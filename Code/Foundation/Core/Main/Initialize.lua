local addonName, addon = ...
local PrefabRegistry = addon.PrefabRegistry
local CallbackRegistry = addon.CallbackRegistry
local L = addon.Locales

--------------------------------
-- VARIABLES
--------------------------------

addon.Initialize = {}
local NS = addon.Initialize

do -- MAIN
	NS.QueuedForInitalization = false
	NS.Initalized = false
	NS.Ready = false
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
		function NS:LoadCode()
			local function Protected()
				addon.InteractionFrame:Load()
			end

			local function Modules()
				addon.Modules:Load()
			end

			--------------------------------

			Protected()
			Modules()

			--------------------------------

			CallbackRegistry:Trigger("THEME_UPDATE")
			C_Timer.After(2, function()
				CallbackRegistry:Trigger("THEME_UPDATE")
			end)

			--------------------------------

			C_Timer.After(2.5, function()
				NS.Ready = true
			end)
		end

		function NS:Initalize()
			if InCombatLockdown() then
				NS.QueuedForInitalization = true

				return
			end
			NS.QueuedForInitalization = false

			--------------------------------

			if NS.Initalized then
				return
			end
			NS.Initalized = true

			--------------------------------

			addon.Database.DB_GLOBAL.profile.LastLoadedSession = GetTime()

			--------------------------------

			NS:LoadCode()
		end
	end

	--------------------------------
	-- EVENTS
	--------------------------------

	do
		local Events = CreateFrame("Frame")
		Events:RegisterEvent("PLAYER_REGEN_ENABLED")
		Events:SetScript("OnEvent", function(_, event, ...)
			if NS.QueuedForInitalization then
				if event == "PLAYER_REGEN_ENABLED" then
					if not InCombatLockdown() then
						NS:Initalize()

						Events:UnregisterEvent("PLAYER_REGEN_ENABLED")
					end
				end
			end
		end)
	end

	--------------------------------
	-- SETUP
	--------------------------------

	do
		NS:Initalize()
	end
end
