---@class addon
local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local PrefabRegistry = addon.PrefabRegistry
local L = addon.Locales
local NS = addon.Support.WaypointUI; addon.Support.WaypointUI = NS

--------------------------------

NS.Script = {}

--------------------------------

function NS.Script:Load()
	--------------------------------
	-- REFERENCES
	--------------------------------

	local Callback = NS.Script; NS.Script = Callback

	--------------------------------
	-- FUNCTIONS (MAIN)
	--------------------------------

	do
		function Callback:UpdateSettings()
			if addon.Database.DB_GLOBAL.profile.INT_WAYPOINT then
				addon.SettingsUI.Utils:Prompt_Reload()

				--------------------------------

				addon.Database.DB_GLOBAL.profile.INT_WAYPOINT = false
			end
		end
	end

	--------------------------------
	-- SETUP
	--------------------------------

	do
		Callback:UpdateSettings()
	end
end
