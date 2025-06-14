---@class addon
local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local PrefabRegistry = addon.PrefabRegistry
local L = addon.Locales
local NS = addon.SettingsUI; addon.SettingsUI = NS

--------------------------------

NS.Variables = {}

--------------------------------
-- VARIABLES
--------------------------------

do -- MAIN

end

do  -- CONSTANTS
	do -- SCALE
		NS.Variables.FRAME_SIZE = { x = 875, y = 875 * .65 }
		NS.Variables.RATIO_REFERENCE = 568.75

		--------------------------------

		do -- FUNCTIONS
			function NS.Variables:RATIO(level)
				return NS.Variables.RATIO_REFERENCE / addon.Variables:RAW_RATIO(level)
			end
		end
	end

	do -- MAIN
		NS.Variables.SETTINGS_PATH = addon.Variables.PATH_ART .. "Settings/"
		NS.Variables.TOOLTIP_PATH = addon.Variables.PATH_ART .. "Settings/Tooltip/"
	end
end

--------------------------------
-- EVENTS
--------------------------------
