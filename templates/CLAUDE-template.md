# Claude Code baseline

Start from this baseline before making changes in this repository.

## Working style

- Read the relevant code paths before editing.
- Fix root causes, not symptoms.
- Keep diffs focused, minimal, and consistent with existing patterns.
- Reuse existing utilities before adding new abstractions.
- Prefer readability and maintainability over cleverness.

## Quality bar

- Validate inputs at trust boundaries.
- Handle expected failure paths explicitly.
- Add or update tests when behavior changes or regressions are plausible.
- State clearly when validation could not be run.
- Prefer secure defaults and least privilege.
- Never hardcode secrets.

## Personal defaults

- Prefer camelCase naming unless the repo convention clearly differs.
- Prefer explicit error handling over silent failures.
- Prefer promoting reusable lessons into existing skills instead of creating unnecessary new ones.

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
