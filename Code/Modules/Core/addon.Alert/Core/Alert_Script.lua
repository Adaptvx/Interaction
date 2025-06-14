---@class addon
local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local PrefabRegistry = addon.PrefabRegistry
local L = addon.Locales
local NS = addon.Alert; addon.Alert = NS

--------------------------------

NS.Script = {}

--------------------------------

function NS.Script:Load()
	--------------------------------
	-- REFERENCES
	--------------------------------

	local Frame = InteractionFrame.AlertFrame
	local Callback = NS.Script; NS.Script = Callback

	--------------------------------
	-- FUNCTIONS (FRAME)
	--------------------------------

	do
		function Callback:Show(image, text, textSize, startSFX, endSFX, duration)
			if not Frame then
				return
			end

			Frame.REF_IMAGE_TEXTURE:SetTexture(image)
			Frame.REF_TITLE_TEXT:SetText(text)
			addon.Libraries.AceTimer:ScheduleTimer(function()
				addon.API.Util:SetFontSize(Frame.REF_TITLE_TEXT, textSize)
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
			Frame.REF_IMAGE:SetAlpha(0)
			Frame.REF_BACKGROUND:SetAlpha(0)
			Frame.REF_TITLE:SetAlpha(0)

			--------------------------------

			addon.API.Animation:Fade(Frame.REF_IMAGE, .125, 0, 1, nil, Frame.ShowWithAnimation_StopEvent)
			addon.API.Animation:Scale(Frame.REF_IMAGE, .375, 5, 1, nil, addon.API.Animation.EaseExpo, Frame.ShowWithAnimation_StopEvent)

			addon.Libraries.AceTimer:ScheduleTimer(function()
				if not Frame.hidden then
					addon.API.Animation:Fade(Frame.REF_IMAGE, 1, 1, .5, nil, Frame.ShowWithAnimation_StopEvent)
				end
			end, .125)

			addon.Libraries.AceTimer:ScheduleTimer(function()
				if not Frame.hidden then
					addon.API.Animation:Fade(Frame.REF_BACKGROUND, .25, 0, 1, nil, Frame.ShowWithAnimation_StopEvent)
					addon.API.Animation:Scale(Frame.REF_BACKGROUND, 1, 50, Frame:GetWidth(), "x", addon.API.Animation.EaseExpo, Frame.ShowWithAnimation_StopEvent)
				end
			end, .125)

			addon.Libraries.AceTimer:ScheduleTimer(function()
				if not Frame.hidden then
					addon.API.Animation:Fade(Frame.REF_TITLE, .25, 0, 1, nil, Frame.ShowWithAnimation_StopEvent)
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
			addon.API.Animation:Scale(Frame.REF_BACKGROUND_TEXTURE, .5, Frame.REF_BACKGROUND_TEXTURE:GetWidth(), 125, "x", addon.API.Animation.EaseExpo, Frame.HideWithAnimation_StopEvent)
			addon.API.Animation:Scale(Frame.REF_IMAGE, .5, Frame.REF_IMAGE:GetScale(), .75, nil, addon.API.Animation.EaseSine, Frame.HideWithAnimation_StopEvent)
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
