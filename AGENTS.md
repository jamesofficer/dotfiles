# Communication style

- Always reply in ASD-STE100 Simplified Technical English.
- Avoid technical jargon. When a technical term is unavoidable, briefly explain it in simple words the first time you use it.
- Brevity is good. You don't need to write an essay to explain a change.

# Workflow

- Don't commit by default — only commit when explicitly asked to.
- Use conventional commits (`feat:`, `fix:`, `chore:`, etc.).
- When writing or updating a PR description, keep it high level and easy to understand. Lead with why the changes were made and what they achieve, not a detailed technical list of every change.
- Use `pnpm` as the preferred package manager.
 
# Git branch naming

- For packages in the `instant` repo: `jo/[fix|feat|chore]/DEV-XXXX-branch-description` (e.g. `jo/fix/DEV-1819-address-review-stars-feedback`)
- For `logro`: `[fix|feat|chore]/LOG-XXX/branch-description` (e.g. `feat/LOG-123/add-user-settings`)
- If unsure, use conventional commit style branch names (e.g. `feat/add-user-settings`).

# Code style

- Avoid unnecessary comments — if the code is easy to understand on its own, don't comment it.
- Any comments written in code must be in ASD-STE100 Simplified Technical English.

# React code style

## Architecture: lib → hook → component

Structure non-trivial React logic in three layers:

1. **Pure functions in `lib`.** Extract single-purpose, pure functions to a lib file (e.g. `src/lib/cropImage.ts`). No React imports, explicit input/output types, no side effects. Colocate the test file (`cropImage.ts` + `cropImage.test.ts`) and cover it thoroughly.
2. **A hook per responsibility.** Wrap the lib function in a hook (e.g. `useCropImage`) that only orchestrates: it calls the lib function and manages async/loading/error state, or wires it into a data-fetching library. Business logic stays in the lib layer, not the hook.
3. **The component consumes the hook(s).** Keep the component focused on wiring hook output to JSX.

Rules:

- Skip the hook layer when it's overkill — for small, one-off logic, call the lib function straight from the component.
- Split hooks by responsibility (`useCropImage`, `useSaveImage`, `useImageAdjustments`) rather than one large hook (`useEditImage`).
- Name a hook after the lib function it wraps, so the mapping between layers stays obvious.
- Keep hooks flat — avoid a hook calling another domain hook, since this hides coupling and makes each hook harder to test alone.
- Since logic lives in well-tested lib functions, hooks and components only need thin tests for wiring and rendering.

- Declare components with the `function` keyword, not arrow functions.
- Functions inside components should also use the `function` keyword over arrow functions: `function myFunc() {}`
- Never declare a function below a component's `return`. Hoisting makes it work, but it reads as unreachable code, and it only works for `function` declarations, so it breaks the moment someone changes it to an arrow function. Helper functions go above the return, as the hierarchy below shows.
- Do not add a `renderSomething()` helper only to hold a branch of JSX. Handle loading and error states with early returns, keep a small choice as a plain branch in the JSX, and extract a component when a branch grows. A helper that returns JSX and is called once is a component in the wrong shape.
- Name a component's props `interface Props {}` — unless the props need to be exported, in which case give them a descriptive exported name (e.g. `export interface MyComponentProps {}`).
- Extract reusable components into their own files where possible. Avoid creating giant components that are difficult to understand and maintain.
- Use Tanstack Query and Tanstack Router where possible, when available. Avoid doing data mutations in useEffect's for example if Tanstack Query if available (unless necessary).
- Try to follow the follow code heirachy in components:
    - Refs
    - Global hooks & global state
    - Local state, useState etc
    - useEffect's, useLayoutEffect's etc
    - Component functions
    - Early returns
    - JSX/Template code

