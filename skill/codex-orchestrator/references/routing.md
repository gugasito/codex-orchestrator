# Routing and escalation

Roles are available only after the runtime discovers their installed TOML files.
The main chat remains on the user's selected model. Role files fix effort;
explicit spawn arguments cannot override those fixed settings in all runtimes.
Use a generic agent with explicit model/effort and the relevant domain contract
when a different combination is needed and supported.

| Role | Model / effort | Responsibility |
| --- | --- | --- |
| luna_explorer | GPT-6 Luna / low | Targeted read-only discovery with paths and evidence |
| luna_repetitive | GPT-6 Luna / low | Finite mechanical edits |
| luna_worker | GPT-6 Luna / medium | Bounded general implementation and focused checks |
| luna_backend | GPT-6 Luna / medium | Services, business behavior, API contracts |
| luna_frontend | GPT-6 Luna / medium | Existing components, UX states, accessibility |
| luna_infra | GPT-6 Luna / medium | Runtime and infrastructure changes |
| luna_database | GPT-6 Luna / high | Data invariants, queries, safe migrations |
| luna_qa | GPT-6 Luna / high | Test implementation or complex acceptance analysis |
| luna_verifier | GPT-6 Luna / high | Independent checks; no source edits |
| luna_security | GPT-6 Luna / high | Focused read-only threat/correctness review |
| luna_docs | GPT-6 Luna / low | Project documentation grounded in evidence |
| luna_deep_worker | GPT-6 Luna / xhigh | Compatibility role for explicitly justified difficult Luna work |
| sol_specialist | GPT-6.1 Sol / high | Bounded difficult diagnosis, implementation or architecture |
| sol_reviewer | GPT-6.1 Sol / high | Independent review of critical decisions and changes |
| astra_specialist | GPT-6 Astra / high | Exceptional unresolved reasoning or consequential design |

Use the controller for architecture/UX decisions unless independent judgment or
an isolated deep investigation has clear value. A separate planner, architect,
implementer, and reviewer are not mandatory stages.

Escalation examples:
- Missing API contract: controller resolves it, then the same Luna worker resumes.
- Single implementation defect: one focused Luna repair.
- Repeated failure tracing transaction/concurrency behavior: controller or Sol
  specialist examines the invariant and failing evidence.
- Sol cannot resolve a consequential design tradeoff: bounded Astra consultation
  if available and consistent with the user's cost constraints.
- Tests cannot connect to a service: diagnose environment; report blocked checks.

If an optional role is absent, use the controller or supported explicit-model
spawn; report limitations. Never silently substitute a more expensive model
when the user has set a model/cost constraint. Price and availability are not
hard-coded guarantees. Record actual model, effort, and usage when exposed.
