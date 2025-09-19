-- [!] [addon.Interaction.Dialog] is a custom frame to display quest/gossip text in a chat-bubble format.
-- [Dialog_Script.lua] is the back-end (logic & behavior)
-- for [Dialog_Elements.lua].

---@class addon
local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local PrefabRegistry = addon.PrefabRegistry
local L = addon.Locales
local NS = addon.Interaction.Dialog; addon.Interaction.Dialog = NS

--------------------------------

NS.Script = {}

--------------------------------

local GetTitleForQuestID = C_QuestLog.GetTitleForQuestID or C_QuestLog.GetQuestInfo

--------------------------------

function NS.Script:Load()
	--------------------------------
	-- REFERENCES
	--------------------------------

	local Frame = InteractionFrame.DialogFrame
	local Callback = NS.Script; NS.Script = Callback

	--------------------------------
	-- FUNCTIONS (FRAME)
	--------------------------------

	do
		do -- UPDATE
			function Frame:UpdateAll()
				Frame:UpdateLayout()
				Frame:UpdatePosition()
				Frame:UpdateStyle()
			end

			function Frame:UpdateLayout()
				CallbackRegistry:Trigger("UpdateDynamicTextSize Dialog.Content.Text")
				CallbackRegistry:Trigger("LayoutGroupSort Dialog.Title")
			end

			function Frame:UpdatePosition()
				if not Frame.hidden then
					local NAMEPLATE = C_NamePlate.GetNamePlateForUnit("npc")
					local NAMEPLATE_PLAYER = C_NamePlate.GetNamePlateForUnit("player")

					--------------------------------

					do -- STATE
						local isValidNameplate = (NAMEPLATE and NAMEPLATE ~= NAMEPLATE_PLAYER and (not UnitIsGameObject("npc") and not UnitIsGameObject("questnpc")))

						--------------------------------

						if isValidNameplate then
							Frame.REF_BACKGROUND_DIALOG_TAIL:Show()

							--------------------------------

							Frame:ClearAllPoints()
							Frame:SetPoint("BOTTOM", NAMEPLATE, 0, 35)

							--------------------------------

							Frame:SetFrameStrata(NS.Variables.FRAME_STRATA)
						else
							Frame.REF_BACKGROUND_DIALOG_TAIL:Hide()

							--------------------------------

							-- UI Direction
							-- 1 -> LEFT
							-- 2 -> RIGHT

							-- Dialog Direction:
							-- 1 -> TOP
							-- 2 -> CENTER
							-- 3 -> BOTTOM

							local uiDirection = addon.Database.DB_GLOBAL.profile.INT_UIDIRECTION
							local dialogDirection = addon.Database.DB_GLOBAL.profile.INT_UIDIRECTION_DIALOG
							local mirrorQuest = addon.Database.DB_GLOBAL.profile.INT_UIDIRECTION_DIALOG_MIRROR

							local screenWidth = addon.API.Main:GetScreenWidth()
							local screenHeight = addon.API.Main:GetScreenHeight()
							local questWidth = InteractionFrame.QuestFrame:GetWidth() + 50 -- Padding
							local questHeight = InteractionFrame.QuestFrame:GetHeight() + 50 -- Padding
							local dialogWidth = NS.Variables.FRAME_MAX_WIDTH + 25
							local dialogHeight = InteractionFrame.DialogFrame:GetHeight()

							local dialogMaxWidth = NS.Variables.FRAME_MAX_WIDTH
							local quarterWidth = (screenWidth - dialogMaxWidth) / 2
							local quarterEdgePadding = (quarterWidth - questWidth) / 2

							local offsetX = 0
							local offsetY = (screenHeight - questHeight) / 2

							if mirrorQuest then
								local offset = (screenWidth - questWidth - quarterEdgePadding) + (dialogWidth / 2)

								if uiDirection == 1 then
									offsetX = -(screenWidth / 2) + offset
								else
									offsetX = (screenWidth / 2) - offset
								end
							end

							Frame:ClearAllPoints()
							if dialogDirection == 1 then
								Frame:SetPoint("TOP", UIParent, offsetX, -offsetY)
							elseif dialogDirection == 2 then
								Frame:SetPoint("CENTER", UIParent, offsetX, 0)
							elseif dialogDirection == 3 then
								Frame:SetPoint("BOTTOM", UIParent, offsetX, offsetY)
							end

							--------------------------------

							Frame:SetFrameStrata(NS.Variables.FRAME_STRATA_MAX)
						end
					end
				end
			end
		end

		do -- STYLE
			function Frame:Style_MatchScrollCriteria()
				local targetIsGameObject = (UnitIsGameObject("npc") or UnitIsGameObject("questnpc"))
				local targetIsSelf = ((UnitName("npc") == UnitName("player")) or UnitName("questnpc") == UnitName("player"))
				local targetIsItem = (addon.API.Util:FindItemInInventory(UnitName("npc") or "Empty Result") or addon.API.Util:FindItemInInventory(UnitName("questnpc") or "Empty Result"))

				--------------------------------

				if targetIsGameObject or targetIsSelf or targetIsItem then
					return true
				else
					return false
				end
			end

			function Frame:UpdateStyle()
				local info = NS.Variables.info
				local interactTargetNameplate = ((C_NamePlate.GetNamePlateForUnit("npc") or C_NamePlate.GetNamePlateForUnit("questnpc")))
				local interactTargetIsSelf = ((UnitName("npc") == UnitName("player")) or UnitName("questnpc") == UnitName("player"))

				--------------------------------

				if info.contentInfo.full then
					if info.contentInfo.emoteIndexes[NS.Variables.Playback_Index] then NS.Variables.Style_IsEmote = true else NS.Variables.Style_IsEmote = false end
					NS.Variables.Style_IsScroll = Frame:Style_MatchScrollCriteria()
					NS.Variables.Style_IsRustic = addon.Theme.IsRusticTheme_Dialog
					NS.Variables.Style_IsDialog = not NS.Variables.Style_IsEmote and not NS.Variables.Style_IsScroll and not NS.Variables.Style_IsRustic

					--------------------------------

					if NS.Variables.Style_IsEmote then
						Frame:Style_SetToEmote()
					elseif NS.Variables.Style_IsScroll then
						Frame:Style_SetToScroll()
					elseif NS.Variables.Style_IsRustic then
						Frame:Style_SetToRustic()
					elseif NS.Variables.Style_IsDialog then
						Frame:Style_SetToDialog(interactTargetNameplate and not interactTargetIsSelf)
					end
				end
			end

			function Frame:Style_SetToDialog(showTail)
				NS.Variables.Playback_Freeze = false

				--------------------------------

				Frame.REF_BACKGROUND_DIALOG:Show(); Frame.REF_BACKGROUND_DIALOG_TAIL:SetShown(showTail)
				Frame.REF_BACKGROUND_SCROLL:Hide()
				Frame.REF_BACKGROUND_RUSTIC:Hide()
				Frame.REF_BACKGROUND_EMOTE:Hide()

				Frame.REF_CONTENT_TEXT:SetJustifyH("CENTER")
				if addon.Theme.IsDarkTheme_Dialog then
					Frame.REF_CONTENT_TEXT:SetTextColor(1, 1, 1)
				else
					Frame.REF_CONTENT_TEXT:SetTextColor(1, .87, .67)
				end
			end

			function Frame:Style_SetToScroll()
				NS.Variables.Playback_Freeze = false

				--------------------------------

				Frame.REF_BACKGROUND_DIALOG:Hide()
				Frame.REF_BACKGROUND_SCROLL:Show()
				Frame.REF_BACKGROUND_RUSTIC:Hide()
				Frame.REF_BACKGROUND_EMOTE:Hide()

				Frame.REF_CONTENT_TEXT:SetJustifyH("CENTER")
				if (addon.Theme.IsDarkTheme_Dialog or addon.Theme.IsRusticTheme_Dialog) then
					Frame.REF_CONTENT_TEXT:SetTextColor(1, 1, 1)
				else
					Frame.REF_CONTENT_TEXT:SetTextColor(.1, .1, .1)
				end

				--------------------------------

				Frame.REF_BACKGROUND_SCROLL:ShowWithAnimation()
			end

			function Frame:Style_SetToRustic()
				NS.Variables.Playback_Freeze = false

				--------------------------------

				Frame.REF_BACKGROUND_DIALOG:Hide()
				Frame.REF_BACKGROUND_SCROLL:Hide()
				Frame.REF_BACKGROUND_RUSTIC:Hide()
				Frame.REF_BACKGROUND_EMOTE:Show()

				Frame.REF_CONTENT_TEXT:SetJustifyH("CENTER")
				Frame.REF_CONTENT_TEXT:SetTextColor(1, .87, .67)
			end

			function Frame:Style_SetToEmote()
				NS.Variables.Playback_Freeze = true

				--------------------------------

				Frame.REF_BACKGROUND_DIALOG:Hide()
				Frame.REF_BACKGROUND_SCROLL:Hide()
				Frame.REF_BACKGROUND_RUSTIC:Hide()
				Frame.REF_BACKGROUND_EMOTE:Show()

				Frame.REF_CONTENT_TEXT:SetJustifyH("CENTER")
				Frame.REF_CONTENT_TEXT:SetTextColor(.93, .52, .31)
			end
		end
	end

	--------------------------------
	-- FUNCTIONS (LOGIC)
	--------------------------------

	do
		do -- GET
			local function SplitString(string, pattern)
				local start, iterator = 1, string.gmatch(string, "()(" .. pattern .. ")")

				--------------------------------

				local function GetNextSegment(segments, separators, separator, capture1, ...)
					start = separator and separators + #separator
					return string.sub(string, segments, separators or -1), capture1 or separator, ...
				end

				--------------------------------

				return function()
					if start then
						return GetNextSegment(start, iterator())
					end
				end
			end

			local function SplitText(string)
				if not string then
					return
				end

				--------------------------------

				local separatorPattern = "[\\.|>|<|!|?|\n]%s+"
				string = string:gsub(" %s+", " "):gsub("|cffFFFFFF", ""):gsub("|r", "")
				string = string:gsub("%.%.%.", "...")

				--------------------------------

				local lines = {}
				local lineIndex = 1

				for segment in SplitString(string, separatorPattern) do
					if segment ~= nil and segment ~= "" then
						lines[lineIndex] = segment
						lineIndex = lineIndex + 1
					end
				end

				--------------------------------

				return lines
			end

			local function RemoveAngledBrackets(str)
				if str then
					return str:gsub("[<>]", "")
				else
					return str
				end
			end

			function Callback:GetNPCInfo()
				local npcInfo = {
					["name"] = UnitName("npc") or UnitName("questnpc"),
					["guid"] = UnitGUID("npc") or UnitGUID("questnpc")
				}

				return npcInfo
			end

			function Callback:GetContextIcon()
				local contextIcon = addon.ContextIcon:GetContextIcon() or ""
				return contextIcon
			end

			function Callback:GetTitle(frameType)
				local text_title = nil

				--------------------------------

				if frameType == "quest-reward" or frameType == "quest-progress" or frameType == "quest-detail" then
					local text = GetTitleForQuestID(GetQuestID())
					text_title = text
				elseif frameType == "gossip" or frameType == "quest-greeting" then
					local text = UnitName("npc")
					text_title = text
				end

				--------------------------------

				return text_title
			end

			function Callback:GetContent(frameType)
				local contentInfo = {
					["full"] = nil,
					["split"] = nil,
					["formatted"] = nil,
				}

				--------------------------------

				local TEXT_REWARD = GetRewardText()
				local TEXT_PROGRESS = GetProgressText()
				local TEXT_GREETING = GetGreetingText()
				local TEXT_QUEST = GetQuestText()
				local TEXT_GOSSIP = C_GossipInfo.GetText()

				local text_full =
					frameType == "quest-reward" and TEXT_REWARD or
					frameType == "quest-progress" and TEXT_PROGRESS or
					frameType == "gossip" and TEXT_GOSSIP or
					frameType == "quest-greeting" and TEXT_GREETING or
					frameType == "quest-detail" and TEXT_QUEST

				local text_split =
					frameType == "quest-reward" and SplitText(TEXT_REWARD) or
					frameType == "quest-progress" and SplitText(TEXT_PROGRESS) or
					frameType == "gossip" and SplitText(TEXT_GOSSIP) or
					frameType == "quest-greeting" and SplitText(TEXT_GREETING) or
					frameType == "quest-detail" and SplitText(TEXT_QUEST)

				local text_formatted = {}
				if text_split then
					for i = 1, #text_split do
						local formatted = {
							["skipAnimation"] = false,
							["text"] = RemoveAngledBrackets(text_split[i]),
						}

						--------------------------------

						formatted.text = formatted.text:gsub("%.%.%.", "…")
						if string.find(formatted.text, "|cFFFF0000") then
							formatted.skipAnimation = true
						end

						--------------------------------

						table.insert(text_formatted, formatted)
					end
				end

				contentInfo["full"] = text_full
				contentInfo["split"] = text_split
				contentInfo["formatted"] = text_formatted

				--------------------------------

				return contentInfo
			end

			function Callback:GetEmoteIndexes(splitText)
				local results = {}

				--------------------------------

				local isInEmote = nil
				local skipNextLineEmote = nil
				for line = 1, #splitText do
					local currentLine = splitText[line]
					local isSameLineEmote = false

					--------------------------------

					if skipNextLineEmote then
						isInEmote = false
						skipNextLineEmote = nil
					end

					if addon.API.Util:FindString(currentLine, "<") then
						isInEmote = true
					end

					if addon.API.Util:FindString(currentLine, ">") then
						isInEmote = true
						skipNextLineEmote = true
					end

					if addon.API.Util:FindString(currentLine, "<") and addon.API.Util:FindString(currentLine, ">") then
						isSameLineEmote = true
					end

					--------------------------------

					if isInEmote or isSameLineEmote then
						results[line] = true
					end
				end

				--------------------------------

				return results
			end
		end

		do -- SET
			function Callback:SetInfo(frameType)
				local npcInfo = Callback:GetNPCInfo()
				local contextIcon = Callback:GetContextIcon()
				local title = Callback:GetTitle(frameType)
				local contentInfo = Callback:GetContent(frameType)
				local emoteIndexes = Callback:GetEmoteIndexes(contentInfo.split)

				NS.Variables.info.type = frameType
				NS.Variables.info.npcInfo.name = npcInfo.name
				NS.Variables.info.npcInfo.guid = npcInfo.guid
				NS.Variables.info.contextIcon = contextIcon
				NS.Variables.info.title = title
				NS.Variables.info.contentInfo.full = contentInfo.full
				NS.Variables.info.contentInfo.split = contentInfo.split
				NS.Variables.info.contentInfo.formatted = contentInfo.formatted
				NS.Variables.info.contentInfo.emoteIndexes = emoteIndexes
			end

			function Callback:SetLineToIndex(index, skipAnimation, preventAutoProgress)
				local info = NS.Variables.info

				--------------------------------

				NS.Variables.Playback_Index = index
				if skipAnimation or preventAutoProgress then NS.Variables.Playback_AutoProgress = false else NS.Variables.Playback_AutoProgress = addon.Database.DB_GLOBAL.profile.INT_PLAYBACK_AUTOPROGRESS end
				if info.contentInfo.formatted[index].skipAnimation then skipAnimation = true end

				--------------------------------

				do -- STYLE
					Frame:UpdateStyle()
				end

				do -- SET
					local isAlwaysShowQuest = addon.Database.DB_GLOBAL.profile.INT_ALWAYS_SHOW_QUEST
					local isQuestVisible = (QuestFrame:IsVisible() and not QuestFrameGreetingPanel:IsVisible())
					local isQuestType = (info.type == "quest-reward" or info.type == "quest-progress" or info.type == "quest-detail")

					--------------------------------

					do -- TITLE TEXT
						if isAlwaysShowQuest and isQuestVisible and isQuestType then
							Frame.REF_TITLE_PREFIXFRAME:Hide()
							Frame.REF_TITLE_TITLEFRAME_TEXT:SetText(info.contextIcon .. " " .. (info.npcInfo.name or ""))
						elseif isQuestType then
							Frame.REF_TITLE_PREFIXFRAME:Show()
							Frame.REF_TITLE_PREFIXFRAME_TEXT:SetText(info.npcInfo.name or "")
							Frame.REF_TITLE_TITLEFRAME_TEXT:SetText(info.contextIcon .. " " .. (info.title or ""))
						else
							Frame.REF_TITLE_PREFIXFRAME:Hide()
							Frame.REF_TITLE_TITLEFRAME_TEXT:SetText(info.contextIcon .. " " .. (info.title or ""))
						end
					end

					do -- TITLE PROGRESS
						Frame.REF_TITLE_PROGRESS_BAR:SetMinMaxValues(0, #info.contentInfo.split)
						addon.API.Animation:SetProgressTo(Frame.REF_TITLE_PROGRESS_BAR, index, .25, addon.API.Animation.EaseExpo)
					end

					do -- CONTENT TEXT
						Frame.REF_CONTENT_TEXT:SetText(info.contentInfo.formatted[index].text)
					end
				end

				do -- ANIMATION
					Frame:Animation_New()

					--------------------------------

					if skipAnimation then
						Frame:Animation_Text_Stop()
					else
						local interval = .05 / (addon.Database.DB_GLOBAL.profile.INT_PLAYBACK_SPEED * L["DialogData - PlaybackSpeedModifier"])
						local pauseText = addon.Database.DB_GLOBAL.profile.INT_PLAYBACK_PUNCTUATION_PAUSING

						--------------------------------

						Frame:Animation_Text_Start(interval, pauseText)
					end
				end

				do -- TTS
					local playQuest = addon.Database.DB_GLOBAL.profile.INT_TTS_QUEST
					local playGossip = addon.Database.DB_GLOBAL.profile.INT_TTS_GOSSIP
					local gender = UnitSex("npc")
					local voice =
						NS.Variables.Style_IsEmote and addon.Database.DB_GLOBAL.profile.INT_TTS_EMOTE_VOICE or
						gender == 3 and addon.Database.DB_GLOBAL.profile.INT_TTS_VOICE_02 or
						gender == 2 and addon.Database.DB_GLOBAL.profile.INT_TTS_VOICE_01 or
						gender == 1 and addon.Database.DB_GLOBAL.profile.INT_TTS_VOICE

					--------------------------------

					if not playQuest and (info.type == "quest-detail" or info.type == "quest-reward" or info.type == "quest-progress") then
						addon.TextToSpeech.Script:StopSpeakingText()
						return
					end

					if not playGossip and (info.type == "gossip" or info.type == "quest-greeting") then
						addon.TextToSpeech.Script:StopSpeakingText()
						return
					end

					--------------------------------

					addon.TextToSpeech.Script:PlayConfiguredTTS(voice, info.contentInfo.formatted[index].text)
				end

				--------------------------------

				Frame:UpdateAll()

				--------------------------------

				CallbackRegistry:Trigger("UPDATE_DIALOG")
			end
		end

		do -- STATE
			function Callback:IncrementIndex(preventAutoProgress)
				if addon.Interaction.Gossip.Variables.RefreshInProgress then
					return
				end

				--------------------------------

				if NS.Variables.Playback_Index < #NS.Variables.info.contentInfo.split then
					NS.Variables.Playback_Index = NS.Variables.Playback_Index + 1

					--------------------------------

					if not NS.Variables.Style_IsEmote then
						addon.SoundEffects:PlaySoundFile(addon.SoundEffects.Dialog_Next)
					end

					--------------------------------

					Callback:SetLineToIndex(NS.Variables.Playback_Index, false, preventAutoProgress)

					--------------------------------

					CallbackRegistry:Trigger("Dialog.IncrementIndex")
				else
					do -- Auto close
						local isAutoClose = addon.Database.DB_GLOBAL.profile.INT_PLAYBACK_AUTOCLOSE
						local isGossip = (InteractionFrame.GossipFrame:IsVisible())

						if isAutoClose and isGossip then
							local numButtons = #InteractionFrame.GossipFrame:GetButtons()

							--------------------------------

							if numButtons == 0 then
								addon.Interaction.Script:Stop(true)

								--------------------------------

								CallbackRegistry:Trigger("Dialog.AutoIncrement.AutoClose")
							end
						end
					end

					Callback:Stop()

					--------------------------------

					CallbackRegistry:Trigger("Dialog.IncrementIndex.Finished")
				end
			end

			function Callback:DecrementIndex(preventAutoProgress)
				if addon.Interaction.Gossip.Variables.RefreshInProgress then
					return
				end

				--------------------------------

				if NS.Variables.Playback_Finished then
					Callback:Restart()
				elseif not NS.Variables.Finished and (NS.Variables.Playback_Index > 1) then
					NS.Variables.Playback_Index = NS.Variables.Playback_Index - 1

					--------------------------------

					if not NS.Variables.Style_IsEmote then
						addon.SoundEffects:PlaySoundFile(addon.SoundEffects.Dialog_Previous)
					end

					--------------------------------

					Callback:SetLineToIndex(NS.Variables.Playback_Index, true, preventAutoProgress)

					--------------------------------

					CallbackRegistry:Trigger("Dialog.DecrementIndex")
				else
					Frame:Animation_Invalid()

					--------------------------------

					if not NS.Variables.Style_IsEmote then
						addon.SoundEffects:PlaySoundFile(addon.SoundEffects.Dialog_Invalid)
					end

					--------------------------------

					Callback:SetLineToIndex(NS.Variables.Playback_Index, true, preventAutoProgress)

					--------------------------------

					CallbackRegistry:Trigger("Dialog.DecrementIndex.Invalid")
				end
			end

			function Callback:AutoIncrement()
				local isAutoClose = addon.Database.DB_GLOBAL.profile.INT_PLAYBACK_AUTOCLOSE
				local isDialog = (Frame:IsVisible())
				local isGossip = (InteractionFrame.GossipFrame:IsVisible())

				--------------------------------

				if isDialog then
					if NS.Variables.Playback_Index < #NS.Variables.info.contentInfo.split then
						Callback:IncrementIndex(false)
					else
						if isAutoClose and isGossip then
							local numButtons = #InteractionFrame.GossipFrame:GetButtons()

							--------------------------------

							if numButtons == 0 then
								addon.Interaction.Script:Stop(true)

								--------------------------------

								CallbackRegistry:Trigger("Dialog.AutoIncrement.AutoClose")
							else
								Callback:Stop()
							end
						else
							Callback:Stop()
						end
					end
				end

				--------------------------------

				CallbackRegistry:Trigger("Dialog.AutoIncrement")
			end

			function Callback:Restart()
				Callback:Start(NS.Variables.Playback_Index, true)

				--------------------------------

				CallbackRegistry:Trigger("RESTART_DIALOG")
			end

			function Callback:Start(index, skipAnimation)
				NS.Variables.Playback_Finished = false
				addon.TextToSpeech.Script:StopSpeakingText()

				--------------------------------

				Callback:SetLineToIndex(index, skipAnimation, false)
				Frame:ShowWithAnimation()

				--------------------------------

				CallbackRegistry:Trigger("START_DIALOG")
			end

			function Callback:Stop()
				NS.Variables.Playback_Finished = true
				addon.TextToSpeech.Script:StopSpeakingText()
				Frame:Animation_Text_Stop()

				--------------------------------

				Frame:HideWithAnimation()

				--------------------------------

				CallbackRegistry:Trigger("STOP_DIALOG")
			end

			function Callback:Init(frameType)
				Callback:SetInfo(frameType)

				--------------------------------

				local info = NS.Variables.info

				--------------------------------

				NS.Variables.Playback_Valid = nil
				NS.Variables.Playback_Index = 1
				NS.Variables.Playback_Freeze = false
				NS.Variables.Playback_AutoProgress = true
				NS.Variables.Playback_Finished = false

				NS.Variables.Style_IsDialog = false
				NS.Variables.Style_IsScroll = false
				NS.Variables.Style_IsRustic = false
				NS.Variables.Style_IsEmote = false

				if #info.contentInfo.split >= 1 and #info.contentInfo.split[1] > 1 then
					NS.Variables.Playback_Valid = true

					--------------------------------

					Callback:Start(1)
				else
					NS.Variables.Playback_Valid = false
				end

				--------------------------------

				CallbackRegistry:Trigger("INIT_DIALOG")
			end
		end

		do -- AUTO PROGRESS PROCESSING
			local AutoProgress = {}
			AutoProgress.Timer = nil

			--------------------------------

			do -- FUNCTIONS
				function AutoProgress:Init()
					local isValid = addon.Database.DB_GLOBAL.profile.INT_PLAYBACK_AUTOPROGRESS and NS.Variables.Playback_AutoProgress
					local autoProgressDelay = addon.Database.DB_GLOBAL.profile.INT_PLAYBACK_AUTOPROGRESS_DELAY

					--------------------------------

					if isValid then
						AutoProgress:Cancel()
						AutoProgress.Timer = C_Timer.NewTimer(autoProgressDelay, Callback.AutoIncrement)
					end
				end

				function AutoProgress:Cancel()
					if AutoProgress.Timer then
						AutoProgress.Timer:Cancel()
					end
				end
			end

			do -- EVENTS
				CallbackRegistry:Add("Dialog.Animation_Text_OnUpdate.Finished", AutoProgress.Init, 0)
				CallbackRegistry:Add("Dialog.IncrementIndex", AutoProgress.Cancel, 0)
				CallbackRegistry:Add("Dialog.DecrementIndex", AutoProgress.Cancel, 0)
				CallbackRegistry:Add("START_DIALOG", AutoProgress.Cancel, 0)
				CallbackRegistry:Add("STOP_DIALOG", AutoProgress.Cancel, 0)
			end
		end
	end

	--------------------------------
	-- FUNCTIONS (ANIMATION)
	--------------------------------

	do
		do -- TEXT
			local session = {}
			local _ = CreateFrame("Frame")

			local function ResetSession()
				session = {
					["text"] = "",
					["elapsed"] = 0,
					["interval"] = 0,
					["pause"] = {
						["enabled"] = false,
						["duration"] = 0,
						["active"] = false,
						["elapsed"] = 0,
						["database"] = nil
					}
				}
			end

			local function GetTextColor()
				local color
				local textColor

				local contentPreviewAlpha = addon.Database.DB_GLOBAL.profile.INT_CONTENT_PREVIEW_ALPHA
				local isDarkThemeDialog = addon.Theme.IsDarkTheme_Dialog
				local isRusticThemeDialog = addon.Theme.IsRusticTheme_Dialog
				local isDialogStyle = NS.Variables.Style_IsDialog
				local isScrollStyle = NS.Variables.Style_IsScroll
				local isRusticStyle = NS.Variables.Style_IsRustic
				local isEmoteStyle = NS.Variables.Style_IsEmote

				--------------------------------

				do -- TEXT COLOR
					if (isDarkThemeDialog or isRusticThemeDialog) and (isScrollStyle) then
						textColor = { r = 1, g = 1, b = 1 }
					elseif (isDarkThemeDialog or isRusticThemeDialog) then
						if isRusticThemeDialog then
							textColor = addon.Theme.RGB_CHAT_MSG_SAY
						elseif isDarkThemeDialog then
							textColor = { r = 1, g = 1, b = 1 }
						end
					elseif not (isDarkThemeDialog or isRusticThemeDialog) and (isScrollStyle) then
						textColor = { r = .1, g = .1, b = .1 }
					elseif not (isDarkThemeDialog or isRusticThemeDialog) then
						if isRusticThemeDialog then
							textColor = addon.Theme.RGB_CHAT_MSG_SAY
						elseif not isDarkThemeDialog then
							textColor = addon.Theme.RGB_CHAT_MSG_SAY
						end
					end
				end

				do -- COLOR
					if contentPreviewAlpha <= .1 then
						if (isDarkThemeDialog or isRusticThemeDialog) and (isScrollStyle) then
							color = Frame.isMouseOver and "101010" or "101010"
						elseif (isDarkThemeDialog or isRusticThemeDialog) then
							if isRusticThemeDialog then
								color = "101010"
							elseif isDarkThemeDialog then
								color = Frame.isMouseOver and "0D0A0B" or "070504"
							end
						elseif not (isDarkThemeDialog or isRusticThemeDialog) and (isScrollStyle) then
							color = "CEAA82"
						elseif not (isDarkThemeDialog or isRusticThemeDialog) then
							if isRusticThemeDialog then
								color = "101010"
							elseif not isDarkThemeDialog then
								color = Frame.isMouseOver and "232323" or "191919"
							end
						end
					else
						local modifier = .2 + (addon.Database.DB_GLOBAL.profile.INT_CONTENT_PREVIEW_ALPHA / 1.25)
						if not (isDarkThemeDialog or isRusticThemeDialog) and (isScrollStyle) then
							color = addon.API.Util:SetHexColorFromModifierWithBase(addon.API.Util:GetHexColor(textColor.r, textColor.g, textColor.b), modifier, "CEAA82")
						else
							color = addon.API.Util:SetHexColorFromModifier(addon.API.Util:GetHexColor(textColor.r, textColor.g, textColor.b), modifier)
						end
					end
				end

				--------------------------------

				return color
			end

			function Frame:Animation_Text_Start(interval, pauseText)
				ResetSession()
				session.text = Frame.REF_CONTENT_TEXT:GetText() or ""
				session.interval = interval
				session.pause.enabled = pauseText
				session.pause.duration = .125
				session.pause.database = L["DialogData - PauseCharDB"]

				--------------------------------

				_:SetScript("OnUpdate", Frame.Animation_Text_OnUpdate)
			end

			function Frame:Animation_Text_Stop()
				ResetSession()

				--------------------------------

				_:SetScript("OnUpdate", nil)
			end

			function Frame:Animation_Text_OnUpdate(elapsed)
				if session.pause.enabled and session.pause.active then
					session.pause.elapsed = session.pause.elapsed + elapsed

					--------------------------------

					if session.pause.elapsed >= session.pause.duration then
						session.pause.active = false
						session.pause.elapsed = 0
					else
						return
					end
				end

				--------------------------------

				session.elapsed = session.elapsed + elapsed

				--------------------------------

				local numCharsToShow = math.min(math.floor(session.elapsed / session.interval) + 1, strlenutf8(session.text))
				local text_current = addon.API.Util:GetSubstring(session.text, 1, numCharsToShow)
				local text_remaining = addon.API.Util:GetSubstring(session.text, numCharsToShow + 1, strlenutf8(session.text))
				local text_new = ""
				local preview_color = GetTextColor()

				--------------------------------

				do -- PAUSE
					if session.pause.enabled then
						local lastChar = addon.API.Util:GetSubstring(session.text, numCharsToShow, numCharsToShow)

						--------------------------------

						for char = 1, #session.pause.database do
							if addon.API.Util:FindString(session.pause.database[char], lastChar) then
								session.pause.active = true
								break
							end
						end
					end
				end

				--------------------------------

				if strlenutf8(text_remaining) > 0 and not NS.Variables.Playback_Freeze then
					text_new = text_current .. "|cff" .. preview_color .. text_remaining .. "|r"
				else
					text_new = text_current .. text_remaining
				end

				Frame.REF_CONTENT_TEXT:SetText(text_new)

				--------------------------------

				if numCharsToShow >= strlenutf8(session.text) then
					Frame:Animation_Text_Stop()
					CallbackRegistry:Trigger("Dialog.Animation_Text_OnUpdate.Finished")
				end
			end
		end

		do -- FRAME
			local isTransition
			local savedDialogText

			--------------------------------

			do -- BACKGROUND
				do -- SHOW
					function Frame.REF_BACKGROUND_SCROLL:ShowWithAnimation_StopEvent()
						return not Frame.REF_BACKGROUND_SCROLL:IsVisible()
					end

					function Frame.REF_BACKGROUND_SCROLL:ShowWithAnimation()
						Frame.REF_BACKGROUND_SCROLL:Show()

						addon.API.Animation:Scale(Frame.REF_BACKGROUND_SCROLL, .5, .75, 1, nil, nil, Frame.REF_BACKGROUND_SCROLL.ShowWithAnimation_StopEvent)
					end
				end
			end

			do -- NEW DIALOG
				function Frame:Animation_New_StopEvent()
					return NS.Variables.info.contentInfo.split[NS.Variables.Playback_Index] ~= savedDialogText
				end

				function Frame:Animation_New()
					if isTransition then
						return
					end

					--------------------------------

					if savedDialogText == NS.Variables.info.contentInfo.split[NS.Variables.Playback_Index] then
						return
					end
					savedDialogText = NS.Variables.info.contentInfo.split[NS.Variables.Playback_Index]

					--------------------------------

					addon.API.Animation:Fade(Frame, .25, 0, 1, nil, Frame.Animation_New_StopEvent)
					addon.API.Animation:Fade(Frame.REF_CONTENT, .5, 0, 1, nil, Frame.Animation_New_StopEvent)
					if NS.Variables.Style_IsDialog then addon.API.Animation:Scale(Frame.REF_BACKGROUND_DIALOG, .75, .75, 1, nil, addon.API.Animation.EaseExpo, Frame.Animation_New_StopEvent) end
				end
			end

			do -- INVALID DIALOG
				function Frame:Animation_Invalid()
					if (NS.Variables.Style_IsDialog or NS.Variables.Style_IsScroll) and not (NS.Variables.Style_IsEmote) then addon.API.Animation:Scale(Frame.REF_CLIP, 1, .95, 1) end
					if NS.Variables.Style_IsDialog then addon.API.Animation:Scale(Frame.REF_BACKGROUND_DIALOG, 1, .95, 1) end
					if NS.Variables.Style_IsScroll then addon.API.Animation:Scale(Frame.REF_BACKGROUND_SCROLL, 1, .95, 1) end
				end
			end

			do -- SHOW
				function Frame:ShowWithAnimation_StopEvent()
					return Frame.hidden
				end

				function Frame:ShowWithAnimation()
					Frame.hidden = false

					--------------------------------

					Frame:Show()

					--------------------------------

					isTransition = true
					savedDialogText = NS.Variables.info.contentInfo.split[NS.Variables.Playback_Index]
					addon.Libraries.AceTimer:ScheduleTimer(function()
						if not Frame.hidden then
							isTransition = false
						end
					end, .25)

					--------------------------------

					if not Frame.hidden then
						addon.API.Animation:Fade(Frame, .25, 0, 1, nil, Frame.ShowWithAnimation_StopEvent)
						addon.API.Animation:Fade(Frame.REF_TITLE, .25, 0, 1, nil, Frame.ShowWithAnimation_StopEvent)
						addon.API.Animation:Fade(Frame.REF_TITLE_PREFIXFRAME, .5, 0, addon.Database.DB_GLOBAL.profile.INT_TITLE_ALPHA, nil, Frame.ShowWithAnimation_StopEvent)
						addon.API.Animation:Fade(Frame.REF_TITLE_PREFIXFRAME_TEXT, .5, 0, Frame.REF_TITLE_PREFIXFRAME_TEXT.targetAlpha, nil, Frame.ShowWithAnimation_StopEvent)
						addon.API.Animation:Fade(Frame.REF_TITLE_TITLEFRAME, .5, 0, addon.Database.DB_GLOBAL.profile.INT_TITLE_ALPHA, nil, Frame.ShowWithAnimation_StopEvent)
						addon.API.Animation:Fade(Frame.REF_TITLE_TITLEFRAME_TEXT, .5, 0, 1, nil, Frame.ShowWithAnimation_StopEvent)
						addon.API.Animation:Fade(Frame.REF_CONTENT, .5, 0, 1, nil, Frame.ShowWithAnimation_StopEvent)
						if (NS.Variables.Style_IsDialog or NS.Variables.Style_IsScroll) and not (NS.Variables.Style_IsEmote) then addon.API.Animation:Scale(Frame.REF_CLIP, 1, .25, 1, nil, nil, Frame.ShowWithAnimation_StopEvent) end
						if NS.Variables.Style_IsDialog then addon.API.Animation:Scale(Frame.REF_BACKGROUND_DIALOG, 1, .25, 1, nil, nil, Frame.ShowWithAnimation_StopEvent) end
						if NS.Variables.Style_IsScroll then addon.API.Animation:Scale(Frame.REF_BACKGROUND_SCROLL, 1, .25, 1, nil, nil, Frame.ShowWithAnimation_StopEvent) end
					end
				end
			end

			do -- HIDE
				function Frame:HideWithAnimation_StopEvent()
					return not Frame.hidden
				end

				function Frame:HideWithAnimation(skipAnimation)
					if Frame.hidden then
						return
					end
					Frame.hidden = true

					if skipAnimation then
						Frame:Hide()
					else
						addon.Libraries.AceTimer:ScheduleTimer(function()
							if Frame.hidden then
								Frame:Hide()
							end
						end, .25)
					end

					--------------------------------

					if not skipAnimation then
						addon.API.Animation:Fade(Frame, .125, Frame:GetAlpha(), 0)
						if NS.Variables.Style_IsDialog then addon.API.Animation:Scale(Frame.REF_BACKGROUND_DIALOG, .25, Frame.REF_BACKGROUND_DIALOG:GetScale(), .925, nil, nil, Frame.HideWithAnimation_StopEvent) end
						if NS.Variables.Style_IsScroll then addon.API.Animation:Scale(Frame.REF_BACKGROUND_SCROLL, .25, Frame.REF_BACKGROUND_SCROLL:GetScale(), .925, nil, nil, Frame.HideWithAnimation_StopEvent) end
					end
				end
			end

			do -- ON ENTER
				function Frame:Animation_OnEnter_StopEvent()
					return not Frame.isMouseOver
				end

				function Frame:Animation_OnEnter(skipAnimation)
					if skipAnimation then
						if NS.Variables.Style_IsDialog then Frame.REF_BACKGROUND_DIALOG:SetAlpha(.75) end
						if NS.Variables.Style_IsDialog then Frame.REF_BACKGROUND_DIALOG_TAIL:SetAlpha(.75) end
						if NS.Variables.Style_IsScroll then Frame.REF_BACKGROUND_SCROLL:SetAlpha(.975) end
					else
						if NS.Variables.Style_IsDialog then addon.API.Animation:Fade(Frame.REF_BACKGROUND_DIALOG, .125, Frame.REF_BACKGROUND_DIALOG:GetAlpha(), .75, nil, Frame.Animation_OnEnter_StopEvent) end
						if NS.Variables.Style_IsDialog then addon.API.Animation:Fade(Frame.REF_BACKGROUND_DIALOG_TAIL, .125, Frame.REF_BACKGROUND_DIALOG_TAIL:GetAlpha(), .75, nil, Frame.Animation_OnEnter_StopEvent) end
						if NS.Variables.Style_IsScroll then addon.API.Animation:Fade(Frame.REF_BACKGROUND_SCROLL, .125, Frame.REF_BACKGROUND_SCROLL:GetAlpha(), .975, nil, Frame.Animation_OnEnter_StopEvent) end
					end
				end
			end

			do -- ON LEAVE
				function Frame:Animation_OnLeave_StopEvent()
					return Frame.isMouseOver
				end

				function Frame:Animation_OnLeave(skipAnimation)
					if skipAnimation then
						if NS.Variables.Style_IsDialog then Frame.REF_BACKGROUND_DIALOG:SetAlpha(1) end
						if NS.Variables.Style_IsDialog then Frame.REF_BACKGROUND_DIALOG_TAIL:SetAlpha(1) end
						if NS.Variables.Style_IsScroll then Frame.REF_BACKGROUND_SCROLL:SetAlpha(1) end
					else
						if NS.Variables.Style_IsDialog then addon.API.Animation:Fade(Frame.REF_BACKGROUND_DIALOG, .125, Frame.REF_BACKGROUND_DIALOG:GetAlpha(), 1, nil, Frame.Animation_OnLeave_StopEvent) end
						if NS.Variables.Style_IsDialog then addon.API.Animation:Fade(Frame.REF_BACKGROUND_DIALOG_TAIL, .125, Frame.REF_BACKGROUND_DIALOG_TAIL:GetAlpha(), 1, nil, Frame.Animation_OnLeave_StopEvent) end
						if NS.Variables.Style_IsScroll then addon.API.Animation:Fade(Frame.REF_BACKGROUND_SCROLL, .125, Frame.REF_BACKGROUND_SCROLL:GetAlpha(), 1, nil, Frame.Animation_OnLeave_StopEvent) end
					end
				end
			end

			do -- ON MOUSE DOWN
				function Frame:Animation_OnMouseDown_StopEvent()
					return not Frame.isMouseDown
				end

				function Frame:Animation_OnMouseDown(skipAnimation)

				end
			end

			do -- ON MOUSE UP
				function Frame:Animation_OnMouseUp_StopEvent()
					return Frame.isMouseDown
				end

				function Frame:Animation_OnMouseUp(skipAnimation)

				end
			end
		end
	end

	--------------------------------
	-- SETTINGS
	--------------------------------

	do
		local function Settings_ContentSize()
			addon.API.Util:SetFontSize(Frame.REF_CONTENT_TEXT, addon.Database.DB_GLOBAL.profile.INT_CONTENT_SIZE)

			--------------------------------

			Frame:UpdateAll()
		end
		Settings_ContentSize()

		local function Settings_TitleProgressVisibility()
			Frame.REF_TITLE_PROGRESS:SetShown(addon.Database.DB_GLOBAL.profile.INT_PROGRESS_SHOW)
			Frame.REF_TITLE_PROGRESS:SetAlpha(1)

			--------------------------------

			Frame:UpdateAll()
		end
		Settings_TitleProgressVisibility()

		local function Settings_TitleAlpha()
			Frame.REF_TITLE_PREFIXFRAME:SetAlpha(addon.Database.DB_GLOBAL.profile.INT_TITLE_ALPHA)
			Frame.REF_TITLE_TITLEFRAME:SetAlpha(addon.Database.DB_GLOBAL.profile.INT_TITLE_ALPHA)
		end
		Settings_TitleAlpha()

		local function Settings_ThemeUpdate()
			Frame:UpdateStyle()
		end
		Settings_ThemeUpdate()

		--------------------------------

		CallbackRegistry:Add("SETTINGS_CONTENT_SIZE_CHANGED", Settings_ContentSize, 0)
		CallbackRegistry:Add("SETTINGS_TITLE_PROGRESS_VISIBILITY_CHANGED", Settings_TitleProgressVisibility, 0)
		CallbackRegistry:Add("SETTINGS_TITLE_ALPHA_CHANGED", Settings_TitleAlpha, 0)
		CallbackRegistry:Add("THEME_UPDATE", Settings_ThemeUpdate, 0)
	end

	--------------------------------
	-- EVENTS
	--------------------------------

	do
		Frame.isMouseOver = false
		Frame.isMouseDown = false

		Frame.enterCallbacks = {}
		Frame.leaveCallbacks = {}
		Frame.mouseDownCallbacks = {}
		Frame.mouseUpCallbacks = {}

		--------------------------------

		do -- EVENTS
			local function Logic_OnEnter()

			end

			local function Logic_OnLeave()

			end

			local function Logic_OnMouseDown(button)

			end

			local function Logic_OnMouseUp(button)
				if addon.Database.DB_GLOBAL.profile.INT_FLIPMOUSE then
					if button == "LeftButton" then
						Callback:DecrementIndex(true)
					else
						Callback:IncrementIndex(true)
					end
				else
					if button == "LeftButton" then
						Callback:IncrementIndex(true)
					else
						Callback:DecrementIndex(true)
					end
				end
			end

			function Frame:OnEnter(skipAnimation)
				Frame.isMouseOver = true

				--------------------------------

				Frame:Animation_OnEnter(skipAnimation)
				Logic_OnEnter()

				--------------------------------

				do -- ON ENTER
					if #Frame.enterCallbacks >= 1 then
						local enterCallbacks = Frame.enterCallbacks

						for callback = 1, #enterCallbacks do
							enterCallbacks[callback](skipAnimation)
						end
					end
				end
			end

			function Frame:OnLeave(skipAnimation)
				Frame.isMouseOver = false

				--------------------------------

				Frame:Animation_OnLeave(skipAnimation)
				Logic_OnLeave()

				--------------------------------

				do -- ON LEAVE
					if #Frame.leaveCallbacks >= 1 then
						local leaveCallbacks = Frame.leaveCallbacks

						for callback = 1, #leaveCallbacks do
							leaveCallbacks[callback](skipAnimation)
						end
					end
				end
			end

			function Frame:OnMouseDown(button, skipAnimation)
				Frame.isMouseDown = true

				--------------------------------

				Frame:Animation_OnMouseDown(skipAnimation)
				Logic_OnMouseDown(button)

				--------------------------------

				do -- ON MOUSE DOWN
					if #Frame.mouseDownCallbacks >= 1 then
						local mouseDownCallbacks = Frame.mouseDownCallbacks

						for callback = 1, #mouseDownCallbacks do
							mouseDownCallbacks[callback](skipAnimation)
						end
					end
				end
			end

			function Frame:OnMouseUp(button, skipAnimation)
				Frame.isMouseDown = false

				--------------------------------

				Frame:Animation_OnMouseUp(skipAnimation)
				Logic_OnMouseUp(button)

				--------------------------------

				do -- ON MOUSE UP
					if #Frame.mouseUpCallbacks >= 1 then
						local mouseUpCallbacks = Frame.mouseUpCallbacks

						for callback = 1, #mouseUpCallbacks do
							mouseUpCallbacks[callback](skipAnimation)
						end
					end
				end
			end

			Frame.REF_MOUSE_RESPONDER:SetScript("OnEnter", function() Frame:OnEnter() end)
			Frame.REF_MOUSE_RESPONDER:SetScript("OnLeave", function() Frame:OnLeave() end)
			Frame.REF_MOUSE_RESPONDER:SetScript("OnMouseDown", function(_, button) Frame:OnMouseDown(button) end)
			Frame.REF_MOUSE_RESPONDER:SetScript("OnMouseUp", function(_, button) Frame:OnMouseUp(button) end)
		end

		Frame:SetScript("OnUpdate", function()
			Frame:UpdatePosition()
		end)

		local Events = CreateFrame("Frame")
		Events:RegisterEvent("GLOBAL_MOUSE_UP")
		Events:SetScript("OnEvent", function(self, event, ...)
			if event == "GLOBAL_MOUSE_UP" then
				if addon.Interaction.Variables.Active then
					local button = ...

					--------------------------------

					local targetName = UnitName("npc") or UnitName("questnpc")
					local mouseOverName = UnitName("mouseover")

					--------------------------------

					if tostring(targetName) == tostring(mouseOverName) then
						Frame:OnMouseUp(button, false)
					end
				end
			end
		end)
	end
end
