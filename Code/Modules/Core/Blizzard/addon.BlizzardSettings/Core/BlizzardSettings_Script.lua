local addonName, addon = ...
local CallbackRegistry = addon.CallbackRegistry
local L = addon.Locales
local NS = addon.BlizzardSettings

--------------------------------

NS.Script = {}

--------------------------------

function NS.Script:Load()
	--------------------------------
	-- REFERENCES
	--------------------------------

	local Frame = NS.Variables.Frame
    local Callback = NS.Script

	--------------------------------
	-- FUNCTIONS (BUTTONS)
	--------------------------------

	do
		Frame.Content.Title:SetScript("OnEnter", function()
			AdaptiveAPI.Animation:Fade(Frame.Content.Title, .125, Frame.Content.Title:GetAlpha(), .75)
			-- AdaptiveAPI.Animation:Scale(Frame.Content.Title.Background, .75, Frame.Content.Title.Background:GetWidth(), Frame.Content.Title:GetWidth() * 1.125, "x", AdaptiveAPI.Animation.EaseExpo)

			--------------------------------

			AdaptiveAPI.Animation:Fade(Frame.Content.Shortcut, .125, Frame.Content.Shortcut:GetAlpha(), .25)
		end)

		Frame.Content.Title:SetScript("OnLeave", function()
			AdaptiveAPI.Animation:Fade(Frame.Content.Title, .125, Frame.Content.Title:GetAlpha(), 1)
			-- AdaptiveAPI.Animation:Scale(Frame.Content.Title.Background, .5, Frame.Content.Title.Background:GetWidth(), Frame.Content.Title:GetWidth(), "x", AdaptiveAPI.Animation.EaseExpo)

			--------------------------------

			AdaptiveAPI.Animation:Fade(Frame.Content.Shortcut, .125, Frame.Content.Shortcut:GetAlpha(), 1)
		end)

		Frame.Content.Title:SetScript("OnMouseDown", function()
			AdaptiveAPI.Animation:Fade(Frame.Content.Title, .125, Frame.Content.Title:GetAlpha(), .5)
		end)

		Frame.Content.Title:SetScript("OnMouseUp", function()
			AdaptiveAPI.Animation:Fade(Frame.Content.Title, .125, Frame.Content.Title:GetAlpha(), 1)

			--------------------------------

			addon.SettingsUI.Script:ShowSettingsUI(false, true)
		end)
	end

	--------------------------------
	-- FUNCTIONS (FRAME)
	--------------------------------

	do
        function addon.BlizzardSettings:Set(text, shortcut)
			Frame.Content.Title.Text:SetText(text)
			Frame.Content.Shortcut.Text:SetText(shortcut)

			--------------------------------

			Frame.ShowWithAnimation()
		end
	end

	--------------------------------
	-- FUNCTIONS (ANIMATION)
	--------------------------------

	do
		Frame.ShowWithAnimation = function()
			Frame.Background:SetAlpha(0)
			Frame.Border:SetAlpha(0)
			Frame.Content.Title:SetAlpha(0)
			Frame.Content.Title.Text:SetAlpha(0)
			Frame.Content.Shortcut.Text:SetAlpha(0)

			--------------------------------

			AdaptiveAPI.Animation:Fade(Frame.Border, .5, 0, 1, nil, function() return not Frame:IsVisible() end)
			AdaptiveAPI.Animation:Scale(Frame.Border, 1, 50, Frame:GetHeight(), "y", AdaptiveAPI.Animation.EaseExpo, function() return not Frame:IsVisible() end)

			--------------------------------

			addon.Libraries.AceTimer:ScheduleTimer(function()
				AdaptiveAPI.Animation:Fade(Frame.Background, .25, 0, 1, nil, function() return not Frame:IsVisible() end)

				addon.Libraries.AceTimer:ScheduleTimer(function()
					AdaptiveAPI.Animation:Fade(Frame.Content.Title, .25, 0, 1, nil, function() return not Frame:IsVisible() end)
					AdaptiveAPI.Animation:Scale(Frame.Content.Title.Background, 1, 50, Frame.Content.Title:GetWidth(), "x", AdaptiveAPI.Animation.EaseExpo, function() return not Frame:IsVisible() end)
				end, .1)

                addon.Libraries.AceTimer:ScheduleTimer(function()
					Frame.Content.Title.Text:SetAlpha(0)
					AdaptiveAPI.Animation:Fade(Frame.Content.Title.Text, .25, 0, 1, nil, function() return not Frame:IsVisible() end)
				end, .3)

				addon.Libraries.AceTimer:ScheduleTimer(function()
					Frame.Content.Shortcut.Text:SetAlpha(0)
					AdaptiveAPI.Animation:Fade(Frame.Content.Shortcut.Text, .5, 0, 1, nil, function() return not Frame:IsVisible() end)
				end, .325)
			end, .125)
		end
	end

	--------------------------------
	-- SETTINGS
	--------------------------------

	do

	end

	--------------------------------
	-- EVENTS
	--------------------------------

	do
		hooksecurefunc(Frame, "Show", function()
			local Shortcut

			if addon.Input.Variables.IsController then
				Shortcut = AdaptiveAPI:InlineIcon(NS.Variables.PATH .. "shortcut-controller.png", 25, 25, 0, 0) .. L["BlizzardSettings - Shortcut - Controller"]
			else
				Shortcut = AdaptiveAPI:InlineIcon(NS.Variables.PATH .. "shortcut-pc.png", 40, 130, 0, 0)
			end

			addon.BlizzardSettings:Set(L["BlizzardSettings - Title"], Shortcut)
		end)
	end

	--------------------------------
	-- SETUP
	--------------------------------

	local Category = Settings.RegisterCanvasLayoutCategory(Frame, "Interaction")
	Settings.RegisterAddOnCategory(Category)
end
