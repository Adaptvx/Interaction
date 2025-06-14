---@class addon
local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local PrefabRegistry = addon.PrefabRegistry
local L = addon.Locales
local NS = addon.Alert; addon.Alert = NS

--------------------------------

NS.Variables = {}

--------------------------------
-- VARIABLES
--------------------------------

do -- MAIN

end

do -- CONSTANTS
	do -- MAIN
		NS.Variables.PATH = addon.Variables.PATH_ART .. "Alert/"

		NS.Variables.FRAME_STRATA = "FULLSCREEN_DIALOG"
		NS.Variables.FRAME_LEVEL = 99
		NS.Variables.FRAME_LEVEL_MAX = 999
	end
end

--------------------------------
-- EVENTS
--------------------------------
