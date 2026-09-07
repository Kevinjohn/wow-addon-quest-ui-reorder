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
L.OPTION_SORT_LABEL = "按类型排序任务"
L.OPTION_SORT_TOOLTIP = "将追踪的任务按类型排序：重要、传说、统合、可重复、故事线，然后是其余任务。"
L.OPTION_121_NOTE = "12.1 版本提示：暴雪的任务追踪器仍保留着暗影国度时期的代码，每次重绘都会检查你的增益效果。12.1 锁定了增益数据，因此只要插件改动追踪器，该检查就可能失败，追踪器会停止更新，直到你执行 /reload。"
L.OPTION_NEEDS_RELOAD = "此项更改需要 /reload 后生效。"
L.MSG_OPT_IN_RESET = "两项功能现在都处于关闭状态，需你手动开启：请在插件选项中查看它们在 12.1 版本中的影响。"
L.MSG_ADDON_DISABLED = "暴雪任务追踪器已变更；插件已禁用。"
L.MSG_SORT_DISABLED_FMT = "%s——任务排序已关闭，恢复默认顺序。请重载界面（/reload）重试。"
L.MSG_SORT_ERROR_BUILDER = "暴雪任务追踪器在排序挂钩内发生错误"
L.MSG_SORT_CHANGED = "暴雪任务追踪器发生了意外变更"
L.MSG_SORT_REPEATED = "任务排序多次失败"
L.MSG_SECTIONS_DISABLED = "暴雪任务追踪器已变更；独立任务区域已禁用（排序仍然有效）。"
L.MSG_OPTIONS_UNAVAILABLE = "暴雪设置面板已变更；选项复选框不可用（插件将继续以默认设置运行）。"
L.MSG_OPTIONS_FAILED = "无法创建选项复选框（插件将继续以默认设置运行）。"
