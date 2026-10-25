# My Development Environment

## System & Tools
- OS: NixOS

## Nix Shells
- Always use `nix-shell` or `nix develop` for project dependencies
- Check for `shell.nix` or `flake.nix` in project root before installing packages
- Run commands inside the nix-shell environment, not the host system
- Example: `nix-shell -p nodejs python3 --run "npm install"`

## Code Style
- 2-space indentation (no tabs)
- Line length: 100 characters max or use language formatter default
- Don't style code comments, they should be short and explain feature

## Markdown Documentation Style
- Never use emojis
- Try to be conceise and technical
- Use headings `#` and separators `---` only when sections aren't fully connected directly

## Naming Conventions
- Files: kebab-case (my-component.ts)
- Classes: PascalCase
- Functions/variables: camelCase
- Constants: UPPER_SNAKE_CASE

## Workflows
- Always run tests and formatters before committing
- Use feature branches: `feature/description`
- Commit messages: use conventional commits 
