---
name: codex-orchestrator
description: Run a strict native Codex workflow with the user's selected primary model as controller when native delegation is available, and GPT-6 Luna subagents for exploration, implementation, verification, and repetitive work. Use when the user requests this Sol/Astra/Luna workflow or invokes $codex-orchestrator.
---

# Codex orchestrator: strict controller mode

The project defaults the primary Codex session to GPT-6 Sol
(`gpt-6-sol`). The active model selected by the user for the current Codex
session is the authoritative controller. Respect that selection; do not ask the
user to switch models by name. Models such as GPT-6 Sol (`gpt-6-sol`), GPT-6
Astra (`gpt-6-astra`), and GPT-6.1 Sol (`gpt-6.1-sol`) are examples, not an
exhaustive compatibility list. This workflow requires the runtime to provide
native subagent delegation to the active controller. Do not assume that every
model has delegation tools. If delegation is unavailable, report that concrete
blocker without silently substituting another model or operating as controller.
When delegation is available, the controller plans the task, chooses Luna
roles, starts and waits for subagents, handles bounded follow-ups, and reports
the final result.

The explicit model selected for the current Codex session is authoritative and
cannot be changed by a skill. Do not reject the session because its model name
is not listed here. First determine whether native delegation is available to
the active controller; if it is not, report the runtime limitation and stop.

## Controller's hard workflow boundary

While this skill is active, the controller must not perform workspace actions
directly.
Do not use shell, terminal, apply-patch, editor, browser, web, MCP, file-editing,
test, build, git, or other operational tools from the primary session. Do not
read the repository to discover implementation details. Delegate discovery to
`luna_explorer`.

The only operational calls available to the controller in this workflow are native
subagent lifecycle calls: create a subagent, wait for it, send a bounded
follow-up, or stop it. The controller must never edit, integrate, test, review
files, or run a command itself. When a result needs integration or verification,
create a Luna node for that responsibility. If native delegation is unavailable,
report the blocker instead of doing the work directly.

This is a workflow boundary enforced by instructions. Codex may still expose
tools to the primary session because skills do not provide a separate tool
allow-list. Follow the boundary exactly and report if the runtime cannot honor
it.

## Luna routing

Every implementation or verification node must use GPT-6 Luna
(`gpt-6-luna`) explicitly or use one of the named roles below. Never omit the
model when spawning: an omitted model can inherit the controller.

| Role | Effort | Use for | Permissions |
| --- | --- | --- | --- |
| `luna_explorer` | low | Read-only mapping and evidence | read-only |
| `luna_repetitive` | low | Finite mechanical transformations | workspace-write |
| `luna_worker` | medium | Clear implementation and focused tests | workspace-write |
| `luna_deep_worker` | xhigh | Ambiguous debugging, architecture, or difficult integration | workspace-write |
| `luna_verifier` | high | Tests and evidence review without code edits | read-only |
| `luna_infra` | medium | Docker, Compose, CI/CD, deployment, and runtime configuration | workspace-write |
| `luna_backend` | medium | APIs, services, business logic, and integrations | workspace-write |
| `luna_frontend` | medium | UI, client state, accessibility, and component tests | workspace-write |
| `luna_database` | high | Schemas, migrations, queries, integrity, and rollback safety | workspace-write |
| `luna_qa` | high | Test strategy, regression coverage, and acceptance evidence | workspace-write |
| `luna_security` | high | Threat modeling, security review, and findings (read-only) | read-only |
| `luna_docs` | low | README, runbooks, contracts, and technical documentation | workspace-write |

Use `max` for a Luna node only when the user explicitly asks for maximum
reasoning or the task remains blocked after a high or xhigh attempt. Luna also
supports `low`, `medium`, `high`, and `xhigh`. Do not replace a requested Luna
effort with Astra.

Interpret effort hints in the objective as follows:

- mechanical, batch, repetitive, formatting: `luna_repetitive`, `low`;
- normal implementation or a known bug: `luna_worker`, `medium`;
- complex, ambiguous, architectural, or difficult debugging: `luna_deep_worker`,
  `xhigh`;
- explicit `high`, `xhigh`, or `max`: use that exact Luna effort when callable.

Prefer the smallest role and effort that can complete the node. A user request
for a specific effort overrides this classifier.

## Execution protocol

Treat the text after `$codex-orchestrator` as the objective. Do not inspect the
workspace yourself. When the user names the files and acceptance conditions are
clear, use the fast path: delegate directly to one suitable worker. Start with
`luna_explorer` only when genuine uncertainty about code paths, dependencies, or
ownership prevents a bounded implementation assignment. Do not rediscover facts
already established in the conversation.

Each node must include an id, responsibility, model, effort, owned files or
scope, dependencies, expected output, verification, and stop condition. Send
only the context needed for that node. Do not paste raw logs or the whole
workspace into later prompts.

Use one Luna node for a small task. Use at most four active nodes; run them in
parallel only when their write scopes are disjoint. Serialize all nodes that
can touch the same files, shared contracts, migrations, or root configuration.
Four is a ceiling, not a target: prefer fewer nodes when coordination costs
outweigh the benefit. Assign each node explicit ownership, and do not let two
nodes write the same path concurrently. Do not ask Luna agents to delegate
further.

## Task contract, budget, and completion

Every assignment must state: objective, `owned_paths` (or read-only scope),
acceptance criteria, required verification, stop condition, and an initial
budget. Keep prompts to the minimum context needed; use a context-free fork
when supported, and never send full history or raw logs. Agents must not
delegate further.

Treat these initial budgets as soft planning limits, not runtime enforcement:

| Size | Starting budget |
| --- | --- |
| Small, known paths | 6 tool calls or 3 minutes |
| Normal, bounded change | 12 tool calls or 8 minutes |
| Larger or risky work | Set a justified budget in the assignment |

At a budget checkpoint, report progress and remaining acceptance work, then
continue only within the stated scope when needed. Do not skip required tests or
verification just to meet a timebox. Mark `complete` only when every acceptance
criterion is evidenced; otherwise return `blocked` or `incomplete` with the
remaining work. Use low effort for simple work, medium for normal work, and high
for material risk. Use xhigh only for a concrete blocker or explicit user
request. Named roles may have fixed effort: use a callable role with the needed
effort, and do not promise an override the runtime cannot make. Allow at most
one focused corrective follow-up per node.

Request a separate verifier only when risk or the need for independent evidence
justifies it. For small, low-risk tasks, the owner can provide the focused
verification evidence. Final summaries report observed elapsed time, tool-call
count, and token usage when available; label unavailable metrics `unknown` and
never estimate them as observed facts.

## Domain routing and ownership

Choose the narrowest domain from the requested outcome and affected paths,
then choose the execution role (`luna_explorer`, a domain worker, or
`luna_verifier`). Domain roles do not replace the generic lifecycle roles:
exploration remains read-only, implementation belongs to the domain owner, and
independent verification belongs to `luna_qa`, `luna_security`, or
`luna_verifier` as appropriate.

| Domain | Primary owner | Required follow-up |
| --- | --- | --- |
| Docker, infrastructure, CI/CD, deployment | `luna_infra` | `luna_verifier` or `luna_security` for hardening |
| API, service, or business logic | `luna_backend` | `luna_qa` for behavior and regression coverage |
| UI, client state, accessibility | `luna_frontend` | `luna_qa` for component/user-flow coverage |
| Schema, migration, query, data integrity | `luna_database` | `luna_qa`; serialize consumers behind migrations |
| Test strategy or broad regression work | `luna_qa` | `luna_verifier` for independent evidence when risky |
| Threat model, secrets, auth, dependency/security review | `luna_security` | implementation findings return to the owning domain |
| README, guides, contracts, runbooks | `luna_docs` | `luna_verifier` when docs describe executable behavior |

For cross-domain work, create a dependency graph before spawning nodes. A
database migration precedes code that consumes its new schema; a backend
contract precedes frontend work that consumes it; infrastructure changes that
alter test/runtime behavior precede QA. Independent documentation or security
review may run alongside implementation when ownership is disjoint. Never use
parallelism to hide a shared-file conflict.

For every writing node, require this concise result:

```text
status: complete | blocked
changed_files: paths or none
verification: command and result, or not run
blocker: one short explanation or none
```

A worker may run only the checks relevant to its owned change. A separate
`luna_verifier` is reserved for cases where risk or acceptance criteria need
independent evidence. The controller never runs the checks.

Use at most one focused correction for a failed node. If it fails again, return
the evidence and decision needed to the user. Do not retry loops, broaden the
scope, or escalate effort automatically.

After all required Luna nodes finish, the controller consolidates their summaries
and reports the models, changed files, verification, blockers, and next decision.
The controller does not perform a final integration edit; assign integration to
`luna_worker` or `luna_deep_worker`.

Do not commit, push, deploy, publish, send external messages, or perform other
external mutations unless the user explicitly requests them.
