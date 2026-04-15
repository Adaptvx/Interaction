local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local TemplateRegistry = addon.TemplateRegistry
local L = addon.Locales

addon.Interaction.Gossip = {}
local NS = addon.Interaction.Gossip; addon.Interaction.Gossip = NS

function NS:Load()
	local function Modules()
		NS.Elements:Load()
		NS.Script:Load()
	end

	local function Templates()
		NS.Templates:Load()
	end

	local function Submodules()
		NS.AutoSelect:Load()
		NS.FriendshipBar:Load()
	end

	Templates()
	Modules()

	C_Timer.After(0, function()
		Submodules()
	end)
end
