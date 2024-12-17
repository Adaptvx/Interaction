local addonName, addon = ...
local CallbackRegistry = addon.CallbackRegistry
local L = addon.Locales
local NS = addon.PromptText

--------------------------------

NS.Variables = {}

--------------------------------
-- VARIABLES
--------------------------------

do -- MAIN

end

do -- CONSTANTS
	NS.Variables.PATH = addon.Variables.PATH .. "Art/Readable/"
	NS.Variables.NINESLICE_DEFAULT = NS.Variables.PATH .. "Elements/button-nineslice.png"
	NS.Variables.NINESLICE_HEAVY = NS.Variables.PATH .. "Elements/button-heavy-nineslice.png"
	NS.Variables.NINESLICE_HIGHLIGHT = NS.Variables.PATH .. "Elements/button-highlighted-nineslice.png"
end

--------------------------------
-- EVENTS
--------------------------------
