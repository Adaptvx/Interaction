local addonName, addon = ...
local CallbackRegistry = addon.CallbackRegistry
local L = addon.Locales
local NS = addon.BlizzardMinimapIcon

--------------------------------

NS.Variables = {}

--------------------------------
-- VARIABLES
--------------------------------

do -- MAIN
	NS.Variables.Icon = nil
end

do -- CONSTANTS
	NS.Variables.PATH = addon.Variables.PATH .. "Art/Icons/"
end

--------------------------------
-- EVENTS
--------------------------------
