local addonName, addon = ...
local CallbackRegistry = addon.CallbackRegistry
local PrefabRegistry = addon.PrefabRegistry
local L = addon.Locales
local NS = addon.Interaction

--------------------------------

NS.Variables = {}

--------------------------------
-- VARIABLES
--------------------------------

do -- MAIN
	-- STATE
	NS.Variables.Active = false
	NS.Variables.LastActive = nil

	-- QUEST
	NS.Variables.LastQuestNPC = nil

	-- INFO
	NS.Variables.Type = nil
end

do -- CONSTANTS

end

--------------------------------
-- EVENTS
--------------------------------
