---@class addon
local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local PrefabRegistry = addon.PrefabRegistry
local L = addon.Locales
local NS = addon.Interaction.Gossip; addon.Interaction.Gossip = NS

--------------------------------

NS.Variables = {}

--------------------------------
-- VARIABLES
--------------------------------

do -- MAIN
	NS.Variables.NumCurrentButtons = 0
	NS.Variables.State = ""
	NS.Variables.RefreshInProgress = false
	NS.Variables.CurrentSession = {
		["npc"] = nil
	}
end

do  -- CONSTANTS
	do -- SCALE
		NS.Variables.BUTTON_SPACING = -5
		NS.Variables.RATIO_REFERENCE = 45

		--------------------------------

		do -- FUNCTIONS
			function NS.Variables:RATIO(level)
				return NS.Variables.RATIO_REFERENCE / addon.Variables:RAW_RATIO(level)
			end
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
