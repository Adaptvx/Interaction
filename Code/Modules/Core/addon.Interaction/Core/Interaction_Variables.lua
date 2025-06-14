---@class addon
local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local PrefabRegistry = addon.PrefabRegistry
local L = addon.Locales
local NS = addon.Interaction; addon.Interaction = NS

--------------------------------

NS.Variables = {}

--------------------------------
-- VARIABLES
--------------------------------

do -- MAIN
	-- STATE
	NS.Variables.Active = false
	NS.Variables.LastActive = nil
	NS.Variables.CurrentSession = {
		["type"] = nil,
		["questID"] = nil,
		["dialogText"] = nil,
		["npc"] = nil
	}

	-- QUEST
	NS.Variables.LastQuestNPC = nil

	-- INFO
	NS.Variables.CurrentSession.type = nil
end

do -- CONSTANTS

end

--------------------------------
-- EVENTS
--------------------------------
