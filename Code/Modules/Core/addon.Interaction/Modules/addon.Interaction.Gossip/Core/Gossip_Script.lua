local addonName, addon = ...
local CallbackRegistry = addon.CallbackRegistry
local L = addon.Locales
local NS = addon.Interaction.Gossip

--------------------------------

NS.Script = {}

--------------------------------

local GetAvailableQuestInfo = GetAvailableQuestInfo or function() return false, 0, false, false, 0 end
local GetActiveQuestID = GetActiveQuestID or function() return 0 end

--------------------------------

function NS.Script:Load()
	--------------------------------
	-- REFERENCES
	--------------------------------

	local Frame = InteractionGossipFrame
	local Callback = NS.Script

	--------------------------------
	-- FUNCTIONS (BUTTONS)
	--------------------------------

	do
		do -- GOODBYE BUTTON
			Frame.GoodbyeButton:SetScript("OnClick", function()
				GossipFrame:Hide()
				QuestFrame:Hide()

				addon.Interaction.Script:Stop(true)
			end)
		end

		do -- OPTION BUTTON
			local IsWaitingForGossipShow = false
			local IsTTSPlayback = { ["playback"] = false, ["button"] = nil }

			--------------------------------

			local function Start(button)
				if Frame.SelectedOptionTransition then
					return
				end
				Frame.SelectedOptionTransition = true

				--------------------------------

				AdaptiveAPI.Animation:Fade(Frame, .125, 1, 0)
			end

			local function Finish(button)
				local IsGossipOrQuestGreetingStillVisible = (GossipFrame:IsVisible() or QuestFrameGreetingPanel:IsVisible())

				--------------------------------

				if IsGossipOrQuestGreetingStillVisible then
					Frame.GoodbyeButton:Hide()
					AdaptiveAPI.Animation:Fade(Frame, .125, 0, 1)

					--------------------------------

					Frame:UpdateButtons()
					Frame.StartButtonSequence()
				end

				--------------------------------

				addon.Libraries.AceTimer:ScheduleTimer(function()
					if Frame.SelectedOptionTransition then
						Frame.SelectedOptionTransition = false
					end
				end, .125)

				--------------------------------

				IsWaitingForGossipShow = false
				IsTTSPlayback = { ["playback"] = false, ["button"] = nil }
			end

			local function TTS(button)
				local string = button.Label:GetText()

				--------------------------------

				local function RemoveTriggerText()
					if string:match("^%(%s*Quest%s*%)") then
						string = string:match("^%(%s*Quest%s*%)%s*(.*)$")
					else
						string = string
					end
				end

				--------------------------------

				RemoveTriggerText()

				--------------------------------

				addon.TextToSpeech.Script:PlayConfiguredTTS(INTDB.profile.INT_TTS_PLAYER_VOICE, string)
			end

			local function Click(button)
				local PATH_GOSSIP = addon.Variables.PATH .. "Art/ContextIcons/gossip-bubble.png"

				local UsePlayerVoice = (INTDB.profile.INT_TTS and INTDB.profile.INT_TTS_PLAYER)
				local IsGossipOption = (button.texture == PATH_GOSSIP)

				--------------------------------

				Start(button)

				--------------------------------

				if UsePlayerVoice and IsGossipOption then
					TTS(button)

					--------------------------------

					addon.Interaction.Dialog.Script:StopInteraction()

					--------------------------------

					IsWaitingForGossipShow = false
					IsTTSPlayback = { ["playback"] = false, ["button"] = nil }

					addon.Libraries.AceTimer:ScheduleTimer(function()
						IsTTSPlayback = { ["playback"] = true, ["button"] = button }
					end, .25)
				else
					button.SelectOption()

					--------------------------------

					IsWaitingForGossipShow = true
					IsTTSPlayback = { ["playback"] = false, ["button"] = nil }
				end
			end

			--------------------------------

			local Events = CreateFrame("Frame")
			Events:RegisterEvent("GOSSIP_SHOW")
			Events:RegisterEvent("VOICE_CHAT_TTS_PLAYBACK_FINISHED")
			Events:SetScript("OnEvent", function(self, event, ...)
				if event == "GOSSIP_SHOW" then
					if IsWaitingForGossipShow then
						Finish()
					end
				end

				if event == "VOICE_CHAT_TTS_PLAYBACK_FINISHED" then
					if IsTTSPlayback.playback then
						if IsTTSPlayback.button then
							IsTTSPlayback.button.SelectOption()
						end

						--------------------------------

						IsWaitingForGossipShow = true
						IsTTSPlayback = { ["playback"] = true, ["button"] = nil }
					end
				end
			end)

			--------------------------------

			CallbackRegistry:Add("GOSSIP_BUTTON_CLICKED", function(button)
				if INTDB.profile.INT_ALWAYS_SHOW_GOSSIP then
					Click(button)
				end
			end, 0)

			CallbackRegistry:Add("STOP_PROMPT", function()
				if IsWaitingForGossipShow then
					Finish()
				end
			end)
		end

		do -- MOUSE RESPONDER
			Frame.MouseResponder:SetScript("OnMouseUp", function(self, button)
				if INTDB.profile.INT_FLIPMOUSE == false and button == "RightButton" then
					InteractionDialogFrame.ReturnToPreviousDialog()
				elseif INTDB.profile.INT_FLIPMOUSE == true and button == "LeftButton" then
					InteractionDialogFrame.ReturnToPreviousDialog()
				end
			end)
		end
	end

	--------------------------------
	-- FUNCTIONS (DATA)
	--------------------------------

	do
		Frame.GetButtons = function()
			if Frame.Buttons == nil then
				return
			end

			local CurrentButtons = {}
			for i = 1, NS.Variables.NumCurrentButtons do
				table.insert(CurrentButtons, Frame.Buttons[i])
			end

			return CurrentButtons
		end

		Frame.GetAllButtons = function()
			if Frame.Buttons == nil then
				return
			end

			return Frame.Buttons
		end

		Frame.SetButtons = function(hideButtons)
			local buttons = Frame.GetAllButtons()

			local availableQuests = C_GossipInfo.GetAvailableQuests()
			local activeQuests = C_GossipInfo.GetActiveQuests()
			local options = C_GossipInfo.GetOptions()

			local entries = {}
			local currentIndex = 0

			do -- GOSSIP
				if addon.Interaction.Variables.Type == "gossip" then
					availableQuests = C_GossipInfo.GetAvailableQuests()
					activeQuests = C_GossipInfo.GetActiveQuests()
					options = C_GossipInfo.GetOptions()

					--------------------------------

					for i = 1, #availableQuests do
						currentIndex = currentIndex + 1

						--------------------------------

						local entry = {}

						for k, v in pairs(availableQuests[i]) do
							entry[k] = v
						end

						entry.optionFrame = "gossip"
						entry.optionType = "available"
						entry.optionID = entry.questID
						entry.optionIndex = i
						entry.flag = "available"

						--------------------------------

						table.insert(entries, entry)
					end

					for i = 1, #activeQuests do
						currentIndex = currentIndex + 1

						--------------------------------

						local entry = {}

						for k, v in pairs(activeQuests[i]) do
							entry[k] = v
						end

						entry.optionFrame = "gossip"
						entry.optionType = "active"
						entry.optionID = entry.questID
						entry.optionIndex = i

						if not entry.isComplete then
							local isRetail = not addon.Variables.IS_CLASSIC and not addon.Variables.IS_CLASSIC_ERA
							local result

							--------------------------------

							if isRetail then
								result = C_QuestLog.IsComplete(entry.questID)
							else
								result = IsQuestComplete(entry.questID)
							end

							--------------------------------

							entry.isComplete = result
						end

						entry.flag = entry.isComplete and "complete" or "active"

						--------------------------------

						table.insert(entries, entry)
					end

					for i = 1, #options do
						currentIndex = currentIndex + 1

						--------------------------------

						local entry = {}

						for k, v in pairs(options[i]) do
							entry[k] = v
						end

						entry.optionFrame = "gossip"
						entry.optionType = "option"
						entry.optionID = entry.gossipOptionID
						entry.optionIndex = i
						entry.flag = "option"

						--------------------------------

						table.insert(entries, entry)
					end
				end
			end

			do -- QUEST GREETING
				if addon.Interaction.Variables.Type == "quest-greeting" then
					local numAvailableQuests = GetNumAvailableQuests()
					local numActiveQuests = GetNumActiveQuests()
					local currentIndex = 0

					--------------------------------

					for i = 1, numAvailableQuests do
						currentIndex = currentIndex + 1

						--------------------------------

						local title = GetAvailableTitle(i)
						local isTrivial, frequency, isRepeatable, isLegendary, questID = GetAvailableQuestInfo(i)

						--------------------------------

						local questInfo = {
							index = i,
							title = title,
							isComplete = false,
							questID = questID,
							isOnQuest = false,
							isTrivial = isTrivial,
							frequency = frequency,
							repeatable = isRepeatable,
							isLegendary = isLegendary,
							isAvailableQuest = true,
						}

						if not questInfo.isComplete then
							local isRetail = not addon.Variables.IS_CLASSIC and not addon.Variables.IS_CLASSIC_ERA
							local result

							--------------------------------

							if isRetail then
								result = C_QuestLog.IsComplete(questInfo.questID)
							else
								result = IsQuestComplete(questInfo.questID)
							end

							--------------------------------

							questInfo.isComplete = result
						end

						questInfo.optionFrame = "quest-greeting"
						questInfo.optionType = "available"
						questInfo.optionID = questID
						questInfo.optionIndex = i
						questInfo.flag = "available"

						--------------------------------

						entries[currentIndex] = questInfo
					end

					for i = 1, numActiveQuests do
						currentIndex = currentIndex + 1;

						--------------------------------

						local title, isComplete = GetActiveTitle(i)
						local questID = GetActiveQuestID(i)

						--------------------------------

						local questInfo = {
							index = i,
							title = title,
							isComplete = isComplete,
							questID = questID,
							isAvailableQuest = false,
							isOnQuest = true,
						}

						if not questInfo.isComplete then
							local isRetail = not addon.Variables.IS_CLASSIC and not addon.Variables.IS_CLASSIC_ERA
							local result

							--------------------------------

							if isRetail then
								result = C_QuestLog.IsComplete(questInfo.questID)
							else
								result = IsQuestComplete(questInfo.questID)
							end

							--------------------------------

							questInfo.isComplete = result
						end

						questInfo.optionFrame = "quest-greeting"
						questInfo.optionType = "active"
						questInfo.optionID = questID
						questInfo.optionIndex = i
						questInfo.flag = isComplete and "complete" or "active"

						--------------------------------

						entries[currentIndex] = questInfo
					end
				end
			end

			table.sort(entries, function(a, b)
				local flagOrder = { ["complete"] = 0, ["available"] = 1, ["active"] = 2, ["option"] = 3 }
				return flagOrder[a.flag] < flagOrder[b.flag]
			end)

			--------------------------------

			NS.Variables.NumCurrentButtons = #entries

			--------------------------------

			do -- BUTTONS
				if buttons then
					for i = 1, #buttons do
						buttons[i]:Hide()
					end

					for i = 1, #entries do
						if not hideButtons then
							buttons[i]:Show()
						end

						--------------------------------

						buttons[i].OptionFrame = entries[i].optionFrame
						buttons[i].OptionType = entries[i].optionType
						buttons[i].OptionID = entries[i].optionID
						buttons[i].OptionIndex = entries[i].optionIndex

						--------------------------------

						buttons[i].UpdatePosition()

						--------------------------------

						do -- TEXT
							local text = entries[i].title or entries[i].name
							text = (string.gsub(text, L["GossipData - Trigger - Quest"], AdaptiveAPI:InlineIcon(addon.Variables.PATH .. "Art/ContextIcons/trigger-quest.png", 25, 64, 0, 0)))
							text = (string.gsub(text, L["GossipData - Trigger - Movie 1"], AdaptiveAPI:InlineIcon(addon.Variables.PATH .. "Art/ContextIcons/trigger-movie.png", 25, 64, 0, 0)))
							text = (string.gsub(text, L["GossipData - Trigger - Movie 2"], AdaptiveAPI:InlineIcon(addon.Variables.PATH .. "Art/ContextIcons/trigger-movie.png", 25, 64, 0, 0)))
							text = (string.gsub(text, L["GossipData - Trigger - NPC Dialog"], AdaptiveAPI:InlineIcon(addon.Variables.PATH .. "Art/ContextIcons/trigger-npcdialog.png", 12.5, 12.5, 0, 0) .. " " .. L["GossipData - Trigger - NPC Dialog - Subtext 1"]))

							--------------------------------

							buttons[i].Label:SetText(text)
						end

						do -- CONTEXT ICON
							local gossipOptionTexture = entries[i].optionType == "option" and options[entries[i].optionIndex].icon
							local _, texture = addon.ContextIcon.Script:GetContextIcon(entries[i], gossipOptionTexture)

							--------------------------------

							buttons[i].IconTexture:SetTexture(texture)
						end

						do -- INDEX KEYBIND
							if i <= 18 then
								if i <= 9 then
									buttons[i].Keybind.Label:SetScale(1)
									buttons[i].Keybind.Label:SetText(i)
								else
									buttons[i].Keybind.Label:SetScale(.75)
									buttons[i].Keybind.Label:SetText("S" .. i - 9)
								end
							end
						end

						do -- SCALE
							buttons[i]:SetHeight(buttons[i].Label:GetStringHeight() + NS.Variables:RATIO(.5))
						end
					end
				end
			end

			do -- FORMATTING
				local spacing = NS.Variables.BUTTON_SPACING
				local totalHeight = 0

				--------------------------------

				for i = 1, NS.Variables.NumCurrentButtons do
					totalHeight = totalHeight + (buttons[i]:GetHeight() + spacing)
				end

				--------------------------------

				Frame:SetWidth(325)
				Frame.GoodbyeButton:ClearAllPoints()

				if #entries >= 1 then
					Frame:SetHeight(totalHeight)

					--------------------------------

					Frame.GoodbyeButton:SetPoint("BOTTOM", Frame, 0, -Frame.GoodbyeButton:GetHeight() - NS.Variables:RATIO(2))
				else
					Frame:SetHeight(50)

					--------------------------------

					Frame.GoodbyeButton:SetPoint("CENTER", Frame)
				end
			end

			--------------------------------

			CallbackRegistry:Trigger("GOSSIP_DATA_LOADED")
		end

		Frame.SetAllButtons = function(hideButtons)
			if GossipFrame:IsVisible() then
				Frame.SetButtons(hideButtons)
			end

			if QuestFrameGreetingPanel:IsVisible() then
				Frame.SetButtons(hideButtons)
			end
		end

		Frame.UpdateButtons = function(hideButtons)
			if addon.Interaction.Variables.Active then
				CallbackRegistry:Trigger("UPDATE_GOSSIP")
			end

			--------------------------------

			addon.Libraries.AceTimer:ScheduleTimer(function()
				Frame.SetAllButtons(hideButtons)

				--------------------------------

				if addon.Interaction.Variables.Active then
					CallbackRegistry:Trigger("UPDATE_GOSSIP_READY")
				end
			end, 0)
		end

		Frame.UpdateAllButtonStates = function()
			local Buttons = Frame.GetAllButtons()

			for button = 1, #Buttons do
				if Buttons and Buttons[button] then
					Buttons[button].UpdateState()
				end
			end
		end
	end

	--------------------------------
	-- FUNCTIONS (FRAME)
	--------------------------------

	do
		Frame.UpdateAll = function()
			NS.Variables.LastNPC = NS.Variables.NPC

			Frame.SetAllButtons()
			Frame.UpdatePosition()
			Frame.UpdateStyle()
			Frame.UpdateFocus()
		end

		Frame.UpdatePosition = function()
			local Settings_UIDirection = INTDB.profile.INT_UIDIRECTION

			--------------------------------

			NS.Variables.NPC = UnitName("npc") or ""

			--------------------------------

			local screenWidth = addon.API:GetScreenWidth()
			local frameWidth = 325
			local dialogMaxWidth = 350

			local quarterWidth = (screenWidth - dialogMaxWidth) / 2
			local quarterEdgePadding = (quarterWidth - frameWidth) / 2
			local offsetX

			Frame:ClearAllPoints()
			if Settings_UIDirection == 1 then
				offsetX = quarterEdgePadding

				--------------------------------

				Frame:SetPoint("LEFT", UIParent, offsetX, 0)
			else
				offsetX = screenWidth - frameWidth - quarterEdgePadding

				--------------------------------

				Frame:SetPoint("LEFT", UIParent, offsetX, 0)
			end
		end

		Frame.UpdateStyle = function()
			local LastNPC = NS.Variables.LastNPC
			local NPC = NS.Variables.NPC

			local Buttons = Frame.GetButtons()

			--------------------------------

			if (LastNPC ~= NPC and NPC ~= "") then
				Frame:SetAlpha(0)
				Frame.GoodbyeButton:Hide()

				--------------------------------

				Frame.animation = true
				addon.Libraries.AceTimer:ScheduleTimer(function()
					Frame.animation = false
				end, .5)

				--------------------------------

				if Frame:GetAlpha() < .1 then
					AdaptiveAPI.Animation:Fade(Frame, .25, 0, 1, nil, function() return NPC ~= UnitName("npc") or NPC == "" or Frame.hidden end)
				end

				--------------------------------

				for i = 1, #Buttons do
					Buttons[i].HideButtons()
					Buttons[i].Standalone:Show()
				end

				--------------------------------

				Frame.UpdateButtons(true)
				addon.Libraries.AceTimer:ScheduleTimer(Frame.StartButtonSequence, .125)
			end
		end
	end

	--------------------------------
	-- FUNCTIONS (ANIMATION)
	--------------------------------

	do
		Frame.StartButtonSequence = function()
			local Buttons = Frame.GetButtons()

			local StartPosition
			if INTDB.profile.INT_UIDIRECTION == 1 then
				StartPosition = 12.5
			else
				StartPosition = -12.5
			end

			--------------------------------

			if Buttons then
				if NS.Variables.NumCurrentButtons >= 1 then
					local function ButtonAnimation(index, button)
						local valid = true -- Flag to check if button was hidden

						--------------------------------

						button.transition = true
						if addon.Variables.Platform == 1 then
							addon.Libraries.AceTimer:ScheduleTimer(function()
								if valid then
									button.transition = false
								end
							end, .325)
						end

						--------------------------------

						button:Show()

						--------------------------------

						AdaptiveAPI.Animation:Fade(button, .25, 0, 1, nil, function()
							if not button:IsVisible() or Frame.hidden then
								valid = false; return true
							end
						end)
						AdaptiveAPI.Animation:Fade(button.Label, .25, 0, 1, nil, function()
							if not button:IsVisible() or Frame.hidden then
								valid = false; return true
							end
						end)
						AdaptiveAPI.Animation:Move(button.Standalone.Background, .5, "CENTER", StartPosition, 0, "x", AdaptiveAPI.Animation.EaseSine, function()
							if not button:IsVisible() or Frame.hidden then
								valid = false; return true
							end
						end)

						--------------------------------

						if index == NS.Variables.NumCurrentButtons then
							Frame.GoodbyeButton:Show()

							--------------------------------

							AdaptiveAPI.Animation:Fade(Frame.GoodbyeButton, .25, 0, .5, nil, function()
								if Frame.hidden then
									valid = false; return true
								end
							end)
							AdaptiveAPI.Animation:Move(Frame.GoodbyeButton.API_ButtonTextFrame, .5, "CENTER", StartPosition, 0, "x", AdaptiveAPI.Animation.EaseSine, function()
								if Frame.hidden then
									valid = false; return true
								end
							end)
						end
					end

					for i = 1, NS.Variables.NumCurrentButtons do
						local button = Buttons[i]
						local delay = .0125 * i

						--------------------------------

						button:Hide()
						button.Label:SetAlpha(0)

						--------------------------------

						addon.Libraries.AceTimer:ScheduleTimer(function()
							ButtonAnimation(i, button)
						end, delay)
					end
				else
                    Frame.GoodbyeButton:Show()

					--------------------------------

                    Frame.GoodbyeButton:SetAlpha(1)

					local point, relativeTo, relativePoint, offsetX, offsetY = Frame.GoodbyeButton:GetPoint()
					Frame.GoodbyeButton:ClearAllPoints()
					Frame.GoodbyeButton:SetPoint("CENTER", relativeTo, 0, 0)
				end
			end
		end

		Frame.ShowWithAnimation = function()
			if not Frame.hidden then
				return
			end
			Frame.hidden = false
			Frame:Show()

			--------------------------------

			NS.Variables.LastNPC = nil
			NS.Variables.NPC = nil

			--------------------------------

			Frame:SetAlpha(0)

			--------------------------------

			Frame.UpdateStyle()
		end

		Frame.HideWithAnimation = function()
			if Frame.hidden then
				return
			end
			Frame.hidden = true

			addon.Libraries.AceTimer:ScheduleTimer(function()
				if Frame.hidden then
					Frame:Hide()
				end
			end, .5)

			--------------------------------

			AdaptiveAPI.Animation:Fade(Frame, .125, Frame:GetAlpha(), 0, nil, function() return not Frame.hidden end)
		end
	end

	--------------------------------
	-- FUNCTIONS (FOCUS)
	--------------------------------

	do
		function Frame.Enter()
			Frame.mouseOver = true

			--------------------------------

			Frame.UpdateFocus()
		end

		function Frame.Leave()
			Frame.mouseOver = false

			--------------------------------

			Frame.UpdateFocus()
		end

		function Frame.UpdateFocus()
			if not addon.Input.Variables.IsController then
				local IsMouseOver = (Frame.mouseOver)
				local IsInDialog = (not InteractionDialogFrame.hidden)

				--------------------------------

				if IsInDialog and not IsMouseOver then
					Frame.focused = false
				else
					Frame.focused = true
				end

				--------------------------------

				if Frame.focused then
					AdaptiveAPI.Animation:Fade(InteractionGossipParent, .25, InteractionGossipParent:GetAlpha(), 1, nil, function() return not Frame.focused end)
				else
					AdaptiveAPI.Animation:Fade(InteractionGossipParent, .25, InteractionGossipParent:GetAlpha(), .75, nil, function() return Frame.focused end)
				end
			else
				InteractionGossipParent:SetAlpha(1)
			end
		end

		AdaptiveAPI.FrameTemplates:CreateMouseResponder(Frame, Frame.Enter, Frame.Leave)
	end

	--------------------------------
	-- SETTINGS
	--------------------------------

	do
		local function Settings_UIDirection()
			Frame.UpdatePosition()
		end

		local function Settings_ThemeUpdate()
			Frame.UpdateAllButtonStates()
		end

		local function Settings_ThemeUpdateAnimation()
			if Frame:IsVisible() then
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

		CallbackRegistry:Add("SETTINGS_UIDIRECTION_CHANGED", Settings_UIDirection, 0)
		CallbackRegistry:Add("THEME_UPDATE_ANIMATION", Settings_ThemeUpdateAnimation, 0)
		CallbackRegistry:Add("THEME_UPDATE_DIALOG_ANIMATION", Settings_ThemeUpdateAnimation, 0)
		CallbackRegistry:Add("THEME_UPDATE", Settings_ThemeUpdate, 10)
	end

	--------------------------------
	-- EVENTS
	--------------------------------

	do
		hooksecurefunc(Frame, "Show", function()
			CallbackRegistry:Trigger("START_GOSSIP")
		end)

		hooksecurefunc(Frame, "Hide", function()
			CallbackRegistry:Trigger("STOP_GOSSIP")
		end)

		local Events = CreateFrame("Frame")
		Events:RegisterEvent("QUEST_LOG_UPDATE")
		Events:SetScript("OnEvent", function(self, event, ...)
			if event == "QUEST_LOG_UPDATE" then
				if not Frame.SelectedOptionTransition then
					Frame.SetAllButtons()
				end
			end
		end)
	end
end
