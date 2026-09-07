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
L.OPTION_SORT_LABEL = "Ordina le missioni per tipo"
L.OPTION_SORT_TOOLTIP = "Ordina le missioni seguite per tipo: Importante, Leggendaria, Meta, Ripetibile, Linea narrativa e poi tutto il resto."
L.OPTION_121_NOTE = "Nota per la patch 12.1: il tracciatore di Blizzard controlla ancora i tuoi benefici a ogni ridisegno, un residuo di Shadowlands. Nella 12.1 quei dati sono stati bloccati, quindi appena un addon tocca il tracciatore quel controllo può fallire e il tracciatore smette di aggiornarsi finché non usi /reload."
L.OPTION_NEEDS_RELOAD = "La modifica ha effetto dopo un /reload."
L.MSG_OPT_IN_RESET = "entrambe le funzioni sono ora disattivate finché non le attivi: nelle opzioni dell'addon trovi cosa comporta ciascuna nella patch 12.1."
L.MSG_ADDON_DISABLED = "il tracciamento delle missioni di Blizzard è cambiato; l'addon è disattivato."
L.MSG_SORT_DISABLED_FMT = "%s — l'ordinamento delle missioni è ora disattivato ed è attivo l'ordine predefinito. Ricarica l'interfaccia (/reload) per riprovare."
L.MSG_SORT_ERROR_BUILDER = "il tracciamento delle missioni di Blizzard ha generato un errore nell'hook di ordinamento"
L.MSG_SORT_CHANGED = "il tracciamento delle missioni di Blizzard è cambiato in modo inatteso"
L.MSG_SORT_REPEATED = "l'ordinamento delle missioni è fallito ripetutamente"
L.MSG_SECTIONS_DISABLED = "il tracciamento delle missioni di Blizzard è cambiato; le sezioni separate delle missioni sono disattivate (l'ordinamento continua a funzionare)."
L.MSG_OPTIONS_UNAVAILABLE = "il pannello delle impostazioni di Blizzard è cambiato; la casella delle opzioni non è disponibile (l'addon continua a funzionare con le impostazioni predefinite)."
L.MSG_OPTIONS_FAILED = "non è stato possibile creare la casella delle opzioni (l'addon continua a funzionare con le impostazioni predefinite)."
