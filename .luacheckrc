std = "lua51"
max_line_length = false

read_globals = {
    -- WoW API
    "C_QuestInfoSystem",
    "C_QuestLog",
    "CreateFrame",
    "Enum",
    "hooksecurefunc",
    "Mixin",
    "ORANGE_FONT_COLOR",
    -- Blizzard tracker globals: read-only, except the fields below
    "ObjectiveTrackerManager",
    "QuestObjectiveTracker",
    "QuestObjectiveTrackerMixin",
    "QuestUtil",
}

-- The only Blizzard fields this addon is allowed to replace
globals = {
    "QuestObjectiveTracker.BuildQuestWatchInfos",
    "QuestObjectiveTracker.ShouldDisplayQuest",
    "QuestObjectiveTracker.headerText",
}
