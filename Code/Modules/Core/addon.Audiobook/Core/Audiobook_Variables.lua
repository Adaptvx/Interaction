---@class addon
local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local PrefabRegistry = addon.PrefabRegistry
local L = addon.Locales
local NS = addon.Audiobook; addon.Audiobook = NS

--------------------------------

NS.Variables = {}

--------------------------------
-- VARIABLES
--------------------------------

do -- MAIN
	NS.Variables.IsPlaying = nil
	NS.Variables.LastPlayTime = nil
	NS.Variables.PlaybackLineIndex = nil
	NS.Variables.PlaybackTimer = nil

	NS.Variables.Title = nil
	NS.Variables.NumPages = nil
	NS.Variables.Content = nil
	NS.Variables.Lines = nil
end

do  -- CONSTANTS
	do -- SCALE
		NS.Variables.FRAME_WIDTH = 350
		NS.Variables.FRAME_HEIGHT = 50

		NS.Variables.RATIO_REFERENCE = 50

		--------------------------------

		do -- FUNCTIONS
			function NS.Variables:RATIO(level)
				return NS.Variables.RATIO_REFERENCE / addon.Variables:RAW_RATIO(level)
			end
		end
	end

	do -- MAIN
		NS.Variables.AUDIOBOOKUI_PATH = addon.Variables.PATH_ART .. "Audiobook/"
		NS.Variables.READABLEUI_PATH = addon.Variables.PATH_ART .. "Readable/"

		NS.Variables.NINESLICE_DEFAULT = NS.Variables.READABLEUI_PATH .. "Elements/button-nineslice.png"
		NS.Variables.NINESLICE_HEAVY = NS.Variables.READABLEUI_PATH .. "Elements/button-heavy-nineslice.png"
		NS.Variables.NINESLICE_HIGHLIGHT = NS.Variables.READABLEUI_PATH .. "Elements/button-highlighted-nineslice.png"

		NS.Variables.PADDING = 10
	end
end

--------------------------------
-- EVENTS
--------------------------------
