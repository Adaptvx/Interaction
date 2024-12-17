local addonName, addon = ...
local CallbackRegistry = addon.CallbackRegistry
local L = addon.Locales

--------------------------------
-- VARIABLES
--------------------------------

addon.EventListener = {}
local NS = addon.EventListener

do -- MAIN

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

	end

	--------------------------------
	-- EVENTS
	--------------------------------

	do
		local _ = CreateFrame("Frame")
		_:RegisterEvent("UI_SCALE_CHANGED")
		_:SetScript("OnEvent", function(self, event, ...)
			if event == "UI_SCALE_CHANGED" then
				CallbackRegistry:Trigger("BLIZZARD_SETTINGS_RESOLUTION_CHANGED")
			end
		end)
	end
end
