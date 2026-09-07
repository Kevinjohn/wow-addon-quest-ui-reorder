# Changelog

What changed in each release. Newest first.

<!-- Developer-level detail (architecture, Blizzard internals, rejected approaches) lives in CHANGELOG-dev.md. -->

## 0.9.2 — 2026-09-07
- Both features are back, as two separate options you turn on yourself: "Order quests by type" and "Split quests into sections". Each one explains the patch 12.1 problem so you can decide. Nothing is on until you switch it on.

## 0.9.1 — 2026-09-07
- The addon now turns itself off on patch 12.1 and says so once at login. A Blizzard bug freezes the whole quest tracker — every section, not just quests — as soon as any addon changes it, and no part of this addon avoids that, so sorting is off for now too. The options checkbox is still there and can force it back on if you want it, at the cost of the freeze.

## 0.9.0 — 2026-09-07
- Splitting quests into their own sections is off by default: a bug in patch 12.1 stops the quest tracker updating in real time while it is on, so changes only appear after a /reload. (The claim here that quests were still sorted correctly was wrong — sorting hits the same bug. Fixed in 0.9.1.)

## 0.8.2 — 2026-08-22
- Updated for retail patch 12.1 — no longer shows as out of date.
- No in-game behaviour change: nothing the addon uses changed in this patch.

## 0.8.1 — 2026-07-08
- Fixed the addon's name showing incorrectly on CurseForge.

## 0.8.0 — 2026-06-26
- First release-channel build on CurseForge. Added in-game screenshots to the README; no in-game behaviour change.

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
