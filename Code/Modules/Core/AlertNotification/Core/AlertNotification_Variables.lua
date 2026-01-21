local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local TemplateRegistry = addon.TemplateRegistry
local L = addon.Locales
local NS = addon.AlertNotification; addon.AlertNotification = NS

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
		NS.Variables.PATH = addon.Variables.PATH_ART .. "AlertNotification\\"

		NS.Variables.FRAME_STRATA = "FULLSCREEN_DIALOG"
		NS.Variables.FRAME_LEVEL = 99
		NS.Variables.FRAME_LEVEL_MAX = 999
	end

	do -- Padding
		NS.Variables.PADDING = NS.Variables:RATIO(8)
	end
end

-- Events
----------------------------------------------------------------------------------------------------
