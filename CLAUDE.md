# Claude Code — ai-agent-skills-sync

This is the **ai-agent-skills-sync** repo: the source of truth for reusable AI assistant skills and the learning pipeline that feeds them.

## Repo layout

- `skills/` — cross-agent engineering skills, used by all AI agents
- `cursor/skills-cursor/` — Cursor-specific workflow skills
- `codex/skills/` — Codex/OpenAI skills
- `claude/skills/` — Claude Code-specific skills
- `claude/CLAUDE.md` — tracked source for `~/.claude/CLAUDE.md`
- `learning/manual/` and `learning/generated/` — draft entries; promote to skills once validated
- `scripts/learningManager.py` — core CLI: review, promote, promote-into-existing, dashboard
- `scripts/learningUiServer.py` — local HTTP server for the web dashboard
- `ui/` — vanilla JS frontend (inline in `learning-dashboard.html`; `ui/js/` modules are in-progress migration)
- `templates/` — portable bootstrap files stamped into other repos via `scripts/install-repo-bootstrap.sh`

## Grow-together contract

This system is a shared learning loop. When a reusable pattern emerges from our work:

1. Suggest recording it: `./record-learning.sh generated "title" "details and why it helped"`
2. Reference existing skills before introducing new patterns — check `skills/` first
3. Suggest which skill it belongs in using the same taxonomy as `suggest_promotion` in `learningUiServer.py`
4. Respect the pipeline: `pending → approved → promoted` — don't skip review

At the end of any substantial session in this or any other repo, note patterns worth capturing.

## Skills to apply by default

| Skill | Apply when |
|---|---|
| `master-engineering-standards` | Always |
| `always-apply-standards` | Always |
| `modern-development-practices` | Always |
| `testing-patterns` | Writing or changing behavior |
| `security-best-practices` | Auth, input, secrets |
| `typescript-best-practices` | TypeScript files |
| `async-concurrency` | async/await, promises, queues, background jobs |
| `error-handling-logging` | Error paths, structured logging |
| `validation-input-sanitization` | User input, API boundaries |

Full skill list: `skills/` (all agents), `cursor/skills-cursor/` (Cursor), `claude/skills/` (Claude Code)

## Common commands

```bash
./sync.sh to-local                                                   # install skills to ~/.cursor/skills
./sync.sh to-repo                                                    # pull local edits back into repo
./record-learning.sh generated "title" "details"                    # log an AI-suggested learning
./record-learning.sh manual "title" "details"                       # log your own decision
./scripts/run-learning-ui.sh 8765                                   # open dashboard at http://127.0.0.1:8765
./scripts/review-learning.sh generated <fp> approved "reason"       # approve an entry
./scripts/promote-learning.sh generated <fp> my-slug "desc" shared  # promote to a new shared skill
./scripts/promote-learning-into-existing.sh generated <fp> master-engineering-standards shared
./scripts/install-repo-bootstrap.sh /path/to/other-repo             # stamp bootstrap into another repo
```

## Conventions

- Skills live in `<slug>/SKILL.md`. Validate with `./scripts/validateSkills.sh`.
- Fingerprint = sha256 of `source|title|details` — duplicate detection is automatic.
- Prefer updating an existing skill over creating a new one.
- camelCase unless the repo convention clearly differs.
- Python backend, vanilla JS frontend, bash+PowerShell scripts for cross-platform support.

## Escalation path

When this file is not enough: `PROJECT-BOOTSTRAP.md` → `skills/master-engineering-standards/SKILL.md` → `README.md` → `LEARNING-FLOW.md`
