local addonName, addon = ...
local CallbackRegistry = addon.CallbackRegistry
local L = addon.Locales
local NS = addon.Interaction.Gossip

--------------------------------

NS.Script = {}

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

				AdaptiveAPI.Animation:Fade(Frame, .25, 1, 0)
			end

			local function Finish(button)
				local IsInGossipOrQuestGreeting = (GossipFrame:IsVisible() or QuestFrameGreetingPanel:IsVisible())

				--------------------------------

				if IsInGossipOrQuestGreeting then
					AdaptiveAPI.Animation:Fade(Frame, .25, 0, 1)
					Frame:UpdateButtons()
				end

				--------------------------------

				addon.Libraries.AceTimer:ScheduleTimer(function()
					if Frame.SelectedOptionTransition then
						Frame.SelectedOptionTransition = false
					end
				end, .25)

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

				addon.TextToSpeech.Script:Speak(INTDB.profile.INT_TTS_PLAYER_VOICE, string)
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
					end, 1)
				else
					button.Callback:Click()

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
							IsTTSPlayback.button.Callback:Click()
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

		Frame.SetButtons = function(callbacks)
			local NumAvailableQuests = GetNumAvailableQuests()
			local NumActiveQuests = GetNumActiveQuests()
			local NumAvailableOptions = #C_GossipInfo.GetOptions()

			NS.Variables.NumCurrentButtons = #callbacks

			--------------------------------

			local Buttons = Frame.GetAllButtons()
			if Buttons then
				for i = 1, #Buttons do
					Buttons[i]:Hide()
				end

				for i = 1, #callbacks do
					Buttons[i]:Show()
					Buttons[i].Callback = callbacks[i]

					addon.Libraries.AceTimer:ScheduleTimer(function()
						Buttons[i].UpdatePosition()
					end, 0)

					--------------------------------

					local LabelText = AdaptiveAPI:GetUnformattedText(callbacks[i].Label:GetText())

					--------------------------------

					local function AddTriggerIcons()
						LabelText = (string.gsub(LabelText, L["GossipData - Trigger - Quest"], AdaptiveAPI:InlineIcon(addon.Variables.PATH .. "Art/ContextIcons/trigger-quest.png", 25, 64, 0, 0)))
						LabelText = (string.gsub(LabelText, L["GossipData - Trigger - Movie 1"], AdaptiveAPI:InlineIcon(addon.Variables.PATH .. "Art/ContextIcons/trigger-movie.png", 25, 64, 0, 0)))
						LabelText = (string.gsub(LabelText, L["GossipData - Trigger - Movie 2"], AdaptiveAPI:InlineIcon(addon.Variables.PATH .. "Art/ContextIcons/trigger-movie.png", 25, 64, 0, 0)))
						LabelText = (string.gsub(LabelText, L["GossipData - Trigger - NPC Dialog"], AdaptiveAPI:InlineIcon(addon.Variables.PATH .. "Art/ContextIcons/trigger-npcdialog.png", 12.5, 12.5, 0, 0) .. " " .. L["GossipData - Trigger - NPC Dialog - Subtext 1"]))
					end

					--------------------------------

					AddTriggerIcons()

					--------------------------------

					Buttons[i].Label:SetText(LabelText)
					Buttons[i]:SetHeight(Buttons[i].Label:GetStringHeight() + NS.Variables:RATIO(.5))

					--------------------------------

					local function UpdateContextIcon()
						local _, texture = addon.ContextIcon.Script:GetContextIcon(i)

						if not texture then
							local icon = callbacks[i].Icon
							if icon.GetAtlas and icon:GetAtlas() ~= nil then
								texture = icon:GetAtlas()
								local replaced = addon.ContextIcon.Script:ReplaceIcon(texture)

								--------------------------------

								if replaced then
									Buttons[i].IconTexture:SetTexture(replaced)
								else
									Buttons[i].IconTexture:SetAtlas(texture)
								end

								--------------------------------

								Buttons[i].texture = replaced or texture
							else
								texture = icon:GetTexture()
								local replaced = addon.ContextIcon.Script:ReplaceIcon(texture)

								--------------------------------

								if replaced then
									Buttons[i].IconTexture:SetTexture(replaced)
								else
									Buttons[i].IconTexture:SetTexture(texture)
								end

								--------------------------------

								Buttons[i].texture = replaced or texture
							end
						else
							Buttons[i].IconTexture:SetTexture(texture)

							--------------------------------

							Buttons[i].texture = texture
						end
					end

					--------------------------------

					UpdateContextIcon()

					addon.Libraries.AceTimer:ScheduleTimer(function()
						UpdateContextIcon()
					end, .25)

					if i <= 18 then
						if i <= 9 then
							Buttons[i].Keybind.Label:SetScale(1)
							Buttons[i].Keybind.Label:SetText(i .. ".")
						else
							Buttons[i].Keybind.Label:SetScale(.75)
							Buttons[i].Keybind.Label:SetText("S" .. i - 9 .. ".")
						end
					end
				end
			end

			--------------------------------

			local TotalHeight = 0

			for i = 1, NS.Variables.NumCurrentButtons do
				TotalHeight = TotalHeight + Buttons[i]:GetHeight()
			end

			if #callbacks >= 1 then
				Frame:SetSize(325, (TotalHeight) + 25 + (NS.Variables.PADDING + Frame.GoodbyeButton:GetHeight()))
			else
				Frame:SetSize(150, 50)
			end

			--------------------------------

			-- Temporarily disabled due to FadeText bug.
			-- Frame.StartButtonSequence()

			--------------------------------

			CallbackRegistry:Trigger("GOSSIP_DATA_LOADED")
		end

		Frame.UpdateButtons = function()
			if addon.Interaction.Variables.Active then
				CallbackRegistry:Trigger("UPDATE_GOSSIP")
			end

			--------------------------------

			if GossipFrame:IsVisible() then
				Frame.SetButtons(addon.Get.Blizzard_GossipButtons())
			end

			if QuestFrameGreetingPanel:IsVisible() then
				Frame.SetButtons(addon.Get.Blizzard_QuestButtons())
			end

			--------------------------------

			if addon.Interaction.Variables.Active then
				CallbackRegistry:Trigger("UPDATE_GOSSIP_READY")
			end
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
		Frame.UpdatePosition = function()
			local Nameplate = C_NamePlate.GetNamePlateForUnit("npc")
			local PlayerNameplate = C_NamePlate.GetNamePlateForUnit("player")

			--------------------------------

			local Settings_UIDirection = INTDB.profile.INT_UIDIRECTION
			local Settings_AlwaysShowGossipFrame = INTDB.profile.INT_ALWAYS_SHOW_GOSSIP

			local IsInDialog = (InteractionDialogFrame:IsVisible())
			local IsDynamicView = (tonumber(GetCVar("test_cameraDynamicPitch")) > 0 or tonumber(GetCVar("test_cameraOverShoulder")) > 0 or tostring(GetCVar("test_cameraTargetFocusInteractEnable")) == "1")
			local IsStaticNPC = (not (Nameplate and Nameplate ~= PlayerNameplate))
			local IsDialogOutOfScreen = (addon.API:GetScreenHeight() * .5 + Frame:GetHeight() >= addon.API:GetScreenHeight())
			local IsCinematicModeZoomInStandaloneRange = (addon.Cinematic.Variables.IsZooming and INTDB.profile.INT_CINEMATIC_ZOOMIN_DISTANCE <= 8)
			local IsStandaloneZoomRange = (GetCameraZoom() <= 8 or IsCinematicModeZoomInStandaloneRange)
			local IsPersonalNameplateVisible = (tostring(GetCVar("NameplateShowSelf")) ~= "0")

			--------------------------------

			NS.Variables.NPC = UnitName("npc") or ""

			--------------------------------

			local screenWidth = addon.API:GetScreenWidth()
			local frameWidth = Frame:GetWidth()
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

		Frame.UpdateVisibility = function()
			local IsReady = addon.Initialize.Ready
			if not IsReady then
				return
			end

			--------------------------------

			local NumAvailableQuests = GetNumAvailableQuests()
			local NumActiveQuests = GetNumActiveQuests()
			local NumAvailableOptions = #C_GossipInfo.GetOptions()

			--------------------------------

			local Settings_AlwaysShowGossipFrame = INTDB.profile.INT_ALWAYS_SHOW_GOSSIP

			local IsInteractingWithNPC = (UnitName("npc") or UnitName("questnpc"))
			local IsInDialog = (InteractionDialogFrame:IsVisible())
			local IsQuest = (QuestFrame:IsVisible() and not QuestFrameGreetingPanel:IsVisible())
			local IsInGossipOrQuestGreeting = (GossipFrame:IsVisible() or QuestFrameGreetingPanel:IsVisible())
			local IsQuestFrameVisible = (InteractionQuestFrame:IsVisible())

			local IsInitalized = (addon.Interaction.Variables.Active)
			local IsDialogFinished = (addon.Interaction.Dialog.Variables.Finished)

			--------------------------------

			if IsInitalized and IsInteractingWithNPC and IsInGossipOrQuestGreeting and (Settings_AlwaysShowGossipFrame or (not Settings_AlwaysShowGossipFrame and not IsInDialog and IsDialogFinished)) then
				Frame.ShowWithAnimation()
			else
				Frame.HideWithAnimation()
			end
		end

		Frame.UpdateStyle = function()
			local LastNPC = NS.Variables.LastNPC
			local NPC = NS.Variables.NPC

			local Buttons = Frame.GetButtons()

			--------------------------------

			if (LastNPC ~= NPC and NPC ~= "") then
				Frame:SetAlpha(0)
				Frame.GoodbyeButton.Text:SetAlpha(0)

				--------------------------------

				Frame.animation = true
				addon.Libraries.AdaptiveTimer.Script:Schedule(function()
					Frame.animation = false
				end, .5)

				--------------------------------

				addon.Libraries.AdaptiveTimer.Script:Schedule(function()
					if Frame:GetAlpha() < .1 then
						AdaptiveAPI.Animation:Fade(Frame, .25, 0, 1, nil, function() return NPC ~= UnitName("npc") or NPC == "" or Frame.hidden end)
						AdaptiveAPI.Animation:Fade(Frame.GoodbyeButton.Text, .25, 0, 1, nil, function() return Frame.hidden end)
					end
				end, .125)

				--------------------------------

				Frame.UpdateButtons()
				Frame.StartButtonSequence()

				--------------------------------

				for i = 1, #Buttons do
					Buttons[i].HideButtons()
					Buttons[i].Standalone:Show()
				end
			end
		end
	end

	--------------------------------
	-- FUNCTIONS (ANIMATION)
	--------------------------------

	do
		Frame.StartButtonSequence = function()
			local Buttons = Frame.GetButtons()

			--------------------------------

			if Buttons then
				for i = 1, NS.Variables.NumCurrentButtons do
					local button = Buttons[i]

					--------------------------------

					button.transition = true

					--------------------------------

					button.Label:SetAlpha(0)

					--------------------------------

					local valid = true -- Flag to check if button was hidden

					--------------------------------

					if button:IsVisible() then
						button:Show()

						--------------------------------

						AdaptiveAPI.Animation:Fade(button.Label, .25, 0, 1, AdaptiveAPI.Animation.EaseExpo, function()
							if not button:IsVisible() then
								valid = false; return true
							end
						end)

						--------------------------------

						if addon.Variables.Platform == 1 then
							addon.Libraries.AceTimer:ScheduleTimer(function()
								if valid then
									button.transition = false

									--------------------------------

									button:EnableMouse(true)
								end
							end, .325)
						end
					end
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

			AdaptiveAPI.Animation:Fade(Frame, .25, Frame:GetAlpha(), 0, nil, function() return not Frame.hidden end)
		end
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
		Frame.UpdateAll = function()
			NS.Variables.LastNPC = NS.Variables.NPC

			Frame.UpdatePosition()
			Frame.UpdateVisibility()
			Frame.UpdateStyle()
		end

		Frame.MouseResponder:SetScript("OnMouseUp", function(self, button)
			if INTDB.profile.INT_FLIPMOUSE == false and button == "RightButton" then
				InteractionDialogFrame.ReturnToPreviousDialog()
			elseif INTDB.profile.INT_FLIPMOUSE == true and button == "LeftButton" then
				InteractionDialogFrame.ReturnToPreviousDialog()
			end
		end)

		Frame:HookScript("OnShow", function()
			addon.Libraries.AceTimer:ScheduleTimer(function()
				if GossipFrame:IsVisible() then
					Frame.SetButtons(addon.Get.Blizzard_GossipButtons())
				end

				if QuestFrameGreetingPanel:IsVisible() then
					Frame.SetButtons(addon.Get.Blizzard_QuestButtons())

					addon.Libraries.AceTimer:ScheduleTimer(function()
						Frame.SetButtons(addon.Get.Blizzard_QuestButtons())
					end, .1)
				end
			end, .1)
		end)

		--------------------------------

		CallbackRegistry:Add("START_INTERACTION", function()
			Frame.UpdateFocus()
			Frame.SetFocusTransition()

			Frame.UpdateAll()
		end, 0)

		CallbackRegistry:Add("FINISH_DIALOG", function()
			Frame.UpdateFocus()
			Frame.SetFocusTransition()

			Frame.UpdateAll()
		end, 0)

		CallbackRegistry:Add("START_DIALOG", function()
			Frame.UpdateFocus()
			Frame.SetFocusTransition()

			Frame.UpdateAll()
		end, 0)

		CallbackRegistry:Add("PREVIOUS_DIALOG", function()
			Frame.UpdateFocus()
			Frame.SetFocusTransition()

			Frame.UpdateAll()
		end, 0)

		--------------------------------

		function Frame.UpdateFocus()
			local IsFocused = (Frame.Focused)
			local IsMouseOver = (Frame.MouseOver)
			local IsInDialog = (InteractionDialogFrame:IsVisible())

			if IsInDialog and not IsMouseOver then
				Frame.Focused = false
			else
				Frame.Focused = true
			end
		end

		function Frame.SetFocusTransition()
			local IsFocused = (Frame.Focused)
			local IsMouseOver = (Frame.MouseOver)
			local IsInDialog = (InteractionDialogFrame:IsVisible())

			--------------------------------

			if IsFocused then
				AdaptiveAPI.Animation:Fade(InteractionGossipParent, .25, InteractionGossipParent:GetAlpha(), 1, nil, function() return not IsFocused end)
			else
				AdaptiveAPI.Animation:Fade(InteractionGossipParent, .25, InteractionGossipParent:GetAlpha(), .875, nil, function() return IsFocused end)
			end
		end

		--------------------------------

		hooksecurefunc(GossipFrame, "Hide", function()
			Frame.UpdateVisibility()
		end)

		hooksecurefunc(Frame, "Show", function()
			CallbackRegistry:Trigger("START_GOSSIP")
		end)

		hooksecurefunc(Frame, "Hide", function()
			CallbackRegistry:Trigger("STOP_GOSSIP")
		end)

		local Events = CreateFrame("Frame")
		Events:RegisterEvent("PLAYER_TARGET_CHANGED")
		Events:SetScript("OnEvent", function(self, event, ...)
			if event == "PLAYER_TARGET_CHANGED" then
				Frame.UpdateAll()
			end
		end)

		local _ = CreateFrame("Frame", "UpdateFrame/InteractionGossipFrame.lua", nil)
		_:SetScript("OnUpdate", function()
			if not addon.Interaction.Variables.Active and Frame:IsVisible() then
				Frame.UpdateAll()
			end
		end)
	end
end
