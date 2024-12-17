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
	NS.Variables.PlaybackLineIndex = nil

	NS.Variables.Title = nil
	NS.Variables.NumPages = nil
	NS.Variables.Content = nil
	NS.Variables.Lines = nil
end

do -- CONSTANTS
	NS.Variables.AUDIOBOOKUI_PATH = addon.Variables.PATH .. "Art/Audiobook/"
	NS.Variables.READABLEUI_PATH = addon.Variables.PATH .. "Art/Readable/"

	NS.Variables.NINESLICE_DEFAULT = NS.Variables.READABLEUI_PATH .. "Elements/button-nineslice.png"
	NS.Variables.NINESLICE_HEAVY = NS.Variables.READABLEUI_PATH .. "Elements/button-heavy-nineslice.png"
	NS.Variables.NINESLICE_HIGHLIGHT = NS.Variables.READABLEUI_PATH .. "Elements/button-highlighted-nineslice.png"

	NS.Variables.PADDING = 10
end

--------------------------------
-- EVENTS
--------------------------------
