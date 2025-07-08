---@class addon
local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local PrefabRegistry = addon.PrefabRegistry
local L = addon.Locales

--------------------------------
-- VARIABLES
--------------------------------

addon.LoadedAddons = {}
local NS = addon.LoadedAddons; addon.LoadedAddons = NS

do -- MAIN
	NS.DynamicCam = false
	NS.BtWQuests = false
	NS.ElvUI = false
	NS.WaypointUI = false
end

do -- CONSTANTS

end

--------------------------------
-- FUNCTIONS (MAIN)
--------------------------------

function NS:Load()
	--------------------------------
	-- FUNCTIONS (MAIN)
	--------------------------------

	do
		function addon.LoadedAddons:IsAddOnLoaded(name)
			local loaded, finished = C_AddOns.IsAddOnLoaded(name)
			return loaded
		end

		function addon.LoadedAddons:GetAddons()
			addon.LoadedAddons.DynamicCam = addon.LoadedAddons:IsAddOnLoaded("DynamicCam")
			addon.LoadedAddons.BtWQuests = addon.LoadedAddons:IsAddOnLoaded("BtWQuests")
			addon.LoadedAddons.ElvUI = addon.LoadedAddons:IsAddOnLoaded("ElvUI")
			addon.LoadedAddons.WaypointUI = addon.LoadedAddons:IsAddOnLoaded("WaypointUI")

			CallbackRegistry:Trigger("LOADED_ADDONS_READY")
		end
	end

	--------------------------------
	-- EVENTS
	--------------------------------

	do

	end

	--------------------------------
	-- SETUP
	--------------------------------

	do
		addon.Libraries.AceTimer:ScheduleTimer(addon.LoadedAddons.GetAddons, addon.Variables.INIT_DELAY_LAST)
	end
end
