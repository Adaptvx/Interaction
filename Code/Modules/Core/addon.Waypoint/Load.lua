local addonName, addon = ...
local PrefabRegistry = addon.PrefabRegistry
local CallbackRegistry = addon.CallbackRegistry
local L = addon.Locales

--------------------------------

addon.Waypoint = {}
local NS = addon.Waypoint

--------------------------------

function NS:Load()
	local WAYPOINT_ENABLE = addon.Database.DB_GLOBAL.profile.INT_WAYPOINT
	if not WAYPOINT_ENABLE or addon.Variables.IS_CLASSIC then return end

	--------------------------------

	local function Modules()
		NS.Variables:Load()
		NS.Elements:Load()
		NS.Script:Load()
	end

	local function Misc()
		SetCVar("showInGameNavigation", 1)
	end

	--------------------------------

	Modules()
	Misc()
end
