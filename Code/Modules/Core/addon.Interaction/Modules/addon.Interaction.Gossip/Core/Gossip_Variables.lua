local addonName, addon = ...
local CallbackRegistry = addon.CallbackRegistry
local PrefabRegistry = addon.PrefabRegistry
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
	NS.Variables.RefreshInProgress = false
end

do  -- CONSTANTS
	do -- SCALE
		NS.Variables.BUTTON_SPACING = -5
		NS.Variables.BASELINE_WIDTH = 100
		NS.Variables.BASELINE_HEIGHT = 45

		--------------------------------

		function NS.Variables:RATIO(level)
			return NS.Variables.BASELINE_HEIGHT / addon.Variables:RAW_RATIO(level)
		end
	end

	do -- MAIN
		NS.Variables.PATH = addon.Variables.PATH_ART .. "Gossip/"
		NS.Variables.PADDING = 10

		NS.Variables.FRAME_STRATA = "HIGH"
		NS.Variables.FRAME_LEVEL = 99
		NS.Variables.FRAME_LEVEL_MAX = 999
	end
end

do -- REFERENCES
	NS.Variables.Buttons = {}
end

--------------------------------
-- EVENTS
--------------------------------
