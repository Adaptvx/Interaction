local addonName, addon = ...
local CallbackRegistry = addon.CallbackRegistry
local L = addon.Locales
local NS = addon.Audiobook

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

do -- CONSTANTS
	do -- SCALE
		NS.Variables.FRAME_WIDTH = 350
		NS.Variables.FRAME_HEIGHT = 50

		NS.Variables.BASELINE_WIDTH = NS.Variables.FRAME_WIDTH
		NS.Variables.BASELINE_HEIGHT = NS.Variables.FRAME_HEIGHT

		--------------------------------

		function NS.Variables:RATIO(level)
			return NS.Variables.BASELINE_HEIGHT / addon.Variables:RAW_RATIO(level)
		end
	end

	do -- MAIN
		NS.Variables.AUDIOBOOKUI_PATH = addon.Variables.PATH .. "Art/Audiobook/"
		NS.Variables.READABLEUI_PATH = addon.Variables.PATH .. "Art/Readable/"

		NS.Variables.NINESLICE_DEFAULT = NS.Variables.READABLEUI_PATH .. "Elements/button-nineslice.png"
		NS.Variables.NINESLICE_HEAVY = NS.Variables.READABLEUI_PATH .. "Elements/button-heavy-nineslice.png"
		NS.Variables.NINESLICE_HIGHLIGHT = NS.Variables.READABLEUI_PATH .. "Elements/button-highlighted-nineslice.png"

		NS.Variables.PADDING = 10
	end
end

--------------------------------
-- EVENTS
--------------------------------
