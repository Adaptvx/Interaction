local addonName, addon = ...
local CallbackRegistry = addon.CallbackRegistry
local PrefabRegistry = addon.PrefabRegistry
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
	NS.Variables.PATH = addon.Variables.PATH_ART .. "Icons/"
end

--------------------------------
-- EVENTS
--------------------------------
