# Quest UI Reorder — developer notes

Player-facing docs live in [README.md](README.md); release history in
[CHANGELOG.md](CHANGELOG.md). This file covers internals, design decisions,
and the release process.

## Repo layout

```
QuestUIReorder/            the addon (this folder is what ships / gets symlinked)
  QuestUIReorder.toc       Interface 120005, hard dep on Blizzard_ObjectiveTracker
  QuestUIReorder.lua       the entire addon
.luacheckrc                lint config (lua51 + WoW globals)
README.md                  player-facing
README-DEV.md              this file
CHANGELOG.md               release history
```

## Dev install

Symlink the addon folder into the game so repo edits go live on `/reload`:

```sh
ln -sfn "$(pwd)/QuestUIReorder" "/Applications/Games/World of Warcraft/_retail_/Interface/AddOns/QuestUIReorder"
```

Always use `-sfn`: a plain `ln -s` re-run against an existing link follows it
and creates a cyclic `QuestUIReorder/QuestUIReorder` link inside the repo.

## How it works

The tracker's display order is decided in
`QuestObjectiveTrackerMixin:BuildQuestWatchInfos()`
(`Interface/AddOns/Blizzard_ObjectiveTracker/Blizzard_QuestObjectiveTracker.lua`
in [Gethe/wow-ui-source](https://github.com/Gethe/wow-ui-source/tree/live), live
branch). It reads the watch list via `C_QuestLog.GetNumQuestWatches()` /
`GetQuestIDForQuestWatchIndex(i)`, filters through `ShouldDisplayQuest`, and
`table.sort`s (Blizzard's comparator: Callings first, then
`overridesSortOrder`, then watch index). Its enumeration order *is* the visual
order; it is called only from `EnumQuestWatchData`.

We replace that method **on the `QuestObjectiveTracker` frame instance**.
Mixin methods are copied per frame at creation, so
`CampaignQuestObjectiveTracker` (which filters for
`Enum.QuestClassification.Campaign` and owns the Campaign accordion) keeps its
own untouched copy — the Campaign section is structurally out of reach.

The sort itself: each entry gets one combined key,
`priority * (#infos + 1) + incomingPosition`, then an in-place `table.sort`
with a trivial `<` comparator over distinct numbers. Distinct keys mean Lua's
unstable sort still yields a stable result (Blizzard's order preserved within
groups), and the comparator can never violate strict-weak-order requirements.

### Classification mapping (retail 12.0.5)

`Enum.QuestClassification`: Important=0, Legendary=1, Campaign=2, Calling=3,
Meta=4, Recurring=5 (tag "Repeatable"), Questline=6 (tag "Storyline"; the
world-map legend calls these "Local Story"), Normal=7, BonusObjective=8,
Threat=9, WorldQuest=10. Label/atlas mapping lives in
`g_classificationInfoTable` in `Blizzard_FrameXMLUtil/Mainline/QuestUtils.lua`.

Deliberate decision: **Callings sort into "everything else"** (Blizzard floats
them to the top) — per the original spec; revisit if Shadowlands callings ever
matter again.

### Defensive design (in order of execution)

1. **Load guard** — every external symbol (tracker method, the enum, both
   quest APIs) is verified before any use; missing → one chat message, addon
   stays inert. Classification *names* missing from the enum are skipped
   individually (their quests sort as "other") rather than failing the load.
2. **Never add/drop entries** — if any entry fails the
   `C_QuestLog.GetQuestWatchType` re-check (user requirement: the watch list
   is the sole source of truth), or `GetQuestClassification` returns nil
   (quest data not streamed yet — fresh login/loading screen), the pass
   returns Blizzard's list untouched. A later layout sorts it.
3. **Both call regions are pcall'd** — Blizzard's original builder *and* our
   sort. The original runs tainted once we're in the call chain, and 12.x
   "secret values" can make `C_QuestLog` APIs throw under taint, so an
   unprotected `orig()` call would be a crash path the comment used to deny.
4. **Failure latch** — builder error or unexpected return shape unhooks
   immediately; sort errors unhook after 10 *consecutive* failures (counter
   resets on success, so intermittent taint bursts are tolerated). Unhooking
   restores `origBuildQuestWatchInfos` and prints once.

### Taint, honestly

Replacing the method taints the rest of every layout pass. Downstream,
`QuestObjectiveItemButtonMixin:SetUp` writes `questLogIndex`/`questID`
attributes that a click reads before calling protected
`UseQuestLogSpecialItem` — so a combat click on a quest item button can hit
`ADDON_ACTION_BLOCKED`. This is inherent to reordering the tracker (Kaliel's
Tracker forks the whole thing and carries the same exposure); there is no
supported sort seam. Unhooking cannot fully clean the tainted method slot;
only `/reload` does. Don't promise otherwise in user-facing text.

## Linting

```sh
luacheck QuestUIReorder
```

`.luacheckrc` declares `QuestObjectiveTracker` read-only with exactly one
writable field (`QuestObjectiveTracker.BuildQuestWatchInfos`). This is
deliberate: an accidental top-level `QuestObjectiveTracker = ...` assignment
(which would clobber the frame global for the whole UI) fails lint, while the
addon's legitimate single-field replacement passes. Verified by mutation test:
append `QuestObjectiveTracker = nil` to a copy of the file and luacheck must
warn "setting read-only global variable".

## Release process

1. Test against the live patch in-game (order correct; zone-change re-sort;
   track/untrack mid-session; instanced content; quest item button in combat).
2. Only then bump `## Interface:` in the TOC. **Never pre-declare an
   unreleased patch number**: the runtime guard detects a *missing* method but
   not a changed contract, so the client's "out of date" flag is the only
   signal that re-verification is due. (12.0.7 is imminent as of June 2026 —
   it will need this dance.)
3. Bump `## Version:` and add a `CHANGELOG.md` entry.

## What breaks us, and how it shows

| Blizzard change | Symptom |
| --- | --- |
| `BuildQuestWatchInfos` renamed/removed | one chat message at load, addon inert |
| Enum or quest APIs removed | same |
| A classification value removed | its quests sort as "other"; no error |
| Info entry shape changed (`info.quest` gone) | sort fails per pass → silent Blizzard order → unhooks + one message after 10 passes |
| Builder errors under taint (secret values) | immediate unhook + one message |

## Reference material

- [Gethe/wow-ui-source](https://github.com/Gethe/wow-ui-source) (`live` branch) — the actual Blizzard UI code; always verify against this, not memory.
- [warcraft.wiki.gg](https://warcraft.wiki.gg/wiki/) — API/event documentation, TOC format, [secret values](https://warcraft.wiki.gg/wiki/Secret_values).
- [Ketho/BlizzardInterfaceResources](https://github.com/Ketho/BlizzardInterfaceResources) — generated enum/global-string dumps per build.
