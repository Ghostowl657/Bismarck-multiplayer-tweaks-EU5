# Vision and fort console setup transcript

Temporary debug-on proxy build **866a**, EU5 1.4.7, Bismarck Tuesday with only Bismarck v3.0. Exact observed console commands from this session follow. These are disposable test setup, not production scripts or reusable recommended commands. No console date jumps were used.

`help yesmen` was an unsuccessful help lookup; `help yesman` confirmed the correct singular command. The first Scotland war was not a neutral spectator setup; it was ended with white peace before using Portugal. The `destroy_building = "building(...)"` setup failed due console quoting and generated `:1` errors. The subsequent building-object loop succeeded. Fort predicates queried in the same command as demolition can see cached state; normal simulation and UI verified the updated state afterward.

The conspicuous gold branches supported engine-condition checks only. They are not claims about real human-human negotiation, autonomous AI construction, or campaign balance.

```text
help effect
help yesmen
help yesman
effect set_variable = bismarck_fixture_human add_gold = 10000 c:ENG = { set_variable = bismarck_fixture_human } c:BLS = { set_variable = bismarck_fixture_human }
yesman
effect c:ENG = { declare_war = c:SCO } c:FRA = { save_scope_as = actor } location:montmorency = { if = { limit = { bismarck_fort_spacing_allowed = yes } c:FRA = { add_gold = -1000000 } } else = { c:FRA = { add_gold = 1000000 } } }
effect c:BLS = { save_scope_as = actor } location:montmorency = { if = { limit = { NOT = { bismarck_fort_spacing_allowed = yes } } c:FRA = { add_gold = 1000000 } } else = { c:FRA = { add_gold = -1000000 } } } c:POR = { save_scope_as = actor } location:montmorency = { if = { limit = { bismarck_fort_spacing_allowed = yes } c:FRA = { add_gold = 1000000 } } else = { c:FRA = { add_gold = -1000000 } } } c:FRA = { save_scope_as = actor } location:montmorency = { change_location_owner = c:BLS if = { limit = { NOT = { bismarck_fort_spacing_allowed = yes } } c:FRA = { add_gold = 1000000 } } else = { c:FRA = { add_gold = -1000000 } } }
effect if = { limit = { bismarck_vision_alliance_can_exist = { first = c:FRA second = c:ENG } } add_gold = 1000000 } else = { add_gold = -1000000 } if = { limit = { NOT = { bismarck_vision_alliance_can_exist = { first = c:FRA second = c:POR } } } add_gold = 1000000 } else = { add_gold = -1000000 } if = { limit = { NOT = { bismarck_vision_alliance_can_exist = { first = c:FRA second = c:BLS } } } add_gold = 1000000 } else = { add_gold = -1000000 }
effect c:ENG = { every_current_war = { save_scope_as = test_war c:ENG = { white_peace = scope:test_war } } declare_war = c:POR } if = { limit = { bismarck_vision_alliance_can_exist = { first = c:FRA second = c:ENG } } add_gold = 1000000 } else = { add_gold = -1000000 }
effect c:FRA = { save_scope_as = actor } location:montmorency = { change_location_owner = c:FRA every_neighbor_location = { if = { limit = { has_building = building_type:castle } destroy_building = "building(building_type:castle|owner)" } if = { limit = { has_building = building_type:stockade } destroy_building = "building(building_type:stockade|owner)" } } if = { limit = { bismarck_fort_spacing_allowed = yes } c:FRA = { add_gold = 1000000 } } else = { c:FRA = { add_gold = -1000000 } } }
effect c:FRA = { save_scope_as = actor } location:montmorency = { every_neighbor_location = { every_buildings_in_location = { limit = { building_category = defense_category } location = { destroy_building = prev } } } if = { limit = { bismarck_fort_spacing_allowed = yes } c:FRA = { add_gold = 1000000 } } else = { c:FRA = { add_gold = -1000000 } } }
```
