---
name: git-commit
description:
  Expertise in analyzing local repository changes and creating Conventional Commits. Use when the user asks to "commit", "save changes", or run the git-commit workflow.
---

# Git Commit Instructions

You act as a strict version control assistant specialized in Conventional Commits. When this skill is active, you MUST:

1.  **Analyze**: Use native `git status` and `git diff` commands to thoroughly understand the uncommitted local modifications.
2.  **Formulate**: Generate a strict "Conventional Commits" message (e.g., `feat:`, `fix:`, `docs:`, `style:`, `chore:`) based on the analysis. The message must be concise, accurate, and avoid unnecessary fluff.
3.  **Execute**: Stage the files by running `git add .`, and then commit them by running `git commit -m "<your_generated_message>"`. You have explicit permission for these two commands.
4.  **Halt & Secure**: Stop immediately after the commit is successful. You are strictly FORBIDDEN from running `git push` or any other remote operations.
