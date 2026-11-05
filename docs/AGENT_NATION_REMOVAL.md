# Bismarck campaign setup: agent handoff

## Result and use

Implemented a standalone EU5 1.4 native decision: **Content (book/F9) → Decisions → Other → Apply Bismarck Campaign Setup**. Any human may use it once per campaign, **before April 1, 1338** (one year after the standard start). The fixed deadline and global completion variable gate visibility, eligibility and the effect itself, including stale open dialogs. Later starts are intentionally outside this window. No Faster Universalis, Community Mod Framework, Glorp, aliases or upstream GUI are required. Metadata already has an empty dependency list.

The verified local installation is `Documents/Paradox Interactive/Europa Universalis V/mod/bismarck_decision_test`. The applied **Bismarck Tuesday** playset contains only this tweaks mod. Repository implementation files were copied from staging only after the runtime tests passed. Temporary diagnostic decisions are excluded from the repository and removed from the installed scripts.

## Confirmed configuration

- **East Asia:** remove ownership, units, buildings and pops; reduce development and set rural rank; add permanent `bismarck_location_disabled`.
- **South America, Australasia, Pacific Islands:** remove ownership, units and buildings. Do not add the disabled modifier or depopulate them.
- **South Asia and Southeast Asia:** preserve them.
- Remove active Societies of Pops using the original conversion-to-building-country and building-removal effect.
- Keep Great Pestilence vanilla; no situation-ending hook is included.
- Retain original meritocracy compensation: first yearly country pulse at/after 1390 following setup gives 100 meritocracy progress to owned locations with a neighbor in East **or South** Asia, once globally. The South Asia condition is intentional, even though South Asia survives.

Removal abandons locations; it does not explicitly delete every country record. Countries retaining land outside the footprint can survive. Stored eliminated-country records are not proof that a country remains active.

## Execution and files

All paths below are relative to the mod root:

| File | Purpose |
|---|---|
| `in_game/common/decisions/bismarck_campaign_setup.txt` | Human-only, globally one-time native decision; concise tooltip and hidden effect |
| `in_game/common/scripted_effects/bismarck_campaign_setup.txt` | Setup, location stripping, subcontinent removal and meritocracy helpers |
| `in_game/common/on_action/bismarck_campaign_setup.txt` | Meritocracy yearly pulse; disabled-location ownership guard |
| `main_menu/common/static_modifiers/bismarck_campaign_setup.txt` | Population capacity/growth, migration and prosperity penalties |
| `main_menu/localization/english/bismarck_campaign_setup_l_english.yml` | Decision, option, tooltip and modifier names |

EU5 1.4.6 rejects the old `INJECT:create_colonial_charter` because charter creation is no longer a generic-action entry. The replacement uses native `on_location_changed_owner`: if a newly owned location has the disabled modifier, strip it and abandon it immediately. `has_owner` prevents recursion after abandonment. This rejects retained ownership; it does not grey out the charter-creation button in advance. No recurring world-removal sweep is used.

Do not expose the removal loops directly in decision tooltips: generating their descriptions hung the game. `custom_tooltip` plus `hidden_effect` resolved that. Native decision localization uses `<id>.title` / `<id>.desc`. New game script/localization files use UTF-8 BOM.

## Verification: EU5 1.4.6, November 2, 2026

Two independent campaigns used only the staged tweaks mod:

| Player | Decision applied | Stable endpoint | Month ticks crossed |
|---|---|---|---:|
| France | April 1, 1337 | September 5, 1337 | 5 |
| Delhi | April 1, 1337 | August 1, 1337 | 4 |

Both executed through the actual native decision UI and continued unpaused without a crash. Temporary debug decision requirements passed: target land unowned, East Asia land disabled and effectively depopulated, South Asia/SEA still owned, no active Societies of Pops. The setup disappeared after execution, and completion persisted through save/reload.

Save audits independently found the same results in both campaigns:

| Subcontinent | Owned locations after setup | Disabled locations |
|---|---:|---:|
| East Asia | 0 | 3,146 |
| South America | 0 | 0 |
| Australasia | 0 | 0 |
| Pacific Islands | 0 | 0 |
| South Asia | 1,202 | 0 |
| Southeast Asia | 893 | 0 |

East Asia modifier expiry is `9999.1.1` (permanent). No disabled location retained an owner. The game can reseed tiny pops despite depopulation/negative growth; Dadu reseeded about one person. This did not restore ownership.

A temporary UI test forcibly assigned disabled Dadu to France. Its save ownership history records **FRA → unowned on August 1**, proving the owner-change guard fired; regional checks still passed afterward. A full colonial-charter lifecycle was not tested.

Checkpoint labels in the game's save directory:

- `1337.9.5 - France BISMARCK_TEST_FRA_POST_GUARD` (`SP_FRA_1337_09_05_50f231da-54c4-4132-9696-04914a797107.eu5`)
- `1337.8.1 - Delhi BISMARCK_TEST_DLH_FOUR_MONTHS` (`SP_DLH_1337_08_01_33f5ed3a-73a8-41b1-8e05-19ff7d1c39c0.eu5`)

No errors naming the new Bismarck scripts occurred during these tests. Vanilla scripts logged invalid abandoned cabinet/province/market targets and missing `middle_kingdom` organization queries after removal; do not claim error-free logs. Short-run stability is verified, not a full campaign or multiplayer synchronization. The production threshold remains 1390; its pulse was runtime-tested with a temporary 1338 threshold (below).

## Expiry verification

A copy of the unused France September 1337 save was fixture-dated to March 31, 1338; only its metadata date and test label changed. This is boundary testing, not an additional year-long stability run. The decision was visible/eligible on March 31. Left its dialog open and unpaused one day: on **April 1** it disappeared from the list. Clicking the stale option closed the dialog without applying setup.

Post-click save audit: both setup/meritocracy completion flags absent, Dadu still owned, zero disabled modifiers anywhere, Sargadwari meritocracy 0 and Delhi 0.05829. The early-threshold pulse produced no additional execution marker in this unused campaign. Checkpoint: `1338.4.1 - France BISMARCK_TEST_EXPIRY_STALE_OPTION_REJECTED` (`SP_FRA_1338_04_01_50f231da-54c4-4132-9696-04914a797107.eu5`). Pre-boundary fixture: `BISMARCK_TEST_EXPIRY_MAR31_DATE_FIXTURE.eu5`. Final production build (1390 restored, checksum `b9aa`) started and reloaded the April 1 checkpoint successfully; setup remained hidden and no errors named the new Bismarck scripts. All five implementation files match the installed staging copy byte-for-byte.

## Meritocracy pulse and duplicate submissions

A temporary test build lowered only the threshold to 1338 and logged execution plus an engine-wide postcondition. Delhi's August 1337 checkpoint had no completion flag; Delhi progress was 0.00132 and Sargadwari 0. After normal unpaused simulation through January 1, 1339:

- Exactly one execution and one PASS log; zero FAIL logs.
- A temporary saved variable records firing year **1338**, not 1337. The exact day was not recorded; this is a yearly-country-pulse hook, not a promised January 1 event.
- Delhi and Sargadwari reached 100; Paris stayed 0. Every eligible owned location passed the 100-progress assertion.
- The completion flag persisted and prevented repeat execution into 1339.

Checkpoint: `1339.1.1 - Delhi BISMARCK_TEST_MERITOCRACY_1338_THRESHOLD` (`SP_DLH_1339_01_01_33f5ed3a-73a8-41b1-8e05-19ff7d1c39c0.eu5`). The installed and repository on_action were restored to 1390 with test logging/assertions removed.

Simultaneous multiplayer presses were reviewed, not runtime-tested. The setup helper rechecks the global flag, then sets it before any world mutations. Under ordered script execution a queued second submission is a no-op. No costs or rewards occur outside this guard. The guard also avoids repeated development subtraction and country conversion; coordinating one player remains sensible.

## Source trace

Workshop root: `D:/SteamLibrary/steamapps/workshop/content/3450310`.

- Faster Universalis `3662193478`: CMF registration in `fum_cmm_effects.txt` → CMF Apply callback → `fum_handle_cmf_callback` → `fum_apply_performance_settings` in `fum_scripted_effects.txt` → regional/subcontinent/location helpers.
- Community Mod Framework `3692202776`: stores configuration aliases and dispatches callback; it does not implement removal. Its installed version already targets 1.4.
- Published Bismarck `3723873282`: customized `fum_scripted_effects.txt` preserves South Asia/SEA in Europe Centric mode while retaining the other three removal targets. User confirmed this override.
- Upstream `fum_on_action.txt`: meritocracy compensation and separate Great Pestilence cleanup. Only compensation was retained.
- Upstream location exclusions cover Caucasus, Steppes and Egypt; none overlap the selected subcontinents, so the port needs no extra exclusion trigger.

See `AGENT_EU5_COMPUTER_TIPS.md` for resolved UI and testing obstacles.
