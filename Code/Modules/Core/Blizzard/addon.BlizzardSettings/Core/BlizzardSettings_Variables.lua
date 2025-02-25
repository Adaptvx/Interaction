local addonName, addon = ...
local PrefabRegistry = addon.PrefabRegistry
local CallbackRegistry = addon.CallbackRegistry
local L = addon.Locales
local NS = addon.BlizzardSettings

--------------------------------

NS.Variables = {}

--------------------------------
-- VARIABLES
--------------------------------

do -- MAIN

end

do  -- CONSTANTS
	do -- SCALE
		NS.Variables.BASELINE_WIDTH = 500
		NS.Variables.BASELINE_HEIGHT = 125

		--------------------------------

		function NS.Variables:RATIO(level)
			return NS.Variables.BASELINE_HEIGHT / addon.Variables:RAW_RATIO(level)
		end
	end

	do -- MAIN
		NS.Variables.PATH = addon.Variables.PATH .. "Art/Blizzard/Settings/"
	end
end

--------------------------------
-- EVENTS
--------------------------------
