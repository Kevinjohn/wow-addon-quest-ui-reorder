-- Locale regression harness: loads the addon's real Locales/ files once per
-- possible GetLocale() value and asserts the localization contract holds:
--   * every key in the enUS base resolves to a non-empty string,
--   * no locale introduces a key the base doesn't have (a typo'd key would
--     leave the real key on its English fallback while a stray key appears),
--   * each translated locale actually applies its overlay (so a broken
--     GetLocale() guard — e.g. esMX silently falling back to English — fails
--     loudly here, not in a player's bug report),
--   * MSG_SORT_DISABLED_FMT keeps its %s placeholder, and
--   * the /reload instruction stays literal in every language.
--
-- It runs the files exactly as the WoW client does: enUS.lua first (it
-- publishes ns.L), then every Locales/<locale>.lua overlay in TOC order,
-- each a chunk taking the (addonName, namespace) varargs and self-guarding on
-- GetLocale(). No game client is needed — any Lua >= 5.1 works (WoW runs 5.1).
--
-- Run from the repo root:  lua tests/run.lua

-- Root layout: the addon's Lua sits at the repo root (no addon subfolder),
-- with the locale files under Locales/.
local LOCALES_DIR = "Locales/"
local BASE_FILE = LOCALES_DIR .. "enUS.lua"

-- The overlay files, in the exact order the TOC loads them. Each guards on
-- GetLocale() and returns early when it doesn't match, so loading all of them
-- for every locale mirrors the client precisely.
local OVERLAYS = {
	"deDE.lua", "frFR.lua", "esES.lua", "itIT.lua", "ptBR.lua",
	"ruRU.lua", "koKR.lua", "zhCN.lua", "zhTW.lua",
}

-- Every GetLocale() value we care about: the translated locales (esMX is
-- served by esES.lua, which guards both), enUS/enGB/ptPT (no overlay -> the
-- base), an unknown locale, and GetLocale entirely absent.
local TRANSLATED = {
	"deDE", "esES", "esMX", "frFR", "itIT",
	"koKR", "ptBR", "ruRU", "zhCN", "zhTW",
}
local BASE_LIKE = { "enUS", "enGB", "ptPT" } -- no overlay: fall back to base

-- A canary string per translated locale (its OTHER_QUESTS). If a locale's
-- overlay never runs, OTHER_QUESTS stays on the English base and this fails —
-- the only check that catches a broken GetLocale() guard. esMX shares esES.
local CANARY_OTHER_QUESTS = {
	deDE = "Andere Quests",
	esES = "Otras misiones",
	esMX = "Otras misiones",
	frFR = "Autres quêtes",
	itIT = "Altre missioni",
	koKR = "기타 퀘스트",
	ptBR = "Outras missões",
	ruRU = "Другие задания",
	zhCN = "其它任务",
	zhTW = "其他任務",
}

local failures, checks = {}, 0
local function check(ok, label)
	checks = checks + 1
	if not ok then
		failures[#failures + 1] = label
		io.write("FAIL  ", label, "\n")
	end
end

-- Load the Locales/ files fresh for a given locale value (nil = GetLocale
-- absent). Returns the namespace's L table. Each load gets its own namespace,
-- so locales can't leak into one another.
local function loadLocale(locale)
	if locale == nil then
		_G.GetLocale = nil
	else
		_G.GetLocale = function() return locale end
	end
	local ns = {}
	-- enUS.lua always runs first and publishes ns.L (it ignores GetLocale).
	assert(loadfile(BASE_FILE))("QuestUIReorder", ns)
	assert(type(ns.L) == "table", "enUS.lua did not populate ns.L")
	-- Then every overlay, in TOC order; each self-guards on GetLocale().
	for _, file in ipairs(OVERLAYS) do
		assert(loadfile(LOCALES_DIR .. file))("QuestUIReorder", ns)
	end
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
-- (The enUS __index metamethod returns visible text for missing keys but is
-- invisible to pairs(), so the key-set checks below see only real keys.)
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

	-- Translated locales must actually be translated (overlay applied). This
	-- is what guards esMX: esES.lua serves both, so esMX gets the Spanish
	-- OTHER_QUESTS rather than silently falling back to English.
	local canary = locale ~= false and CANARY_OTHER_QUESTS[locale]
	if canary then
		check(L.OTHER_QUESTS == canary,
			name .. ": OTHER_QUESTS should be '" .. canary
				.. "' (overlay not applied?), got '" .. tostring(L.OTHER_QUESTS) .. "'")
	end
end

------------------------------------------------------------------------------
io.write(string.format("\n%d checks, %d failures\n", checks, #failures))
os.exit(#failures == 0 and 0 or 1)
