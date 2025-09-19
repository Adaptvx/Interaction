---@class addon
local addonName, addon = ...
local CallbackRegistry = addon.CallbackRegistry
local PrefabRegistry = addon.PrefabRegistry
local L = addon.Locales

--------------------------------
-- VARIABLES
--------------------------------

addon.Variables = {}
local NS = addon.Variables; addon.Variables = NS

do -- MAIN
	NS.Platform = nil
	NS.Settings_UIDirection = nil
	NS.Settings_AlwaysShowQuest = nil
	NS.Settings_AlwaysShowGossip = nil
end

do -- CONSTANTS
	-- REFERENCE
	NS.PATH = "Interface/AddOns/"..addonName.."/"
	NS.PATH_ART = NS.PATH .. "Art/"

	-- VERSION
	NS.VERSION_STRING = C_AddOns.GetAddOnMetadata(addonName, "Version")
	NS.VERSION_NUMBER = (function(t)
		local j,n,p = t:match("(%d+)%.(%d+)%.(%d+)") -- major, minor, patch semantic versioning
		return tonumber(j or 0)*10^4 + tonumber(n or 0)*10^2 + tonumber(p or 0)
	end)(NS.VERSION_STRING)-- major*10000 + minor*100 + patch (for numeric version comparisons)

	-- CLIENT VERSION
	local clientBuild = select(4, GetBuildInfo())
	NS.IS_WOW_VERSION_RETAIL = (clientBuild >= 110000) -- Retail
	NS.IS_WOW_VERSION_CLASSIC_ALL = (clientBuild < 110000) -- All classic ver
	NS.IS_WOW_VERSION_CLASSIC_PROGRESSION = (clientBuild < 110000 and clientBuild > 50000) -- MoP Classic
	NS.IS_WOW_VERSION_CLASSIC_ERA = (clientBuild < 50000) -- Classic era

	-- INITALIZATION
	NS.INIT_DELAY_1 = .025
	NS.INIT_DELAY_2 = .05
	NS.INIT_DELAY_3 = .075
	NS.INIT_DELAY_LAST = .1

	-- CONSTANTS
	NS.GOLDEN_RATIO = 1.618034
end

--------------------------------
-- FUNCTIONS (VARIABLES)
--------------------------------

do
	function NS:RATIO(base, level)
		return base / (NS.GOLDEN_RATIO ^ level)
	end

	function NS:RAW_RATIO(level)
		return NS.GOLDEN_RATIO ^ level
	end
end

--------------------------------
-- EVENTS
--------------------------------

do
	C_Timer.After(0, function()
		CallbackRegistry:Add("ADDON_DATABASE_READY", function()
			NS.Platform = addon.Database.DB_GLOBAL.profile.INT_PLATFORM
		end, 0)
	end)
end

--------------------------------
-- SETUP
--------------------------------
