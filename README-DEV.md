# Quest UI Reorder — developer notes

Player-facing docs live in [README.md](README.md); release history in
[CHANGELOG.md](CHANGELOG.md). This file covers internals, design decisions,
and the release process.

## Repo layout

```
QuestUIReorder/            the addon (this folder is what ships / gets symlinked)
  QuestUIReorder.toc       Interface 120005, hard dep on Blizzard_ObjectiveTracker
  Locales.lua              translations (loaded first; publishes ns.L)
  QuestUIReorder.lua       the addon logic (exports ns.ApplySplitSetting)
  Options.lua              the one checkbox in the native Settings panel
.luacheckrc                lint config (lua51 + WoW globals)
README.md                  player-facing
README-DEV.md              this file
CONTRIBUTING.md            bug-report / code / translation guidelines
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

The addon has two independent layers. Part 1 (sorting) is the v0.1.0 addon,
unchanged; Part 2 (sections) splits the high-value classifications into their
own tracker modules. Part 1 is also the fallback: every Part 2 failure mode
degrades to "one fully sorted Quests section", never to a missing quest.

### Part 1: sorting the (catch-all) quest module

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
`CampaignQuestObjectiveTracker` (which owns the Campaign accordion) keeps its
own untouched copy — the Campaign section is structurally out of reach.

The sort itself: each entry gets one combined key,
`priority * (#infos + 1) + incomingPosition`, then an in-place `table.sort`
with a trivial `<` comparator over distinct numbers. Distinct keys mean Lua's
unstable sort still yields a stable result (Blizzard's order preserved within
groups), and the comparator can never violate strict-weak-order requirements.

With the split live, Important/Legendary/Meta/Recurring never reach this
module, so the sort's practical job is floating Questline ("Storyline") to
the top of "Other Quests".

### Part 2: one tracker module per classification

Since the Dragonflight tracker rewrite, each accordion is an independent
"module" frame (`ObjectiveTrackerModuleTemplate`) registered with
`ObjectiveTrackerManager` into a container (`ObjectiveTrackerFrame`).
Blizzard's Campaign section is literally the quest module re-mixed with a
different header and a one-line `ShouldDisplayQuest` filter
(`Blizzard_CampaignQuestObjectiveTracker.lua` is ~10 lines). Part 2 does the
same four more times:

1. `CreateFrame` from `"ObjectiveTrackerModuleTemplate"`, then
   `Mixin(module, QuestObjectiveTrackerMixin)`. The XML route applies the
   mixin *before* `OnLoad`; the runtime route can't, so we set
   `headerText`/`SetHeader` ourselves and explicitly
   `SetScript("OnEvent", module.OnEvent)` rather than rely on how
   `method="OnEvent"` scripts resolve.
2. Override `ShouldDisplayQuest`: stock filter (pcall'd) AND classification
   matches. Override `events` (stock list minus `QUEST_AUTOCOMPLETE`, see
   below). Events are read once, inside the module's first `SetContainer`.
3. Set numeric `uiOrder` and register via
   `ObjectiveTrackerManager:SetModuleContainer(module, container)`. The
   container sorts modules by `uiOrder` and **hard-errors on nil**; stock
   orders are consecutive integers (Campaign=3, Quest=4), so fractions in
   `(questOrder-1, questOrder)` slot between Campaign and the catch-all.
4. Only after *all* sections are built and verified registered, narrow the
   stock instance's `ShouldDisplayQuest` to "stock filter AND not claimed"
   and rename its header to "Other Quests". Ordering matters: narrowing
   first would hide quests if a section failed; sections-first without
   narrowing would duplicate them. Registration is verified because
   `SetModuleContainer` **silently no-ops** when the manager doesn't know
   the container; any miss rolls back the whole split.

The single-displayer invariant — each watched quest renders in exactly one
module — is what the rest of the UI actually relies on (Blizzard's own words,
comment atop `Blizzard_ObjectiveTrackerQuestPOIBlock.lua`). Both filter
overrides therefore start from the same stock filter, and classification
lookups are guarded to return nil (→ catch-all) on error, so the partition is
exact and error cases bias toward Blizzard's home for the quest.

**Setup timing.** `ObjectiveTrackerManager:Init()` (which registers the
container and assigns `uiOrder`s) is deferred via
`EventUtil.ContinueAfterAllEvents(GenerateClosure(...), "PLAYER_ENTERING_WORLD",
"VARIABLES_LOADED")` — the closure captures `Init` **at Blizzard file-load
time**, so `hooksecurefunc(manager, "Init", ...)` would never fire on the
login path. Init *ends* with a dynamic `self:UpdateAll()`, so we hook
`UpdateAll` instead: pending → set up when the stock quest module is mapped
and ordered; live → self-heal (re-register our modules if something like
`RemoveAllModules` rebuilt the list — it too ends in `UpdateAll`); failed →
inert. The container is resolved via
`manager:GetContainerForModule(QuestObjectiveTracker)` rather than assumed to
be `ObjectiveTrackerFrame`, so the sections follow the quest module wherever
it lives.

### The one option (Options.lua)

A single account-wide boolean — `QuestUIReorderDB.splitSections`, default
true — surfaced as a checkbox in the native Settings panel's AddOns tab via
the modern `Settings` API (`RegisterVerticalLayoutCategory` →
`RegisterAddOnSetting` → `CreateCheckbox` → `RegisterAddOnCategory`).
Registration runs in `EventUtil.ContinueOnAddOnLoaded` (saved variables are
only readable from ADDON_LOADED) and the whole thing is pcall'd: a failure
costs the checkbox, never the addon.

Verified API facts (live 12.0.5, `Blizzard_Settings_Shared`):

- `Settings.RegisterAddOnSetting(categoryTbl, variable, variableKey,
  variableTbl, variableType, name, defaultValue)` — returns the setting
  object. It writes the default into `variableTbl[variableKey]` *before
  returning* if the key is nil, but `assert`s the table itself exists —
  create `QuestUIReorderDB = QuestUIReorderDB or {}` first.
- The `variable` string is reserved globally across every addon's settings
  and Blizzard's own; a collision is a hard `error()`. Hence the
  addon-prefixed `"QuestUIReorder_SplitSections"`.
- The real enum keys are `Settings.VarType.Boolean` and
  `Settings.Default.True` — the usage comment at the top of Blizzard's own
  `Blizzard_Settings.lua` says `VarType.Bool`/`Settings.Defaults` and is
  **stale/wrong**; trust the definitions, not the comment.
- `setting:SetValueChangedCallback(cb)` fires `cb(setting, value)` on every
  applied change (addon settings apply immediately; there is no Apply
  commit stage).
- `Settings.CreateCheckbox` (lowercase "b") takes `(category, setting,
  tooltip)`; the canonical usage example Blizzard ships is in
  `Blizzard_Settings_Shared/Blizzard_ImplementationReadme.lua` — the only
  in-tree user of the addon-setting path.

The toggle applies **live**. The split logic is factored into build-once /
activate / deactivate (`ApplySplitSetting` in the main file, exported on
`ns`): deactivating removes the four modules from the container, restores
the stock `ShouldDisplayQuest` *by reference* and the stock header, and
dirties the tracker; reactivating re-registers the same module frames
(events stay registered across a remove — the mixin's one-time init flag
would silently skip re-registration anyway) and re-applies the same
narrowed-filter closure, built exactly once so flapping the checkbox can
never stack wrappers. Removed modules must be explicitly `Hide()`-den:
stock code only hides modules it lays out, and a removed module is never
laid out again. After any (de)activation, the section modules and the
stock tracker are explicitly `MarkDirty()`-ed because a dirty-driven
container relayout can serve cached layouts for modules it doesn't
consider dirty.

### Verified plumbing facts (12.0.5, live source)

Things checked in `Gethe/wow-ui-source` that the design leans on — re-verify
on Blizzard tracker rewrites:

- **Empty modules vanish entirely.** `EndLayout` hides the whole module
  frame, header included, when state < `ShownPartially`. Rare sections cost
  nothing on screen. A *collapsed* module with content still shows its header.
- **Module collapse is per-session** for stock modules too (header `OnLoad`
  resets to expanded; no CVar/saved-var). Our sections behave identically.
- **Module "tags" are safe to share.** `AddTag("quest")` (inherited via
  `InitModule`) sets a single `self.tag`; the only consumer in the entire UI
  is `EnumerateActiveBlocksByTag` (supertrack tutorial HelpTip), which
  iterates all matches. Nothing takes "the" quest module by tag.
- **Block pools are shared by template but bookkept per module**
  (`usedBlocks`, `parentModule` reassigned on acquire) — no cross-module id
  collisions.
- **Auto-quest popups are global C-side state** (`AddAutoQuestPopUp` etc. in
  `Blizzard_AutoQuestPopUpTracker.lua`), *rendered* by every module whose
  `LayoutContents` → `AddAutoQuestObjectives` → `ShouldDisplayQuest` claims
  them — i.e. popups follow our partition automatically. The sections drop
  `QUEST_AUTOCOMPLETE` from their event list so the stock module remains the
  single writer of that global state (mirrors Campaign, which also omits it).
- **`WatchMoney`/`playerMoney` are per-module `self` state** — six modules
  each tracking their own copy is harmless.
- Known cosmetic externals that hardcode the stock instances: NPE/boost
  tutorial item-button pointers (`QuestObjectiveTracker:GetExistingBlock` or
  Campaign only — arrow silently skipped if one of our sections owns the
  quest; new characters only) and the quest-item charge ticker in
  `Blizzard_ObjectiveTrackerShared.lua` (dirties only the stock module — the
  shipping Campaign module has the same exposure today; worst case a cached
  layout until the next quest event).

### Classification mapping (retail 12.0.5)

`Enum.QuestClassification`: Important=0, Legendary=1, Campaign=2, Calling=3,
Meta=4, Recurring=5 (tag "Repeatable"), Questline=6 (tag "Storyline"; the
world-map legend calls these "Local Story"), Normal=7, BonusObjective=8,
Threat=9, WorldQuest=10. Label/atlas mapping lives in
`g_classificationInfoTable` in `Blizzard_FrameXMLUtil/Mainline/QuestUtils.lua`;
section headers use `QuestUtil.GetQuestClassificationInfo(c).text` (the raw
localized tag — *not* `GetQuestClassificationDetails`, which time-suffixes
Repeatable), falling back to the addon's own translations in `Locales.lua`,
then to English literals.

### Localization

Header resolution is three-deep: Blizzard's runtime string (always correct
for the client locale, survives Blizzard rewording) → `ns.L` from
`Locales.lua` → English literal in `QuestUIReorder.lua` (survives a packaging
error that drops the file). `Locales.lua` covers all retail client locales —
deDE, esES, esMX (identical to esES, aliased), frFR, itIT, koKR, ptBR, ruRU,
zhCN, zhTW — keyed by `GetLocale()`; enGB and unknown locales fall through to
the English base table.

Translation sourcing policy: the four classification fallbacks are *verbatim
copies* of Blizzard's `QUEST_CLASSIFICATION_*` strings per locale
(Ketho/BlizzardInterfaceResources, branch `live`,
`Resources/GlobalStrings/<locale>.lua`) — never freehand, so they always
match the in-game quest-log tags (note zhCN Meta = 统合 vs zhTW = 主任務,
koKR = 상위). Everything else is the addon's own text, composed where
possible from Blizzard's vocabulary (e.g. `OTHER_QUESTS` = `OTHER` +
`TRACKER_HEADER_QUESTS` with grammatical agreement: ruRU "Другие задания",
esES "Otras misiones"). When a patch rewords `QUEST_CLASSIFICATION_*`,
re-grep the dumps and refresh the fallbacks.

As of 0.5.0 *all* user-facing strings are localized, including the chat
diagnostics (`MSG_*` keys — the earlier English-only policy was reversed by
request) and the addon-list description (`## Notes-<locale>:` in the TOC).
Each failure mode has its own `MSG_*` key, so a pasted bug report still
identifies the exact safeguard that fired regardless of language;
`MSG_SORT_DISABLED_FMT` carries a `%s` for the reason and the harness
asserts the placeholder survives in every locale. The addon-original
strings are maintainer-written with AI assistance and not all
native-reviewed — CONTRIBUTING.md explicitly invites corrections.

The merge logic is plain Lua and is verified headlessly (no game client):
load `Locales.lua` once per `GetLocale()` value — all 10 translated locales,
enUS/enGB, an unknown locale, and with `GetLocale` absent — and assert every
key resolves to a non-empty string. Re-run after editing translations.

Deliberate decisions: **Callings sort into "Other Quests"** (Blizzard floats
them to the top) — per the original spec; and the split is
**Important / Legendary / Meta / Repeatable / Other** rather than merging
Meta+Repeatable, because empty sections are free (see above). Merging is a
two-line change to `SECTIONS` if it ever feels busy in practice.

### Defensive design (in order of execution)

1. **Load guard, two tiers** — tier 1 (tracker method, the enum, both quest
   APIs) gates the whole addon; tier 2 (manager functions, quest mixin,
   frame/mixin/hook utilities) gates only Part 2, leaving Part 1 sorting
   alive. Either prints one chat line. Classification *names* missing from
   the enum are skipped individually (their quests stay in the catch-all).
2. **Never add/drop entries** — if any entry fails the
   `C_QuestLog.GetQuestWatchType` re-check (user requirement: the watch list
   is the sole source of truth), or `GetQuestClassification` returns nil
   (quest data not streamed yet), the sort pass returns Blizzard's list
   untouched. A later layout sorts it.
3. **Both sort call regions are pcall'd** — Blizzard's original builder *and*
   our sort. The original runs tainted once we're in the call chain, and 12.x
   "secret values" can make `C_QuestLog` APIs throw under taint.
4. **Sort failure latch** — builder error or unexpected return shape unhooks
   immediately; sort errors unhook after 10 *consecutive* failures (counter
   resets on success). Unhooking restores `origBuildQuestWatchInfos` and
   prints once.
5. **Split is all-or-nothing** — sections are built first, registration is
   verified, and only then do they claim classifications and narrow the
   stock filter. Any failure before that point rolls back (modules removed,
   events unregistered, hidden) and latches `splitFailed`; the option
   checkbox silently no-ops for the rest of the session.
6. **Filter lookups are guarded** — our `ShouldDisplayQuest` overrides run
   inside Blizzard's layout pass where an uncaught error aborts the whole
   tracker update, so the stock-filter call and classification lookup are
   pcall'd; errors bias the quest into the catch-all, never out of the UI.

### Taint, honestly

Replacing the builder method taints the rest of every layout pass, and the
Part 2 module frames are addon-created, so everything they lay out is tainted
too. Downstream, `QuestObjectiveItemButtonMixin:SetUp` writes
`questLogIndex`/`questID` attributes that a click reads before calling
protected `UseQuestLogSpecialItem` — so a combat click on a quest item button
can hit `ADDON_ACTION_BLOCKED`. This is inherent to reordering the tracker
(Kaliel's Tracker forks the whole thing and carries the same exposure); there
is no supported sort seam. Unhooking cannot fully clean the tainted method
slot; only `/reload` does. Don't promise otherwise in user-facing text.

## Headless tests

Run the headless suite (and luacheck) with:

```sh
sh scripts/check.sh
```

It needs only luacheck and any Lua >= 5.1 on `PATH` (no game client; e.g. the
interpreter inside Homebrew's luacheck keg, or `luajit`).

- **Locales** — committed as `tests/run.lua`: loads the real `Locales.lua`
  once per possible `GetLocale()` value (all 10 translated locales, esMX,
  enUS/enGB, an unknown locale, and `GetLocale` absent) and asserts every
  base key resolves to a non-empty string, no locale introduces a stray key,
  and `MSG_SORT_DISABLED_FMT` keeps its single `%s` and a literal `/reload`.
  Re-run after touching `Locales.lua`.

A **toggle state-machine** harness is planned but not yet committed: stub the
Blizzard surface Part 2 touches (tracker, manager, container, `CreateFrame`,
`Mixin`, `hooksecurefunc`, quest stubs), load the real `QuestUIReorder.lua`,
and drive it — login activation with the setting on (4 sections, exact
partition; fractional uiOrders strictly between Campaign and Quests), live
toggle off (stock filter restored by reference, header restored), off/on
flapping (no duplicate sections, no wrapper stacking), `UpdateAll` self-heal
stability, disabled-at-login, and the creation-failure latch. Until it lands,
those behaviours stay on the in-game checklist below.

What headless tests cannot cover regardless: real layout, taint, POI buttons,
and the Settings panel itself — that stays on the in-game checklist below.

## Linting

```sh
luacheck QuestUIReorder
```

`.luacheckrc` declares the Blizzard tracker globals read-only with exactly
three writable fields (`QuestObjectiveTracker.BuildQuestWatchInfos`,
`.ShouldDisplayQuest`, `.headerText`) plus the addon's own saved-variables
global (`QuestUIReorderDB`). This is deliberate: an accidental
top-level `QuestObjectiveTracker = ...` or `ObjectiveTrackerManager = ...`
assignment (which would clobber the global for the whole UI) fails lint,
while the addon's legitimate field replacements pass. Verified by mutation
test: append `QuestObjectiveTracker = nil` and `ObjectiveTrackerManager =
nil` to a copy of the file and luacheck must warn "setting read-only global
variable" for both.

## Release process

1. Test against the live patch in-game. Sorting: order correct; zone-change
   re-sort; track/untrack mid-session; instanced content; quest item button
   in combat. Sections: each appears only when populated, in the right
   order; collapse arrows work per section; POI buttons/supertrack highlight
   inside a section; quest-added fanfare lands in the right section;
   auto-accept popup (area-trigger quest) renders once, in the section
   matching its classification; `/reload` mid-session rebuilds the split.
   Option: checkbox present under Options → AddOns; toggling off mid-session
   collapses to one sorted section and back on rebuilds, both without
   reload; the choice survives relog; first run writes
   `QuestUIReorderDB.splitSections = true`.
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
| Manager/mixin/`SetHeader`/`ShouldDisplayQuest` missing | one chat message at load, sections off, sorting still on |
| A classification value removed | that section skipped; its quests stay in the catch-all; no error |
| `ObjectiveTrackerModuleTemplate` uncreatable | sections roll back + one message, sorting still on |
| `SetModuleContainer` contract changed | registration verify fails → rollback + one message |
| Info entry shape changed (`info.quest` gone) | sort fails per pass → silent Blizzard order → unhooks + one message after 10 passes |
| Builder errors under taint (secret values) | immediate unhook + one message |
| `quest:GetQuestClassification()` throws in filters | quest shows in catch-all for that pass; no error |
| Settings API renamed/changed | one chat message, checkbox unavailable, split stays at its saved/default state |

## Reference material

- [Gethe/wow-ui-source](https://github.com/Gethe/wow-ui-source) (`live` branch) — the actual Blizzard UI code; always verify against this, not memory. Key files: `Blizzard_ObjectiveTracker/Blizzard_ObjectiveTrackerManager.lua` (Init/SetModuleContainer/UpdateAll), `Blizzard_ObjectiveTrackerModule.lua` (module lifecycle, SetContainer, EndLayout), `Blizzard_ObjectiveTrackerContainer.lua` (uiOrder sort), `Blizzard_QuestObjectiveTracker.lua` + `Blizzard_CampaignQuestObjectiveTracker.lua` (the pattern Part 2 copies).
- [warcraft.wiki.gg](https://warcraft.wiki.gg/wiki/) — API/event documentation, TOC format, [secret values](https://warcraft.wiki.gg/wiki/Secret_values).
- [Ketho/BlizzardInterfaceResources](https://github.com/Ketho/BlizzardInterfaceResources) (`live` branch) — generated enum/global-string dumps per build (`QUEST_CLASSIFICATION_*`, `TRACKER_HEADER_*`).
