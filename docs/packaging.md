# Packaging & repo layout

How release zips are built for this addon, the layout decision behind it, and —
at the end — the steps to convert another addon repo to the same layout.

## TL;DR

- The addon's loaded files (`QuestUIReorder.toc`, `*.lua`, `LICENSE`) live at the
  **repository root** ("root layout"), **not** in a `QuestUIReorder/` subfolder.
- That's required by the **BigWigs packager**: it only discovers an addon `.toc`
  at the repo root (`$topdir/<package-as>.toc`). `package-as` renames the folder
  *inside the zip*; it cannot point the packager at a subfolder.
- `.pkgmeta`'s `ignore:` list is what keeps the repo-only files (scripts, tests,
  docs, README, CI templates, the changelog) out of the shipped zip.
- Build a no-upload zip with `sh scripts/release.sh` (needs `bash` >= 4.3).

## Why root layout (the non-obvious bit)

A subfolder layout (`AddonName/AddonName.toc`) reads more cleanly in a repo and
mirrors what lands in `Interface/AddOns/`. It is also **silently incompatible
with the BigWigs packager**: the packager walks up to the VCS root, sets that as
`$topdir`, and looks for the `.toc` at `$topdir/<package-as>.toc`. A nested
`AddonName/AddonName.toc` is never found, and the build dies with:

```
Could not find an addon TOC file. In another directory? Make sure it matches the 'package-as' in .pkgmeta
```

`move-folders` does **not** rescue this. Tested 2026-06-18: its two-level form
(`AddonName/AddonName: AddonName`) fails with the same error because TOC
discovery runs before `move-folders`, and a one-level mapping produces an empty
build. `move-folders` is for splitting one repo into multiple *output* addon
folders, not for source discovery. The only fix is to put the `.toc` at the root.

The repo stays tidy anyway: the packager copies every tracked file that is **not**
in `.pkgmeta`'s `ignore:` list, so the ignore list does the separating instead of
a folder.

## What ends up in the zip

`package-as: QuestUIReorder` makes the packager build a single folder named
`QuestUIReorder/` and zip it. Everything tracked is included **except** the
`ignore:` entries, so the zip contains:

```
QuestUIReorder/
  QuestUIReorder.toc         # @project-version@ replaced with the git tag
  Locales.lua  QuestUIReorder.lua  Options.lua
  LICENSE
  CHANGELOG.md               # our curated one (see the changelog gotcha below)
```

`@project-version@` in the `.toc` is substituted from the latest git tag at build
time. A raw checkout shows the literal token in-game — the accepted trade-off.

### Changelog gotcha

The packager **always** puts a changelog in the zip. With no configuration it
*generates* one from the git log — a messy dump that includes commit trailers —
and adds it **regardless of the `ignore:` list**. To ship the curated
`CHANGELOG.md` instead, `.pkgmeta` points the packager at it:

```yaml
manual-changelog:
  filename: CHANGELOG.md
  markup-type: markdown
```

When you do this, `CHANGELOG.md` must **not** be in `ignore:` (the packager needs
to read it and ship it). It is also what CurseForge/Wago show as the release
notes on upload.

## Building a release

```sh
sh scripts/release.sh          # no-upload build into .release/ (implicit -d)
```

Requirements: `bash` >= 4.3 (the packager is a bash script; macOS ships 3.2, so
`brew install bash`), plus `git`, `curl`, and `zip`. The packager reads the
latest git tag for the version, so tag first:

```sh
git tag v0.6.0-alpha && git push --tags
sh scripts/release.sh
```

Publishing to CurseForge / Wago / a GitHub Release later: fill the
`X-Curse-Project-ID` / `X-Wago-ID` stubs in the `.toc`, export `CF_API_KEY` /
`WAGO_API_TOKEN` / `GITHUB_OAUTH`, and run `scripts/release.sh` without `-d` (or
wire up the BigWigs GitHub Action, which runs the same packager).

## Development symlink

Because the addon is at the repo root, symlink the **repo root** in as the addon
folder. WoW only loads what the `.toc` lists, so the repo-only files alongside
are ignored by the client:

```sh
ln -sfn "$(pwd)" \
  "/Applications/Games/World of Warcraft/_retail_/Interface/AddOns/QuestUIReorder"
```

Use `-sfn` (re-running a plain `ln -s` against an existing link creates a cyclic
link inside the target). The symlink's folder name must match the `.toc` base
name (`QuestUIReorder`).

## Converting another repo to this layout

For an addon repo currently laid out as `AddonName/AddonName.toc`, flatten it:

1. **Move the loaded files to the root** (preserve history):
   ```sh
   git mv AddonName/*.lua AddonName/*.xml AddonName/*.toc .
   git mv AddonName/Locales .        # if it has a Locales/ folder
   rmdir AddonName
   ```

2. **`.pkgmeta`** — keep `package-as: AddonName`; **delete any `move-folders`
   block** (it doesn't work, see above); make sure `ignore:` lists every
   repo-only path (`.release`, `.github`, `.gitignore`, `.gitattributes`,
   `.luacheckrc`, `.pkgmeta`, `scripts`, `tests`, `docs`, and the `*.md` docs).

3. **Update paths that assumed the subfolder:**
   - `scripts/check.sh`: `luacheck AddonName` → `luacheck *.lua` (add
     `Locales/*.lua` if your Lua is nested).
   - test runner: drop the `AddonName/` prefix from any load paths.
   - README / README-DEV: layout text and the dev-symlink target (symlink the
     repo root, as above).

4. **Fix exec bits** (the AddOns-folder symlink on macOS flips source files to
   `+x`): `chmod 644 *.lua *.toc` (and `*.xml`, `Locales/*.lua` if present); keep
   `scripts/*.sh` at `755`. Verify `git diff --summary | grep "mode change"` is
   empty.

5. **Verify:**
   ```sh
   sh scripts/check.sh          # luacheck clean + tests pass
   sh scripts/release.sh        # .release/ has only the AddonName/ folder,
                                # and its .toc shows a real version
   ```
