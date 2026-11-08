# Vanilla override audit

Originally audited on November 6, 2026. Rechecked on November 7 against the installed EU5 1.4.7 (Rio Salado) files. All five same-path overrides match the vanilla files apart from the changes below, ignoring line endings. This refactor moves the five existing changes into targeted overrides on the tea and fort-spacing branch.

## Override scope

Before the refactor, the mod supplied each listed file at its original vanilla path. For supported script databases, `REPLACE:<id>` in a separate file replaces one complete named definition, so its body must include any vanilla fields that should survive. `INJECT:<id>` feeds extra fields into the existing definition. The receiving database determines how it handles a repeated field or block. A clean load alone cannot show that an old value was removed.

| Former whole-file override | Retained behavior | Targeted override |
|---|---|---|
| `in_game/common/building_types/foreign_buildings.txt` | `colonial_administration.modifier` raises merchant capacity and power from 0.2 to 0.5 each. | `building_types/zz_bismarck_foreign_buildings.txt` replaces the complete building. The proposed injection yielded +0.70 for both values in Europedia. |
| `in_game/common/government_reforms/republic.txt` | `merchant_republic.country_modifier` lowers merchant capacity from 0.50 to 0.35 and trade income from 0.20 to 0.10. | `government_reforms/zz_bismarck_republic_reforms.txt` replaces the complete reform. The injection showed the original +50% capacity and +20% income alongside +35% capacity and +10% income. |
| `main_menu/common/static_modifiers/location.txt` | Removes 5 normal and 10 severe winter naval attrition by setting `local_navy_attrition` to 0. | `static_modifiers/zz_bismarck_winter.txt` replaces both complete winter definitions. Injecting zero left the +5 and +10 naval attrition visible in the winter tooltips. |
| `in_game/common/generic_actions/government_conversions.txt` | Six societal-value thresholds move from ±95 to ±60, preserving the direction of each comparison. | `generic_actions/zz_bismarck_government_conversions.txt` replaces six complete actions and preserves the surrounding `allow` logic, including the monarchy-to-republic `trigger_else` and the theocracy-to-republic `OR`. |
| `main_menu/localization/english/cultural_and_languages_l_english.yml` | `low_franconian` changes from “Low Franconian” to “Dutch”. | `main_menu/localization/english/replace/bismarck_cultures_l_english.yml` overrides the single key through the localization loader. |

The current branch also carries the unchanged vanilla `in_game/gui/ingame_topbar.gui` baseline. The debug-toggle branch adds a button to an existing widget. GUI extension remains a separate investigation.

The installed Across the Pillars DLC uses `INJECT:crown_castile_reform` in `in_game/common/government_reforms/d009_country_specific.txt` to add a second `country_modifier` block with its own condition. This matches the separate modifier blocks seen in the Merchant Republic test.

Applying the extracted entries and culture key to the installed vanilla files reconstructs the former mod files after accounting for BOMs, whitespace, and the internal production-method ID described below. The existing base-branch commit `64a823a` records the original EU5 v1.4 import. This refactor reuses that import.

The first production candidate reused the vanilla building's unique production-method ID. EU5 reported a duplicate registration during debug startup before a checksum was captured. The final replacement names the method `bismarck_colonial_administration_requirements` and aliases the vanilla English label in `main_menu/localization/english/bismarck_foreign_buildings_l_english.yml`. The paper cost, icon, and maintenance category come from the previous definition.

## Isolated candidate checks

EU5 **1.4.7 (Rio Salado)**, temporary checksum **3033** with debug on. Debug-off checksum is unknown. The applied **Override Audit** playset had one temporary mod and the Monumental Bonus DLC. The mod supplied the proposed building, reform, and winter injections, six complete conversion entries prefixed with `REPLACE:`, and the one-key English localization file. The normal Bismarck playset and production scripts were outside this run.

- Europedia read the loaded building, reform, and winter modifiers and exposed all three injection mismatches listed above. In Languages > German, the culture list displayed **Dutch** between Danube Bavarian and East Franconian, independently of the existing Dutch dialect label.
- Compared all six complete replacement entries with vanilla. Each differs by exactly one threshold, and the file's two other actions are outside the replacement list.
- In Genoa's Content > Formables, the republic-to-monarchy tooltip showed at least **60 Aristocracy**, and the republic-to-theocracy tooltip showed at least **60 Spiritualist**. Both tooltips still listed their other prerequisites.
- A fresh campaign with Country Change Allowed enabled showed France's standard monarchy-to-republic requirement of at least **60 Plutocracy**, and its monarchy-to-theocracy requirement of at least **60 Spiritualist**. After switching to the Teutonic Order on April 1, the theocracy-to-monarchy tooltip showed at least **60 Aristocracy** and greater than **0 Humanist**. The theocracy-to-republic tooltip showed at least **60 Plutocracy** or at least **50 Humanist**, confirming the existing alternative path.
- Genoa advanced from **April 1 to October 6, 1337**, crossing the May through October monthly updates. After the June 1 conversion tooltip checks it ran for over four more months. The run used a fresh campaign with no console commands, date jumps, or edited saves. Rivalry and major-event reports were dismissed, funds for the Maona were declined, and Genoa kept its alignment in the Guelphs and Ghibellines event.
- The Teutonic campaign advanced from **April 1 to at least July 14, 1337**, crossing three monthly updates after the tooltip checks. Rivalry, stance, and Italy event reports were resolved. The game was closed after the run and the temporary profile was removed.
- The logs did not report rejected conversion IDs or errors at the audit definition files. The first startup logged missing temporary-mod metadata before the description was supplied and the UI confirmed the applied playset. The debug log recorded both definitions of `low_franconian`, and the UI confirmed the replacement won. Other logs included DLC/texture warnings, database size warnings, and errors in vanilla building and character scripts.

The checks cover loaded values and requirements in the UI, with a single-player simulation smoke test. This candidate build used injections for the building, reform, and winter definitions. Building construction, reform enactment, fleet attrition ticks, government conversion effects, and multiplayer were outside the test scope.

## Other observations

Tea injects three fields absent from the vanilla `tea` block. The fort rules inject build conditions and have separate test coverage. The player-alliance implementation already uses `REPLACE:alliance_can_exist` for the complete named vanilla trigger.

The custom player map-sharing interactions are new identifiers, not same-path vanilla-file overrides. Defines use a separate file. Their correctness or possible further deduplication was outside this audit.
