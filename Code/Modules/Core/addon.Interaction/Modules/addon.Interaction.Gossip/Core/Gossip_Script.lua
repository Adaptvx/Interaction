-- [!] [addon.Interaction.Gossip] is a replacement for Blizzard's Gossip Frame.
-- [Gossip_Script.lua] is the back-end (logic & behavior)
-- for [Gossip_Elements.lua].

---@class addon
local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local PrefabRegistry = addon.PrefabRegistry
local L = addon.Locales
local NS = addon.Interaction.Gossip; addon.Interaction.Gossip = NS

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

	local Frame = InteractionFrame.GossipFrame
	local Callback = NS.Script; NS.Script = Callback

	--------------------------------
	-- FUNCTIONS (BUTTONS)
	--------------------------------

	do
		do -- GOODBYE BUTTON
			Frame.REF_FOOTER_CONTENT_GOODBYE:SetScript("OnClick", function()
				addon.Interaction.Script:Stop(true)
			end)
		end

		do -- OPTION BUTTON
			Callback.OptionButtons = {}
			Callback.OptionButtons.IsWaitingForGossipShow = false
			Callback.OptionButtons.IsTTSPlayback = { ["playback"] = false, ["button"] = nil }

			--------------------------------

			do -- LOGIC
				local function RemoveTriggerText(text)
					local result = text

					--------------------------------

					result = result:gsub(L["GossipData - Trigger - Quest"], "")
					result = result:gsub(L["GossipData - Trigger - Movie 1"], "")
					result = result:gsub(L["GossipData - Trigger - Movie 2"], "")
					result = result:gsub(L["GossipData - Trigger - NPC Dialog"], "")

					--------------------------------

					return result
				end

				function Callback.OptionButtons:Start()
					Frame:RefreshWithAnimation_Start()
				end

				function Callback.OptionButtons:Finish()
					Frame:RefreshWithAnimation_End()

					--------------------------------

					Callback.OptionButtons.IsWaitingForGossipShow = false
					Callback.OptionButtons.IsTTSPlayback = { ["playback"] = false, ["button"] = nil }
				end

				function Callback.OptionButtons:PlayTTS(button)
					local text = button:GetText()
					text = RemoveTriggerText(text)

					--------------------------------

					addon.TextToSpeech.Script:PlayConfiguredTTS(addon.Database.DB_GLOBAL.profile.INT_TTS_PLAYER_VOICE, text)
				end

				function Callback.OptionButtons:Click(button)
					local PATH_GOSSIP = addon.Variables.PATH_ART .. "ContextIcons/gossip-bubble.png"

					local usePlayerVoice = (addon.Database.DB_GLOBAL.profile.INT_TTS and addon.Database.DB_GLOBAL.profile.INT_TTS_PLAYER)
					local isGossipOption = (button.contextIconTexture == PATH_GOSSIP)

					--------------------------------

					Callback.OptionButtons:Start()

					--------------------------------

					if usePlayerVoice and isGossipOption then
						Callback.OptionButtons:PlayTTS(button)

						--------------------------------

						addon.Interaction.Script:Manager_Dialog_Stop()

						--------------------------------

						Callback.OptionButtons.IsWaitingForGossipShow = false
						Callback.OptionButtons.IsTTSPlayback = { ["playback"] = false, ["button"] = nil }

						addon.Libraries.AceTimer:ScheduleTimer(function()
							Callback.OptionButtons.IsTTSPlayback = { ["playback"] = true, ["button"] = button }
						end, .25)
					else
						button.SelectOption()

						--------------------------------

						Callback.OptionButtons.IsWaitingForGossipShow = true
						Callback.OptionButtons.IsTTSPlayback = { ["playback"] = false, ["button"] = nil }
					end
				end
			end

			do -- EVENTS
				local Events = CreateFrame("Frame")
				Events:RegisterEvent("GOSSIP_SHOW")
				Events:RegisterEvent("VOICE_CHAT_TTS_PLAYBACK_FINISHED")
				Events:SetScript("OnEvent", function(self, event, ...)
					if event == "GOSSIP_SHOW" then
						if Callback.OptionButtons.IsWaitingForGossipShow then
							Callback.OptionButtons:Finish()
						end
					end

					if event == "VOICE_CHAT_TTS_PLAYBACK_FINISHED" then
						if Callback.OptionButtons.IsTTSPlayback.playback then
							if Callback.OptionButtons.IsTTSPlayback.button then
								Callback.OptionButtons.IsTTSPlayback.button.SelectOption()
							end

							--------------------------------

							Callback.OptionButtons.IsWaitingForGossipShow = true
							Callback.OptionButtons.IsTTSPlayback = { ["playback"] = true, ["button"] = nil }
						end
					end
				end)

				--------------------------------

				CallbackRegistry:Add("GOSSIP_BUTTON_CLICKED", function(button)
					Callback.OptionButtons:Click(button)
				end, 0)

				CallbackRegistry:Add("STOP_PROMPT", function()
					if Callback.OptionButtons.IsWaitingForGossipShow then
						Callback.OptionButtons:Finish()
					end
				end)
			end
		end

		do -- MOUSE RESPONDER
			Frame.REF_MOUSE_RESPONDER:SetScript("OnMouseUp", function(self, button)
				if addon.Database.DB_GLOBAL.profile.INT_FLIPMOUSE == false and button == "RightButton" then
					InteractionFrame.DialogFrame:ReturnToPreviousDialog()
				elseif addon.Database.DB_GLOBAL.profile.INT_FLIPMOUSE == true and button == "LeftButton" then
					InteractionFrame.DialogFrame:ReturnToPreviousDialog()
				end
			end)
		end
	end

	--------------------------------
	-- FUNCTIONS (DATA)
	--------------------------------

	do
		do -- SET
			local function ApplyCustomTextColor(text)
				local new = text

				--------------------------------

				do                                                     -- RED
					local count
					new, count = gsub(new, "|[cC][fF][fF][fF][fF]0000", "|cffFF8181") -- cffFF0000

					--------------------------------

					if count == 0 then
						new, count = gsub(new, "|cnRED_FONT_COLOR:", "|cffFF8181")
					end
				end

				do                                              -- BLUE
					new = gsub(new, "|[cC][fF][fF]0000[fF][fF]", "|cff8DC0FF") -- cff0000FF
					new = gsub(new, "|[cC][fF][fF]0008[eE]8", "|cff8DC0FF") -- cff0008E8
				end

				--------------------------------

				return new
			end

			function Frame:UpdateOptions(hideButtons)
				if not GossipFrame:IsVisible() and not QuestFrameGreetingPanel:IsVisible() then
					return
				end

				--------------------------------

				local buttons = Frame:GetAllButtons()

				local availableQuests = C_GossipInfo.GetAvailableQuests()
				local activeQuests = C_GossipInfo.GetActiveQuests()
				local options = C_GossipInfo.GetOptions()

				local entries = {}
				local currentIndex = 0

				--------------------------------

				do -- ENTRIES
					do -- GET (GOSSIP)
						if addon.Interaction.Variables.CurrentSession.type == "gossip" then
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
									local result

									--------------------------------

									if addon.Variables.IS_WOW_VERSION_RETAIL then
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

					do -- GET (QUEST GREETING)
						if addon.Interaction.Variables.CurrentSession.type == "quest-greeting" then
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
									local result

									--------------------------------

									if addon.Variables.IS_WOW_VERSION_RETAIL then
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
									local result

									--------------------------------

									if addon.Variables.IS_WOW_VERSION_RETAIL then
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

					do -- SORT
						table.sort(entries, function(a, b)
							local flagOrder = { ["complete"] = 0, ["available"] = 1, ["active"] = 2, ["option"] = 3 }
							if a.flag == b.flag then
								return a.optionIndex < b.optionIndex
							else
								return flagOrder[a.flag] < flagOrder[b.flag]
							end
						end)
					end
				end

				do -- SET
					if buttons then
						for i = 1, #buttons do
							buttons[i]:Hide()
						end

						for i = 1, #entries do
							local currentButton = buttons[i]

							--------------------------------

							if not hideButtons then
								currentButton:Show()
							end

							--------------------------------

							currentButton.optionFrame = entries[i].optionFrame
							currentButton.optionType = entries[i].optionType
							currentButton.optionID = entries[i].optionID
							currentButton.orderIndex = entries[i].orderIndex
							currentButton.optionIndex = entries[i].optionIndex

							--------------------------------

							do -- SET
								do -- TEXT
									local text = entries[i].title or entries[i].name

									--------------------------------

									do -- COLOR
										text = ApplyCustomTextColor(text)
									end

									do -- TRIGGER ICON
										text = (string.gsub(text, L["GossipData - Trigger - Quest"], addon.API.Util:InlineIcon(addon.Variables.PATH_ART .. "Icons/trigger-quest.png", 25, 64, 0, 0)))
										text = (string.gsub(text, L["GossipData - Trigger - Movie 1"], addon.API.Util:InlineIcon(addon.Variables.PATH_ART .. "Icons/trigger-movie.png", 25, 64, 0, 0)))
										text = (string.gsub(text, L["GossipData - Trigger - Movie 2"], addon.API.Util:InlineIcon(addon.Variables.PATH_ART .. "Icons/trigger-movie.png", 25, 64, 0, 0)))
										text = (string.gsub(text, L["GossipData - Trigger - NPC Dialog"], addon.API.Util:InlineIcon(addon.Variables.PATH_ART .. "Icons/trigger-npcdialog.png", 12.5, 12.5, 0, 0) .. " " .. L["GossipData - Trigger - NPC Dialog - Append"]))
									end

									--------------------------------

									currentButton:SetText(text)
								end

								do -- CONTEXT ICON
									local gossipOptionTexture = entries[i].optionType == "option" and options[entries[i].optionIndex].icon
									local _, texture = addon.ContextIcon.Script:GetContextIcon(entries[i], gossipOptionTexture)

									--------------------------------

									currentButton:SetContextIcon(texture)
								end

								do -- KEYBIND
									currentButton:SetKeybindTextFromIndex(i)
								end
							end

							--------------------------------

							currentButton:UpdateLayout()
						end
					end
				end

				--------------------------------

				NS.Variables.NumCurrentButtons = #entries

				--------------------------------

				CallbackRegistry:Trigger("GOSSIP_DATA_LOADED")
			end

			function Frame:RefreshOptions(hideButtons)
				local chain = addon.API.Util:AddMethodChain({ "onFinish" })

				--------------------------------

				if addon.Interaction.Variables.Active then
					CallbackRegistry:Trigger("UPDATE_GOSSIP")
				end

				--------------------------------

				addon.Libraries.AceTimer:ScheduleTimer(function()
					Frame:UpdateOptions(hideButtons)

					--------------------------------

					if addon.Interaction.Variables.Active then
						CallbackRegistry:Trigger("UPDATE_GOSSIP_READY")
					end

					if chain.onFinish.variable then
						chain.onFinish.variable()
					end
				end, 0)

				--------------------------------

				return { onFinish = chain.onFinish.set }
			end
		end

		do -- GET
			function Frame:GetButtons()
				if NS.Variables.Buttons == nil then
					return
				end

				--------------------------------

				local CurrentButtons = {}

				for i = 1, NS.Variables.NumCurrentButtons do
					table.insert(CurrentButtons, NS.Variables.Buttons[i])
				end

				--------------------------------

				return CurrentButtons
			end

			function Frame:GetAllButtons()
				if NS.Variables.Buttons == nil then
					return
				end

				--------------------------------

				return NS.Variables.Buttons
			end
		end
	end

	--------------------------------
	-- FUNCTIONS (FRAME)
	--------------------------------

	do
		function Frame:UpdateAll()
			Frame:UpdateOptions()
			Frame:UpdateLayout()
			Frame:UpdateFocus()
		end

		function Frame:UpdateLayout()
			CallbackRegistry:Trigger("LayoutGroupSort Gossip.Content.Main")
			CallbackRegistry:Trigger("LayoutGroupSort Gossip.Content")

			--------------------------------

			Frame.Content:UpdatePosition()
		end
	end

	--------------------------------
	-- FUNCTIONS (ANIMATION)
	--------------------------------

	do
		do -- BUTTONS
			function Frame:ShowButtonsWithAnimation()
				local Buttons = Frame:GetButtons()

				--------------------------------

				if Buttons then
					if NS.Variables.NumCurrentButtons >= 1 then
						for i = 1, NS.Variables.NumCurrentButtons do
							local currentButton = Buttons[i]
							local delay = .0125 * i

							--------------------------------

							currentButton:ShowWithAnimation_Pre()

							--------------------------------

							addon.Libraries.AceTimer:ScheduleTimer(function()
								currentButton:ShowWithAnimation()
							end, delay)
						end

						--------------------------------

						Frame.REF_FOOTER_CONTENT_GOODBYE:SetAlpha(.5)
					else
						Frame.REF_FOOTER_CONTENT_GOODBYE:SetAlpha(1)
					end
				end

				--------------------------------

				addon.Libraries.AceTimer:ScheduleTimer(Frame.UpdateLayout, 1)
			end
		end

		do -- FRAME
			do -- SHOW
				function Frame:ShowWithAnimation_StopEvent()
					return Frame.hidden
				end

				function Frame:ShowWithAnimation(bypass)
					if not Frame.hidden and not bypass then
						return
					end
					Frame.hidden = false
					Frame:Show()

					--------------------------------

					addon.API.Animation:Fade(Frame, .25, 0, 1, nil, Frame.ShowWithAnimation_StopEvent)

					--------------------------------

					Frame:RefreshOptions(true).onFinish(function()
						Frame:UpdateAll()
						Frame:ShowButtonsWithAnimation()
					end)

					--------------------------------

					NS.Variables.CurrentSession.npc = UnitName("npc") or UnitName("questnpc")
				end
			end

			do -- HIDE
				function Frame:HideWithAnimation_StopEvent()
					return not Frame.hidden
				end

				function Frame:HideWithAnimation(bypass)
					if Frame.hidden and not bypass then
						return
					end
					Frame.hidden = true

					addon.Libraries.AceTimer:ScheduleTimer(function()
						if Frame.hidden then
							Frame:Hide()
						end
					end, .125)

					--------------------------------

					addon.API.Animation:Fade(Frame, .125, Frame:GetAlpha(), 0, nil, Frame.HideWithAnimation_StopEvent)

					--------------------------------

					NS.Variables.CurrentSession.npc = nil
				end
			end

			do -- REFRESH
				do -- START
					function Frame:RefreshWithAnimation_Start_StopEvent()
						return Frame.hidden
					end

					function Frame:RefreshWithAnimation_Start()
						local isGossipOrQuestGreetingStillVisible = (GossipFrame:IsVisible() or QuestFrameGreetingPanel:IsVisible())

						--------------------------------

						if isGossipOrQuestGreetingStillVisible then
							NS.Variables.RefreshInProgress = true

							--------------------------------

							addon.API.Animation:Fade(Frame, .125, Frame:GetAlpha(), 0, nil, Frame.RefreshWithAnimation_Start_StopEvent)
						end
					end
				end

				do -- END
					function Frame:RefreshWithAnimation_End_StopEvent()
						return Frame.hidden
					end

					function Frame:RefreshWithAnimation_End()
						NS.Variables.RefreshInProgress = false

						--------------------------------

						local isGossipOrQuestGreetingStillVisible = (GossipFrame:IsVisible() or QuestFrameGreetingPanel:IsVisible())

						--------------------------------

						if isGossipOrQuestGreetingStillVisible then
							addon.Libraries.AceTimer:ScheduleTimer(function()
								if not Frame:RefreshWithAnimation_End_StopEvent() then
									addon.API.Animation:Fade(Frame, .125, Frame:GetAlpha(), 1, nil, Frame.RefreshWithAnimation_End_StopEvent)
								end
							end, .125)

							Frame:RefreshOptions().onFinish(function()
								Frame:UpdateAll()
								Frame:ShowButtonsWithAnimation()
							end)
						end
					end
				end
			end
		end
	end

	--------------------------------
	-- FUNCTIONS (FOCUS)
	--------------------------------

	do
		function Frame:OnEnter()
			Frame.mouseOver = true

			--------------------------------

			Frame:UpdateFocus()
		end

		function Frame:OnLeave()
			Frame.mouseOver = false

			--------------------------------

			Frame:UpdateFocus()
		end

		function Frame:UpdateFocus()
			if not addon.Input.Variables.IsController then
				local IsMouseOver = (Frame.mouseOver)
				local IsInDialog = (not InteractionFrame.DialogFrame.hidden)

				--------------------------------

				if IsInDialog and not IsMouseOver then
					Frame.focused = false
				else
					Frame.focused = true
				end

				--------------------------------

				if Frame.focused then
					addon.API.Animation:Fade(InteractionFrame.GossipParent, .25, InteractionFrame.GossipParent:GetAlpha(), 1, nil, function() return not Frame.focused end)
				else
					addon.API.Animation:Fade(InteractionFrame.GossipParent, .25, InteractionFrame.GossipParent:GetAlpha(), .75, nil, function() return Frame.focused end)
				end
			else
				InteractionFrame.GossipParent:SetAlpha(1)
			end
		end

		addon.API.FrameTemplates:CreateMouseResponder(Frame, { enterCallback = Frame.OnEnter, leaveCallback = Frame.OnLeave })
	end

	--------------------------------
	-- SETTINGS
	--------------------------------

	do
		local function Settings_UIDirection()
			local usableWidth = InteractionFrame.GossipParent:GetWidth()
			local frameWidth = 325
			local dialogMaxWidth = 350

			local quarterWidth = (usableWidth - dialogMaxWidth) / 2
			local quarterEdgePadding = (quarterWidth - frameWidth) / 2
			local offsetX

			Frame:ClearAllPoints()
			if addon.Database.DB_GLOBAL.profile.INT_UIDIRECTION == 1 then
				offsetX = quarterEdgePadding

				--------------------------------

				Frame:SetPoint("LEFT", InteractionFrame.GossipParent, offsetX, 0)
			else
				offsetX = usableWidth - frameWidth - quarterEdgePadding

				--------------------------------

				Frame:SetPoint("LEFT", InteractionFrame.GossipParent, offsetX, 0)
			end
		end
		Settings_UIDirection()

		--------------------------------

		CallbackRegistry:Add("SETTINGS_UIDIRECTION_CHANGED", Settings_UIDirection, 0)
	end

	--------------------------------
	-- EVENTS
	--------------------------------

	do
		hooksecurefunc(Frame, "Show", function()
			NS.Variables.RefreshInProgress = false

			--------------------------------

			CallbackRegistry:Trigger("START_GOSSIP")
		end)

		hooksecurefunc(Frame, "Hide", function()
			NS.Variables.RefreshInProgress = false

			--------------------------------

			CallbackRegistry:Trigger("STOP_GOSSIP")
		end)

		local Events = CreateFrame("Frame")
		Events:RegisterEvent("QUEST_LOG_UPDATE")
		Events:SetScript("OnEvent", function(self, event, ...)
			if event == "QUEST_LOG_UPDATE" then
				if not NS.Variables.RefreshInProgress then
					Frame:UpdateOptions()
				end
			end
		end)
	end
end
