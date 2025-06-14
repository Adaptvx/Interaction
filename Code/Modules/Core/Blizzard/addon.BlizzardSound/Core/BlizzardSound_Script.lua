---@class addon
local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local PrefabRegistry = addon.PrefabRegistry
local L = addon.Locales
local NS = addon.BlizzardSound; addon.BlizzardSound = NS

--------------------------------

NS.Script = {}

--------------------------------

function NS.Script:Load()
	--------------------------------
	-- FUNCTIONS
	--------------------------------

	do
		function NS.Script:MuteDialog()
			SetCVar("Sound_DialogVolume", 0)
		end

		function NS.Script:UnmuteDialog()
			SetCVar("Sound_DialogVolume", addon.ConsoleVariables.Variables.Saved_Sound_DialogVolume)
		end

		function NS.Script:MuteSoundFile(soundID)
			MuteSoundFile(soundID)
		end

		function NS.Script:UnmuteSoundFile(soundID)
			UnmuteSoundFile(soundID)
		end
	end

	--------------------------------
	-- EVENTS
	--------------------------------

	do
		local function StartInteraction()
			NS.Script:MuteSoundFile(NS.Variables.TargetLostSFX)
			NS.Script:MuteSoundFile(NS.Variables.QuestOpenSFX)
			NS.Script:MuteSoundFile(NS.Variables.QuestCloseSFX)

			--------------------------------
			-- SOUND
			--------------------------------

			if addon.Database.DB_GLOBAL.profile.INT_MUTE_DIALOG then
				NS.Script:MuteDialog()
			end
		end

		local function StopInteraction()
			NS.Script:UnmuteSoundFile(NS.Variables.TargetLostSFX)
			NS.Script:UnmuteSoundFile(NS.Variables.QuestOpenSFX)
			NS.Script:UnmuteSoundFile(NS.Variables.QuestCloseSFX)

			--------------------------------
			-- SOUND
			--------------------------------

			NS.Script:UnmuteDialog()
		end

		CallbackRegistry:Add("START_INTERACTION", StartInteraction, 0)
		CallbackRegistry:Add("STOP_INTERACTION", StopInteraction, 0)
	end
end
