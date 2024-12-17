local addonName, addon = ...
local CallbackRegistry = addon.CallbackRegistry
local L = addon.Locales

--------------------------------

addon.Cinematic = {}
local NS = addon.Cinematic

--------------------------------

function NS:Load()
	local function Modules()
		NS.Util:Load()

		NS.Elements:Load()
		NS.Script:Load()
	end

	local function Misc()
		UIParent:UnregisterEvent("EXPERIMENTAL_CVAR_CONFIRMATION_NEEDED")

		--------------------------------

		local function Start()
			local cinematicMode = INTDB.profile.INT_CINEMATIC

			if cinematicMode then
				SetCVar("test_cameraTargetFocusInteractEnable", addon.ConsoleVariables.Variables.Saved_cameraTargetFocusInteractEnable)
			end
		end

		--------------------------------

		Start()
	end

	--------------------------------

	Modules()
	Misc()
end
