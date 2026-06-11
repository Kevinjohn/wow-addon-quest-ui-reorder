std = "lua51"
max_line_length = false

read_globals = {
    -- WoW API
    "C_QuestInfoSystem",
    "C_QuestLog",
    "Enum",
    "ORANGE_FONT_COLOR",
    -- Blizzard tracker frame: read-only, except the single field below
    "QuestObjectiveTracker",
}

-- The one Blizzard field this addon is allowed to replace
globals = {
    "QuestObjectiveTracker.BuildQuestWatchInfos",
}
