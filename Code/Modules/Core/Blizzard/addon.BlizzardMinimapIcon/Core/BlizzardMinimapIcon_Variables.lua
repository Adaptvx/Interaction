local addonName, addon = ...
local PrefabRegistry = addon.PrefabRegistry
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
	NS.Variables.PATH = addon.Variables.PATH_ART .. "Icons/"
end

--------------------------------
-- EVENTS
--------------------------------
