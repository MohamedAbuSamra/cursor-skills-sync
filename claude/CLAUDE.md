# Claude Code — global rules

These rules apply in every codebase, every session, on every machine.

## Source of truth

All reusable skills, learning entries, and engineering standards live in:

```
~/ai-agent-skills-sync
```

This repo is installed on every device and shared across Cursor, Codex, GitHub Copilot, and Claude Code.
Before making decisions, check the relevant skill file there. After a session, suggest logging reusable patterns back into it.

Key references (in order):
1. `~/ai-agent-skills-sync/PROJECT-BOOTSTRAP.md` — short portable baseline, read this first
2. `~/ai-agent-skills-sync/skills/master-engineering-standards/SKILL.md` — default engineering standard
3. `~/ai-agent-skills-sync/README.md` — full system overview
4. `~/ai-agent-skills-sync/LEARNING-FLOW.md` — how to capture and promote learnings

## Engineering defaults

- Read the relevant code before editing anything.
- Fix root causes, not symptoms.
- Keep diffs small, focused, and consistent with the existing codebase.
- Reuse existing utilities and abstractions before adding new ones.
- Prefer readability and maintainability over cleverness.
- Validate inputs at trust boundaries. Handle expected failures explicitly.
- Prefer secure defaults. Never hardcode secrets.
- Add or update tests when behavior changes or regressions are plausible.
- State clearly when validation could not be run.
- camelCase naming unless the repo convention clearly differs.

## Skills to apply by default

| Skill | Apply when |
|---|---|
| `master-engineering-standards` | Always |
| `always-apply-standards` | Always |
| `modern-development-practices` | Always |
| `clean-code-principles` | Always — naming, focused functions, error handling, no null returns |
| `product-software-thinking` | Always — validate before building, user goals drive tech decisions |
| `testing-patterns` | Writing or changing behavior |
| `security-best-practices` | Auth, input, secrets |
| `typescript-best-practices` | TypeScript files |
| `async-concurrency` | async/await, promises, queues |
| `error-handling-logging` | Error paths, structured logging |
| `validation-input-sanitization` | User input, API boundaries |

## Conditional skills (apply when domain matches)

| Skill | Apply when |
|---|---|
| `algorithms-data-structures` | Complexity analysis, data structure choice, sorting, graphs, DP |
| `api-design-restful` | HTTP API design, endpoints, status codes, versioning |
| `database-data-modeling` | Schema design, migrations, ORM, indexes, N+1 queries |
| `domain-driven-design` | Service boundaries, bounded contexts, domain modeling |
| `dry-solid-principles` | Refactoring, duplication, design quality |
| `game-design-principles` | Engagement loops, feedback systems, user motivation |
| `javascript-patterns` | JavaScript files — closures, modules, functional patterns |
| `performance-optimization` | Caching, lazy loading, query performance |
| `software-patterns-architecture` | Architecture decisions, design patterns |
| `ux-product-design` | UI/UX decisions, usability, design sprints |

Full shared skill list: `~/ai-agent-skills-sync/skills/`
Claude-specific skills: `~/ai-agent-skills-sync/claude/skills/`

## Grow-together learning contract

When a reusable pattern emerges from our work together:

1. Suggest recording it: `~/ai-agent-skills-sync/record-learning.sh generated "title" "details and why it helped"`
2. Suggest which existing skill it belongs in — prefer updating an existing skill over creating a new one
3. Common promotion targets: `master-engineering-standards`, `clean-code-principles`, `product-software-thinking`, `testing-patterns`, `security-best-practices`, `typescript-best-practices`, `error-handling-logging`, `async-concurrency`
4. The pipeline is: `pending → approved → promoted` — don't skip review

## Per-repo override

If the current repo has a local `CLAUDE.md`, follow it. If it has stronger conventions, follow those and record the difference as a learning entry.
