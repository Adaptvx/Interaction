local addonName, addon = ...
local PrefabRegistry = addon.PrefabRegistry
local CallbackRegistry = addon.CallbackRegistry
local L = addon.Locales

--------------------------------
-- VARIABLES
--------------------------------

addon.LoadedAddons = {}
local NS = addon.LoadedAddons

do -- MAIN
	NS.DynamicCam = false
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
		addon.LoadedAddons:GetAddons()
	end
end
