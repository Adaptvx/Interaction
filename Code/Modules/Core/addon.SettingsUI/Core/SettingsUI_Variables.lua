local addonName, addon = ...
local PrefabRegistry = addon.PrefabRegistry
local CallbackRegistry = addon.CallbackRegistry
local L = addon.Locales
local NS = addon.SettingsUI

--------------------------------

NS.Variables = {}

--------------------------------
-- VARIABLES
--------------------------------

do -- MAIN

end

do -- CONSTANTS
	do -- SCALE
		NS.Variables.BASELINE_WIDTH = 875
		NS.Variables.BASELINE_HEIGHT = 875 * .65

		--------------------------------

		function NS.Variables:RATIO(level)
			return NS.Variables.BASELINE_HEIGHT / addon.Variables:RAW_RATIO(level)
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
