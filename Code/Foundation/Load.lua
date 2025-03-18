local addonName, addon = ...

--------------------------------
-- VARIABLES
--------------------------------

addon.Foundation = {}
local NS = addon.Foundation

do -- MAIN
	NS.Initalized = false
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

	local function Priority()
		addon.PrefabRegistry:Load()
		addon.CallbackRegistry:Load()
		addon.EventListener:Load()
	end

	local function Modules()
		addon._DEV:Load()

		addon.Theme:Load()
		addon.SoundEffects:Load()
		addon.Get:Load()
		addon.LoadedAddons:Load()

		addon.Initialize:Load()
	end

	--------------------------------
	-- EVENTS
	--------------------------------

	do
		local Events = CreateFrame("Frame")
		Events:RegisterEvent("PLAYER_ENTERING_WORLD")
		Events:SetScript("OnEvent", function(self, event, ...)
			if event == "PLAYER_ENTERING_WORLD" then
				if not NS.Initalized then
					C_Timer.After(addon.Variables.INIT_DELAY_2, function()
						Modules()
					end)
				end
			end
		end)
	end

	--------------------------------
	-- SETUP
	--------------------------------

	do
		Priority()
	end
end

NS:Load()
