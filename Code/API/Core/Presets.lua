---@class addon
local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local PrefabRegistry = addon.PrefabRegistry
local L = addon.Locales

--------------------------------
-- VARIABLES
--------------------------------

addon.API.Presets = {}

do -- MAIN
	addon.API.Presets.UIModifier = .325
	addon.API.Presets.UITextModifier = 1
end

do -- CONSTANTS

end

--------------------------------
-- BASIC SHAPES
--------------------------------

do
	addon.API.Presets.BASIC_SQUARE = addon.Variables.PATH_ART .. "Elements/BasicShapes/square.png"
end

--------------------------------
-- SHARP
--------------------------------

do
	do -- TOOLTIP
		addon.API.Presets.BG_SHARP = addon.Variables.PATH_ART .. "Elements/Sharp/sharp-center.png"
		addon.API.Presets.EDGE_SHARP = addon.Variables.PATH_ART .. "Elements/Sharp/sharp-border.png"
		addon.API.Presets.DIALOG_SHARP = addon.Variables.PATH_ART .. "Elements/Sharp/sharp-dialog.png"
	end

	do -- NINESLICE
		addon.API.Presets.NINESLICE_SHARP = addon.Variables.PATH_ART .. "Elements/Sharp/sharp-nineslice.png"
		addon.API.Presets.NINESLICE_SHARP_SPRITESHEET = addon.Variables.PATH_ART .. "Elements/Sharp/Spritesheet/sharp-nineslice.png"
		addon.API.Presets.NINESLICE_SHARP_SPRITESHEET_TOTALFRAMES = 25
	end
end

--------------------------------
-- STYLISED
--------------------------------

do
	do -- TOOLTIP
		addon.API.Presets.BG_STYLISED = addon.Variables.PATH_ART .. "Elements/Stylised/stylised-center.png"
		addon.API.Presets.EDGE_STYLISED = addon.Variables.PATH_ART .. "Elements/Stylised/stylised-border.png"
		addon.API.Presets.BG_STYLISED_HIGHLIGHT = addon.Variables.PATH_ART .. "Elements/Stylised/stylised-center-highlighted.png"
		addon.API.Presets.EDGE_STYLISED_HIGHLIGHT = addon.Variables.PATH_ART .. "Elements/Stylised/stylised-edge-highlighted.png"
	end

	do -- SCROLL
		do -- TOOLTIP
			addon.API.Presets.BG_STYLISED_SCROLL = addon.Variables.PATH_ART .. "Elements/Stylised/stylised-scroll-center-light.png"
			addon.API.Presets.EDGE_STYLISED_SCROLL = addon.Variables.PATH_ART .. "Elements/Stylised/stylised-scroll-border-light.png"

			addon.API.Presets.BG_STYLISED_SCROLL_02 = addon.Variables.PATH_ART .. "Elements/Stylised/stylised-scroll-center-dark.png"
			addon.API.Presets.EDGE_STYLISED_SCROLL_02 = addon.Variables.PATH_ART .. "Elements/Stylised/stylised-scroll-border-dark.png"
		end

		do -- NINESLICE
			addon.API.Presets.NINESLICE_STYLISED_SCROLL = addon.Variables.PATH_ART .. "Elements/Stylised/stylised-scroll-nineslice-light.png"

			addon.API.Presets.NINESLICE_STYLISED_SCROLL_02 = addon.Variables.PATH_ART .. "Elements/Stylised/stylised-scroll-nineslice-dark.png"
		end
	end
end

--------------------------------
-- FORGED
--------------------------------

do
	addon.API.Presets.NINESLICE_FORGED = addon.Variables.PATH_ART .. "Elements/Forged/forged-nineslice.png"
end

--------------------------------
-- INSCRIBED
--------------------------------

do
	do -- NINESLICE
		addon.API.Presets.NINESLICE_INSCRIBED = addon.Variables.PATH_ART .. "Elements/Inscribed/inscribed-nineslice.png"
		addon.API.Presets.NINESLICE_INSCRIBED_BORDER = addon.Variables.PATH_ART .. "Elements/Inscribed/inscribed-border-nineslice.png"
		addon.API.Presets.NINESLICE_INSCRIBED_BORDER_HIGHLIGHT = addon.Variables.PATH_ART .. "Elements/Inscribed/inscribed-border-highlighted-nineslice.png"
	end

	do -- FILLED
		addon.API.Presets.NINESLICE_INSCRIBED_FILLED = addon.Variables.PATH_ART .. "Elements/Inscribed/inscribed-filled-nineslice.png"
		addon.API.Presets.NINESLICE_INSCRIBED_FILLED_HIGHLIGHT = addon.Variables.PATH_ART .. "Elements/Inscribed/inscribed-filled-highlighted-nineslice.png"
	end
end

--------------------------------
-- INSCRIBED BACKGROUND
--------------------------------

do
	addon.API.Presets.NINESLICE_INSCRIBED_BACKGROUND = addon.Variables.PATH_ART .. "Elements/Inscribed/inscribed-background-nineslice-light.png"
	addon.API.Presets.NINESLICE_INSCRIBED_BACKGROUND_HIGHLIGHT = addon.Variables.PATH_ART .. "Elements/Inscribed/inscribed-background-highlighted-nineslice-light.png"
	addon.API.Presets.NINESLICE_INSCRIBED_BACKGROUND_02 = addon.Variables.PATH_ART .. "Elements/Inscribed/inscribed-background-nineslice-dark.png"
	addon.API.Presets.NINESLICE_INSCRIBED_BACKGROUND_HIGHLIGHT_02 = addon.Variables.PATH_ART .. "Elements/Inscribed/inscribed-background-highlighted-nineslice-dark.png"
end

--------------------------------
-- WEATHERED
--------------------------------

do
	do -- NINESLICE
		addon.API.Presets.NINESLICE_WEATHERED = addon.Variables.PATH_ART .. "Elements/Weathered/weathered-nineslice.png"
		addon.API.Presets.NINESLICE_WEATHERED_HIGHLIGHT = addon.Variables.PATH_ART .. "Elements/Weathered/weathered-highlighted-nineslice-light.png"
		addon.API.Presets.NINESLICE_WEATHERED_02 = addon.Variables.PATH_ART .. "Elements/Weathered/weathered-nineslice-light.png"
		addon.API.Presets.NINESLICE_WEATHERED_HIGHLIGHT_02 = addon.Variables.PATH_ART .. "Elements/Weathered/weathered-highlighted-nineslice-dark.png"
	end

	do -- SPRITESHEET
		addon.API.Presets.NINESLICE_WEATHERED_SPRITESHEET = addon.Variables.PATH_ART .. "Elements/Weathered/Spritesheet/weathered-nineslice.png"
		addon.API.Presets.NINESLICE_WEATHERED_SPRITESHEET_TOTALFRAMES = 24
	end

	do -- FORGED
		addon.API.Presets.NINESLICE_WEATHERED_FORGED = addon.Variables.PATH_ART .. "Elements/Weathered/weathered-forged-nineslice.png"
	end
end

--------------------------------
-- RUSTIC
--------------------------------

do
	do -- NINESLICE
		addon.API.Presets.NINESLICE_RUSTIC_FILLED = addon.Variables.PATH_ART .. "Elements/Rustic/rustic-filled-nineslice.png"
		addon.API.Presets.NINESLICE_RUSTIC_BORDER = addon.Variables.PATH_ART .. "Elements/Rustic/rustic-border-nineslice.png"
	end
end

--------------------------------
-- TOOLTIP
--------------------------------

do
	do -- TOOLTIP
		addon.API.Presets.NINESLICE_TOOLTIP = addon.Variables.PATH_ART .. "Elements/Tooltip/tooltip-nineslice-light.png"
		addon.API.Presets.NINESLICE_TOOLTIP_02 = addon.Variables.PATH_ART .. "Elements/Tooltip/tooltip-nineslice-dark.png"
	end

	do -- CUSTOM TOOLTIP
        addon.API.Presets.NINESLICE_TOOLTIP_CUSTOM = addon.Variables.PATH_ART .. "Elements/Tooltip/tooltip-custom-nineslice-light.png"
		addon.API.Presets.NINESLICE_TOOLTIP_CUSTOM_02 = addon.Variables.PATH_ART .. "Elements/Tooltip/tooltip-custom-nineslice-dark.png"
	end
end

--------------------------------
-- VIGNETTE
--------------------------------

do
	addon.API.Presets.NINESLICE_VIGNETTE_DARK = addon.Variables.PATH_ART .. "Elements/Vignette/vignette-nineslice-dark.png"
	addon.API.Presets.NINESLICE_VIGNETTE_LIGHT = addon.Variables.PATH_ART .. "Elements/Vignette/vignette-nineslice-light.png"
end
