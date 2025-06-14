---@class addon
local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local PrefabRegistry = addon.PrefabRegistry
local L = addon.Locales
local NS = addon.BlizzardSettings; addon.BlizzardSettings = NS

--------------------------------

NS.Script = {}

--------------------------------

function NS.Script:Load()
	--------------------------------
	-- REFERENCES
	--------------------------------

	local Frame = NS.Variables.Frame
	local Callback = NS.Script; NS.Script = Callback

	--------------------------------
	-- FUNCTIONS (BUTTONS)
	--------------------------------

	do
		Frame.Content.Title:SetScript("OnEnter", function()
			addon.API.Animation:Fade(Frame.Content.Title, .125, Frame.Content.Title:GetAlpha(), .75)
			-- addon.API.Animation:Scale(Frame.Content.Title.Background, .75, Frame.Content.Title.Background:GetWidth(), Frame.Content.Title:GetWidth() * 1.125, "x", addon.API.Animation.EaseExpo)

			--------------------------------

			addon.API.Animation:Fade(Frame.Content.Shortcut, .125, Frame.Content.Shortcut:GetAlpha(), .25)
		end)

		Frame.Content.Title:SetScript("OnLeave", function()
			addon.API.Animation:Fade(Frame.Content.Title, .125, Frame.Content.Title:GetAlpha(), 1)
			-- addon.API.Animation:Scale(Frame.Content.Title.Background, .5, Frame.Content.Title.Background:GetWidth(), Frame.Content.Title:GetWidth(), "x", addon.API.Animation.EaseExpo)

			--------------------------------

			addon.API.Animation:Fade(Frame.Content.Shortcut, .125, Frame.Content.Shortcut:GetAlpha(), 1)
		end)

		Frame.Content.Title:SetScript("OnMouseDown", function()
			addon.API.Animation:Fade(Frame.Content.Title, .125, Frame.Content.Title:GetAlpha(), .5)
		end)

		Frame.Content.Title:SetScript("OnMouseUp", function()
			addon.API.Animation:Fade(Frame.Content.Title, .125, Frame.Content.Title:GetAlpha(), 1)

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

			Frame:ShowWithAnimation()
		end
	end

	--------------------------------
	-- FUNCTIONS (ANIMATION)
	--------------------------------

	do
		do -- SHOW
			function Frame:ShowWithAnimation_StopEvent()
				return not Frame:IsVisible()
			end

			function Frame:ShowWithAnimation()
				Frame.Background:SetAlpha(0)
				Frame.Border:SetAlpha(0)
				Frame.Content.Title:SetAlpha(0)
				Frame.Content.Title.Text:SetAlpha(0)
				Frame.Content.Shortcut.Text:SetAlpha(0)

				--------------------------------

				addon.API.Animation:Fade(Frame.Border, .5, 0, 1, nil, Frame.ShowWithAnimation_StopEvent)
				addon.API.Animation:Scale(Frame.Border, 1, 50, Frame:GetHeight(), "y", addon.API.Animation.EaseExpo, Frame.ShowWithAnimation_StopEvent)

				--------------------------------

				addon.Libraries.AceTimer:ScheduleTimer(function()
					addon.API.Animation:Fade(Frame.Background, .25, 0, 1, nil, Frame.ShowWithAnimation_StopEvent)

					addon.Libraries.AceTimer:ScheduleTimer(function()
						addon.API.Animation:Fade(Frame.Content.Title, .25, 0, 1, nil, Frame.ShowWithAnimation_StopEvent)
						addon.API.Animation:Scale(Frame.Content.Title.Background, 1, 50, Frame.Content.Title:GetWidth(), "x", addon.API.Animation.EaseExpo, Frame.ShowWithAnimation_StopEvent)
					end, .1)

					addon.Libraries.AceTimer:ScheduleTimer(function()
						Frame.Content.Title.Text:SetAlpha(0)
						addon.API.Animation:Fade(Frame.Content.Title.Text, .25, 0, 1, nil, Frame.ShowWithAnimation_StopEvent)
					end, .3)

					addon.Libraries.AceTimer:ScheduleTimer(function()
						Frame.Content.Shortcut.Text:SetAlpha(0)
						addon.API.Animation:Fade(Frame.Content.Shortcut.Text, .5, 0, 1, nil, Frame.ShowWithAnimation_StopEvent)
					end, .325)
				end, .125)
			end
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
				Shortcut = addon.API.Util:InlineIcon(NS.Variables.PATH .. "shortcut-controller.png", 25, 25, 0, 0) .. L["BlizzardSettings - Shortcut - Controller"]
			else
				Shortcut = addon.API.Util:InlineIcon(NS.Variables.PATH .. "shortcut-pc.png", 40, 130, 0, 0)
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
