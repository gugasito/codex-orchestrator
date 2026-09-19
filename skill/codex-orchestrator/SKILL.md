---
name: codex-orchestrator
description: Coordinate native Codex subagents with GPT-6 Astra as the lead and GPT-5.6 Luna for bounded implementation, exploration, and repetitive work. Use when the user requests this Astra/Luna workflow or invokes $codex-orchestrator.
---

# Codex orchestrator

The main Codex session uses GPT-6 Astra (`gpt-6-astra`) to plan, delegate,
review, integrate, and verify. Delegate implementation to GPT-5.6 Luna
(`gpt-5.6-luna`) through native subagent tools.

## Model selection

A skill cannot switch the current session's model. If the session is known to
use another model, tell the user to select Astra before claiming this workflow
is active. If the main model is not exposed, say it is unverified rather than
guessing. Model configuration alone does not prove runtime availability.

Inspect the live subagent tool and callable roles before dispatch. Prefer the
installed roles below when they are actually callable. Otherwise use an
explicit `gpt-5.6-luna` model override and the matching reasoning effort if the
live tool supports them. Provide the role's responsibility in the task prompt.
Never spawn without a confirmed Luna selection: the default can inherit Astra.
If neither route is callable, report the missing capability and stop delegation;
do not replace it with a shell CLI process, a separate user task, or another model.

| Role | Effort | Responsibility |
| --- | --- | --- |
| `luna_worker` | medium | Bounded code changes and relevant tests |
| `luna_repetitive` | low | Explicit mechanical transformations and repeatable checks |
| `luna_explorer` | low | Read-only code mapping and concise evidence gathering |

## Execution

Interpret the text after `$codex-orchestrator` as the objective. Inspect enough
workspace context to define acceptance criteria, then form a compact task graph.
Each node needs an owner, dependencies, allowed files or responsibility,
deliverable, verification, and a stop condition. Keep Astra's integration and
final review outside the Luna implementation nodes.

Delegate only work that benefits from a separate agent; one Luna worker is
enough for a small implementation. Avoid creating agents for trivial questions.
For independent tasks, use at most three active subagents, or the live limit
if lower. Each writing agent gets a disjoint file set; serialize work on shared
files. Tell workers that other agents share the project and their edits must
be preserved. Keep agents focused on their assignment without further delegation.

Before starting, briefly state each assignment and its model. Give the worker
only the necessary context, file ownership, acceptance criteria, tests, and stop
condition. Repetitive work needs a finite batch or iteration limit. A blocked
worker should return evidence and the decision needed, not repeatedly retry.

Collect changed paths, test results, and unresolved issues. Inspect the actual
changes, integrate them, and run appropriate final checks. Send a focused
correction back to Luna when needed; after two unsuccessful correction rounds
for the same node, reassess the plan with the user rather than silently
escalating to a more expensive model. Astra can resolve integration decisions
and small integration edits; keep substantial implementation with Luna.

Report the models actually used, material changes, verification, and any
remaining blockers. Distinguish passed local checks from an untested live
workflow. Do not claim savings from model selection alone: agent count,
duplicated context, and retries also affect usage.
