---@class addon
local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local PrefabRegistry = addon.PrefabRegistry
local L = addon.Locales
local NS = addon.Prompt; addon.Prompt = NS

--------------------------------

NS.Script = {}

--------------------------------

function NS.Script:Load()
	--------------------------------
	-- REFERENCES
	--------------------------------

	local Frame = InteractionFrame.PromptFrame
	local Callback = NS.Script; NS.Script = Callback

	--------------------------------
	-- FUNCTIONS (BUTTONS)
	--------------------------------

	do
		Frame.REF_BUTTONFRAME_CONTENT.Button1:SetScript("OnClick", function()
			NS.Variables.Button1Callback()
		end)

		Frame.REF_BUTTONFRAME_CONTENT.Button2:SetScript("OnClick", function()
			NS.Variables.Button2Callback()
		end)
	end

	--------------------------------
	-- FUNCTIONS (FRAME)
	--------------------------------

	do
		function Frame:UpdateLayout()
			CallbackRegistry:Trigger("LayoutGroupSort Prompt.Content")
			CallbackRegistry:Trigger("LayoutGroupSort Prompt.Content.ButtonFrame")
		end
	end

	--------------------------------
	-- FUNCTIONS (MAIN)
	--------------------------------

	do
		function Callback:Set(text, button1Text, button2Text, button1Callback, button2Callback, button1Active, button2Active)
			NS.Variables.Text = text or ""
			NS.Variables.Button1Text = button1Text or ""
			NS.Variables.Button2Text = button2Text or ""
			NS.Variables.Button1Callback = button1Callback
			NS.Variables.Button2Callback = button2Callback
			addon.Prompt.Button1Active = button1Active or false
			addon.Prompt.Button2Active = button2Active or false

			--------------------------------

			do -- SET
				Frame.REF_TEXTFRAME.Text:SetText(NS.Variables.Text)

				Callback:SetButton(1, NS.Variables.Button1Text, addon.Prompt.Button1Active)
				Callback:SetButton(2, NS.Variables.Button2Text, addon.Prompt.Button2Active)
				addon.API.Main:SetButtonToPlatform(Frame.REF_BUTTONFRAME_CONTENT.Button1, nil, addon.Input.Variables:GetKeybindForPlatform(addon.Input.Variables.Key_Prompt_Accept))
				addon.API.Main:SetButtonToPlatform(Frame.REF_BUTTONFRAME_CONTENT.Button2, nil, addon.Input.Variables:GetKeybindForPlatform(addon.Input.Variables.Key_Prompt_Decline))
			end

			--------------------------------

			Frame:ShowWithAnimation()
			addon.SoundEffects:PlaySoundFile(addon.SoundEffects.Prompt_Show)

			--------------------------------

			Frame:UpdateLayout()
			CallbackRegistry:Trigger("START_PROMPT")
		end

		function Callback:Clear()
			NS.Variables.Text = nil
			NS.Variables.Button1Text = nil
			NS.Variables.Button2Text = nil
			NS.Variables.Button1Callback = nil
			NS.Variables.Button2Callback = nil
			addon.Prompt.Button1Active = nil
			addon.Prompt.Button2Active = nil

			--------------------------------

			Frame:HideWithAnimation()
			addon.SoundEffects:PlaySoundFile(addon.SoundEffects.Prompt_Hide)

			--------------------------------

			CallbackRegistry:Trigger("STOP_PROMPT")
		end

		function Callback:SetButton(index, text, active)
			Frame.REF_BUTTONFRAME_CONTENT["Button" .. index]:SetText(text)
			Frame.REF_BUTTONFRAME_CONTENT["Button" .. index]:SetActive(active)
		end

		function Callback:ClickButton(index)
			Frame.REF_BUTTONFRAME_CONTENT["Button" .. index]:Click()
		end
	end

	--------------------------------
	-- FUNCTIONS (ANIMATION)
	--------------------------------

	do
		do -- SHOW
			function Frame:ShowWithAnimation_StopEvent()
				return Frame.hidden
			end

			function Frame:ShowWithAnimation()
				if not Frame.hidden then
					return
				end
				Frame.hidden = false
				Frame:Show()

				--------------------------------

				addon.API.Animation:Fade(Frame, .25, 0, 1, nil, Frame.ShowWithAnimation_StopEvent)
				addon.API.Animation:Move(Frame, .5, "TOP", 25, -35, "y", addon.API.Animation.EaseExpo, Frame.ShowWithAnimation_StopEvent)

				addon.API.Animation:Fade(Frame.REF_BUTTONFRAME_CONTENT.Button1, .25, 0, 1, nil, Frame.ShowWithAnimation_StopEvent)
				addon.API.Animation:Fade(Frame.REF_BUTTONFRAME_CONTENT.Button2, .25, 0, 1, nil, Frame.ShowWithAnimation_StopEvent)
			end
		end

		do -- HIDE
			function Frame:HideWithAnimation_StopEvent()
				return not Frame.hidden
			end

			function Frame:HideWithAnimation()
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

				addon.API.Animation:Fade(Frame, .25, Frame:GetAlpha(), 0, nil, Frame.HideWithAnimation_StopEvent)
				addon.API.Animation:Move(Frame, .5, "TOP", -35, 5, "y", addon.API.Animation.EaseExpo, Frame.HideWithAnimation_StopEvent)

				addon.API.Animation:Fade(Frame.REF_BUTTONFRAME_CONTENT.Button1, .25, Frame.REF_BUTTONFRAME_CONTENT.Button1:GetAlpha(), 0, nil, Frame.HideWithAnimation_StopEvent)
				addon.API.Animation:Fade(Frame.REF_BUTTONFRAME_CONTENT.Button2, .25, Frame.REF_BUTTONFRAME_CONTENT.Button2:GetAlpha(), 0, nil, Frame.HideWithAnimation_StopEvent)
			end
		end
	end

	--------------------------------
	-- EVENTS
	--------------------------------

	do
		do -- GOSSIP
			local POPUPS = {
				"StaticPopup1",
				"StaticPopup2"
			}

			local function GetPopup(text)
				local frame

				--------------------------------

				for i = 1, #POPUPS do
					if _G[POPUPS[i] .. "Text"]:GetText() == text then
						frame = POPUPS[i]
					end
				end

				--------------------------------

				return frame
			end


			local GossipEvents = CreateFrame("Frame")
			GossipEvents:RegisterEvent("GOSSIP_CONFIRM")
			GossipEvents:RegisterEvent("GOSSIP_CLOSED")
			GossipEvents:SetScript("OnEvent", function(self, event, ...)
				if event == "GOSSIP_CONFIRM" then
					local gossipID, text, cost = ...

					--------------------------------

					local DesiredPopup = GetPopup(text)
					local Popup = _G[DesiredPopup]
					local Text = _G[DesiredPopup .. "Text"]:GetText()
					local Button1 = _G[DesiredPopup .. "Button1"]
					local Button2 = _G[DesiredPopup .. "Button2"]

					--------------------------------

					local FormattedText
					if cost and cost > 0 then
						local gold, silver, copper = addon.API.Util:FormatMoney(cost)

						--------------------------------

						local text_gold, text_silver, text_copper

						--------------------------------

						if gold > 0 then
							text_gold = addon.API.Util:InlineIcon(addon.Variables.PATH_ART .. "Icons/gold.png", 20, 20, 0, 0) .. "" .. gold .. " "
						end

						if silver > 0 then
							text_silver = addon.API.Util:InlineIcon(addon.Variables.PATH_ART .. "Icons/silver.png", 20, 20, 0, 0) .. "" .. silver .. " "
						end

						if copper > 0 then
							text_copper = addon.API.Util:InlineIcon(addon.Variables.PATH_ART .. "Icons/copper.png", 20, 20, 0, 0) .. "" .. copper .. " "
						end

						--------------------------------

						FormattedText = Text .. "\n\n" .. (text_gold or "") .. (text_silver or "") .. (text_copper or "") .. "\n"
					else
						FormattedText = Text
					end

					--------------------------------

					Callback:Set(FormattedText, Button1:GetText(), Button2:GetText(), function() Button1:Click(); Callback:Clear() end, function() Button2:Click(); Callback:Clear() end, true, false)

					--------------------------------

					-- Hide Interaction Prompt Frame when the Popup is shown to prevent
					-- the visible prompt buttons to interact with unrelated actions

					-- Example: Interaction Prompt for Skipping quest-chain and clicking Exit Game which
					-- will cause the "Skip" button to click on the "Exit Game" button.

					if not Popup.hookedFunc then
						Popup.hookedFunc = true

						hooksecurefunc(Popup, "Show", function()
							Popup:SetAlpha(1)
							Callback:Clear()
						end)
					end

					--------------------------------

					Popup:SetAlpha(0)
				end

				if event == "GOSSIP_CLOSED" then
					Callback:Clear()
				end
			end)
		end
	end

	--------------------------------
	-- SETUP
	--------------------------------

	do

	end
end
