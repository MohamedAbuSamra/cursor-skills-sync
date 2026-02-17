#!/usr/bin/env python3
from __future__ import annotations

import argparse
import json
from http import HTTPStatus
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path
import re
from datetime import datetime, UTC
from urllib.parse import parse_qs, urlparse

from learningManager import cmd_promote, cmd_review, entries_path, load_lines, parse_entries


FRONTMATTER_RE = re.compile(r"^---\n(.*?)\n---\n", re.DOTALL)
NAME_RE = re.compile(r"^name:\s*(.+)$", re.MULTILINE)
DESCRIPTION_RE = re.compile(r"^description:\s*(.+)$", re.MULTILINE)


def build_dashboard(repo_dir: Path, limit: int) -> dict:
    manual_entries = parse_entries(load_lines(entries_path(repo_dir, "manual")))
    generated_entries = parse_entries(load_lines(entries_path(repo_dir, "generated")))

    all_entries = [{"source": "manual", "entry": e} for e in manual_entries] + [
        {"source": "generated", "entry": e} for e in generated_entries
    ]

    pending = [x for x in all_entries if (x["entry"].status or "").strip() == "pending"]
    approved = [x for x in all_entries if (x["entry"].status or "").strip() == "approved"]
    rejected = [x for x in all_entries if (x["entry"].status or "").strip() == "rejected"]
    promoted = [x for x in all_entries if (x["entry"].status or "").strip() == "promoted"]

    def serialize(items: list[dict], item_limit: int | None = None) -> list[dict]:
        records = items if item_limit is None else items[:item_limit]
        return [
            {
                "source": x["source"],
                "timestamp": x["entry"].timestamp,
                "title": x["entry"].title,
                "fingerprint": x["entry"].fingerprint,
                "status": x["entry"].status,
                "details": x["entry"].details,
                "reviewNote": x["entry"].review_note,
            }
            for x in records
        ]

    return {
        "counts": {
            "pending": len(pending),
            "approved": len(approved),
            "rejected": len(rejected),
            "promoted": len(promoted),
        },
        "pending": serialize(pending, limit),
        "all": serialize(all_entries),
    }


def parse_skill_frontmatter(skill_text: str) -> dict:
    front = {"name": "", "description": ""}
    match = FRONTMATTER_RE.search(skill_text)
    if not match:
        return front

    block = match.group(1)
    name_match = NAME_RE.search(block)
    desc_match = DESCRIPTION_RE.search(block)
    if name_match:
        front["name"] = name_match.group(1).strip()
    if desc_match:
        front["description"] = desc_match.group(1).strip()
    return front


def build_skills(repo_dir: Path) -> dict:
    roots = [
        ("cursor", repo_dir / "cursor" / "skills"),
        ("cursor-custom", repo_dir / "cursor" / "skills-cursor"),
        ("codex", repo_dir / "codex" / "skills"),
    ]
    skills: list[dict] = []

    for source, root in roots:
        if not root.exists():
            continue
        for skill_file in sorted(root.rglob("SKILL.md")):
            text = skill_file.read_text(encoding="utf-8", errors="replace")
            front = parse_skill_frontmatter(text)
            rel = skill_file.relative_to(repo_dir).as_posix()
            skills.append(
                {
                    "source": source,
                    "name": front["name"] or skill_file.parent.name,
                    "description": front["description"] or "No description",
                    "path": rel,
                }
            )

    return {
        "total": len(skills),
        "items": skills,
    }


def logs_file_path(repo_dir: Path) -> Path:
    return repo_dir / "learning" / "action-logs.jsonl"


def read_logs(repo_dir: Path, limit: int) -> list[dict]:
    path = logs_file_path(repo_dir)
    if not path.exists():
        return []
    lines = path.read_text(encoding="utf-8", errors="replace").splitlines()
    records: list[dict] = []
    for line in lines:
        if not line.strip():
            continue
        try:
            records.append(json.loads(line))
        except json.JSONDecodeError:
            continue
    return list(reversed(records[-limit:]))


def append_log(repo_dir: Path, payload: dict) -> None:
    path = logs_file_path(repo_dir)
    path.parent.mkdir(parents=True, exist_ok=True)
    record = {
        "timestamp": datetime.now(UTC).isoformat(),
        "type": payload.get("type", "event"),
        "title": payload.get("title", ""),
        "source": payload.get("source", ""),
        "status": payload.get("status", ""),
        "reason": payload.get("reason", ""),
        "skillPath": payload.get("skillPath", ""),
    }
    with path.open("a", encoding="utf-8") as handle:
        handle.write(json.dumps(record, ensure_ascii=True) + "\n")


def read_skill_file(repo_dir: Path, rel_path: str) -> dict:
    candidate = (repo_dir / rel_path).resolve()
    if repo_dir.resolve() not in candidate.parents and candidate != repo_dir.resolve():
        raise ValueError("Invalid path.")
    if candidate.name != "SKILL.md":
        raise ValueError("Only SKILL.md paths are allowed.")
    if not candidate.exists():
        raise FileNotFoundError(f"Skill file not found: {rel_path}")
    content = candidate.read_text(encoding="utf-8", errors="replace")
    return {"path": rel_path, "content": content}


class LearningUiHandler(BaseHTTPRequestHandler):
    repo_dir: Path
    html_path: Path

    def _send_json(self, payload: dict, status: int = HTTPStatus.OK) -> None:
        body = json.dumps(payload).encode("utf-8")
        self.send_response(status)
        self.send_header("Content-Type", "application/json; charset=utf-8")
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)

    def _send_html(self, html_text: str) -> None:
        body = html_text.encode("utf-8")
        self.send_response(HTTPStatus.OK)
        self.send_header("Content-Type", "text/html; charset=utf-8")
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)

    def _read_json(self) -> dict:
        length = int(self.headers.get("Content-Length", "0"))
        raw = self.rfile.read(length) if length else b"{}"
        return json.loads(raw.decode("utf-8"))

    def do_GET(self) -> None:  # noqa: N802
        parsed = urlparse(self.path)
        if parsed.path in {"/", "/index.html", "/learning-dashboard.html"}:
            self._send_html(self.html_path.read_text(encoding="utf-8"))
            return

        if parsed.path == "/api/dashboard":
            qs = parse_qs(parsed.query)
            limit = int(qs.get("limit", ["20"])[0])
            data = build_dashboard(self.repo_dir, limit)
            self._send_json({"ok": True, "data": data})
            return
        if parsed.path == "/api/skills":
            data = build_skills(self.repo_dir)
            self._send_json({"ok": True, "data": data})
            return
        if parsed.path == "/api/skill":
            qs = parse_qs(parsed.query)
            rel_path = qs.get("path", [""])[0]
            data = read_skill_file(self.repo_dir, rel_path)
            self._send_json({"ok": True, "data": data})
            return
        if parsed.path == "/api/logs":
            qs = parse_qs(parsed.query)
            limit = int(qs.get("limit", ["100"])[0])
            data = read_logs(self.repo_dir, limit)
            self._send_json({"ok": True, "data": data})
            return

        # Static files under /css/ and /js/ from ui/
        if parsed.path.startswith("/css/") or parsed.path.startswith("/js/"):
            safe_path = parsed.path.lstrip("/").replace("..", "")
            file_path = (self.repo_dir / "ui" / safe_path).resolve()
            ui_root = (self.repo_dir / "ui").resolve()
            try:
                file_path.relative_to(ui_root)
            except ValueError:
                file_path = None
            if file_path and file_path.is_file():
                suffix = file_path.suffix.lower()
                ctype = "text/css" if suffix == ".css" else "application/javascript"
                body = file_path.read_bytes()
                self.send_response(HTTPStatus.OK)
                self.send_header("Content-Type", f"{ctype}; charset=utf-8")
                self.send_header("Content-Length", str(len(body)))
                self.end_headers()
                self.wfile.write(body)
                return

        self._send_json({"ok": False, "error": "Not found"}, status=HTTPStatus.NOT_FOUND)

    def do_POST(self) -> None:  # noqa: N802
        parsed = urlparse(self.path)
        try:
            payload = self._read_json()
            if parsed.path == "/api/review":
                cmd_review(
                    repo_dir=self.repo_dir,
                    source=payload["source"],
                    fingerprint=payload["fingerprint"],
                    status=payload["status"],
                    reason=payload.get("reason", ""),
                )
                self._send_json({"ok": True})
                return

            if parsed.path == "/api/promote":
                cmd_promote(
                    repo_dir=self.repo_dir,
                    source=payload["source"],
                    fingerprint=payload["fingerprint"],
                    slug=payload["slug"],
                    description=payload["description"],
                    target=payload.get("target", "skills"),
                )
                self._send_json({"ok": True})
                return
            if parsed.path == "/api/log":
                append_log(self.repo_dir, payload)
                self._send_json({"ok": True})
                return
        except Exception as exc:  # noqa: BLE001
            self._send_json({"ok": False, "error": str(exc)}, status=HTTPStatus.BAD_REQUEST)
            return

        self._send_json({"ok": False, "error": "Not found"}, status=HTTPStatus.NOT_FOUND)

    def log_message(self, fmt: str, *args) -> None:  # noqa: A003
        return


def main() -> int:
    parser = argparse.ArgumentParser(description="Serve local learning dashboard UI.")
    parser.add_argument("--repo-dir", default=".", help="Repository root path")
    parser.add_argument("--port", type=int, default=8765, help="Port to serve on")
    args = parser.parse_args()

    repo_dir = Path(args.repo_dir).resolve()
    html_path = repo_dir / "ui" / "learning-dashboard.html"
    if not html_path.exists():
        raise FileNotFoundError(f"UI file not found: {html_path}")

    LearningUiHandler.repo_dir = repo_dir
    LearningUiHandler.html_path = html_path

    server = ThreadingHTTPServer(("127.0.0.1", args.port), LearningUiHandler)
    print(f"Learning UI running at http://127.0.0.1:{args.port}")
    print("Press Ctrl+C to stop.")
    try:
        server.serve_forever()
    except KeyboardInterrupt:
        pass
    finally:
        server.server_close()
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
