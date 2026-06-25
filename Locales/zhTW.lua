local _, ns = ...
if GetLocale() ~= "zhTW" then return end

-- Traditional Chinese (zhTW). The classification names match Blizzard's own
-- quest-type terms; everything else is the addon's own strings. Anything
-- missing here falls back to English via Locales/enUS.lua.
local L = ns.L

L.OTHER_QUESTS = "其他任務"
L.Important = "重要"
L.Legendary = "傳說"
L.Meta = "主任務"
L.Recurring = "可重複"
L.OPTION_SPLIT_LABEL = "將任務拆分為多個區塊"
L.OPTION_SPLIT_TOOLTIP = "將重要、傳說、主任務和可重複任務分別顯示在各自的區塊中。取消勾選後，所有追蹤的任務將保留在單一區塊中，並仍依類型排序。"
L.MSG_ADDON_DISABLED = "暴雪任務追蹤器已變更；插件已停用。"
L.MSG_SORT_DISABLED_FMT = "%s——任務排序已關閉，恢復預設順序。請重新載入介面（/reload）再試。"
L.MSG_SORT_ERROR_BUILDER = "暴雪任務追蹤器在排序掛勾內發生錯誤"
L.MSG_SORT_CHANGED = "暴雪任務追蹤器發生了預期外的變更"
L.MSG_SORT_REPEATED = "任務排序多次失敗"
L.MSG_SECTIONS_DISABLED = "暴雪任務追蹤器已變更；獨立任務區塊已停用（排序仍然有效）。"
L.MSG_OPTIONS_UNAVAILABLE = "暴雪設定面板已變更；選項核取方塊無法使用（插件將繼續以預設值運作）。"
L.MSG_OPTIONS_FAILED = "無法建立選項核取方塊（插件將繼續以預設值運作）。"
