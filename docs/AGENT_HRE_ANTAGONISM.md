# HRE antagonism

Bismarck v3.1.1 uses the vanilla file path
`in_game/common/international_organizations/hre.txt` to set the HRE's
fellow-member land-taking surcharge to `0`. Human and AI members both get
the reduction. Ordinary conquest antagonism and the separate outsider
surcharge still apply.

`in_game/common/cabinet_actions/zz_bismarck_alleviate_concerns.txt` adds an
early **Alleviate Concerns** action for human HRE members under the new ID
`bismarck_hre_alleviate_concerns`. It requires timed antagonism and uses the
vanilla decay modifier and finish condition. The English aliases in
`main_menu/localization/english/bismarck_hre_antagonism_l_english.yml` reuse
vanilla labels and tooltips. The vanilla action still unlocks through
Deflating Tensions. Human HRE members remain eligible for the early action
after researching that advance.

## Verification

The user tested the installed `bismarck_tweaks` mod before Git recovery.
Recovery verification compared the gameplay files, localization, and
version metadata with that installation.
The baseline HRE file matches the installed EU5 1.4.7 (Rio Salado) script
and uses the same file path as the tested mod. The feature commit introduces
the new cabinet action and its localization together.

The historical run's checksum with debug on and with debug off, debug state,
playset, console commands, observed dates, and elapsed simulation time are
unknown.
