local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local TemplateRegistry = addon.TemplateRegistry
local L = addon.Locales

addon.Interaction.Gossip.AutoSelect = {}
local NS = addon.Interaction.Gossip.AutoSelect; addon.Interaction.Gossip.AutoSelect = NS

function NS:Load()
	local function Modules()
		NS.Script:Load()
	end

	Modules()
end
