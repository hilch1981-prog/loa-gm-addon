# Game observation and acceptance boundaries

Date:2026-10-30. Client:original Korean WoW 5.4.8(18414),64-bit. Server:LoA Pandaria with native Playerbots,the author's WER MOP development runtime. Addon visible in the capture:1.3.1-mop548,GM MINI BAR[판다리아-LoA].

# # Observed

- Authenticated and entered Stormwind Trade District in the original game client.
- Existing minibar rendered with14 slots.
- Clicked GM Menu to open the two-column utility panel;LoA client/core title appeared.
- Closed the panel normally.
- Korean nearby bot names and ambient dialogue appeared in the scene. This is server localization context,not a feature provided by the addon.

No level,money,HP or other GM action was executed as part of this menu capture. No captured scene is presented as a successful full dungeon,raid,PvP match or all-command test.

# # Public1.0.0 relationship

The release packages the same implementation with two version literals changed and those files' line endings normalized. It adds documentation/license records. Static comparison checks all original file hashes,normalizes the two changed version files for comparison,and retains the exact catalogs and namespace. It is not a new full graphical-client test of every release function.

# # Automated checks

Lua 5.1 compilation covers24 TOC Lua files. The mocked WoW client runs115 assertions per locale for koKR,enUS,zhCN,zhTW,ruRU. It exercises14 secure-template slots,command validation,namespace preservation,dead named revival transport,key binding conflicts,combat layout restrictions,catalog counts and ID searches. A mocked secure callback is not a real secure-execution/gameplay test,and loading a locale is not proof of complete translation.

# # Still unverified

- Every GM command and selected-other-player behavior on all LoA revisions.
- Protected inventory actions in the real client,all profession ranks and recipes.
- Every teleport destination,floor,phase,difficulty and quest objective.
- Complete non-Korean localization and actual gameplay in those clients.
- Multiplayer party actions,full dungeon completion and all remote tester PCs.

Actual screens and their provenance are recorded in the repository's `docs/SCREENSHOTS.md`. The install ZIP contains no private logs,accounts,passwords or server configuration.
