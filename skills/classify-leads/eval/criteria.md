# Eval Criteria — classify-leads

Used by Claude during self-reflection after each run.
Each criterion is checked: pass / partial / miss. Not scored.

Primary pack: Pack 9 (Batch/Data Processing)
Secondary: Pack 3 (Tool/API/Automation) — 3 evals added

---

## Universal Evals (always apply)

- **Instruction-Following** — Did Claude follow every step and rule in SKILL.md?
- **Completeness** — Was every lead in the input file classified? No rows silently dropped?
- **Accuracy** — Do the classifications match the intended distinction (e.g., product SaaS vs agency)?
- **Hallucination** — Did Claude invent lead data, company details, or classification reasons not in the input?
- **Safety / Risk** — Was the script run on a test batch before processing the full list?
- **Constraint** — Were the output format, file path, and classification type flags respected?

---

## Pack 9 — Batch / Data Processing (trimmed)

- **Row Completeness** — Does every lead record in the output contain a classification field? No rows missing the result.
- **Missing Data Handling** — When a lead has insufficient info to classify, is it labeled "unclear" rather than forced into a category?
- **Ambiguous Match** — Are borderline leads (medium confidence) included by default unless the user explicitly filters them out?
- **Output Schema** — Does the JSON output match the expected schema — classification field added to the original record, nothing removed?
- **Error Row Reporting** — If any leads fail to classify (API error, malformed input), are they reported clearly rather than silently lost?
- **Sample Verification** — Were a few output rows spot-checked before the result was handed to the user?

---

## Pack 3 — Tool / API / Automation (selected)

- **Small-Batch Test** — Was the script run on a small sample (~10–20 leads) to verify behavior before the full run?
- **Error Handling** — If the Claude API call fails for a lead, does the script handle the error gracefully (retry, skip with log, not crash)?
- **Response Parsing** — Is the LLM output correctly parsed into a structured classification result, not used as raw text?

---

## Skill-Specific

- **Classification Criteria Match** — Does the classification prompt in the script accurately reflect the distinction the user asked for (e.g., "product SaaS" means product-led software company, not any software company)?
- **Confidence Transparency** — When the model is uncertain about a lead, is that uncertainty surfaced to the user rather than hidden behind a confident label?
