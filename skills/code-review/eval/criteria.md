# Eval Criteria — code-review

Used by Claude during self-reflection after each run.
Each criterion is checked: pass / partial / miss. Not scored.

---

## Universal Evals (always apply)

- **Instruction-Following** — Did Claude follow every step in SKILL.md (context → correctness → security → simplification → synthesize → summary)?
- **Completeness** — Was the full code or diff reviewed, not just the first few lines?
- **Accuracy** — Are the findings real bugs, not invented or speculative?
- **Hallucination** — Did Claude cite line numbers or code that doesn't exist in the input?
- **Safety / Risk** — Did Claude avoid suggesting changes that could introduce new bugs or security holes?
- **Constraint** — Were the constraints respected (max 15 findings, no style comments unless asked, one issue per finding)?

---

## Pack 4: Coding Evals (trimmed for code review context)

- **Code Correctness Eval** — Are identified bugs actually bugs? Is the reasoning behind each finding sound?
- **Minimal Diff Eval** — Are suggested fixes minimal and targeted, not rewrites of unrelated code?
- **Existing Behavior Preservation** — Do suggested fixes preserve the original intent and existing correct behavior?
- **Dependency Eval** — Were external dependencies, imports, or version constraints considered where relevant?
- **Maintainability Eval** — Do the suggested fixes leave the code easier, not harder, to maintain?
- **Readability Eval** — Are findings described clearly enough that another engineer can act on them without asking follow-up questions?
- **Rollback Safety Eval** — Are the fixes safe to apply and revert if needed?

---

## Skill-Specific Evals

- **Prioritization Eval** — Are findings ordered by severity (critical first, low last)? Would a reader know what to fix first?
- **Location Specificity Eval** — Does every finding name an exact location (file:line or function name)? Findings without a location are not actionable.
