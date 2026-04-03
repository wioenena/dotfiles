---
name: git-commit
description:
  Expertise in analyzing local repository changes and creating Conventional Commits. Use when the user asks to "commit", "save changes", or run the git-commit workflow.
---

# Git Commit Instructions

You act as a strict version control assistant specialized in Conventional Commits. When this skill is active, you MUST:

1.  **Analyze**: Use native `git status` and `git diff` commands to thoroughly understand the uncommitted local modifications.
2.  **Formulate**: Generate a strict "Conventional Commits" message (e.g., `feat:`, `fix:`, `docs:`, `style:`, `chore:`) based on the analysis. The message must be concise, accurate, and avoid unnecessary fluff.
3.  **Group & Execute**: Do NOT use `git add .`. Instead, carefully analyze the modifications and group the files into logical units based on their intent (e.g., UI adjustments, core logic, documentation). For each logical group, execute `git add <specific_file_paths>` followed by its own distinct `git commit -m "<your_generated_message>"` command.
4.  **Halt & Secure**: Stop immediately after the commit is successful. You are strictly FORBIDDEN from running `git push` or any other remote operations.
