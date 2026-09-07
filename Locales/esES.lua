local _, ns = ...
local locale = GetLocale()
if locale ~= "esES" and locale ~= "esMX" then return end

-- Spanish, shared by European esES and Latin American esMX: Blizzard's esMX
-- strings are identical to esES for every key used here, so one file serves
-- both (mirrors the old `translations.esMX = translations.esES`). The
-- classification names match Blizzard's own quest-type terms. Anything
-- missing here falls back to English via Locales/enUS.lua.
local L = ns.L

L.OTHER_QUESTS = "Otras misiones"
L.Important = "Importante"
L.Legendary = "Legendaria"
L.Meta = "Meta"
L.Recurring = "Repetible"
L.OPTION_SPLIT_LABEL = "Dividir las misiones en secciones"
L.OPTION_SPLIT_TOOLTIP = "Muestra las misiones importantes, legendarias, meta y repetibles en secciones propias. Si se desactiva, todas las misiones seguidas permanecen en una sola sección, ordenada igualmente por tipo."
L.OPTION_SPLIT_WARNING_121 = "Aviso: por un error del parche 12.1, el rastreador de misiones no se actualiza mientras esto está activado; tienes que usar /reload para ver los cambios. Se espera que Blizzard lo corrija en el 12.1.5. Es mejor dejarlo desactivado hasta entonces."
L.MSG_SPLIT_RESET_121 = "las secciones de misiones se han desactivado: un error del parche 12.1 impedía que el rastreador de misiones se actualizara mientras estaban activas. La ordenación sigue funcionando. Puedes volver a activarlas en las opciones del accesorio."
L.MSG_DISABLED_121_TAINT = "desactivado en el parche 12.1: un error de Blizzard congela todo el rastreador de misiones cuando un accesorio lo modifica. No se modifica nada. El accesorio volverá a funcionar en un parche que lo corrija."
L.OPTION_SPLIT_OVERRIDE_121 = "Si marcas esto, el accesorio se ejecutará de todos modos tras un /reload. El rastreador de misiones dejará de actualizarse hasta que vuelvas a recargar."
L.MSG_ADDON_DISABLED = "el rastreador de misiones de Blizzard ha cambiado; el accesorio está desactivado."
L.MSG_SORT_DISABLED_FMT = "%s — la ordenación de misiones está ahora desactivada y se aplica el orden predeterminado. Recarga la interfaz (/reload) para reintentarlo."
L.MSG_SORT_ERROR_BUILDER = "el rastreador de misiones de Blizzard produjo un error dentro del gancho de ordenación"
L.MSG_SORT_CHANGED = "el rastreador de misiones de Blizzard ha cambiado de forma inesperada"
L.MSG_SORT_REPEATED = "la ordenación de misiones ha fallado repetidamente"
L.MSG_SECTIONS_DISABLED = "el rastreador de misiones de Blizzard ha cambiado; las secciones de misiones separadas están desactivadas (la ordenación sigue funcionando)."
L.MSG_OPTIONS_UNAVAILABLE = "el panel de opciones de Blizzard ha cambiado; la casilla de opciones no está disponible (el accesorio sigue funcionando con sus valores predeterminados)."
L.MSG_OPTIONS_FAILED = "no se pudo crear la casilla de opciones (el accesorio sigue funcionando con sus valores predeterminados)."
