# Vanilla override audit

Read-only source audit on November 6, 2026 against installed EU5 1.4.7. No files listed below were refactored. This is a static comparison, not a runtime test, and introduces no gameplay build/checksum.

## Candidates

| Existing override | Current change | More focused alternative |
|---|---|---|
| `in_game/common/building_types/foreign_buildings.txt` (479 lines) | Only `colonial_administration.modifier`: merchant capacity and power 0.2 -> 0.5 | A new file with `INJECT:colonial_administration = { modifier = { ... } }`, after verifying nested modifier replacement semantics. |
| `in_game/common/government_reforms/republic.txt` (287 lines) | Only `merchant_republic.country_modifier`: capacity 0.50 -> 0.35 and trade income 0.20 -> 0.10 | Targeted `INJECT:merchant_republic` with the two nested scalar changes, after checking merge semantics. |
| `main_menu/common/static_modifiers/location.txt` (4,458 lines) | `winter_normal.local_navy_attrition` 5 -> 0 and `winter_severe.local_navy_attrition` 10 -> 0 | Two small `INJECT:` entries. |
| `in_game/common/generic_actions/government_conversions.txt` (559 lines) | Six conversion thresholds: absolute societal-value requirement 95 -> 60 | Per-action `REPLACE:` entries are preferable unless injection supports replacing the specific nested repeated `allow`/`OR` conditions. Do not blindly append looser conditions: the original stricter requirements would remain. |
| `main_menu/localization/english/cultural_and_languages_l_english.yml` (2,825 lines) | Only `low_franconian`: Low Franconian -> Dutch | A dedicated localization override under `english/replace`, containing one key. Script `INJECT` does not apply to localization. |

The current branch also carries the unchanged 669-line vanilla `in_game/gui/ingame_topbar.gui` baseline. The debug-toggle branch modifies this GUI; database `INJECT` is not established for GUI widget trees. Investigate GUI extension mechanisms separately rather than mechanically applying script directives.

## Other observations

The tea implementation already uses `INJECT:tea`. The player-alliance implementation already uses `REPLACE:alliance_can_exist` rather than a whole vanilla trigger file. The new fort rules use small `INJECT:` entries and new triggers; the vision relation is wholly new code.

The custom player map-sharing interactions are new identifiers, not same-path vanilla-file overrides. Defines use a separate file. Their correctness or possible further deduplication was outside this audit.

All alternatives require game validation of replacement/merge behavior in a future session. Retain the source/version and baseline-history requirements when undertaking that work.

