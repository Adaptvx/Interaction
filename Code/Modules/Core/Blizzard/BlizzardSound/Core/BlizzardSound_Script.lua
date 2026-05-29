local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local TemplateRegistry = addon.TemplateRegistry
local L = addon.Locales
local NS = addon.BlizzardSound; addon.BlizzardSound = NS

NS.Script = {}

function NS.Script:Load()

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

		local function CancelDuckTicker()
			if NS.Variables.DuckTicker then
				NS.Variables.DuckTicker:Cancel()
				NS.Variables.DuckTicker = nil
			end
		end

		local function LerpVolume(from, to, progress)
			return from + (to - from) * progress
		end

		function NS.Script:DuckAudio()
			if not addon.Database.DB_GLOBAL.profile.INT_TTS_DUCK_AUDIO then return end

			CancelDuckTicker()

			local savedMusic = NS.Variables.Saved_Sound_MusicVolume or GetCVar("Sound_MusicVolume")
			local savedSFX = NS.Variables.Saved_Sound_SFXVolume or GetCVar("Sound_SFXVolume")
			local savedAmbience = NS.Variables.Saved_Sound_AmbienceVolume or GetCVar("Sound_AmbienceVolume")

			if not NS.Variables.IsDucked then
				NS.Variables.Saved_Sound_MusicVolume = savedMusic
				NS.Variables.Saved_Sound_SFXVolume = savedSFX
				NS.Variables.Saved_Sound_AmbienceVolume = savedAmbience
			end

			NS.Variables.IsDucked = true

			local reduction = (100 - addon.Database.DB_GLOBAL.profile.INT_TTS_DUCK_AUDIO_LEVEL) / 100
			local targetMusic = NS.Variables.Saved_Sound_MusicVolume * reduction
			local targetSFX = NS.Variables.Saved_Sound_SFXVolume * reduction
			local targetAmbience = NS.Variables.Saved_Sound_AmbienceVolume * reduction

			local currentMusic = tonumber(GetCVar("Sound_MusicVolume"))
			local currentSFX = tonumber(GetCVar("Sound_SFXVolume"))
			local currentAmbience = tonumber(GetCVar("Sound_AmbienceVolume"))

			local step = 0
			local steps = NS.Variables.DUCK_FADE_STEPS
			local interval = NS.Variables.DUCK_FADE_DURATION / steps

			NS.Variables.DuckTicker = C_Timer.NewTicker(interval, function()
				step = step + 1
				local progress = step / steps

				SetCVar("Sound_MusicVolume", LerpVolume(currentMusic, targetMusic, progress))
				SetCVar("Sound_SFXVolume", LerpVolume(currentSFX, targetSFX, progress))
				SetCVar("Sound_AmbienceVolume", LerpVolume(currentAmbience, targetAmbience, progress))

				if step >= steps then
					CancelDuckTicker()
				end
			end, steps)
		end

		function NS.Script:UnDuckAudio()
			if not NS.Variables.IsDucked then return end

			CancelDuckTicker()

			NS.Variables.IsDucked = false

			local targetMusic = tonumber(NS.Variables.Saved_Sound_MusicVolume) or 1
			local targetSFX = tonumber(NS.Variables.Saved_Sound_SFXVolume) or 1
			local targetAmbience = tonumber(NS.Variables.Saved_Sound_AmbienceVolume) or 1

			local currentMusic = tonumber(GetCVar("Sound_MusicVolume"))
			local currentSFX = tonumber(GetCVar("Sound_SFXVolume"))
			local currentAmbience = tonumber(GetCVar("Sound_AmbienceVolume"))

			local step = 0
			local steps = NS.Variables.DUCK_FADE_STEPS
			local interval = NS.Variables.DUCK_FADE_DURATION / steps

			NS.Variables.DuckTicker = C_Timer.NewTicker(interval, function()
				step = step + 1
				local progress = step / steps

				SetCVar("Sound_MusicVolume", LerpVolume(currentMusic, targetMusic, progress))
				SetCVar("Sound_SFXVolume", LerpVolume(currentSFX, targetSFX, progress))
				SetCVar("Sound_AmbienceVolume", LerpVolume(currentAmbience, targetAmbience, progress))

				if step >= steps then
					CancelDuckTicker()
					NS.Variables.Saved_Sound_MusicVolume = nil
					NS.Variables.Saved_Sound_SFXVolume = nil
					NS.Variables.Saved_Sound_AmbienceVolume = nil
				end
			end, steps)
		end
	end

	do
		local function StartInteraction()
			NS.Script:MuteSoundFile(NS.Variables.TargetLostSFX)
			NS.Script:MuteSoundFile(NS.Variables.QuestOpenSFX)
			NS.Script:MuteSoundFile(NS.Variables.QuestCloseSFX)

			if addon.Database.DB_GLOBAL.profile.INT_MUTE_DIALOG then
				NS.Script:MuteDialog()
			end
		end

		local function StopInteraction()
			NS.Script:UnmuteSoundFile(NS.Variables.TargetLostSFX)
			NS.Script:UnmuteSoundFile(NS.Variables.QuestOpenSFX)
			NS.Script:UnmuteSoundFile(NS.Variables.QuestCloseSFX)

			NS.Script:UnmuteDialog()
		end

		CallbackRegistry:Add("START_INTERACTION", StartInteraction, 0)
		CallbackRegistry:Add("STOP_INTERACTION", StopInteraction, 0)
	end
end
