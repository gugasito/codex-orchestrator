---
name: codex-orchestrator
description: Coordinate software development with the selected primary model and focused Luna subagents, adapting delegation to complexity and risk while preserving project architecture and UX. Use for the Sol/Luna development workflow or an explicit codex-orchestrator request.
---

# Adaptive Codex Orchestrator

The selected primary model owns requirements, technical decisions, integration,
and acceptance. Recommend GPT-6.1 Sol for this role, but never switch the user's
active model or claim a skill can change its reasoning setting. The controller
may inspect code, edit, run checks, and resolve integration directly. Delegate
bounded implementation to GPT-6 Luna when it saves expected cost or time.

## Establish the task

Read applicable AGENTS.md instructions and inspect the relevant implementation
and existing tests. Reuse evidence already gathered. Delegate broad or noisy
exploration to `luna_explorer`; do not create an explorer for known paths.
Express the intended behavior, acceptance examples, constraints, and relevant
contracts briefly. Ask only about uncertainty that materially changes the
outcome and cannot be resolved from the project. Continue independent work.
Read [project-context.md](references/project-context.md) when architecture, UX,
or persistent project knowledge matters. Load only the relevant domain section
and linked project evidence, not the entire reference library.

## Choose the smallest useful workflow

| Route | Trigger | Execution and verification |
| --- | --- | --- |
| Fast | Localized, understood, low-risk change | Controller directly or one Luna owner; focused verification by owner, no mandatory explorer or QA node |
| Normal | Feature with separable implementation scopes | Controller defines contracts; one or two domain workers, parallel only when independent; controller integrates and checks acceptance |
| Critical | Authorization, sensitive data integrity, destructive migration, or consequential cross-module design | Controller reasons through invariants; bounded implementation; independent review of the material risk and integration evidence |

These are routing defaults, not fixed ceremonies. Estimate whether delegation
saves more work than its context and handoff overhead. Preserve the user's
explicit model, effort, cost, or delegation constraints. No recurring observer,
background work, external service, or ECC dependency is required.

## Model and role selection

Read [routing.md](references/routing.md) when selecting specialists, escalating,
or encountering unavailable roles. Domain responsibility is separate from model.
Use Luna low for mechanical work or focused discovery, medium for ordinary
implementation, and high for concrete reasoning or risk. Use xhigh/max only for
a justified hard problem or explicit request, not merely a domain label.
Named agents have fixed model/effort settings; choose a suitable role or an
explicit-model spawn when supported instead of claiming to override the role.
Never accidentally inherit the primary model for a Luna assignment.

The controller can handle difficult work itself. `sol_specialist` and
`sol_reviewer` are optional GPT-6.1 Sol roles; `astra_specialist` is reserved for
exceptionally difficult reasoning with a concrete escalation reason. Do not
escalate an environment failure to a more expensive model.
If delegation is unavailable, continue directly when allowed and report the
limitation; if the user requires a strict model split, explain the blocker.
Do not claim a configured model is callable until the runtime supports it.

## Delegate with a compact contract

Include objective, owned paths/read scope, relevant architecture/UX references,
acceptance criteria, required verification, dependencies, and a stop condition.
Workers are not alone: preserve other edits, report ownership overlaps, and do
not expand scope or spawn descendants. Prefer context-free forks with only the
needed evidence. Reuse an existing worker for a related correction.

Start with one or two workers. Use at most three simultaneous subagents and
obey lower runtime limits, accounting for the primary if the runtime counts it.
One owner per writable path. Finalize shared contracts before consumers start;
parallel frontend/backend work can use that agreed contract, but integration
must verify the real implementation. Serialize overlapping edits and migrations.
Independent worktrees do not eliminate semantic integration conflicts.

Use soft checkpoints, not promises of enforced budgets: roughly 3 minutes or
6 calls for a tiny task, 8 minutes or 12 calls for a bounded change. At a
checkpoint reassess progress and scope; do not skip necessary verification or
stop useful authorized work solely to satisfy a timebox.

## Correct, verify, and finish

After a failure, identify missing context, a local defect, a reasoning problem,
or an environment blocker. Attempt one focused repair by the owner only when a plausible repair exists;
skip retries while a known missing prerequisite remains unavailable; if the same
failure persists, the controller diagnoses and changes approach, handles it
directly, or escalates the bounded problem. Avoid repeated blind retries.

Verification is selected by risk, never required merely because a domain role
was used. Low-risk changes use owner evidence. Critical changes need an
independent reviewer with adequate context and capability; checks may include
contract, authorization, transaction, migration, or end-to-end evidence. For UI,
inspect relevant states visually when tools are available and report any gap.
Re-run affected checks after integration edits; do not repeat unchanged suites.

Each worker returns status (complete/incomplete/blocked), changed paths,
checks and results, unresolved risks, and the next decision if needed.
The controller checks acceptance against code and evidence, including integration;
a worker's summary alone is not proof. Report incomplete checks honestly.
If critical work cannot obtain independent review, authorized implementation may
continue, but critical acceptance remains incomplete and the review gap is explicit.
Do not commit, push, deploy, publish, or message others without authorization.

For completed nontrivial runs, consult [learning-and-evaluation.md](references/learning-and-evaluation.md)
to record useful project-scoped lessons and available metrics. Do not force a
lesson or a new file for every task. Never promote one observation into a global
rule or claim measured improvements without comparative runs.
