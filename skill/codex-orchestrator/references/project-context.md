# Project architecture and UX

Use existing project documentation first. For missing guidance, follow
[project-setup.md](project-setup.md). Project AGENTS.md and explicit user
requirements take precedence over this skill's defaults. Proposed knowledge
paths are conventions, not runtime-loaded magic. The controller must explicitly
read the relevant files and include their paths/evidence in worker contracts.

For repeat work, keep a small index at `.codex/knowledge/index.md` pointing to
existing architecture, UX, decisions, and lessons. Create it only when useful;
do not overwrite existing docs or invent project facts to populate a template.
Record unknowns as unknown and resolve only those needed by the current task.
Reference code paths/symbols and the commit or date of inspection; validate stale
claims against current code. Preserve intentional conventions, but do not copy
an existing defect merely because it appears elsewhere.

## Backend changes

Establish the affected module boundaries and dependency direction. Identify
where business rules, transport validation, persistence, and integrations live.
Specify changed request/response contracts, errors, compatibility, authorization,
transaction boundaries, idempotency and data invariants when relevant.
Use representative existing code as evidence. Avoid imposing microservices,
CQRS, repositories, or another architecture without a concrete project need.
Write a short decision record only for a consequential choice: context,
decision, alternatives, consequences, and evidence. For migration work identify
compatibility, rollout and recovery behavior before changing consumers.

## Frontend and UX changes

Locate the actual design tokens and reusable components. Establish the user
journey, navigation, validation and loading/empty/error/success states affected
by the change. Preserve responsive behavior, keyboard access, focus management,
and accessible names relevant to that journey. Define the API contract before
parallel frontend/backend implementation.
Verify the rendered affected states and user flow when a browser/app preview is
available, alongside relevant behavioral tests. If rendering is unavailable,
report that limitation instead of claiming visual acceptance from tests alone.
A new design choice belongs in existing UX docs only when it should be reused.

## Compact task contract example

Objective: allow cancellation of eligible orders.
Acceptance: allowed states and roles; repeated cancellation behavior; stock/payment
consequences; UI pending, success, and failure states.
Evidence: actual order module, transaction path, API schema, existing dialog.
Ownership: one owner for schema/contract; separate service and UI scopes only
after the contract is agreed. Integration checks real behavior, not just mocks.
Do not assume the example's rules apply to the project; discover its actual rules.
