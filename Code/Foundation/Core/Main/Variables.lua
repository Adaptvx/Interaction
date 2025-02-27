local addonName, addon = ...
local PrefabRegistry = addon.PrefabRegistry
local CallbackRegistry = addon.CallbackRegistry
local L = addon.Locales

--------------------------------
-- VARIABLES
--------------------------------

addon.Variables = {}
local NS = addon.Variables

do -- MAIN
	NS.Platform = nil
	NS.Settings_UIDirection = nil
	NS.Settings_AlwaysShowQuest = nil
	NS.Settings_AlwaysShowGossip = nil
end

do -- CONSTANTS
	NS.PATH = "Interface/AddOns/Interaction/"

	NS.VERSION_STRING = "0.0.6.1"
	NS.VERSION_NUMBER = 00000601 -- XX.XX.XX.XX
	NS.IS_CLASSIC = select(4, GetBuildInfo()) < 110000
	NS.IS_CLASSIC_ERA = select(4, GetBuildInfo()) < 20000

	NS.INIT_DELAY_1 = .025
	NS.INIT_DELAY_2 = .05
	NS.INIT_DELAY_3 = .075
	NS.INIT_DELAY_LAST = .1

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
	C_Timer.After(NS.INIT_DELAY_1, function()
		NS.Platform = addon.Database.DB_GLOBAL.profile.INT_PLATFORM
	end)
end

--------------------------------
-- SETUP
--------------------------------
