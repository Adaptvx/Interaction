---@class addon
local addon = select(2, ...)
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
	NS.PATH = "Interface/AddOns/Interaction/"
	NS.PATH_ART = NS.PATH .. "Art/"

	-- VERSION
	NS.VERSION_STRING = "0.1.3"
	NS.VERSION_NUMBER = 00010300 -- XX.XX.XX.XX
	NS.IS_WOW_VERSION_RETAIL = (select(4, GetBuildInfo()) > 110000)
	NS.IS_WOW_VERSION_CLASSIC_PROGRESSION = (select(4, GetBuildInfo()) < 110000 and select(4, GetBuildInfo()) >= 20000)
	NS.IS_WOW_VERSION_CLASSIC_ERA = (select(4, GetBuildInfo()) < 20000)
	NS.IS_WOW_VERSION_CLASSIC_ALL = (NS.IS_WOW_VERSION_CLASSIC_PROGRESSION or NS.IS_WOW_VERSION_CLASSIC_ERA)

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
