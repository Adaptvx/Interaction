---@class addon
local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local PrefabRegistry = addon.PrefabRegistry
local L = addon.Locales
local NS = addon.PlayerStatusBar; addon.PlayerStatusBar = NS

--------------------------------

NS.Script = {}

--------------------------------

function NS.Script:Load()
	--------------------------------
	-- REFERENCES
	--------------------------------

	local Frame = InteractionPlayerStatusBarFrame
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
		function Callback:Update()
			if Callback.IsNewLevelTransition then
				return
			end

			--------------------------------

			local min = 0
			local max = UnitXPMax("player")
			local value = UnitXP("player")
			local level = UnitLevel(UnitName("player"))
			local unitIsMaxLevel = (GetMaxPlayerLevel() == UnitLevel(UnitName("player")))

			--------------------------------

			if unitIsMaxLevel then
				Frame:HideWithAnimation()

				--------------------------------

				return
			end

			--------------------------------

			Frame.Progress:SetMinMaxValues(min, max)

			--------------------------------

			if Callback.SavedLevel ~= level then
				Callback.IsNewLevelTransition = true

				--------------------------------

				addon.API.Animation:SetProgressTo(Frame.Progress, max, 1, addon.API.Animation.EaseExpo)

				--------------------------------

				addon.Libraries.AceTimer:ScheduleTimer(function()
					Callback.IsNewLevelTransition = false

					--------------------------------

					Frame.Progress:SetValue(min)
					addon.API.Animation:SetProgressTo(Frame.Progress, value, 1, addon.API.Animation.EaseExpo)
				end, 1)
			else
				addon.API.Animation:SetProgressTo(Frame.Progress, value, 1, addon.API.Animation.EaseExpo)
			end
			Callback.SavedLevel = level

			--------------------------------

			local tooltipLine1 = L["PlayerStatusBar - TooltipLine1"] .. value .. " (" .. string.format("%.0f", (value / max) * 100) .. "%)"
			local tooltipLine2 = L["PlayerStatusBar - TooltipLine2"] .. (max - value)
			local tooltipLine3 = L["PlayerStatusBar - TooltipLine3"] .. level

			addon.API.Util:AddTooltip(Frame, tooltipLine1 .. "\n" .. tooltipLine2 .. "\n" .. tooltipLine3, "ANCHOR_TOP", 0, 10)
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

				addon.API.Animation:Fade(Frame, .5, 0, 1, addon.API.Animation.EaseSine, Frame.ShowWithAnimation_StopEvent)
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
				end, 1)

				--------------------------------

				addon.API.Animation:Fade(Frame, .25, Frame:GetAlpha(), 0, addon.API.Animation.EaseSine, Frame.HideWithAnimation_StopEvent)
			end
		end
	end

	--------------------------------
	-- EVENTS
	--------------------------------

	do
		function Frame:OnEnter()
			Frame.Notch:SetAlpha(1)
			Frame.Progress:SetAlpha(1)
		end

		function Frame:OnLeave()
			Frame.Notch:SetAlpha(.5)
			Frame.Progress:SetAlpha(.5)
		end

		addon.API.FrameTemplates:CreateMouseResponder(Frame, { enterCallback = Frame.OnEnter, leaveCallback = Frame.OnLeave})

		--------------------------------

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

					Frame:ShowWithAnimation()
				end
			end, 0)
		end, 0)

		CallbackRegistry:Add("STOP_INTERACTION", function()
			Frame:HideWithAnimation()
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
