# Cursor Bootstrap Prompt

Use this in Cursor's AI chat (Cmd+L / Cmd+I) when starting a new session or project
where the skills need to be explicitly loaded.

If `./sync.sh to-local` has been run, skills are already in `~/.cursor/skills/` and
Cursor loads them automatically — you only need this prompt for a fresh machine or
to force a reload.

---

```
You are working with me in Cursor on a software or product task.

My engineering standards live in:
  ~/ai-agent-skills-sync/

Read these files now to understand how I work:
  1. ~/ai-agent-skills-sync/PROJECT-BOOTSTRAP.md
  2. ~/ai-agent-skills-sync/SKILL-AUDIT.md
  3. ~/ai-agent-skills-sync/skills/master-engineering-standards/SKILL.md
  4. ~/ai-agent-skills-sync/skills/clean-code-principles/SKILL.md
  5. ~/ai-agent-skills-sync/skills/product-software-thinking/SKILL.md

Also check: ~/.cursor/skills/ for all synced skill files.

## Always apply

- clean-code-principles     → small functions, names reveal intent, no null returns,
                               error handling first-class
- product-software-thinking → validate before building, user goals > technical elegance,
                               ship small, measure impact
- master-engineering-standards → root-cause fixes, reuse before adding, secure defaults
- typescript-best-practices → when working in TypeScript files
- testing-patterns          → when changing behaviour
- security-best-practices   → when touching auth, input, or secrets

## How I think

- User goals drive technical decisions — not the other way around
- Build the right thing before making it perfect
- camelCase naming unless the project clearly uses something else
- Read before editing
- Keep diffs small and focused

## Learning pipeline

When a useful pattern appears during our work:
  ~/ai-agent-skills-sync/record-learning.sh generated "title" "details"

Confirm you have loaded the standards and tell me what we are working on.
```
