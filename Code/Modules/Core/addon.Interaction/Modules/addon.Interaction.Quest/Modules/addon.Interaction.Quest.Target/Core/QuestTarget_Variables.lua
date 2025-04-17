local addonName, addon = ...
local CallbackRegistry = addon.CallbackRegistry
local PrefabRegistry = addon.PrefabRegistry
local L = addon.Locales
local NS = addon.Interaction.Quest.Target

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
		NS.Variables.PADDING = NS.Variables:RATIO(9)
		NS.Variables.CONTENT_PADDING = NS.Variables:RATIO(8.5)
		NS.Variables.PATH = addon.Variables.PATH_ART .. "QuestTarget/"

		NS.Variables.FRAME_STRATA = "FULLSCREEN"
		NS.Variables.FRAME_LEVEL = 999
		NS.Variables.FRAME_LEVEL_MAX = 1999
	end
end

--------------------------------
-- EVENTS
--------------------------------
