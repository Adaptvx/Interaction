local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local TemplateRegistry = addon.TemplateRegistry
local L = addon.Locales
local NS = addon.Cinematic.Effects; addon.Cinematic.Effects = NS

NS.Variables = {}

-- Variables
----------------------------------------------------------------------------------------------------

do -- Main

end

do -- Constants
	do -- Scale
		NS.Variables.RATIO_REFERENCE = 45

		do -- Functions

			function NS.Variables:RATIO(level)
				return NS.Variables.RATIO_REFERENCE / addon.Variables:RAW_RATIO(level)
			end
		end
	end

	do -- Main
		NS.Variables.FRAME_STRATA = "HIGH"
		NS.Variables.FRAME_LEVEL = 1
		NS.Variables.FRAME_LEVEL_MAX = 999
	end
end

-- Events
----------------------------------------------------------------------------------------------------
