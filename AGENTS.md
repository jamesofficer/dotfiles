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
- For `logro`: `[fix|feat|chore|docs]/<github-issue-number>/branch-description` (e.g. `fix/389/timer-completed-sets`)
- If unsure, use conventional commit style branch names (e.g. `feat/add-user-settings`).

# Rules for the code you write

1. **Think before you code.** For design decisions, give 2–3 options with their trade-offs and a recommendation. Do not use the first idea without question.
2. **Push back, and ask.** If a request seems wrong, say why and give an alternative before you start. If a request is not clear, ask. Do not guess. Then follow the user's decision.
3. **The best code is no code.** First, look for existing code, a library, or a platform feature that does the job. The best PRs remove more lines than they add. Delete dead code and commented-out code.
4. **Fix the root cause, not the symptom.**
5. **Code is for humans.** Write it to be read. Clear is better than clever. If a name is hard to find, the design is probably wrong.
6. **Keep coupling loose. Earn each abstraction.** Duplication is cheaper than the wrong abstraction. Wait for 2–3 real uses before you abstract.
7. **Make invalid states impossible and errors loud.** Use types so that bad data cannot exist. Do not hide errors or add silent fallbacks.
8. **Follow the codebase.** Use the patterns that are already there, not your own preferences.
9. **Leave it better than you found it.** When a refactor makes your change simpler, refactor the code you touch. Keep it small, and tell the user.
10. **Test behaviour, not implementation.** Each test must catch a bug that a user could see. A small number of good tests is better than many weak tests.

# Code style

- Avoid unnecessary comments — if the code is easy to understand on its own, don't comment it.
- Any comments written in code must be in ASD-STE100 Simplified Technical English.
- Write each comment in the fewest lines it fits in at the file's normal line width (about 80 characters if unsure). When a comment needs more than one line, taper it like a Laravel-style comment block: each line shorter than the line above it, ideally by 3-5 characters. Get the taper by rewording or moving a line break to a natural spot — the line count stays the same. If the line count and the taper conflict, the fewest lines wins.
- Separate control-flow blocks (`if`, `for`, `while`, `switch`, and `try`/`catch`) from surrounding statements with one blank line. Keep linked clauses such as `else`, `else if`, `catch`, and `finally` attached to the preceding block.

# React code style

## Architecture: lib → hook → component

Structure non-trivial React logic in three layers:

1. **Pure functions in `lib`.** Extract single-purpose, pure functions to a lib file (e.g. `src/lib/cropImage.ts`). No React imports, explicit input/output types, no side effects. Colocate the test file (`cropImage.ts` + `cropImage.test.ts`).
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

