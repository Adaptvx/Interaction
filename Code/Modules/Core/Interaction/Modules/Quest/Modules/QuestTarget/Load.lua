local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local TemplateRegistry = addon.TemplateRegistry
local L = addon.Locales

addon.Interaction.Quest.Target = {}
local NS = addon.Interaction.Quest.Target; addon.Interaction.Quest.Target = NS

function NS:Load()
	local function Modules()
		NS.Elements:Load()
		NS.Script:Load()
	end

	Modules()
end
