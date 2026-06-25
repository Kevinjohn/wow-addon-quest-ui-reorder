local _, ns = ...
if GetLocale() ~= "ptBR" then return end

-- Brazilian Portuguese (ptBR). The classification names match Blizzard's own
-- quest-type terms; everything else is the addon's own strings. ptPT clients
-- have no overlay and fall back to English via Locales/enUS.lua. Anything
-- missing here also falls back to English.
local L = ns.L

L.OTHER_QUESTS = "Outras missões"
L.Important = "Importante"
L.Legendary = "Lendário"
L.Meta = "Meta"
L.Recurring = "Repetível"
L.OPTION_SPLIT_LABEL = "Dividir as missões em seções"
L.OPTION_SPLIT_TOOLTIP = "Mostra missões importantes, lendárias, meta e repetíveis em seções próprias. Quando desativado, todas as missões acompanhadas ficam em uma única seção, ainda ordenada por tipo."
L.MSG_ADDON_DISABLED = "o rastreador de missões da Blizzard mudou; o addon está desativado."
L.MSG_SORT_DISABLED_FMT = "%s — a ordenação de missões está desligada e a ordem padrão está em vigor. Recarregue a interface (/reload) para tentar novamente."
L.MSG_SORT_ERROR_BUILDER = "o rastreador de missões da Blizzard gerou um erro dentro do gancho de ordenação"
L.MSG_SORT_CHANGED = "o rastreador de missões da Blizzard mudou de forma inesperada"
L.MSG_SORT_REPEATED = "a ordenação de missões falhou repetidamente"
L.MSG_SECTIONS_DISABLED = "o rastreador de missões da Blizzard mudou; as seções separadas de missões estão desativadas (a ordenação continua funcionando)."
L.MSG_OPTIONS_UNAVAILABLE = "o painel de opções da Blizzard mudou; a caixa de opções não está disponível (o addon continua funcionando com os padrões)."
L.MSG_OPTIONS_FAILED = "não foi possível criar a caixa de opções (o addon continua funcionando com os padrões)."
