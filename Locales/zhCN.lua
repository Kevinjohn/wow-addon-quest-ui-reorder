local _, ns = ...
if GetLocale() ~= "zhCN" then return end

-- Simplified Chinese (zhCN). The classification names match Blizzard's own
-- quest-type terms; everything else is the addon's own strings. Anything
-- missing here falls back to English via Locales/enUS.lua.
local L = ns.L

L.OTHER_QUESTS = "其它任务"
L.Important = "重要"
L.Legendary = "传说"
L.Meta = "统合"
L.Recurring = "可重复"
L.OPTION_SPLIT_LABEL = "将任务拆分为多个区域"
L.OPTION_SPLIT_TOOLTIP = "将重要、传说、统合和可重复任务分别显示在各自的区域中。取消勾选后，所有追踪的任务将保留在单个区域中，并仍按类型排序。"
L.OPTION_SPLIT_WARNING_121 = "警告：由于 12.1 版本的一个错误，开启此选项时任务追踪器不会更新，必须使用 /reload 才能看到变化。暴雪预计将在 12.1.5 中修复。在此之前建议保持关闭。"
L.MSG_SPLIT_RESET_121 = "任务分区已关闭：12.1 版本的一个错误导致分区开启时任务追踪器无法更新。排序仍然有效。你可以在插件选项中重新开启分区。"
L.MSG_DISABLED_121_TAINT = "已在 12.1 版本中停用：暴雪的一个错误会导致插件修改任务追踪器时整个追踪器卡住。本插件不会做任何修改。待该问题修复后将恢复工作。"
L.OPTION_SPLIT_OVERRIDE_121 = "勾选后，插件将在 /reload 之后照常运行。届时任务追踪器将停止更新，直到你再次重载界面。"
L.MSG_ADDON_DISABLED = "暴雪任务追踪器已变更；插件已禁用。"
L.MSG_SORT_DISABLED_FMT = "%s——任务排序已关闭，恢复默认顺序。请重载界面（/reload）重试。"
L.MSG_SORT_ERROR_BUILDER = "暴雪任务追踪器在排序挂钩内发生错误"
L.MSG_SORT_CHANGED = "暴雪任务追踪器发生了意外变更"
L.MSG_SORT_REPEATED = "任务排序多次失败"
L.MSG_SECTIONS_DISABLED = "暴雪任务追踪器已变更；独立任务区域已禁用（排序仍然有效）。"
L.MSG_OPTIONS_UNAVAILABLE = "暴雪设置面板已变更；选项复选框不可用（插件将继续以默认设置运行）。"
L.MSG_OPTIONS_FAILED = "无法创建选项复选框（插件将继续以默认设置运行）。"
