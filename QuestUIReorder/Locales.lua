-- QuestUIReorder localization.
--
-- The four classification section headers normally come from Blizzard's own
-- localized strings at runtime (QuestUtil.GetQuestClassificationInfo), so
-- they appear in the client's language with no help from this file; the
-- per-classification values below are fallbacks for the day that lookup
-- breaks, copied verbatim from Blizzard's locale data. OTHER_QUESTS is the
-- addon's own header — Blizzard has no "Other Quests" string — composed per
-- locale from Blizzard's vocabulary (OTHER + TRACKER_HEADER_QUESTS, with
-- grammatical agreement).
--
-- Chat diagnostics deliberately stay English: they exist to be pasted into
-- bug reports.
--
-- Source for Blizzard's strings: Ketho/BlizzardInterfaceResources, branch
-- `live`, Resources/GlobalStrings/<locale>.lua (retail 12.0.5).

local _, ns = ...

-- enUS and enGB, and the base for any locale missing a key.
local L = {
    OTHER_QUESTS = "Other Quests",
    Important = "Important",
    Legendary = "Legendary",
    Meta = "Meta",
    Recurring = "Repeatable",
}
ns.L = L

local translations = {
    deDE = {
        OTHER_QUESTS = "Andere Quests",
        Important = "Wichtig",
        Legendary = "Legendär",
        Meta = "Meta",
        Recurring = "Wiederholbar",
    },
    esES = {
        OTHER_QUESTS = "Otras misiones",
        Important = "Importante",
        Legendary = "Legendaria",
        Meta = "Meta",
        Recurring = "Repetible",
    },
    frFR = {
        OTHER_QUESTS = "Autres quêtes",
        Important = "Important",
        Legendary = "Légendaire",
        Meta = "Méta",
        Recurring = "Répétable",
    },
    itIT = {
        OTHER_QUESTS = "Altre missioni",
        Important = "Importante",
        Legendary = "Leggendaria",
        Meta = "Meta",
        Recurring = "Ripetibile",
    },
    koKR = {
        OTHER_QUESTS = "기타 퀘스트",
        Important = "중요",
        Legendary = "전설",
        Meta = "상위",
        Recurring = "반복 가능",
    },
    ptBR = {
        OTHER_QUESTS = "Outras missões",
        Important = "Importante",
        Legendary = "Lendário",
        Meta = "Meta",
        Recurring = "Repetível",
    },
    ruRU = {
        OTHER_QUESTS = "Другие задания",
        Important = "Важное",
        Legendary = "Легендарное",
        Meta = "Мета",
        Recurring = "Повторяемое",
    },
    zhCN = {
        OTHER_QUESTS = "其它任务",
        Important = "重要",
        Legendary = "传说",
        Meta = "统合",
        Recurring = "可重复",
    },
    zhTW = {
        OTHER_QUESTS = "其他任務",
        Important = "重要",
        Legendary = "傳說",
        Meta = "主任務",
        Recurring = "可重複",
    },
}
-- Blizzard's esMX strings are identical to esES for every key used here.
translations.esMX = translations.esES

local active = GetLocale and translations[GetLocale()]
if active then
    for key, text in pairs(active) do
        L[key] = text
    end
end
