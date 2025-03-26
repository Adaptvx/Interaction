local addonName, addon = ...
local PrefabRegistry = addon.PrefabRegistry
local CallbackRegistry = addon.CallbackRegistry
local L = addon.Locales
local NS = addon.Interaction.Quest

--------------------------------

NS.Variables = {}

--------------------------------
-- VARIABLES
--------------------------------

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
		NS.Variables.QUEST_PATH = addon.Variables.PATH_ART .. "Quest/"
		NS.Variables.FRAME_SIZE = { x = 625 * .75, y = 625 }
	end

	do -- PADDING
		NS.Variables.PADDING = NS.Variables:RATIO(8)
	end
end

do  -- MAIN
	do -- THEME
		NS.Variables.THEME = {}
		NS.Variables.THEME.INSCRIBED_BACKGROUND = nil
		NS.Variables.THEME.INSCRIBED_BACKGROUND_HIGHLIGHT = nil
	end

	do -- FRAME
		NS.Variables.Buttons_Choice = {}
		NS.Variables.Buttons_Reward = {}
		NS.Variables.Buttons_Required = {}
		NS.Variables.Buttons_Spell = {}
		NS.Variables.Num_Choice = 0
		NS.Variables.Num_Reward = 0
		NS.Variables.Num_Required = 0
		NS.Variables.Num_Spell = 0
		NS.Variables.State = ""

		NS.Variables.ChoiceSelected = false
	end

	do -- SCALE
		NS.Variables.ScaleModifier = 1

		--------------------------------

		function NS.Variables:UpdateScaleModifier(x)
			local baseScale = NS.Variables.FRAME_SIZE.x
			local newScale = x
			local scaleModifier = newScale / baseScale
			NS.Variables.ScaleModifier = scaleModifier
		end
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
	addon.API.Main:RegisterThemeUpdate(function()
		if addon.Theme.IsDarkTheme then
			NS.Variables.THEME.INSCRIBED_BACKGROUND = addon.API.Presets.NINESLICE_INSCRIBED
            NS.Variables.THEME.INSCRIBED_BACKGROUND_HIGHLIGHT = addon.API.Presets.NINESLICE_INSCRIBED
			NS.Variables.THEME.INSCRIBED_HEADER = addon.Variables.PATH_ART .. "Quest/header-nineslice.png"
		else
			NS.Variables.THEME.INSCRIBED_BACKGROUND = addon.API.Presets.NINESLICE_INSCRIBED
            NS.Variables.THEME.INSCRIBED_BACKGROUND_HIGHLIGHT = addon.API.Presets.NINESLICE_INSCRIBED
			NS.Variables.THEME.INSCRIBED_HEADER = addon.Variables.PATH_ART .. "Quest/header-nineslice.png"
		end
	end, 0)
end
