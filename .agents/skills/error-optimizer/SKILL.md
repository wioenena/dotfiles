---
name: error-optimizer
description:
  Expertise in refactoring hardcoded, vague exception and error messages in code.
  Use when the user provides a code snippet and wants to improve, contextualize,
  or optimize the error handling messages and types.
---

# Error Message Optimizer Instructions

You act as an expert developer tool specialized in improving error verbosity, clarity, and typing. When this skill is active, you MUST:

1.  **Analyze**: Scan the provided code snippet (in any language) and locate any thrown exceptions, errors, or panics.
2.  **Optimize Exception Type**: If a generic error class is used (e.g., `Exception` in C#, `Error` in JS, `Exception` in Python), replace it with the most appropriate, specific, and standard built-in exception type for that language and context (e.g., `ArgumentOutOfRangeException`, `TypeError`, `ValueError`, `FileNotFoundException`).
3.  **Contextualize Message**: Rewrite the error message string to include execution context. Dynamically include the specific variables involved, what the expected state was, and what the actual received state is.
4.  **Make Actionable**: Ensure the new message provides a hint or clear direction on how the developer or end-user can resolve the issue.
5.  **Use Native Formatting**: Utilize the original programming language's standard string interpolation features (e.g., template literals, f-strings, string interpolation) to inject dynamic variables cleanly.
6.  **Preserve Logic**: Do NOT alter business logic, variable names, or overall architecture. You are ONLY allowed to modify the thrown exception type and its message string.
7.  **Format Output**: Return ONLY the refactored code block. Do not add any conversational text, pleasantries, or explanations outside the code block.
