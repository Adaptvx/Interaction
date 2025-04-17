local addonName, addon = ...
local CallbackRegistry = addon.CallbackRegistry
local PrefabRegistry = addon.PrefabRegistry
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

CallbackRegistry:Add("LOADED_ADDONS_READY", function()
	if addon.LoadedAddons.BtWQuests then
		NS:Load()
	end
end)
