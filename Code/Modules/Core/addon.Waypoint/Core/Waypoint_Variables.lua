local addonName, addon = ...
local CallbackRegistry = addon.CallbackRegistry
local L = addon.Locales
local NS = addon.Waypoint

--------------------------------

NS.Variables = {}

--------------------------------

function NS.Variables:Load()
	--------------------------------
	-- VARIABLES
	--------------------------------

	do -- MAIN
		NS.Variables.LastInInstance = IsInInstance()
		NS.Variables.State = nil
		NS.Variables.LastState = nil
		NS.Variables.Playback = nil

		NS.Variables.ID = nil
		NS.Variables.QuestID = nil

		NS.Variables.AudioEnable = addon.Database.DB_GLOBAL.profile.INT_WAYPOINT_AUDIO
	end

	do -- CONSTANTS
		NS.Variables.PATH = addon.Variables.PATH .. "Art/Waypoint/"
		NS.Variables.DEFAULT_HEIGHT = 125
		NS.Variables.BLOCKED_HEIGHT = 75
		NS.Variables.ANIMATION_HEIGHT = 25
		NS.Variables.LINE_WIDTH = 2
		NS.Variables.LINE_HEIGHT = 100
		NS.Variables.BACKGROUND_PADDING = 50
	end

	do -- ANIMATION
		NS.Variables.SUPER_TRACKING_CHANGED_COOLDOWN = false
	end

	--------------------------------
	-- EVENTS
	--------------------------------

	do
		CallbackRegistry:Add("SETTINGS_CHANGED", function()
			NS.Variables.AudioEnable = addon.Database.DB_GLOBAL.profile.INT_WAYPOINT_AUDIO
		end, 2)
	end
end
