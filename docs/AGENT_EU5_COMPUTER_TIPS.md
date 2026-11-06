# EU5 computer-control tips

Keep only verified workflows that help test unrelated features. Feature behavior and test results belong in the feature documents linked from [DEVELOPMENT.md](DEVELOPMENT.md).

## Launching and configuring the game

- Startup can exceed a launch tool's window timeout. Refresh the window inventory and check for an existing game process before launching again; activate the game before capturing or clicking.
- Apply the intended playset through Main menu > Mods and DLCs > playset dropdown > Apply. Editing the saved playset configuration or seeing discovery/mount messages in logs does not prove the mod is active.
- Launch with `-debug_mode` when readable saves are needed. Debug saves can use SAV0300 text; ordinary saves can use SAV0303 binary/ZIP. Inspect the format rather than assuming every `.eu5` file is text.
- Fully restart after removing temporary script definitions. Reloading a save may retain cached definitions even when localization has hot-reloaded.

## Navigating and keeping simulation running

- Decisions are under the top-left book icon (Content/F9), then Decisions; the rightmost category is Other. The scroll-shaped alert opens government reforms.
- Dismiss persistent tooltips by clicking empty space, then refresh the view before clicking the intended control.
- The top-right flag opens searchable country selection; the adjacent list icon opens Game Rules. Observe again after typing because results may update asynchronously.
- If one dialog covers a pausing event, drag it by its title bar to reveal the event choices. Resolve events and resume simulation; check the displayed date to confirm progress.
- Verify save-name fields after typing: Ctrl+A may not select the existing text, and new text may append.
- The in-game Exit button opens a choice between the main menu and desktop. Save test state before leaving.
- The normal console is a translucent panel on the left with an `Insert command ...` field above its toolbox. Confirm visibility by focusing the field and observing typed text; confirm execution separately from text entry.
- If injected shortcuts appear ineffective, test them in Settings > Input Bindings > Remap input. A blank capture while mouse input is recognized indicates an automation input problem. Temporarily binding the console to middle mouse can expose it for diagnosis, but clears Drag camera's binding; preserve and restore the original user bindings after closing the game.
- With an explicit user exception to the computer-use skill's API-only restriction, `scripts/Send-Eu5ScanKey.ps1 -Key Grave` and `-Key Enter` send working Windows scan-code input. The helper also supports `ShiftF10` and `Escape`; it checks the installed executable and requires exactly one visible game process, then verifies EU5 is foreground before sending. Override `-GameExecutable` for a different installation. In the verified workflow, open the console with Grave, focus its input, enter text through the regular computer-use tool, submit with the helper's Enter, then capture a fresh screenshot: the immediate text-entry screenshot can precede the rendered update. The green FPS counter may remain after turning debug off; verify purple debug details or the console's ON/OFF response instead.

## Scripts and supporting evidence

- Native decision localization uses `<id>.title` and `<id>.desc`. Use UTF-8 BOM for new EU5 script/localization files to avoid lexer warnings.
- Expensive effect loops can stall tooltip generation. Use a concise `custom_tooltip` and `hidden_effect`, then verify both the UI and execution.
- In readable saves, the metadata location list maps one-based numeric IDs to names; live locations are in `locations.locations`, and pops are in `population.pops`.
- Numeric record IDs can recur in different save sections. Parse the intended section and identify country records by `country_name`, rather than taking the first numeric match.
- Serialized eliminated-country records do not establish that a country is active. Use engine predicates or observable gameplay as supporting checks.
- Edited-save fixtures and console date jumps can cover boundaries, but do not demonstrate elapsed simulation stability. Follow the unpaused testing requirements in the root instructions.
