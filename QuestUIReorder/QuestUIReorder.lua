-- QuestUIReorder
-- Re-sorts the "Quests" section of the Blizzard Objective Tracker by quest
-- classification: Important > Legendary > Meta > Repeatable > Storyline
-- ("Local Story") > everything else.
--
-- Display order only: the player's tracked-quest watch list is never modified,
-- entries are never added or dropped, and the Campaign section (a separate
-- tracker module with its own copy of the mixin methods) is never touched.
-- Anything unexpected — an entry failing the watch-list re-check, quest data
-- not streamed in yet, an error from a changed API — yields Blizzard's own
-- order for that pass rather than a guess, and repeated errors restore the
-- original Blizzard method entirely.

local ADDON_NAME = ...

local function PrintMessage(text)
    local prefix = ADDON_NAME
    if ORANGE_FONT_COLOR then
        prefix = ORANGE_FONT_COLOR:WrapTextInColorCode(prefix)
    end
    print(("%s: %s"):format(prefix, text))
end

local tracker = QuestObjectiveTracker
local classifications = Enum and Enum.QuestClassification

-- Every external dependency is checked before it is used anywhere, so a
-- future client change degrades to this one chat line, not a load error.
if not (tracker and tracker.BuildQuestWatchInfos
        and classifications
        and C_QuestLog and C_QuestLog.GetQuestWatchType
        and C_QuestInfoSystem and C_QuestInfoSystem.GetQuestClassification) then
    PrintMessage("the Blizzard quest tracker has changed; quest sorting is disabled.")
    return
end

-- Highest priority first. A classification name missing from a future client
-- is skipped, so its quests join the "everything else" group instead of
-- erroring at load.
local PRIORITY_NAMES = {
    "Important",
    "Legendary",
    "Meta",
    "Recurring", -- tagged "Repeatable" in-game
    "Questline", -- tagged "Storyline"; "Local Story" on the world map
}
local CLASSIFICATION_PRIORITY = {}
for i, name in ipairs(PRIORITY_NAMES) do
    if classifications[name] ~= nil then
        CLASSIFICATION_PRIORITY[classifications[name]] = i
    end
end
local OTHER_PRIORITY = #PRIORITY_NAMES + 1

local function CompareOrder(a, b)
    return a.qurOrder < b.qurOrder
end

-- Stamps each entry with one combined key (classification priority, then
-- incoming position) and sorts in place. Every key is distinct, so Lua's
-- unstable table.sort still produces a stable result: within a group,
-- Blizzard's own order (proximity re-sort on zone change, etc.) is kept.
--
-- Never filters: if an entry fails the watch-list re-check, or its
-- classification has not streamed in yet (fresh login, loading screen), the
-- whole list is returned untouched in Blizzard's order and a later pass
-- sorts it once the data is consistent.
local function SortWatchInfos(infos)
    local stride = #infos + 1
    for index, info in ipairs(infos) do
        local questID = info.quest:GetID()
        if C_QuestLog.GetQuestWatchType(questID) == nil then
            return infos
        end
        local classification = C_QuestInfoSystem.GetQuestClassification(questID)
        if classification == nil then
            return infos
        end
        info.qurOrder = (CLASSIFICATION_PRIORITY[classification] or OTHER_PRIORITY) * stride + index
    end
    table.sort(infos, CompareOrder)
    return infos
end

local origBuildQuestWatchInfos = tracker.BuildQuestWatchInfos
local FAILURE_LIMIT = 10
local consecutiveFailures = 0

local function Disable(reason)
    tracker.BuildQuestWatchInfos = origBuildQuestWatchInfos
    PrintMessage(reason .. " — quest sorting is now off and the default order is in effect. Reload the UI (/reload) to retry.")
end

function tracker:BuildQuestWatchInfos()
    -- Calling through this replacement taints the rest of the layout pass, so
    -- Blizzard's own builder runs protected too; if it throws here, restore it
    -- so later layouts run it on a clean path.
    local ok, infos = pcall(origBuildQuestWatchInfos, self)
    if not ok then
        Disable("the Blizzard quest tracker errored inside the sorting hook")
        return {}
    end
    if type(infos) ~= "table" then
        Disable("the Blizzard quest tracker changed in an unexpected way")
        return infos
    end

    local sortedOk, sorted = pcall(SortWatchInfos, infos)
    if sortedOk then
        consecutiveFailures = 0
        return sorted
    end

    consecutiveFailures = consecutiveFailures + 1
    if consecutiveFailures >= FAILURE_LIMIT then
        Disable("quest sorting failed repeatedly")
    end
    return infos
end
