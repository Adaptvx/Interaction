local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local TemplateRegistry = addon.TemplateRegistry
local L = addon.Locales
local NS = addon.Interaction.Quest.Target; addon.Interaction.Quest.Target = NS

NS.Variables = {}

-- Variables
----------------------------------------------------------------------------------------------------

do -- Main

end

do -- Constants
	do -- Scale
		NS.Variables.RATIO_REFERENCE = 625

		do -- Functions

			function NS.Variables:RATIO(level)
				return NS.Variables.RATIO_REFERENCE / addon.Variables:RAW_RATIO(level)
			end
		end
	end

	do -- Main
		NS.Variables.PADDING = NS.Variables:RATIO(9)
		NS.Variables.CONTENT_PADDING = NS.Variables:RATIO(8.5)
		NS.Variables.PATH = addon.Variables.PATH_ART .. "QuestTarget\\"

		NS.Variables.FRAME_STRATA = "FULLSCREEN"
		NS.Variables.FRAME_LEVEL = 999
		NS.Variables.FRAME_LEVEL_MAX = 1999
	end
end

-- Events
----------------------------------------------------------------------------------------------------
