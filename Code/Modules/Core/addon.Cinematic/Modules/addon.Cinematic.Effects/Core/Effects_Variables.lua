---@class addon
local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local PrefabRegistry = addon.PrefabRegistry
local L = addon.Locales
local NS = addon.Cinematic.Effects; addon.Cinematic.Effects = NS

--------------------------------

NS.Variables = {}

--------------------------------
-- VARIABLES
--------------------------------

do -- MAIN

end

do  -- CONSTANTS
	do -- SCALE
		NS.Variables.RATIO_REFERENCE = 45

		--------------------------------

		do -- FUNCTIONS
			function NS.Variables:RATIO(level)
				return NS.Variables.RATIO_REFERENCE / addon.Variables:RAW_RATIO(level)
			end
		end
	end

	do -- MAIN
		NS.Variables.FRAME_STRATA = "HIGH"
		NS.Variables.FRAME_LEVEL = 1
		NS.Variables.FRAME_LEVEL_MAX = 999
	end
end

--------------------------------
-- EVENTS
--------------------------------
