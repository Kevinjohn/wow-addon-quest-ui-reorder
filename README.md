# Quest UI Reorder

[![Release](https://img.shields.io/github/v/release/Kevinjohn/wow-addon-quest-ui-reorder?include_prereleases&sort=semver)](https://github.com/Kevinjohn/wow-addon-quest-ui-reorder/releases)
[![License: MIT](https://img.shields.io/github/license/Kevinjohn/wow-addon-quest-ui-reorder)](LICENSE)
![Interface](https://img.shields.io/badge/Interface-120005-blue)
![Last commit](https://img.shields.io/github/last-commit/Kevinjohn/wow-addon-quest-ui-reorder)

<!-- Keep the Interface badge above in step with `## Interface` in the .toc. -->

Splits your tracked quests into sections by importance.

The on-screen quest list (the panel on the right toggled by the **All
Objectives** button) normally lumps every tracked quest into one **Quests**
section, in whatever order you happened to track them. With this addon the
high-value quest types each get their own collapsible section — built the
same way the game builds its **Campaign** section — so the quests that
matter most always sit at the top, under their own header:

| | Section | What goes in it |
| --- | --- | --- |
| 1 | Campaign | Blizzard's own section, untouched |
| 2 | Important | quests tagged "Important" |
| 3 | Legendary | quests tagged "Legendary" |
| 4 | Meta | quests tagged "Meta" |
| 5 | Repeatable | quests tagged "Repeatable" |
| 6 | Other Quests | everything else, with "Storyline" quests sorted first |

A section only appears while you actually track a quest of that type —
Legendary quests are rare, so most of the time you'll simply see Campaign,
maybe one or two of the special sections, and Other Quests. Each section has
its own collapse arrow, just like Campaign does. Within every section,
quests stay in the order the game would have shown them — including the
game's own nearest-first re-sort when you change zones.

## Screenshots

<!-- Drop screenshots into docs/img/ and reference them here. -->
![Tracked quests split into sections by type](docs/img/sections.png)

## What it will never do

- **It never changes what you track.** The checkboxes you tick in your quest
  log stay completely under your control; the addon only changes where and
  in what order what's already shown appears. It will never hide a tracked
  quest or show an untracked one.
- **It never touches the Campaign section**, world quests, bonus objectives,
  achievements, or scenarios — only the Quests section.
- **Almost no setup.** There is exactly one option and one sane default;
  no slash commands, no configuration ritual. Install it and the layout is
  just right; uninstall it and everything goes back to normal.

## Options

The addon has a single option, and it lives where the game keeps all addon
options: **Esc → Options → AddOns → Quest UI Reorder**.

- **Split quests into sections** (on by default). Untick it if the
  extra sections aren't for you: all tracked quests collapse back into one
  **Quests** section, still sorted with the most important quest types at
  the top. The change applies immediately — no reload — and is remembered
  account-wide.

The sorting itself is not optional; it's the point of the addon.

## Installation

Download the latest `QuestUIReorder` zip from the
[Releases page](https://github.com/Kevinjohn/wow-addon-quest-ui-reorder/releases),
unzip it, and copy the `QuestUIReorder` folder into your World of Warcraft AddOns
folder, then restart the game or type `/reload`:

- **Windows:** `C:\Program Files (x86)\World of Warcraft\_retail_\Interface\AddOns\`
- **Mac:** `/Applications/World of Warcraft/_retail_/Interface/AddOns/`
  (yours may live elsewhere, e.g. under `/Applications/Games/`)

You should see **Quest UI Reorder** in the AddOns list on the character select
screen.

## Languages

Works in every language the game supports: English, German, French, Spanish
(EU and Latin American), Italian, Brazilian Portuguese, Russian, Korean, and
Simplified and Traditional Chinese. The Important / Legendary / Meta /
Repeatable headers use the game's own translated quest-type names, so they
always match what your quest log shows; the **Other Quests** header ships
with the addon's own translations, built from the game's vocabulary.

## Compatibility

- Retail only, built and tested against patch **12.0.5**. Classic flavours are
  not supported (they don't have quest classifications).
- **Alpha software**: it has been carefully built and reviewed, but not yet
  battle-tested across a full patch cycle. See `CHANGELOG.md` for history.

## If something goes wrong

The addon is designed to fail safe, in layers: if the separate sections can't
be set up (usually after a game patch), it falls back to a single **Quests**
section sorted in the same order — and if even sorting fails, you get the
game's normal quest order. Never a broken tracker, never a missing quest.

- An **orange chat message from QuestUIReorder** means it detected a problem
  and switched the affected feature off until you `/reload`. Your tracker
  keeps working normally in the meantime.
- Very rarely, clicking a quest item button on the tracker **during combat**
  may show "Interface action failed because of an AddOn". This is a known
  limitation of any addon that modifies the tracker; a `/reload` clears it.
- Section collapse arrows reset to expanded on `/reload` or relog — the same
  per-session behaviour as the game's own section headers.

## Contributing

Bug reports, fixes, and better translations are all welcome — see
[CONTRIBUTING.md](CONTRIBUTING.md) for what to include in a bug report and
how the translation files work. If a message or label reads awkwardly in
your language, that's exactly the kind of fix we'd love a hand with.

---

**Install:** grab the latest zip from the
[Releases page](https://github.com/Kevinjohn/wow-addon-quest-ui-reorder/releases)
and unzip it into your AddOns folder (see [Installation](#installation) above for
the exact path). Contributions are welcome — see
[CONTRIBUTING.md](CONTRIBUTING.md). Licensed under [MIT](LICENSE).

*Developers: see [README-DEV.md](README-DEV.md).*
