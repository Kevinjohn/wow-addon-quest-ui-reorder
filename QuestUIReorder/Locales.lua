-- QuestUIReorder localization.
--
-- The four classification section headers normally come from Blizzard's own
-- localized strings at runtime (QuestUtil.GetQuestClassificationInfo), so
-- they appear in the client's language with no help from this file; the
-- per-classification values below are fallbacks for the day that lookup
-- breaks, copied verbatim from Blizzard's locale data. OTHER_QUESTS is the
-- addon's own header — Blizzard has no "Other Quests" string — composed per
-- locale from Blizzard's vocabulary (OTHER + TRACKER_HEADER_QUESTS, with
-- grammatical agreement). OPTION_* strings label the checkbox in the
-- Settings panel; the quest-type names inside each tooltip are Blizzard's
-- exact terms for that locale.
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
    OPTION_SPLIT_LABEL = "Split quests into sections by type",
    OPTION_SPLIT_TOOLTIP = "Show Important, Legendary, Meta, and Repeatable quests in their own sections. When unchecked, all tracked quests stay in one Quests section, still sorted by type.",
}
ns.L = L

local translations = {
    deDE = {
        OTHER_QUESTS = "Andere Quests",
        Important = "Wichtig",
        Legendary = "Legendär",
        Meta = "Meta",
        Recurring = "Wiederholbar",
        OPTION_SPLIT_LABEL = "Quests nach Typ in Abschnitte aufteilen",
        OPTION_SPLIT_TOOLTIP = "Zeigt wichtige, legendäre, Meta- und wiederholbare Quests in eigenen Abschnitten an. Wenn deaktiviert, bleiben alle verfolgten Quests in einem einzelnen, weiterhin nach Typ sortierten Abschnitt.",
    },
    esES = {
        OTHER_QUESTS = "Otras misiones",
        Important = "Importante",
        Legendary = "Legendaria",
        Meta = "Meta",
        Recurring = "Repetible",
        OPTION_SPLIT_LABEL = "Dividir las misiones en secciones por tipo",
        OPTION_SPLIT_TOOLTIP = "Muestra las misiones importantes, legendarias, meta y repetibles en secciones propias. Si se desactiva, todas las misiones seguidas permanecen en una sola sección, ordenada igualmente por tipo.",
    },
    frFR = {
        OTHER_QUESTS = "Autres quêtes",
        Important = "Important",
        Legendary = "Légendaire",
        Meta = "Méta",
        Recurring = "Répétable",
        OPTION_SPLIT_LABEL = "Diviser les quêtes en sections par type",
        OPTION_SPLIT_TOOLTIP = "Affiche les quêtes importantes, légendaires, méta et répétables dans des sections dédiées. Si désactivé, toutes les quêtes suivies restent dans une seule section, toujours triée par type.",
    },
    itIT = {
        OTHER_QUESTS = "Altre missioni",
        Important = "Importante",
        Legendary = "Leggendaria",
        Meta = "Meta",
        Recurring = "Ripetibile",
        OPTION_SPLIT_LABEL = "Dividi le missioni in sezioni per tipo",
        OPTION_SPLIT_TOOLTIP = "Mostra le missioni importanti, leggendarie, meta e ripetibili in sezioni dedicate. Se disattivato, tutte le missioni seguite restano in un'unica sezione, comunque ordinata per tipo.",
    },
    koKR = {
        OTHER_QUESTS = "기타 퀘스트",
        Important = "중요",
        Legendary = "전설",
        Meta = "상위",
        Recurring = "반복 가능",
        OPTION_SPLIT_LABEL = "퀘스트를 유형별 섹션으로 분리",
        OPTION_SPLIT_TOOLTIP = "중요, 전설, 상위, 반복 가능 퀘스트를 각각의 섹션에 표시합니다. 해제하면 모든 추적 퀘스트가 유형별로 정렬된 하나의 섹션에 표시됩니다.",
    },
    ptBR = {
        OTHER_QUESTS = "Outras missões",
        Important = "Importante",
        Legendary = "Lendário",
        Meta = "Meta",
        Recurring = "Repetível",
        OPTION_SPLIT_LABEL = "Dividir as missões em seções por tipo",
        OPTION_SPLIT_TOOLTIP = "Mostra missões importantes, lendárias, meta e repetíveis em seções próprias. Quando desativado, todas as missões acompanhadas ficam em uma única seção, ainda ordenada por tipo.",
    },
    ruRU = {
        OTHER_QUESTS = "Другие задания",
        Important = "Важное",
        Legendary = "Легендарное",
        Meta = "Мета",
        Recurring = "Повторяемое",
        OPTION_SPLIT_LABEL = "Разделять задания на секции по типу",
        OPTION_SPLIT_TOOLTIP = "Важные, легендарные, мета- и повторяемые задания отображаются в отдельных секциях. Если параметр выключен, все отслеживаемые задания остаются в одной секции, по-прежнему отсортированной по типу.",
    },
    zhCN = {
        OTHER_QUESTS = "其它任务",
        Important = "重要",
        Legendary = "传说",
        Meta = "统合",
        Recurring = "可重复",
        OPTION_SPLIT_LABEL = "按类型将任务拆分为多个区域",
        OPTION_SPLIT_TOOLTIP = "将重要、传说、统合和可重复任务分别显示在各自的区域中。取消勾选后，所有追踪的任务将保留在单个区域中，并仍按类型排序。",
    },
    zhTW = {
        OTHER_QUESTS = "其他任務",
        Important = "重要",
        Legendary = "傳說",
        Meta = "主任務",
        Recurring = "可重複",
        OPTION_SPLIT_LABEL = "依類型將任務拆分為多個區塊",
        OPTION_SPLIT_TOOLTIP = "將重要、傳說、主任務和可重複任務分別顯示在各自的區塊中。取消勾選後，所有追蹤的任務將保留在單一區塊中，並仍依類型排序。",
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
