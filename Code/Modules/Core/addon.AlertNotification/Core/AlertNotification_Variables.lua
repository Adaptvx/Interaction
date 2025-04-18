local addonName, addon = ...
local CallbackRegistry = addon.CallbackRegistry
local PrefabRegistry = addon.PrefabRegistry
local L = addon.Locales
local NS = addon.AlertNotification

--------------------------------

NS.Variables = {}

--------------------------------
-- VARIABLES
--------------------------------

do -- MAIN

end

do -- CONSTANTS
	do -- SCALE
		NS.Variables.BASELINE_WIDTH = 625 * .75
		NS.Variables.BASELINE_HEIGHT = 625

		--------------------------------

		function NS.Variables:RATIO(level)
			return NS.Variables.BASELINE_HEIGHT / addon.Variables:RAW_RATIO(level)
		end
	end

	do -- MAIN
		NS.Variables.PATH = addon.Variables.PATH_ART .. "AlertNotification/"

		NS.Variables.FRAME_STRATA = "FULLSCREEN_DIALOG"
		NS.Variables.FRAME_LEVEL = 99
		NS.Variables.FRAME_LEVEL_MAX = 999
	end

	do -- PADDING
		NS.Variables.PADDING = NS.Variables:RATIO(8)
	end
end

--------------------------------
-- EVENTS
--------------------------------
