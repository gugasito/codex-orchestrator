# Routing and escalation

Roles are available only after the runtime discovers their installed TOML files.
The main chat remains on the user's selected model. Role files fix effort;
explicit spawn arguments cannot override those fixed settings in all runtimes.
Use a generic agent with explicit model/effort and the relevant domain contract
when a different combination is needed and supported.

| Role | Model / effort | Responsibility |
| --- | --- | --- |
| luna_explorer | GPT-6 Luna / low | Targeted read-only discovery with paths and evidence |
| luna_worker | GPT-6 Luna / medium | Alternative sole implementer for unclassified or bounded cross-domain work |
| luna_backend | GPT-6 Luna / medium | Sole owner for assigned service, business behavior, and API implementation |
| luna_frontend | GPT-6 Luna / medium | Sole owner for assigned UI, UX states, and accessibility implementation |
| luna_infra | GPT-6 Luna / medium | Sole owner for assigned runtime and infrastructure implementation |
| luna_database | GPT-6 Luna / high | Sole owner for assigned data invariants, queries, and safe migrations |
| luna_qa | GPT-6 Luna / medium | Test implementation or focused acceptance analysis |
| luna_verifier | GPT-6 Luna / medium | Independent focused checks; no source edits |
| luna_security | GPT-6 Luna / high | Focused read-only threat/correctness review |
| luna_docs | GPT-6 Luna / low | Project documentation grounded in evidence |
| sol_specialist | GPT-6.1 Sol / high | Bounded difficult diagnosis, implementation or architecture |
| sol_reviewer | GPT-6.1 Sol / high | Independent review of critical decisions and changes |
| astra_specialist | GPT-6 Astra / high | Exceptional unresolved reasoning or consequential design |

Use the controller for architecture/UX decisions unless independent judgment or
an isolated deep investigation has clear value. A separate planner, architect,
implementer, and reviewer are not mandatory stages.

Keep responsibilities distinct: the domain worker implements and runs focused
checks for its change; `luna_qa` authors or improves tests and fixtures; and
`luna_verifier` independently runs supplied checks without editing or repairing
code. Add either role only when that work is independently useful. Security is a
scoped, read-only review. Reviewers inspect the relevant diff and current
evidence; repeat a check only when it is stale, affected by integration, or
needed to resolve a concrete risk.

Backend, frontend, database, and infrastructure roles are implementers with
writable assigned scopes, not advisors who pass implementation to `luna_worker`.
Use exactly one implementation owner per path. `luna_worker` is the alternative
owner when no domain role fits or a bounded cross-domain change needs one owner;
it is not a follow-up stage. There is no dedicated low-effort bulk-edit role or
xhigh Luna implementation preset; use an available owner and focused scope.

Escalation examples:
- Missing API contract: controller resolves it, then the same Luna worker resumes.
- Independent ready scopes: dispatch them in parallel; queue consumers only until
  the owner resolves their shared contract.
- Routine in-scope detail: worker uses project evidence and proceeds; report a
  decision only when acceptance changes or the detail exceeds assigned scope.
- Single implementation defect: one focused Luna repair.
- Repeated failure tracing transaction/concurrency behavior: controller or Sol
  specialist examines the invariant and failing evidence.
- Sol cannot resolve a consequential design tradeoff: bounded Astra consultation
  if available and consistent with the user's cost constraints.
- Tests cannot connect to a service: diagnose environment; report blocked checks.

If a named Luna role is absent, first use a supported explicit Luna spawn with
the domain contract. If Luna delegation itself is unavailable, report it and
apply the entrypoint's exception/strict-model policy. Absence of an optional
specialist is not permission to bypass the default Luna implementation route. Never silently substitute a more expensive model
when the user has set a model/cost constraint. Price and availability are not
hard-coded guarantees. Record actual model, effort, and usage when exposed.
