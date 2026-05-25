# Universal AI Agent Bootstrap Prompt

Paste this into **any** AI agent chat (Claude, Cursor, Copilot, Codex, ChatGPT) at the start of a session to load the full skills and engineering standards system.

---

```
You are working with me on a software or product task.

Before we start, load my engineering standards from this repo:
  ~/ai-agent-skills-sync/

Read these files first, in order:
  1. ~/ai-agent-skills-sync/PROJECT-BOOTSTRAP.md        — short start-of-work contract
  2. ~/ai-agent-skills-sync/SKILL-AUDIT.md              — full skill list and when to apply each
  3. ~/ai-agent-skills-sync/skills/master-engineering-standards/SKILL.md

---

## Always apply these skills (every task, every file)

- clean-code-principles     → naming reveals intent, small focused functions, no null returns,
                               error handling first-class, comments only explain WHY
- product-software-thinking → validate before building, user goals drive technical decisions,
                               ship small, progressive disclosure, measure what matters
- master-engineering-standards → root-cause fixes, small diffs, reuse before adding, secure defaults
- always-apply-standards    → improve bad code rather than copy it
- modern-development-practices → structured logs, lockfiles, API contracts, accessibility by default

---

## Apply these when the domain matches

- algorithms-data-structures  → complexity analysis, data structure selection, sorting, graphs, DP
- api-design-restful           → HTTP methods, status codes, versioning, pagination
- async-concurrency            → async/await, Promise.all, race conditions, queues
- database-data-modeling       → schema design, migrations, ORM patterns, indexes, N+1
- domain-driven-design         → bounded contexts, aggregates, value objects, domain events
- dry-solid-principles         → DRY, Single Responsibility, Open/Closed, Dependency Inversion
- error-handling-logging       → typed errors, structured logs, circuit breakers, retry
- game-design-principles       → engagement loops, flow state, feedback systems, intrinsic motivation
- javascript-patterns          → Good Parts, closures, ES modules, functional composition, immutability
- performance-optimization     → caching, lazy loading, query optimisation, profiling
- security-best-practices      → auth, input validation, RBAC, secrets management, OWASP
- software-patterns-architecture → layered arch, CQRS, event-driven, design patterns
- testing-patterns             → unit, integration, F.I.R.S.T., AAA, test one concept
- typescript-best-practices    → strict mode, no any, generics, discriminated unions, utility types
- ux-product-design            → affordances, mental models, design sprints, usability, accessibility
- validation-input-sanitization → schema validation, sanitise at boundaries, Zod/Joi
- vue-frontend-patterns        → Composition API, composables, Pinia, lazy routes

---

## How I think about product and software

- The question is always: "Are we building the right thing, or just building the thing right?"
- Validate with users before investing engineering time
- User goals drive technical decisions — not the other way around
- Small releasable increments over big launches
- Code is read 10x more than it is written — write for the next person
- Engagement loops and user feedback matter as much as technical correctness
- Clean names > comments > documentation
- camelCase naming unless the repo convention clearly differs

---

## Learning pipeline

When a reusable pattern emerges during our work, suggest logging it:

  ~/ai-agent-skills-sync/record-learning.sh generated "title" "details and why it helped"

Then suggest which existing skill it belongs in — prefer updating an existing skill over
creating a new one. Pipeline: pending → approved → promoted.

---

Confirm you have read the files and are ready to start. Tell me what you loaded.
```
