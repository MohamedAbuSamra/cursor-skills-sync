# Claude Code baseline

Start from this baseline before making changes in this repository.

## Always-apply standards

These apply to every task, every file, every request:

**clean-code-principles** — names reveal intent, functions do one thing, no null returns,
errors are first-class, comments explain WHY only, no commented-out code.

**product-software-thinking** — validate before building, user goals drive technical decisions,
ship the smallest useful thing, measure what matters. Ask: "Are we building the right thing?"

**master-engineering-standards** — root-cause fixes, small focused diffs, reuse before adding,
secure defaults, validate at boundaries.

## Working style

- Read the relevant code paths before editing.
- Fix root causes, not symptoms.
- Keep diffs focused, minimal, and consistent with existing patterns.
- Reuse existing utilities before adding new abstractions.
- Prefer readability and maintainability over cleverness.
- camelCase naming unless the repo convention clearly differs.
- Explicit error handling — never silent failures, never return null.

## Apply when the domain matches

- `algorithms-data-structures` → complexity, data structure selection, sorting, graphs, DP
- `api-design-restful`         → HTTP API design, status codes, versioning, pagination
- `async-concurrency`          → async/await, Promise.all, race conditions, queues
- `database-data-modeling`     → schema design, migrations, ORM, indexes
- `domain-driven-design`       → bounded contexts, aggregates, domain events
- `dry-solid-principles`       → refactoring, duplication, SRP, DIP
- `error-handling-logging`     → typed errors, structured logs, retry, circuit breaker
- `game-design-principles`     → engagement loops, feedback systems, user motivation
- `javascript-patterns`        → closures, ES modules, functional composition, immutability
- `performance-optimization`   → caching, lazy loading, query performance
- `security-best-practices`    → auth, input validation, RBAC, secrets
- `software-patterns-architecture` → design patterns, layered arch, CQRS
- `testing-patterns`           → unit/integration tests, F.I.R.S.T., AAA
- `typescript-best-practices`  → strict mode, no any, generics, discriminated unions
- `ux-product-design`          → affordances, mental models, design sprints, usability
- `validation-input-sanitization` → schema validation, sanitise at boundaries

## Quality bar

- Validate inputs at trust boundaries.
- Handle expected failure paths explicitly.
- Add or update tests when behavior changes or regressions are plausible.
- State clearly when validation could not be run.
- Prefer secure defaults and least privilege.
- Never hardcode secrets.

## Grow-together learning contract

When a reusable pattern emerges from our work, suggest recording it:

```bash
~/ai-agent-skills-sync/record-learning.sh generated "title" "what worked and why"
```

Prefer targeting an existing skill over creating a new one. Common targets:

- `master-engineering-standards` — broad engineering quality
- `testing-patterns` — test strategy and structure
- `security-best-practices` — auth, authorization, secrets
- `typescript-best-practices` — strict typing patterns
- `error-handling-logging` — error models, structured logs
- `validation-input-sanitization` — schema validation, sanitization
- `async-concurrency` — async/await, promises, queues
- `api-design-restful` — HTTP API design

Reference point for all skills and the full pipeline:

- ~/ai-agent-skills-sync/skills/master-engineering-standards/SKILL.md
- ~/ai-agent-skills-sync/PROJECT-BOOTSTRAP.md

## Repo override

If this repository has stronger local conventions, follow them and record the difference as a learning entry.
