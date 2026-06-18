# Contributing to Quest UI Reorder

Thanks for helping! Three kinds of contribution are especially welcome:
**bug reports**, **bug fixes**, and **translations**. Issues and pull
requests live at
<https://github.com/Kevinjohn/wow-addon-quest-ui-reorder>.

## Bug reports

Open a GitHub issue and include:

- The **addon version** (AddOns list on the character screen, or
  `## Version` in `QuestUIReorder/QuestUIReorder.toc`) and the **game
  patch**.
- Your **client language**.
- The **quest names** involved and the type tag the game shows for each
  ("Important", "Legendary", "Meta", "Repeatable", "Storyline") — the
  quest log shows these next to the quest name.
- **What you expected vs. what you saw**: section order, a quest in the
  wrong section, missing/duplicated entries. A screenshot of the tracker
  helps a lot.
- Any **orange "QuestUIReorder:" chat message, pasted exactly**. Every
  failure prints a distinct message in your language, and the wording
  identifies which safeguard fired — please don't paraphrase it.
- Whether a **`/reload` clears it**.

## Bug fixes & code

- **Read [README-DEV.md](README-DEV.md) first.** It documents the
  architecture, the verified Blizzard internals the addon leans on, and
  the failure-handling design; most "why is this so paranoid?" questions
  are answered there.
- **Dev setup** is a symlink into your AddOns folder (see "Dev install"
  in README-DEV); edits go live on `/reload`.
- Ground rules the codebase holds to — PRs that break these won't land:
  - **Display order only.** Never modify the player's tracked-quest watch
    list; never drop or invent entries. Every failure path falls back to
    Blizzard's own behaviour, never a guess.
  - Code that runs inside Blizzard's layout pass must not be able to
    throw (`pcall` it, fail toward stock behaviour).
  - Verify Blizzard internals against
    [Gethe/wow-ui-source](https://github.com/Gethe/wow-ui-source)
    (`live` branch) — not against memory, wikis, or old forum posts.
- Before opening a PR: run `sh scripts/check.sh` (luacheck + the headless
  locale suite) and make sure it's clean. If you touched the section-split
  logic, also run the in-game checklist in README-DEV ("Release process").
- Branch from `main`, keep PRs focused on one change.

## Translations

All player-facing strings live in **`QuestUIReorder/Locales.lua`**, in one
table per locale keyed by the client's `GetLocale()` value; the addon-list
description is localized via the `## Notes-<locale>:` lines in
`QuestUIReorder/QuestUIReorder.toc`.

What to know before editing:

- The `Important` / `Legendary` / `Meta` / `Recurring` keys must stay
  **verbatim copies of Blizzard's `QUEST_CLASSIFICATION_*` strings** for
  your locale (source:
  [Ketho/BlizzardInterfaceResources](https://github.com/Ketho/BlizzardInterfaceResources),
  `live` branch, `Resources/GlobalStrings/<locale>.lua`). Don't "improve"
  them — they exist to match the tags the game itself shows.
- Everything else (`OTHER_QUESTS`, `OPTION_*`, `MSG_*`, the TOC notes) is
  the addon's own text. **These were written by the maintainer with AI
  assistance and not all have native-speaker review — corrections from
  native speakers are very welcome.** Natural phrasing beats literal
  translation of the English.
- `MSG_SORT_DISABLED_FMT` must keep its `%s` placeholder (the failure
  reason is inserted there). Keep `/reload` literal in every language.
- Keep the checkbox label (`OPTION_SPLIT_LABEL`) short — the Settings
  panel truncates long labels; the tooltip is the place for detail.
- To check your work without the game: run the headless locale harness
  (README-DEV, "Headless tests") — it loads `Locales.lua` for every
  locale and asserts every key resolves. In-game, `GetLocale()` follows
  the client language, so either switch the client or temporarily
  hardcode your locale at the bottom of `Locales.lua` while testing.
- Adding a missing locale = adding one new table to `translations` keyed
  by its `GetLocale()` value, plus a `## Notes-<locale>:` line in the TOC.
