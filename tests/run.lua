-- Locale regression harness: loads the addon's real Locales.lua once per
-- possible GetLocale() value and asserts the localization contract holds:
--   * every key in the enUS base resolves to a non-empty string,
--   * no locale introduces a key the base doesn't have (a typo'd key would
--     leave the real key on its English fallback while a stray key appears),
--   * MSG_SORT_DISABLED_FMT keeps its %s placeholder, and
--   * the /reload instruction stays literal in every language.
--
-- It runs the file exactly as the WoW client does: as a chunk taking the
-- (addonName, namespace) varargs, with GetLocale provided as a global. No
-- game client is needed — any Lua >= 5.1 works (WoW runs 5.1).
--
-- Run from the repo root:  lua tests/run.lua

-- Root layout: the addon's Lua sits at the repo root (no addon subfolder).
local LOCALES_FILE = "Locales.lua"

-- Every GetLocale() value we care about: the 10 translated locales, esMX
-- (aliased to esES in the file), enUS/enGB (no overlay -> the base), an
-- unknown locale, and GetLocale entirely absent.
local TRANSLATED = {
	"deDE", "esES", "esMX", "frFR", "itIT",
	"koKR", "ptBR", "ruRU", "zhCN", "zhTW",
}
local BASE_LIKE = { "enUS", "enGB", "ptPT" } -- no overlay: fall back to base

local failures, checks = {}, 0
local function check(ok, label)
	checks = checks + 1
	if not ok then
		failures[#failures + 1] = label
		io.write("FAIL  ", label, "\n")
	end
end

-- Load Locales.lua fresh for a given locale value (nil = GetLocale absent).
-- Returns the namespace's L table. Each load gets its own chunk and its own
-- namespace, so locales can't leak into one another.
local function loadLocale(locale)
	if locale == nil then
		_G.GetLocale = nil
	else
		_G.GetLocale = function() return locale end
	end
	local chunk = assert(loadfile(LOCALES_FILE))
	local ns = {}
	chunk("QuestUIReorder", ns)
	assert(type(ns.L) == "table", "Locales.lua did not populate ns.L")
	return ns.L
end

local function keySet(tbl)
	local s = {}
	for k in pairs(tbl) do s[k] = true end
	return s
end

------------------------------------------------------------------------------
-- The base (enUS) key set is the canonical contract. Derived from a real
-- load with an unknown locale, so it can never drift from the source file.
local base = loadLocale("xxXX")
local canonical = keySet(base)

do -- sanity: the base must actually contain the keys the addon relies on.
	local required = {
		"OTHER_QUESTS", "Important", "Legendary", "Meta", "Recurring",
		"OPTION_SPLIT_LABEL", "OPTION_SPLIT_TOOLTIP",
		"MSG_ADDON_DISABLED", "MSG_SORT_DISABLED_FMT",
		"MSG_SORT_ERROR_BUILDER", "MSG_SORT_CHANGED", "MSG_SORT_REPEATED",
		"MSG_SECTIONS_DISABLED", "MSG_OPTIONS_UNAVAILABLE", "MSG_OPTIONS_FAILED",
	}
	for _, key in ipairs(required) do
		check(canonical[key] == true, "base is missing required key " .. key)
	end
end

------------------------------------------------------------------------------
-- Build the full list of locales to exercise, including GetLocale absent.
local locales = {}
for _, l in ipairs(BASE_LIKE) do locales[#locales + 1] = l end
for _, l in ipairs(TRANSLATED) do locales[#locales + 1] = l end
locales[#locales + 1] = "xxXX"          -- unknown locale -> base
locales[#locales + 1] = false           -- sentinel for "GetLocale absent"

for _, locale in ipairs(locales) do
	local name = locale == false and "<GetLocale absent>" or locale
	local L = loadLocale(locale == false and nil or locale)
	local got = keySet(L)

	-- No stray keys (a translation typo would surface here).
	for key in pairs(got) do
		check(canonical[key] == true,
			name .. ": unexpected key '" .. tostring(key) .. "'")
	end

	-- Every canonical key present and a non-empty string.
	for key in pairs(canonical) do
		local v = L[key]
		check(type(v) == "string" and v ~= "",
			name .. ": key '" .. key .. "' missing or not a non-empty string")
	end

	-- The format string must keep exactly one %s, and /reload stays literal.
	local fmt = L.MSG_SORT_DISABLED_FMT
	if type(fmt) == "string" then
		local _, n = fmt:gsub("%%s", "")
		check(n == 1, name .. ": MSG_SORT_DISABLED_FMT must contain exactly one %s")
		check(fmt:find("/reload", 1, true) ~= nil,
			name .. ": MSG_SORT_DISABLED_FMT must keep '/reload' literal")
	end
end

------------------------------------------------------------------------------
io.write(string.format("\n%d checks, %d failures\n", checks, #failures))
os.exit(#failures == 0 and 0 or 1)
