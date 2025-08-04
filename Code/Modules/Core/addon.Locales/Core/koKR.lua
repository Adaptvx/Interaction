-- Localization and translation Crazyyoungs

---@class addon
local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local PrefabRegistry = addon.PrefabRegistry
local L = addon.Locales

--------------------------------

local function Load()
	if GetLocale() ~= "koKR" then
		return
	end
	--------------------------------
	-- 설정
	--------------------------------

	do
		-- 경고
		L["Warning - Leave NPC Interaction"] = "NPC 상호작용을 종료해야 설정을 변경할 수 있습니다."
		L["Warning - Leave ReadableUI"] = "읽기 전용 UI를 종료해야 설정을 변경할 수 있습니다."


		-- PROMPTS
		L["Prompt - Reload"] = "설정을 적용하려면 인터페이스를 다시 불러와야 합니다."
		L["Prompt - Reload Button 1"] = "다시 불러오기"
		L["Prompt - Reload Button 2"] = "닫기"
		L["Prompt - Reset Settings"] = "설정을 초기화하시겠습니까?"
		L["Prompt - Reset Settings Button 1"] = "초기화"
		L["Prompt - Reset Settings Button 2"] = "취소"


		-- 탭
		L["Tab - Appearance"] = "외형"
		L["Tab - Effects"] = "효과"
		L["Tab - Playback"] = "재생"
		L["Tab - Controls"] = "조작"
		L["Tab - Gameplay"] = "게임 플레이"
		L["Tab - More"] = "기타"


		-- 구성 요소
		-- 외형
		L["Title - Theme"] = "테마"
		L["Range - Main Theme"] = "기본 테마"
		L["Range - Main Theme - Tooltip"] = "전체 UI 테마를 설정합니다.\n\n기본값: 낮.\n\n" .. addon.Theme.Settings.Tooltip_Text_Note_Highlight .. "동적" .. addon.Theme.Settings.Tooltip_Text_Note .. " 옵션은 게임 내 낮/밤 주기에 따라 테마가 자동으로 설정됩니다.|r"
		L["Range - Main Theme - Day"] = "낮"
		L["Range - Main Theme - Night"] = "밤"
		L["Range - Main Theme - Dynamic"] = "동적"
		L["Range - Dialog Theme"] = "대화 테마"
		L["Range - Dialog Theme - Tooltip"] = "NPC 대화 UI의 테마를 설정합니다.\n\n기본값: 일치.\n\n" .. addon.Theme.Settings.Tooltip_Text_Note_Highlight .. "일치" .. addon.Theme.Settings.Tooltip_Text_Note .. " 옵션은 기본 테마와 동일하게 설정됩니다.|r"
		L["Range - Dialog Theme - Auto"] = "일치"
		L["Range - Dialog Theme - Day"] = "낮"
		L["Range - Dialog Theme - Night"] = "밤"
		L["Range - Dialog Theme - Rustic"] = "고풍"
		L["Title - Appearance"] = "외형"
		L["Range - UIDirection"] = "UI 방향"
		L["Range - UIDirection - Tooltip"] = "UI 방향을 설정합니다."
		L["Range - UIDirection - Left"] = "왼쪽"
		L["Range - UIDirection - Right"] = "오른쪽"
		L["Range - UIDirection / Dialog"] = "고정된 대화 위치"
		L["Range - UIDirection / Dialog - Tooltip"] = "고정된 대화 위치를 설정합니다.\n\nNPC의 이름표가 없을 때 사용됩니다."
		L["Range - UIDirection / Dialog - Top"] = "상단"
		L["Range - UIDirection / Dialog - Center"] = "중앙"
		L["Range - UIDirection / Dialog - Bottom"] = "하단"
		L["Checkbox - UIDirection / Dialog / Mirror"] = "반전"
		L["Checkbox - UIDirection / Dialog / Mirror - Tooltip"] = "UI 방향을 반전시킵니다."
		L["Range - Quest Frame Size"] = "퀘스트 프레임 크기"
		L["Range - Quest Frame Size - Tooltip"] = "퀘스트 프레임 크기를 조정합니다.\n\n기본값: 중간."
		L["Range - Quest Frame Size - Small"] = "작음"
		L["Range - Quest Frame Size - Medium"] = "중간"
		L["Range - Quest Frame Size - Large"] = "큼"
		L["Range - Quest Frame Size - Extra Large"] = "매우 큼"
		L["Range - Text Size"] = "텍스트 크기"
		L["Range - Text Size - Tooltip"] = "텍스트 크기를 조정합니다."
		L["Title - Dialog"] = "대화"
		L["Checkbox - Dialog / Title / Progress Bar"] = "진행 바 표시"
		L["Checkbox - Dialog / Title / Progress Bar - Tooltip"] = "대화 진행 바를 표시하거나 숨깁니다.\n\n현재 대화가 얼마나 진행되었는지를 나타냅니다.\n\n기본값: 켬."
		L["Range - Dialog / Title / Text Alpha"] = "제목 투명도"
		L["Range - Dialog / Title / Text Alpha - Tooltip"] = "대화 제목의 투명도를 설정합니다.\n\n기본값: 50%."
		L["Range - Dialog / Content Preview Alpha"] = "미리보기 투명도"
		L["Range - Dialog / Content Preview Alpha - Tooltip"] = "대화 텍스트 미리보기의 투명도를 설정합니다.\n\n기본값: 50%."
		L["Title - Gossip"] = "잡담"
		L["Checkbox - Always Show Gossip Frame"] = "항상 잡담 프레임 표시"
		L["Checkbox - Always Show Gossip Frame - Tooltip"] = "대화 이후에만 표시되는 것이 아니라 사용 가능할 때 항상 잡담 프레임을 표시합니다.\n\n기본값: 켬."
		L["Title - Quest"] = "퀘스트"
		L["Checkbox - Always Show Quest Frame"] = "항상 퀘스트 프레임 표시"
		L["Checkbox - Always Show Quest Frame - Tooltip"] = "대화 이후에만 표시되는 것이 아니라 사용 가능할 때 항상 퀘스트 프레임을 표시합니다.\n\n기본값: 켬."


		-- 뷰포트
		L["Title - Effects"] = "효과"
		L["Checkbox - Hide UI"] = "UI 숨기기"
		L["Checkbox - Hide UI - Tooltip"] = "NPC 상호작용 중 UI를 숨깁니다.\n\n기본값: 켬."
		L["Range - Cinematic"] = "카메라 연출"
		L["Range - Cinematic - Tooltip"] = "상호작용 중 카메라 연출을 설정합니다.\n\n기본값: 전체."
		L["Range - Cinematic - None"] = "없음"
		L["Range - Cinematic - Full"] = "전체"
		L["Range - Cinematic - Balanced"] = "균형"
		L["Range - Cinematic - Custom"] = "사용자 설정"
		L["Checkbox - Zoom"] = "줌"
		L["Range - Zoom / Min Distance"] = "최소 거리"
		L["Range - Zoom / Min Distance - Tooltip"] = "현재 줌이 이 값보다 작으면 해당 수준까지 확대됩니다."
		L["Range - Zoom / Max Distance"] = "최대 거리"
		L["Range - Zoom / Max Distance - Tooltip"] = "현재 줌이 이 값보다 크면 해당 수준까지 축소됩니다."
		L["Checkbox - Zoom / Pitch"] = "수직 각도 조절"
		L["Checkbox - Zoom / Pitch - Tooltip"] = "카메라 수직 각도 조절을 활성화합니다."
		L["Range - Zoom / Pitch / Level"] = "최대 각도"
		L["Range - Zoom / Pitch / Level - Tooltip"] = "수직 각도 기준값입니다."
		L["Checkbox - Zoom / Field Of View"] = "시야각(FOV) 조절"
		L["Checkbox - Pan"] = "팬 이동"
		L["Range - Pan / Speed"] = "속도"
		L["Range - Pan / Speed - Tooltip"] = "최대 팬 이동 속도입니다."
		L["Checkbox - Dynamic Camera"] = "다이나믹 카메라"
		L["Checkbox - Dynamic Camera - Tooltip"] = "다이나믹 카메라 설정을 활성화합니다."
		L["Checkbox - Dynamic Camera / Side View"] = "측면 시점"
		L["Checkbox - Dynamic Camera / Side View - Tooltip"] = "카메라를 측면 시점으로 조절합니다."
		L["Range - Dynamic Camera / Side View / Strength"] = "강도"
		L["Range - Dynamic Camera / Side View / Strength - Tooltip"] = "값이 높을수록 측면 움직임이 커집니다."
		L["Checkbox - Dynamic Camera / Offset"] = "오프셋"
		L["Checkbox - Dynamic Camera / Offset - Tooltip"] = "캐릭터 기준으로 뷰포트를 오프셋 조정합니다."
		L["Range - Dynamic Camera / Offset / Strength"] = "강도"
		L["Range - Dynamic Camera / Offset / Strength - Tooltip"] = "값이 높을수록 오프셋 크기가 커집니다."
		L["Checkbox - Dynamic Camera / Focus"] = "포커스"
		L["Checkbox - Dynamic Camera / Focus - Tooltip"] = "대상에 포커스를 맞춥니다."
		L["Range - Dynamic Camera / Focus / Strength"] = "강도"
		L["Range - Dynamic Camera / Focus / Strength - Tooltip"] = "값이 높을수록 포커스 강도가 증가합니다."
		L["Checkbox - Dynamic Camera / Focus / X"] = "X축 무시"
		L["Checkbox - Dynamic Camera / Focus / X - Tooltip"] = "X축 포커스를 방지합니다."
		L["Checkbox - Dynamic Camera / Focus / Y"] = "Y축 무시"
		L["Checkbox - Dynamic Camera / Focus / Y - Tooltip"] = "Y축 포커스를 방지합니다."
		L["Checkbox - Vignette"] = "비네트"
		L["Checkbox - Vignette - Tooltip"] = "화면 가장자리의 밝기를 낮춥니다."
		L["Checkbox - Vignette / Gradient"] = "그라데이션"
		L["Checkbox - Vignette / Gradient - Tooltip"] = "잡담 및 퀘스트 인터페이스 뒤쪽 밝기를 줄입니다."


		-- 재생
		L["Title - Pace"] = "속도"
		L["Range - Playback Speed"] = "텍스트 재생 속도"
		L["Range - Playback Speed - Tooltip"] = "텍스트가 표시되는 속도를 설정합니다.\n\n기본값: 100%."
		L["Checkbox - Dynamic Playback"] = "자연스러운 재생"
		L["Checkbox - Dynamic Playback - Tooltip"] = "대화에 구두점 기준의 일시 정지를 추가합니다.\n\n기본값: 켬."
		L["Title - Auto Progress"] = "자동 진행"
		L["Checkbox - Auto Progress"] = "자동 진행 활성화"
		L["Checkbox - Auto Progress - Tooltip"] = "다음 대화로 자동으로 진행합니다.\n\n기본값: 켬."
		L["Checkbox - Auto Close Dialog"] = "자동 종료"
		L["Checkbox - Auto Close Dialog - Tooltip"] = "선택지가 없을 경우 NPC 상호작용을 종료합니다.\n\n기본값: 켬."
		L["Range - Auto Progress / Delay"] = "지연 시간"
		L["Range - Auto Progress / Delay - Tooltip"] = "다음 대화로 진행되기 전의 지연 시간입니다.\n\n기본값: 1."
		L["Title - Text To Speech"] = "텍스트 음성 변환"
		L["Checkbox - Text To Speech"] = "활성화"
		L["Checkbox - Text To Speech - Tooltip"] = "대화 텍스트를 음성으로 읽어줍니다.\n\n기본값: 끔."
		L["Title - Text To Speech / Playback"] = "재생"
		L["Checkbox - Text To Speech / Quest"] = "퀘스트 음성 재생"
		L["Checkbox - Text To Speech / Quest - Tooltip"] = "퀘스트 대화에서 텍스트 음성 변환을 활성화합니다.\n\n기본값: 켬."
		L["Checkbox - Text To Speech / Gossip"] = "잡담 음성 재생"
		L["Checkbox - Text To Speech / Gossip - Tooltip"] = "잡담 대화에서 텍스트 음성 변환을 활성화합니다.\n\n기본값: 켬."
		L["Range - Text To Speech / Rate"] = "속도"
		L["Range - Text To Speech / Rate - Tooltip"] = "음성 재생 속도를 설정합니다.\n\n기본값: 100%."
		L["Range - Text To Speech / Volume"] = "볼륨"
		L["Range - Text To Speech / Volume - Tooltip"] = "음성 재생 볼륨을 설정합니다.\n\n기본값: 100%."
		L["Title - Text To Speech / Voice"] = "음성 설정"
		L["Dropdown - Text To Speech / Voice / Neutral"] = "중성"
		L["Dropdown - Text To Speech / Voice / Neutral - Tooltip"] = "성별이 명확하지 않은 NPC에 사용됩니다."
		L["Dropdown - Text To Speech / Voice / Male"] = "남성"
		L["Dropdown - Text To Speech / Voice / Male - Tooltip"] = "남성 NPC에 사용됩니다."
		L["Dropdown - Text To Speech / Voice / Female"] = "여성"
		L["Dropdown - Text To Speech / Voice / Female - Tooltip"] = "여성 NPC에 사용됩니다."
		L["Dropdown - Text To Speech / Voice / Emote"] = "감정 표현"
		L["Dropdown - Text To Speech / Voice / Emote - Tooltip"] = "`<>` 괄호로 표시된 감정 표현 대사에 사용됩니다."
		L["Checkbox - Text To Speech / Player / Voice"] = "플레이어 음성"
		L["Checkbox - Text To Speech / Player / Voice - Tooltip"] = "플레이어가 대화 선택지를 고를 때 음성을 재생합니다.\n\n기본값: 켬."
		L["Dropdown - Text To Speech / Player / Voice / Voice"] = "음성 선택"
		L["Dropdown - Text To Speech / Player / Voice / Voice - Tooltip"] = "대화 선택지에 사용할 플레이어 음성을 설정합니다."
		L["Title - More"] = "기타"
		L["Checkbox - Mute Dialog"] = "NPC 음성 음소거"
		L["Checkbox - Mute Dialog - Tooltip"] = "NPC 상호작용 중 Blizzard의 NPC 음성을 음소거합니다.\n\n기본값: 끔."


		-- 컨트롤
		L["Title - UI"] = "UI"
		L["Checkbox - UI / Control Guide"] = "컨트롤 가이드 표시"
		L["Checkbox - UI / Control Guide - Tooltip"] = "컨트롤 가이드 프레임을 표시합니다.\n\n기본값: 켬."
		L["Title - Platform"] = "플랫폼"
		L["Range - Platform"] = "플랫폼"
		L["Range - Platform - Tooltip"] = "적용하려면 인터페이스를 다시 불러와야 합니다."
		L["Range - Platform - PC"] = "PC"
		L["Range - Platform - Playstation"] = "PlayStation"
		L["Range - Platform - Xbox"] = "Xbox"
		L["Title - PC"] = "PC"
		L["Title - PC / Keyboard"] = "키보드"
		L["Checkbox - PC / Keyboard / Use Interact Key"] = "상호작용 키 사용"
		L["Checkbox - PC / Keyboard / Use Interact Key - Tooltip"] = "진행 시 상호작용 키를 사용합니다. 복수 키 조합은 지원되지 않습니다.\n\n기본값: 끔."
		L["Title - PC / Mouse"] = "마우스"
		L["Checkbox - PC / Mouse / Flip Mouse Controls"] = "마우스 버튼 전환"
		L["Checkbox - PC / Mouse / Flip Mouse Controls - Tooltip"] = "좌우 마우스 버튼 동작을 전환합니다.\n\n기본값: 끔."
		L["Title - PC / Keybind"] = "단축키"
		L["Keybind - PC / Keybind / Previous"] = "이전"
		L["Keybind - PC / Keybind / Previous - Tooltip"] = "이전 대화로 이동하는 키.\n\n기본값: Q."
		L["Keybind - PC / Keybind / Next"] = "다음"
		L["Keybind - PC / Keybind / Next - Tooltip"] = "다음 대화로 이동하는 키.\n\n기본값: E."
		L["Keybind - PC / Keybind / Progress"] = "진행"
		L["Keybind - PC / Keybind / Progress - Tooltip"] = "다음 작업에 사용하는 키:\n- 건너뛰기\n- 수락\n- 계속하기\n- 완료\n\n기본값: SPACE."
		L["Keybind - PC / Keybind / Progress - Tooltip / Conflict"] = addon.Theme.Settings.Tooltip_Text_Warning_Highlight .. "상호작용 키 사용" .. addon.Theme.Settings.Tooltip_Text_Warning .. " 옵션을 끄면 이 키를 변경할 수 있습니다.|r"
		L["Keybind - PC / Keybind / Quest Next Reward"] = "다음 보상"
		L["Keybind - PC / Keybind / Quest Next Reward - Tooltip"] = "퀘스트 보상에서 다음 항목을 선택하는 키.\n\n기본값: TAB."
		L["Keybind - PC / Keybind / Close"] = "닫기"
		L["Keybind - PC / Keybind / Close - Tooltip"] = "현재 상호작용 창을 닫는 단축키.\n\n기본값: ESCAPE."
		L["Title - Controller"] = "컨트롤러"
		L["Title - Controller / Controller"] = "컨트롤러"


		-- 게임플레이
		L["Title - Waypoint"] = "웨이포인트"
		L["Checkbox - Waypoint"] = "활성화"
		L["Checkbox - Waypoint - Tooltip"] = "블리자드 기본 내비게이션을 대체하는 웨이포인트 기능입니다.\n\n기본값: 켬."
		L["Checkbox - Waypoint / Audio"] = "오디오"
		L["Checkbox - Waypoint / Audio - Tooltip"] = "웨이포인트 상태가 변경될 때 효과음을 재생합니다.\n\n기본값: 켬."
		L["Title - Readable"] = "읽을 수 있는 아이템"
		L["Checkbox - Readable"] = "활성화"
		L["Checkbox - Readable - Tooltip"] = "읽을 수 있는 아이템 전용 UI를 활성화하며, 이를 저장할 수 있는 라이브러리를 제공합니다.\n\n기본값: 켬."
		L["Title - Readable / Display"] = "표시"
		L["Checkbox - Readable / Display / Always Show Item"] = "항상 아이템 표시"
		L["Checkbox - Readable / Display / Always Show Item - Tooltip"] = "게임 내 아이템 거리에서 벗어나도 UI가 닫히지 않도록 방지합니다.\n\n기본값: 끔."
		L["Title - Readable / Viewport"] = "뷰포트"
		L["Checkbox - Readable / Viewport"] = "뷰포트 효과 사용"
		L["Checkbox - Readable / Viewport - Tooltip"] = "읽기 UI를 열 때 뷰포트 효과를 적용합니다.\n\n기본값: 켬."
		L["Title - Readable / Shortcuts"] = "단축 경로"
		L["Checkbox - Readable / Shortcuts / Minimap Icon"] = "미니맵 아이콘"
		L["Checkbox - Readable / Shortcuts / Minimap Icon - Tooltip"] = "라이브러리로 빠르게 접근할 수 있는 미니맵 아이콘을 표시합니다.\n\n기본값: 켬."
		L["Title - Readable / Audiobook"] = "오디오북"
		L["Range - Readable / Audiobook - Rate"] = "재생 속도"
		L["Range - Readable / Audiobook - Rate - Tooltip"] = "오디오북의 재생 속도를 설정합니다.\n\n기본값: 100%."
		L["Range - Readable / Audiobook - Volume"] = "볼륨"
		L["Range - Readable / Audiobook - Volume - Tooltip"] = "오디오북의 재생 볼륨을 설정합니다.\n\n기본값: 100%."
		L["Dropdown - Readable / Audiobook - Voice"] = "내레이터"
		L["Dropdown - Readable / Audiobook - Voice - Tooltip"] = "재생 시 사용될 목소리입니다."
		L["Dropdown - Readable / Audiobook - Special Voice"] = "보조 내레이터"
		L["Dropdown - Readable / Audiobook - Special Voice - Tooltip"] = "'<>'로 묶인 특별한 문단에 사용되는 목소리입니다."
		L["Title - Gameplay"] = "게임플레이"
		L["Checkbox - Gameplay / Auto Select Option"] = "자동 옵션 선택"
		L["Checkbox - Gameplay / Auto Select Option - Tooltip"] = "일부 NPC의 최적 옵션을 자동으로 선택합니다.\n\n기본값: 끔."


		-- 추가 설정
		L["Title - Audio"] = "오디오"
		L["Checkbox - Audio"] = "오디오 활성화"
		L["Checkbox - Audio - Tooltip"] = "효과음과 오디오를 활성화합니다.\n\n기본값: 켬."
		L["Title - Settings"] = "설정"
		L["Checkbox - Settings / Reset Settings"] = "모든 설정 초기화"
		L["Checkbox - Settings / Reset Settings - Tooltip"] = "모든 설정을 기본값으로 초기화합니다.\n\n기본값: 끔."

		L["Title - Credits"] = "감사의 글"
		L["Title - Credits / ZamestoTV"] = "ZamestoTV | 러시아어 번역"
		L["Title - Credits / ZamestoTV - Tooltip"] = "러시아어 번역에 도움 주신 ZamestoTV님께 특별 감사드립니다!"
		L["Title - Credits / AKArenan"] = "AKArenan | 브라질 포르투갈어 번역"
		L["Title - Credits / AKArenan - Tooltip"] = "브라질 포르투갈어 번역에 도움 주신 AKArenan님께 특별 감사드립니다!"
		L["Title - Credits / El1as1989"] = "El1as1989 | 스페인어 번역"
		L["Title - Credits / El1as1989 - Tooltip"] = "스페인어 번역에 도움 주신 El1as1989님께 특별 감사드립니다!"
		L["Title - Credits / huchang47"] = "huchang47 | 중국어(간체) 번역"
		L["Title - Credits / huchang47 - Tooltip"] = "중국어 번역에 도움 주신 huchang47님께 특별 감사드립니다!"
		L["Title - Credits / muiqo"] = "muiqo | 독일어 번역"
		L["Title - Credits / muiqo - Tooltip"] = "독일어 번역에 도움 주신 muiqo님께 특별 감사드립니다!"
		L["Title - Credits / Crazyyoungs"] = "Crazyyoungs | Translator - Korean"
		L["Title - Credits / Crazyyoungs - Tooltip"] = "Special thanks to Crazyyoungs for the Korean translations!"
		L["Title - Credits / joaoc_pires"] = "Joao Pires | 코드 - 버그 수정"
		L["Title - Credits / joaoc_pires - Tooltip"] = "버그 수정에 도움 주신 Joao Pires님께 특별 감사드립니다!"
	end

	--------------------------------
	-- 읽기 쉬운 UI
	--------------------------------

	do
		do -- 라이브러리
			-- 프롬프트
			L["Readable - Library - Prompt - Delete - Local"] = "이 항목을 플레이어 라이브러리에서 영구적으로 삭제합니다."
			L["Readable - Library - Prompt - Delete - Global"] = "이 항목을 전쟁부대 라이브러리에서 영구적으로 삭제합니다."
			L["Readable - Library - Prompt - Delete Button 1"] = "삭제"
			L["Readable - Library - Prompt - Delete Button 2"] = "취소"

			L["Readable - Library - Prompt - Import - Local"] = "저장된 상태를 가져오면 플레이어 라이브러리가 덮어씌워집니다."
			L["Readable - Library - Prompt - Import - Global"] = "저장된 상태를 가져오면 전쟁부대 라이브러리가 덮어씌워집니다."
			L["Readable - Library - Prompt - Import Button 1"] = "가져오기 및 재시작"
			L["Readable - Library - Prompt - Import Button 2"] = "취소"

			L["Readable - Library - TextPrompt - Import - Local"] = "플레이어 라이브러리로 가져오기"
			L["Readable - Library - TextPrompt - Import - Global"] = "전쟁부대 라이브러리로 가져오기"
			L["Readable - Library - TextPrompt - Import Input Placeholder"] = "데이터 텍스트 입력"
			L["Readable - Library - TextPrompt - Import Button 1"] = "가져오기"

			L["Readable - Library - TextPrompt - Export - Local"] = "플레이어 데이터를 클립보드에 복사"
			L["Readable - Library - TextPrompt - Export - Global"] = "전쟁부대 데이터를 클립보드에 복사"
			L["Readable - Library - TextPrompt - Export Input Placeholder"] = "내보내기 코드가 올바르지 않습니다"


			-- 사이드바
			L["Readable - Library - Search Input Placeholder"] = "검색"
			L["Readable - Library - Export Button"] = "내보내기"
			L["Readable - Library - Import Button"] = "가져오기"
			L["Readable - Library - Show"] = "표시"
			L["Readable - Library - Letters"] = "편지"
			L["Readable - Library - Books"] = "책"
			L["Readable - Library - Slates"] = "석판"
			L["Readable - Library - Show only World"] = "월드 항목만 표시"

			-- 제목
			L["Readable - Library - Name Text - Global"] = "전쟁부대 라이브러리"
			L["Readable - Library - Name Text - Local - Subtext 1"] = ""
			L["Readable - Library - Name Text - Local - Subtext 2"] = "의 라이브러리"
			L["Readable - Library - Showing Status Text - Subtext 1"] = "표시 중: "
			L["Readable - Library - Showing Status Text - Subtext 2"] = "개 항목"

			-- 콘텐츠
			L["Readable - Library - No Results Text - Subtext 1"] = "검색 결과 없음: "
			L["Readable - Library - No Results Text - Subtext 2"] = "."
			L["Readable - Library - Empty Library Text"] = "등록된 항목이 없습니다."
		end

		do -- 읽을 수 있음
			-- 알림
			L["Readable - Notification - Saved To Library"] = "라이브러리에 저장되었습니다."

			--  툴팁
			L["Readable - Tooltip - Change Page"] = "페이지를 넘기려면 스크롤하세요."
		end
	end

	--------------------------------
	-- 오디오북
	--------------------------------

	do
		L["Audiobook - Action Tooltip"] = addon.API.Util:InlineIcon(addon.Variables.PATH_ART .. "Icons/mouse-left.png", 16, 16, 0, 0) .. " 드래그\n" .. addon.API.Util:InlineIcon(addon.Variables.PATH_ART .. "Icons/mouse-right.png", 16, 16, 0, 0) .. " 닫기"
	end

	--------------------------------
	-- 상호작용 퀘스트 프레임
	--------------------------------

	do
		L["InteractionFrame.QuestFrame - Objectives"] = "퀘스트 목표"
		L["InteractionFrame.QuestFrame - Rewards"] = "보상"
		L["InteractionFrame.QuestFrame - Required Items"] = "필요 아이템"

		L["InteractionFrame.QuestFrame - Accept - Quest Log Full"] = "퀘스트 목록이 가득 찼습니다"
		L["InteractionFrame.QuestFrame - Accept - Auto Accept"] = "자동 수락됨"
		L["InteractionFrame.QuestFrame - Accept"] = "수락"
		L["InteractionFrame.QuestFrame - Decline"] = "거절"
		L["InteractionFrame.QuestFrame - Goodbye"] = "잘 가요"
		L["InteractionFrame.QuestFrame - Goodbye - Auto Accept"] = "알겠습니다"
		L["InteractionFrame.QuestFrame - Continue"] = "계속"
		L["InteractionFrame.QuestFrame - In Progress"] = "진행 중"
		L["InteractionFrame.QuestFrame - Complete"] = "완료"
	end

	--------------------------------
	-- 상호작용 대화 프레임
	--------------------------------

	do
		L["InteractionFrame.DialogFrame - Skip"] = "건너뛰기"
	end

	--------------------------------
	-- 상호작용 대화창
	--------------------------------

	do
		L["InteractionFrame.GossipFrame - Close"] = "닫기"
	end

	--------------------------------
	-- 상호작용 제어 가이드
	--------------------------------

	do
		L["ControlGuide - Back"] = "뒤로"
		L["ControlGuide - Next"] = "다음"
		L["ControlGuide - Skip"] = "건너뛰기"
		L["ControlGuide - Accept"] = "수락"
		L["ControlGuide - Continue"] = "계속"
		L["ControlGuide - Complete"] = "완료"
		L["ControlGuide - Decline"] = "거절"
		L["ControlGuide - Goodbye"] = "닫기"
		L["ControlGuide - Got it"] = "알겠습니다"
		L["ControlGuide - Gossip Option Interact"] = "선택하기"
		L["ControlGuide - Quest Next Reward"] = "다음 보상"
	end

	--------------------------------
	-- 경고 알림
	--------------------------------

	do
		L["Alert Notification - Accept"] = "퀘스트 수락됨"
		L["Alert Notification - Complete"] = "퀘스트 완료됨"
	end

	--------------------------------
	-- 웨이포인트
	--------------------------------

	do
		L["Waypoint - Ready for Turn-in"] = "퀘스트 완료 보고 가능"

		L["Waypoint - Waypoint"] = "목표 지점"
		L["Waypoint - Quest"] = "퀘스트"
		L["Waypoint - Flight Point"] = "비행 지점"
		L["Waypoint - Pin"] = "핀"
		L["Waypoint - Party Member"] = "파티원"
		L["Waypoint - Content"] = "콘텐츠"
	end

	--------------------------------
	-- 플레이어 상태 표시줄
	--------------------------------

	do
		L["PlayerStatusBar - TooltipLine1"] = "현재 경험치:"
		L["PlayerStatusBar - TooltipLine2"] = "남은 경험치:"
		L["PlayerStatusBar - TooltipLine3"] = "레벨 "
	end

	--------------------------------
	-- 미니맵 아이콘
	--------------------------------

	do
		L["MinimapIcon - Tooltip - Title"] = "상호작용 도감"
		L["MinimapIcon - Tooltip - Entries - Subtext 1"] = ""
		L["MinimapIcon - Tooltip - Entries - Subtext 2"] = "개의 항목"
		L["MinimapIcon - Tooltip - Entries - Singular - Subtext 1"] = ""
		L["MinimapIcon - Tooltip - Entries - Singular - Subtext 2"] = "개 항목"
		L["MinimapIcon - Tooltip - Entries - Empty"] = "항목 없음"
	end

	--------------------------------
	-- 블리자드 설정
	--------------------------------

	do
		L["BlizzardSettings - Title"] = "설정 열기"
		L["BlizzardSettings - Shortcut - Controller"] = "상호작용 UI 내에서"
	end

	--------------------------------
	-- 알림
	--------------------------------

	do
		L["Alert - Under Attack"] = "공격받고 있습니다!"
		L["Alert - Open Settings"] = "설정을 열려면"
	end

	--------------------------------
	-- 대화 데이터
	--------------------------------

	do
		-- '동적 재생' 일시 정지에 사용되는 문자입니다. 단일 문자만 지원합니다.
		L["DialogData - PauseCharDB"] = {
			"…",
			"!",
			"?",
			".",
			",",
			";",
		}

		-- 해당 언어의 기본 TTS의 대략적인 속도에 맞춰 대화 재생 속도를 조정합니다. 높을수록 더 빠릅니다.
		L["DialogData - PlaybackSpeedModifier"] = 1
	end

	--------------------------------
	-- 소문 데이터
	--------------------------------

	do
		-- Blizzard의 특별 가십 옵션 접두사 텍스트와 일치해야 합니다..
		L["GossipData - Trigger - Quest"] = "%(퀘스트%)"
		L["GossipData - Trigger - Movie 1"] = "%(재생%)"
		L["GossipData - Trigger - Movie 2"] = "%(영상 재생%)"
		L["GossipData - Trigger - NPC Dialog"] = "%<잠깐 머물며 이야기를 들어보세요.%>"
		L["GossipData - Trigger - NPC Dialog - Append"] = "잠깐 머물며 이야기를 들어보세요."
	end

	--------------------------------
	-- 오디오북 데이터
	--------------------------------

	do
		-- 해당 언어의 기본 TTS 속도와 대략 일치하도록 초당 추정 문자 수를 나타냅니다. 높을수록 더 빠릅니다.
		-- 이것은 Blizzard TTS에서 가끔 다음 줄로 넘어가지 못하는 문제를 해결하기 위한 방법으로, 일정 시간이 지난 후 수동으로 다시 시작해야 합니다.
		L["AudiobookData - EstimatedCharPerSecond"] = 10
	end

	--------------------------------
	-- 지원되는 애드온
	--------------------------------

	do
		do -- BtWQuests
			L["SupportedAddons - BtWQuests - Tooltip - Quest - Completed - Subtext 1"] = addon.Theme.RGB_GREEN_HEXCODE
			L["SupportedAddons - BtWQuests - Tooltip - Quest - Completed - Subtext 2"] = "|r"
			L["SupportedAddons - BtWQuests - Tooltip - Quest - Active - Subtext 1"] = addon.Theme.RGB_WHITE_HEXCODE
			L["SupportedAddons - BtWQuests - Tooltip - Quest - Active - Subtext 2"] = "|r"
			L["SupportedAddons - BtWQuests - Tooltip - Quest - Incomplete - Subtext 1"] = addon.Theme.RGB_GRAY_HEXCODE
			L["SupportedAddons - BtWQuests - Tooltip - Quest - Incomplete - Subtext 2"] = "|r"
			L["SupportedAddons - BtWQuests - Tooltip - Call to Action"] = addon.Theme.RGB_ORANGE_HEXCODE .. "BtWQuests에서 퀘스트 체인을 열려면 클릭하세요" .. "|r"
		end
	end
end

Load()
