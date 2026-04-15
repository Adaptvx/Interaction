local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local TemplateRegistry = addon.TemplateRegistry
local L = addon.Locales

addon.BlizzardMinimapIcon = {}
local NS = addon.BlizzardMinimapIcon; addon.BlizzardMinimapIcon = NS

function NS:Load()
	local function Modules()
		NS.Elements:Load()
		NS.Script:Load()
	end

	Modules()
end
