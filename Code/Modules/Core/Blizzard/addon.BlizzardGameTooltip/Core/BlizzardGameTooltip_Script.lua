local addonName, addon = ...
local CallbackRegistry = addon.CallbackRegistry
local L = addon.Locales
local NS = addon.BlizzardGameTooltip

--------------------------------

NS.Script = {}

--------------------------------

function NS.Script:Load()
	--------------------------------
	-- REFERENCES
	--------------------------------

	local Tooltip
	local NineSlice
	local Background

	if addon.Variables.IS_CLASSIC then
		Tooltip = { GameTooltip, ShoppingTooltip1, ShoppingTooltip2 }
		NineSlice = { GameTooltip.NineSlice, ShoppingTooltip1.NineSlice, ShoppingTooltip2.NineSlice }
		Background = { GameTooltip.Background, ShoppingTooltip1.Background, ShoppingTooltip2.Background }
	else
		Tooltip = { GameTooltip, ShoppingTooltip1, ShoppingTooltip2, GarrisonFollowerTooltip }
		NineSlice = { GameTooltip.NineSlice, ShoppingTooltip1.NineSlice, ShoppingTooltip2.NineSlice, GarrisonFollowerTooltip.NineSlice }
		Background = { GameTooltip.Background, ShoppingTooltip1.Background, ShoppingTooltip2.Background, GarrisonFollowerTooltip.Background }
	end

	--------------------------------
	-- FUNCTIONS
	--------------------------------

	do
		function NS.Script:StartCustom()
			for i = 1, #Tooltip do
				local CurrentTooltip = Tooltip[i]
				local CurrentNineSlice = NineSlice[i]
				local CurrentBackground = Background[i]

				--------------------------------

				CurrentTooltip:SetParent(InteractionFrame)
				CurrentTooltip:SetFrameStrata("FULLSCREEN_DIALOG")
				CurrentTooltip:SetFrameLevel(999)

				if CurrentTooltip == GameTooltip then
					GameTooltipStatusBar:Hide()
				end

				--------------------------------

				NS.Script:ShowTooltipWithAnimation(CurrentTooltip, CurrentNineSlice, CurrentBackground, true)
			end
		end

		function NS.Script:StopCustom()
			for i = 1, #Tooltip do
				local CurrentTooltip = Tooltip[i]
				local CurrentNineSlice = NineSlice[i]
				local CurrentBackground = Background[i]

				--------------------------------

				CurrentTooltip:SetParent(UIParent)
				CurrentTooltip:SetFrameStrata("FULLSCREEN_DIALOG")
				CurrentTooltip:SetFrameLevel(999)

				--------------------------------

				NS.Script:HideTooltipWithAnimation(CurrentTooltip, CurrentNineSlice, CurrentBackground, true)
			end
		end
	end

	--------------------------------
	-- FUNCTIONS (ANIMATION)
	--------------------------------

	do
		function NS.Script:ShowTooltipWithAnimation(tooltip, nineslice, background, skipAnimation)
			if tooltip.hidden and not skipAnimation then
				return
			end
			tooltip.hidden = false

			--------------------------------

			nineslice:Hide()
			background:Show()

			--------------------------------

			if skipAnimation then
				background:SetAlpha(1)
			else
				AdaptiveAPI.Animation:Fade(background, .075, 0, 1, AdaptiveAPI.Animation.EaseSine, function() return tooltip.hidden end)
			end
		end

		function NS.Script:HideTooltipWithAnimation(tooltip, nineslice, background, skipAnimation)
			if not tooltip.hidden and not skipAnimation then
				return
			end
			tooltip.hidden = true

			--------------------------------

			if skipAnimation then
				nineslice:Show()
				background:Hide()
			else
				addon.Libraries.AceTimer:ScheduleTimer(function()
					if tooltip.hidden then
						nineslice:Show()
						background:Hide()
					end
				end, .1)
			end

			--------------------------------

			if skipAnimation then
				background:SetAlpha(0)
			else
				AdaptiveAPI.Animation:Fade(background, .075, 1, 0, AdaptiveAPI.Animation.EaseSine, function() return not tooltip.hidden end)
			end
		end
	end

	--------------------------------
	-- EVENTS
	--------------------------------

	do

	end

	--------------------------------
	-- SETUP
	--------------------------------

	do
		addon.BlizzardGameTooltip.Script:StopCustom()
	end
end
