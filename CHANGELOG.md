# Changelog

What changed in each release. Newest first.

<!-- Developer-level detail (architecture, Blizzard internals, rejected approaches) lives in CHANGELOG-dev.md. -->

## 0.6.1-alpha — 2026-06-25
- Internal localization, packaging, and documentation cleanup; no in-game changes.

## 0.6.0-alpha — 2026-06-22
- Updated for retail patch 12.0.7 — no longer shows as out of date.
- Packaging and automated releases only; no in-game behaviour change.

## 0.5.0-alpha — 2026-06-11
- Every message the addon shows is now translated in all supported languages.

## 0.4.0-alpha — 2026-06-11
- Added an option to turn the extra sections on or off (**Esc → Options → AddOns → Quest UI Reorder**), on by default.
- Toggling it applies instantly — no `/reload` — and is remembered account-wide.

## 0.3.0-alpha — 2026-06-11
- Added German, French, Spanish (EU + Latin American), Italian, Brazilian Portuguese, Russian, Korean, and Simplified/Traditional Chinese.
- Every WoW language is now supported.

## 0.2.0-alpha — 2026-06-11
- Tracked quests now split into their own collapsible sections — **Important**, **Legendary**, **Meta**, **Repeatable** — above **Other Quests**.
- Each section appears only while you're tracking a quest of that type, and collapses just like the Campaign section.

## 0.1.0-alpha — 2026-06-11
- First release: sorts the Objective Tracker's **Quests** by type — Important, Legendary, Meta, Repeatable, Storyline, then everything else.
- Never changes what you track; if anything goes wrong it falls back to the game's normal order.
