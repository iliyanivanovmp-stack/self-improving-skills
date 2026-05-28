# Improvements — code-review

Append-only log of every accepted improvement. Never edit or delete past entries.
Format: [YYYY-MM-DD] vN→vN+1 | WHAT: [one-line description] | WHY: [criterion or user suggestion]

---

[2026-05-27] v1→v2 | WHAT: Added "Maximum 15 findings" constraint to Step 6 | WHY: Constraint eval — early runs returned 20+ findings on large files, making the output hard to act on
[2026-05-27] v2→v3 | WHAT: Added explicit rule "Do not comment on test coverage unless asked" | WHY: Instruction-Following eval — skill was adding unsolicited test coverage suggestions that weren't requested
