# Workflow

- Don't commit by default — only commit when explicitly asked to.
- Use conventional commits (`feat:`, `fix:`, `chore:`, etc.).
- When writing or updating a PR description, keep it high level and easy to understand. Lead with why the changes were made and what they achieve, not a detailed technical list of every change.
- Use `pnpm` as the preferred package manager.

# Code style

- Avoid unnecessary comments — if the code is easy to understand on its own, don't comment it.

# Git branch naming

- For packages in the `instant` repo: `jo/[fix|feat|chore]/DEV-XXXX-branch-description` (e.g. `jo/fix/DEV-1819-address-review-stars-feedback`)
- For `logro`: `[fix|feat|chore]/LOG-XXX/branch-description` (e.g. `feat/LOG-123/add-user-settings`)

# React code style

- Declare components with the `function` keyword, not arrow functions.
- Functions inside components should also use the `function` keyword over arrow functions: `function myFunc() {}`
- Name a component's props `interface Props {}` — unless the props need to be exported, in which case give them a descriptive exported name (e.g. `export interface MyComponentProps {}`).

# Communication style

- Use plain, easy-to-understand English in all explanations and summaries.
- Avoid technical jargon. When a technical term is unavoidable, briefly explain it in simple words the first time you use it.
- Prefer short sentences and everyday words over dense or academic phrasing.
- Explain concepts the way you would to a smart colleague who doesn't work in this codebase, not to a compiler.
- When describing what a change does, focus on the outcome and why it matters, not the low-level mechanics — unless asked for detail.
