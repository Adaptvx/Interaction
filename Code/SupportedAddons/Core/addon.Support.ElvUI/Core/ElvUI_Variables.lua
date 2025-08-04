---@class addon
local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local PrefabRegistry = addon.PrefabRegistry
local L = addon.Locales
local NS = addon.Support.ElvUI; addon.Support.ElvUI = NS

--------------------------------

NS.Variables = {}

--------------------------------
-- VARIABLES
--------------------------------

do -- MAIN

end

do -- CONSTANTS
	do -- MAIN
		NS.Variables.PATH = addon.Variables.PATH_ART .. "SupportedAddons/ElvUI/"
		NS.Variables.DIALOG_BACKGROUND = NS.Variables.PATH .. "Art/dialog-background.png"
	end
end

--------------------------------
-- EVENTS
--------------------------------
