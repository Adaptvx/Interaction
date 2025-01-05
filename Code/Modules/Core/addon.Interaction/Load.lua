local addonName, addon = ...
local CallbackRegistry = addon.CallbackRegistry
local L = addon.Locales

--------------------------------

addon.Interaction = {}
local NS = addon.Interaction

--------------------------------

function NS:Load()
	local function Modules()
		NS.Script:Load()
	end

	local function Submodules()
		NS.Dialog:Load()
		NS.Gossip:Load()
		NS.Quest:Load()
		NS.Effects:Load()
	end

	--------------------------------

	Modules()

	addon.Libraries.AceTimer:ScheduleTimer(function()
		Submodules()
	end, 0)
end
