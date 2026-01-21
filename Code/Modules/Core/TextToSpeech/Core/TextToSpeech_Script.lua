local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local TemplateRegistry = addon.TemplateRegistry
local L = addon.Locales
local NS = addon.TextToSpeech; addon.TextToSpeech = NS

NS.Script = {}

function NS.Script:Load()

	-- Main
	----------------------------------------------------------------------------------------------------

	do

		function NS.Script:SpeakText(voice, text, rate, volume)
			NS.Variables.IsPlaybackActive = true

			MuteSoundFile(4192839) -- Tts line break

			addon.BlizzardSound.Script:DuckAudio()

			C_VoiceChat.StopSpeakingText()
			C_Timer.After(0, function()
				if Enum.VoiceTtsDestination then
					C_VoiceChat.SpeakText(voice, text, Enum.VoiceTtsDestination.LocalPlayback, rate, volume)
				else
					C_VoiceChat.SpeakText(voice, text, rate, volume, false)
				end
			end)
		end

		function NS.Script:StopSpeakingText()
			NS.Variables.IsPlaybackActive = false

			C_VoiceChat.StopSpeakingText()

			C_Timer.After(.1, function()
				if not NS.Variables.IsPlaybackActive then
					UnmuteSoundFile(4192839) -- Tts line break
					addon.BlizzardSound.Script:UnDuckAudio()
				end
			end)
		end

		function NS.Script:PlayConfiguredTTS(voice, text)
			local isEnabled = addon.Database.DB_GLOBAL.profile.INT_TTS

			local voice = (voice or 1) - 1
			local rate = addon.Database.DB_GLOBAL.profile.INT_TTS_SPEED * .725
			local volume = addon.Database.DB_GLOBAL.profile.INT_TTS_VOLUME

			if isEnabled then
				NS.Script:SpeakText(voice, text, rate, volume)
			end
		end
	end

	-- Events
	----------------------------------------------------------------------------------------------------

	do

	end

	-- Setup
	----------------------------------------------------------------------------------------------------

	do

	end
end
