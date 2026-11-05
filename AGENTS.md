# Agent instructions

## Workflow and documentation

- Read the relevant files in `docs/` before changing the mod. Use `docs/AGENT_LOCAL_PATHS.md` for local installations; copy the example if needed.
- Preserve unrelated user changes. Keep changes focused and follow the existing EU5 script and localization conventions.
- Put documentation, mod-change explanations, test evidence, and handoffs in `/docs`; only `AGENTS.md` and `CLAUDE.md` belong at the root. Update the relevant feature document with behavior, affected files, validation, and limitations.
- Add only verified, reusable workflows to `docs/AGENT_EU5_COMPUTER_TIPS.md` that would help an agent testing an unrelated feature. Keep feature-specific goods, dates, locations, save names, and test results in the feature document instead; generalize and deduplicate tips before adding them.
- Keep `AGENTS.md` and `CLAUDE.md` byte-for-byte identical. Edit both together and stage both. Run `./scripts/install-hooks.ps1` once per checkout to enable the equality check; see `docs/DEVELOPMENT.md`.

## Testing mod changes

- Test the actual production mod in EU5 under conditions as close to real play as possible. Confirm the intended mod/playset is applied, exercise the normal player UI, and verify the resulting behavior.
- Agents always have authority to choose any event options needed to continue a test campaign. Resolve event dialogs and resume play without asking for permission.
- Use console commands wherever practical to set up tests as a human tester would, including changing the date to reach a production event's real threshold. Verify command syntax in the installed game. Do not lower production dates or change event conditions just to make a test pass.
- Do not rely heavily on temporary test scripts, diagnostic decisions, or edited-save fixtures. Use them only when normal UI and console setup cannot cover a necessary check, explain why, and distinguish fixture coverage from normal gameplay coverage.
- After exercising the change, unpause and advance through at least three in-game months, crossing monthly updates. Resolve pauses and confirm the date actually advances. A test that never unpauses is not conclusive; a console date jump does not count as simulated stability time.
- Inspect relevant game logs and observable outcomes; use saves as supporting evidence when useful. Remove any temporary instrumentation, restart if definitions may be cached, and verify the final production build with the same unpaused stability requirement.
- Record the game version, active mods, setup/console commands, actions, observed results, start/end dates, elapsed simulated months, log findings, and remaining gaps in the feature document. Distinguish pre-existing/vanilla errors from errors caused by the change. Do not claim multiplayer or long-term stability from a single-player smoke test.
- Static checks, log inspection, startup, and paused UI checks supplement runtime testing; they do not replace it. If runtime testing is unavailable, report the change as unverified and explain the blocker. Documentation/hook-only changes need appropriate file/hook checks rather than a game run.
