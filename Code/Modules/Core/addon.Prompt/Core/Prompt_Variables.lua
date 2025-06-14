---@class addon
local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local PrefabRegistry = addon.PrefabRegistry
local L = addon.Locales
local NS = addon.Prompt; addon.Prompt = NS

--------------------------------

NS.Variables = {}

--------------------------------
-- VARIABLES
--------------------------------

do -- MAIN
	NS.Variables.Text = nil
	NS.Variables.Button1Text = nil
	NS.Variables.Button2Text = nil
	NS.Variables.Button1Callback = nil
	NS.Variables.Button2Callback = nil
end

do  -- CONSTANTS
	do -- SCALE
		NS.Variables.RATIO_REFERENCE = 350

		--------------------------------

		do -- FUNCTIONS
			function NS.Variables:RATIO(level)
				return NS.Variables.RATIO_REFERENCE / addon.Variables:RAW_RATIO(level)
			end
		end
	end

	do -- MAIN
		NS.Variables.PADDING = (NS.Variables:RATIO(8))

		NS.Variables.FRAME_STRATA = "FULLSCREEN_DIALOG"
		NS.Variables.FRAME_LEVEL = 1
		NS.Variables.FRAME_LEVEL_MAX = 999
	end
end

--------------------------------
-- EVENTS
--------------------------------
