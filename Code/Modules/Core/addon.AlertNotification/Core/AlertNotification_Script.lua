local addonName, addon = ...
local CallbackRegistry = addon.CallbackRegistry
local L = addon.Locales
local NS = addon.AlertNotification

--------------------------------

NS.Script = {}

--------------------------------

function NS.Script:Load()
	--------------------------------
	-- REFERENCES
	--------------------------------

	local Frame = InteractionAlertNotificationFrame
	local Callback = NS.Script

	--------------------------------
	-- FUNCTIONS (BUTTON)
	--------------------------------

	do

	end

	--------------------------------
	-- FUNCTIONS (FRAME)
	--------------------------------

	do
		function Callback:ShowWithText(text)
			Frame.Text:SetText(text)

			--------------------------------

			Frame.ShowWithAnimation()
			addon.Libraries.AceTimer:ScheduleTimer(function() Frame.HideWithAnimation() end, 2)
		end
	end

	--------------------------------
	-- FUNCTIONS (ANIMATION)
	--------------------------------

	do
		Frame.ShowWithAnimation = function()
			local AnimationID = GetTime()
			Frame.AnimationID = AnimationID

			--------------------------------

			Frame:Show()

			--------------------------------

			Frame.Text:SetAlpha(0)
			Frame:SetScale(1)

			--------------------------------

			AdaptiveAPI.Animation:Fade(Frame, .5, 0, 1, nil, function() return Frame.AnimationID ~= AnimationID end)

			addon.Libraries.AceTimer:ScheduleTimer(function()
				AdaptiveAPI.Animation:FadeText(Frame.Text, 1.5, 15, 1, AdaptiveAPI.Animation.EaseExpo, function() return Frame.AnimationID ~= AnimationID end)
			end, .2)

			--------------------------------

			Frame.Flare.PlayAnimation()

			--------------------------------

			addon.SoundEffects:PlaySoundFile(addon.SoundEffects.AlertNotification_Show)
		end

		Frame.HideWithAnimation = function()
			local AnimationID = Frame.AnimationID

			--------------------------------

			addon.Libraries.AceTimer:ScheduleTimer(function()
				if Frame.AnimationID == AnimationID then
					Frame:Hide()
				end
			end, .5)

			--------------------------------

			AdaptiveAPI.Animation:Fade(Frame.Text, .5, 1, 0, nil, function() return Frame.AnimationID ~= AnimationID end)
			AdaptiveAPI.Animation:Fade(Frame, .5, 1, 0, nil, function() return Frame.AnimationID ~= AnimationID end)

			--------------------------------

			addon.SoundEffects:PlaySoundFile(addon.SoundEffects.AlertNotification_Hide)
		end

		Frame.Flare.PlayAnimation = function()
			local AnimationID = GetTime()
			Frame.Flare.AnimationID = AnimationID

			--------------------------------

			Frame.Flare:Show()
			Frame.Flare:SetAlpha(0)
			Frame.Flare:SetScale(.1)

			--------------------------------

			AdaptiveAPI.Animation:Fade(Frame.Flare, .125, 0, 1, AdaptiveAPI.Animation.EaseExpo, function() return Frame.Flare.AnimationID ~= AnimationID end)
			AdaptiveAPI.Animation:Scale(Frame.Flare, .125, .875, 1, function() return Frame.Flare.AnimationID ~= AnimationID end)

			addon.Libraries.AceTimer:ScheduleTimer(function()
				if Frame.Flare.AnimationID == AnimationID then
					AdaptiveAPI.Animation:Fade(Frame.Flare, 2, 1, 0, AdaptiveAPI.Animation.EaseExpo, function() return Frame.Flare.AnimationID ~= AnimationID end)
					AdaptiveAPI.Animation:Scale(Frame.Flare, 2, 1, .875, nil, AdaptiveAPI.Animation.EaseExpo, function() return Frame.Flare.AnimationID ~= AnimationID end)
				end
			end, .125)

			addon.Libraries.AceTimer:ScheduleTimer(function()
				if Frame.Flare.AnimationID == AnimationID then
					Frame.Flare:Hide()
				end
			end, 2)
		end
	end

	--------------------------------
	-- SETTINGS
	--------------------------------

	do
		local function Settings_UIDirection()
			Frame:ClearAllPoints()
			if INTDB.profile.INT_UIDIRECTION == 1 then
				Frame:SetPoint("TOPLEFT", UIParent, 25, -25)
			else
				Frame:SetPoint("TOPRIGHT", UIParent, -25, -25)
			end
		end
		Settings_UIDirection()

		--------------------------------

		CallbackRegistry:Add("SETTINGS_UIDIRECTION_CHANGED", Settings_UIDirection, 2)
	end

	--------------------------------
	-- FUNCTIONS (EVENT)
	--------------------------------

	do
		local Events = CreateFrame("Frame")
		Events:RegisterEvent("QUEST_ACCEPTED")
		Events:RegisterEvent("QUEST_TURNED_IN")
		Events:SetScript("OnEvent", function(self, event, ...)
			do -- QUEST
				local isQuestFrameVisible = (InteractionQuestFrame.validForNotification)

				if not isQuestFrameVisible then
					return
				end

				--------------------------------

				if event == "QUEST_ACCEPTED" then
					Callback:ShowWithText(L["Alert Notification - Accept"])
				end

				if event == "QUEST_TURNED_IN" then
					Callback:ShowWithText(L["Alert Notification - Complete"])
				end
			end
		end)
	end

	--------------------------------
	-- SETUP
	--------------------------------
end
