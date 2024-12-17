local addonName, addon = ...
local CallbackRegistry = addon.CallbackRegistry
local L = addon.Locales
local NS = addon.Readable

--------------------------------

NS.Variables = {}

--------------------------------
-- VARIABLES
--------------------------------

do -- MAIN
	NS.Variables.Frame = nil
	NS.Variables.ReadableUIFrame = nil
	NS.Variables.LibraryUIFrame = nil
end

do -- CONSTANTS
	do -- SCALE
		NS.Variables.BASELINE_WIDTH = addon.API:GetScreenHeight()
		NS.Variables.BASELINE_HEIGHT = addon.API:GetScreenHeight()

		--------------------------------

		function NS.Variables:RATIO(level)
			return NS.Variables.BASELINE_HEIGHT / addon.Variables:RAW_RATIO(level)
		end
	end

	do -- MAIN
		NS.Variables.READABLE_UI_PATH = addon.Variables.PATH .. "Art/Readable/"

		NS.Variables.SCREEN_WIDTH = addon.API:GetScreenWidth()
		NS.Variables.SCREEN_HEIGHT = addon.API:GetScreenHeight()

		NS.Variables.NINESLICE_DEFAULT = NS.Variables.READABLE_UI_PATH .. "Elements/button-nineslice.png"
		NS.Variables.NINESLICE_HEAVY = NS.Variables.READABLE_UI_PATH .. "Elements/button-heavy-nineslice.png"
		NS.Variables.NINESLICE_HIGHLIGHT = NS.Variables.READABLE_UI_PATH .. "Elements/button-highlighted-nineslice.png"
		NS.Variables.NINESLICE_RUSTIC = AdaptiveAPI.Presets.NINESLICE_RUSTIC_FILLED
		NS.Variables.NINESLICE_RUSTIC_BORDER = AdaptiveAPI.Presets.NINESLICE_RUSTIC_BORDER
		NS.Variables.TEXTURE_CHECK = NS.Variables.READABLE_UI_PATH .. "Elements/checkbox-checked.png"
	end
end

--------------------------------
-- EVENTS
--------------------------------
