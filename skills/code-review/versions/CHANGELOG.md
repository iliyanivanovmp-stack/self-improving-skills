# Changelog — code-review

## v3 — 2026-05-27
- Added rule: do not comment on test coverage unless explicitly asked
- Why: skill was adding unsolicited coverage suggestions on most reviews — violated instruction-following eval

## v2 — 2026-05-27
- Added "Maximum 15 findings per review" constraint to Constraints section
- Why: runs on large files returned 20+ findings, making output overwhelming and hard to prioritize

## v1 — 2026-05-27
- Initial version. 6-step review: context → correctness → security → simplification → synthesize → summary.
- Imported into self-improving skills framework.
