# Sources and data scope

This is the LoA-specific GM MINI BAR development line,published by 취미연구가(Hobbyist). It was adapted from the author's AzerothAdminMoP/GM MINI BAR work,with the familiar Legion minibar design and explicit Pandaria-LoA namespace/folder isolation. See the [other editions](https://github.com/hilch1981-prog/loa-gm-addon#choose-the-matching-edition). Retain attribution and GPL-3.0 notices when modifying or redistributing.

# # Server and catalogs

`Generated/SourceInfo.lua` records the original extraction provenance:Legends-of-Azeroth/Legends-of-Azeroth-Pandaria-5.4.8,WER MOP world snapshot2026-10-28 and that extraction's worldserver SHA256. This is a historical extraction identifier,not the current server image,not a verified full upstream commit and not compatibility proof for every LoA fork.

| File | Selected reference fields | Rows |
|---|---|---|
|Generated/Items.lua |Item entry,label/locale fallback,quality,item level,required level,class |80,064 |
|Generated/Quests.lua |Quest entry,label/locale fallback and search fields |18,028 |
|Generated/Creatures.lua |Creature entry,label/locale fallback and search fields |57,518 |
|Generated/Teleports.lua |Canonical game_tele identifier/name and search/coordinate fields |1,602 |

These Lua lists are offline search indexes,not full SQL table/database exports. No account,character,SavedVariables,connection string or credential data is included. The addon never connects to MySQL. A record can exist in a catalog without being usable by a particular server/player/phase. Spell names come from the running5.4.8 client APIs rather than a supplied full client archive.

# # Command adaptation

The compatibility layer uses the target LoA chat-command path. It normalizes and bounds single commands,rejects control characters,uses secure self-target buttons,and sends named revival through GUILD while dead according to that core's command parsing order. The normal toolbar/menu catalogs include broader commands whose availability is server-dependent. Mock coverage is not evidence that every catalog command succeeded in game.

# # Publication relationship

The source installed during the2026-10-30 screen observation was development1.3.1-mop548. The first public release is1.0.0,following the other editions' initial-publication convention. Only Core/TOC version literals and their line endings are normalized;function bodies,catalogs and SavedVariables identity are preserved. Documentation/license files are added. The repository's `docs/development-source.json` stores relative hashes and comparison scope. No original private workspace paths are published.

Game textures and metadata belong to their respective rights holders. UI icons reference textures already in the installed client. No MPQ,DB2 archive,client executable,DLL,server binary or whole SQL database accompanies this addon.
