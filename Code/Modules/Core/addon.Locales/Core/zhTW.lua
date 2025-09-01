---@class addon
local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local PrefabRegistry = addon.PrefabRegistry
local L = addon.Locales

--------------------------------

local function Load()
	if GetLocale() ~= "zhTW" then
		return
	end

	--------------------------------
	-- SETTINGS
	--------------------------------

	do
		-- WARNINGS
		L["Warning - Leave NPC Interaction"] = "請先離開 NPC 互動再調整設定。"
		L["Warning - Leave ReadableUI"] = "請先離開閱讀介面再調整設定。"

		-- PROMPTS
		L["Prompt - Reload"] = "套用設定需要重新載入介面"
		L["Prompt - Reload Button 1"] = "重新載入"
		L["Prompt - Reload Button 2"] = "關閉"
		L["Prompt - Reset Settings"] = "確定要將設定重置為預設值嗎？"
		L["Prompt - Reset Settings Button 1"] = "重置"
		L["Prompt - Reset Settings Button 2"] = "取消"

		-- TABS
		L["Tab - Appearance"] = "外觀"
		L["Tab - Effects"] = "特效"
		L["Tab - Playback"] = "播放"
		L["Tab - Controls"] = "控制"
		L["Tab - Gameplay"] = "遊戲玩法"
		L["Tab - More"] = "更多"

		-- ELEMENTS
		-- APPEARANCE
		L["Title - Theme"] = "主題"
		L["Range - Main Theme"] = "主要主題"
		L["Range - Main Theme - Tooltip"] = "設定整體介面主題。\n\n預設：日間。\n\n" .. addon.Theme.Settings.Tooltip_Text_Note_Highlight .. "動態" .. addon.Theme.Settings.Tooltip_Text_Note .. "選項會根據遊戲內的晝夜循環設定主要主題。|r"
		L["Range - Main Theme - Day"] = "日間"
		L["Range - Main Theme - Night"] = "夜間"
		L["Range - Main Theme - Dynamic"] = "動態"
		L["Range - Dialog Theme"] = "對話主題"
		L["Range - Dialog Theme - Tooltip"] = "設定 NPC 對話介面主題。\n\n預設：匹配。\n\n" .. addon.Theme.Settings.Tooltip_Text_Note_Highlight .. "匹配" .. addon.Theme.Settings.Tooltip_Text_Note .. "選項會將對話主題設定為與主要主題一致。|r"
		L["Range - Dialog Theme - Auto"] = "匹配"
		L["Range - Dialog Theme - Day"] = "日間"
		L["Range - Dialog Theme - Night"] = "夜間"
		L["Range - Dialog Theme - Rustic"] = "古樸"
		L["Title - Appearance"] = "外觀設定"
		L["Range - UIDirection"] = "介面方向"
		L["Range - UIDirection - Tooltip"] = "設定介面方向。"
		L["Range - UIDirection - Left"] = "左側"
		L["Range - UIDirection - Right"] = "右側"
		L["Range - UIDirection / Dialog"] = "固定對話位置"
		L["Range - UIDirection / Dialog - Tooltip"] = "設定固定對話位置。\n\n當 NPC 名牌不可用時，會使用固定對話位置。"
		L["Range - UIDirection / Dialog - Top"] = "上方"
		L["Range - UIDirection / Dialog - Center"] = "中央"
		L["Range - UIDirection / Dialog - Bottom"] = "下方"
		L["Checkbox - UIDirection / Dialog / Mirror"] = "鏡像"
		L["Checkbox - UIDirection / Dialog / Mirror - Tooltip"] = "鏡像介面方向。"
		L["Range - Quest Frame Size"] = "任務框架大小"
		L["Range - Quest Frame Size - Tooltip"] = "調整任務框架大小。\n\n預設：中型。"
		L["Range - Quest Frame Size - Small"] = "小型"
		L["Range - Quest Frame Size - Medium"] = "中型"
		L["Range - Quest Frame Size - Large"] = "大型"
		L["Range - Quest Frame Size - Extra Large"] = "超大型"
		L["Range - Text Size"] = "文字大小"
		L["Range - Text Size - Tooltip"] = "調整文字大小。"
		L["Title - Dialog"] = "對話"
		L["Checkbox - Dialog / Title / Progress Bar"] = "顯示進度條"
		L["Checkbox - Dialog / Title / Progress Bar - Tooltip"] = "顯示或隱藏對話進度條。\n\n此進度條指示當前對話的進行狀況。\n\n預設：開啟。"
		L["Range - Dialog / Title / Text Alpha"] = "標題透明度"
		L["Range - Dialog / Title / Text Alpha - Tooltip"] = "設定對話標題的透明度。\n\n預設：50%。"
		L["Range - Dialog / Content Preview Alpha"] = "預覽透明度"
		L["Range - Dialog / Content Preview Alpha - Tooltip"] = "設定對話文字預覽的透明度。\n\n預設：50%。"
		L["Title - Gossip"] = "閒聊"
		L["Checkbox - Always Show Gossip Frame"] = "總是顯示閒聊框架"
		L["Checkbox - Always Show Gossip Frame - Tooltip"] = "有可用閒聊框架時總是顯示，而不只是在對話後顯示。\n\n預設：開啟。"
		L["Title - Quest"] = "任務"
		L["Checkbox - Always Show Quest Frame"] = "總是顯示任務框架"
		L["Checkbox - Always Show Quest Frame - Tooltip"] = "有可用任務框架時總是顯示，而不只是在對話後顯示。\n\n預設：開啟。"

		-- VIEWPORT
		L["Title - Effects"] = "特效"
		L["Checkbox - Hide UI"] = "隱藏介面"
		L["Checkbox - Hide UI - Tooltip"] = "在與 NPC 互動時隱藏介面。\n\n預設：開啟。"
		L["Range - Cinematic"] = "鏡頭特效"
		L["Range - Cinematic - Tooltip"] = "互動期間的鏡頭特效。\n\n預設：完整。"
		L["Range - Cinematic - None"] = "無"
		L["Range - Cinematic - Full"] = "完整"
		L["Range - Cinematic - Balanced"] = "平衡"
		L["Range - Cinematic - Custom"] = "自訂"
		L["Checkbox - Zoom"] = "縮放"
		L["Range - Zoom / Min Distance"] = "最小距離"
		L["Range - Zoom / Min Distance - Tooltip"] = "如果目前縮放距離低於此閾值，鏡頭將縮放至此等級。"
		L["Range - Zoom / Max Distance"] = "最大距離"
		L["Range - Zoom / Max Distance - Tooltip"] = "如果目前縮放距離高於此閾值，鏡頭將縮放至此等級。"
		L["Checkbox - Zoom / Pitch"] = "調整垂直角度"
		L["Checkbox - Zoom / Pitch - Tooltip"] = "啟用鏡頭垂直角度調整。"
		L["Range - Zoom / Pitch / Level"] = "最大角度"
		L["Range - Zoom / Pitch / Level - Tooltip"] = "垂直角度閾值。"
		L["Checkbox - Zoom / Field Of View"] = "調整視野範圍"
		L["Checkbox - Pan"] = "平移"
		L["Range - Pan / Speed"] = "速度"
		L["Range - Pan / Speed - Tooltip"] = "最大平移速度。"
		L["Checkbox - Dynamic Camera"] = "動態鏡頭"
		L["Checkbox - Dynamic Camera - Tooltip"] = "啟用動態鏡頭設定。"
		L["Checkbox - Dynamic Camera / Side View"] = "側視圖"
		L["Checkbox - Dynamic Camera / Side View - Tooltip"] = "調整鏡頭以獲得側視圖。"
		L["Range - Dynamic Camera / Side View / Strength"] = "強度"
		L["Range - Dynamic Camera / Side View / Strength - Tooltip"] = "數值越高，側向移動越大。"
		L["Checkbox - Dynamic Camera / Offset"] = "偏移"
		L["Checkbox - Dynamic Camera / Offset - Tooltip"] = "將視野從角色處偏移。"
		L["Range - Dynamic Camera / Offset / Strength"] = "強度"
		L["Range - Dynamic Camera / Offset / Strength - Tooltip"] = "數值越高，偏移越大。"
		L["Checkbox - Dynamic Camera / Focus"] = "焦點"
		L["Checkbox - Dynamic Camera / Focus - Tooltip"] = "將視野聚焦於目標。"
		L["Range - Dynamic Camera / Focus / Strength"] = "強度"
		L["Range - Dynamic Camera / Focus / Strength - Tooltip"] = "數值越高，聚焦強度越大。"
		L["Checkbox - Dynamic Camera / Focus / X"] = "忽略 X 軸"
		L["Checkbox - Dynamic Camera / Focus / X - Tooltip"] = "防止 X 軸聚焦。"
		L["Checkbox - Dynamic Camera / Focus / Y"] = "忽略 Y 軸"
		L["Checkbox - Dynamic Camera / Focus / Y - Tooltip"] = "防止 Y 軸聚焦。"
		L["Checkbox - Vignette"] = "暈影效果"
		L["Checkbox - Vignette - Tooltip"] = "降低邊緣亮度。"
		L["Checkbox - Vignette / Gradient"] = "漸層"
		L["Checkbox - Vignette / Gradient - Tooltip"] = "降低閒聊和任務介面元素後方的亮度。"

		-- PLAYBACK
		L["Title - Pace"] = "節奏"
		L["Range - Playback Speed"] = "播放速度"
		L["Range - Playback Speed - Tooltip"] = "文字播放速度。\n\n預設：100%。"
		L["Checkbox - Dynamic Playback"] = "動態播放"
		L["Checkbox - Dynamic Playback - Tooltip"] = "在對話中新增標點符號停頓。\n\n預設：開啟。"
		L["Title - Auto Progress"] = "自動推進"
		L["Checkbox - Auto Progress"] = "啟用"
		L["Checkbox - Auto Progress - Tooltip"] = "自動推進到下一個對話。\n\n預設：開啟。"
		L["Checkbox - Auto Close Dialog"] = "自動關閉"
		L["Checkbox - Auto Close Dialog - Tooltip"] = "當沒有可用選項時，停止與 NPC 的互動。\n\n預設：開啟。"
		L["Range - Auto Progress / Delay"] = "延遲"
		L["Range - Auto Progress / Delay - Tooltip"] = "進入下一個對話前的延遲時間。\n\n預設：1。"
		L["Title - Text To Speech"] = "文字轉語音"
		L["Checkbox - Text To Speech"] = "啟用"
		L["Checkbox - Text To Speech - Tooltip"] = "朗讀對話文字。\n\n預設：關閉。"
		L["Title - Text To Speech / Playback"] = "播放設定"
		L["Checkbox - Text To Speech / Quest"] = "播放任務對話"
		L["Checkbox - Text To Speech / Quest - Tooltip"] = "在任務對話中啟用文字轉語音功能。\n\n預設：開啟。"
		L["Checkbox - Text To Speech / Gossip"] = "播放閒聊對話"
		L["Checkbox - Text To Speech / Gossip - Tooltip"] = "在閒聊對話中啟用文字轉語音功能。\n\n預設：開啟。"
		L["Range - Text To Speech / Rate"] = "語速"
		L["Range - Text To Speech / Rate - Tooltip"] = "語音播放速度。\n\n預設：100%。"
		L["Range - Text To Speech / Volume"] = "音量"
		L["Range - Text To Speech / Volume - Tooltip"] = "語音播放音量。\n\n預設：100%。"
		L["Title - Text To Speech / Voice"] = "語音"
		L["Dropdown - Text To Speech / Voice / Neutral"] = "中性"
		L["Dropdown - Text To Speech / Voice / Neutral - Tooltip"] = "用於性別中性的 NPC。"
		L["Dropdown - Text To Speech / Voice / Male"] = "男性"
		L["Dropdown - Text To Speech / Voice / Male - Tooltip"] = "用於男性 NPC。"
		L["Dropdown - Text To Speech / Voice / Female"] = "女性"
		L["Dropdown - Text To Speech / Voice / Female - Tooltip"] = "用於女性 NPC。"
		L["Dropdown - Text To Speech / Voice / Emote"] = "表情"
		L["Dropdown - Text To Speech / Voice / Emote - Tooltip"] = "用於 '<>' 中的對話。"
		L["Checkbox - Text To Speech / Player / Voice"] = "玩家語音"
		L["Checkbox - Text To Speech / Player / Voice - Tooltip"] = "選擇對話選項時播放文字轉語音。\n\n預設：開啟。"
		L["Dropdown - Text To Speech / Player / Voice / Voice"] = "語音"
		L["Dropdown - Text To Speech / Player / Voice / Voice - Tooltip"] = "對話選項的語音。"
		L["Title - More"] = "更多"
		L["Checkbox - Mute Dialog"] = "靜音 NPC 對話"
		L["Checkbox - Mute Dialog - Tooltip"] = "在與 NPC 互動期間靜音暴雪的 NPC 對話音效。\n\n預設：關閉。"

		-- CONTROLS
		L["Title - UI"] = "介面"
		L["Checkbox - UI / Control Guide"] = "顯示控制指南"
		L["Checkbox - UI / Control Guide - Tooltip"] = "顯示控制指南框架。\n\n預設：開啟。"
		L["Title - Platform"] = "平台"
		L["Range - Platform"] = "平台"
		L["Range - Platform - Tooltip"] = "需要重新載入介面才能生效。"
		L["Range - Platform - PC"] = "PC"
		L["Range - Platform - Playstation"] = "Playstation"
		L["Range - Platform - Xbox"] = "Xbox"
		L["Title - PC"] = "PC"
		L["Title - PC / Keyboard"] = "鍵盤"
		L["Checkbox - PC / Keyboard / Use Interact Key"] = "使用互動鍵"
		L["Checkbox - PC / Keyboard / Use Interact Key - Tooltip"] = "使用互動鍵進行操作。不支援多鍵組合。\n\n預設：關閉。"
		L["Title - PC / Mouse"] = "滑鼠"
		L["Checkbox - PC / Mouse / Flip Mouse Controls"] = "反轉滑鼠控制"
		L["Checkbox - PC / Mouse / Flip Mouse Controls - Tooltip"] = "反轉滑鼠左右控制。\n\n預設：關閉。"
		L["Title - PC / Keybind"] = "按鍵"
		L["Keybind - PC / Keybind / Previous"] = "上一個"
		L["Keybind - PC / Keybind / Previous - Tooltip"] = "上一個對話的按鍵。\n\n預設：Q。"
		L["Keybind - PC / Keybind / Next"] = "下一個"
		L["Keybind - PC / Keybind / Next - Tooltip"] = "下一個對話的按鍵。\n\n預設：E。"
		L["Keybind - PC / Keybind / Progress"] = "推進"
		L["Keybind - PC / Keybind / Progress - Tooltip"] = "按鍵用於：\n- 跳過\n- 接受\n- 繼續\n- 完成\n\n預設：空白鍵。"
		L["Keybind - PC / Keybind / Progress - Tooltip / Conflict"] = addon.Theme.Settings.Tooltip_Text_Warning_Highlight .. "使用互動鍵" .. addon.Theme.Settings.Tooltip_Text_Warning .. "選項必須停用才能調整此按鍵。|r"
		L["Keybind - PC / Keybind / Quest Next Reward"] = "下一個獎勵"
		L["Keybind - PC / Keybind / Quest Next Reward - Tooltip"] = "選擇下一個任務獎勵的按鍵。\n\n預設：Tab 鍵。"
		L["Keybind - PC / Keybind / Close"] = "關閉"
		L["Keybind - PC / Keybind / Close - Tooltip"] = "關閉目前活躍互動視窗的按鍵。\n\n預設：Esc 鍵。"
		L["Title - Controller"] = "控制器"
		L["Title - Controller / Controller"] = "控制器"

		-- GAMEPLAY
		L["Title - Waypoint"] = "路徑點"
		L["Checkbox - Waypoint"] = "啟用"
		L["Checkbox - Waypoint - Tooltip"] = "使用路徑點替代暴雪的遊戲內導航功能。\n\n預設：開啟。"
		L["Checkbox - Waypoint / Audio"] = "音效"
		L["Checkbox - Waypoint / Audio - Tooltip"] = "路徑點狀態改變時的音效。\n\n預設：開啟。"
		L["Title - Readable"] = "可閱讀物品"
		L["Checkbox - Readable"] = "啟用"
		L["Checkbox - Readable - Tooltip"] = "為可閱讀物品啟用自訂介面 - 以及用於儲存它們的圖書館。\n\n預設：開啟。"
		L["Title - Readable / Display"] = "顯示設定"
		L["Checkbox - Readable / Display / Always Show Item"] = "總是顯示物品"
		L["Checkbox - Readable / Display / Always Show Item - Tooltip"] = "當離開遊戲內物品的互動距離時，防止可閱讀物品介面關閉。\n\n預設：關閉。"
		L["Title - Readable / Viewport"] = "視野"
		L["Checkbox - Readable / Viewport"] = "使用視野特效"
		L["Checkbox - Readable / Viewport - Tooltip"] = "啟動可閱讀物品介面時的視野特效。\n\n預設：開啟。"
		L["Title - Readable / Shortcuts"] = "捷徑"
		L["Checkbox - Readable / Shortcuts / Minimap Icon"] = "小地圖圖示"
		L["Checkbox - Readable / Shortcuts / Minimap Icon - Tooltip"] = "在小地圖上顯示圖示，以便快速存取圖書館。\n\n預設：開啟。"
		L["Title - Readable / Audiobook"] = "有聲書"
		L["Range - Readable / Audiobook - Rate"] = "語速"
		L["Range - Readable / Audiobook - Rate - Tooltip"] = "播放語速。\n\n預設：100%。"
		L["Range - Readable / Audiobook - Volume"] = "音量"
		L["Range - Readable / Audiobook - Volume - Tooltip"] = "播放音量。\n\n預設：100%。"
		L["Dropdown - Readable / Audiobook - Voice"] = "旁白"
		L["Dropdown - Readable / Audiobook - Voice - Tooltip"] = "播放語音。"
		L["Dropdown - Readable / Audiobook - Special Voice"] = "次要旁白"
		L["Dropdown - Readable / Audiobook - Special Voice - Tooltip"] = "用於特殊段落（如 '<>' 內的段落）的播放語音。"
		L["Title - Gameplay"] = "遊戲玩法"
		L["Checkbox - Gameplay / Auto Select Option"] = "自動選擇選項"
		L["Checkbox - Gameplay / Auto Select Option - Tooltip"] = "為特定 NPC 選擇最佳選項。\n\n預設：關閉。"

		-- MORE
		L["Title - Audio"] = "音效"
		L["Checkbox - Audio"] = "啟用音效"
		L["Checkbox - Audio - Tooltip"] = "啟用音效和音訊。\n\n預設：開啟。"
		L["Title - Settings"] = "設定"
		L["Checkbox - Settings / Reset Settings"] = "重置所有設定"
		L["Checkbox - Settings / Reset Settings - Tooltip"] = "將設定重置為預設值。\n\n預設：關閉。"

		L["Title - Credits"] = "致謝"
		L["Title - Credits / ZamestoTV"] = "ZamestoTV | 翻譯者 - 俄語"
		L["Title - Credits / ZamestoTV - Tooltip"] = "特別感謝 ZamestoTV 提供俄語翻譯！"
		L["Title - Credits / AKArenan"] = "AKArenan | 翻譯者 - 巴西葡萄牙語"
		L["Title - Credits / AKArenan - Tooltip"] = "特別感謝 AKArenan 提供巴西葡萄牙語翻譯！"
		L["Title - Credits / El1as1989"] = "El1as1989 | 翻譯者 - 西班牙語"
		L["Title - Credits / El1as1989 - Tooltip"] = "特別感謝 El1as1989 提供西班牙語翻譯！"
		L["Title - Credits / huchang47"] = "huchang47 | 翻譯者 - 簡體中文"
		L["Title - Credits / huchang47 - Tooltip"] = "特別感謝 huchang47 提供簡體中文翻譯！"
		L["Title - Credits / muiqo"] = "muiqo | 翻譯者 - 德語"
		L["Title - Credits / muiqo - Tooltip"] = "特別感謝 muiqo 提供德語翻譯！"
		L["Title - Credits / Crazyyoungs"] = "Crazyyoungs | 翻譯者 - 韓語"
		L["Title - Credits / Crazyyoungs - Tooltip"] = "特別感謝 Crazyyoungs 提供韓語翻譯！"
		L["Title - Credits / fang2hou"] = "fang2hou | Translator - Chinese (Traditional)"
		L["Title - Credits / fang2hou - Tooltip"] = "Special thanks to fang2hou for the Chinese (Traditional) translations!"
		L["Title - Credits / joaoc_pires"] = "Joao Pires | 程式 - 錯誤修復"
		L["Title - Credits / joaoc_pires - Tooltip"] = "特別感謝 Joao Pires 的錯誤修復！"
	end

	--------------------------------
	-- READABLE UI
	--------------------------------

	do
		do -- LIBRARY
			-- PROMPTS
			L["Readable - Library - Prompt - Delete - Local"] = "這將從你的角色圖書館中永久移除此項目。"
			L["Readable - Library - Prompt - Delete - Global"] = "這將從戰隊圖書館中永久移除此項目。"
			L["Readable - Library - Prompt - Delete Button 1"] = "移除"
			L["Readable - Library - Prompt - Delete Button 2"] = "取消"

			L["Readable - Library - Prompt - Import - Local"] = "匯入儲存狀態將覆蓋你的角色圖書館。"
			L["Readable - Library - Prompt - Import - Global"] = "匯入儲存狀態將覆蓋戰隊圖書館。"
			L["Readable - Library - Prompt - Import Button 1"] = "匯入並重新載入"
			L["Readable - Library - Prompt - Import Button 2"] = "取消"

			L["Readable - Library - TextPrompt - Import - Local"] = "匯入到角色圖書館"
			L["Readable - Library - TextPrompt - Import - Global"] = "匯入到戰隊圖書館"
			L["Readable - Library - TextPrompt - Import Input Placeholder"] = "輸入資料文字"
			L["Readable - Library - TextPrompt - Import Button 1"] = "匯入"

			L["Readable - Library - TextPrompt - Export - Local"] = "複製角色資料到剪貼簿"
			L["Readable - Library - TextPrompt - Export - Global"] = "複製戰隊資料到剪貼簿"
			L["Readable - Library - TextPrompt - Export Input Placeholder"] = "無效的匯出字串"

			-- SIDEBAR
			L["Readable - Library - Search Input Placeholder"] = "搜尋"
			L["Readable - Library - Export Button"] = "匯出"
			L["Readable - Library - Import Button"] = "匯入"
			L["Readable - Library - Show"] = "顯示"
			L["Readable - Library - Letters"] = "信件"
			L["Readable - Library - Books"] = "書籍"
			L["Readable - Library - Slates"] = "石板"
			L["Readable - Library - Show only World"] = "僅世界"

			-- TITLE
			L["Readable - Library - Name Text - Global"] = "戰隊圖書館"
			L["Readable - Library - Name Text - Local - Subtext 1"] = ""
			L["Readable - Library - Name Text - Local - Subtext 2"] = "的圖書館"
			L["Readable - Library - Showing Status Text - Subtext 1"] = "顯示 "
			L["Readable - Library - Showing Status Text - Subtext 2"] = " 個項目"

			-- CONTENT
			L["Readable - Library - No Results Text - Subtext 1"] = "沒有找到 "
			L["Readable - Library - No Results Text - Subtext 2"] = " 的結果。"
			L["Readable - Library - Empty Library Text"] = "無項目。"
		end

		do -- READABLE
			-- NOTIFICATIONS
			L["Readable - Notification - Saved To Library"] = "已儲存到圖書館"

			-- TOOLTIP
			L["Readable - Tooltip - Change Page"] = "滾動以翻頁。"
		end
	end

	--------------------------------
	-- AUDIOBOOK
	--------------------------------

	do
		L["Audiobook - Action Tooltip"] = addon.API.Util:InlineIcon(addon.Variables.PATH_ART .. "Icons/mouse-left.png", 16, 16, 0, 0) .. " 拖曳。\n" .. addon.API.Util:InlineIcon(addon.Variables.PATH_ART .. "Icons/mouse-right.png", 16, 16, 0, 0) .. " 關閉。"
	end

	--------------------------------
	-- INTERACTION QUEST FRAME
	--------------------------------

	do
		L["InteractionFrame.QuestFrame - Objectives"] = "任務目標"
		L["InteractionFrame.QuestFrame - Rewards"] = "獎勵"
		L["InteractionFrame.QuestFrame - Required Items"] = "所需物品"

		L["InteractionFrame.QuestFrame - Accept - Quest Log Full"] = "任務日誌已滿"
		L["InteractionFrame.QuestFrame - Accept - Auto Accept"] = "已自動接受"
		L["InteractionFrame.QuestFrame - Accept"] = "接受"
		L["InteractionFrame.QuestFrame - Decline"] = "拒絕"
		L["InteractionFrame.QuestFrame - Goodbye"] = "再見"
		L["InteractionFrame.QuestFrame - Goodbye - Auto Accept"] = "瞭解"
		L["InteractionFrame.QuestFrame - Continue"] = "繼續"
		L["InteractionFrame.QuestFrame - In Progress"] = "進行中"
		L["InteractionFrame.QuestFrame - Complete"] = "完成"
	end

	--------------------------------
	-- INTERACTION DIALOG FRAME
	--------------------------------

	do
		L["InteractionFrame.DialogFrame - Skip"] = "跳過"
	end

	--------------------------------
	-- INTERACTION GOSSIP FRAME
	--------------------------------

	do
		L["InteractionFrame.GossipFrame - Close"] = "再見"
	end

	--------------------------------
	-- INTERACTION CONTROL GUIDE
	--------------------------------

	do
		L["ControlGuide - Back"] = "返回"
		L["ControlGuide - Next"] = "下一步"
		L["ControlGuide - Skip"] = "跳過"
		L["ControlGuide - Accept"] = "接受"
		L["ControlGuide - Continue"] = "繼續"
		L["ControlGuide - Complete"] = "完成"
		L["ControlGuide - Decline"] = "拒絕"
		L["ControlGuide - Goodbye"] = "再見"
		L["ControlGuide - Got it"] = "瞭解"
		L["ControlGuide - Gossip Option Interact"] = "選擇選項"
		L["ControlGuide - Quest Next Reward"] = "下一個獎勵"
	end

	--------------------------------
	-- ALERT NOTIFICATION
	--------------------------------

	do
		L["Alert Notification - Accept"] = "已接受任務"
		L["Alert Notification - Complete"] = "已完成任務"
	end

	--------------------------------
	-- WAYPOINT
	--------------------------------

	do
		L["Waypoint - Ready for Turn-in"] = "可交付任務"

		L["Waypoint - Waypoint"] = "路徑點"
		L["Waypoint - Quest"] = "任務"
		L["Waypoint - Flight Point"] = "飛行點"
		L["Waypoint - Pin"] = "標記"
		L["Waypoint - Party Member"] = "隊伍成員"
		L["Waypoint - Content"] = "內容"
	end

	--------------------------------
	-- PLAYER STATUS BAR
	--------------------------------

	do
		L["PlayerStatusBar - TooltipLine1"] = "目前經驗值："
		L["PlayerStatusBar - TooltipLine2"] = "剩餘經驗值："
		L["PlayerStatusBar - TooltipLine3"] = "等級 "
	end

	--------------------------------
	-- MINIMAP ICON
	--------------------------------

	do
		L["MinimapIcon - Tooltip - Title"] = "互動圖書館"
		L["MinimapIcon - Tooltip - Entries - Subtext 1"] = ""
		L["MinimapIcon - Tooltip - Entries - Subtext 2"] = " 個項目"
		L["MinimapIcon - Tooltip - Entries - Singular - Subtext 1"] = ""
		L["MinimapIcon - Tooltip - Entries - Singular - Subtext 2"] = " 個項目"
		L["MinimapIcon - Tooltip - Entries - Empty"] = "無項目。"
	end

	--------------------------------
	-- BLIZZARD SETTINGS
	--------------------------------

	do
		L["BlizzardSettings - Title"] = "開啟設定"
		L["BlizzardSettings - Shortcut - Controller"] = "在任何互動介面中。"
	end

	--------------------------------
	-- ALERTS
	--------------------------------

	do
		L["Alert - Under Attack"] = "正在戰鬥中"
		L["Alert - Open Settings"] = "開啟設定。"
	end

	--------------------------------
	-- DIALOG DATA
	--------------------------------

	do
		-- Characters used for 'Dynamic Playback' pausing. Only supports single characters.
		L["DialogData - PauseCharDB"] = {
			"…",
			"！",
			"？",
			"。",
			"，",
			"；",
		}

		-- Modifier of dialog playback speed to match the rough speed of base TTS in the language. Higher = faster.
		L["DialogData - PlaybackSpeedModifier"] = 1
	end

	--------------------------------
	-- GOSSIP DATA
	--------------------------------

	do
		-- Need to match Blizzard's special gossip option prefix text.
		L["GossipData - Trigger - Quest"] = "%(任務%)"
		L["GossipData - Trigger - Movie 1"] = "%(播放%)"
		L["GossipData - Trigger - Movie 2"] = "%(播放影片%)"
		L["GossipData - Trigger - NPC Dialog"] = "%<稍等一下，聽我說。%>"
		L["GossipData - Trigger - NPC Dialog - Append"] = "稍等一下，聽我說。"
	end

	--------------------------------
	-- AUDIOBOOK DATA
	--------------------------------

	do
		-- Estimated character per second to roughly match the speed of the base TTS in the language. Higher = faster.
		-- This is a workaround for Blizzard TTS where it sometimes fails to continue to the next line, so we need to manually start it back up after a period of time.
		L["AudiobookData - EstimatedCharPerSecond"] = 5
	end

	--------------------------------
	-- SUPPORTED ADDONS
	--------------------------------

	do
		do -- BtWQuests
			L["SupportedAddons - BtWQuests - Tooltip - Quest - Completed - Subtext 1"] = addon.Theme.RGB_GREEN_HEXCODE
			L["SupportedAddons - BtWQuests - Tooltip - Quest - Completed - Subtext 2"] = "|r"
			L["SupportedAddons - BtWQuests - Tooltip - Quest - Active - Subtext 1"] = addon.Theme.RGB_WHITE_HEXCODE
			L["SupportedAddons - BtWQuests - Tooltip - Quest - Active - Subtext 2"] = "|r"
			L["SupportedAddons - BtWQuests - Tooltip - Quest - Incomplete - Subtext 1"] = addon.Theme.RGB_GRAY_HEXCODE
			L["SupportedAddons - BtWQuests - Tooltip - Quest - Incomplete - Subtext 2"] = "|r"
			L["SupportedAddons - BtWQuests - Tooltip - Call to Action"] = addon.Theme.RGB_ORANGE_HEXCODE .. "點擊以在 BtWQuests 中開啟任務鏈" .. "|r"
		end
	end
end

Load()
