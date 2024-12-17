local addonName, addon = ...
local CallbackRegistry = addon.CallbackRegistry
local L = addon.Locales
local NS = addon.Interaction.Quest

--------------------------------

NS.Variables = {}

--------------------------------
-- VARIABLES
--------------------------------

do  -- MAIN
	do -- THEME
		NS.Variables.THEME = {}
		NS.Variables.THEME.INSCRIBED_BACKGROUND = nil
		NS.Variables.THEME.INSCRIBED_BACKGROUND_HIGHLIGHT = nil
	end

	do -- FRAME
		NS.Variables.ChoiceButtons = {}
		NS.Variables.ReceiveButtons = {}
		NS.Variables.RequiredItemButtons = {}
		NS.Variables.SpellButtons = {}
		NS.Variables.NumChoices = 0
		NS.Variables.NumReceive = 0
		NS.Variables.NumRequireItem = 0
		NS.Variables.NumSpell = 0
		NS.Variables.State = ""

		NS.Variables.ChoiceSelected = nil
	end
end

do  -- CONSTANTS
	do -- SCALE
		NS.Variables.BASELINE_WIDTH = 625 * .75
		NS.Variables.BASELINE_HEIGHT = 625

		--------------------------------

		function NS.Variables:RATIO(level)
			return NS.Variables.BASELINE_HEIGHT / addon.Variables:RAW_RATIO(level)
		end
	end

	do -- MAIN
		NS.Variables.QUEST_PATH = addon.Variables.PATH .. "Art/Quest/"
		NS.Variables.FRAME_SIZE = { x = 625 * .75, y = 625 }
	end

	do -- PADDING
		NS.Variables.PADDING = NS.Variables:RATIO(8)
	end
end

--------------------------------
-- FUNCTIONS (VARIABLES)
--------------------------------

do

end

--------------------------------
-- EVENTS
--------------------------------

do
	addon.API:RegisterThemeUpdate(function()
		if addon.Theme.IsDarkTheme then
			NS.Variables.THEME.INSCRIBED_BACKGROUND = AdaptiveAPI.Presets.NINESLICE_INSCRIBED
			NS.Variables.THEME.INSCRIBED_BACKGROUND_HIGHLIGHT = AdaptiveAPI.Presets.NINESLICE_INSCRIBED
		else
			NS.Variables.THEME.INSCRIBED_BACKGROUND = AdaptiveAPI.Presets.NINESLICE_INSCRIBED
			NS.Variables.THEME.INSCRIBED_BACKGROUND_HIGHLIGHT = AdaptiveAPI.Presets.NINESLICE_INSCRIBED
		end
	end, 0)
end
