---@class addon
local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local PrefabRegistry = addon.PrefabRegistry
local L = addon.Locales
local NS = addon.Cinematic; addon.Cinematic = NS

--------------------------------

NS.Elements = {}

--------------------------------

function NS.Elements:Load()
	--------------------------------
	-- CREATE ELEMENTS
	--------------------------------

	do
		do -- ELEMENTS
			InteractionFrame.CinematicMode = CreateFrame("Frame", "$parent.CinematicMode", InteractionFrame)
			InteractionFrame.CinematicMode:SetAllPoints(UIParent, true)
			InteractionFrame.CinematicMode:SetIgnoreParentScale(true)
			InteractionFrame.CinematicMode:SetIgnoreParentAlpha(true)

			--------------------------------

			do -- VIGNETTE
				InteractionFrame.CinematicMode.Vignette = CreateFrame("Frame", "$parent.Vignette", InteractionFrame.CinematicMode)
				InteractionFrame.CinematicMode.Vignette:SetAllPoints(UIParent, true)

				--------------------------------

				do -- TEXTURE
					InteractionFrame.CinematicMode.Vignette.Texture, _ = addon.API.FrameTemplates:CreateNineSlice(InteractionFrame.CinematicMode.Vignette, "BACKGROUND", addon.API.Presets.NINESLICE_VIGNETTE_DARK, 256, 1)
					InteractionFrame.CinematicMode.Vignette.Texture:SetAllPoints(InteractionFrame.CinematicMode.Vignette, true)
					InteractionFrame.CinematicMode.Vignette.Texture:SetAlpha(.5)
					InteractionFrame.CinematicMode.Vignette.Texture:SetScale(1)
				end

				--------------------------------

				InteractionFrame.CinematicMode.Vignette:SetAlpha(0)
			end
		end
	end
end
