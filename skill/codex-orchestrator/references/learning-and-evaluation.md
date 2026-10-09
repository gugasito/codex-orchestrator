# Evidence-based learning and evaluation

## Project learning

Capture a lesson only when an observed correction, repeated failure, or explicit
decision is useful beyond this task. Use existing project memory conventions;
otherwise `.codex/knowledge/lessons.md` is an optional project-local ledger.
Do not store secrets, raw conversations, customer data, or complete tool logs.
Do not edit the installed global skill or AGENTS.md as an automatic side effect.

Each record contains:
- Situation/trigger and proposed action.
- Project/domain scope and source (test, code path, decision or user correction).
- Observed date/commit and status: observation, validated, or retired.
- Validation evidence and condition that would invalidate the lesson.

An observation is not a binding rule. Promote to validated after repeated
supporting evidence or an explicit project decision. Retire contradicted lessons;
keep the reason. Global promotion requires an explicit maintenance request and
evidence that the lesson transfers across projects. Only read relevant lessons.

## Run metrics

For nontrivial work, record metrics in the existing project log or optionally
`.codex/knowledge/runs.jsonl`. Keep one compact JSON object per run:

```json
{"task":"identifier","variant":"adaptive-v2","base_commit":"unknown","route":"normal","agents":[],"elapsed_seconds":null,"coordination_seconds":null,"input_tokens":null,"output_tokens":null,"cost_usd":null,"retries":0,"acceptance":"incomplete","checks":[],"limitations":[]}
```

Populate agents with actual role/model/effort where known. Missing measurements
are null/unknown, not zero. Distinguish observed usage from API-price estimates;
subscription usage is not API dollar billing. Do not ask agents to invent token
or tool-call counts. Timing needs observed timestamps. Logging is small and
local; no external telemetry or background observer is implied.

## Compare before claiming an improvement

Use the same base commit, task, acceptance rubric, environment, and service tier
for: selected model alone, previous orchestrator, and adaptive orchestrator.
Keep variants in isolated disposable workspaces. Choose representative small
bugs, backend features, UX changes, migrations, refactors, and hard diagnoses.
Run multiple repetitions; retain failures and blocked runs. Assess acceptance
independently of the implementation model. Check regression, architecture, and
UX quality as well as duration and usage. Report per-task outcomes and median
latency, rework, and cost per accepted task when enough data exists; do not hide
failed-run cost. Instruction/installer tests are not end-to-end benchmarks.

An offline routing exercise can check whether the skill chooses sensible work
boundaries, but cannot establish model quality, speed, or actual delegation.
