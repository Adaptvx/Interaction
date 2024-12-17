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
		Frame.ShowWithText = function(text)
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

		CallbackRegistry:Trigger("SETTINGS_UIDIRECTION_CHANGED", Settings_UIDirection, 2)
	end

	--------------------------------
	-- FUNCTIONS (EVENT)
	--------------------------------

	do
		local Events = CreateFrame("Frame")
		Events:RegisterEvent("QUEST_ACCEPTED")
		Events:RegisterEvent("QUEST_TURNED_IN")
		Events:SetScript("OnEvent", function(self, event, arg1)
			addon.Libraries.AceTimer:ScheduleTimer(function()
				local IsInLastActiveTime = (addon.Interaction.Variables.LastActiveTime and (GetTime() - addon.Interaction.Variables.LastActiveTime) < 5)
				local IsInLastStartTime = (addon.Interaction.Variables.StartInteractionTime and (GetTime() - addon.Interaction.Variables.StartInteractionTime) < 5)
				local InNPCInteraction = (IsInLastActiveTime == true or IsInLastStartTime == true)

				local IsWorldQuest = (C_QuestLog.IsWorldQuest and C_QuestLog.IsWorldQuest(arg1))
				local IsBonusObjective = (C_QuestInfoSystem and C_QuestInfoSystem.GetQuestClassification and C_QuestInfoSystem.GetQuestClassification(GetQuestID()) == Enum.QuestClassification.BonusObjective)

				--------------------------------

				if event == "QUEST_ACCEPTED" then
					if InNPCInteraction and not IsWorldQuest and not IsBonusObjective then
						Frame.ShowWithText("Quest Accepted")
					end
				end

				if event == "QUEST_TURNED_IN" then
					if InNPCInteraction and not IsWorldQuest and not IsBonusObjective then
						Frame.ShowWithText("Quest Completed")
					end
				end
			end, .1)
		end)
	end

	--------------------------------
	-- SETUP
	--------------------------------
end
