---@class addon
local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local PrefabRegistry = addon.PrefabRegistry
local L = addon.Locales

--------------------------------

addon.Support.WaypointUI = {}
local NS = addon.Support.WaypointUI; addon.Support.WaypointUI = NS

--------------------------------

function NS:Load()
	local function Modules()
		addon.Support.WaypointUI.Script:Load()
	end

	--------------------------------

	Modules()
end

CallbackRegistry:Add("LOADED_ADDONS_READY", function()
	if addon.LoadedAddons.WaypointUI then
		NS:Load()
	end
end)
