local _, ns = ...
if GetLocale() ~= "deDE" then return end

-- German (deDE). The classification names match Blizzard's own quest-type
-- terms; everything else is the addon's own strings. Anything missing here
-- falls back to English via Locales/enUS.lua.
local L = ns.L

L.OTHER_QUESTS = "Andere Quests"
L.Important = "Wichtig"
L.Legendary = "Legendär"
L.Meta = "Meta"
L.Recurring = "Wiederholbar"
L.OPTION_SPLIT_LABEL = "Quests in Abschnitte aufteilen"
L.OPTION_SPLIT_TOOLTIP = "Zeigt wichtige, legendäre, Meta- und wiederholbare Quests in eigenen Abschnitten an. Wenn deaktiviert, bleiben alle verfolgten Quests in einem einzelnen, weiterhin nach Typ sortierten Abschnitt."
L.OPTION_SORT_LABEL = "Quests nach Typ ordnen"
L.OPTION_SORT_TOOLTIP = "Ordnet verfolgte Quests nach Typ: Wichtig, Legendär, Meta, Wiederholbar, Handlungsstrang und danach alles Übrige."
L.OPTION_121_NOTE = "Hinweis zu Patch 12.1: Blizzards Questverfolgung prüft bei jedem Neuzeichnen noch immer deine Buffs — ein Überbleibsel aus Shadowlands. In 12.1 wurden Buff-Daten gesperrt, sodass diese Prüfung fehlschlagen kann, sobald ein Addon die Questverfolgung verändert; sie aktualisiert sich dann nicht mehr, bis du /reload benutzt."
L.OPTION_NEEDS_RELOAD = "Änderungen werden nach einem /reload wirksam."
L.MSG_OPT_IN_RESET = "beide Funktionen sind jetzt aus, bis du sie einschaltest: in den Optionen des Addons steht, was jede auf Patch 12.1 bedeutet."
L.MSG_ADDON_DISABLED = "der Blizzard-Quest-Tracker hat sich geändert; das Addon ist deaktiviert."
L.MSG_SORT_DISABLED_FMT = "%s — die Questsortierung ist jetzt aus und die Standardreihenfolge gilt. Lade die UI neu (/reload), um es erneut zu versuchen."
L.MSG_SORT_ERROR_BUILDER = "im Sortierungs-Hook ist ein Fehler des Blizzard-Quest-Trackers aufgetreten"
L.MSG_SORT_CHANGED = "der Blizzard-Quest-Tracker hat sich unerwartet geändert"
L.MSG_SORT_REPEATED = "die Questsortierung ist wiederholt fehlgeschlagen"
L.MSG_SECTIONS_DISABLED = "der Blizzard-Quest-Tracker hat sich geändert; separate Questabschnitte sind deaktiviert (die Sortierung funktioniert weiterhin)."
L.MSG_OPTIONS_UNAVAILABLE = "das Einstellungsfenster von Blizzard hat sich geändert; das Optionskästchen ist nicht verfügbar (das Addon funktioniert weiter mit den Standardwerten)."
L.MSG_OPTIONS_FAILED = "das Optionskästchen konnte nicht erstellt werden (das Addon funktioniert weiter mit den Standardwerten)."
