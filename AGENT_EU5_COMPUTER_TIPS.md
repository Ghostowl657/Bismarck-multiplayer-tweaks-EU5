# EU5 computer-control tips

Record resolved obstacles and verified workflows here during testing.

- EU5 startup can exceed sky.launch_app's window timeout. After the timeout, refresh sky.list_windows before assuming startup failed. Select the returned game window and activate it; captures can include unrelated windows until EU5 is foregrounded.
- Local runtime tested is EU5 1.4.6 (Rio Salado). Keep proposed files in Documents/mod/bismarck_decision_test until verified.

- Decisions live under the top-left book icon (Content/F9), then Decisions; the rightmost category is Other. The scroll-shaped alert is government reforms, not decisions.
- Long-lived tooltips can intercept clicks on underlying controls. Click an empty area to dismiss, refresh, then click the intended button.
- Ctrl+A did not select the save-name field in this run; typed text appended. A BISMARCK_TEST_FRA_BASELINE labeled save was successfully written (SP_FRA_1337_04_01_50f231da-54c4-4132-9696-04914a797107.eu5).
- The in-game Exit button opens an Exit to Menu / Exit to Desktop chooser. Save disposable test state before opening it.

- IMPORTANT: Editing playsets.json does not apply the playset. Main menu -> Mods and DLCs (bottom-right castle) -> dropdown -> Bismarck Tuesday -> Apply. The default playset can remain applied with 0 mods despite a correct saved playset. Discovery mount messages in debug.log do not establish active mods.

- Native decisions use <id>.title and <id>.desc localization, not <id> and <id>_desc. All new script text should have UTF-8 BOM to avoid lexer warnings.
- EU5 1.4.6 rejects INJECT:create_colonial_charter: the action is no longer a generic-action database entry. Replaced with the native on_location_changed_owner hook, checking the disabled modifier plus has_owner to avoid recursion. Verified: a temporary decision assigned Dadu to France; its save ownership history immediately recorded FRA then --- on 1337.8.1. Regional invariants remained green.
- Avoid exposing world-scale loops in decision tooltips. Use a concise custom_tooltip and hidden_effect; repeated attempts to open the original decision stalled, consistent with expensive effect-description generation (verified after restart: dialog and execution both worked).

- Non-escalated Get-Process did not show host EU5 processes. An escalated read revealed BOTH launches were still running: the hidden launch and the foreground sky launch. Do not relaunch after a window timeout until checking host processes with the required permissions. Both agent-created processes were stopped after saving the paused baseline; restarted one visible EU5 in its binaries working directory with -debug_mode.

- Launch with -debug_mode to make subsequent saves readable SAV0300 text. Ordinary saves are SAV0303 binary/ZIP; do not assume .eu5 is always text. The metadata locations list maps one-based numeric location IDs to names; live records are locations.locations.<id>. Population pop IDs are nested one level deeper, in population.pops.
- After depopulating, EU5 reseeds tiny populations (Dadu ~0.00092 thousand after two ticks), even with negative capacity/growth. Check that countries remain absent and ownership guard works rather than assuming any_pop remains false forever.
- User explicitly permits choosing routine event/diplomatic outcomes freely in disposable BISMARCK_TEST campaigns.

- Country selection: top-right flag button opens a searchable list; the adjacent list icon opens Game Rules. Search results may need a fresh observation after typing before the list updates. Delhi is searchable directly.
- Temporary diagnostic decisions can check engine-level invariants using allow conditions. Remove their definitions and localization before shipping. Reloading a save can pick up additions but does NOT reliably remove cached decision definitions. A removed definition remained visible with a raw localization key. Fully restart EU5 after removing diagnostic definitions; localization alone can hot-reload while the old decision stays cached.
- Do not infer active Societies of Pops from every stored type=pop country record: eliminated countries retain serialized data. The engine any_country predicate is the useful active-country check.
- Save parsing must match country records with country_name; numeric IDs are reused across database sections. Do not select the first numeric record in the file.

- After the user authorized disposable event choices, select an event option directly; no timeout is needed. Many diplomatic notifications do not pause simulation. Check the date again before labeling checkpoints.

- Multiplayer duplicate-click review: the completion flag is rechecked inside the setup helper and set before mutations. There are no unguarded option costs. Sequential duplicate submissions should therefore be no-ops; lockstep concurrency has not been runtime-tested.

- If an open decision covers a pausing event, drag the decision by its title bar to one side. This exposes event choices and diplomatic notice OK buttons without closing or executing the decision; useful for testing stale dialogs across a deadline.

- Expiry boundary testing: a disposable SAV0300 copy can use a fixture metadata date and clearly marked save_label, preserving the metadata byte length and original save. A March 31, 1338 fixture loaded successfully; unpausing one day reached April 1. Treat fixture results as date/guard coverage, not natural campaign stability. The runtime save after a stale-option click is the evidence for whether the effect ran.
- The yearly meritocracy compensation hook fired once in 1338 with a temporary 1338 threshold. Save a temporary numeric current_year variable and assert all eligible locations have 100 progress to verify timing/results. Restore the production 1390 threshold and remove instrumentation before shipping.
