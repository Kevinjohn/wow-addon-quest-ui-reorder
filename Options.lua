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

-- Plain-English version of what CHANGELOG-dev.md records in full: on 12.1 any
-- addon touching the tracker can stop it repainting. Both boxes carry it,
-- because both features touch the same path.
local DEFAULT_121_NOTE = "Note for patch 12.1: Blizzard's tracker still checks your buffs every time it redraws, left over from Shadowlands. In 12.1 they locked buff data down, so once an addon touches the tracker that check can fail and the tracker stops updating until you /reload."
local DEFAULT_NEEDS_RELOAD = "Changing this takes effect after a /reload."

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

local function AddCheckbox(category, variable, key, label, tooltip, needsReload)
    local setting = Settings.RegisterAddOnSetting(
        category, variable, key, QuestUIReorderDB,
        Settings.VarType.Boolean, label, false)
    assert(setting and type(setting.SetValueChangedCallback) == "function",
        "unexpected setting object")

    local text = tooltip .. "|n|n" .. (L.OPTION_121_NOTE or DEFAULT_121_NOTE)
    if needsReload then
        text = text .. " " .. (L.OPTION_NEEDS_RELOAD or DEFAULT_NEEDS_RELOAD)
    end
    Settings.CreateCheckbox(category, setting, text)
    return setting
end

local function RegisterOptions()
    -- First ever run: the saved-variables table itself does not exist yet.
    QuestUIReorderDB = QuestUIReorderDB or {}

    -- Must run before the settings are registered: RegisterAddOnSetting reads
    -- the stored value to seed each checkbox, so resetting afterwards would
    -- leave a box shown ticked while the feature was actually off.
    if type(ns.ResetForOptIn) == "function" then
        ns.ResetForOptIn()
    end

    local category = Settings.RegisterVerticalLayoutCategory("Quest UI Reorder")

    -- Sorting is read once at load (it replaces a Blizzard method), so it
    -- needs a /reload. The split activates and deactivates live.
    AddCheckbox(category,
        "QuestUIReorder_EnableSorting", "enableSorting",
        L.OPTION_SORT_LABEL or "Order quests by type",
        L.OPTION_SORT_TOOLTIP
            or "Order tracked quests by type: Important, Legendary, Meta, Repeatable, Storyline, then everything else.",
        true)

    local split = AddCheckbox(category,
        "QuestUIReorder_SplitSections", "splitSections",
        L.OPTION_SPLIT_LABEL or "Split quests into sections",
        L.OPTION_SPLIT_TOOLTIP
            or "Show Important, Legendary, Meta, and Repeatable quests in their own sections. When unchecked, all tracked quests stay in one Quests section.",
        false)
    split:SetValueChangedCallback(function()
        if type(ns.ApplySplitSetting) == "function" then
            ns.ApplySplitSetting()
        end
    end)

    Settings.RegisterAddOnCategory(category)
end

-- Deliberately NOT scheduled here. QuestUIReorder.lua calls this once it has
-- read the saved variables and installed what the player opted into: two
-- EventUtil.ContinueOnAddOnLoaded callbacks for the same addon are not
-- guaranteed to run in registration order, and relying on that once left this
-- panel empty. Options.lua loads after QuestUIReorder.lua (TOC order), so this
-- export is always in place before that call.
--
-- The panel registers unconditionally: both features are opt-in, so the
-- Settings entry is the only place a player can find out the addon exists and
-- what the patch 12.1 trade-off is.
function ns.RegisterOptions()
    if not pcall(RegisterOptions) then
        ns.PrintMessage(L.MSG_OPTIONS_FAILED
            or "the options checkbox could not be created (the addon keeps working with its defaults).")
    end
end
