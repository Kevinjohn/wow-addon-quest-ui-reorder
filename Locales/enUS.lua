local _, ns = ...

-- QuestUIReorder localization — default (enUS/enGB) strings and the base
-- every other locale builds on. See CONTRIBUTING.md for how to improve or
-- add a translation: each Locales/<locale>.lua file overrides a subset of
-- these keys, so any string it misses falls back to English. The __index
-- metamethod turns a typo'd or missing key into visible text ("OTHER_QUESTS")
-- instead of a SetText(nil) error.
--
-- The four classification section headers (Important, Legendary, Meta,
-- Recurring) normally come from Blizzard's own localized strings at runtime
-- (QuestUtil.GetQuestClassificationInfo), so they appear in the client's
-- language with no help from this file; the values below are fallbacks for
-- the day that lookup breaks, copied verbatim from Blizzard's locale data —
-- never reworded. OTHER_QUESTS is the addon's own header — Blizzard has no
-- "Other Quests" string — composed per locale from Blizzard's vocabulary.
-- OPTION_* strings label the checkbox in the Settings panel.
--
-- MSG_* strings are the chat diagnostics. Every failure mode has its own
-- distinct key, so a pasted bug report identifies the exact failure in any
-- language. MSG_SORT_DISABLED_FMT must keep its %s placeholder (the failure
-- reason is inserted there); "/reload" stays literal everywhere.
--
-- Source for Blizzard's strings: Ketho/BlizzardInterfaceResources, branch
-- `live`, Resources/GlobalStrings/<locale>.lua (retail 12.0.5).
ns.L = setmetatable({
    OTHER_QUESTS = "Other Quests",
    Important = "Important",
    Legendary = "Legendary",
    Meta = "Meta",
    Recurring = "Repeatable",
    OPTION_SPLIT_LABEL = "Split quests into sections",
    OPTION_SPLIT_TOOLTIP = "Show Important, Legendary, Meta, and Repeatable quests in their own sections. When unchecked, all tracked quests stay in one Quests section, still sorted by type.",
    MSG_ADDON_DISABLED = "the Blizzard quest tracker has changed; the addon is disabled.",
    MSG_SORT_DISABLED_FMT = "%s — quest sorting is now off and the default order is in effect. Reload the UI (/reload) to retry.",
    MSG_SORT_ERROR_BUILDER = "the Blizzard quest tracker errored inside the sorting hook",
    MSG_SORT_CHANGED = "the Blizzard quest tracker changed in an unexpected way",
    MSG_SORT_REPEATED = "quest sorting failed repeatedly",
    MSG_SECTIONS_DISABLED = "the Blizzard quest tracker has changed; separate quest sections are disabled (sorting still works).",
    MSG_OPTIONS_UNAVAILABLE = "the Blizzard settings panel has changed; the options checkbox is unavailable (the addon keeps working with its defaults).",
    MSG_OPTIONS_FAILED = "the options checkbox could not be created (the addon keeps working with its defaults).",
}, { __index = function(_, key) return tostring(key) end })
