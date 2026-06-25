local _, ns = ...
if GetLocale() ~= "ruRU" then return end

-- Russian (ruRU). The classification names match Blizzard's own quest-type
-- terms; everything else is the addon's own strings. Anything missing here
-- falls back to English via Locales/enUS.lua.
local L = ns.L

L.OTHER_QUESTS = "Другие задания"
L.Important = "Важное"
L.Legendary = "Легендарное"
L.Meta = "Мета"
L.Recurring = "Повторяемое"
L.OPTION_SPLIT_LABEL = "Разделять задания на секции"
L.OPTION_SPLIT_TOOLTIP = "Важные, легендарные, мета- и повторяемые задания отображаются в отдельных секциях. Если параметр выключен, все отслеживаемые задания остаются в одной секции, по-прежнему отсортированной по типу."
L.MSG_ADDON_DISABLED = "трекер заданий Blizzard изменился; аддон отключён."
L.MSG_SORT_DISABLED_FMT = "%s — сортировка заданий отключена, действует стандартный порядок. Перезагрузите интерфейс (/reload), чтобы попробовать снова."
L.MSG_SORT_ERROR_BUILDER = "трекер заданий Blizzard выдал ошибку внутри перехватчика сортировки"
L.MSG_SORT_CHANGED = "трекер заданий Blizzard изменился неожиданным образом"
L.MSG_SORT_REPEATED = "сортировка заданий неоднократно завершалась ошибкой"
L.MSG_SECTIONS_DISABLED = "трекер заданий Blizzard изменился; отдельные секции заданий отключены (сортировка продолжает работать)."
L.MSG_OPTIONS_UNAVAILABLE = "панель настроек Blizzard изменилась; флажок настройки недоступен (аддон продолжает работать с настройками по умолчанию)."
L.MSG_OPTIONS_FAILED = "не удалось создать флажок настройки (аддон продолжает работать с настройками по умолчанию)."
