local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local TemplateRegistry = addon.TemplateRegistry
local L = addon.Locales
local NS = addon.Alert; addon.Alert = NS

NS.Variables = {}

-- Variables
----------------------------------------------------------------------------------------------------

do -- Main

end

do -- Constants
	do -- Main
		NS.Variables.PATH = addon.Variables.PATH_ART .. "Alert\\"

		NS.Variables.FRAME_STRATA = "FULLSCREEN_DIALOG"
		NS.Variables.FRAME_LEVEL = 99
		NS.Variables.FRAME_LEVEL_MAX = 999
	end
end

-- Events
----------------------------------------------------------------------------------------------------
