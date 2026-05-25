# AGENTS.md

This repository should be worked on using the following baseline.

## Always-apply standards

**clean-code-principles** — names reveal intent, functions do one thing, no null returns,
errors are first-class, comments explain WHY only, no commented-out code.

**product-software-thinking** — validate before building, user goals drive technical decisions,
ship the smallest useful thing, measure what matters.

**master-engineering-standards** — root-cause fixes, small focused diffs, reuse before adding,
secure defaults, validate inputs at system boundaries.

## Default behavior

- Read the relevant code before editing.
- Fix the root cause when practical.
- Keep changes minimal and aligned with existing patterns.
- Preserve unrelated local changes unless the task explicitly requires touching them.
- Validate the changed path with tests, lint, typecheck, or direct runtime checks.
- Call out risks, assumptions, and validation gaps clearly.
- camelCase naming unless the repo already uses a different convention.
- Explicit, maintainable code over clever shortcuts.
- Secure defaults and clear error handling — never return null, never swallow errors.
- Prefer updating an existing skill or pattern before inventing a new one.

## Apply when the domain matches

- `algorithms-data-structures`     → complexity, data structures, sorting, graphs, DP
- `api-design-restful`             → HTTP API design, status codes, versioning
- `async-concurrency`              → async/await, queues, race conditions
- `database-data-modeling`         → schema, migrations, ORM, indexes
- `domain-driven-design`           → bounded contexts, aggregates, domain events
- `error-handling-logging`         → typed errors, structured logs, retry
- `javascript-patterns`            → closures, modules, functional JS, immutability
- `security-best-practices`        → auth, input, RBAC, secrets
- `testing-patterns`               → unit/integration, F.I.R.S.T., AAA
- `typescript-best-practices`      → strict mode, no any, generics
- `ux-product-design`              → affordances, usability, design sprints

## Reusable lessons

When a lesson is reusable across tasks or repos, record it in:

- /Users/samra/ai-agent-skills-sync

Prefer promoting it into an existing skill, especially:

- /Users/samra/ai-agent-skills-sync/skills/master-engineering-standards/SKILL.md

## Bootstrap reference

Inspect this first when you need the short baseline:

- /Users/samra/ai-agent-skills-sync/PROJECT-BOOTSTRAP.md

Then escalate to:

1. /Users/samra/ai-agent-skills-sync/SKILL-AUDIT.md
2. /Users/samra/ai-agent-skills-sync/skills/master-engineering-standards/SKILL.md
3. The most relevant domain skill under /Users/samra/ai-agent-skills-sync/skills/
