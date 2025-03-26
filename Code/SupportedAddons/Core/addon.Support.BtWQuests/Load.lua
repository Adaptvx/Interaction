local addonName, addon = ...
local PrefabRegistry = addon.PrefabRegistry
local CallbackRegistry = addon.CallbackRegistry
local L = addon.Locales

--------------------------------

addon.Support.BtWQuests = {}
local NS = addon.Support.BtWQuests

--------------------------------

function NS:Load()
	local function Modules()
		addon.Support.BtWQuests.Script:Load()
	end

	--------------------------------

	Modules()
end

C_Timer.After(addon.Variables.INIT_DELAY_LAST, function()
	if addon.LoadedAddons.BtWQuests then
		NS:Load()
	end
end)