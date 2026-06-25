local _, ns = ...
if GetLocale() ~= "frFR" then return end

-- French (frFR). The classification names match Blizzard's own quest-type
-- terms; everything else is the addon's own strings. Anything missing here
-- falls back to English via Locales/enUS.lua.
local L = ns.L

L.OTHER_QUESTS = "Autres quêtes"
L.Important = "Important"
L.Legendary = "Légendaire"
L.Meta = "Méta"
L.Recurring = "Répétable"
L.OPTION_SPLIT_LABEL = "Diviser les quêtes en sections"
L.OPTION_SPLIT_TOOLTIP = "Affiche les quêtes importantes, légendaires, méta et répétables dans des sections dédiées. Si désactivé, toutes les quêtes suivies restent dans une seule section, toujours triée par type."
L.MSG_ADDON_DISABLED = "le suivi des quêtes de Blizzard a changé ; l'addon est désactivé."
L.MSG_SORT_DISABLED_FMT = "%s — le tri des quêtes est désormais désactivé et l'ordre par défaut s'applique. Rechargez l'interface (/reload) pour réessayer."
L.MSG_SORT_ERROR_BUILDER = "le suivi des quêtes de Blizzard a rencontré une erreur dans le crochet de tri"
L.MSG_SORT_CHANGED = "le suivi des quêtes de Blizzard a changé de manière inattendue"
L.MSG_SORT_REPEATED = "le tri des quêtes a échoué à plusieurs reprises"
L.MSG_SECTIONS_DISABLED = "le suivi des quêtes de Blizzard a changé ; les sections de quêtes séparées sont désactivées (le tri fonctionne toujours)."
L.MSG_OPTIONS_UNAVAILABLE = "le panneau d'options de Blizzard a changé ; la case d'option n'est pas disponible (l'addon continue de fonctionner avec ses valeurs par défaut)."
L.MSG_OPTIONS_FAILED = "la case d'option n'a pas pu être créée (l'addon continue de fonctionner avec ses valeurs par défaut)."
