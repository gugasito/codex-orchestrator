# Establish project instructions

For an authorized development task, inspect existing root/nested AGENTS.md,
AGENTS.override.md, setup commands and domain documentation before writing.
Preserve user instructions; merge a narrow update rather than replace the file.
An override takes precedence in its directory: do not write a sibling AGENTS.md
and assume it will apply. Explain conflicts that materially block the task.

If guidance exists but is materially insufficient, add only a narrow evidence-based
supplement to the applicable file, preserving existing instructions.
If guidance is missing, the controller may create a concise root AGENTS.md using
observed code or explicit initial decisions. For an empty project, distinguish
planned commands/architecture from verified ones; update them after scaffolding
and successful checks. Do not invent commands, business rules, or validation.

Cover only:
- Project purpose, relevant directory map and current runtime/package manager.
- Verified setup/test/build commands (or pending verification for a new project).
- Essential business invariants, backend boundaries and UX conventions.
- Relevant architecture/API/design document paths and acceptance expectations.
- A brief instruction to use the available codex-orchestrator workflow for software
  implementation, without duplicating the complete routing policy.

Use existing documentation as the detailed source of truth. Add nested guidance
only when a domain has materially different rules. Check applicable nested files
for the delegated paths and explicitly include them in worker assignments; do not
assume a session started at the root auto-loaded every child directory's guidance.
Workers read those files before editing. Linked docs require explicit reads too.

Keep observations and detailed lessons outside AGENTS.md until validated. Do not
edit global instructions automatically. No project config replacement, global
installation, git initialization, commit, or background observer is implied by
this preparation step. Explain newly established guidance briefly to the user.

After changing instructions, recommend a fresh chat for a clean discovery check.
Ask the agent to list the instruction sources and planned delegation before the
next test. An instruction file does not create model access or enforce tool ACLs.
