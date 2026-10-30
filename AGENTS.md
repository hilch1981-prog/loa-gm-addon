# GM MINI BAR — Pandaria / LoA

- Target WoW 5.4.8 build18414,Interface 50400,Lua 5.1 and the documented LoA Pandaria server family.
- Read README.md,release.json,GMminibar-LoA/SOURCES.md,GMminibar-LoA/GAME_TEST.md first.
- Preserve the single GMminibar-LoA folder,matching TOC,GMMPandaria548 namespace and GMMPandariaDB settings. The core suffix is intentional.
- Keep other core editions separate; do not import SkyFire/SPP commands or client data without checking this target.
- Preserve secure hardware actions,combat restrictions and saved settings.
- Run python scripts/validate.py and python scripts/package.py after deliberate changes,including documentation.
- Explicitly update addon-manifest.json when addon files change; validation must not rewrite it.
- Mock/API/catalog checks are not gameplay proof. Keep current tests,older captures and unverified scope distinct.
- Never publish accounts,passwords,private host paths,server configs,SavedVariables,full SQL dumps,client archives or server/client binaries.
- Preserve attribution and license notices. Publish only within user authorization and keep the exact tested release asset.
