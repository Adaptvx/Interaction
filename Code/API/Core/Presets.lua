local addonName, addon = ...
local PrefabRegistry = addon.PrefabRegistry
local CallbackRegistry = addon.CallbackRegistry
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
	addon.API.Presets.BASIC_SQUARE = addon.API.Util.PATH .. "BasicShapes/square.png"
end

--------------------------------
-- SHARP
--------------------------------

do
	do -- TOOLTIP
		addon.API.Presets.BG_SHARP = addon.API.Util.PATH .. "Sharp/sharp-center.png"
		addon.API.Presets.EDGE_SHARP = addon.API.Util.PATH .. "Sharp/sharp-border.png"
		addon.API.Presets.DIALOG_SHARP = addon.API.Util.PATH .. "Sharp/sharp-dialog.png"
	end

	do -- NINESLICE
		addon.API.Presets.NINESLICE_SHARP = addon.API.Util.PATH .. "Sharp/sharp-nineslice.png"
		addon.API.Presets.NINESLICE_SHARP_SPRITESHEET = addon.API.Util.PATH .. "Sharp/Spritesheet/sharp-nineslice.png"
		addon.API.Presets.NINESLICE_SHARP_SPRITESHEET_TOTALFRAMES = 25
	end
end

--------------------------------
-- STYLISED
--------------------------------

do
	do -- TOOLTIP
		addon.API.Presets.BG_STYLISED = addon.API.Util.PATH .. "Stylised/stylised-center.png"
		addon.API.Presets.EDGE_STYLISED = addon.API.Util.PATH .. "Stylised/stylised-border.png"
		addon.API.Presets.BG_STYLISED_HIGHLIGHT = addon.API.Util.PATH .. "Stylised/stylised-center-highlighted.png"
		addon.API.Presets.EDGE_STYLISED_HIGHLIGHT = addon.API.Util.PATH .. "Stylised/stylised-edge-highlighted.png"
	end

	do -- SCROLL
		do -- TOOLTIP
			addon.API.Presets.BG_STYLISED_SCROLL = addon.API.Util.PATH .. "Stylised/stylised-scroll-center-light.png"
			addon.API.Presets.EDGE_STYLISED_SCROLL = addon.API.Util.PATH .. "Stylised/stylised-scroll-border-light.png"

			addon.API.Presets.BG_STYLISED_SCROLL_02 = addon.API.Util.PATH .. "Stylised/stylised-scroll-center-dark.png"
			addon.API.Presets.EDGE_STYLISED_SCROLL_02 = addon.API.Util.PATH .. "Stylised/stylised-scroll-border-dark.png"
		end

		do -- NINESLICE
			addon.API.Presets.NINESLICE_STYLISED_SCROLL = addon.API.Util.PATH .. "Stylised/stylised-scroll-nineslice-light.png"

			addon.API.Presets.NINESLICE_STYLISED_SCROLL_02 = addon.API.Util.PATH .. "Stylised/stylised-scroll-nineslice-dark.png"
		end
	end
end

--------------------------------
-- FORGED
--------------------------------

do
	addon.API.Presets.NINESLICE_FORGED = addon.API.Util.PATH .. "Forged/forged-nineslice.png"
end

--------------------------------
-- INSCRIBED
--------------------------------

do
	do -- NINESLICE
		addon.API.Presets.NINESLICE_INSCRIBED = addon.API.Util.PATH .. "Inscribed/inscribed-nineslice.png"
		addon.API.Presets.NINESLICE_INSCRIBED_BORDER = addon.API.Util.PATH .. "Inscribed/inscribed-border-nineslice.png"
		addon.API.Presets.NINESLICE_INSCRIBED_BORDER_HIGHLIGHT = addon.API.Util.PATH .. "Inscribed/inscribed-border-highlighted-nineslice.png"
	end

	do -- FILLED
		addon.API.Presets.NINESLICE_INSCRIBED_FILLED = addon.API.Util.PATH .. "Inscribed/inscribed-filled-nineslice.png"
		addon.API.Presets.NINESLICE_INSCRIBED_FILLED_HIGHLIGHT = addon.API.Util.PATH .. "Inscribed/inscribed-filled-highlighted-nineslice.png"
	end
end

--------------------------------
-- INSCRIBED BACKGROUND
--------------------------------

do
	addon.API.Presets.NINESLICE_INSCRIBED_BACKGROUND = addon.API.Util.PATH .. "Inscribed/inscribed-background-nineslice-light.png"
	addon.API.Presets.NINESLICE_INSCRIBED_BACKGROUND_HIGHLIGHT = addon.API.Util.PATH .. "Inscribed/inscribed-background-highlighted-nineslice-light.png"
	addon.API.Presets.NINESLICE_INSCRIBED_BACKGROUND_02 = addon.API.Util.PATH .. "Inscribed/inscribed-background-nineslice-dark.png"
	addon.API.Presets.NINESLICE_INSCRIBED_BACKGROUND_HIGHLIGHT_02 = addon.API.Util.PATH .. "Inscribed/inscribed-background-highlighted-nineslice-dark.png"
end

--------------------------------
-- WEATHERED
--------------------------------

do
	do -- NINESLICE
		addon.API.Presets.NINESLICE_WEATHERED = addon.API.Util.PATH .. "Weathered/weathered-nineslice.png"
		addon.API.Presets.NINESLICE_WEATHERED_HIGHLIGHT = addon.API.Util.PATH .. "Weathered/weathered-highlighted-nineslice-light.png"
		addon.API.Presets.NINESLICE_WEATHERED_02 = addon.API.Util.PATH .. "Weathered/weathered-nineslice-light.png"
		addon.API.Presets.NINESLICE_WEATHERED_HIGHLIGHT_02 = addon.API.Util.PATH .. "Weathered/weathered-highlighted-nineslice-dark.png"
	end

	do -- SPRITESHEET
		addon.API.Presets.NINESLICE_WEATHERED_SPRITESHEET = addon.API.Util.PATH .. "Weathered/Spritesheet/weathered-nineslice.png"
		addon.API.Presets.NINESLICE_WEATHERED_SPRITESHEET_TOTALFRAMES = 24
	end

	do -- FORGED
		addon.API.Presets.NINESLICE_WEATHERED_FORGED = addon.API.Util.PATH .. "Weathered/weathered-forged-nineslice.png"
	end
end

--------------------------------
-- RUSTIC
--------------------------------

do
	do -- NINESLICE
		addon.API.Presets.NINESLICE_RUSTIC_FILLED = addon.API.Util.PATH .. "Rustic/rustic-filled-nineslice.png"
		addon.API.Presets.NINESLICE_RUSTIC_BORDER = addon.API.Util.PATH .. "Rustic/rustic-border-nineslice.png"
	end
end

--------------------------------
-- TOOLTIP
--------------------------------

do
	do -- TOOLTIP
		addon.API.Presets.NINESLICE_TOOLTIP = addon.API.Util.PATH .. "Tooltip/tooltip-nineslice-light.png"
		addon.API.Presets.NINESLICE_TOOLTIP_02 = addon.API.Util.PATH .. "Tooltip/tooltip-nineslice-dark.png"
	end

	do -- CUSTOM TOOLTIP
        addon.API.Presets.NINESLICE_TOOLTIP_CUSTOM = addon.API.Util.PATH .. "Tooltip/tooltip-custom-nineslice-light.png"
		addon.API.Presets.NINESLICE_TOOLTIP_CUSTOM_02 = addon.API.Util.PATH .. "Tooltip/tooltip-custom-nineslice-dark.png"
	end
end

--------------------------------
-- VIGNETTE
--------------------------------

do
	addon.API.Presets.NINESLICE_VIGNETTE_DARK = addon.API.Util.PATH .. "Vignette/vignette-nineslice-dark.png"
	addon.API.Presets.NINESLICE_VIGNETTE_LIGHT = addon.API.Util.PATH .. "Vignette/vignette-nineslice-light.png"
end
