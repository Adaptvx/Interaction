local addonName, addon = ...

--------------------------------
-- VARIABLES
--------------------------------

AdaptiveAPI.Presets = {}

do -- MAIN
	AdaptiveAPI.Presets.UIModifier = .325
	AdaptiveAPI.Presets.UITextModifier = 1
end

do -- CONSTANTS

end

--------------------------------
-- BASIC SHAPES
--------------------------------

do
	AdaptiveAPI.Presets.BASIC_SQUARE = AdaptiveAPI.PATH .. "BasicShapes/square.png"
end

--------------------------------
-- SHARP
--------------------------------

do
	do -- TOOLTIP
		AdaptiveAPI.Presets.BG_SHARP = AdaptiveAPI.PATH .. "Sharp/sharp-center.png"
		AdaptiveAPI.Presets.EDGE_SHARP = AdaptiveAPI.PATH .. "Sharp/sharp-border.png"
		AdaptiveAPI.Presets.DIALOG_SHARP = AdaptiveAPI.PATH .. "Sharp/sharp-dialog.png"
	end

	do -- NINESLICE
		AdaptiveAPI.Presets.NINESLICE_SHARP = AdaptiveAPI.PATH .. "Sharp/sharp-nineslice.png"
		AdaptiveAPI.Presets.NINESLICE_SHARP_SPRITESHEET = AdaptiveAPI.PATH .. "Sharp/Spritesheet/sharp-nineslice.png"
		AdaptiveAPI.Presets.NINESLICE_SHARP_SPRITESHEET_TOTALFRAMES = 25
	end
end

--------------------------------
-- STYLISED
--------------------------------

do
	do -- TOOLTIP
		AdaptiveAPI.Presets.BG_STYLISED = AdaptiveAPI.PATH .. "Stylised/stylised-center.png"
		AdaptiveAPI.Presets.EDGE_STYLISED = AdaptiveAPI.PATH .. "Stylised/stylised-border.png"
		AdaptiveAPI.Presets.BG_STYLISED_HIGHLIGHT = AdaptiveAPI.PATH .. "Stylised/stylised-center-highlighted.png"
		AdaptiveAPI.Presets.EDGE_STYLISED_HIGHLIGHT = AdaptiveAPI.PATH .. "Stylised/stylised-edge-highlighted.png"
	end

	do -- SCROLL
		do -- TOOLTIP
			AdaptiveAPI.Presets.BG_STYLISED_SCROLL = AdaptiveAPI.PATH .. "Stylised/stylised-scroll-center-light.png"
			AdaptiveAPI.Presets.EDGE_STYLISED_SCROLL = AdaptiveAPI.PATH .. "Stylised/stylised-scroll-border-light.png"

			AdaptiveAPI.Presets.BG_STYLISED_SCROLL_02 = AdaptiveAPI.PATH .. "Stylised/stylised-scroll-center-dark.png"
			AdaptiveAPI.Presets.EDGE_STYLISED_SCROLL_02 = AdaptiveAPI.PATH .. "Stylised/stylised-scroll-border-dark.png"
		end

		do -- NINESLICE
			AdaptiveAPI.Presets.NINESLICE_STYLISED_SCROLL = AdaptiveAPI.PATH .. "Stylised/stylised-scroll-nineslice-light.png"

			AdaptiveAPI.Presets.NINESLICE_STYLISED_SCROLL_02 = AdaptiveAPI.PATH .. "Stylised/stylised-scroll-nineslice-dark.png"
		end
	end
end

--------------------------------
-- FORGED
--------------------------------

do
	AdaptiveAPI.Presets.NINESLICE_FORGED = AdaptiveAPI.PATH .. "Forged/forged-nineslice.png"
end

--------------------------------
-- INSCRIBED
--------------------------------

do
	do -- NINESLICE
		AdaptiveAPI.Presets.NINESLICE_INSCRIBED = AdaptiveAPI.PATH .. "Inscribed/inscribed-nineslice.png"
		AdaptiveAPI.Presets.NINESLICE_INSCRIBED_BORDER = AdaptiveAPI.PATH .. "Inscribed/inscribed-border-nineslice.png"
		AdaptiveAPI.Presets.NINESLICE_INSCRIBED_BORDER_HIGHLIGHT = AdaptiveAPI.PATH .. "Inscribed/inscribed-border-highlighted-nineslice.png"
	end

	do -- FILLED
		AdaptiveAPI.Presets.NINESLICE_INSCRIBED_FILLED = AdaptiveAPI.PATH .. "Inscribed/inscribed-filled-nineslice.png"
		AdaptiveAPI.Presets.NINESLICE_INSCRIBED_FILLED_HIGHLIGHT = AdaptiveAPI.PATH .. "Inscribed/inscribed-filled-highlighted-nineslice.png"
	end
end

--------------------------------
-- INSCRIBED BACKGROUND
--------------------------------

do
	AdaptiveAPI.Presets.NINESLICE_INSCRIBED_BACKGROUND = AdaptiveAPI.PATH .. "Inscribed/inscribed-background-nineslice-light.png"
	AdaptiveAPI.Presets.NINESLICE_INSCRIBED_BACKGROUND_HIGHLIGHT = AdaptiveAPI.PATH .. "Inscribed/inscribed-background-highlighted-nineslice-light.png"
	AdaptiveAPI.Presets.NINESLICE_INSCRIBED_BACKGROUND_02 = AdaptiveAPI.PATH .. "Inscribed/inscribed-background-nineslice-dark.png"
	AdaptiveAPI.Presets.NINESLICE_INSCRIBED_BACKGROUND_HIGHLIGHT_02 = AdaptiveAPI.PATH .. "Inscribed/inscribed-background-highlighted-nineslice-dark.png"
end

--------------------------------
-- WEATHERED
--------------------------------

do
	do -- NINESLICE
		AdaptiveAPI.Presets.NINESLICE_WEATHERED = AdaptiveAPI.PATH .. "Weathered/weathered-nineslice.png"
		AdaptiveAPI.Presets.NINESLICE_WEATHERED_HIGHLIGHT = AdaptiveAPI.PATH .. "Weathered/weathered-highlighted-nineslice-light.png"
		AdaptiveAPI.Presets.NINESLICE_WEATHERED_02 = AdaptiveAPI.PATH .. "Weathered/weathered-nineslice-light.png"
		AdaptiveAPI.Presets.NINESLICE_WEATHERED_HIGHLIGHT_02 = AdaptiveAPI.PATH .. "Weathered/weathered-highlighted-nineslice-dark.png"
	end

	do -- SPRITESHEET
		AdaptiveAPI.Presets.NINESLICE_WEATHERED_SPRITESHEET = AdaptiveAPI.PATH .. "Weathered/Spritesheet/weathered-nineslice.png"
		AdaptiveAPI.Presets.NINESLICE_WEATHERED_SPRITESHEET_TOTALFRAMES = 24
	end

	do -- FORGED
		AdaptiveAPI.Presets.NINESLICE_WEATHERED_FORGED = AdaptiveAPI.PATH .. "Weathered/weathered-forged-nineslice.png"
	end
end

--------------------------------
-- RUSTIC
--------------------------------

do
	do -- NINESLICE
		AdaptiveAPI.Presets.NINESLICE_RUSTIC_FILLED = AdaptiveAPI.PATH .. "Rustic/rustic-filled-nineslice.png"
		AdaptiveAPI.Presets.NINESLICE_RUSTIC_BORDER = AdaptiveAPI.PATH .. "Rustic/rustic-border-nineslice.png"
	end
end

--------------------------------
-- TOOLTIP
--------------------------------

do
	do -- TOOLTIP
		AdaptiveAPI.Presets.NINESLICE_TOOLTIP = AdaptiveAPI.PATH .. "Tooltip/tooltip-nineslice-light.png"
		AdaptiveAPI.Presets.NINESLICE_TOOLTIP_02 = AdaptiveAPI.PATH .. "Tooltip/tooltip-nineslice-dark.png"
	end

	do -- CUSTOM TOOLTIP
        AdaptiveAPI.Presets.NINESLICE_TOOLTIP_CUSTOM = AdaptiveAPI.PATH .. "Tooltip/tooltip-custom-nineslice-light.png"
		AdaptiveAPI.Presets.NINESLICE_TOOLTIP_CUSTOM_02 = AdaptiveAPI.PATH .. "Tooltip/tooltip-custom-nineslice-dark.png"
	end
end

--------------------------------
-- VIGNETTE
--------------------------------

do
	AdaptiveAPI.Presets.NINESLICE_VIGNETTE_DARK = AdaptiveAPI.PATH .. "Vignette/vignette-nineslice-dark.png"
	AdaptiveAPI.Presets.NINESLICE_VIGNETTE_LIGHT = AdaptiveAPI.PATH .. "Vignette/vignette-nineslice-light.png"
end
