local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local TemplateRegistry = addon.TemplateRegistry
local L = addon.Locales
local NS = addon.Interaction.Gossip; addon.Interaction.Gossip = NS

NS.Variables = {}

-- Variables
----------------------------------------------------------------------------------------------------

do -- Main
	NS.Variables.NumCurrentButtons = 0
	NS.Variables.State = ""
	NS.Variables.RefreshInProgress = false
	NS.Variables.CurrentSession = {
		["npc"] = nil
	}
end

do -- Constants
	do -- Scale
		NS.Variables.BUTTON_SPACING = -5
		NS.Variables.RATIO_REFERENCE = 45

		do -- Functions

			function NS.Variables:RATIO(level)
				return NS.Variables.RATIO_REFERENCE / addon.Variables:RAW_RATIO(level)
			end
		end
	end

	do -- Main
		NS.Variables.PATH = addon.Variables.PATH_ART .. "Gossip\\"
		NS.Variables.PADDING = 10

		NS.Variables.FRAME_STRATA = "HIGH"
		NS.Variables.FRAME_LEVEL = 99
		NS.Variables.FRAME_LEVEL_MAX = 999
	end
end

do -- References
	NS.Variables.Buttons = {}
end

-- Events
----------------------------------------------------------------------------------------------------
