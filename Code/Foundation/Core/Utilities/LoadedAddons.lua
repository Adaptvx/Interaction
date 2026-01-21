local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local TemplateRegistry = addon.TemplateRegistry
local L = addon.Locales

-- Variables
----------------------------------------------------------------------------------------------------

addon.LoadedAddons = {}
local NS = addon.LoadedAddons; addon.LoadedAddons = NS

do -- Main
	NS.DynamicCam = false
	NS.BtWQuests = false
	NS.ElvUI = false
end


function NS:Load()

	-- Main
	----------------------------------------------------------------------------------------------------

	do

		function addon.LoadedAddons:IsAddOnLoaded(name)
			local loaded, _ = C_AddOns.IsAddOnLoaded(name)
			return loaded
		end

		function addon.LoadedAddons:GetAddons()
			addon.LoadedAddons.DynamicCam = addon.LoadedAddons:IsAddOnLoaded("DynamicCam")
			addon.LoadedAddons.BtWQuests = addon.LoadedAddons:IsAddOnLoaded("BtWQuests")
			addon.LoadedAddons.ElvUI = addon.LoadedAddons:IsAddOnLoaded("ElvUI")

			CallbackRegistry:Trigger("LOADED_ADDONS_READY")
		end
	end

	-- Events
	----------------------------------------------------------------------------------------------------

	do

	end

	-- Setup
	----------------------------------------------------------------------------------------------------

	do
		C_Timer.After(addon.Variables.INIT_DELAY_LAST, addon.LoadedAddons.GetAddons)
	end
end
