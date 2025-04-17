local addonName, addon = ...
local CallbackRegistry = addon.CallbackRegistry
local PrefabRegistry = addon.PrefabRegistry
local L = addon.Locales

--------------------------------
-- VARIABLES
--------------------------------

addon.LoadedAddons = {}
local NS = addon.LoadedAddons

do -- MAIN
	NS.DynamicCam = false
	NS.BtWQuests = false
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
