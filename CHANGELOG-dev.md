# Changelog — developer notes

> Looking for the player-facing changelog? See [CHANGELOG.md](CHANGELOG.md).

The technical history: the Blizzard internals touched, the design decisions and
the failure-handling behind them, and the approaches tried and rejected.
Plain-language summaries for players live in [CHANGELOG.md](CHANGELOG.md).
Newest first; follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [Unreleased]

## [0.7.0-alpha] — 2026-06-26

### Changed
- Set `## X-Curse-Project-ID: 1588096` in the TOC, enabling the packager's
  CurseForge upload on tag push (the `CF_API_TOKEN` repo secret was already in
  place). Wago stays a `000000` placeholder. Added the three in-game captures
  under `screenshots/` to the README (separated sections, single-section
  fallback, options panel). No player-facing code change.

## [0.6.1-alpha] — 2026-06-25

### Changed
- Split the monolithic `Locales.lua` into per-locale files under `Locales/`,
  matching the sibling addons. `Locales/enUS.lua` is the base and publishes
  `ns.L`; each other `Locales/<locale>.lua` overlays it in place, guarded by an
  early `if GetLocale() ~= "<locale>" then return end`. `Locales/esES.lua`
  guards both `esES` and `esMX`, preserving the old
  `translations.esMX = translations.esES` aliasing. `enUS.lua` now wraps the
  table in an `__index` metamethod that returns the key name for any missing
  key, so a typo renders as visible text instead of a `SetText(nil)` error. The
  TOC lists `Locales\enUS.lua` first and the whole `Locales\` block ahead of
  `QuestUIReorder.lua` / `Options.lua`, which capture `ns.L` by reference at
  load — load order is load-bearing. No player-facing change.
- Split the changelog: short player-facing summaries stay in `CHANGELOG.md`;
  this file carries the technical detail. The release workflow strips everything
  above the first `## ` heading from `CHANGELOG.md` before the packager reads it,
  so the GitHub Release body and the CurseForge/Wago notes show only the version
  list.
- Renamed `README-DEV.md` → `README-dev.md` for consistency with the sibling
  addons (and with this repo's own `docs/release-checklist.md`, which already
  used the lowercase spelling); swept every in-repo reference.
- Release workflow: bumped `actions/checkout` to `v5` (Node 24), and pass the
  CurseForge token under both `CF_API_KEY` (what `BigWigsMods/packager@v2`
  reads) and `CF_API_TOKEN` (the name on the packager's unreleased master) so a
  later packager bump can't silently no-op the upload.
- Tooling/hygiene: `.luacheckrc` adds `self = false` and excludes the headless
  test harness; `.gitignore` and `.pkgmeta` now ignore `.DS_Store`; `.pkgmeta`
  also ignores `screenshots/` and `CHANGELOG-dev.md`.

### Added
- `screenshots/` directory for the README capture and the store-listing image
  (`screenshots/quest-ui-reorder-tracker.png`, ignored by the packager).
- Locale harness (`tests/run.lua`) now loads the split `Locales/` files exactly
  as the client does (enUS base + every overlay, each self-guarding) and
  asserts each translated locale actually applies — so a broken `GetLocale()`
  guard (e.g. esMX silently falling back to English) fails the suite.

## [0.6.0-alpha] — 2026-06-22

### Added
- Automated releases via GitHub Actions (`.github/workflows/release.yml`):
  pushing a `vX.Y.Z` tag runs the same BigWigs packager in CI and publishes a
  GitHub Release with the zip attached. CurseForge/Wago uploads are wired and
  switch on once their project IDs are filled into the `.toc` and the
  `CF_API_TOKEN` / `WAGO_API_TOKEN` repo secrets are set; until then a tag push
  just builds the zip and creates the GitHub Release. See `docs/packaging.md`
  and `_wow-Addon-Publishing-Readiness.md`.
- `## X-Curse-Project-ID:` / `## X-Wago-ID:` fields in the TOC (placeholder
  `000000` until the store projects exist), so the upload path is ready to enable.

### Changed
- Bumped `## Interface:` to `120007` for retail patch 12.0.7 so the addon loads
  without the "out of date" prompt.
- Moved the addon's loaded files (`QuestUIReorder.toc`, `Locales.lua`,
  `QuestUIReorder.lua`, `Options.lua`) from the `QuestUIReorder/` subfolder to
  the repository root so the BigWigs packager can discover the `.toc`. The
  packaged zip is still a single `QuestUIReorder/` folder. No in-game behaviour
  change. See `docs/packaging.md`.
- Removed the non-working `move-folders` block from `.pkgmeta` (it does not point
  the packager at a nested `.toc`; root layout is the actual fix).
- The release zip now bundles the curated `CHANGELOG.md` (dropped it from the
  `.pkgmeta` ignore list), matching the other addon repos.

## [0.5.0-alpha] — 2026-06-11

### Added

- **Every user-facing string is now localized**, completing what 0.3.0
  started: the chat diagnostics (each failure mode has its own distinct
  message key, so a pasted bug report identifies the exact safeguard that
  fired in any language) and the addon-list description (localized
  `## Notes-<locale>:` lines in the TOC).
- **CONTRIBUTING.md**: guidelines for bug reports (what to include, why
  the orange chat message should be pasted verbatim), code contributions
  (the display-order-only ground rules, lint and headless-harness
  requirements), and translations (which strings must stay
  Blizzard-verbatim, which are addon-original and open to improvement,
  placeholder rules, how to test). README links to it.

### Changed

- The "chat diagnostics stay English" policy from 0.3.0 is reversed by
  request. The addon-original translations are maintainer-written with AI
  assistance; native-speaker corrections are explicitly invited in
  CONTRIBUTING.md.

## [0.4.0-alpha] — 2026-06-11

### Added

- **One option, in the native Settings panel** (Esc → Options → AddOns →
  Quest UI Reorder): "Split quests into sections", **on by default**
  (label kept short so it never truncates in the settings list; the
  tooltip carries the detail). Unticking collapses everything back into a single sorted
  Quests section; re-ticking rebuilds the split — both live, no `/reload`.
  Stored account-wide (`SavedVariables: QuestUIReorderDB`); label and
  tooltip localized in all client languages. Sorting itself is
  deliberately not optional.
- Headless test harness for the toggle: the real addon code runs under a
  desktop Lua against a stubbed Blizzard surface, covering login
  activation, exact one-section-per-quest partition, off/on flapping
  (no duplicate sections, no filter-wrapper stacking), self-heal
  stability, disabled-at-login, and the failure latch.

### Changed

- Split internals refactored from a one-way setup into
  build-once/activate/deactivate to support the live toggle; the
  catch-all's narrowed filter and the stock filter/header are now swapped
  by reference, built exactly once.
- The "zero config" promise is now "one checkbox, sane default": no slash
  commands, no saved settings beyond the single account-wide boolean, and
  a missing/failed options panel leaves the addon fully functional at its
  defaults.

## [0.3.0-alpha] — 2026-06-11

### Added

- **Localization for every retail client language**: German, French, Spanish
  (EU + Latin American), Italian, Brazilian Portuguese, Russian, Korean,
  Simplified Chinese, and Traditional Chinese, plus English (US/EU). New
  `Locales.lua` loads ahead of the main file and publishes the strings
  through the addon-private table; English defaults survive even if the file
  is missing.
- The **"Other Quests"** header (the addon's only original string) is now
  translated in all locales, composed from Blizzard's own `OTHER` +
  "Quests" vocabulary with grammatical agreement.
- The four classification fallback headers are now verbatim copies of
  Blizzard's localized `QUEST_CLASSIFICATION_*` strings per locale (sourced
  from Ketho/BlizzardInterfaceResources, `live`). They remain fallbacks
  only: at runtime the section headers keep reading Blizzard's translated
  strings directly, so they were already localized in 0.2.0.
- Headless locale verification: the merge logic was executed for all 13
  possible `GetLocale()` outcomes (10 translations, enUS/enGB, unknown
  locale, and `GetLocale` absent) — every key resolves in every case.

### Notes

- Chat diagnostics intentionally remain English — they exist to be pasted
  into bug reports.

## [0.2.0-alpha] — 2026-06-11

Built against retail patch 12.0.5 (Interface 120005). In-game verification
of the new sections is still pending — see the release checklist in
README-dev.md before promoting beyond alpha.

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
