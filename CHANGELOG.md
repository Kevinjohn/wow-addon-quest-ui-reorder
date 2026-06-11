# Changelog

All notable changes to Quest UI Reorder are documented here. The format is
based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [0.2.0-alpha] — 2026-06-11 (unreleased, feature branch)

Built against retail patch 12.0.5 (Interface 120005); not yet verified
in-game.

### Added

- The **Quests** section is now split into separate collapsible tracker
  sections by quest classification — **Important**, **Legendary**, **Meta**,
  **Repeatable** — slotted between Campaign and the catch-all. Each section
  is a real tracker module built the way Blizzard builds the Campaign
  section (stock quest module code plus a one-line display filter), so
  collapse buttons, POI buttons, fanfares, auto-quest popups, and
  hide-when-empty come from stock code. Sections with nothing to show are
  hidden entirely, header included.
- Section headers reuse Blizzard's localized quest-type names
  (`QuestUtil.GetQuestClassificationInfo`), with English fallbacks.
- The split is all-or-nothing: sections are created and their registration
  verified before the stock module's filter is narrowed, so any setup
  failure rolls back cleanly to the 0.1.0 behaviour (one fully sorted
  Quests section) with a single chat message. A self-heal pass re-registers
  the sections if Blizzard's manager ever rebuilds its module list.

### Changed

- The stock Quests section is renamed **"Other Quests"** while the split is
  live, and holds everything not claimed by a special section — still
  sorted, with Storyline quests first.
- The two failure messages now distinguish "the addon is disabled" (core
  tracker change) from "separate quest sections are disabled (sorting still
  works)".

### Known limitations

- All 0.1.0 limitations carry over (combat-click taint on quest item
  buttons, Callings in "everything else", patch-verification policy).
- Section collapse state is per-session, exactly like Blizzard's own
  section headers.
- The new-player-experience tutorial pointer that highlights a quest item
  button on the tracker hardcodes Blizzard's stock sections and silently
  skips quests shown in the new ones (new characters only, cosmetic).
- "Other Quests" is not localized (Blizzard has no such string).

## [0.1.0-alpha] — 2026-06-11

First release. Built and verified against retail patch 12.0.5 (Interface
120005).

### Added

- Sorting of the Objective Tracker's **Quests** section by quest
  classification: Important → Legendary → Meta → Repeatable → Storyline →
  everything else, stable within each group (Blizzard's order, including its
  proximity re-sort, is preserved as the tiebreak).
- Display-order-only guarantee: the tracked-quest watch list is never
  modified, entries are never added or dropped, and the Campaign section is
  never touched.
- Defensive failure handling: full load-time dependency guard, fallback to
  Blizzard's order on any per-pass anomaly (untracked entry, classification
  not yet streamed), both the Blizzard builder call and the sort protected by
  `pcall`, and automatic self-disable (with a single chat message) after
  repeated errors.
- Tooling: luacheck configuration with field-scoped write permissions, plus
  player and developer documentation.

### Known limitations

- Replacing a tracker method taints the layout pass: clicking a tracked
  quest's item button during combat can rarely report "Interface action
  failed because of an AddOn". Inherent to tracker-modifying addons; `/reload`
  clears it.
- Calling quests (Shadowlands) sort into "everything else" by design.
- Not yet validated on patch 12.0.7 (due mid/late June 2026); the TOC
  intentionally declares only verified patch versions.
