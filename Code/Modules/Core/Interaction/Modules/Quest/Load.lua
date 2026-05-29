local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local TemplateRegistry = addon.TemplateRegistry
local L = addon.Locales

addon.Interaction.Quest = {}
local NS = addon.Interaction.Quest; addon.Interaction.Quest = NS

function NS:Load()
	local function Modules()
		NS.Elements:Load()
		NS.Script:Load()
	end

	local function Templates()
		NS.Templates:Load()
	end

	local function Submodules()
		NS.Target:Load()
	end

	Templates()
	Modules()

	C_Timer.After(0, function()
		Submodules()
	end)
end
