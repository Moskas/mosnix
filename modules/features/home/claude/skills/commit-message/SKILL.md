---
name: commit-message
description: Formats commit messages following project conventional commits structure.
---

Write commit messages following this format

## Structure
```
<type>: <short description>

<optional body explaining what, not why>
```

Types:
- `feat`: New Feature 
- `fix`: Bug Fix
- `docs`: Documentation only
- `refactor`: Code change that neither fixes bug nor adds feature
- `chore`: Build process, dependencies, or tooling changes
- `test`: Adding or updating tests

Rules:
- Summary line under 50 characters
- Use imperative mood ("add" not "added")
- No period at the end of summary
- Body wrapped to 72 characters
