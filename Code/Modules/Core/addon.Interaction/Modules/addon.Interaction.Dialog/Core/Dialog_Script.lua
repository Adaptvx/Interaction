local addonName, addon = ...
local CallbackRegistry = addon.CallbackRegistry
local L = addon.Locales
local NS = addon.Interaction.Dialog

--------------------------------

NS.Script = {}

--------------------------------

function NS.Script:Load()
	--------------------------------
	-- REFERENCES
	--------------------------------

	local Frame = InteractionDialogFrame
	local Callback = NS.Script

	--------------------------------
	-- FUNCTIONS (FRAME)
	--------------------------------

	do
		Frame.UpdateSize = function()
			local limitWidth = 350
			Frame.Content.Label:SetWidth(limitWidth)
			Frame.Content.Measurement:SetWidth(limitWidth)
			local wrap = Frame.Content.Label:GetStringWidth() >= limitWidth and Frame.Content.Measurement:GetStringHeight() >= 25

			--------------------------------

			if wrap then
				Frame:SetWidth(limitWidth + 50)
				Frame.DialogBackground:SetWidth(Frame:GetWidth())
				Frame.Content.Label:SetWidth(limitWidth)
				Frame.Content.Measurement:SetWidth(limitWidth)
			else
				Frame:SetWidth(Frame.Content.Label:GetStringWidth() + 50)
				Frame.DialogBackground:SetWidth(Frame:GetWidth())
				Frame.Content.Label:SetWidth(Frame.Content.Label:GetStringWidth() + 200)
				Frame.Content.Measurement:SetWidth(Frame.Content.Label:GetStringWidth() + 200)
			end

			Frame.Content.Label:ClearAllPoints()
			Frame.Content.Label:SetPoint("CENTER", 0, -100)

			--------------------------------

			Frame:SetHeight(Frame.Content.Measurement:GetStringHeight() + 50)
			Frame.Content.Label:SetHeight(Frame.Content.Measurement:GetStringHeight() + 200)
			Frame.DialogBackground:SetHeight(Frame:GetHeight())
		end

		Frame.UpdateTitle = function()
			Frame.Title.Progress:SetWidth(Frame.Title.Label:GetStringWidth())
			Frame.Title.Progress.Bar:SetWidth(Frame.Title.Progress:GetWidth() - 5)

			--------------------------------

			if addon.Database.DB_GLOBAL.profile.INT_ALWAYS_SHOW_QUEST and (QuestFrame:IsVisible() and not QuestFrameGreetingPanel:IsVisible()) then
				Frame.Title.Label:Hide()
			else
				Frame.Title.Label:Show()
			end
		end

		Frame.UpdateStyle = function()
			local interactTargetNameplate = ((C_NamePlate.GetNamePlateForUnit("npc") or C_NamePlate.GetNamePlateForUnit("questnpc")))
			local interactTargetIsSelf = ((UnitName("npc") == UnitName("player")) or UnitName("questnpc") == UnitName("player"))

			--------------------------------

			if NS.Variables.Temp_IsEmoteDialog then
				--------------------------------
				-- TEXT PLAYBACK STATE
				--------------------------------

				Frame.Content.Label.freezePlayback = true

				--------------------------------
				-- BACKGROUND
				--------------------------------

				Frame.DialogBackgroundTexture:SetAlpha(0)
				Frame.DialogBackground.TailTexture:SetAlpha(0)

				--------------------------------
				-- TEXT
				--------------------------------

				Frame.Content.Label:SetJustifyH("CENTER")
				Frame.Content.Label:SetTextColor(.93, .52, .31)

				--------------------------------
				-- SCROLL
				--------------------------------

				Frame.ScrollBackground:Hide()

				--------------------------------
				-- BACKDROP
				--------------------------------

				Frame.RusticBackground:Show()
			elseif NS.Variables.Temp_IsScrollDialog then
				--------------------------------
				-- TEXT ANIMATION
				--------------------------------

				Frame.Content.Label.freezePlayback = false

				--------------------------------
				-- BACKGROUND
				--------------------------------

				Frame.DialogBackgroundTexture:SetAlpha(0)
				Frame.DialogBackground.TailTexture:SetAlpha(0)

				--------------------------------
				-- TEXT
				--------------------------------

				Frame.Content.Label:SetJustifyH("CENTER")

				if (addon.Theme.IsDarkTheme_Dialog or addon.Theme.IsRusticTheme_Dialog) then
					Frame.Content.Label:SetTextColor(1, 1, 1)
				else
					Frame.Content.Label:SetTextColor(.1, .1, .1)
				end

				--------------------------------
				-- SCROLL
				--------------------------------

				Frame.ScrollBackground.ShowWithAnimation()

				--------------------------------
				-- BACKDROP
				--------------------------------

				Frame.RusticBackground:Hide()
			elseif NS.Variables.Temp_IsStylisedDialog then
				--------------------------------
				-- TEXT PLAYBACK STATE
				--------------------------------

				Frame.Content.Label.freezePlayback = false

				--------------------------------
				-- BACKGROUND
				--------------------------------

				Frame.DialogBackgroundTexture:SetAlpha(0)
				Frame.DialogBackground.TailTexture:SetAlpha(0)

				--------------------------------
				-- TEXT
				--------------------------------

				Frame.Content.Label:SetJustifyH("CENTER")
				Frame.Content.Label:SetTextColor(1, .87, .67)

				--------------------------------
				-- SCROLL
				--------------------------------

				Frame.ScrollBackground:Hide()

				--------------------------------
				-- BACKDROP
				--------------------------------

				Frame.RusticBackground:Show()
			else
				--------------------------------
				-- TEXT ANIMATION
				--------------------------------

				Frame.Content.Label.freezePlayback = false

				--------------------------------
				-- BACKGROUND
				--------------------------------

				Frame.DialogBackgroundTexture:SetAlpha(1)
				Frame.DialogBackground.TailTexture:SetAlpha(1)

				if not interactTargetNameplate or interactTargetIsSelf then
					Frame.DialogBackground.Tail:SetAlpha(0)
				else
					if Frame.DialogBackground.Tail:GetAlpha() == 0 then
						Frame.DialogBackground.Tail:SetAlpha(1)
					end
				end

				--------------------------------
				-- TEXT
				--------------------------------

				Frame.Content.Label:SetJustifyH("CENTER")

				if addon.Theme.IsDarkTheme_Dialog then
					Frame.Content.Label:SetTextColor(1, 1, 1)
				else
					Frame.Content.Label:SetTextColor(1, .87, .67)
				end

				--------------------------------
				-- SCROLL
				--------------------------------

				Frame.ScrollBackground:Hide()

				--------------------------------
				-- BACKDROP
				--------------------------------

				Frame.RusticBackground:Hide()
			end
		end

		Frame.UpdateScrollDialog = function()
			local interactTargetIsGameObject = (UnitIsGameObject("npc") or UnitIsGameObject("questnpc"))
			local interactTargetIsSelf = ((UnitName("npc") == UnitName("player")) or UnitName("questnpc") == UnitName("player"))
			local isItem = (AdaptiveAPI:FindItemInInventory(UnitName("npc") or "Empty Result") or AdaptiveAPI:FindItemInInventory(UnitName("questnpc") or "Empty Result"))

			--------------------------------

			if interactTargetIsGameObject or interactTargetIsSelf or isItem then
				return true
			else
				return false
			end
		end
	end

	--------------------------------
	-- FUNCTIONS (LOGIC)
	--------------------------------

	do
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
			string = string:gsub("%.%.%.", "…")

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

		local function DoesCurrentIndexAppearIn(table)
			return (AdaptiveAPI:FindIndexInTableByValue(table, tostring(NS.Variables.Temp_CurrentIndex)))
		end

		function Callback:GetString()
			local rewardQuestText = GetRewardText()
			local progressQuestText = GetProgressText()
			local greetingQuestText = GetGreetingText()
			local infoQuestText = GetQuestText()
			local gossipText = C_GossipInfo.GetText()

			if NS.Variables.Temp_FrameType == "quest-reward" then
				NS.Variables.Temp_DialogStringList = SplitText(rewardQuestText)
			elseif NS.Variables.Temp_FrameType == "quest-progress" then
				NS.Variables.Temp_DialogStringList = SplitText(progressQuestText)
			elseif NS.Variables.Temp_FrameType == "gossip" then
				NS.Variables.Temp_DialogStringList = SplitText(gossipText)
			elseif NS.Variables.Temp_FrameType == "quest-greeting" then
				NS.Variables.Temp_DialogStringList = SplitText(greetingQuestText)
			elseif NS.Variables.Temp_FrameType == "quest-detail" then
				NS.Variables.Temp_DialogStringList = SplitText(infoQuestText)
			end
		end

		function Callback:UpdateString(animate)
			if not NS.Variables.Temp_DialogStringList[NS.Variables.Temp_CurrentIndex] then
				return
			end

			local callbackID = GetTime()

			--------------------------------

			local isGossip = (NS.Variables.Temp_FrameType == "gossip")
			local isQuestFrameGreeting = (NS.Variables.Temp_FrameType == "quest-greeting")
			local isQuestFrameProgress = (NS.Variables.Temp_FrameType == "quest-progress")
			local isQuestFrameDetail = (NS.Variables.Temp_FrameType == "quest-detail")

			--------------------------------

			CallbackRegistry:Trigger("UPDATE_DIALOG")

			addon.Libraries.AceTimer:ScheduleTimer(function()
				Frame.UpdateDialog()
			end, 0)

			--------------------------------

			do -- SET
				do -- TITLE
					NS.Variables.NPCName = nil
					NS.Variables.OptionIcon = nil
					NS.Variables.IsCompleted = nil
					NS.Variables.QuestTitleText = nil

					--------------------------------

					do                                                       -- GET
						do                                                   -- COMPLETED
							if addon.Variables.IS_CLASSIC then
								NS.Variables.IsCompleted = QuestFrameCompleteQuestButton:IsVisible() -- IsQuestComplete(GetQuestID())
							else
								NS.Variables.IsCompleted = QuestFrameCompleteQuestButton:IsVisible() -- C_QuestLog.IsComplete(GetQuestID())
							end
						end

						do -- NPC NAME
							if C_NamePlate.GetNamePlateForUnit("npc") == nil and UnitName("npc") then
								NS.Variables.NPCName = UnitName("npc")
							else
								NS.Variables.NPCName = ""
							end
						end

						do -- QUEST TITLE
							local infoTitle
							local progressTitle

							if not addon.Variables.IS_CLASSIC then
								infoTitle = QuestInfoTitleHeader
								progressTitle = QuestProgressTitleText
							else
								infoTitle = QuestInfoTitleHeader
								progressTitle = QuestProgressTitleText
							end

							if infoTitle:IsVisible() then
								NS.Variables.QuestTitleText = infoTitle:GetText()
							elseif progressTitle:IsVisible() then
								NS.Variables.QuestTitleText = progressTitle:GetText()
							else
								NS.Variables.QuestTitleText = ""
							end
						end

						do -- OPTION ICON
							NS.Variables.OptionIcon = addon.ContextIcon.Script:GetContextIcon() or "[Missing Icon]"
						end
					end

					do -- SET
						if isQuestFrameProgress then
							Frame.Title.Label:SetText(NS.Variables.OptionIcon .. " " .. "|cffFFFFFF" .. AdaptiveAPI:RemoveAtlasMarkup(QuestProgressTitleText:GetText()) .. "|r")
						elseif isGossip or isQuestFrameGreeting then
							local name = UnitName("npc") or UnitName("questnpc")

							--------------------------------

							if name then
								Frame.Title.Label:SetText(NS.Variables.OptionIcon .. " " .. name)
							else
								addon.Interaction.Script:Stop(true)
							end
						else
							Frame.Title.Label:SetText(NS.Variables.OptionIcon .. " " .. "|cffFFFFFF" .. AdaptiveAPI:RemoveAtlasMarkup(QuestInfoTitleHeader:GetText()) .. "|r")
						end
					end
				end

				do -- SPECIAL DIALOG
					local isEmoteStart = (AdaptiveAPI:FindString(NS.Variables.Temp_DialogStringList[NS.Variables.Temp_CurrentIndex], "<"))
					local isEmoteEnd = (AdaptiveAPI:FindString(NS.Variables.Temp_DialogStringList[NS.Variables.Temp_CurrentIndex], ">"))
					local isLastIndexEmoteEnd = (NS.Variables.Temp_CurrentIndex - 1 > 0 and AdaptiveAPI:FindString(NS.Variables.Temp_DialogStringList[NS.Variables.Temp_CurrentIndex - 1], ">"))

					--------------------------------

					if isEmoteStart then
						NS.Variables.Temp_Temp_IsEmoteDialog = true

						--------------------------------

						NS.Variables.Temp_CurrentString = RemoveAngledBrackets(NS.Variables.Temp_DialogStringList[NS.Variables.Temp_CurrentIndex])
					elseif isEmoteEnd then
						NS.Variables.Temp_CurrentString = RemoveAngledBrackets(NS.Variables.Temp_DialogStringList[NS.Variables.Temp_CurrentIndex])
					else
						NS.Variables.Temp_CurrentString = RemoveAngledBrackets(NS.Variables.Temp_DialogStringList[NS.Variables.Temp_CurrentIndex])
					end

					if isLastIndexEmoteEnd then
						NS.Variables.Temp_Temp_IsEmoteDialog = false
					end

					-- SAVE THIS INDEX AS SPECIAL DIALOG
					--------------------------------

					if NS.Variables.Temp_Temp_IsEmoteDialog and not DoesCurrentIndexAppearIn(NS.Variables.Temp_NotEmoteDialogIndexes) then
						table.insert(NS.Variables.Temp_IsEmoteDialogIndexes, tostring(NS.Variables.Temp_CurrentIndex))
					end

					if not NS.Variables.Temp_Temp_IsEmoteDialog and not DoesCurrentIndexAppearIn(NS.Variables.Temp_IsEmoteDialogIndexes) then
						table.insert(NS.Variables.Temp_NotEmoteDialogIndexes, tostring(NS.Variables.Temp_CurrentIndex))
					end

					-- SET SPECIAL DIALOG BASED ON INDEX --
					--------------------------------

					if DoesCurrentIndexAppearIn(NS.Variables.Temp_IsEmoteDialogIndexes) then
						NS.Variables.Temp_IsEmoteDialog = true
					elseif DoesCurrentIndexAppearIn(NS.Variables.Temp_NotEmoteDialogIndexes) then
						NS.Variables.Temp_IsEmoteDialog = false
					else
						NS.Variables.Temp_IsEmoteDialog = false
					end
				end

				do -- CONTENT
					Frame.Content.Measurement:SetText(NS.Variables.Temp_CurrentString)
					Frame.Content.Label:SetText(NS.Variables.Temp_CurrentString)
				end

				do -- PROGRESS BAR
					if #NS.Variables.Temp_DialogStringList > 1 then
						Frame.Title.Progress.Bar:SetMinMaxValues(0, #NS.Variables.Temp_DialogStringList)
						AdaptiveAPI.Animation:SetProgressTo(Frame.Title.Progress.Bar, NS.Variables.Temp_CurrentIndex, .25, AdaptiveAPI.Animation.EaseExpo)
						Frame.Title.Progress.Bar:SetAlpha(1)
					else
						Frame.Title.Progress.Bar:SetMinMaxValues(0, 1)
						Frame.Title.Progress.Bar:SetValue(1)
						Frame.Title.Progress.Bar:SetAlpha(.5)
					end
				end
			end

			do -- ANIMATION
				Frame.NewDialogAnimation(NS.Variables.Temp_IsEmoteDialog, NS.Variables.Temp_IsScrollDialog)

				--------------------------------

				if animate then
					do -- PLAY ANIMATION
						local skipAnimation = false
						local animationSpeed = .05 / (addon.Database.DB_GLOBAL.profile.INT_PLAYBACK_SPEED * L["DialogData - PlaybackSpeedModifier"])

						local autoPlayEnabled = addon.Database.DB_GLOBAL.profile.INT_PLAYBACK_AUTOPROGRESS
						local autoPlayDynamicPausingEnabled = addon.Database.DB_GLOBAL.profile.INT_PLAYBACK_PUNCTUATION_PAUSING
						local autoCloseEnabled = addon.Database.DB_GLOBAL.profile.INT_PLAYBACK_AUTOPROGRESS_AUTOCLOSE

						local autoPlayDelay = addon.Database.DB_GLOBAL.profile.INT_PLAYBACK_AUTOPROGRESS_DELAY

						--------------------------------

						Frame.StopTextPlayback(Frame.Content.Label)
						Frame.StartTextPlayback(Frame.Content.Label, animationSpeed, function()
							Callback:AutoProgress(callbackID, autoPlayEnabled, autoCloseEnabled)
						end, autoPlayDelay, skipAnimation, autoPlayDynamicPausingEnabled)
					end
				else
					Frame.StopTextPlayback(Frame.Content.Label)
				end
			end

			do -- TTS
				do -- READ CURRENT LINE
					local quest = addon.Database.DB_GLOBAL.profile.INT_TTS_QUEST
					local gossip = addon.Database.DB_GLOBAL.profile.INT_TTS_GOSSIP
					local voice = addon.Database.DB_GLOBAL.profile.INT_TTS_VOICE
					local gender = UnitSex("npc")

					--------------------------------

					if not quest and (addon.Interaction.Variables.Type == "quest-detail" or addon.Interaction.Variables.Type == "quest-reward" or addon.Interaction.Variables.Type == "quest-progress") then
						addon.TextToSpeech.Script:StopSpeakingText()
						return
					end

					if not gossip and (addon.Interaction.Variables.Type == "gossip" or addon.Interaction.Variables.Type == "quest-greeting") then
						addon.TextToSpeech.Script:StopSpeakingText()
						return
					end

					--------------------------------

					if gender == 2 then
						voice = addon.Database.DB_GLOBAL.profile.INT_TTS_VOICE_01
					elseif gender == 3 then
						voice = addon.Database.DB_GLOBAL.profile.INT_TTS_VOICE_02
					end
					if NS.Variables.Temp_IsEmoteDialog then
						voice = addon.Database.DB_GLOBAL.profile.INT_TTS_EMOTE_VOICE
					end

					--------------------------------

					addon.TextToSpeech.Script:PlayConfiguredTTS(voice, NS.Variables.Temp_CurrentString)
				end
			end
		end

		function Callback:AutoProgress(callbackID, autoPlayEnabled, autoCloseEnabled)
			local savedInteractionID = tostring(callbackID)
			local savedString = NS.Variables.Temp_CurrentString

			local isInDialog = (Frame:IsVisible())
			local isInGossip = (InteractionGossipFrame:IsVisible())
			local isSameID = (tostring(callbackID) == savedInteractionID)
			local isSameText = (Frame.Content.Label.currentText == savedString)

			--------------------------------

			if isInDialog and isSameID and isSameText then
				if autoPlayEnabled and NS.Variables.AllowAutoProgress then
					if NS.Variables.Temp_CurrentIndex < #NS.Variables.Temp_DialogStringList then
						NS.Variables.Temp_CurrentIndex = NS.Variables.Temp_CurrentIndex + 1

						--------------------------------

						Callback:UpdateString(true)

						--------------------------------

						if not NS.Variables.Temp_IsEmoteDialog then
							addon.SoundEffects:PlaySoundFile(addon.SoundEffects.Dialog_Next)
						end
					else
						if autoCloseEnabled and isInGossip then
							local numButtons = #InteractionGossipFrame.GetButtons()

							--------------------------------

							if numButtons == 0 then
								InteractionGossipFrame.HideWithAnimation()

								--------------------------------

								addon.Interaction.Script:Stop(true)
							else
								Frame.StopDialog()
							end
						else
							Frame.StopDialog()
						end
					end
				end
			end
		end

		--------------------------------

		Frame.PreventAutoPlay = function()
			NS.Variables.AllowAutoProgress = false
		end

		Frame.StopDialog = function()
			NS.Variables.Finished = true

			--------------------------------

			local interactTargetNameplate = ((C_NamePlate.GetNamePlateForUnit("npc") or C_NamePlate.GetNamePlateForUnit("questnpc")))

			--------------------------------

			if interactTargetNameplate then -- ANCHORED
				Frame.HideWithAnimation()
			else                   -- SCROLL DIALOG
				Frame.HideWithAnimation()
			end

			--------------------------------

			addon.TextToSpeech.Script:StopSpeakingText()

			--------------------------------

			CallbackRegistry:Trigger("STOP_DIALOG")
		end

		Frame.StartDialog = function(isReturnToPreviousDialog)
			NS.Variables.Finished = false

			--------------------------------

			if NS.Variables.Temp_FrameType == "gossip" then
				local gossipInteractMessage = select(1, select(1, GossipFrame.GreetingPanel.ScrollBox.ScrollTarget:GetChildren()):GetRegions()):GetText()

				--------------------------------

				if not isReturnToPreviousDialog then
					if addon.Interaction.Variables.GossipLastNPC ~= UnitName("npc") then
						addon.Interaction.GossipFirstInteractMessage = gossipInteractMessage
						addon.Interaction.Variables.GossipLastNPC = UnitName("npc")
					end

					--------------------------------

					Frame.ShowWithAnimation()
				else
					Frame.ShowWithAnimation()
				end
			else
				Frame.ShowWithAnimation()
			end

			--------------------------------

			CallbackRegistry:Trigger("START_DIALOG")
		end

		Frame.UpdatePosition = function()
			local nameplate = C_NamePlate.GetNamePlateForUnit("npc")
			local playerNameplate = C_NamePlate.GetNamePlateForUnit("player")

			--------------------------------

			do -- STATE
				local IsValidNameplate = (nameplate and nameplate ~= playerNameplate and (not UnitIsGameObject("npc") and not UnitIsGameObject("questnpc")))

				--------------------------------

				if IsValidNameplate then
					do -- FRAME
						Frame.DialogBackground.Tail:Show()

						--------------------------------

						local heightModifier = 25

						Frame:ClearAllPoints()
						Frame:SetPoint("BOTTOM", nameplate, 0, heightModifier)

						--------------------------------

						Frame:SetFrameStrata("LOW")
					end
				else
					do -- FRAME
						Frame.DialogBackground.Tail:Hide()

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

						local screenWidth = addon.API:GetScreenWidth()
						local screenHeight = addon.API:GetScreenHeight()
						local questWidth = InteractionQuestFrame:GetWidth() + 50 -- Padding
						local questHeight = InteractionQuestFrame:GetHeight() + 50 -- Padding
						local dialogWidth = 375
						local dialogHeight = InteractionDialogFrame:GetHeight()

						local dialogMaxWidth = 350
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

						Frame:SetFrameStrata("FULLSCREEN")
					end
				end
			end
		end

		Frame.UpdateDialog = function()
			NS.Variables.Temp_IsScrollDialog = Frame.UpdateScrollDialog()
			NS.Variables.Temp_IsStylisedDialog = addon.Theme.IsRusticTheme_Dialog

			--------------------------------

			Frame.UpdatePosition()
			Frame.UpdateSize(NS.Variables.Temp_IsEmoteDialog)
			Frame.UpdateTitle()
			Frame.UpdateStyle(NS.Variables.Temp_IsEmoteDialog, NS.Variables.Temp_IsScrollDialog, NS.Variables.Temp_IsStylisedDialog)
		end

		--------------------------------

		function Frame.IncrementIndex()
			if not NS.Variables.IsInInteraction then
				return
			end

			--------------------------------

			if NS.Variables.Temp_DialogStringList and NS.Variables.Temp_CurrentIndex < #NS.Variables.Temp_DialogStringList then
				NS.Variables.Temp_CurrentIndex = NS.Variables.Temp_CurrentIndex + 1
				Callback:UpdateString(true)

				--------------------------------

				if NS.Variables.Temp_IsEmoteDialog == false then
					addon.SoundEffects:PlaySoundFile(addon.SoundEffects.Dialog_Next)
				end
			else
				Frame.StopDialog()
			end
		end

		function Frame.DecrementIndex()
			if not NS.Variables.IsInInteraction then
				return
			end

			--------------------------------

			if Frame:IsVisible() then
				if NS.Variables.Temp_CurrentIndex > 1 then
					NS.Variables.Temp_CurrentIndex = NS.Variables.Temp_CurrentIndex - 1
					Callback:UpdateString(false)

					addon.SoundEffects:PlaySoundFile(addon.SoundEffects.Dialog_Previous)
				else
					Frame.InvalidDialogAnimation()
					Callback:UpdateString(false)

					addon.SoundEffects:PlaySoundFile(addon.SoundEffects.Dialog_Invalid)
				end
			else
				Frame.ReturnToPreviousDialog()
			end
		end

		function Frame.ReturnToPreviousDialog()
			if not NS.Variables.IsInInteraction or not Frame.hidden then
				return
			end

			if NS.Variables.Temp_DialogStringList[NS.Variables.Temp_CurrentIndex] == " " then
				return
			end

			--------------------------------

			Frame.StartDialog(true)
			Callback:UpdateString(false)

			--------------------------------

			NS.Variables.AllowAutoProgress = false

			--------------------------------

			CallbackRegistry:Trigger("PREVIOUS_DIALOG")
		end

		--------------------------------

		CallbackRegistry:Add("GOSSIP_BUTTON_CLICKED", Frame.PreventAutoPlay, 0)
	end

	--------------------------------
	-- FUNCTIONS (ANIMATION)
	--------------------------------

	do
		do -- PLAYBACK
			Frame.StartTextPlayback = function(frame, interval, callback, callbackDelay, skipAnimation, usePausing)
				local text = frame:GetText() or ""
				local textLength = strlenutf8(text)
				local pauseDuration = .125
				local timer = 0
				local paused = false
				local pauseTimer = 0

				local pauseCharDB = L["DialogData - PauseCharDB"]

				--------------------------------

				frame.TextAnimationFrame = frame.TextAnimationFrame or CreateFrame("Frame", "$parent.TextAnimationFrame", nil)

				--------------------------------

				local function Update(self, elapsed)
					if paused then
						pauseTimer = pauseTimer + elapsed

						--------------------------------

						if pauseTimer >= pauseDuration then
							paused = false
							pauseTimer = 0
						else
							return
						end
					end

					--------------------------------

					timer = timer + elapsed

					--------------------------------

					local numCharsToShow = math.min(math.floor(timer / interval) + 1, textLength)
					local current = AdaptiveAPI:GetSubstring(text, 1, numCharsToShow)
					local remaining = AdaptiveAPI:GetSubstring(text, numCharsToShow + 1, textLength)
					local new

					--------------------------------

					local textColor
					local color

					do -- TEXT COLOR
						if (addon.Theme.IsDarkTheme_Dialog or addon.Theme.IsRusticTheme_Dialog) and NS.Variables.Temp_IsScrollDialog then
							textColor = { r = 1, g = 1, b = 1 }
						elseif (addon.Theme.IsDarkTheme_Dialog or addon.Theme.IsRusticTheme_Dialog) then
							if addon.Theme.IsRusticTheme_Dialog then
								textColor = addon.Theme.RGB_CHAT_MSG_SAY
							elseif addon.Theme.IsDarkTheme_Dialog then
								textColor = { r = 1, g = 1, b = 1 }
							end
						elseif not (addon.Theme.IsDarkTheme_Dialog or addon.Theme.IsRusticTheme_Dialog) and NS.Variables.Temp_IsScrollDialog then
							textColor = { r = .1, g = .1, b = .1 }
						elseif not (addon.Theme.IsDarkTheme_Dialog or addon.Theme.IsRusticTheme_Dialog) then
							if addon.Theme.IsRusticTheme_Dialog then
								textColor = addon.Theme.RGB_CHAT_MSG_SAY
							elseif not addon.Theme.IsDarkTheme_Dialog then
								textColor = addon.Theme.RGB_CHAT_MSG_SAY
							end
						end
					end

					do -- COLOR
						local isMouseOver = frame.mouseOver

						--------------------------------

						if addon.Database.DB_GLOBAL.profile.INT_CONTENT_PREVIEW_ALPHA <= .1 then
							if (addon.Theme.IsDarkTheme_Dialog or addon.Theme.IsRusticTheme_Dialog) and NS.Variables.Temp_IsScrollDialog then
								color = isMouseOver and "101010" or "101010"
							elseif (addon.Theme.IsDarkTheme_Dialog or addon.Theme.IsRusticTheme_Dialog) then
								if addon.Theme.IsRusticTheme_Dialog then
									color = "101010"
								elseif addon.Theme.IsDarkTheme_Dialog then
									color = isMouseOver and "0D0A0B" or "070504"
								end
							elseif not (addon.Theme.IsDarkTheme_Dialog or addon.Theme.IsRusticTheme_Dialog) and NS.Variables.Temp_IsScrollDialog then
								color = "CEAA82"
							elseif not (addon.Theme.IsDarkTheme_Dialog or addon.Theme.IsRusticTheme_Dialog) then
								if addon.Theme.IsRusticTheme_Dialog then
									color = "101010"
								elseif not addon.Theme.IsDarkTheme_Dialog then
									color = isMouseOver and "232323" or "191919"
								end
							end
						else
							local modifier = .2 + (addon.Database.DB_GLOBAL.profile.INT_CONTENT_PREVIEW_ALPHA / 1.25)
							if not (addon.Theme.IsDarkTheme_Dialog or addon.Theme.IsRusticTheme_Dialog) and NS.Variables.Temp_IsScrollDialog then
								color = AdaptiveAPI:SetHexColorFromModifierWithBase(AdaptiveAPI:GetHexColor(textColor.r, textColor.g, textColor.b), modifier, "CEAA82")
							else
								color = AdaptiveAPI:SetHexColorFromModifier(AdaptiveAPI:GetHexColor(textColor.r, textColor.g, textColor.b), modifier)
							end
						end
					end

					do -- PAUSE
						if usePausing then
							local lastChar = AdaptiveAPI:GetSubstring(text, numCharsToShow, numCharsToShow)

							--------------------------------

							for char = 1, #pauseCharDB do
								if AdaptiveAPI:FindString(pauseCharDB[char], lastChar) then
									paused = true
									break
								end
							end
						end
					end

					do -- TEXT
						if strlenutf8(remaining) > 0 and not frame.freezePlayback then
							new = current .. "|cff" .. color .. remaining .. "|r"
						else
							new = current .. remaining
						end
					end

					--------------------------------

					if not skipAnimation then
						frame:SetText(new)
						frame.currentText = new
					end

					--------------------------------

					if numCharsToShow >= textLength then
						frame.TextAnimationFrame:SetScript("OnUpdate", nil)

						--------------------------------

						if callback then
							if callbackDelay then
								frame.TextAnimationCallbackTimer = addon.Libraries.AceTimer:ScheduleTimer(function()
									callback()
								end, callbackDelay)
							else
								callback()
							end
						end
					end
				end

				frame.TextAnimationFrame:SetScript("OnUpdate", Update)
			end

			Frame.StopTextPlayback = function(textFrame)
				if textFrame.TextAnimationFrame then
					textFrame.TextAnimationFrame:SetScript("OnUpdate", nil)

					--------------------------------

					if textFrame.TextAnimationCallbackTimer then
						addon.Libraries.AceTimer:CancelTimer(textFrame.TextAnimationCallbackTimer)
					end
				end
			end
		end

		do -- FRAME
			local isTransition
			local isInvalidDialogTransition
			local savedDialogText

			Frame.NewDialogAnimation = function()
				if isTransition or isInvalidDialogTransition then
					return
				end

				--------------------------------

				if savedDialogText == Frame.Content.Measurement:GetText() then
					return
				end
				savedDialogText = Frame.Content.Measurement:GetText()

				--------------------------------

				AdaptiveAPI.Animation:Fade(Frame.Content.Label, .5, 0, 1, nil, function() return Frame.Content.Measurement:GetText() ~= savedDialogText end)

				if not NS.Variables.Temp_IsEmoteDialog and not NS.Variables.Temp_IsScrollDialog then
					AdaptiveAPI.Animation:Fade(Frame, .25, 0, 1, nil, function() return Frame.Content.Measurement:GetText() ~= savedDialogText end)
					AdaptiveAPI.Animation:Scale(Frame.DialogBackground, .75, .75, 1, nil, AdaptiveAPI.Animation.EaseExpo, function() return Frame.Content.Measurement:GetText() ~= savedDialogText or isInvalidDialogTransition end)
				end
			end

			Frame.PreviousDialogAnimation = function()
				AdaptiveAPI.Animation:Fade(Frame.Content.Label, .5, 0, 1)
			end

			Frame.InvalidDialogAnimation = function()
				if isTransition or isInvalidDialogTransition then
					return
				end
				isInvalidDialogTransition = true
				addon.Libraries.AceTimer:ScheduleTimer(function()
					if isInvalidDialogTransition then
						isInvalidDialogTransition = false
					end
				end, .25)

				--------------------------------

				AdaptiveAPI.Animation:Scale(Frame.DialogBackground, 1, .95, 1)
				AdaptiveAPI.Animation:Scale(Frame.ScrollBackground, 1, .95, 1)
			end

			Frame.ShowWithAnimation = function()
				Frame.hidden = false

				--------------------------------

				Frame:Show()

				--------------------------------

				isTransition = true
				savedDialogText = nil
				addon.Libraries.AceTimer:ScheduleTimer(function()
					if not Frame.hidden then
						isTransition = false
					end
				end, .25)

				--------------------------------

				Frame:SetAlpha(0)
				Frame.Title:SetAlpha(0)
				Frame.Title.Label:SetAlpha(0)
				Frame.Content.Label:SetAlpha(0)

				--------------------------------

				if not Frame.hidden then
					AdaptiveAPI.Animation:Fade(Frame, .25, 0, 1)
					AdaptiveAPI.Animation:Fade(Frame.Title, .25, 0, 1)

					--------------------------------

					if addon.Database.DB_GLOBAL.profile.INT_TITLE_ALPHA > 0 then
						AdaptiveAPI.Animation:Fade(Frame.Title.Label, .5, 0, addon.Database.DB_GLOBAL.profile.INT_TITLE_ALPHA)
					else
						AdaptiveAPI.Animation:Fade(Frame.Title.Label, .5, 0, addon.Database.DB_GLOBAL.profile.INT_TITLE_ALPHA)
					end

					--------------------------------

					AdaptiveAPI.Animation:Fade(Frame.Content.Label, .5, 0, 1)

					--------------------------------

					AdaptiveAPI.Animation:Scale(Frame.DialogBackground, 1, .25, 1)
					AdaptiveAPI.Animation:Scale(Frame.ScrollBackground, 1, .25, 1)
				end
			end

			Frame.HideWithAnimation = function(skipAnimation)
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
					AdaptiveAPI.Animation:Fade(Frame, .125, Frame:GetAlpha(), 0)
					AdaptiveAPI.Animation:Scale(Frame.DialogBackground, .25, Frame.DialogBackground:GetScale(), .925)
					AdaptiveAPI.Animation:Scale(Frame.ScrollBackground, .25, Frame.ScrollBackground:GetScale(), .925)
				end
			end

			Frame.ScrollBackground.ShowWithAnimation = function()
				if not Frame.ScrollBackground:IsVisible() then
					Frame.ScrollBackground:Show()

					AdaptiveAPI.Animation:Fade(Frame.ScrollBackground, .25, 0, 1)
					AdaptiveAPI.Animation:Scale(Frame.ScrollBackground, .5, .75, 1)
				end
			end

			Frame.ScrollBackground.HideWithAnimation = function()
				if Frame.ScrollBackground:IsVisible() and Frame.ScrollBackground:GetAlpha() == 1 then
					AdaptiveAPI.Animation:Fade(Frame.ScrollBackground, .5, 1, 0)
					AdaptiveAPI.Animation:Scale(Frame.ScrollBackground, .5, 1, .5)

					addon.Libraries.AceTimer:ScheduleTimer(function()
						Frame.ScrollBackground:Hide()
					end, 1)
				end
			end
		end
	end

	--------------------------------
	-- SETTINGS
	--------------------------------

	do
		local function Settings_ContentSize()
			local TextSize = addon.Database.DB_GLOBAL.profile.INT_CONTENT_SIZE

			AdaptiveAPI:SetFontSize(Frame.Content.Measurement, TextSize)
			AdaptiveAPI:SetFontSize(Frame.Content.Label, TextSize)

			if Frame:IsVisible() and addon.Interaction.Variables.Active then
				Frame.UpdateDialog()
			end
		end
		Settings_ContentSize()

		local function Settings_TitleProgressVisibility()
			local Visiblity = addon.Database.DB_GLOBAL.profile.INT_PROGRESS_SHOW

			Frame.Title.Progress:SetShown(Visiblity)
			Frame.Title.Progress:SetAlpha(1)
		end
		Settings_TitleProgressVisibility()

		local function Settings_TitleAlpha()
			local Alpha = addon.Database.DB_GLOBAL.profile.INT_TITLE_ALPHA

			Frame.Title.Label:SetAlpha(Alpha)
		end
		Settings_TitleAlpha()

		local function Settings_ThemeUpdate()
			if Frame:IsVisible() then
				Frame.UpdateDialog()

				--------------------------------

				Callback:UpdateString(true)
			end
		end

		local function Settings_ThemeUpdateDialogAnimation()
			if Frame:IsVisible() then
				Frame.AllowAutoProgress = false

				--------------------------------

				AdaptiveAPI.Animation:RemoveAllAnimationsFromFrame(Frame)
				if Frame.ThemeUpdateTimer then
					addon.Libraries.AceTimer:CancelTimer(Frame.ThemeUpdateTimer)
				end

				--------------------------------

				addon.Libraries.AceTimer:ScheduleTimer(function()
					AdaptiveAPI.Animation:Fade(Frame, .25, Frame:GetAlpha(), 0)

					--------------------------------

					Frame.ThemeUpdateTimer = addon.Libraries.AceTimer:ScheduleTimer(function()
						AdaptiveAPI.Animation:Fade(Frame, .25, 0, 1)
					end, .75)
				end, .1)
			end
		end

		--------------------------------

		CallbackRegistry:Add("SETTINGS_CONTENT_SIZE_CHANGED", Settings_ContentSize, 0)
		CallbackRegistry:Add("SETTINGS_TITLE_PROGRESS_VISIBILITY_CHANGED", Settings_TitleProgressVisibility, 0)
		CallbackRegistry:Add("SETTINGS_TITLE_ALPHA_CHANGED", Settings_TitleAlpha, 0)

		CallbackRegistry:Add("THEME_UPDATE", Settings_ThemeUpdate, 10)
		CallbackRegistry:Add("THEME_UPDATE_DIALOG_ANIMATION", Settings_ThemeUpdateDialogAnimation, 0)
	end

	--------------------------------
	-- EVENTS
	--------------------------------

	do
		Frame:SetScript("OnEnter", function()
			AdaptiveAPI.Animation:Scale(Frame.Title.Progress, .5, 1, 1.125)
			AdaptiveAPI.Animation:Scale(Frame.ScrollBackground, .5, 1, 1.05)

			AdaptiveAPI.Animation:Fade(Frame.DialogBackground, .125, 1, .75)
			AdaptiveAPI.Animation:Fade(Frame.DialogBackground.Tail, .125, 1, .75)
			AdaptiveAPI.Animation:Fade(Frame.ScrollBackground, .125, 1, .975)

			Frame.Content.Label.mouseOver = true
		end)

		Frame:SetScript("OnLeave", function()
			AdaptiveAPI.Animation:Scale(Frame.Title.Progress, .5, 1.125, 1)
			AdaptiveAPI.Animation:Scale(Frame.ScrollBackground, .5, 1.05, 1)

			AdaptiveAPI.Animation:Fade(Frame.DialogBackground, .125, .75, 1)
			AdaptiveAPI.Animation:Fade(Frame.DialogBackground.Tail, .125, .75, 1)
			AdaptiveAPI.Animation:Fade(Frame.ScrollBackground, .125, .975, 1)

			Frame.Content.Label.mouseOver = false
		end)

		Frame:SetScript("OnMouseUp", function(self, button)
			if button == "LeftButton" then
				if addon.Database.DB_GLOBAL.profile.INT_FLIPMOUSE == true then
					Frame.DecrementIndex()
				else
					Frame.IncrementIndex()
				end

				NS.Variables.AllowAutoProgress = false
			elseif button == "RightButton" then
				if addon.Database.DB_GLOBAL.profile.INT_FLIPMOUSE == true then
					Frame.IncrementIndex()
				else
					Frame.DecrementIndex()
				end

				NS.Variables.AllowAutoProgress = false
			end
		end)

		Frame.Title.Progress:SetScript("OnMouseUp", function(self, button)
			Frame.StopDialog()
		end)

		Frame:SetScript("OnUpdate", function()
			Frame.UpdatePosition()
		end)

		local Events = CreateFrame("Frame")
		Events:RegisterEvent("GLOBAL_MOUSE_UP")
		Events:SetScript("OnEvent", function(self, event, ...)
			if event == "GLOBAL_MOUSE_UP" then
				if addon.Interaction.Variables.Active then
					local button = ...

					--------------------------------

					local npcName_Target = UnitName("npc") or UnitName("questnpc")
					local npcName_MouseOver = UnitName("mouseover")

					--------------------------------

					if (tostring(npcName_Target) == tostring(npcName_MouseOver)) then
						if button == "LeftButton" then
							if addon.Database.DB_GLOBAL.profile.INT_FLIPMOUSE == true then
								Frame.DecrementIndex()
							else
								Frame.IncrementIndex()
							end

							NS.Variables.AllowAutoProgress = false
						elseif button == "RightButton" then
							if addon.Database.DB_GLOBAL.profile.INT_FLIPMOUSE == true then
								Frame.IncrementIndex()
							else
								Frame.DecrementIndex()
							end

							NS.Variables.AllowAutoProgress = false
						end
					end
				end
			end
		end)
	end
end
