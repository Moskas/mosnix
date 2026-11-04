# My Development Environment

## System & Tools
- OS: NixOS
- Package management: Nix flakes
- Prefer declarative configuration over imperative system changes
- Never use system package managers (apt, pacman, etc.)

## Code Style
- Follow existing project conventions before applying global preferences
- Use 2-space indentation (no tabs), unless the language or formatter specifies otherwise
- Prefer a maximum line length of 100 characters
- Respect existing formatter and linter configurations
- If no formatter exists, prefer language-standard formatting tools
- Keep comments concise and focused on explaining non-obvious behavior

## Markdown Documentation Style
- Never use emojis
- Keep documentation concise, technical, and factual
- Prefer clear headings and short paragraphs
- Avoid unnecessary introductory or concluding sections

## Naming Conventions
- Follow existing project conventions where established
- Files: kebab-case (`my-component.ts`)
- Classes: PascalCase
- Functions and variables: camelCase
- Constants: UPPER_SNAKE_CASE

## Workflows
- Inspect the project structure and existing conventions before making changes
- Prefer minimal, focused changes over unnecessary refactoring
- Run relevant tests, linters, and formatters before committing
- Do not commit unless explicitly requested
- Use Conventional Commits for commit messages
- Never overwrite or discard existing user changes

## Agent Behavior
- Understand the existing implementation before proposing changes
- Ask for clarification when requirements are ambiguous
- Explain non-obvious decisions and trade-offs
- Do not introduce abstractions or dependencies without a clear benefit
- Prefer straightforward solutions over premature optimization
