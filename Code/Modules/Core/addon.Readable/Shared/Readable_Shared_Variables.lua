---@class addon
local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local PrefabRegistry = addon.PrefabRegistry
local L = addon.Locales
local NS = addon.Readable; addon.Readable = NS

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

do  -- CONSTANTS
	do -- SCALE
		NS.Variables.RATIO_REFERENCE = addon.API.Main:GetScreenHeight()

		--------------------------------

		do -- FUNCTIONS
			function NS.Variables:RATIO(level)
				return NS.Variables.RATIO_REFERENCE / addon.Variables:RAW_RATIO(level)
			end
		end
	end

	do -- MAIN
		NS.Variables.READABLE_UI_PATH = addon.Variables.PATH_ART .. "Readable/"

		NS.Variables.SCREEN_WIDTH = addon.API.Main:GetScreenWidth()
		NS.Variables.SCREEN_HEIGHT = addon.API.Main:GetScreenHeight()

		NS.Variables.NINESLICE_DEFAULT = NS.Variables.READABLE_UI_PATH .. "Elements/button-nineslice.png"
		NS.Variables.NINESLICE_HEAVY = NS.Variables.READABLE_UI_PATH .. "Elements/button-heavy-nineslice.png"
		NS.Variables.NINESLICE_HIGHLIGHT = NS.Variables.READABLE_UI_PATH .. "Elements/button-highlighted-nineslice.png"
		NS.Variables.NINESLICE_RUSTIC = addon.API.Presets.NINESLICE_RUSTIC_FILLED
		NS.Variables.NINESLICE_RUSTIC_BORDER = addon.API.Presets.NINESLICE_RUSTIC_BORDER
		NS.Variables.TEXTURE_CHECK = NS.Variables.READABLE_UI_PATH .. "Elements/checkbox-checked.png"
	end
end

--------------------------------
-- EVENTS
--------------------------------
