local addonName, addon = ...
local CallbackRegistry = addon.CallbackRegistry
local PrefabRegistry = addon.PrefabRegistry
local L = addon.Locales
local NS = addon.Interaction.Dialog

--------------------------------

NS.Variables = {}

--------------------------------
-- VARIABLES
--------------------------------

do -- MAIN
	NS.Variables.info = {
		["type"] = nil,
		["npcInfo"] = {
			["name"] = nil,
			["guid"] = nil,
		},
		["contextIcon"] = nil,
		["title"] = nil,
		["contentInfo"] = {
			["full"] = nil,
			["split"] = nil,
			["formatted"] = nil,
			["emoteIndexes"] = nil,
		},
	}

	NS.Variables.Playback_Valid = nil
	NS.Variables.Playback_Index = nil
	NS.Variables.Playback_Freeze = nil
	NS.Variables.Playback_AutoProgress = nil
	NS.Variables.Playback_Finished = nil

	NS.Variables.Style_IsDialog = nil
	NS.Variables.Style_IsScroll = nil
	NS.Variables.Style_IsRustic = nil
	NS.Variables.Style_IsEmote = nil
end

do  -- CONSTANTS
	do -- SCALE
		NS.Variables.BASELINE_WIDTH = 100
		NS.Variables.BASELINE_HEIGHT = 45

		--------------------------------

		function NS.Variables:RATIO(level)
			return NS.Variables.BASELINE_HEIGHT / addon.Variables:RAW_RATIO(level)
		end
	end

	do -- MAIN
		NS.Variables.FRAME_MAX_WIDTH = 350

		NS.Variables.FRAME_STRATA = "BACKGROUND"
		NS.Variables.FRAME_STRATA_MAX = "FULLSCREEN"
		NS.Variables.FRAME_LEVEL = 1
		NS.Variables.FRAME_LEVEL_MAX = 999
	end

	do -- PADDING
		NS.Variables.PADDING = NS.Variables:RATIO(8)
	end
end

--------------------------------
-- EVENTS
--------------------------------
