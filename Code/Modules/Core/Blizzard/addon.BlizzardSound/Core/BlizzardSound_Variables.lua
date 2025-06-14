---@class addon
local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local PrefabRegistry = addon.PrefabRegistry
local L = addon.Locales
local NS = addon.BlizzardSound; addon.BlizzardSound = NS

--------------------------------

NS.Variables = {}

--------------------------------
-- VARIABLES
--------------------------------

do -- MAIN

end

do -- CONSTANTS
	NS.Variables.TargetLostSFX = 567520
	NS.Variables.QuestOpenSFX = 567504
	NS.Variables.QuestCloseSFX = 567508
end

--------------------------------
-- EVENTS
--------------------------------
