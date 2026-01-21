local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local TemplateRegistry = addon.TemplateRegistry
local L = addon.Locales
local NS = addon.Interaction.Quest; addon.Interaction.Quest = NS

NS.Variables = {}

-- Variables
----------------------------------------------------------------------------------------------------

do -- Constants
	do -- Scale
		NS.Variables.FRAME_SIZE = { x = 625 * .75, y = 625 }
		NS.Variables.RATIO_REFERENCE = 625

		do -- Functions

			function NS.Variables:RATIO(level)
				return NS.Variables.RATIO_REFERENCE / addon.Variables:RAW_RATIO(level)
			end
		end
	end

	do -- Main
		NS.Variables.QUEST_PATH = addon.Variables.PATH_ART .. "Quest\\"

		NS.Variables.FRAME_STRATA = "HIGH"
		NS.Variables.FRAME_LEVEL = 99
		NS.Variables.FRAME_LEVEL_MAX = 999
	end

	do -- Padding
		NS.Variables.PADDING = NS.Variables:RATIO(8)
	end
end

do  -- Main
	do -- Theme
		NS.Variables.THEME = {}
		NS.Variables.THEME.INSCRIBED_BACKGROUND = nil
		NS.Variables.THEME.INSCRIBED_BACKGROUND_HIGHLIGHT = nil
	end

	do -- Frame
		NS.Variables.Num_Choice = 0
		NS.Variables.Num_Reward = 0
		NS.Variables.Num_Required = 0
		NS.Variables.Num_Spell = 0
		NS.Variables.State = ""
	end

	do -- Scale
		NS.Variables.ScaleModifier = 1

		function NS.Variables:UpdateScaleModifier(x)
			local baseScale = NS.Variables.FRAME_SIZE.x
			local newScale = x
			local scaleModifier = newScale / baseScale
			NS.Variables.ScaleModifier = scaleModifier
		end
	end

	do -- Elements
		NS.Variables.Elements = {}
	end
end

do -- References
	NS.Variables.Buttons_Choice = nil
	NS.Variables.Buttons_Reward = nil
	NS.Variables.Buttons_Required = nil
	NS.Variables.Buttons_Spell = nil

	NS.Variables.Button_Choice_Selected = nil
end


-- Events
----------------------------------------------------------------------------------------------------

do
	addon.API.Main:RegisterThemeUpdate(function()
		if addon.Theme.IsDarkTheme then
			NS.Variables.THEME.INSCRIBED_BACKGROUND = addon.API.Presets.NINESLICE_INSCRIBED
			NS.Variables.THEME.INSCRIBED_BACKGROUND_HIGHLIGHT = addon.API.Presets.NINESLICE_INSCRIBED
			NS.Variables.THEME.INSCRIBED_HEADER = addon.Variables.PATH_ART .. "Quest\\header-nineslice.png"
		else
			NS.Variables.THEME.INSCRIBED_BACKGROUND = addon.API.Presets.NINESLICE_INSCRIBED
			NS.Variables.THEME.INSCRIBED_BACKGROUND_HIGHLIGHT = addon.API.Presets.NINESLICE_INSCRIBED
			NS.Variables.THEME.INSCRIBED_HEADER = addon.Variables.PATH_ART .. "Quest\\header-nineslice.png"
		end
	end, 0)
end
