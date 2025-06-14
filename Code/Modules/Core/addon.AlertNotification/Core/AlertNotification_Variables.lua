---@class addon
local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local PrefabRegistry = addon.PrefabRegistry
local L = addon.Locales
local NS = addon.AlertNotification; addon.AlertNotification = NS

--------------------------------

NS.Variables = {}

--------------------------------
-- VARIABLES
--------------------------------

do -- MAIN

end

do  -- CONSTANTS
	do -- SCALE
		NS.Variables.RATIO_REFERENCE = 625

		--------------------------------

		do -- FUNCTIONS
			function NS.Variables:RATIO(level)
				return NS.Variables.RATIO_REFERENCE / addon.Variables:RAW_RATIO(level)
			end
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
