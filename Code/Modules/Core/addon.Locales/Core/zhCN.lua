-- Localization and translation huchang47

---@class addon
local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local PrefabRegistry = addon.PrefabRegistry
local L = addon.Locales

--------------------------------

local function Load()
	if GetLocale() ~= "zhCN" then
		return
	end

	--------------------------------
	-- SETTINGS
	--------------------------------

	do
		-- WARNINGS
		L["Warning - Leave NPC Interaction"] = "脱离NPC交互才能调整设置。"
		L["Warning - Leave ReadableUI"] = "离开任务界面才能调整设置。"

		-- PROMPTS
		L["Prompt - Reload"] = "应用设置需要重载界面"
		L["Prompt - Reload Button 1"] = "重载"
		L["Prompt - Reload Button 2"] = "关闭"
		L["Prompt - Reset Settings"] = "你确定要重置到默认设置吗？"
		L["Prompt - Reset Settings Button 1"] = "重置"
		L["Prompt - Reset Settings Button 2"] = "取消"

		-- TABS
		L["Tab - Appearance"] = "外观"
		L["Tab - Effects"] = "特效"
		L["Tab - Playback"] = "播放"
		L["Tab - Controls"] = "控制"
		L["Tab - Gameplay"] = "游戏玩法"
		L["Tab - More"] = "更多"

		-- ELEMENTS
		-- APPEARANCE
		L["Title - Theme"] = "主题"
		L["Range - Main Theme"] = "主要主题"
		L["Range - Main Theme - Tooltip"] = "设置整体UI主题。\n\n默认值：白昼。\n\n" .. addon.Theme.Settings.Tooltip_Text_Note_Highlight .. "动态" .. addon.Theme.Settings.Tooltip_Text_Note .. "选项会根据游戏内的昼夜循环来设置主要主题。|r"
		L["Range - Main Theme - Day"] = "白昼"
		L["Range - Main Theme - Night"] = "暗夜"
		L["Range - Main Theme - Dynamic"] = "动态"
		L["Range - Dialog Theme"] = "对话主题"
		L["Range - Dialog Theme - Tooltip"] = "设置NPC对话界面的主题。\n\n默认值：匹配。\n\n" .. addon.Theme.Settings.Tooltip_Text_Note_Highlight .. "匹配" .. addon.Theme.Settings.Tooltip_Text_Note .. "选项会将对话主题设置为与主要主题一致。|r"
		L["Range - Dialog Theme - Auto"] = "匹配"
		L["Range - Dialog Theme - Day"] = "白昼"
		L["Range - Dialog Theme - Night"] = "暗夜"
		L["Range - Dialog Theme - Rustic"] = "古朴"
		L["Title - Appearance"] = "外观设置"
		L["Range - UIDirection"] = "UI方向"
		L["Range - UIDirection - Tooltip"] = "设置UI方向。"
		L["Range - UIDirection - Left"] = "左侧"
		L["Range - UIDirection - Right"] = "右侧"
		L["Range - UIDirection / Dialog"] = "固定对话位置"
		L["Range - UIDirection / Dialog - Tooltip"] = "设置固定对话位置。\n\n当NPC的姓名板不可用时，将使用固定对话位置。"
		L["Range - UIDirection / Dialog - Top"] = "顶部"
		L["Range - UIDirection / Dialog - Center"] = "中部"
		L["Range - UIDirection / Dialog - Bottom"] = "底部"
		L["Checkbox - UIDirection / Dialog / Mirror"] = "镜像"
		L["Checkbox - UIDirection / Dialog / Mirror - Tooltip"] = "镜像UI方向。"
		L["Range - Quest Frame Size"] = "任务框架大小"
		L["Range - Quest Frame Size - Tooltip"] = "调整任务框架大小。\n\n默认值：中型。"
		L["Range - Quest Frame Size - Small"] = "小型"
		L["Range - Quest Frame Size - Medium"] = "中型"
		L["Range - Quest Frame Size - Large"] = "大型"
		L["Range - Quest Frame Size - Extra Large"] = "超大型"
		L["Range - Text Size"] = "文本大小"
		L["Range - Text Size - Tooltip"] = "调整文本的大小。"
		L["Title - Dialog"] = "对话"
		L["Checkbox - Dialog / Title / Progress Bar"] = "显示对话进度条"
		L["Checkbox - Dialog / Title / Progress Bar - Tooltip"] = "显示或隐藏对话进度条。\n\n此进度条用于指示当前对话的进行进度。\n\n默认值：开启。"
		L["Range - Dialog / Title / Text Alpha"] = "对话标题透明度"
		L["Range - Dialog / Title / Text Alpha - Tooltip"] = "设置对话标题的透明度。\n\n默认值：50%。"
		L["Range - Dialog / Content Preview Alpha"] = "对话内容预览透明度"
		L["Range - Dialog / Content Preview Alpha - Tooltip"] = "设置对话文本预览的透明度。\n\n默认值：50%。"
		L["Title - Gossip"] = "闲聊"
		L["Checkbox - Always Show Gossip Frame"] = "始终显示闲聊框架"
		L["Checkbox - Always Show Gossip Frame - Tooltip"] = "有闲聊框架时始终显示，而不是仅在开始对话后显示。\n\n默认值：开启。"
		L["Title - Quest"] = "任务"
		L["Checkbox - Always Show Quest Frame"] = "始终显示任务框架"
		L["Checkbox - Always Show Quest Frame - Tooltip"] = "有可用任务框架时始终显示，而不是仅在开始对话后显示。\n\n默认值：开启。"

		-- VIEWPORT
		L["Title - Effects"] = "特效"
		L["Checkbox - Hide UI"] = "隐藏用户界面"
		L["Checkbox - Hide UI - Tooltip"] = "在与NPC交互时隐藏用户界面。\n\n默认值：开启。"
		L["Range - Cinematic"] = "镜头特效"
		L["Range - Cinematic - Tooltip"] = "交互期间的镜头特效。\n\n默认值：完整。"
		L["Range - Cinematic - None"] = "无"
		L["Range - Cinematic - Full"] = "完整"
		L["Range - Cinematic - Balanced"] = "平衡"
		L["Range - Cinematic - Custom"] = "自定义"
		L["Checkbox - Zoom"] = "缩放"
		L["Range - Zoom / Min Distance"] = "最小距离"
		L["Range - Zoom / Min Distance - Tooltip"] = "如果当前缩放距离低于此阈值，镜头将缩放到此级别。"
		L["Range - Zoom / Max Distance"] = "最大距离"
		L["Range - Zoom / Max Distance - Tooltip"] = "如果当前缩放距离高于此阈值，镜头将缩放到此级别。"
		L["Checkbox - Zoom / Pitch"] = "调整垂直角度"
		L["Checkbox - Zoom / Pitch - Tooltip"] = "启用镜头垂直角度调整。"
		L["Range - Zoom / Pitch / Level"] = "最大角度"
		L["Range - Zoom / Pitch / Level - Tooltip"] = "垂直角度阈值。"
		L["Checkbox - Zoom / Field Of View"] = "调整视野范围"
		L["Checkbox - Pan"] = "平移"
		L["Range - Pan / Speed"] = "平移速度"
		L["Range - Pan / Speed - Tooltip"] = "最大平移速度。"
		L["Checkbox - Dynamic Camera"] = "动态镜头"
		L["Checkbox - Dynamic Camera - Tooltip"] = "启用动态镜头设置。"
		L["Checkbox - Dynamic Camera / Side View"] = "侧视图"
		L["Checkbox - Dynamic Camera / Side View - Tooltip"] = "调整镜头以获得侧视图。"
		L["Range - Dynamic Camera / Side View / Strength"] = "强度"
		L["Range - Dynamic Camera / Side View / Strength - Tooltip"] = "值越高，侧向移动越大。"
		L["Checkbox - Dynamic Camera / Offset"] = "偏移"
		L["Checkbox - Dynamic Camera / Offset - Tooltip"] = "将视野从角色处偏移。"
		L["Range - Dynamic Camera / Offset / Strength"] = "强度"
		L["Range - Dynamic Camera / Offset / Strength - Tooltip"] = "值越高，偏移越大。"
		L["Checkbox - Dynamic Camera / Focus"] = "焦点"
		L["Checkbox - Dynamic Camera / Focus - Tooltip"] = "将视野聚焦到目标上。"
		L["Range - Dynamic Camera / Focus / Strength"] = "强度"
		L["Range - Dynamic Camera / Focus / Strength - Tooltip"] = "值越高，聚焦强度越大。"
		L["Checkbox - Dynamic Camera / Focus / X"] = "忽略X轴"
		L["Checkbox - Dynamic Camera / Focus / X - Tooltip"] = "防止X轴聚焦。"
		L["Checkbox - Dynamic Camera / Focus / Y"] = "忽略Y轴"
		L["Checkbox - Dynamic Camera / Focus / Y - Tooltip"] = "防止Y轴聚焦。"
		L["Checkbox - Vignette"] = "渐晕效果"
		L["Checkbox - Vignette - Tooltip"] = "降低边缘亮度。"
		L["Checkbox - Vignette / Gradient"] = "渐变"
		L["Checkbox - Vignette / Gradient - Tooltip"] = "降低闲聊和任务界面元素背后的亮度。"

		-- PLAYBACK
		L["Title - Pace"] = "节奏"
		L["Range - Playback Speed"] = "播放速度"
		L["Range - Playback Speed - Tooltip"] = "文本播放速度。\n\n默认值：100%。"
		L["Checkbox - Dynamic Playback"] = "动态播放"
		L["Checkbox - Dynamic Playback - Tooltip"] = "在对话中添加标点符号停顿。\n\n默认值：开启。"
		L["Title - Auto Progress"] = "自动推进"
		L["Checkbox - Auto Progress"] = "启用"
		L["Checkbox - Auto Progress - Tooltip"] = "自动推进到下一个对话。\n\n默认值：开启。"
		L["Checkbox - Auto Close Dialog"] = "自动关闭"
		L["Checkbox - Auto Close Dialog - Tooltip"] = "当没有可用选项时，停止与NPC的交互。\n\n默认值：开启。"
		L["Range - Auto Progress / Delay"] = "延迟"
		L["Range - Auto Progress / Delay - Tooltip"] = "进入下一个对话前的延迟时间。\n\n默认值：1。"
		L["Title - Text To Speech"] = "文本转语音"
		L["Checkbox - Text To Speech"] = "启用"
		L["Checkbox - Text To Speech - Tooltip"] = "朗读对话文本。\n\n默认值：关闭。"
		L["Title - Text To Speech / Playback"] = "播放设置"
		L["Checkbox - Text To Speech / Quest"] = "播放任务对话"
		L["Checkbox - Text To Speech / Quest - Tooltip"] = "在任务对话中启用文本转语音功能。\n\n默认值：开启。"
		L["Checkbox - Text To Speech / Gossip"] = "播放闲聊对话"
		L["Checkbox - Text To Speech / Gossip - Tooltip"] = "在闲聊对话中启用文本转语音功能。\n\n默认值：开启。"
		L["Range - Text To Speech / Rate"] = "语速"
		L["Range - Text To Speech / Rate - Tooltip"] = "设置语音语速。\n\n默认值：100%。"
		L["Range - Text To Speech / Volume"] = "语音音量"
		L["Range - Text To Speech / Volume - Tooltip"] = "语音播放音量。\n\n默认值：100%。"
		L["Title - Text To Speech / Voice"] = "语音"
		L["Dropdown - Text To Speech / Voice / Neutral"] = "中性"
		L["Dropdown - Text To Speech / Voice / Neutral - Tooltip"] = "用于无性别区分的NPC。"
		L["Dropdown - Text To Speech / Voice / Male"] = "男性"
		L["Dropdown - Text To Speech / Voice / Male - Tooltip"] = "用于男性NPC。"
		L["Dropdown - Text To Speech / Voice / Female"] = "女性"
		L["Dropdown - Text To Speech / Voice / Female - Tooltip"] = "用于女性NPC。"
		L["Dropdown - Text To Speech / Voice / Emote"] = "表情"
		L["Dropdown - Text To Speech / Voice / Emote - Tooltip"] = "用于 '<>' 中的对话。"
		L["Checkbox - Text To Speech / Player / Voice"] = "玩家语音"
		L["Checkbox - Text To Speech / Player / Voice - Tooltip"] = "选择对话选项时播放文本转语音。\n\n默认值：开启。"
		L["Dropdown - Text To Speech / Player / Voice / Voice"] = "语音"
		L["Dropdown - Text To Speech / Player / Voice / Voice - Tooltip"] = "对话选项的语音。"
		L["Title - More"] = "更多"
		L["Checkbox - Mute Dialog"] = "静音NPC对话"
		L["Checkbox - Mute Dialog - Tooltip"] = "在与NPC交互期间静音暴雪的NPC对话音频。\n\n默认值：关闭。"

		-- CONTROLS
		L["Title - UI"] = "用户界面"
		L["Checkbox - UI / Control Guide"] = "显示控制指南"
		L["Checkbox - UI / Control Guide - Tooltip"] = "显示控制指南框架。\n\n默认值：开启。"
		L["Title - Platform"] = "平台"
		L["Range - Platform"] = "平台"
		L["Range - Platform - Tooltip"] = "需要重载界面才能生效。"
		L["Range - Platform - PC"] = "PC"
		L["Range - Platform - Playstation"] = "Playstation"
		L["Range - Platform - Xbox"] = "Xbox"
		L["Title - PC"] = "PC"
		L["Title - PC / Keyboard"] = "键盘"
		L["Checkbox - PC / Keyboard / Use Interact Key"] = "使用交互键"
		L["Checkbox - PC / Keyboard / Use Interact Key - Tooltip"] = "使用交互键进行操作。不支持多键组合。\n\n默认值：关闭。"
		L["Title - PC / Mouse"] = "鼠标"
		L["Checkbox - PC / Mouse / Flip Mouse Controls"] = "反转鼠标控制"
		L["Checkbox - PC / Mouse / Flip Mouse Controls - Tooltip"] = "反转鼠标左右控制。\n\n默认值：关闭。"
		L["Title - PC / Keybind"] = "按键绑定"
		L["Keybind - PC / Keybind / Previous"] = "上一个"
		L["Keybind - PC / Keybind / Previous - Tooltip"] = "上一个对话的按键绑定。\n\n默认值：Q。"
		L["Keybind - PC / Keybind / Next"] = "下一个"
		L["Keybind - PC / Keybind / Next - Tooltip"] = "下一个对话的按键绑定。\n\n默认值：E。"
		L["Keybind - PC / Keybind / Progress"] = "推进"
		L["Keybind - PC / Keybind / Progress - Tooltip"] = "按键绑定用于：\n- 跳过\n- 接受\n- 继续\n- 完成\n\n默认值：空格键。"
		L["Keybind - PC / Keybind / Progress - Tooltip / Conflict"] = addon.Theme.Settings.Tooltip_Text_Warning_Highlight .. "使用交互键" .. addon.Theme.Settings.Tooltip_Text_Warning .. "选项必须禁用才能调整此按键绑定。|r"
		L["Keybind - PC / Keybind / Quest Next Reward"] = "下一个奖励"
		L["Keybind - PC / Keybind / Quest Next Reward - Tooltip"] = "选择下一个任务奖励的按键绑定。\n\n默认值：Tab键。"
		L["Keybind - PC / Keybind / Close"] = "关闭"
		L["Keybind - PC / Keybind / Close - Tooltip"] = "用于关闭当前活动交互窗口的按键绑定。\n\n默认值：Esc键。"
		L["Title - Controller"] = "游戏手柄"
		L["Title - Controller / Controller"] = "游戏手柄"

		-- GAMEPLAY
		L["Title - Waypoint"] = "超炫路径点"
		L["Checkbox - Waypoint"] = "启用"
		L["Checkbox - Waypoint - Tooltip"] = "使用超炫路径点替代暴雪的游戏内导航功能。\n\n默认值：开启。"
		L["Checkbox - Waypoint / Audio"] = "路径点音效"
		L["Checkbox - Waypoint / Audio - Tooltip"] = "路径点状态改变时的音效。\n\n默认值：开启。"
		L["Title - Readable"] = "可阅读物品"
		L["Checkbox - Readable"] = "启用"
		L["Checkbox - Readable - Tooltip"] = "为可阅读物品（信件等）启用自定义界面 - 以及用于存储它们的库。\n\n默认值：开启。"
		L["Title - Readable / Display"] = "显示设置"
		L["Checkbox - Readable / Display / Always Show Item"] = "始终显示物品"
		L["Checkbox - Readable / Display / Always Show Item - Tooltip"] = "当离开游戏内物品的交互距离时，防止可阅读物品交互界面关闭。\n\n默认值：关闭。"
		L["Title - Readable / Viewport"] = "视野"
		L["Checkbox - Readable / Viewport"] = "使用视野特效"
		L["Checkbox - Readable / Viewport - Tooltip"] = "启动可阅读物品界面时的视野特效。\n\n默认值：开启。"
		L["Title - Readable / Shortcuts"] = "快捷方式"
		L["Checkbox - Readable / Shortcuts / Minimap Icon"] = "小地图图标"
		L["Checkbox - Readable / Shortcuts / Minimap Icon - Tooltip"] = "在小地图上显示一个图标，以便快速访问图书馆。\n\n默认值：开启。"
		L["Title - Readable / Audiobook"] = "有声读物"
		L["Range - Readable / Audiobook - Rate"] = "语速"
		L["Range - Readable / Audiobook - Rate - Tooltip"] = "朗读的语速。\n\n默认值：100%。"
		L["Range - Readable / Audiobook - Volume"] = "音量"
		L["Range - Readable / Audiobook - Volume - Tooltip"] = "朗读音量。\n\n默认值：100%。"
		L["Dropdown - Readable / Audiobook - Voice"] = "旁白"
		L["Dropdown - Readable / Audiobook - Voice - Tooltip"] = "播放旁边语音。"
		L["Dropdown - Readable / Audiobook - Special Voice"] = "次要旁白"
		L["Dropdown - Readable / Audiobook - Special Voice - Tooltip"] = "用于特殊段落（如 '<>' 内的段落）的播放语音。"
		L["Title - Gameplay"] = "游戏玩法"
		L["Checkbox - Gameplay / Auto Select Option"] = "自动选择选项"
		L["Checkbox - Gameplay / Auto Select Option - Tooltip"] = "为某些NPC选择最佳选项。\n\n默认值：关闭。"

		-- MORE
		L["Title - Audio"] = "音频"
		L["Checkbox - Audio"] = "启用音频"
		L["Checkbox - Audio - Tooltip"] = "启用音效和音频。\n\n默认值：开启。"
		L["Title - Settings"] = "设置"
		L["Checkbox - Settings / Reset Settings"] = "重置所有设置"
		L["Checkbox - Settings / Reset Settings - Tooltip"] = "将所有设置项重置为默认值。\n\n默认值：关闭。"

		L["Title - Credits"] = "鸣谢"
		L["Title - Credits / ZamestoTV"] = "ZamestoTV | 翻译者 - 俄语"
		L["Title - Credits / ZamestoTV - Tooltip"] = "特别感谢 ZamestoTV 提供的俄语翻译！"
		L["Title - Credits / AKArenan"] = "AKArenan | 翻译者 - 巴西葡萄牙语"
		L["Title - Credits / AKArenan - Tooltip"] = "特别感谢 AKArenan 提供的巴西葡萄牙语翻译！"
		L["Title - Credits / El1as1989"] = "El1as1989 | 翻译者 - 西班牙语"
		L["Title - Credits / El1as1989 - Tooltip"] = "特别感谢 El1as1989 提供的西班牙语翻译！"
		L["Title - Credits / huchang47"] = "huchang47 | 翻译者 - 简体中文"
		L["Title - Credits / huchang47 - Tooltip"] = "特别感谢 huchang47 提供的简体中文翻译！"
		L["Title - Credits / muiqo"] = "Muiqo | 翻译者 - 德语"
		L["Title - Credits / muiqo - Tooltip"] = "特别感谢 muiqo 提供的德语翻译！"
		L["Title - Credits / Crazyyoungs"] = "Crazyyoungs | 翻译者 - 韩语"
		L["Title - Credits / Crazyyoungs - Tooltip"] = "特别感谢 Crazyyoungs 提供的韩语翻译！"
		L["Title - Credits / fang2hou"] = "fang2hou | Translator - Chinese (Traditional)"
		L["Title - Credits / fang2hou - Tooltip"] = "Special thanks to fang2hou for the Chinese (Traditional) translations!"
		L["Title - Credits / joaoc_pires"] = "Joao Pires | 编码者 - 修复Bug"
		L["Title - Credits / joaoc_pires - Tooltip"] = "特别感谢 Joao Pires 修复的Bug！"
	end

	--------------------------------
	-- READABLE UI
	--------------------------------

	do
		do -- LIBRARY
			-- PROMPTS
			L["Readable - Library - Prompt - Delete - Local"] = "这将从你的角色图书馆中永久移除该条目。"
			L["Readable - Library - Prompt - Delete - Global"] = "这将从你的战团图书馆中永久移除该条目。"
			L["Readable - Library - Prompt - Delete Button 1"] = "移除"
			L["Readable - Library - Prompt - Delete Button 2"] = "取消"

			L["Readable - Library - Prompt - Import - Local"] = "导入保存状态将覆盖你的角色图书馆。"
			L["Readable - Library - Prompt - Import - Global"] = "导入保存状态将覆盖你的战团图书馆。"
			L["Readable - Library - Prompt - Import Button 1"] = "导入并重载"
			L["Readable - Library - Prompt - Import Button 2"] = "取消"

			L["Readable - Library - TextPrompt - Import - Local"] = "导入到角色图书馆"
			L["Readable - Library - TextPrompt - Import - Global"] = "导入到战团图书馆"
			L["Readable - Library - TextPrompt - Import Input Placeholder"] = "输入数据文本"
			L["Readable - Library - TextPrompt - Import Button 1"] = "导入"

			L["Readable - Library - TextPrompt - Export - Local"] = "将玩家数据复制到剪贴板"
			L["Readable - Library - TextPrompt - Export - Global"] = "将战团数据复制到剪贴板 "
			L["Readable - Library - TextPrompt - Export Input Placeholder"] = "无效的导出代码"

			-- SIDEBAR
			L["Readable - Library - Search Input Placeholder"] = "搜索"
			L["Readable - Library - Export Button"] = "导出"
			L["Readable - Library - Import Button"] = "导入"
			L["Readable - Library - Show"] = "显示"
			L["Readable - Library - Letters"] = "信件"
			L["Readable - Library - Books"] = "书籍"
			L["Readable - Library - Slates"] = "石板"
			L["Readable - Library - Show only World"] = "仅世界时显示"

			-- TITLE
			L["Readable - Library - Name Text - Global"] = "战团图书馆"
			L["Readable - Library - Name Text - Local - Subtext 1"] = ""
			L["Readable - Library - Name Text - Local - Subtext 2"] = "的图书馆"
			L["Readable - Library - Showing Status Text - Subtext 1"] = "显示 "
			L["Readable - Library - Showing Status Text - Subtext 2"] = " 条目"

			-- CONTENT
			L["Readable - Library - No Results Text - Subtext 1"] = "未找到 "
			L["Readable - Library - No Results Text - Subtext 2"] = "。"
			L["Readable - Library - Empty Library Text"] = "无条目。"
		end

		do -- READABLE
			-- NOTIFICATIONS
			L["Readable - Notification - Saved To Library"] = "已保存到图书馆"

			-- TOOLTIP
			L["Readable - Tooltip - Change Page"] = "滚动翻页。"
		end
	end

	--------------------------------
	-- AUDIOBOOK
	--------------------------------

	do
		L["Audiobook - Action Tooltip"] = addon.API.Util:InlineIcon(addon.Variables.PATH_ART .. "Icons/mouse-left.png", 16, 16, 0, 0) .. " 拖动。\n" .. addon.API.Util:InlineIcon(addon.Variables.PATH_ART .. "Icons/mouse-right.png", 16, 16, 0, 0) .. " 关闭。"
	end

	--------------------------------
	-- INTERACTION QUEST FRAME
	--------------------------------

	do
		L["InteractionFrame.QuestFrame - Objectives"] = "任务目标"
		L["InteractionFrame.QuestFrame - Rewards"] = "奖励"
		L["InteractionFrame.QuestFrame - Required Items"] = "所需物品"

		L["InteractionFrame.QuestFrame - Accept - Quest Log Full"] = "任务日志已满"
		L["InteractionFrame.QuestFrame - Accept - Auto Accept"] = "已自动接受"
		L["InteractionFrame.QuestFrame - Accept"] = "接受"
		L["InteractionFrame.QuestFrame - Decline"] = "拒绝"
		L["InteractionFrame.QuestFrame - Goodbye"] = "再见"
		L["InteractionFrame.QuestFrame - Goodbye - Auto Accept"] = "了解"
		L["InteractionFrame.QuestFrame - Continue"] = "继续"
		L["InteractionFrame.QuestFrame - In Progress"] = "进行中"
		L["InteractionFrame.QuestFrame - Complete"] = "完成"
	end

	--------------------------------
	-- INTERACTION DIALOG FRAME
	--------------------------------

	do
		L["InteractionFrame.DialogFrame - Skip"] = "跳过"
	end

	--------------------------------
	-- INTERACTION GOSSIP FRAME
	--------------------------------

	do
		L["InteractionFrame.GossipFrame - Close"] = "再见"
	end

	--------------------------------
	-- INTERACTION CONTROL GUIDE
	--------------------------------

	do
		L["ControlGuide - Back"] = "返回"
		L["ControlGuide - Next"] = "下一步"
		L["ControlGuide - Skip"] = "跳过"
		L["ControlGuide - Accept"] = "接受"
		L["ControlGuide - Continue"] = "继续"
		L["ControlGuide - Complete"] = "完成"
		L["ControlGuide - Decline"] = "拒绝"
		L["ControlGuide - Goodbye"] = "再见"
		L["ControlGuide - Got it"] = "了解"
		L["ControlGuide - Gossip Option Interact"] = "选择选项"
		L["ControlGuide - Quest Next Reward"] = "下一个奖励"
	end

	--------------------------------
	-- ALERT NOTIFICATION
	--------------------------------

	do
		L["Alert Notification - Accept"] = "任务已接受"
		L["Alert Notification - Complete"] = "任务已完成"
	end

	--------------------------------
	-- WAYPOINT
	--------------------------------

	do
		L["Waypoint - Ready for Turn-in"] = "可交付任务"

		L["Waypoint - Waypoint"] = "路径点"
		L["Waypoint - Quest"] = "任务"
		L["Waypoint - Flight Point"] = "飞行点"
		L["Waypoint - Pin"] = "标记点"
		L["Waypoint - Party Member"] = "队伍成员"
		L["Waypoint - Content"] = "内容"
	end

	--------------------------------
	-- PLAYER STATUS BAR
	--------------------------------

	do
		L["PlayerStatusBar - TooltipLine1"] = "当前经验值: "
		L["PlayerStatusBar - TooltipLine2"] = "剩余经验值: "
		L["PlayerStatusBar - TooltipLine3"] = "等级 "
	end

	--------------------------------
	-- MINIMAP ICON
	--------------------------------

	do
		L["MinimapIcon - Tooltip - Title"] = "超炫交互图书馆"
		L["MinimapIcon - Tooltip - Entries - Subtext 1"] = ""
		L["MinimapIcon - Tooltip - Entries - Subtext 2"] = " 条目"
		L["MinimapIcon - Tooltip - Entries - Singular - Subtext 1"] = ""
		L["MinimapIcon - Tooltip - Entries - Singular - Subtext 2"] = " 条目"
		L["MinimapIcon - Tooltip - Entries - Empty"] = "无条目。"
	end

	--------------------------------
	-- BLIZZARD SETTINGS
	--------------------------------

	do
		L["BlizzardSettings - Title"] = "打开设置"
		L["BlizzardSettings - Shortcut - Controller"] = "在所有超炫交互界面上应用。"
	end

	--------------------------------
	-- ALERTS
	--------------------------------

	do
		L["Alert - Under Attack"] = "正在战斗中"
		L["Alert - Open Settings"] = "打开设置。"
	end

	--------------------------------
	-- DIALOG DATA
	--------------------------------

	do
		-- 在动态播放中用于暂停的字符
		L["DialogData - PauseCharDB"] = {
			"……",
			"！",
			"？",
			"。",
			"，",
			"；",
			"、",
		}

		-- 对话播放速度的修正值，用于匹配该语言基础文本转语音（TTS）的大致速度。数值越高，速度越快。
		L["DialogData - PlaybackSpeedModifier"] = 2
	end

	--------------------------------
	-- GOSSIP DATA
	--------------------------------

	do
		-- 需要匹配暴雪的特殊闲聊选项前缀文本。
		L["GossipData - Trigger - Quest"] = "%(Quest%)"
		L["GossipData - Trigger - Movie 1"] = "%(Play%)"
		L["GossipData - Trigger - Movie 2"] = "%(Play Movie%)"
		L["GossipData - Trigger - NPC Dialog"] = "%<Stay awhile and listen.%>"
		L["GossipData - Trigger - NPC Dialog - Append"] = "勇士请听我说"
	end

	--------------------------------
	-- AUDIOBOOK DATA
	--------------------------------

	do
		-- 每秒估计字符数，大致匹配该语言基础文本转语音（TTS）的速度。数值越高，速度越快。
		-- 这是暴雪文本转语音（TTS）的一种变通方法，因为它有时无法继续到下一行，所以我们需要在一段时间后手动重新启动它。
		L["AudiobookData - EstimatedCharPerSecond"] = 1
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
			L["SupportedAddons - BtWQuests - Tooltip - Call to Action"] = addon.Theme.RGB_ORANGE_HEXCODE .. "点击以在 BtWQuests 中打开任务链" .. "|r"
		end
	end
end

Load()
