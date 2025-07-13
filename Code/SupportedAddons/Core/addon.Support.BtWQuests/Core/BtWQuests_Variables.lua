---@class addon
local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local PrefabRegistry = addon.PrefabRegistry
local L = addon.Locales
local NS = addon.Support.BtWQuests; addon.Support.BtWQuests = NS

--------------------------------

NS.Variables = {}

--------------------------------
-- VARIABLES
--------------------------------

do -- MAIN
	NS.Variables.QuestChains = nil
	NS.Variables.QuestChainReferences = nil
	NS.Variables.QuestChainID = {}
end

do -- CONSTANTS

end

--------------------------------
-- EVENTS
--------------------------------
