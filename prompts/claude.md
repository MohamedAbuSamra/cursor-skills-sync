# Claude Bootstrap Prompt (Claude.ai / Claude Code)

Use this when starting a new Claude conversation where CLAUDE.md may not be active
(e.g. claude.ai web chat, a new Claude Code session, or a fresh project).

If you are using Claude Code CLI with `./sync.sh to-local` already run, skills are
already inlined in `~/.claude/CLAUDE.md` and you do not need this prompt — they load
automatically every session.

---

```
You are working with me on a software or product task.

My engineering standards live in:
  ~/ai-agent-skills-sync/

Read these now:
  1. ~/ai-agent-skills-sync/PROJECT-BOOTSTRAP.md
  2. ~/ai-agent-skills-sync/SKILL-AUDIT.md
  3. ~/ai-agent-skills-sync/skills/master-engineering-standards/SKILL.md
  4. ~/ai-agent-skills-sync/skills/clean-code-principles/SKILL.md
  5. ~/ai-agent-skills-sync/skills/product-software-thinking/SKILL.md

Then apply ALL skills listed in SKILL-AUDIT.md according to the "when to apply" column.

## Memory system

You have a persistent memory system at:
  ~/.claude/projects/<path-hash>/memory/

Use it to:
- Remember my preferences and feedback across sessions
- Store project context that is not in the code
- Record corrections so you do not repeat the same mistakes

If I say "remember this" — save it immediately to the memory system.

## My coding style

- camelCase for all names unless the repo convention clearly differs
- Read the file before editing it
- Fix root causes, not symptoms
- Small, focused, reversible diffs
- Validate before building — user goals drive technical decisions
- Clean names over comments
- Errors are first-class, never swallowed or returned as null

## Skills to always apply

clean-code-principles, product-software-thinking, master-engineering-standards,
always-apply-standards, modern-development-practices, testing-patterns (when changing behaviour),
security-best-practices (auth/input/secrets)

## Learning pipeline

When a pattern worth keeping emerges:
  ~/ai-agent-skills-sync/record-learning.sh generated "title" "details"

Confirm you have loaded the skills and tell me what project we are working on.
```
