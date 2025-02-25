local addonName, addon = ...
local PrefabRegistry = addon.PrefabRegistry
local CallbackRegistry = addon.CallbackRegistry
local L = addon.Locales

--------------------------------

addon.ContextIcon = {}
local NS = addon.ContextIcon

--------------------------------

function NS:Load()
	local function Modules()
		NS.Script:Load()
	end

	--------------------------------

	Modules()
end
