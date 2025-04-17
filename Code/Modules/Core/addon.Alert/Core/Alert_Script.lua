local addonName, addon = ...
local CallbackRegistry = addon.CallbackRegistry
local PrefabRegistry = addon.PrefabRegistry
local L = addon.Locales
local NS = addon.Alert

--------------------------------

NS.Script = {}

--------------------------------

function NS.Script:Load()
	--------------------------------
	-- REFERENCES
	--------------------------------

	local Frame = InteractionFrame.AlertFrame
	local Callback = NS.Script

	--------------------------------
	-- FUNCTIONS (FRAME)
	--------------------------------

	do
		function Callback:Show(image, text, textSize, startSFX, endSFX, duration)
			if not Frame then
				return
			end

			Frame.ImageTexture:SetTexture(image)
			Frame.Title.Text:SetText(text)
			addon.Libraries.AceTimer:ScheduleTimer(function()
				addon.API.Util:SetFontSize(Frame.Title.Text, textSize)
			end, 0)

			--------------------------------

			Frame:ShowWithAnimation()
			addon.SoundEffects:PlaySoundFile(startSFX)

			--------------------------------

			addon.Libraries.AceTimer:ScheduleTimer(function()
				Callback:Hide(endSFX)
			end, duration or 3)
		end

		function Callback:Hide(sfx)
			Frame:HideWithAnimation()
			addon.SoundEffects:PlaySoundFile(sfx)
		end
	end

	--------------------------------
	-- FUNCTIONS (ANIMATION)
	--------------------------------

	do
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

			Frame:SetAlpha(1)
			Frame.Image:SetAlpha(0)
			Frame.Background:SetAlpha(0)
			Frame.Title:SetAlpha(0)

			--------------------------------

			addon.API.Animation:Fade(Frame.Image, .125, 0, 1, nil, Frame.ShowWithAnimation_StopEvent)
			addon.API.Animation:Scale(Frame.Image, .375, 5, 1, nil, addon.API.Animation.EaseExpo, Frame.ShowWithAnimation_StopEvent)

			addon.Libraries.AceTimer:ScheduleTimer(function()
				if not Frame.hidden then
					addon.API.Animation:Fade(Frame.Image, 1, 1, .5, nil, Frame.ShowWithAnimation_StopEvent)
				end
			end, .125)

			addon.Libraries.AceTimer:ScheduleTimer(function()
				if not Frame.hidden then
					addon.API.Animation:Fade(Frame.Background, .25, 0, 1, nil, Frame.ShowWithAnimation_StopEvent)
					addon.API.Animation:Scale(Frame.Background, 1, 50, Frame:GetWidth(), "x", addon.API.Animation.EaseExpo, Frame.ShowWithAnimation_StopEvent)
				end
			end, .125)

			addon.Libraries.AceTimer:ScheduleTimer(function()
				if not Frame.hidden then
					addon.API.Animation:Fade(Frame.Title, .25, 0, 1, nil, Frame.ShowWithAnimation_StopEvent)
				end
			end, .2)

			--------------------------------

			addon.SoundEffects:PlaySoundFile(addon.SoundEffects.PATH .. "Alert/alert.mp3")
		end

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

			addon.API.Animation:Fade(Frame, .5, Frame:GetAlpha(), 0, nil, Frame.HideWithAnimation_StopEvent)
			addon.API.Animation:Scale(Frame.BackgroundTexture, .5, Frame.BackgroundTexture:GetWidth(), 125, "x", addon.API.Animation.EaseExpo, Frame.HideWithAnimation_StopEvent)
			addon.API.Animation:Scale(Frame.Image, .5, Frame.Image:GetScale(), .75, nil, addon.API.Animation.EaseSine, Frame.HideWithAnimation_StopEvent)
		end
	end

	--------------------------------
	-- SETTINGS
	--------------------------------

	do

	end

	--------------------------------
	-- FUNCTIONS (EVENT)
	--------------------------------

	do

	end
end
