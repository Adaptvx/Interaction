local addonName, addon = ...
local CallbackRegistry = addon.CallbackRegistry
local L = addon.Locales
local NS = addon.Interaction

--------------------------------

NS.Variables = {}

--------------------------------
-- VARIABLES
--------------------------------

do -- MAIN
	-- GOSSIP
	NS.Variables.GossipLastNPC = nil
	NS.Variables.GossipFirstInteractMessage = nil

	-- STATE
	NS.Variables.Active = false
	NS.Variables.LastActive = nil
	NS.Variables.StartInteractionTime = nil
	NS.Variables.LastActiveTime = nil

	-- QUEST
	NS.Variables.LastQuestNPC = nil
	NS.Variables.SelectedOptionIcon = nil
	NS.Variables.SelectedOptionText = nil

	-- SAVE
	NS.Variables.SavedSelectedOptionText = nil
	NS.Variables.Type = nil
	NS.Variables.SavedNPC = nil
end

do -- CONSTANTS

end

--------------------------------
-- EVENTS
--------------------------------
