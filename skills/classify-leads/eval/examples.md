# Examples — classify-leads

2–3 golden input/output pairs used as reference during self-reflection and regression checks.

---

## Example 1 — Clear product SaaS vs agency distinction

**Input:**
```json
[
  { "company": "Notion", "website": "notion.so", "description": "All-in-one workspace for notes, docs, and project management" },
  { "company": "WebFX", "website": "webfx.com", "description": "Digital marketing agency helping brands grow online revenue" },
  { "company": "Ahrefs", "website": "ahrefs.com", "description": "SEO toolset for backlink analysis and keyword research" }
]
```

**Command:**
```bash
python3 ./scripts/classify_leads_llm.py leads.json \
  --classification_type product_saas \
  --output classified.json
```

**Expected output:**
```json
[
  { "company": "Notion", "website": "notion.so", "classification": "product_saas", "confidence": "high" },
  { "company": "WebFX", "website": "webfx.com", "classification": "not_product_saas", "confidence": "high" },
  { "company": "Ahrefs", "website": "ahrefs.com", "classification": "product_saas", "confidence": "high" }
]
```

**Notes:** Straightforward case. All three are clear-cut. A good run classifies all three correctly with high confidence and produces valid JSON with no dropped fields.

---

## Example 2 — Ambiguous / unclear lead handled correctly

**Input:**
```json
[
  { "company": "Acme Consulting", "website": "acmeconsulting.io", "description": "We build and manage custom software solutions for enterprise clients" },
  { "company": "Salesforce", "website": "salesforce.com", "description": "CRM and cloud software platform" }
]
```

**Expected output:**
```json
[
  { "company": "Acme Consulting", "website": "acmeconsulting.io", "classification": "unclear", "confidence": "low", "reason": "builds custom software but primarily service/consulting model — no clear product" },
  { "company": "Salesforce", "website": "salesforce.com", "classification": "product_saas", "confidence": "high" }
]
```

**Notes:** Acme is a real edge case — "builds software" but is a services firm. The skill should return "unclear" with a reason, not force it into product_saas. This tests that confidence transparency is working.

---

## Example 3 — Large batch, summary reported correctly

**Input:** 3,000 lead records in `.tmp/leads.json`

**Expected behavior:**
- Script runs without crashing
- Progress logged to terminal (~2 min runtime)
- Output file `.tmp/classified_leads.json` contains exactly 3,000 records
- Summary at end: `Classified: 2,847 | Unclear: 153 | Errors: 0`
- Claude spot-checks 3–5 output rows before handing result to user

**Notes:** Tests batch scale, row completeness, and the summary report. The exact numbers will vary but the format and completeness check are what matters.
