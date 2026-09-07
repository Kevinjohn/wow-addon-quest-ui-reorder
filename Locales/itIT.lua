local _, ns = ...
if GetLocale() ~= "itIT" then return end

-- Italian (itIT). The classification names match Blizzard's own quest-type
-- terms; everything else is the addon's own strings. Anything missing here
-- falls back to English via Locales/enUS.lua.
local L = ns.L

L.OTHER_QUESTS = "Altre missioni"
L.Important = "Importante"
L.Legendary = "Leggendaria"
L.Meta = "Meta"
L.Recurring = "Ripetibile"
L.OPTION_SPLIT_LABEL = "Dividi le missioni in sezioni"
L.OPTION_SPLIT_TOOLTIP = "Mostra le missioni importanti, leggendarie, meta e ripetibili in sezioni dedicate. Se disattivato, tutte le missioni seguite restano in un'unica sezione, comunque ordinata per tipo."
L.OPTION_SPLIT_WARNING_121 = "Attenzione: a causa di un bug della patch 12.1, il tracciatore delle missioni non si aggiorna mentre questa opzione è attiva — devi usare /reload per vedere i cambiamenti. Blizzard dovrebbe risolvere il problema nella 12.1.5. Meglio lasciarla disattivata fino ad allora."
L.MSG_SPLIT_RESET_121 = "le sezioni delle missioni sono state disattivate: un bug della patch 12.1 impediva l'aggiornamento del tracciatore delle missioni mentre erano attive. L'ordinamento funziona ancora. Puoi riattivarle nelle opzioni dell'addon."
L.MSG_ADDON_DISABLED = "il tracciamento delle missioni di Blizzard è cambiato; l'addon è disattivato."
L.MSG_SORT_DISABLED_FMT = "%s — l'ordinamento delle missioni è ora disattivato ed è attivo l'ordine predefinito. Ricarica l'interfaccia (/reload) per riprovare."
L.MSG_SORT_ERROR_BUILDER = "il tracciamento delle missioni di Blizzard ha generato un errore nell'hook di ordinamento"
L.MSG_SORT_CHANGED = "il tracciamento delle missioni di Blizzard è cambiato in modo inatteso"
L.MSG_SORT_REPEATED = "l'ordinamento delle missioni è fallito ripetutamente"
L.MSG_SECTIONS_DISABLED = "il tracciamento delle missioni di Blizzard è cambiato; le sezioni separate delle missioni sono disattivate (l'ordinamento continua a funzionare)."
L.MSG_OPTIONS_UNAVAILABLE = "il pannello delle impostazioni di Blizzard è cambiato; la casella delle opzioni non è disponibile (l'addon continua a funzionare con le impostazioni predefinite)."
L.MSG_OPTIONS_FAILED = "non è stato possibile creare la casella delle opzioni (l'addon continua a funzionare con le impostazioni predefinite)."
