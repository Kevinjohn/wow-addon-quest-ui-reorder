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

local _, ns = ...

if type(ns) ~= "table" then
    return
end

local L = ns.L or {}

if not (Settings
        and type(Settings.RegisterVerticalLayoutCategory) == "function"
        and type(Settings.RegisterAddOnSetting) == "function"
        and type(Settings.CreateCheckbox) == "function"
        and type(Settings.RegisterAddOnCategory) == "function"
        and type(Settings.VarType) == "table") then
    ns.PrintMessage(L.MSG_OPTIONS_UNAVAILABLE
        or "the Blizzard settings panel has changed; the options checkbox is unavailable (the addon keeps working with its defaults).")
    return
end

local function RegisterOptions()
    -- First ever run: the saved-variables table itself does not exist yet.
    QuestUIReorderDB = QuestUIReorderDB or {}

    -- Must run before RegisterAddOnSetting: that call reads the stored value
    -- to seed the checkbox, so migrating afterwards would leave the box shown
    -- as checked while the split was actually off.
    if type(ns.ResetSplitForRetail121) == "function" then
        ns.ResetSplitForRetail121()
    end

    local category = Settings.RegisterVerticalLayoutCategory("Quest UI Reorder")

    local setting = Settings.RegisterAddOnSetting(
        category,
        "QuestUIReorder_SplitSections",                          -- globally unique variable id
        "splitSections",                                         -- key in QuestUIReorderDB
        QuestUIReorderDB,
        Settings.VarType.Boolean,
        L.OPTION_SPLIT_LABEL or "Split quests into sections",
        false                                                    -- Settings.Default.False; see the 12.1 note in QuestUIReorder.lua
    )
    assert(setting and type(setting.SetValueChangedCallback) == "function",
        "unexpected setting object")
    setting:SetValueChangedCallback(function()
        -- Nothing to apply while stood down; the value is still recorded, so
        -- the choice survives to the patch that makes it mean something.
        if type(ns.ApplySplitSetting) == "function" then
            ns.ApplySplitSetting()
        end
    end)

    -- The warning is appended to the tooltip rather than folded into the
    -- label: the label truncates in the panel, and the warning has to
    -- survive translation as its own sentence.
    local tooltip = L.OPTION_SPLIT_TOOLTIP
        or "Show Important, Legendary, Meta, and Repeatable quests in their own sections. When unchecked, all tracked quests stay in one Quests section, still sorted by type."
    local warning
    if ns.standDown then
        -- Reuses the chat string, which says exactly the right thing and is
        -- already translated; it is written lowercase for the "AddonName: "
        -- chat prefix, so lift the first letter for a sentence on its own.
        warning = (L.MSG_DISABLED_121_TAINT
            or "disabled on patch 12.1: a Blizzard bug freezes the whole quest tracker when an addon changes it, so nothing is hooked. The addon will start working again on a patch that fixes it.")
            :gsub("^%l", string.upper)
        warning = warning .. " " .. (L.OPTION_SPLIT_OVERRIDE_121
            or "Ticking this runs the addon anyway, after a /reload. The quest tracker will then stop updating until you reload it again.")
    else
        warning = L.OPTION_SPLIT_WARNING_121
            or "Warning: because of a bug in patch 12.1, the quest tracker does not update while this is on — you have to use /reload to see changes. Blizzard is expected to fix this in 12.1.5. Best left off until then."
    end
    if RED_FONT_COLOR then
        warning = RED_FONT_COLOR:WrapTextInColorCode(warning)
    end

    Settings.CreateCheckbox(category, setting, tooltip .. "|n|n" .. warning)

    Settings.RegisterAddOnCategory(category)
end

-- Deliberately NOT scheduled here. Both flags this depends on
-- (ns.standDown, ns.ApplySplitSetting) are decided in QuestUIReorder.lua at
-- ADDON_LOADED, and two EventUtil.ContinueOnAddOnLoaded callbacks for the same
-- addon are not guaranteed to run in registration order — relying on that left
-- the Settings panel empty, because this ran while both flags were still nil.
-- Instead QuestUIReorder.lua calls this directly once it has decided, which is
-- ordered by construction. Options.lua loads after it (TOC order), so this
-- export is always in place before that call happens.
--
-- Register whenever there is something to show: either a live split to toggle,
-- or a stand-down to explain. An addon that silently disappears from the
-- Settings list reads as uninstalled, which is worse than one that says why it
-- is idle.
function ns.RegisterOptions()
    if type(ns.ApplySplitSetting) ~= "function" and not ns.standDown then
        return
    end
    if not pcall(RegisterOptions) then
        ns.PrintMessage(L.MSG_OPTIONS_FAILED
            or "the options checkbox could not be created (the addon keeps working with its defaults).")
    end
end
