# Changelog

All notable changes to Quest UI Reorder are documented here. The format is
based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

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
