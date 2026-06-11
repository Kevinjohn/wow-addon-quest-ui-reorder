# Quest UI Reorder

Sorts your tracked quests by importance.

The on-screen quest list (the panel on the right toggled by the **All
Objectives** button) normally shows your tracked quests in whatever order you
happened to track them. With this addon, the **Quests** section is grouped so
the quests that matter most are always at the top:

| | Quest type | How it's tagged in-game |
| --- | --- | --- |
| 1 | Important | "Important" |
| 2 | Legendary | "Legendary" |
| 3 | Meta | "Meta" |
| 4 | Repeatable | "Repeatable" |
| 5 | Storyline | "Storyline" (the world map calls these "Local Story") |
| 6 | Everything else | — |

Within each group, quests stay in the order the game would have shown them —
including the game's own nearest-first re-sort when you change zones.

## What it will never do

- **It never changes what you track.** The checkboxes you tick in your quest
  log stay completely under your control; the addon only changes the order of
  what's already shown. It will never hide a tracked quest or show an
  untracked one.
- **It never touches the Campaign section**, world quests, bonus objectives,
  achievements, or scenarios — only the Quests section.
- **No setup needed.** There are no options, no saved settings, no slash
  commands. Install it and the order is just right; uninstall it and
  everything goes back to normal.

## Installation

Copy the `QuestUIReorder` folder into your World of Warcraft AddOns folder,
then restart the game or type `/reload`:

- **Windows:** `C:\Program Files (x86)\World of Warcraft\_retail_\Interface\AddOns\`
- **Mac:** `/Applications/World of Warcraft/_retail_/Interface/AddOns/`
  (yours may live elsewhere, e.g. under `/Applications/Games/`)

You should see **Quest UI Reorder** in the AddOns list on the character select
screen.

## Compatibility

- Retail only, built and tested against patch **12.0.5**. Classic flavours are
  not supported (they don't have quest classifications).
- **Alpha software**: it has been carefully built and reviewed, but not yet
  battle-tested across a full patch cycle. See `CHANGELOG.md` for history.

## If something goes wrong

The addon is designed to fail safe: if anything unexpected happens it quietly
falls back to the game's normal quest order — never a broken tracker.

- An **orange chat message from QuestUIReorder** means it detected a problem
  (usually after a game patch changed something) and switched itself off until
  you `/reload`. Your tracker keeps working normally in the meantime.
- Very rarely, clicking a quest item button on the tracker **during combat**
  may show "Interface action failed because of an AddOn". This is a known
  limitation of any addon that modifies the tracker; a `/reload` clears it.

Found a bug? Please open an issue with the quest names, their tags, and the
order you saw.

---

*Developers: see [README-DEV.md](README-DEV.md).*
