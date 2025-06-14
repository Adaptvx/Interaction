---@class addon
local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local PrefabRegistry = addon.PrefabRegistry
local L = addon.Locales

--------------------------------

addon.Waypoint = {}
local NS = addon.Waypoint; addon.Waypoint = NS

--------------------------------

function NS:Load()
	local WAYPOINT_ENABLE = addon.Database.DB_GLOBAL.profile.INT_WAYPOINT
	if not WAYPOINT_ENABLE or addon.Variables.IS_WOW_VERSION_CLASSIC_ALL then return end

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
