local addonName, addon = ...
local CallbackRegistry = addon.CallbackRegistry
local L = addon.Locales
local NS = addon.Interaction.Gossip

--------------------------------

NS.Variables = {}

--------------------------------
-- VARIABLES
--------------------------------

do -- MAIN
	NS.Variables.NumCurrentButtons = 0
	NS.Variables.State = ""
	NS.Variables.NPC = ""
	NS.Variables.LastNPC = ""
	NS.Variables.ThemeUpdateTransition = false
end

do -- CONSTANTS
	do -- SCALE
		NS.Variables.BASELINE_WIDTH = 100
		NS.Variables.BASELINE_HEIGHT = 45

		--------------------------------

		function NS.Variables:RATIO(level)
			return NS.Variables.BASELINE_HEIGHT / addon.Variables:RAW_RATIO(level)
		end
	end

	do -- MAIN
		NS.Variables.PATH = addon.Variables.PATH .. "Art/Gossip/"
		NS.Variables.PADDING = 10
	end
end

--------------------------------
-- EVENTS
--------------------------------
