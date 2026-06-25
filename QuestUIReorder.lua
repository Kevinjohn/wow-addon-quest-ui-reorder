-- QuestUIReorder
-- Reorganizes the "Quests" section of the Blizzard Objective Tracker.
--
-- Part 1 (sorting) re-sorts the quest list by classification: Important >
-- Legendary > Meta > Repeatable > Storyline ("Local Story") > everything
-- else.
--
-- Part 2 (sections) splits the high-value classifications out into their
-- own collapsible tracker sections — Important, Legendary, Meta,
-- Repeatable — directly above the remaining quests, which stay in the
-- stock section renamed "Other Quests". Each new section is built the way
-- Blizzard builds its own Campaign section: another module frame running
-- the stock quest module's code with a one-line display filter, so
-- collapse buttons, POI buttons, fanfares, and hide-when-empty all come
-- from stock code. A section with nothing to show costs no screen space.
--
-- Display order only: the player's tracked-quest watch list is never
-- modified, entries are never added or dropped, and the Campaign section
-- (a separate tracker module with its own copy of the mixin methods) is
-- never touched. Anything unexpected — an entry failing the watch-list
-- re-check, quest data not streamed in yet, an error from a changed API —
-- yields Blizzard's own behaviour for that pass rather than a guess:
-- repeated sort errors restore the original Blizzard method, and the
-- section split only goes live after every piece of it has succeeded, so
-- a failure costs the split, never a quest.

local ADDON_NAME, ns = ...

-- Translations live in Locales/<locale>.lua (Locales/enUS.lua loaded first
-- via the TOC, ahead of this file); the `or` defaults below keep the addon
-- functional in English even if those files go missing from a package.
local L = (ns and ns.L) or {}

local function PrintMessage(text)
    local prefix = ADDON_NAME
    if ORANGE_FONT_COLOR then
        prefix = ORANGE_FONT_COLOR:WrapTextInColorCode(prefix)
    end
    print(("%s: %s"):format(prefix, text))
end
ns.PrintMessage = PrintMessage

local tracker = QuestObjectiveTracker
local classifications = Enum and Enum.QuestClassification

-- Every external dependency is checked before it is used anywhere, so a
-- future client change degrades to this one chat line, not a load error.
if not (tracker and tracker.BuildQuestWatchInfos
        and classifications
        and C_QuestLog and C_QuestLog.GetQuestWatchType
        and C_QuestInfoSystem and C_QuestInfoSystem.GetQuestClassification) then
    PrintMessage(L.MSG_ADDON_DISABLED
        or "the Blizzard quest tracker has changed; the addon is disabled.")
    return
end

---------------------------------------------------------------------------
-- Part 1: sorting
---------------------------------------------------------------------------
-- Once the Part 2 split is live the four claimed classifications never
-- reach this module, so in practice this orders the catch-all section
-- (Storyline above the rest). It is also the complete fallback: if the
-- split cannot be set up, this alone still delivers one fully sorted
-- Quests section.

-- Highest priority first. A classification name missing from a future
-- client is skipped, so its quests join the "everything else" group
-- instead of erroring at load.
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
    local fmt = L.MSG_SORT_DISABLED_FMT
        or "%s — quest sorting is now off and the default order is in effect. Reload the UI (/reload) to retry."
    PrintMessage(fmt:format(reason))
end

function tracker:BuildQuestWatchInfos()
    -- Calling through this replacement taints the rest of the layout pass, so
    -- Blizzard's own builder runs protected too; if it throws here, restore it
    -- so later layouts run it on a clean path.
    local ok, infos = pcall(origBuildQuestWatchInfos, self)
    if not ok then
        Disable(L.MSG_SORT_ERROR_BUILDER
            or "the Blizzard quest tracker errored inside the sorting hook")
        return {}
    end
    if type(infos) ~= "table" then
        Disable(L.MSG_SORT_CHANGED
            or "the Blizzard quest tracker changed in an unexpected way")
        return infos
    end

    local sortedOk, sorted = pcall(SortWatchInfos, infos)
    if sortedOk then
        consecutiveFailures = 0
        return sorted
    end

    consecutiveFailures = consecutiveFailures + 1
    if consecutiveFailures >= FAILURE_LIMIT then
        Disable(L.MSG_SORT_REPEATED or "quest sorting failed repeatedly")
    end
    return infos
end

---------------------------------------------------------------------------
-- Part 2: classification sections
---------------------------------------------------------------------------

-- The split needs more of the tracker's machinery than the sort does; if
-- any of it has changed, Part 1 alone still provides the full sorted list.
local manager = ObjectiveTrackerManager
local questMixin = QuestObjectiveTrackerMixin
if not (manager
        and type(manager.UpdateAll) == "function"
        and type(manager.SetModuleContainer) == "function"
        and type(manager.GetContainerForModule) == "function"
        and type(questMixin) == "table"
        and type(questMixin.ShouldDisplayQuest) == "function"
        and tracker.ShouldDisplayQuest and tracker.SetHeader
        and tracker.MarkDirty
        and CreateFrame and Mixin and hooksecurefunc) then
    PrintMessage(L.MSG_SECTIONS_DISABLED
        or "the Blizzard quest tracker has changed; separate quest sections are disabled (sorting still works).")
    return
end

-- One entry per new section, in on-screen order, slotted directly above
-- the catch-all. A classification missing from a future client's enum is
-- skipped; its quests stay in the catch-all. Headers use Blizzard's
-- localized quest-type names when available, then the addon's own
-- translations, then English.
local SECTIONS = {
    { name = "Important", fallbackHeader = L.Important or "Important" },
    { name = "Legendary", fallbackHeader = L.Legendary or "Legendary" },
    { name = "Meta",      fallbackHeader = L.Meta or "Meta" },
    { name = "Recurring", fallbackHeader = L.Recurring or "Repeatable" },
}
local OTHER_HEADER = L.OTHER_QUESTS or "Other Quests"

-- The stock quest module's event list minus QUEST_AUTOCOMPLETE: auto-quest
-- popup state is global and the stock module keeps maintaining it; the new
-- sections only need to know when to redraw. Popups, like quests, render
-- in whichever section's display filter claims them.
local SECTION_EVENTS = {
    "QUEST_LOG_UPDATE",
    "QUEST_WATCH_LIST_CHANGED",
    "SUPER_TRACKING_CHANGED",
    "QUEST_TURNED_IN",
    "QUEST_POI_UPDATE",
    "SUPER_TRACKING_PATH_UPDATED",
}

-- Display filters run inside Blizzard's layout pass, where an uncaught
-- error would abort the whole tracker update, so every lookup the addon
-- adds there is guarded. A failed classification lookup reports nil: the
-- quest is claimed by no new section and lands in the catch-all — shown
-- in the wrong group for a pass, never dropped.
local function CallGetQuestClassification(quest)
    return quest:GetQuestClassification()
end

local function GetClassification(quest)
    local ok, classification = pcall(CallGetQuestClassification, quest)
    if ok then
        return classification
    end
    return nil
end

-- Blizzard's own filter (no tasks, bounties, disabled or campaign quests)
-- decides what belongs to the quest tracker at all; each section then
-- claims its classification's slice of that, keeping the sections an
-- exact partition of what the stock module would have shown.
local stockShouldDisplayQuest = questMixin.ShouldDisplayQuest
local function MakeSectionFilter(classification)
    return function(module, quest)
        local ok, stockWants = pcall(stockShouldDisplayQuest, module, quest)
        return ok and stockWants == true
            and GetClassification(quest) == classification
    end
end

local function CreateSection(section, classification)
    local module = CreateFrame("Frame", "QuestUIReorder" .. section.name .. "Tracker",
        nil, "ObjectiveTrackerModuleTemplate")
    Mixin(module, questMixin)
    -- The template binds the OnEvent script before the quest mixin is
    -- copied onto the frame; rebinding guarantees the quest handler
    -- receives events regardless of how method-named scripts resolve.
    module:SetScript("OnEvent", module.OnEvent)

    local info = QuestUtil and QuestUtil.GetQuestClassificationInfo
        and QuestUtil.GetQuestClassificationInfo(classification)
    local headerText = (info and info.text) or section.fallbackHeader
    module.headerText = headerText
    module:SetHeader(headerText)

    module.events = SECTION_EVENTS -- read once, when the manager registers the module
    module.qurClassification = classification
    module.ShouldDisplayQuest = MakeSectionFilter(classification)
    return module
end

local sectionModules = {}
local claimedClassifications = {}
local splitBuilt = false  -- sections created and classifications claimed (once)
local splitActive = false -- sections registered and catch-all narrowed right now
local splitFailed = false -- latched: no further attempts this session

-- The player's one option (see Options.lua): split on (the default) or
-- off. Read straight from the saved variable, defaulting to on, so the
-- split still works even if the options panel could not be registered.
local function IsSplitEnabled()
    local db = QuestUIReorderDB
    return type(db) ~= "table" or db.splitSections ~= false
end

local function RemoveSections()
    for _, module in ipairs(sectionModules) do
        local container = manager:GetContainerForModule(module)
        if container and type(container.RemoveModule) == "function" then
            container:RemoveModule(module) -- also marks the container dirty
        end
        -- A removed module is never laid out again, so stock code can no
        -- longer hide it; do that here or it would linger with stale
        -- content. Events stay registered: re-adding the module skips
        -- registration (the mixin's one-time init flag), and a MarkDirty
        -- from an unlisted module is ignored.
        module:Hide()
    end
end

local function FailSplit()
    RemoveSections()
    for _, module in ipairs(sectionModules) do
        module:UnregisterAllEvents()
    end
    splitFailed = true
    PrintMessage(L.MSG_SECTIONS_DISABLED
        or "the Blizzard quest tracker has changed; separate quest sections are disabled (sorting still works).")
end

-- The catch-all switch is built once and re-applied/restored on toggle,
-- so repeated toggling can never stack wrappers around Blizzard's filter.
local stockShouldDisplay = nil
local stockHeaderText = nil
local narrowedShouldDisplay = nil

local function ApplyCatchAll()
    if not narrowedShouldDisplay then
        stockShouldDisplay = tracker.ShouldDisplayQuest
        stockHeaderText = tracker.headerText
        narrowedShouldDisplay = function(self, quest)
            if not stockShouldDisplay(self, quest) then
                return false
            end
            return not claimedClassifications[GetClassification(quest)]
        end
    end
    tracker.ShouldDisplayQuest = narrowedShouldDisplay
    tracker.headerText = OTHER_HEADER
    tracker:SetHeader(OTHER_HEADER)
end

local function RestoreCatchAll()
    tracker.ShouldDisplayQuest = stockShouldDisplay
    tracker.headerText = stockHeaderText
    tracker:SetHeader(stockHeaderText)
end

local function ActivateSplit()
    -- The container is resolved through the stock quest module rather than
    -- assumed, so the new sections always live wherever Blizzard put the
    -- section they split.
    local container = manager:GetContainerForModule(tracker)
    local questOrder = tracker.uiOrder

    if splitActive then
        -- Self-heal: if something rebuilt the module list (the manager's
        -- RemoveAllModules ends in another UpdateAll), put the sections
        -- back beside the stock quest module — the narrowed catch-all
        -- filter must never run without them.
        if container then
            for _, module in ipairs(sectionModules) do
                if manager:GetContainerForModule(module) ~= container then
                    pcall(manager.SetModuleContainer, manager, module, container)
                end
            end
        end
        return
    end

    -- The manager maps containers and modules in a deferred Init, and until
    -- the stock quest module is mapped and ordered there is nothing safe to
    -- attach to. The Init that completes the mapping always ends in another
    -- UpdateAll, so just wait for it.
    if not container or type(questOrder) ~= "number" then
        return
    end

    -- Build every section once, before touching anything visible.
    if not splitBuilt then
        for _, section in ipairs(SECTIONS) do
            local classification = classifications[section.name]
            if classification ~= nil then
                local ok, module = pcall(CreateSection, section, classification)
                if not ok then
                    FailSplit()
                    return
                end
                table.insert(sectionModules, module)
            end
        end
        if #sectionModules == 0 then
            FailSplit()
            return
        end
        for _, module in ipairs(sectionModules) do
            claimedClassifications[module.qurClassification] = true
        end
        splitBuilt = true
    end

    -- Slot the sections into the gap directly above the stock Quests
    -- module; stock uiOrder values are consecutive integers, so the open
    -- interval below it is free. Registration is pcall'd because the
    -- module's first SetContainer registers its event list, and a renamed
    -- event would otherwise throw out of this hook into Blizzard's Init.
    local step = 1 / (#sectionModules + 1)
    for i, module in ipairs(sectionModules) do
        module.uiOrder = questOrder - (#sectionModules + 1 - i) * step
        if not pcall(manager.SetModuleContainer, manager, module, container) then
            FailSplit()
            return
        end
    end

    -- SetModuleContainer no-ops silently for a container the manager does
    -- not know; verify every registration and roll the whole split back on
    -- any miss, so a half-split can never display a quest twice.
    for _, module in ipairs(sectionModules) do
        if manager:GetContainerForModule(module) ~= container then
            FailSplit()
            return
        end
    end

    -- Only now does anything visible change: the new sections claim their
    -- quests and the stock section becomes the catch-all.
    ApplyCatchAll()
    splitActive = true

    -- A dirty-driven relayout can serve cached layouts for modules it does
    -- not consider dirty, so explicitly dirty everything whose contents
    -- just changed meaning.
    for _, module in ipairs(sectionModules) do
        module:MarkDirty()
    end
    tracker:MarkDirty()
end

local function DeactivateSplit()
    if not splitActive then
        return
    end
    RemoveSections()
    RestoreCatchAll()
    splitActive = false
    tracker:MarkDirty()
end

-- Called below whenever the tracker updates, and by Options.lua when the
-- player toggles the checkbox. Activation self-defers until the tracker
-- is ready; deactivation takes effect immediately.
local function ApplySplitSetting()
    if splitFailed then
        return
    end
    if IsSplitEnabled() then
        ActivateSplit()
    else
        DeactivateSplit()
    end
end
ns.ApplySplitSetting = ApplySplitSetting

-- ObjectiveTrackerManager:Init runs deferred (after PLAYER_ENTERING_WORLD
-- and VARIABLES_LOADED) through a closure captured before any addon could
-- hook Init itself — but it finishes with a dynamic self:UpdateAll(), so
-- hooking that catches the exact moment the tracker becomes ready. Saved
-- variables load before either event, so the setting is readable by then.
hooksecurefunc(manager, "UpdateAll", ApplySplitSetting)
