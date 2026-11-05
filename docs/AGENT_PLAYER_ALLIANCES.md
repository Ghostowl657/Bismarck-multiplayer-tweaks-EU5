# Player alliances

Implements [issue #4](https://github.com/Ghostowl657/Bismarck-multiplayer-tweaks-EU5/issues/4).

## Behavior and affected files

`in_game/common/scripted_triggers/zz_bismarck_alliance_triggers.txt` uses
`REPLACE:alliance_can_exist` to replace only the named vanilla trigger. Both
countries must have `is_ai = no` to bypass the two nonnegative opinion checks.
Human–AI and AI–AI pairs still require nonnegative opinion in both directions.
Every other condition is copied from the installed EU5 1.4.7 definition,
including subject diplomacy, rivals, blocked treaties, unions, coalitions,
rebels, alliance permissions, hegemons, and opposing Hussite Wars sides.

The vanilla alliance relation is unchanged. It calls this trigger for both
offers and automatic expiry, so opinion alone cannot expire an alliance while
both countries are human. If either becomes AI-controlled, normal opinion
requirements apply again. Human recipients still choose whether to accept.
Other mods replacing the same trigger can conflict; future vanilla updates to
this trigger must be reviewed and incorporated.

The historical implementation in commit `0007c5d` changed each country's own
opinion check to `opinion >= 0 OR is_ai = no`, also affecting human–AI pairs.
Commit `2b5c5d2` removed it during the 1.4 cleanup. This version intentionally
implements the user's narrower two-human rule.

## Static validation

Compared the replacement against installed vanilla after removing only the two
original opinion lines and the new opinion gate: all remaining conditions match
exactly. Production contains exactly two `is_ai = no` checks. The tea change is
reviewed separately in [AGENT_TEA_EXCHANGE.md](AGENT_TEA_EXCHANGE.md).

## Runtime validation

Testing uses EU5 **1.4.7 (Rio Salado)**, applied playset **Bismarck Tuesday**,
with only **Bismarck multiplayer tweaks v3.0** enabled. The initial production
debug-on menu checksum was **49b7**. Initial startup with a bare duplicate key
logged `Duplicated key alliance_can_exist will not be created`; the explicit
`REPLACE:` directive removed this error. That rejected initial build's checksum
was not observed and is **unknown**.

No checksum is stored in game script code.

### Synthetic branch coverage

The temporary debug-on fixture replaced only the two `is_ai = no` checks with
`has_variable = bismarck_fixture_human`. Temporary decisions assigned flags,
applied a -500 opinion modifier to France and Portugal in both directions
(displayed opinions capped at **-200**), and added a rivalry. The normal
**Offer Alliance** UI demonstrated:

- France flagged, Portugal unflagged: both opinion requirements failed; the
  tooltip showed the first flag passing and the second flag failing.
- Both flagged: the normal offer confirmation opened despite both -200
  opinions. Portugal's AI acceptance score still prevented submission, as
  expected; the fixture does not override AI acceptance.
- Both flagged plus rivalry: the combined opinion gate passed, but the
  separate rivalry condition failed and prevented opening the offer.

This directly verifies the `REPLACE:` override is used by the normal alliance
action. The fixture was needed because single-player cannot provide two real
human-controlled countries. Grave and Shift+grave did not open a usable console;
no console commands were executed or claimed as verified. The fixture campaign
started from the unedited March 1, 1338 France checkpoint described in the tea
document, retaining that save's historical artificial exchange setup.

The fixture run was interrupted by an account usage limit while paused on an
event, then resumed after the user's instruction to continue. Paused wall-clock
time is not counted as simulated stability time.

The observed fixture checksum was **4c30**, debug **on**; its debug-off checksum
was not captured and is **unknown**. Simulation advanced normally from
**March 1 to July 12, 1338**, over four months, crossing April, May, June, and
July monthly updates. Routine outbreak, ruler, and English-influence dialogs
were resolved through the UI. The rivalry became invalid and was removed by
the game at a later monthly update; its blocking condition was checked before
that removal. No fixture, alliance-trigger, tea, or Curitiba errors appeared.
Pre-existing vanilla `religious_figure` errors at `character_triggers.txt:87`
and vanilla unit-window missing-input-action warnings were present. The newest
crash directory remained dated November 4. The fixture campaign was discarded
and EU5 closed before restoring production definitions.

### Production behavior and first stability run

All three fixture files (decisions, opinion bias, and localization) were removed,
the exact repository trigger was restored, and EU5 was fully restarted. A
SHA256 comparison of every installed file under `in_game`, `main_menu`,
`loading_screen`, and `.metadata` matched the repository, with no extra files.
This build's observed checksums are **49b7 with debug on** (initial clean
startup) and **9df8 with debug off** (post-fixture restart). The code did not
change between those clean observations. This simulation used debug off.

The Mods & DLCs UI again showed **(Applied) Bismarck Tuesday**, with only the
v3.0 Bismarck mod enabled. Continue loaded the original **March 1, 1338**
checkpoint, without saving or reusing the synthetic alliance campaign.

- France–Portugal: natural opinions **+31.93** and **+24.76**; normal Offer
  Alliance confirmation opened. AI acceptance remained separate and negative.
- France–England: the normal requirements tooltip showed both nonnegative
  opinion checks failing and both rivalry restrictions failing. The human–AI
  pair did not receive the exception.

This production debug-off run advanced **March 1 to August 1, 1338**, five
simulated months with April through August monthly updates, resolving routine
events. A normal checkpoint was saved as
`SP_FRA_1338_08_01_199aa3d2-dc4a-41a1-87cf-5f9e87499cbd.eu5`.
No alliance, fixture, tea, or Curitiba errors appeared; startup logged existing
map-sharing message/localization warnings, DLC backend notices, database-size
warnings, and vanilla save-repair notices. No new crash directory appeared.

A final whitespace check removed one trailing space copied from vanilla. This
does not change the trigger logic; the exact cleaned file is restarted and
checked again below, including another three-month production interval.

### Final file checksums and restart

The whitespace-cleaned final production file was installed and fully restarted
with debug on; the observed main-menu checksum was **34c5**. This was a startup
checksum check, not a separate debug-on stability run. The change from the
earlier checksum illustrates why checksums are observed rather than inferred,
even for whitespace-only edits. EU5 was closed before the debug-off restart.

The final debug-off checksum was **1a28**, observed at the main menu and in
the pause menu. An additional SHA256 audit confirmed the installed production
files match the repository with no extras. Continue loaded the clean August 1
checkpoint. Simulation advanced from **August 1, 1338 to January 22, 1339**,
over five months, crossing September, October, November, December, and January
monthly updates without console date jumps. Routine Templar-land, taxation,
subject, war, and siege dialogs were resolved through the UI. The campaign
entered a vanilla war during the run; this was not a controlled alliance war
participation test.

After pausing on January 22, Finder > Kuri > Kuri'tyba opened the South American
location. Its normal location panel and tooltip both still showed **Tea** as
the raw material, owned by France. No alliance-trigger, fixture, tea, or Curitiba
errors were logged. Existing startup map-sharing localization/message warnings,
DLC backend notices, database-size warnings, and vanilla save-repair notices
were present; the newest crash directory remained dated November 4. This is
single-player smoke coverage, not an error-free-log or multiplayer claim.

Both final checksums therefore refer to the exact delivered scripts:
**debug on 34c5; debug off 1a28**. The final run was not saved over the earlier
checkpoints. EU5 was closed at completion. Static checks also confirmed balanced
braces, UTF-8 BOM, no production fixture markers, unchanged non-opinion vanilla
conditions (ignoring whitespace), and clean Git whitespace checks.

## Limits

A single-player run cannot satisfy the real two-human predicate. Synthetic
coverage replaces only those two checks with per-country test flags. It does
not prove genuine multiplayer behavior, human disconnect/reconnect handling,
or synchronization. The synthetic UI checks cover offer eligibility, not a
formed human–human alliance persisting at negative opinion; expiry's use of
the same trigger was verified from the vanilla relation definition. The runtime
non-opinion regression check covers rivalry; the other retained restrictions
were compared statically. No multiplayer or long-term stability claim is made.
