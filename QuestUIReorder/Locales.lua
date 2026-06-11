-- QuestUIReorder localization. See CONTRIBUTING.md for how to improve or
-- add a translation.
--
-- The four classification section headers normally come from Blizzard's own
-- localized strings at runtime (QuestUtil.GetQuestClassificationInfo), so
-- they appear in the client's language with no help from this file; the
-- per-classification values below are fallbacks for the day that lookup
-- breaks, copied verbatim from Blizzard's locale data — never reworded.
-- OTHER_QUESTS is the addon's own header — Blizzard has no "Other Quests"
-- string — composed per locale from Blizzard's vocabulary (OTHER +
-- TRACKER_HEADER_QUESTS, with grammatical agreement). OPTION_* strings
-- label the checkbox in the Settings panel; the quest-type names inside
-- each tooltip are Blizzard's exact terms for that locale.
--
-- MSG_* strings are the chat diagnostics. Every failure mode has its own
-- distinct key, so a pasted bug report identifies the exact failure in any
-- language. MSG_SORT_DISABLED_FMT must keep its %s placeholder (the
-- failure reason is inserted there); "/reload" stays literal everywhere.
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
}
ns.L = L

local translations = {
    deDE = {
        OTHER_QUESTS = "Andere Quests",
        Important = "Wichtig",
        Legendary = "Legendär",
        Meta = "Meta",
        Recurring = "Wiederholbar",
        OPTION_SPLIT_LABEL = "Quests in Abschnitte aufteilen",
        OPTION_SPLIT_TOOLTIP = "Zeigt wichtige, legendäre, Meta- und wiederholbare Quests in eigenen Abschnitten an. Wenn deaktiviert, bleiben alle verfolgten Quests in einem einzelnen, weiterhin nach Typ sortierten Abschnitt.",
        MSG_ADDON_DISABLED = "der Blizzard-Quest-Tracker hat sich geändert; das Addon ist deaktiviert.",
        MSG_SORT_DISABLED_FMT = "%s — die Questsortierung ist jetzt aus und die Standardreihenfolge gilt. Lade die UI neu (/reload), um es erneut zu versuchen.",
        MSG_SORT_ERROR_BUILDER = "im Sortierungs-Hook ist ein Fehler des Blizzard-Quest-Trackers aufgetreten",
        MSG_SORT_CHANGED = "der Blizzard-Quest-Tracker hat sich unerwartet geändert",
        MSG_SORT_REPEATED = "die Questsortierung ist wiederholt fehlgeschlagen",
        MSG_SECTIONS_DISABLED = "der Blizzard-Quest-Tracker hat sich geändert; separate Questabschnitte sind deaktiviert (die Sortierung funktioniert weiterhin).",
        MSG_OPTIONS_UNAVAILABLE = "das Einstellungsfenster von Blizzard hat sich geändert; das Optionskästchen ist nicht verfügbar (das Addon funktioniert weiter mit den Standardwerten).",
        MSG_OPTIONS_FAILED = "das Optionskästchen konnte nicht erstellt werden (das Addon funktioniert weiter mit den Standardwerten).",
    },
    esES = {
        OTHER_QUESTS = "Otras misiones",
        Important = "Importante",
        Legendary = "Legendaria",
        Meta = "Meta",
        Recurring = "Repetible",
        OPTION_SPLIT_LABEL = "Dividir las misiones en secciones",
        OPTION_SPLIT_TOOLTIP = "Muestra las misiones importantes, legendarias, meta y repetibles en secciones propias. Si se desactiva, todas las misiones seguidas permanecen en una sola sección, ordenada igualmente por tipo.",
        MSG_ADDON_DISABLED = "el rastreador de misiones de Blizzard ha cambiado; el accesorio está desactivado.",
        MSG_SORT_DISABLED_FMT = "%s — la ordenación de misiones está ahora desactivada y se aplica el orden predeterminado. Recarga la interfaz (/reload) para reintentarlo.",
        MSG_SORT_ERROR_BUILDER = "el rastreador de misiones de Blizzard produjo un error dentro del gancho de ordenación",
        MSG_SORT_CHANGED = "el rastreador de misiones de Blizzard ha cambiado de forma inesperada",
        MSG_SORT_REPEATED = "la ordenación de misiones ha fallado repetidamente",
        MSG_SECTIONS_DISABLED = "el rastreador de misiones de Blizzard ha cambiado; las secciones de misiones separadas están desactivadas (la ordenación sigue funcionando).",
        MSG_OPTIONS_UNAVAILABLE = "el panel de opciones de Blizzard ha cambiado; la casilla de opciones no está disponible (el accesorio sigue funcionando con sus valores predeterminados).",
        MSG_OPTIONS_FAILED = "no se pudo crear la casilla de opciones (el accesorio sigue funcionando con sus valores predeterminados).",
    },
    frFR = {
        OTHER_QUESTS = "Autres quêtes",
        Important = "Important",
        Legendary = "Légendaire",
        Meta = "Méta",
        Recurring = "Répétable",
        OPTION_SPLIT_LABEL = "Diviser les quêtes en sections",
        OPTION_SPLIT_TOOLTIP = "Affiche les quêtes importantes, légendaires, méta et répétables dans des sections dédiées. Si désactivé, toutes les quêtes suivies restent dans une seule section, toujours triée par type.",
        MSG_ADDON_DISABLED = "le suivi des quêtes de Blizzard a changé ; l'addon est désactivé.",
        MSG_SORT_DISABLED_FMT = "%s — le tri des quêtes est désormais désactivé et l'ordre par défaut s'applique. Rechargez l'interface (/reload) pour réessayer.",
        MSG_SORT_ERROR_BUILDER = "le suivi des quêtes de Blizzard a rencontré une erreur dans le crochet de tri",
        MSG_SORT_CHANGED = "le suivi des quêtes de Blizzard a changé de manière inattendue",
        MSG_SORT_REPEATED = "le tri des quêtes a échoué à plusieurs reprises",
        MSG_SECTIONS_DISABLED = "le suivi des quêtes de Blizzard a changé ; les sections de quêtes séparées sont désactivées (le tri fonctionne toujours).",
        MSG_OPTIONS_UNAVAILABLE = "le panneau d'options de Blizzard a changé ; la case d'option n'est pas disponible (l'addon continue de fonctionner avec ses valeurs par défaut).",
        MSG_OPTIONS_FAILED = "la case d'option n'a pas pu être créée (l'addon continue de fonctionner avec ses valeurs par défaut).",
    },
    itIT = {
        OTHER_QUESTS = "Altre missioni",
        Important = "Importante",
        Legendary = "Leggendaria",
        Meta = "Meta",
        Recurring = "Ripetibile",
        OPTION_SPLIT_LABEL = "Dividi le missioni in sezioni",
        OPTION_SPLIT_TOOLTIP = "Mostra le missioni importanti, leggendarie, meta e ripetibili in sezioni dedicate. Se disattivato, tutte le missioni seguite restano in un'unica sezione, comunque ordinata per tipo.",
        MSG_ADDON_DISABLED = "il tracciamento delle missioni di Blizzard è cambiato; l'addon è disattivato.",
        MSG_SORT_DISABLED_FMT = "%s — l'ordinamento delle missioni è ora disattivato ed è attivo l'ordine predefinito. Ricarica l'interfaccia (/reload) per riprovare.",
        MSG_SORT_ERROR_BUILDER = "il tracciamento delle missioni di Blizzard ha generato un errore nell'hook di ordinamento",
        MSG_SORT_CHANGED = "il tracciamento delle missioni di Blizzard è cambiato in modo inatteso",
        MSG_SORT_REPEATED = "l'ordinamento delle missioni è fallito ripetutamente",
        MSG_SECTIONS_DISABLED = "il tracciamento delle missioni di Blizzard è cambiato; le sezioni separate delle missioni sono disattivate (l'ordinamento continua a funzionare).",
        MSG_OPTIONS_UNAVAILABLE = "il pannello delle impostazioni di Blizzard è cambiato; la casella delle opzioni non è disponibile (l'addon continua a funzionare con le impostazioni predefinite).",
        MSG_OPTIONS_FAILED = "non è stato possibile creare la casella delle opzioni (l'addon continua a funzionare con le impostazioni predefinite).",
    },
    koKR = {
        OTHER_QUESTS = "기타 퀘스트",
        Important = "중요",
        Legendary = "전설",
        Meta = "상위",
        Recurring = "반복 가능",
        OPTION_SPLIT_LABEL = "퀘스트를 섹션으로 분리",
        OPTION_SPLIT_TOOLTIP = "중요, 전설, 상위, 반복 가능 퀘스트를 각각의 섹션에 표시합니다. 해제하면 모든 추적 퀘스트가 유형별로 정렬된 하나의 섹션에 표시됩니다.",
        MSG_ADDON_DISABLED = "블리자드 퀘스트 추적기가 변경되어 애드온이 비활성화되었습니다.",
        MSG_SORT_DISABLED_FMT = "%s — 퀘스트 정렬이 꺼졌으며 기본 순서가 적용됩니다. 다시 시도하려면 인터페이스를 다시 불러오세요(/reload).",
        MSG_SORT_ERROR_BUILDER = "정렬 후크 내부에서 블리자드 퀘스트 추적기에 오류가 발생했습니다",
        MSG_SORT_CHANGED = "블리자드 퀘스트 추적기가 예기치 않게 변경되었습니다",
        MSG_SORT_REPEATED = "퀘스트 정렬이 반복적으로 실패했습니다",
        MSG_SECTIONS_DISABLED = "블리자드 퀘스트 추적기가 변경되어 별도 퀘스트 섹션이 비활성화되었습니다(정렬은 계속 작동합니다).",
        MSG_OPTIONS_UNAVAILABLE = "블리자드 설정 창이 변경되어 옵션 체크박스를 사용할 수 없습니다(애드온은 기본값으로 계속 작동합니다).",
        MSG_OPTIONS_FAILED = "옵션 체크박스를 만들 수 없습니다(애드온은 기본값으로 계속 작동합니다).",
    },
    ptBR = {
        OTHER_QUESTS = "Outras missões",
        Important = "Importante",
        Legendary = "Lendário",
        Meta = "Meta",
        Recurring = "Repetível",
        OPTION_SPLIT_LABEL = "Dividir as missões em seções",
        OPTION_SPLIT_TOOLTIP = "Mostra missões importantes, lendárias, meta e repetíveis em seções próprias. Quando desativado, todas as missões acompanhadas ficam em uma única seção, ainda ordenada por tipo.",
        MSG_ADDON_DISABLED = "o rastreador de missões da Blizzard mudou; o addon está desativado.",
        MSG_SORT_DISABLED_FMT = "%s — a ordenação de missões está desligada e a ordem padrão está em vigor. Recarregue a interface (/reload) para tentar novamente.",
        MSG_SORT_ERROR_BUILDER = "o rastreador de missões da Blizzard gerou um erro dentro do gancho de ordenação",
        MSG_SORT_CHANGED = "o rastreador de missões da Blizzard mudou de forma inesperada",
        MSG_SORT_REPEATED = "a ordenação de missões falhou repetidamente",
        MSG_SECTIONS_DISABLED = "o rastreador de missões da Blizzard mudou; as seções separadas de missões estão desativadas (a ordenação continua funcionando).",
        MSG_OPTIONS_UNAVAILABLE = "o painel de opções da Blizzard mudou; a caixa de opções não está disponível (o addon continua funcionando com os padrões).",
        MSG_OPTIONS_FAILED = "não foi possível criar a caixa de opções (o addon continua funcionando com os padrões).",
    },
    ruRU = {
        OTHER_QUESTS = "Другие задания",
        Important = "Важное",
        Legendary = "Легендарное",
        Meta = "Мета",
        Recurring = "Повторяемое",
        OPTION_SPLIT_LABEL = "Разделять задания на секции",
        OPTION_SPLIT_TOOLTIP = "Важные, легендарные, мета- и повторяемые задания отображаются в отдельных секциях. Если параметр выключен, все отслеживаемые задания остаются в одной секции, по-прежнему отсортированной по типу.",
        MSG_ADDON_DISABLED = "трекер заданий Blizzard изменился; аддон отключён.",
        MSG_SORT_DISABLED_FMT = "%s — сортировка заданий отключена, действует стандартный порядок. Перезагрузите интерфейс (/reload), чтобы попробовать снова.",
        MSG_SORT_ERROR_BUILDER = "трекер заданий Blizzard выдал ошибку внутри перехватчика сортировки",
        MSG_SORT_CHANGED = "трекер заданий Blizzard изменился неожиданным образом",
        MSG_SORT_REPEATED = "сортировка заданий неоднократно завершалась ошибкой",
        MSG_SECTIONS_DISABLED = "трекер заданий Blizzard изменился; отдельные секции заданий отключены (сортировка продолжает работать).",
        MSG_OPTIONS_UNAVAILABLE = "панель настроек Blizzard изменилась; флажок настройки недоступен (аддон продолжает работать с настройками по умолчанию).",
        MSG_OPTIONS_FAILED = "не удалось создать флажок настройки (аддон продолжает работать с настройками по умолчанию).",
    },
    zhCN = {
        OTHER_QUESTS = "其它任务",
        Important = "重要",
        Legendary = "传说",
        Meta = "统合",
        Recurring = "可重复",
        OPTION_SPLIT_LABEL = "将任务拆分为多个区域",
        OPTION_SPLIT_TOOLTIP = "将重要、传说、统合和可重复任务分别显示在各自的区域中。取消勾选后，所有追踪的任务将保留在单个区域中，并仍按类型排序。",
        MSG_ADDON_DISABLED = "暴雪任务追踪器已变更；插件已禁用。",
        MSG_SORT_DISABLED_FMT = "%s——任务排序已关闭，恢复默认顺序。请重载界面（/reload）重试。",
        MSG_SORT_ERROR_BUILDER = "暴雪任务追踪器在排序挂钩内发生错误",
        MSG_SORT_CHANGED = "暴雪任务追踪器发生了意外变更",
        MSG_SORT_REPEATED = "任务排序多次失败",
        MSG_SECTIONS_DISABLED = "暴雪任务追踪器已变更；独立任务区域已禁用（排序仍然有效）。",
        MSG_OPTIONS_UNAVAILABLE = "暴雪设置面板已变更；选项复选框不可用（插件将继续以默认设置运行）。",
        MSG_OPTIONS_FAILED = "无法创建选项复选框（插件将继续以默认设置运行）。",
    },
    zhTW = {
        OTHER_QUESTS = "其他任務",
        Important = "重要",
        Legendary = "傳說",
        Meta = "主任務",
        Recurring = "可重複",
        OPTION_SPLIT_LABEL = "將任務拆分為多個區塊",
        OPTION_SPLIT_TOOLTIP = "將重要、傳說、主任務和可重複任務分別顯示在各自的區塊中。取消勾選後，所有追蹤的任務將保留在單一區塊中，並仍依類型排序。",
        MSG_ADDON_DISABLED = "暴雪任務追蹤器已變更；插件已停用。",
        MSG_SORT_DISABLED_FMT = "%s——任務排序已關閉，恢復預設順序。請重新載入介面（/reload）再試。",
        MSG_SORT_ERROR_BUILDER = "暴雪任務追蹤器在排序掛勾內發生錯誤",
        MSG_SORT_CHANGED = "暴雪任務追蹤器發生了預期外的變更",
        MSG_SORT_REPEATED = "任務排序多次失敗",
        MSG_SECTIONS_DISABLED = "暴雪任務追蹤器已變更；獨立任務區塊已停用（排序仍然有效）。",
        MSG_OPTIONS_UNAVAILABLE = "暴雪設定面板已變更；選項核取方塊無法使用（插件將繼續以預設值運作）。",
        MSG_OPTIONS_FAILED = "無法建立選項核取方塊（插件將繼續以預設值運作）。",
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
