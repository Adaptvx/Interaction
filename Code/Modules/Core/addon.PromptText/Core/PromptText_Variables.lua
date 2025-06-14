---@class addon
local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local PrefabRegistry = addon.PrefabRegistry
local L = addon.Locales
local NS = addon.PromptText; addon.PromptText = NS

--------------------------------

NS.Variables = {}

--------------------------------
-- VARIABLES
--------------------------------

do -- MAIN

end

do -- CONSTANTS
	NS.Variables.PATH = addon.Variables.PATH_ART .. "Readable/"
	NS.Variables.NINESLICE_DEFAULT = NS.Variables.PATH .. "Elements/button-nineslice.png"
	NS.Variables.NINESLICE_HEAVY = NS.Variables.PATH .. "Elements/button-heavy-nineslice.png"
	NS.Variables.NINESLICE_HIGHLIGHT = NS.Variables.PATH .. "Elements/button-highlighted-nineslice.png"
end

--------------------------------
-- EVENTS
--------------------------------
