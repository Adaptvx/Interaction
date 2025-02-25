local addonName, addon = ...
local PrefabRegistry = addon.PrefabRegistry
local CallbackRegistry = addon.CallbackRegistry
local L = addon.Locales
local NS = addon.TextToSpeech

--------------------------------

NS.Script = {}

--------------------------------

function NS.Script:Load()
	--------------------------------
	-- FUNCTIONS (MAIN)
	--------------------------------

	do
		function NS.Script:SpeakText(voice, text, destination, rate, volume)
			MuteSoundFile(4192839) -- TTS line break

			--------------------------------

			addon.Libraries.AceTimer:ScheduleTimer(function()
				C_VoiceChat.StopSpeakingText()
				C_VoiceChat.SpeakText(voice, text, destination, rate, volume)
			end, 0)
		end

		function NS.Script:StopSpeakingText()
			C_VoiceChat.StopSpeakingText()

			--------------------------------

			addon.Libraries.AceTimer:ScheduleTimer(function()
				UnmuteSoundFile(4192839) -- TTS line break
			end, .1)
		end

		function NS.Script:PlayConfiguredTTS(voice, text)
			local IsTextToSpeech = addon.Database.DB_GLOBAL.profile.INT_TTS

			local Voice = (voice or 1) - 1
			local Rate = addon.Database.DB_GLOBAL.profile.INT_TTS_SPEED * .725
			local Volume = addon.Database.DB_GLOBAL.profile.INT_TTS_VOLUME

			--------------------------------

			if IsTextToSpeech then
				NS.Script:SpeakText(Voice, text, Enum.VoiceTtsDestination.LocalPlayback, Rate, Volume)
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
