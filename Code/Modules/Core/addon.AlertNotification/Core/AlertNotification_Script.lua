---@class addon
local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local PrefabRegistry = addon.PrefabRegistry
local L = addon.Locales
local NS = addon.AlertNotification; addon.AlertNotification = NS

--------------------------------

NS.Script = {}

--------------------------------

function NS.Script:Load()
	--------------------------------
	-- REFERENCES
	--------------------------------

	local Frame = InteractionFrame.AlertNotification
	local Callback = NS.Script; NS.Script = Callback

	--------------------------------
	-- FUNCTIONS (BUTTONS)
	--------------------------------

	do

	end

	--------------------------------
	-- FUNCTIONS (FRAME)
	--------------------------------

	do
		function Frame:UpdateLayout()
			CallbackRegistry:Trigger("LayoutGroupSort AlertNotification.Notification")
		end
	end

	--------------------------------
	-- FUNCTIONS (MAIN)
	--------------------------------

	do
		function Callback:ShowWithText(text)
			Frame.REF_NOTIFICATION_TEXT:SetText(text)

			--------------------------------

			Frame:ShowWithAnimation()
			addon.Libraries.AceTimer:ScheduleTimer(Frame.HideWithAnimation, 2)

			--------------------------------

			Frame:UpdateLayout()
		end
	end

	--------------------------------
	-- FUNCTIONS (ANIMATION)
	--------------------------------

	do
		do -- SHOW
			function Frame:ShowWithAnimation_StopEvent(sessionID)
				return Frame.showWithAnimation_sessionID ~= sessionID
			end

			function Frame:ShowWithAnimation()
				local showWithAnimation_sessionID = math.random(1, 9999999)
				Frame.showWithAnimation_sessionID = showWithAnimation_sessionID

				--------------------------------

				Frame:Show()
				Frame.REF_FLARE:StartPlayback()

				--------------------------------

				Frame.REF_NOTIFICATION_TEXT:SetAlpha(0)

				--------------------------------

				addon.API.Animation:Fade(Frame, .5, 0, 1, nil, function() return Frame:ShowWithAnimation_StopEvent(showWithAnimation_sessionID) end)
				addon.Libraries.AceTimer:ScheduleTimer(function()
					addon.API.Animation:FadeText(Frame.REF_NOTIFICATION_TEXT, 1.5, 15, 1, addon.API.Animation.EaseExpo, function() return Frame:ShowWithAnimation_StopEvent(showWithAnimation_sessionID) end)
				end, .2)

				--------------------------------

				addon.SoundEffects:PlaySoundFile(addon.SoundEffects.AlertNotification_Show)
			end
		end

		do -- HIDE
			function Frame:HideWithAnimation_StopEvent(sessionID)
				return Frame.showWithAnimation_sessionID ~= sessionID
			end

			function Frame:HideWithAnimation()
				local showWithAnimation_sessionID = Frame.showWithAnimation_sessionID

				--------------------------------

				addon.Libraries.AceTimer:ScheduleTimer(function()
					if Frame.showWithAnimation_sessionID == showWithAnimation_sessionID then
						Frame:Hide()
					end
				end, .5)

				--------------------------------

				addon.API.Animation:Fade(Frame.REF_NOTIFICATION_TEXT, .5, 1, 0, nil, function() return Frame:HideWithAnimation_StopEvent(showWithAnimation_sessionID) end)
				addon.API.Animation:Fade(Frame, .5, 1, 0, nil, function() return Frame:HideWithAnimation_StopEvent(showWithAnimation_sessionID) end)

				--------------------------------

				addon.SoundEffects:PlaySoundFile(addon.SoundEffects.AlertNotification_Hide)
			end
		end

		do -- FLARE
			function Frame.REF_FLARE:StartPlayback_StopEvent(sessionID)
				return Frame.REF_FLARE.animationID ~= sessionID
			end

			function Frame.REF_FLARE:StartPlayback()
				local animationID = GetTime()
				Frame.REF_FLARE.animationID = animationID

				--------------------------------

				Frame.REF_FLARE:Show()
				Frame.REF_FLARE:SetAlpha(0)
				Frame.REF_FLARE:SetScale(.1)

				--------------------------------

				addon.API.Animation:Fade(Frame.REF_FLARE, .125, 0, 1, addon.API.Animation.EaseExpo, function() return Frame.REF_FLARE:StartPlayback_StopEvent(animationID) end)
				addon.API.Animation:Scale(Frame.REF_FLARE, .125, .875, 1, function() return Frame.REF_FLARE:StartPlayback_StopEvent(animationID) end)

				addon.Libraries.AceTimer:ScheduleTimer(function()
					if Frame.REF_FLARE.animationID == animationID then
						addon.API.Animation:Fade(Frame.REF_FLARE, 2, 1, 0, addon.API.Animation.EaseExpo, function() return Frame.REF_FLARE:StartPlayback_StopEvent(animationID) end)
						addon.API.Animation:Scale(Frame.REF_FLARE, 2, 1, .875, nil, addon.API.Animation.EaseExpo, function() return Frame.REF_FLARE:StartPlayback_StopEvent(animationID) end)
					end
				end, .125)

				addon.Libraries.AceTimer:ScheduleTimer(function()
					if Frame.REF_FLARE.animationID == animationID then
						Frame.REF_FLARE:Hide()
					end
				end, 2)
			end
		end
	end

	--------------------------------
	-- SETTINGS
	--------------------------------

	do
		local function Settings_UIDirection()
			Frame:ClearAllPoints()
			if addon.Database.DB_GLOBAL.profile.INT_UIDIRECTION == 1 then
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
				local valid = (InteractionFrame.QuestFrame.validForNotification)
				if not valid then
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
