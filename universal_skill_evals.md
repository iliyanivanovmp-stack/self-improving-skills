# Universal Skill Evals

These evals can be used for almost any skill.

## 1. Instruction-Following Eval
Checks whether the skill followed its own `SKILL.md`.

## 2. Completeness Eval
Checks whether the skill completed the full task.

## 3. Constraint Eval
Checks hard limits like word count, number of outputs, required sections, no links, no emojis, etc.

## 4. Format Eval
Checks whether the output follows the required structure and formatting.

## 5. Accuracy Eval
Checks whether the output is correct for the task.

## 6. Grounding Eval
Checks whether the output is based on the provided input and does not add unsupported claims.

## 7. Hallucination Eval
Checks whether the skill invented data, facts, links, tool results, or unsupported details.

## 8. Data Preservation Eval
Checks whether important input data was preserved, such as names, numbers, variables, facts, and meaning.

## 9. Relevance Eval
Checks whether the output stays focused on the actual request.

## 10. Clarity Eval
Checks whether the output is easy to understand and act on.

## 11. Efficiency / Minimalism Eval
Checks whether the skill avoids filler, unnecessary steps, over-explaining, and bloated output.

## 12. User Preference Eval
Checks whether the skill respects known user preferences, such as simple language, short paragraphs, direct answers, and low hype.

## 13. Safety / Risk Eval
Checks whether the skill avoids risky behavior, destructive actions, leaking secrets, or sending messages without approval.

## 14. Regression Eval
Checks whether a new skill version still passes older tests and does not break previous behavior.

## 15. Failure Classification Eval
Checks why the skill failed, not only whether it failed.

## 16. Improvement Quality Eval
Checks whether the skill update targets the real failure and improves the skill without adding noise.

## 17. Contradiction Eval
Checks whether the skill contains conflicting instructions, examples, or rules.

## 18. Skill Bloat Eval
Checks whether the skill is becoming too large, redundant, or confusing.

## 19. Generalization Eval
Checks whether the skill improved broadly, not only for one specific test case.

## 20. Hidden Test Eval
Checks the skill on unseen cases to detect overfitting.
