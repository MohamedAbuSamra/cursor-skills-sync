#!/usr/bin/env python3
from __future__ import annotations

import argparse
import re
import sys
from dataclasses import dataclass
from pathlib import Path
from typing import List, Optional


ENTRY_HEADER_RE = re.compile(r"^- \[(?P<ts>[^\]]+)\] (?P<title>.+)$")
KV_RE = re.compile(r"^  - (?P<key>[A-Za-z0-9_]+): (?P<value>.*)$")


@dataclass
class Entry:
    header_index: int
    end_index: int
    timestamp: str
    title: str
    fingerprint: Optional[str]
    source: Optional[str]
    status: Optional[str]
    details: Optional[str]
    review_note: Optional[str]


def entries_path(repo_dir: Path, source: str) -> Path:
    if source == "manual":
        return repo_dir / "learning" / "manual" / "entries.md"
    if source == "generated":
        return repo_dir / "learning" / "generated" / "entries.md"
    raise ValueError(f"Unsupported source: {source}")


def parse_entries(lines: List[str]) -> List[Entry]:
    entries: List[Entry] = []
    i = 0
    while i < len(lines):
        m = ENTRY_HEADER_RE.match(lines[i])
        if not m:
            i += 1
            continue

        header_index = i
        j = i + 1
        while j < len(lines) and not ENTRY_HEADER_RE.match(lines[j]):
            j += 1

        fingerprint = None
        source = None
        status = None
        details = None
        review_note = None

        for k in range(i + 1, j):
            km = KV_RE.match(lines[k])
            if not km:
                continue
            key = km.group("key")
            value = km.group("value")
            if key == "fingerprint":
                fingerprint = value
            elif key == "source":
                source = value
            elif key == "status":
                status = value
            elif key == "details":
                details = value
            elif key == "reviewNote":
                review_note = value

        entries.append(
            Entry(
                header_index=header_index,
                end_index=j,
                timestamp=m.group("ts"),
                title=m.group("title"),
                fingerprint=fingerprint,
                source=source,
                status=status,
                details=details,
                review_note=review_note,
            )
        )
        i = j

    return entries


def load_lines(path: Path) -> List[str]:
    if not path.exists():
        raise FileNotFoundError(f"Missing file: {path}")
    return path.read_text(encoding="utf-8").splitlines()


def save_lines(path: Path, lines: List[str]) -> None:
    path.write_text("\n".join(lines).rstrip() + "\n", encoding="utf-8")


def find_entry_by_fingerprint(entries: List[Entry], fingerprint: str) -> Entry:
    for entry in entries:
        if entry.fingerprint == fingerprint:
            return entry
    raise ValueError(f"Fingerprint not found: {fingerprint}")


def update_or_insert_kv(lines: List[str], entry: Entry, key: str, value: str) -> None:
    target = f"  - {key}: "
    for i in range(entry.header_index + 1, entry.end_index):
        if lines[i].startswith(target):
            lines[i] = f"{target}{value}"
            return

    insert_at = entry.end_index
    lines.insert(insert_at, f"{target}{value}")


def cmd_review(repo_dir: Path, source: str, fingerprint: str, status: str, reason: str) -> None:
    path = entries_path(repo_dir, source)
    lines = load_lines(path)
    entries = parse_entries(lines)
    entry = find_entry_by_fingerprint(entries, fingerprint)

    update_or_insert_kv(lines, entry, "status", status)
    if reason.strip():
        update_or_insert_kv(lines, entry, "reviewNote", reason.strip())

    save_lines(path, lines)
    print(f"Updated {source} learning {fingerprint} -> status={status}")


def safe_slug(value: str) -> str:
    slug = re.sub(r"[^a-zA-Z0-9-]+", "-", value.strip()).strip("-").lower()
    if not slug:
        raise ValueError("Invalid slug.")
    return slug


def skill_dir(repo_dir: Path, target: str, slug: str) -> Path:
    if target == "skills":
        return repo_dir / "cursor" / "skills" / slug
    if target == "skills-cursor":
        return repo_dir / "cursor" / "skills-cursor" / slug
    raise ValueError(f"Unsupported target: {target}")


def create_skill_file(path: Path, slug: str, description: str, title: str, details: str, fingerprint: str) -> None:
    body = f"""---
name: {slug}
description: {description}
---

# {title}

Use this skill when this pattern applies in daily work.

## Guidance

- Keep the implementation concise and consistent with project conventions.
- Apply the pattern intentionally; avoid using it where it does not fit.
- Add examples in this skill over time as usage matures.

## Source

- learning fingerprint: `{fingerprint}`
- original details: {details}
"""
    path.write_text(body, encoding="utf-8")


def cmd_promote(
    repo_dir: Path,
    source: str,
    fingerprint: str,
    slug: str,
    description: str,
    target: str,
) -> None:
    entries_file = entries_path(repo_dir, source)
    lines = load_lines(entries_file)
    entries = parse_entries(lines)
    entry = find_entry_by_fingerprint(entries, fingerprint)

    if entry.status not in {"approved", "promoted"}:
        raise ValueError(
            f"Entry status must be 'approved' before promotion. Current status: {entry.status!r}"
        )

    normalized_slug = safe_slug(slug)
    destination_dir = skill_dir(repo_dir, target, normalized_slug)
    destination_file = destination_dir / "SKILL.md"
    destination_dir.mkdir(parents=True, exist_ok=True)

    if destination_file.exists():
        raise ValueError(f"Skill already exists at {destination_file}")

    final_description = description.strip() or f"Promoted learning: {entry.title}"
    create_skill_file(
        path=destination_file,
        slug=normalized_slug,
        description=final_description,
        title=entry.title,
        details=entry.details or "",
        fingerprint=fingerprint,
    )

    # Re-parse because insertion positions may have shifted due to edits.
    lines = load_lines(entries_file)
    entries = parse_entries(lines)
    entry = find_entry_by_fingerprint(entries, fingerprint)
    update_or_insert_kv(lines, entry, "status", "promoted")
    update_or_insert_kv(lines, entry, "reviewNote", f"Promoted to {destination_file.relative_to(repo_dir)}")
    save_lines(entries_file, lines)

    print(f"Promoted learning to {destination_file.relative_to(repo_dir)}")


def cmd_dashboard(repo_dir: Path, limit: int) -> None:
    manual_file = entries_path(repo_dir, "manual")
    generated_file = entries_path(repo_dir, "generated")

    manual_entries = parse_entries(load_lines(manual_file))
    generated_entries = parse_entries(load_lines(generated_file))

    all_entries = [("manual", e) for e in manual_entries] + [("generated", e) for e in generated_entries]
    pending = [(src, e) for src, e in all_entries if (e.status or "").strip() == "pending"]
    approved = [(src, e) for src, e in all_entries if (e.status or "").strip() == "approved"]
    rejected = [(src, e) for src, e in all_entries if (e.status or "").strip() == "rejected"]
    promoted = [(src, e) for src, e in all_entries if (e.status or "").strip() == "promoted"]

    print("Learning Dashboard")
    print("==================")
    print(f"pending:  {len(pending)}")
    print(f"approved: {len(approved)}")
    print(f"rejected: {len(rejected)}")
    print(f"promoted: {len(promoted)}")
    print("")

    print(f"Top pending (limit {limit})")
    print("---------------------")
    for src, entry in pending[:limit]:
        print(f"- [{src}] {entry.title}")
        print(f"  fingerprint: {entry.fingerprint or 'n/a'}")
        print(f"  details: {entry.details or ''}")


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description="Manage learning entries and skill promotion.")
    parser.add_argument("--repo-dir", default=".", help="Path to repository root")
    sub = parser.add_subparsers(dest="command", required=True)

    review = sub.add_parser("review", help="Review a learning entry by fingerprint")
    review.add_argument("--source", choices=["manual", "generated"], required=True)
    review.add_argument("--fingerprint", required=True)
    review.add_argument("--status", choices=["approved", "rejected", "pending", "promoted"], required=True)
    review.add_argument("--reason", default="", help="Optional review note")

    promote = sub.add_parser("promote", help="Promote approved learning to SKILL.md")
    promote.add_argument("--source", choices=["manual", "generated"], required=True)
    promote.add_argument("--fingerprint", required=True)
    promote.add_argument("--slug", required=True)
    promote.add_argument("--description", required=True)
    promote.add_argument("--target", choices=["skills", "skills-cursor"], default="skills")

    dashboard = sub.add_parser("dashboard", help="Show learning status summary")
    dashboard.add_argument("--limit", type=int, default=10)

    return parser


def main() -> int:
    parser = build_parser()
    args = parser.parse_args()
    repo_dir = Path(args.repo_dir).resolve()

    try:
        if args.command == "review":
            cmd_review(repo_dir, args.source, args.fingerprint, args.status, args.reason)
        elif args.command == "promote":
            cmd_promote(
                repo_dir=repo_dir,
                source=args.source,
                fingerprint=args.fingerprint,
                slug=args.slug,
                description=args.description,
                target=args.target,
            )
        elif args.command == "dashboard":
            cmd_dashboard(repo_dir, args.limit)
        else:
            parser.error("Unsupported command")
    except Exception as exc:
        print(f"ERROR: {exc}", file=sys.stderr)
        return 1

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
