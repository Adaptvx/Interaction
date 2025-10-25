---@class addon
local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local PrefabRegistry = addon.PrefabRegistry
local L = addon.Locales

--------------------------------

addon.Interaction = {}
local NS = addon.Interaction; addon.Interaction = NS

--------------------------------

function NS:Load()
	local function Modules()
		NS.Script:Load()
	end

	local function Submodules()
		NS.Dialog:Load()
		NS.Gossip:Load()
		NS.Quest:Load()
	end

	--------------------------------

	Modules()

	C_Timer.After(0, function()
		Submodules()
	end)
end
