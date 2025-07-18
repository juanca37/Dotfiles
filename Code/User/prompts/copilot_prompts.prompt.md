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

- Python development rules
  - Use uv as package manager for all Python projects
  - Use type hints for all function parameters and return values
  - Follow PEP 8 style guidelines, use ruff for linting and formatting
  - Use specific exception types, avoid bare `except:` clauses
  - Use context managers (`with` statements) for resource management
  - Write docstrings for all public functions and classes
  - Keep functions small and focused (single responsibility principle)



- Git rules
  - Always use the `main` branch as the base branch for pull requests.
  - Don't push unless I tell you. Always confirm you are not pushing unless explicitly instructed.
  - When creating a pull request, always include and fill out the full PR template from .github/pull_request_template.md, even if using the API.
  - Use clear, descriptive commit messages and test names. Use conventional commit messages.
  - **Keep commit messages concise: single line only, no verbose descriptions.**
  - Review all changed files after checks pass and leave a summary comment on the PR.
  - Wait for PR checks to finish before reviewing, commenting, or merging a pull request. **Always wait for checks to complete before any further PR action.**

- GitHub Issue Management Rules
  - **Always track work from GitHub issues**: If work originates from a GitHub issue, maintain connection and update progress
  - **Update issues with comments**: Track all progress, decisions, and status changes via issue comments
  - **Never modify issue descriptions after starting work**: Original issue description stays intact - use comments for updates
  - **Move issues forward**: Update issue status, labels, and milestones as work progresses
  - **Create sub-issues when needed**: Break down large issues into smaller, manageable sub-issues
  - **Reference issues in commits**: Use "fixes #123" or "refs #123" in commit messages to link work
  - **Close issues when complete**: Properly close issues when work is finished, with summary comment

- Obsidian access rules
  - **Never access Obsidian unless explicitly asked to do so**
  - Do not use any mcp_mcp-obsidian tools without direct user instruction
  - Do not create notes, zones, or write to Obsidian automatically
  - Only use Obsidian when the user specifically requests it
