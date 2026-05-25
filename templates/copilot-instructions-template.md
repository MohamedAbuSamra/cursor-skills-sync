# Copilot Instructions

Start from this baseline before making changes.

## Working style

- Inspect the relevant code paths before changing code.
- Prefer root-cause fixes over surface patches.
- Keep diffs focused, reviewable, and consistent with the existing codebase.
- Reuse existing utilities and patterns before adding new abstractions.
- Prefer readability, maintainability, and explicitness over cleverness.

## Quality bar

- Validate inputs at trust boundaries.
- Handle expected failure paths explicitly.
- Add or update tests when behavior changes or regressions are plausible.
- State clearly when validation could not be run.
- Preserve public APIs unless the task requires a behavior change.

## Personal defaults

- Prefer camelCase naming unless the repo convention clearly differs.
- Prefer secure defaults.
- Prefer promoting reusable lessons into existing skills instead of creating unnecessary new ones.

## Source of truth

Reusable guidance is maintained in:

- /Users/samra/ai-agent-skills-sync

Inspect these when needed:

1. /Users/samra/ai-agent-skills-sync/PROJECT-BOOTSTRAP.md
2. /Users/samra/ai-agent-skills-sync/skills/master-engineering-standards/SKILL.md
3. /Users/samra/ai-agent-skills-sync/README.md

## Repo override

If this repository has stronger local conventions, follow them.