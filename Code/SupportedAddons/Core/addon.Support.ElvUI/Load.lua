---@class addon
local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local PrefabRegistry = addon.PrefabRegistry
local L = addon.Locales

--------------------------------

addon.Support.ElvUI = {}
local NS = addon.Support.ElvUI; addon.Support.ElvUI = NS

--------------------------------

function NS:Load()
	local function Modules()
		addon.Support.ElvUI.Script:Load()
	end

	--------------------------------

	Modules()
end

CallbackRegistry:Add("LOADED_ADDONS_READY", function()
	if addon.LoadedAddons.ElvUI then
		NS:Load()
	end
end)
