local addonName, addon = ...
local CallbackRegistry = addon.CallbackRegistry
local L = addon.Locales
local NS = addon.Interaction.Dialog

--------------------------------

NS.Variables = {}

--------------------------------
-- VARIABLES
--------------------------------

do -- MAIN
	NS.Variables.IsInInteraction = false
	NS.Variables.AllowAutoProgress = nil
	NS.Variables.Finished = nil
	NS.Variables.ThemeUpdateTransition = false

	NS.Variables.Temp_FrameType = nil
	NS.Variables.Temp_CurrentIndex = nil
	NS.Variables.Temp_DialogStringList = nil
	NS.Variables.Temp_CurrentString = nil
	NS.Variables.Temp_IsScrollDialog = nil
	NS.Variables.Temp_IsEmoteDialog = nil
	NS.Variables.Temp_Temp_IsEmoteDialog = nil
	NS.Variables.Temp_IsEmoteDialogIndexes = nil
	NS.Variables.Temp_NotEmoteDialogIndexes = nil
	NS.Variables.Temp_IsStylisedDialog = nil
end

do  -- CONSTANTS
	do -- SCALE
		NS.Variables.BASELINE_WIDTH = 100
		NS.Variables.BASELINE_HEIGHT = 45

		--------------------------------

		function NS.Variables:RATIO(level)
			return NS.Variables.BASELINE_HEIGHT / addon.Variables:RAW_RATIO(level)
		end
	end

	do -- MAIN

	end
end

--------------------------------
-- EVENTS
--------------------------------
