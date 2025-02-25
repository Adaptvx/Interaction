local addonName, addon = ...
local PrefabRegistry = addon.PrefabRegistry
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

	local function Submodules()
		NS.Effects:Load()
	end

	local function Misc()
		UIParent:UnregisterEvent("EXPERIMENTAL_CVAR_CONFIRMATION_NEEDED")

		--------------------------------

		local function Start()
			local cinematicMode = addon.Database.DB_GLOBAL.profile.INT_CINEMATIC

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

	addon.Libraries.AceTimer:ScheduleTimer(function()
		Submodules()
	end, 0)
end
