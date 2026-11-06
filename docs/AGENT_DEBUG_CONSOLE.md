# Debug console and Workshop evaluation

Tracks [issue #3](https://github.com/Ghostowl657/Bismarck-multiplayer-tweaks-EU5/issues/3).

## Source inspection (November 5, 2026)

[Free Console Access by Dsingis](https://steamcommunity.com/sharedfiles/filedetails/?id=3600131257)
was already downloaded. Its description explicitly permits reuse and modification.
The downloaded mod contains one gameplay file, `in_game/gui/ingame_topbar.gui`.
Compared with installed EU5 1.4.7, it adds an invisible dockable button invoking
`ExecuteConsoleCommand('debug_mode')`, using input action `top_right_10`
(advertised default Shift+F10). It otherwise copies the vanilla top-bar file.
This creates a whole-file compatibility obligation with UI mods and game updates.
The downloaded GUI SHA256 is
`16B09F545CD5F0105B1C9A97EF9F7339616B254E960E55AB3170064D505F2E6E`.
No Workshop code was imported during this initial inspection. The later
integration is recorded below.

## Preliminary Workshop run

EU5 **1.4.7 (Rio Salado)**, applied **Bismarck Tuesday** playset, with
**Bismarck multiplayer tweaks v3.0** and **Free Console Access v1** enabled.
The Mods & DLCs UI showed two enabled mods after Apply; logs also mounted the
Workshop path. Steam launched with configured `-debug_mode`. Observed checksum:
**75ec, debug on**. A subsequent direct, debug-off startup with the same two-mod
playset showed **b302**; this was a startup check only.

Continued the existing August 1, 1338 France checkpoint described in the alliance
and tea documents. Resolved the war-readiness event by postponing war, chose
state ownership in the Templar lands event, declined the salt-tax increase,
and dismissed routine notifications. Simulation advanced normally from
**August 1, 1338 to January 22, 1339**, over five months, crossing September,
October, November, December, and January updates. No console commands or date
jumps were executed. A natural Brittany war occurred during the run. No new
fixture or production script was added; the old checkpoint retains its previously
documented artificial tea setup.

Shift+F10 produced no observed debug toggle. This is **inconclusive**, since
ordinary injected keyboard shortcuts also failed; the console investigation below
identified an input problem. The simulated interval demonstrates preliminary
single-player smoke stability, not successful shortcut behavior or multiplayer
compatibility. EU5 was closed without saving the test campaign.

The Workshop GUI added an `Unlocalized text 'Enable debug_mode'` warning at
`gui/ingame_topbar.gui:685`. Other observed warnings matched earlier records:
Bismarck defines lacking BOM, map-sharing localization/message notices, database
size warnings, save-repair notices, and vanilla invalid `religious_figure`
references at `character_triggers.txt:87`. The newest crash directory remained
November 4. No new crash was observed.

## Console investigation

The user asked to resolve console visibility/input before further mod evaluation.
Disabled Free Console Access through Mods & DLCs > Apply, leaving only Bismarck
v3.0. Observed baseline checksums: **1a28, debug off** and **34c5, debug on**.
The diagnostic debug launch used Steam `-applaunch 3450310 -debug_mode`; its
configured launch options also supplied that flag, so logs showed it twice.
This was not a changed mod build. A directly spawned hidden diagnostic process
was stopped before launching the interactive Steam instance.

Installed `loading_screen/input_profile/default.profile` defines console as
scancode 53 plus Alt+C. The live settings UI displayed a blank primary binding
and Alt+Shift+C as the alternate. Neither grave nor that displayed chord visibly
opened the console. In the actual Remap input dialog, injected grave and F8
left the selected input blank, while an injected middle mouse click immediately
displayed `MOUSE MIDDLE`. Both the original Sky interface and the alternate CUA
wrapper failed to deliver usable keyboard shortcuts.

Temporarily assigned middle mouse to Enable/Disable Console window through the
normal Input Bindings UI. The game warned that this would clear Drag camera's
binding. After closing Settings and resuming to the still-paused campaign,
middle-click **visibly opened the normal translucent left console panel**.
Clicked its `Insert command ...` field and typed `help`: text appeared visibly.
Neither Return nor KP_Enter submitted it; no command output appeared and no
successful command execution is claimed. Middle-click closed the console again.
This verifies console rendering and text entry, but leaves native keyboard-event
delivery unresolved. A hidden console alone does not explain the remap result.

This diagnostic stayed paused on **August 1, 1338**; elapsed simulated months:
**zero**. It is input/UI coverage, not a stability run. No game scripts changed.
EU5 was exited to desktop without saving. The original `user.bindings` bytes
were preserved before confirmation and restored after exit, including the user's
existing max-zoom-out binding. The Workshop mod remains disabled in the playset.

## Successful scan-code diagnosis and Workshop behavior

The user explicitly authorized a Windows scan-code helper as an exception to
the computer-use skill's API-only restriction. `scripts/Send-Eu5ScanKey.ps1`
uses `SendInput` with `KEYEVENTF_SCANCODE`, holds the key for 100 ms, releases
keys in `finally`, restricts input to Grave, Enter, ShiftF10, or Escape, and
checks for exactly one visible process at the expected EU5 executable path.
It activates that game window and checks foreground identity before input.
The installation path can be overridden with `-GameExecutable`.

Baseline **34c5, debug on**, only Bismarck v3.0: helper Grave visibly opened
the console at the main menu. Focused its input and used the normal text tool
to enter `help debug_mode`; helper Enter executed it. The console visibly
returned `debug_mode` / `Toggles debug mode`, and `console_history.txt` recorded
the exact command. Helper Grave closed it. No binding changes were needed.
This confirms the previous failure was automated keyboard-event delivery,
not an unavailable console or a requirement to alter game definitions.

Re-enabled Free Console Access through Mods & DLCs > Apply. With the same
two-mod playset and **75ec, debug on**, loaded the original August 1 France
checkpoint. After dismissing the initial event, helper ShiftF10 removed purple
debug information from the live location tooltip; repeating it restored that
information. Helper Grave then opened the normal console, whose output showed
`debug_mode`, `Turning debug OFF`, and `Turning debug ON`. The green FPS counter
remained visible while debug details were off, so it is not a reliable toggle
indicator. The mod's original shortcut therefore works.

Closed the console, unpaused via the normal time control, resolved Templar lands
and salt taxation as in the preliminary run, and dismissed routine independence,
imperial-land, and English-influence reports. The run advanced normally from
**August 1, 1338 to January 22, 1339**, over five months, crossing September
through January updates after exercising the shortcut. The later Perigord event
was left unresolved when ending this disposable run. No date jumps or gameplay
console setup were used; the only executed gameplay command was the mod's own
`debug_mode` call. The same existing warnings remained; no new crash directory
appeared. The unsaved Workshop test process was deliberately stopped before
installing the final GUI; it was not reused as a final-build test.

## Integration

`in_game/gui/ingame_topbar.gui` incorporates Dsingis's invisible button and
`top_right_10` action, retaining its default Shift+F10 shortcut and rebinding
through the player's Top Right 10 setting. It invokes the engine's existing
debug-mode toggle; it adds no gameplay script or test decision. The file credits
the source. The original unlocalized tooltip was changed to `raw_tooltip` with
accurate toggle wording, and whitespace/indentation was cleaned. The GUI uses
UTF-8 BOM. Static comparison confirmed all retained vanilla GUI content matches
the installed EU5 1.4.7 file when whitespace and the added toggle are excluded.

This is a whole-file GUI override. Review it against future game versions and
merge conflicts with UI mods that replace `ingame_topbar.gui`. Do not enable the
separate Workshop copy alongside Bismarck. Multiplayer and long-term behavior
are not established by these single-player checks.

The final GUI SHA256 is
`A888989E4E66C8D549E8C4529E6202E5B7ED077207BA793CD0D207344C44A5F2`.
Installed content was audited against the repository: all **20** files under
`in_game`, `main_menu`, `loading_screen`, and `.metadata` matched, with no extras.

## Final production validation

EU5 **1.4.7 (Rio Salado)**, applied **Bismarck Tuesday**, only **Bismarck
multiplayer tweaks v3.0** enabled. Explicitly disabled the separate Workshop
copy through Mods & DLCs > Apply; the final clean launch's UI showed one enabled
mod. The GUI hash above did not change throughout these checks.

Final paired startup checksums observed at the main menu:

- **eeeb, debug on**, Steam launch with configured `-debug_mode`; confirmed
  again in a final fresh launch. This was startup/checksum coverage only.
- **a16c, debug off**, direct executable launch through the computer-use tool;
  startup log showed empty command-line arguments. The pause menu also showed
  **a16c** after the runtime check.

The direct launch does not initialize Steam integration, but mounts the applied
local production mod. It loaded the original August 1 France checkpoint. After
postponing the initial war-readiness event, helper ShiftF10 enabled debug mode
from this clean debug-off process: the live location tooltip gained purple
debug data. Helper Grave opened the normal console, whose output explicitly
showed `debug_mode` and `Turning debug ON`. Closed it with Grave and pressed
ShiftF10 again: purple debug data disappeared. No separate console command was
typed in this production campaign. This verifies re-enabling debug without
requiring the startup flag, as well as disabling it again.

With debug **off**, unpaused through the normal time control. The final build
advanced **August 1 to November 30, 1338**, over three months, crossing September,
October, and November updates. Chose state ownership of Templar lands and
declined the salt-tax increase; dismissed routine independence, imperial-land,
and English-influence reports. A natural Brittany war report paused the run on
November 30. Opened the pause menu to stop at that date. No console date jump,
test fixture, or edited save was used. This single-player test does not establish
multiplayer synchronization or long-term stability.

The final runtime logs contained no `ingame_topbar`, `free_console`,
`top_right_10`, or `debug_mode` errors. In particular, the Workshop's
`Enable debug_mode` localization warning was absent. Existing map-sharing
message/localization notices, database-size warnings, DLC backend notices,
save-repair notices, and the existing defines BOM warning remained. The earlier
vanilla `religious_figure` error was not observed in this final debug-off run.
The newest crash directory remained November 4. The production run was closed
without saving after completion; its process was deliberately stopped after the
exit control did not respond reliably to injected mouse clicks. A fresh debug-on
startup reconfirmed **eeeb** and was closed afterward. No test game was left open.

Static checks verified BOM, balanced GUI braces, unchanged vanilla content
outside the toggle (ignoring whitespace), valid PowerShell syntax, and matching
root instruction files. Git whitespace checks passed. The previously staged
AGENTS.md/CLAUDE.md edits were preserved. The input helper changes no bindings,
and the original user binding file remained restored.
