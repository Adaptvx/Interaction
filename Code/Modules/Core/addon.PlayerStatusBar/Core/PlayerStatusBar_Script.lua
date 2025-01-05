local addonName, addon = ...
local CallbackRegistry = addon.CallbackRegistry
local L = addon.Locales
local NS = addon.PlayerStatusBar

--------------------------------

NS.Script = {}

--------------------------------

function NS.Script:Load()
	--------------------------------
	-- REFERENCES
	--------------------------------

	local Frame = InteractionPlayerStatusBarFrame
	local Callback = NS.Script

	--------------------------------
	-- FUNCTIONS (BUTTONS)
	--------------------------------

	do
		Frame.Enter = function()
			Frame:SetAlpha(.75)
		end

		Frame.Leave = function()
			Frame:SetAlpha(1)
		end

		--------------------------------

		AdaptiveAPI.FrameTemplates:CreateMouseResponder(Frame, function()
			Frame.Enter()
		end, function()
			Frame.Leave()
		end)
	end

	--------------------------------
	-- FUNCTIONS (FRAME)
	--------------------------------

	do
		function Callback:Update()
			if Callback.IsNewLevelTransition then
				return
			end

			local Min = 0
			local Max = UnitXPMax("player")
			local Value = UnitXP("player")
			local Level = UnitLevel(UnitName("player"))
			local UnitIsMaxLevel = (GetMaxPlayerLevel() == UnitLevel(UnitName("player")))

			--------------------------------

			if UnitIsMaxLevel then
				Frame.HideWithAnimation()

				return
			end

			--------------------------------

			Frame.Progress:SetMinMaxValues(Min, Max)

			--------------------------------

			if Callback.SavedLevel ~= Level then
				Callback.IsNewLevelTransition = true

				--------------------------------

				AdaptiveAPI.Animation:SetProgressTo(Frame.Progress, Max, 1, AdaptiveAPI.Animation.EaseExpo)

				--------------------------------

				addon.Libraries.AceTimer:ScheduleTimer(function()
					Callback.IsNewLevelTransition = false

					--------------------------------

					Frame.Progress:SetValue(Min)
					AdaptiveAPI.Animation:SetProgressTo(Frame.Progress, Value, 1, AdaptiveAPI.Animation.EaseExpo)
				end, 1)
			else
				AdaptiveAPI.Animation:SetProgressTo(Frame.Progress, Value, 1, AdaptiveAPI.Animation.EaseExpo)
			end
			Callback.SavedLevel = Level

			--------------------------------

			local TooltipLine1 = L["PlayerStatusBar - TooltipLine1"] .. Value .. " (" .. string.format("%.0f", (Value / Max) * 100) .. "%)"
			local TooltipLine2 = L["PlayerStatusBar - TooltipLine2"] .. (Max - Value)
			local TooltipLine3 = L["PlayerStatusBar - TooltipLine3"] .. Level

			AdaptiveAPI:AddTooltip(Frame, TooltipLine1 .. "\n" .. TooltipLine2 .. "\n" .. TooltipLine3, "ANCHOR_TOP", 0, 10, true)
		end
	end

	--------------------------------
	-- FUNCTIONS (ANIMATION)
	--------------------------------

	do
		Frame.ShowWithAnimation = function()
			if not Frame.hidden then
				return
			end
			Frame.hidden = false
			Frame:Show()

			--------------------------------

			AdaptiveAPI.Animation:Fade(Frame, .5, 0, 1, AdaptiveAPI.Animation.EaseSine, function() return Frame.hidden end)
			AdaptiveAPI.Animation:Move(Frame, .25, "BOTTOM", -5, 5, "y", AdaptiveAPI.Animation.EaseSine, function() return Frame.hidden end)
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
			end, 1)

			--------------------------------

			AdaptiveAPI.Animation:Fade(Frame, .25, Frame:GetAlpha(), 0, AdaptiveAPI.Animation.EaseSine, function() return not Frame.hidden end)
			AdaptiveAPI.Animation:Move(Frame, .25, "BOTTOM", 5, -5, "y", AdaptiveAPI.Animation.EaseSine, function() return not Frame.hidden end)
		end
	end

	--------------------------------
	-- EVENTS
	--------------------------------

	do
		hooksecurefunc(Frame, "Show", function()
			CallbackRegistry:Trigger("START_STATUSBAR")
		end)
		hooksecurefunc(Frame, "Hide", function()
			CallbackRegistry:Trigger("STOP_STATUSBAR")
		end)

		CallbackRegistry:Add("START_INTERACTION", function()
			addon.Libraries.AceTimer:ScheduleTimer(function()
				local UnitIsMaxLevel = (GetMaxPlayerLevel() == UnitLevel(UnitName("player")))

				--------------------------------

				if addon.HideUI.Variables.Active and addon.Interaction.Variables.Active and not UnitIsMaxLevel and not InCombatLockdown() then
					Callback:Update()

					--------------------------------

					Frame.ShowWithAnimation()
				end
			end, .1)
		end, 0)

		CallbackRegistry:Add("STOP_INTERACTION", function()
			Frame.HideWithAnimation()
		end, 0)

		local Events = CreateFrame("Frame")
		Events:RegisterEvent("PLAYER_XP_UPDATE")
		Events:SetScript("OnEvent", function(_, event, arg1)
			if event == "PLAYER_XP_UPDATE" and arg1 == "player" then
				Callback:Update()
			end
		end)
	end

	--------------------------------
	-- SETUP
	--------------------------------

	do
		local Level = UnitLevel(UnitName("player"))
		Callback.SavedLevel = Level
	end
end
