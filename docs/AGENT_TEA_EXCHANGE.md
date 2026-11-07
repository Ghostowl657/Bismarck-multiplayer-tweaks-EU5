# Tea in the Columbian Exchange

Implements [issue #1](https://github.com/Ghostowl657/Bismarck-multiplayer-tweaks-EU5/issues/1).

## Implementation and test checksums

Observed in EU5 **1.4.7 (Rio Salado)** with the Bismarck mod. Checksums belong
to the complete loaded build, including temporary definitions, not just the tea
file. The tea-only production pair was verified again during the compliance
audit; the combined alliance-and-tea build is recorded separately below.

| Build / coverage | Debug on | Debug off |
|---|---|---|
| Tea-only implementation, with all temporary definitions removed | **d7ed** | **525e** |
| Final combined tea and player-alliance build | **34c5** | **1a28** |
| Historical Funchal/Teguise test with diagnostic decisions installed | **1c49** | Not captured |
| Historical South America setup build; April 1–October 17 run | **3285** | Not captured |
| Clean production continuation; October 17–March 1 run | Comparison checksum **d7ed**; no separate unpaused debug run in this audit | **525e**, used for the unpaused audit run |

The historical fixture-build checksums were recovered from the observed menu
screenshots in this conversation. Their debug-off equivalents were not observed
and are unknown; they were not inferred or recreated. The final debug-on
comparison was a startup checksum observation, not an additional stability run.
No checksum is embedded in production game scripts.

## Behavior and affected files

`in_game/common/goods/bismarck_tea.txt` extends the existing `tea` entry with
`INJECT:tea`. It sets `origin_in_old_world = yes` and the `old_world_goods`
custom tag. EU5 1.4's native exchange action, market checks, AI goods selection,
and situation goods list already use these properties; no generic action or
vanilla goods file needs to be copied into the mod.

The former 1.3 action's tea planting conditions now live in `location_potential`:

- Woods, forest, grasslands, or farmland vegetation.
- Subtropical or oceanic climate.
- Plateau, hills, or mountains topography.
- Exclude East Coast, West Coast, and Great Plains regions.

These restrictions apply in America, Oceania, and Macaronesia, matching the
native action's destination geography. Other locations retain vanilla tea's
unrestricted potential. This avoids invalidating existing Old World tea RGOs
that do not meet the exchange-specific planting rules. Only static geography
and terrain conditions are used because the engine caches goods potential.
Ownership, duplicate-resource checks, costs, RGO resizing, prosperity penalties,
and AI replacement safeguards remain in the native action.

## Runtime verification

Tested through Windows computer use on November 5, 2026, with EU5 **1.4.7
(Rio Salado)** and the local Bismarck mod. The installed patch's SHA256 matched
the repository file. A disposable France campaign used temporary diagnostic
decisions to assign Funchal and Teguise to France, supply New World goods to its
market, and activate the situation early. This tests the action without waiting
for a natural late-game exchange.

- A native diagnostic confirmed tea's Old World origin, valid Funchal, invalid
  Teguise, and unrestricted Paris.
- After the market updated, the Columbian Exchange appeared as a purple alert.
- **Spread an Old World Good** offered **Tea** in its normal goods selector.
- Selecting Tea and Macaronesia offered **Funchal** and excluded arid **Teguise**.
- Confirming Funchal changed its raw material from **Sugar to Tea**, deducted
  **100 gold and 5 prestige**, and reported the native **10% prosperity penalty**.
- No tea injection, goods-potential, or invalid existing tea-RGO errors appeared.

An initial temporary diagnostic used unsupported `any_location`; it was
corrected on disk and removed after testing. Do not treat that initial check
as verification of every existing tea RGO. The production patch never used it.
The temporary decision and localization files are excluded from the repository
and removed from the installed mod. Restart EU5 after removing diagnostics to
clear cached decision definitions.

That historical clean restart loaded the production patch without tea-related
errors and stopped at the main menu. It was only a startup check. The later
production-build audit below supplies the required unpaused coverage and closes
the game afterward.

Natural situation activation, long-run AI planting, and multiplayer lockstep
were not runtime-tested. The production patch is limited to tea's data and
uses the same native selectors and effects as the other exchange goods.

## South America follow-up

On November 5, 2026, a fresh EU5 1.4.7 France campaign used a temporary setup
decision to assign `curitiba` (Kuri'tyba in the UI) to France, supply exchange
goods, and activate the situation. The game defines it under America > South
America > Brazil, with hills, forest, and oceanic climate.

On **April 1, 1337**, the native **Spread an Old World Good > Tea > Brazil >
Kuri'tyba** action successfully replaced **Lumber with Tea**, deducted **100 gold
and 5 prestige**, and applied the native prosperity penalty. The setup fixture
did not change Curitiba's raw material; planting was performed through the UI.

The simulation ran normally from **April 1 to October 17, 1337**, over six
months after planting, without a crash. Routine events were resolved with the
user's explicit permission; no date jumps were used. No tea, Curitiba, or
test-fixture errors appeared in the log. The observed script errors concern
vanilla `religious_figure` checks in `character_triggers.txt:87`, also present
before the simulation. The newest crash folder remained from November 4.

Readable saves at June 1 and October 17 independently confirmed the actual
`locations.locations.24431` record has `raw_material=tea` and owner `1141`
(France). The location ID was mapped from `curitiba` in the metadata's location
list. Prosperity recovered from `-0.09` at June 1 to `-0.07` at October 17.

Checkpoints in the local EU5 save directory:

- `SP_FRA_1337_06_01_199aa3d2-dc4a-41a1-87cf-5f9e87499cbd.eu5`
- `SP_FRA_1337_10_17_199aa3d2-dc4a-41a1-87cf-5f9e87499cbd.eu5`

The South America setup decision and localization were removed from the
installed mod after the run. The production tea patch was unchanged. This is
a single-player stability smoke test, not proof of long-term or multiplayer
stability.

## Test setup and fixture limits

The historical debug-mode setup attempts used the grave key, Shift+grave,
Alt+C, and Shift+Alt+C through computer use. They did not open a usable console;
no console command syntax was verified and no console commands were executed.
Temporary decisions were consequently used to supply owned test destinations,
market goods, gold/prestige, and an active exchange. They did not lower any
production date threshold or change production event conditions. Tea was
planted through the native player UI, not through a fixture effect.

This fixture coverage demonstrates planting and subsequent simulation, not
natural late-game activation or a naturally developed colonial economy. The
clean production audit continues the saved test campaign after a full restart,
without fixture definitions installed; it retains that campaign's artificial
initial setup. No additional test scripts or edited saves were created for the
audit.

## Production-build compliance audit

The updated `AGENTS.md` requires an unpaused run after temporary definitions
are removed. The historical six-month run alone did not cover that requirement.
The follow-up audit ran the final production build, with every installed file
under `in_game`, `main_menu`, `loading_screen`, and `.metadata` matching the
repository by SHA256 and no extra files in those directories.

- **Version and active mods:** EU5 1.4.7 (Rio Salado); the Mods & DLCs UI showed
  **(Applied) Bismarck Tuesday**, with only **Bismarck multiplayer tweaks v3.0**
  enabled. The production debug-off checksum was **525e**.
- **Setup:** loaded the unedited October 17 checkpoint listed above through
  Continue. No console commands, temporary definitions, or date jumps were
  used in this audit. The campaign retains its historical fixture setup.
- **Simulation:** unpaused from **October 17, 1337 to March 1, 1338**, over four
  elapsed months, crossing November, December, January, February, and March
  monthly updates. Routine event pauses were resolved through the player UI.
- **Observable result:** after the run, Finder > Kuri > Kuri'tyba opened the
  owned South American location. Its normal location panel and tooltip still
  showed **Tea** as the raw material.
- **Logs and stability:** no crash or logged script errors occurred during
  this debug-off run, and no tea/Curitiba/fixture matches appeared in `error.log`.
  The newest crash folder remained dated November 4. This does not imply that
  the debug-mode vanilla errors described above have been fixed.
- **Checkpoint:** `SP_FRA_1338_03_01_199aa3d2-dc4a-41a1-87cf-5f9e87499cbd.eu5`.
  This normal-mode save was retained as supporting evidence; the final Tea
  observation came from the live UI rather than assuming its format was text.

The implementation was unchanged during the audit. Documentation now lives
under `docs/`, the feature is indexed in `DEVELOPMENT.md`, and feature-specific
test results are kept out of the general computer-use tips. Both root
instruction files were updated identically; the equality hook was installed
and checked. Natural exchange activation, long-term AI planting, and
multiplayer behavior remain outside the verified coverage.

The final paired debug checksum was observed at the main menu, then EU5 was
closed rather than left running for possible follow-up work.

## Combined alliance-and-tea verification

The tea script was reviewed and left unchanged for the combined PR addressing
issues #1 and #4. The native 1.4 exchange implementation remains in control of
selection, costs, and effects. Installed tea matched the repository by SHA256.

Full setup, checksum history, fixture separation, log findings, and final-build
evidence are in [AGENT_PLAYER_ALLIANCES.md](AGENT_PLAYER_ALLIANCES.md). The final
EU5 **1.4.7 (Rio Salado)** build uses applied playset **Bismarck Tuesday**, only
**Bismarck multiplayer tweaks v3.0**, and observed checksums **34c5 debug on**
and **1a28 debug off**. All temporary alliance definitions were removed and the
entire installed mod matched the repository by SHA256 with no extra files.

With debug off, the clean France campaign advanced **August 1, 1338 to January
22, 1339**, over five simulated months after a full restart, crossing September
through January monthly updates. This continued a normal August checkpoint
from the preceding clean March–August production run; no alliance-fixture flags
or opinion modifiers were retained. It still carries the original exchange
setup described above. No console commands or date jumps were used.

After the run, **Finder > Kuri > Kuri'tyba** opened the South American location.
The live location panel and tooltip still showed France-owned **Tea**. No tea,
Curitiba, alliance-trigger, or fixture errors appeared; existing startup and
save-repair notices are detailed in the alliance document. The newest crash
directory remained dated November 4. EU5 was closed after testing.

This is an additional persistence and single-player stability check, not a new
natural-activation or planting test. The earlier native planting evidence and
its fixture limitations remain applicable; multiplayer remains unverified.
