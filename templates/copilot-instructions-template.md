# Copilot Instructions

Start from this baseline before making changes.

## Always-apply standards

**clean-code-principles** — names reveal intent, functions do one thing, no null returns,
errors are first-class, comments explain WHY only, no commented-out code.

**product-software-thinking** — validate before building, user goals drive technical decisions,
ship the smallest useful thing, measure what matters.

**master-engineering-standards** — root-cause fixes, small focused diffs, reuse before adding,
secure defaults, validate inputs at system boundaries.

## Working style

- Inspect the relevant code paths before changing code.
- Prefer root-cause fixes over surface patches.
- Keep diffs focused, reviewable, and consistent with the existing codebase.
- Reuse existing utilities and patterns before adding new abstractions.
- Prefer readability, maintainability, and explicitness over cleverness.
- camelCase naming unless the repo convention clearly differs.
- Explicit error handling — never silent failures.

## Apply when the domain matches

- `algorithms-data-structures`     → complexity, data structures, sorting, graphs, DP
- `api-design-restful`             → HTTP API design, status codes, versioning
- `async-concurrency`              → async/await, queues, race conditions
- `database-data-modeling`         → schema, migrations, ORM, indexes
- `domain-driven-design`           → bounded contexts, aggregates, domain events
- `dry-solid-principles`           → refactoring, DRY, SRP, DIP
- `error-handling-logging`         → typed errors, structured logs, retry
- `javascript-patterns`            → closures, modules, functional JS, immutability
- `performance-optimization`       → caching, lazy loading, query performance
- `security-best-practices`        → auth, input, RBAC, secrets
- `testing-patterns`               → unit/integration, F.I.R.S.T., one concept per test
- `typescript-best-practices`      → strict mode, no any, generics
- `ux-product-design`              → affordances, usability, design sprints
- `validation-input-sanitization`  → schema validation, sanitise at boundaries

## Quality bar

- Validate inputs at trust boundaries.
- Handle expected failure paths explicitly.
- Add or update tests when behavior changes or regressions are plausible.
- State clearly when validation could not be run.
- Preserve public APIs unless the task requires a behavior change.

## Source of truth

Reusable guidance is maintained in:

- /Users/samra/ai-agent-skills-sync

Inspect these when needed:

1. /Users/samra/ai-agent-skills-sync/PROJECT-BOOTSTRAP.md
2. /Users/samra/ai-agent-skills-sync/skills/master-engineering-standards/SKILL.md
3. /Users/samra/ai-agent-skills-sync/README.md

## Repo override

If this repository has stronger local conventions, follow them.