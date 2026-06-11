std = "lua51"
max_line_length = false

read_globals = {
    -- WoW API
    "C_QuestInfoSystem",
    "C_QuestLog",
    "CreateFrame",
    "Enum",
    "EventUtil",
    "GetLocale",
    "Settings",
    "hooksecurefunc",
    "Mixin",
    "ORANGE_FONT_COLOR",
    -- Blizzard tracker globals: read-only, except the fields below
    "ObjectiveTrackerManager",
    "QuestObjectiveTracker",
    "QuestObjectiveTrackerMixin",
    "QuestUtil",
}

-- The only Blizzard fields this addon is allowed to replace, plus the
-- addon's own saved-variables table
globals = {
    "QuestObjectiveTracker.BuildQuestWatchInfos",
    "QuestObjectiveTracker.ShouldDisplayQuest",
    "QuestObjectiveTracker.headerText",
    "QuestUIReorderDB",
}
