# Project Bootstrap

Use this file as the fast start contract when beginning work in any repository.

## Purpose

This file is intentionally short. It is the portable baseline to inspect first before relying on longer prompts, repo-specific docs, or deeper skill files.

## Start-of-work checklist

1. Identify the real task, constraints, and expected behavior change.
2. Inspect the relevant code paths before proposing or making changes.
3. Prefer root-cause fixes over surface patches.
4. Keep the diff focused and consistent with the existing codebase.
5. Validate the changed path with tests, lint, typecheck, or a direct runtime check.
6. If a reusable lesson appears, record it and consider promoting it into an existing skill.

## Default engineering baseline

- Follow existing project conventions when they are sound.
- Prefer readability, maintainability, and explicitness over cleverness.
- Reuse existing utilities and patterns before adding new abstractions.
- Validate inputs and handle expected failure paths.
- Use secure defaults. Do not hardcode secrets or weaken trust boundaries.
- Add or update tests when behavior changes or regressions are plausible.
- State clearly when validation could not be run.

## Promotion rule

When a lesson is reusable across tasks or repos, prefer promoting it into an existing skill before creating a new skill.

Default broad target:

- `skills/master-engineering-standards/`

Common existing targets:

- `skills/testing-patterns/`
- `skills/security-best-practices/`
- `skills/typescript-best-practices/`
- `skills/error-handling-logging/`
- `skills/validation-input-sanitization/`
- `skills/api-design-restful/`

## Source of truth

For reusable guidance and promoted lessons, use this repo as the source of truth:

- `/Users/samra/ai-agent-skills-sync`

## Escalation path

If this file is not enough for the task, inspect these next:

1. `skills/master-engineering-standards/SKILL.md`
2. `README.md`
3. `LEARNING-FLOW.md`
4. The most relevant domain skill under `skills/`