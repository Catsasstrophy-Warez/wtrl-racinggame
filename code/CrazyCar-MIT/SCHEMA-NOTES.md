# CrazyCar — progression schema

Origin: https://github.com/TastSong/CrazyCar
License: MIT, Copyright (c) 2021 TastSong. See `LICENSE`.
Retrieved 29 Aug 2026.

`data.sql` is the upstream MySQL dump (563 lines) including seed data.
`backend-class-index.txt` lists every Java class, useful for navigating the
server after cloning.

## Why this matters
No other open-source Unity racing project implements progression, ownership,
or economy. This is the only prior art. You are copying the *shape*, not the
Java — reimplement in ScriptableObjects + save data locally, or on whatever
backend you choose.

## Tables
```
admin_users, superuser        admin panel auth
user                          uid, user_name, user_password, login_time,
                              aid (equipped avatar), star, is_vip, eid (equipped car)
user_login_record             daily login tracking -> streak rewards

equip                         CATALOG: eid, rid, equip_name, star, mass,
                              power, max_power, can_wade, is_show
equip_record                  OWNERSHIP: id, eid, uid, update_time

avatar                        CATALOG: cosmetics
avatar_record                 OWNERSHIP: cosmetics owned

match_class                   event tiers
match_map                     track registry
match_record                  id, uid, cid, complete_time, record_time

time_trial_class              time-trial tiers
time_trial_record             results
time_trial_class_record       per-tier bests

assets_updating               asset hot-update manifest
version                       client version gating
```

## The pattern to steal
**Catalog table + ownership table, with the equipped item denormalised onto the
user row.** `equip` is every car/part that exists; `equip_record` is who owns
what; `user.eid` is what's currently fitted. Repeat for avatars.

Map to your game:
- `equip` -> cars, engines, suspension kits, tires, transmissions, diffs
- `equip_record` -> the player's garage inventory
- add a `property` catalog + `property_record` for house / garage / shop /
  warehouse tiers
- `star` is their rarity/tier field — you likely want a numeric level instead
- `can_wade` is a capability flag — the generalisable idea is per-item boolean
  capabilities gating which events an item can enter

## `assets_updating` + `version` — worth special attention
This is how CrazyCar ships new content without a store submission. For an iOS
game where every update needs Apple review, a server-driven asset manifest with
client version gating is the difference between a two-day content drop and a
two-week one. Look at `AssetsUpdatingController` / `Service` and
`VersionController` / `Service`.
