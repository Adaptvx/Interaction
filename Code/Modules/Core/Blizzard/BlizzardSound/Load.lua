local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local TemplateRegistry = addon.TemplateRegistry
local L = addon.Locales

addon.BlizzardSound = {}
local NS = addon.BlizzardSound; addon.BlizzardSound = NS

function NS:Load()
	local function Modules()
		NS.Script:Load()
	end

	Modules()
end
