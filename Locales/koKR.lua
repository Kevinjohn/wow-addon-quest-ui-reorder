local _, ns = ...
if GetLocale() ~= "koKR" then return end

-- Korean (koKR). The classification names match Blizzard's own quest-type
-- terms; everything else is the addon's own strings. Anything missing here
-- falls back to English via Locales/enUS.lua.
local L = ns.L

L.OTHER_QUESTS = "기타 퀘스트"
L.Important = "중요"
L.Legendary = "전설"
L.Meta = "상위"
L.Recurring = "반복 가능"
L.OPTION_SPLIT_LABEL = "퀘스트를 섹션으로 분리"
L.OPTION_SPLIT_TOOLTIP = "중요, 전설, 상위, 반복 가능 퀘스트를 각각의 섹션에 표시합니다. 해제하면 모든 추적 퀘스트가 유형별로 정렬된 하나의 섹션에 표시됩니다."
L.OPTION_SORT_LABEL = "퀘스트를 유형별로 정렬"
L.OPTION_SORT_TOOLTIP = "추적 중인 퀘스트를 유형별로 정렬합니다: 중요, 전설, 상위, 반복 가능, 스토리, 그리고 나머지 순서입니다."
L.OPTION_121_NOTE = "12.1 패치 참고: 블리자드의 추적기는 어둠땅 시절의 코드가 남아 있어 다시 그릴 때마다 플레이어의 버프를 확인합니다. 12.1에서 버프 정보가 보호되면서, 애드온이 추적기를 건드리면 이 확인이 실패할 수 있고 /reload 하기 전까지 추적기가 갱신되지 않습니다."
L.OPTION_NEEDS_RELOAD = "변경 사항은 /reload 후에 적용됩니다."
L.MSG_OPT_IN_RESET = "두 기능 모두 직접 켜기 전까지 꺼져 있습니다: 12.1 패치에서 각 기능이 어떤 의미인지는 애드온 옵션을 확인하세요."
L.MSG_ADDON_DISABLED = "블리자드 퀘스트 추적기가 변경되어 애드온이 비활성화되었습니다."
L.MSG_SORT_DISABLED_FMT = "%s — 퀘스트 정렬이 꺼졌으며 기본 순서가 적용됩니다. 다시 시도하려면 인터페이스를 다시 불러오세요(/reload)."
L.MSG_SORT_ERROR_BUILDER = "정렬 후크 내부에서 블리자드 퀘스트 추적기에 오류가 발생했습니다"
L.MSG_SORT_CHANGED = "블리자드 퀘스트 추적기가 예기치 않게 변경되었습니다"
L.MSG_SORT_REPEATED = "퀘스트 정렬이 반복적으로 실패했습니다"
L.MSG_SECTIONS_DISABLED = "블리자드 퀘스트 추적기가 변경되어 별도 퀘스트 섹션이 비활성화되었습니다(정렬은 계속 작동합니다)."
L.MSG_OPTIONS_UNAVAILABLE = "블리자드 설정 창이 변경되어 옵션 체크박스를 사용할 수 없습니다(애드온은 기본값으로 계속 작동합니다)."
L.MSG_OPTIONS_FAILED = "옵션 체크박스를 만들 수 없습니다(애드온은 기본값으로 계속 작동합니다)."
