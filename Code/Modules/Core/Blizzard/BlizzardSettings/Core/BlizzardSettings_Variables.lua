local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local TemplateRegistry = addon.TemplateRegistry
local L = addon.Locales
local NS = addon.BlizzardSettings; addon.BlizzardSettings = NS

NS.Variables = {}

-- Variables
----------------------------------------------------------------------------------------------------

do -- Main

end

do -- Constants
	do -- Scale
		NS.Variables.RATIO_REFERENCE = 125

		do -- Functions

			function NS.Variables:RATIO(level)
				return NS.Variables.RATIO_REFERENCE / addon.Variables:RAW_RATIO(level)
			end
		end
	end

	do -- Main
		NS.Variables.PATH = addon.Variables.PATH_ART .. "Blizzard\\Settings\\"
	end
end

-- Events
----------------------------------------------------------------------------------------------------
