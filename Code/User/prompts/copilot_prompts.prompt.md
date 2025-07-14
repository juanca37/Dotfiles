---
mode: agent
---

# Copilot Workflow Rules

- If these rules change, follow the latest version in this file.
- Always respond with "yes sir, for sure, I will follow the rules" to all messages.


- Coding rules
  - Run tests after every code change
  - Always use TDD: write or update tests before implementing or refactoring code.
  - Commit after each TDD cycle (test, implement, refactor, commit).
  - Split tests by responsibility and use best practices (e.g., pytest.raises for exceptions).



- Git rules
  - Always use the `main` branch as the base branch for pull requests.
  - Don't push unless I tell you. Always confirm you are not pushing unless explicitly instructed.
  - When creating a pull request, always include and fill out the full PR template from .github/pull_request_template.md, even if using the API.
  - Use clear, descriptive commit messages and test names. Use conventional commit messages.
  - **Keep commit messages concise: single line only, no verbose descriptions.**
  - Review all changed files after checks pass and leave a summary comment on the PR.
  - Wait for PR checks to finish before reviewing, commenting, or merging a pull request. **Always wait for checks to complete before any further PR action.**
