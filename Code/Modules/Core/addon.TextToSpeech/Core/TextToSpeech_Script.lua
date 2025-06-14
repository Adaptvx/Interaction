---@class addon
local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local PrefabRegistry = addon.PrefabRegistry
local L = addon.Locales
local NS = addon.TextToSpeech; addon.TextToSpeech = NS

--------------------------------

NS.Script = {}

--------------------------------

function NS.Script:Load()
	--------------------------------
	-- FUNCTIONS (MAIN)
	--------------------------------

	do
		function NS.Script:SpeakText(voice, text, destination, rate, volume)
			NS.Variables.IsPlaybackActive = true

			--------------------------------

			MuteSoundFile(4192839) -- TTS line break

			--------------------------------

			C_VoiceChat.StopSpeakingText()
			addon.Libraries.AceTimer:ScheduleTimer(function()
				C_VoiceChat.SpeakText(voice, text, destination, rate, volume)
			end, 0)
		end

		function NS.Script:StopSpeakingText()
			NS.Variables.IsPlaybackActive = false

			--------------------------------

			C_VoiceChat.StopSpeakingText()

			--------------------------------

			addon.Libraries.AceTimer:ScheduleTimer(function()
				if not NS.Variables.IsPlaybackActive then
					UnmuteSoundFile(4192839) -- TTS line break
				end
			end, .1)
		end

		function NS.Script:PlayConfiguredTTS(voice, text)
			local isEnabled = addon.Database.DB_GLOBAL.profile.INT_TTS

			local voice = (voice or 1) - 1
			local rate = addon.Database.DB_GLOBAL.profile.INT_TTS_SPEED * .725
			local volume = addon.Database.DB_GLOBAL.profile.INT_TTS_VOLUME

			--------------------------------

			if isEnabled then
				NS.Script:SpeakText(voice, text, Enum.VoiceTtsDestination and Enum.VoiceTtsDestination.LocalPlayback or 1, rate, volume)
			end
		end
	end

	----------------------------------
	-- EVENTS
	----------------------------------

	do

	end

	----------------------------------
	-- SETUP
	----------------------------------

	do

	end
end
