---@class addon
local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local PrefabRegistry = addon.PrefabRegistry
local L = addon.Locales
local NS = addon.Interaction.Dialog; addon.Interaction.Dialog = NS

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
		NS.Variables.RATIO_REFERENCE = 45

		--------------------------------

		do -- FUNCTIONS
			function NS.Variables:RATIO(level)
				return NS.Variables.RATIO_REFERENCE / addon.Variables:RAW_RATIO(level)
			end
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
