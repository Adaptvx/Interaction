local addonName, addon = ...
local CallbackRegistry = addon.CallbackRegistry
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
		NS.Variables.PATH = addon.Variables.PATH .. "Art/QuestTarget/"
	end
end



--------------------------------
-- EVENTS
--------------------------------
