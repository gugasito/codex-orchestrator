---
name: codex-orchestrator
description: Run a strict native Codex workflow with GPT-6 Astra as a controller and GPT-5.6 Luna subagents for exploration, implementation, verification, and repetitive work. Use when the user requests this Astra/Luna workflow or invokes $codex-orchestrator.
---

# Codex orchestrator: strict controller mode

The project defaults the primary Codex session to GPT-6 Astra (`gpt-6-astra`).
Astra is a controller only. It plans the task, chooses Luna roles, starts and
waits for subagents, handles bounded follow-ups, and reports the final result.

An explicit model selected for the current Codex session is authoritative and
cannot be changed by a skill. If the session is not using Astra, state the
mismatch and ask the user to start a new task with Astra before claiming this
workflow is active.

## Astra's hard workflow boundary

While this skill is active, Astra must not perform workspace actions directly.
Do not use shell, terminal, apply-patch, editor, browser, web, MCP, file-editing,
test, build, git, or other operational tools from the primary session. Do not
read the repository to discover implementation details. Delegate discovery to
`luna_explorer`.

The only operational calls available to Astra in this workflow are native
subagent lifecycle calls: create a subagent, wait for it, send a bounded
follow-up, or stop it. Astra must never edit, integrate, test, review files, or
run a command itself. When a result needs integration or verification, create a
Luna node for that responsibility. If native delegation is unavailable, report
the blocker instead of doing the work directly.

This is a workflow boundary enforced by instructions. Codex may still expose
tools to the primary session because skills do not provide a separate tool
allow-list. Follow the boundary exactly and report if the runtime cannot honor
it.

## Luna routing

Every implementation or verification node must select GPT-5.6 Luna
(`gpt-5.6-luna`) explicitly or use one of the named roles below. Never omit the
model when spawning: an omitted model can inherit Astra.

| Role | Effort | Use for | Permissions |
| --- | --- | --- | --- |
| `luna_explorer` | low | Read-only mapping and evidence | read-only |
| `luna_repetitive` | low | Finite mechanical transformations | workspace-write |
| `luna_worker` | medium | Clear implementation and focused tests | workspace-write |
| `luna_deep_worker` | xhigh | Ambiguous debugging, architecture, or difficult integration | workspace-write |
| `luna_verifier` | high | Tests and evidence review without code edits | workspace-write |

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
workspace yourself. Build a compact graph from the objective and delegate the
first required inspection to `luna_explorer` when file context is needed.

Each node must include an id, responsibility, model, effort, owned files or
scope, dependencies, expected output, verification, and stop condition. Send
only the context needed for that node. Do not paste raw logs or the whole
workspace into later prompts.

Use one Luna node for a small task. Use at most two active nodes by default;
run them in parallel only when their write scopes are disjoint. Serialize all
nodes that can touch the same files. Do not ask Luna agents to delegate further.

For every writing node, require this concise result:

```text
status: complete | blocked
changed_files: paths or none
verification: command and result, or not run
blocker: one short explanation or none
```

A worker may run only the checks relevant to its owned change. A separate
`luna_verifier` is optional for small, low-risk changes and required when the
acceptance criteria need independent evidence. Astra never runs the checks.

Use at most one focused correction for a failed node. If it fails again, return
the evidence and decision needed to the user. Do not retry loops, broaden the
scope, or escalate effort automatically.

After all required Luna nodes finish, Astra consolidates their summaries and
reports the models, changed files, verification, blockers, and next decision.
Astra does not perform a final integration edit; assign integration to
`luna_worker` or `luna_deep_worker`.

Do not commit, push, deploy, publish, send external messages, or perform other
external mutations unless the user explicitly requests them.
