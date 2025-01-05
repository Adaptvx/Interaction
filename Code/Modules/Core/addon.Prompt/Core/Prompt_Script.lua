local addonName, addon = ...
local CallbackRegistry = addon.CallbackRegistry
local L = addon.Locales
local NS = addon.Prompt

--------------------------------

NS.Script = {}

--------------------------------

function NS.Script:Load()
	--------------------------------
	-- FUNCTIONS (BUTTONS)
	--------------------------------

	do
		InteractionPromptFrame.Content.ButtonArea.Button1:SetScript("OnClick", function()
			NS.Variables.Button1Callback()
		end)

		InteractionPromptFrame.Content.ButtonArea.Button2:SetScript("OnClick", function()
			NS.Variables.Button2Callback()
		end)
	end

	--------------------------------
	-- FUNCTIONS (FRAME)
	--------------------------------

	do
		InteractionPromptFrame.Set = function(text, button1Text, button2Text, button1Callback, button2Callback, button1Active, button2Active)
			NS.Variables.Text = text
			NS.Variables.Button1Text = button1Text
			NS.Variables.Button2Text = button2Text
			NS.Variables.Button1Callback = button1Callback
			NS.Variables.Button2Callback = button2Callback
			addon.Prompt.Button1Active = button1Active
			addon.Prompt.Button2Active = button2Active

			--------------------------------

			InteractionPromptFrame.Content.TextArea.Text:SetText(NS.Variables.Text)
			InteractionPromptFrame.Content.ButtonArea.Button1:SetText(NS.Variables.Button1Text)
			InteractionPromptFrame.Content.ButtonArea.Button2:SetText(NS.Variables.Button2Text)

			addon.API:SetButtonToPlatform(InteractionPromptFrame.Content.ButtonArea.Button1, nil, addon.Input.Variables:GetKeybindForPlatform(addon.Input.Variables.Key_Prompt_Accept))
			addon.API:SetButtonToPlatform(InteractionPromptFrame.Content.ButtonArea.Button2, nil, addon.Input.Variables:GetKeybindForPlatform(addon.Input.Variables.Key_Prompt_Decline))

			InteractionPromptFrame.Content.ButtonArea.Button1.SetActive(addon.Prompt.Button1Active)
			InteractionPromptFrame.Content.ButtonArea.Button2.SetActive(addon.Prompt.Button2Active)

			--------------------------------

			if not InteractionPromptFrame.hidden then
				InteractionPromptFrame.hidden = true
			end

			InteractionPromptFrame.ShowWithAnimation()

			--------------------------------

			CallbackRegistry:Trigger("START_PROMPT")

			--------------------------------

			addon.SoundEffects:PlaySoundFile(addon.SoundEffects.Prompt_Show)
		end

		InteractionPromptFrame.Clear = function()
			NS.Variables.Text = nil
			NS.Variables.Button1Text = nil
			NS.Variables.Button2Text = nil
			NS.Variables.Button1Callback = nil
			NS.Variables.Button2Callback = nil
			addon.Prompt.Button1Active = nil
			addon.Prompt.Button2Active = nil

			--------------------------------

			InteractionPromptFrame.HideWithAnimation()

			--------------------------------

			CallbackRegistry:Trigger("STOP_PROMPT")

			--------------------------------

			addon.SoundEffects:PlaySoundFile(addon.SoundEffects.Prompt_Hide)
		end
	end

	--------------------------------
	-- FUNCTIONS (ANIMATION)
	--------------------------------

	do
		InteractionPromptFrame.ShowWithAnimation = function()
			if not InteractionPromptFrame.hidden then
				return
			end

			--------------------------------

			InteractionPromptFrame:Show()
			InteractionPromptFrame.hidden = false

			--------------------------------

			AdaptiveAPI.Animation:Fade(InteractionPromptFrame, .25, 0, 1, nil, function() return InteractionPromptFrame.hidden end)
			AdaptiveAPI.Animation:Move(InteractionPromptFrame, .5, "TOP", 25, -35, "y", AdaptiveAPI.Animation.EaseExpo, function() return InteractionPromptFrame.hidden end)

			AdaptiveAPI.Animation:Fade(InteractionPromptFrame.Content.ButtonArea.Button1, .25, 0, 1, nil, function() return InteractionPromptFrame.hidden end)
			AdaptiveAPI.Animation:Fade(InteractionPromptFrame.Content.ButtonArea.Button2, .25, 0, 1, nil, function() return InteractionPromptFrame.hidden end)
		end

		InteractionPromptFrame.HideWithAnimation = function()
			if InteractionPromptFrame.hidden then
				return
			end

			--------------------------------

			addon.Libraries.AceTimer:ScheduleTimer(function()
				if InteractionPromptFrame.hidden then
					InteractionPromptFrame:Hide()
				end
			end, .5)

			InteractionPromptFrame.hidden = true

			--------------------------------

			AdaptiveAPI.Animation:Fade(InteractionPromptFrame, .25, InteractionPromptFrame:GetAlpha(), 0, nil, function() return not InteractionPromptFrame.hidden end)
			AdaptiveAPI.Animation:Move(InteractionPromptFrame, .5, "TOP", -35, 5, "y", AdaptiveAPI.Animation.EaseExpo, function() return not InteractionPromptFrame.hidden end)

			AdaptiveAPI.Animation:Fade(InteractionPromptFrame.Content.ButtonArea.Button1, .25, InteractionPromptFrame.Content.ButtonArea.Button1:GetAlpha(), 0, nil, function() return not InteractionPromptFrame.hidden end)
			AdaptiveAPI.Animation:Fade(InteractionPromptFrame.Content.ButtonArea.Button2, .25, InteractionPromptFrame.Content.ButtonArea.Button2:GetAlpha(), 0, nil, function() return not InteractionPromptFrame.hidden end)
		end
	end

	--------------------------------
	-- EVENTS
	--------------------------------

	do
		local GossipEvents = CreateFrame("Frame")
		GossipEvents:RegisterEvent("GOSSIP_CONFIRM")
		GossipEvents:RegisterEvent("GOSSIP_CLOSED")
		GossipEvents:SetScript("OnEvent", function(self, event, ...)
			if event == "GOSSIP_CONFIRM" then
				local gossipID, text, cost = ...

				--------------------------------

				local Popups = {
					"StaticPopup1",
					"StaticPopup2"
				}

				--------------------------------

				local function GetPopup()
					local frame

					--------------------------------

					for i = 1, #Popups do
						if _G[Popups[i] .. "Text"]:GetText() == text then
							frame = Popups[i]
						end
					end

					--------------------------------

					return frame
				end

				--------------------------------

				local DesiredPopup = GetPopup()
				local Popup = _G[DesiredPopup]
				local Text = _G[DesiredPopup .. "Text"]:GetText()
				local Button1 = _G[DesiredPopup .. "Button1"]
				local Button2 = _G[DesiredPopup .. "Button2"]

				--------------------------------

				local FormattedText
				if cost and cost > 0 then
					local gold, silver, copper = AdaptiveAPI:FormatMoney(cost)

					--------------------------------

					local text_gold, text_silver, text_copper

					--------------------------------

					if gold > 0 then
						text_gold = AdaptiveAPI:InlineIcon(addon.Variables.PATH .. "Art/Icons/gold.png", 20, 20, 0, 0) .. "" .. gold .. " "
					end

					if silver > 0 then
						text_silver = AdaptiveAPI:InlineIcon(addon.Variables.PATH .. "Art/Icons/silver.png", 20, 20, 0, 0) .. "" .. silver .. " "
					end

					if copper > 0 then
						text_copper = AdaptiveAPI:InlineIcon(addon.Variables.PATH .. "Art/Icons/copper.png", 20, 20, 0, 0) .. "" .. copper .. " "
					end

					--------------------------------

					FormattedText = Text .. "\n\n" .. (text_gold or "") .. (text_silver or "") .. (text_copper or "") .. "\n"
				else
					FormattedText = Text
				end

				--------------------------------

				InteractionPromptFrame.Set(FormattedText, Button1:GetText(), Button2:GetText(), function()
					Button1:Click(); InteractionPromptFrame.Clear()
				end, function()
					Button2:Click(); InteractionPromptFrame.Clear()
				end, true, false)

				--------------------------------

				-- Hide Interaction Prompt Frame when the Popup is shown to prevent
				-- the visible prompt buttons to interact with unrelated actions

				-- Example: Interaction Prompt for Skipping quest-chain and clicking Exit Game which
				-- will cause the "Skip" button to click on the "Exit Game" button.

				if not Popup.hookedFunc then
					Popup.hookedFunc = true

					hooksecurefunc(Popup, "Show", function()
						Popup:SetAlpha(1)
						InteractionPromptFrame.Clear()
					end)
				end

				--------------------------------

				Popup:SetAlpha(0)
			end

			if event == "GOSSIP_CLOSED" then
				InteractionPromptFrame.Clear()
			end
		end)
	end

	--------------------------------
	-- SETUP
	--------------------------------

	do

	end
end
