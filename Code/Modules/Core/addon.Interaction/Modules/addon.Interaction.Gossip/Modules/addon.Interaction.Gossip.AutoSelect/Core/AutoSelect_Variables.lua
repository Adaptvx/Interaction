---@class addon
local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local PrefabRegistry = addon.PrefabRegistry
local L = addon.Locales
local NS = addon.Interaction.Gossip.AutoSelect; addon.Interaction.Gossip.AutoSelect = NS

--------------------------------

NS.Variables = {}

--------------------------------
-- VARIABLES
--------------------------------

do -- MAIN

end

do -- CONSTANTS
	NS.Variables.ALWAYS = "Always"
	NS.Variables.ONLY_OPTION = "Only Option"

	NS.Variables.DB = {
		[120910] = NS.Variables.ONLY_OPTION, -- (Dornogal) Dornagal Flight Point
		[121665] = NS.Variables.ALWAYS, -- (Dornogal) Trading Post
		[121672] = NS.Variables.ALWAYS, -- (Dornogal) Trading Post
		[107824] = NS.Variables.ALWAYS, -- Trading Post
		[107827] = NS.Variables.ALWAYS, -- Trading Post
		[107825] = NS.Variables.ALWAYS, -- Trading Post
		[107826] = NS.Variables.ALWAYS, -- Trading Post
		[48598] = NS.Variables.ALWAYS, -- Katy Stampwhistle
		[120733] = NS.Variables.ALWAYS, -- Theater Troupe
	}
end

--------------------------------
-- EVENTS
--------------------------------
