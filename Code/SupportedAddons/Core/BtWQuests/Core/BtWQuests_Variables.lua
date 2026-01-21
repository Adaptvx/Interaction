local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local TemplateRegistry = addon.TemplateRegistry
local L = addon.Locales
local NS = addon.Support.BtWQuests; addon.Support.BtWQuests = NS

NS.Variables = {}

-- Variables
----------------------------------------------------------------------------------------------------

do -- Main
	NS.Variables.QuestChains = nil
	NS.Variables.QuestChainReferences = nil
	NS.Variables.QuestChainID = {}
end


-- Events
----------------------------------------------------------------------------------------------------
