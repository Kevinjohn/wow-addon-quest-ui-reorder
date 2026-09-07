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
L.OPTION_SPLIT_WARNING_121 = "경고: 12.1 패치의 버그 때문에 이 설정을 켜 두면 퀘스트 추적기가 갱신되지 않습니다. 변경 사항을 보려면 /reload를 사용해야 합니다. 블리자드가 12.1.5에서 수정할 것으로 예상됩니다. 그때까지는 꺼 두는 것이 좋습니다."
L.MSG_SPLIT_RESET_121 = "퀘스트 구획이 꺼졌습니다: 12.1 패치의 버그 때문에 구획을 켜 둔 동안 퀘스트 추적기가 갱신되지 않았습니다. 정렬은 계속 작동합니다. 애드온 옵션에서 다시 켤 수 있습니다."
L.MSG_DISABLED_121_TAINT = "12.1 패치에서 비활성화되었습니다: 애드온이 퀘스트 추적기를 변경하면 블리자드의 버그로 추적기 전체가 멈춥니다. 아무것도 변경하지 않습니다. 이 문제가 수정된 패치에서 다시 작동합니다."
L.OPTION_SPLIT_OVERRIDE_121 = "이 항목을 켜면 /reload 후에 애드온이 그대로 실행됩니다. 그러면 다시 /reload 할 때까지 퀘스트 추적기가 갱신되지 않습니다."
L.MSG_ADDON_DISABLED = "블리자드 퀘스트 추적기가 변경되어 애드온이 비활성화되었습니다."
L.MSG_SORT_DISABLED_FMT = "%s — 퀘스트 정렬이 꺼졌으며 기본 순서가 적용됩니다. 다시 시도하려면 인터페이스를 다시 불러오세요(/reload)."
L.MSG_SORT_ERROR_BUILDER = "정렬 후크 내부에서 블리자드 퀘스트 추적기에 오류가 발생했습니다"
L.MSG_SORT_CHANGED = "블리자드 퀘스트 추적기가 예기치 않게 변경되었습니다"
L.MSG_SORT_REPEATED = "퀘스트 정렬이 반복적으로 실패했습니다"
L.MSG_SECTIONS_DISABLED = "블리자드 퀘스트 추적기가 변경되어 별도 퀘스트 섹션이 비활성화되었습니다(정렬은 계속 작동합니다)."
L.MSG_OPTIONS_UNAVAILABLE = "블리자드 설정 창이 변경되어 옵션 체크박스를 사용할 수 없습니다(애드온은 기본값으로 계속 작동합니다)."
L.MSG_OPTIONS_FAILED = "옵션 체크박스를 만들 수 없습니다(애드온은 기본값으로 계속 작동합니다)."
