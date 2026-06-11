-- QuestUIReorder options: one checkbox in the game's own Settings panel,
-- under the AddOns tab (Esc > Options > AddOns > Quest UI Reorder).
--
-- The checkbox toggles the section split live — no /reload. Sorting is
-- the addon's reason to exist and is deliberately not optional. The
-- setting is account-wide and read with a default of "on", so a missing
-- options panel or deleted saved variable means stock behaviour.
--
-- API notes (verified against live 12.0.5 source, Blizzard_Settings_Shared):
-- RegisterAddOnSetting writes the default into the saved-variables table
-- before returning if the key is nil, but asserts the table itself exists;
-- the `variable` string must be unique across every addon's settings or
-- the panel hard-errors; and the real enum keys are Settings.VarType.Boolean
-- and Settings.Default.True (the comment in Blizzard's file saying
-- "VarType.Bool"/"Defaults" is stale — do not trust it).

local ADDON_NAME, ns = ...

-- If the main file disabled itself (or just the split) at load, the
-- checkbox would toggle nothing; don't offer one.
if type(ns) ~= "table" or type(ns.ApplySplitSetting) ~= "function" then
    return
end

local L = ns.L or {}

if not (Settings
        and type(Settings.RegisterVerticalLayoutCategory) == "function"
        and type(Settings.RegisterAddOnSetting) == "function"
        and type(Settings.CreateCheckbox) == "function"
        and type(Settings.RegisterAddOnCategory) == "function"
        and type(Settings.VarType) == "table"
        and EventUtil and type(EventUtil.ContinueOnAddOnLoaded) == "function") then
    ns.PrintMessage(L.MSG_OPTIONS_UNAVAILABLE
        or "the Blizzard settings panel has changed; the options checkbox is unavailable (the addon keeps working with its defaults).")
    return
end

local function RegisterOptions()
    -- First ever run: the saved-variables table itself does not exist yet.
    QuestUIReorderDB = QuestUIReorderDB or {}

    local category = Settings.RegisterVerticalLayoutCategory("Quest UI Reorder")

    local setting = Settings.RegisterAddOnSetting(
        category,
        "QuestUIReorder_SplitSections",                          -- globally unique variable id
        "splitSections",                                         -- key in QuestUIReorderDB
        QuestUIReorderDB,
        Settings.VarType.Boolean,
        L.OPTION_SPLIT_LABEL or "Split quests into sections",
        true                                                     -- Settings.Default.True
    )
    assert(setting and type(setting.SetValueChangedCallback) == "function",
        "unexpected setting object")
    setting:SetValueChangedCallback(function()
        ns.ApplySplitSetting()
    end)

    Settings.CreateCheckbox(category, setting,
        L.OPTION_SPLIT_TOOLTIP
            or "Show Important, Legendary, Meta, and Repeatable quests in their own sections. When unchecked, all tracked quests stay in one Quests section, still sorted by type.")

    Settings.RegisterAddOnCategory(category)
end

-- Saved variables are only readable once ADDON_LOADED has fired for this
-- addon; ContinueOnAddOnLoaded is Blizzard's own helper for exactly that.
EventUtil.ContinueOnAddOnLoaded(ADDON_NAME, function()
    if not pcall(RegisterOptions) then
        ns.PrintMessage(L.MSG_OPTIONS_FAILED
            or "the options checkbox could not be created (the addon keeps working with its defaults).")
    end
end)
