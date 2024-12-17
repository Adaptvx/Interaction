local addonName, addon = ...
local CallbackRegistry = addon.CallbackRegistry
local L = addon.Locales
local NS = addon.TextToSpeech

--------------------------------

NS.Script = {}

--------------------------------

function NS.Script:Load()

    --------------------------------
    -- FUNCTIONS
    --------------------------------

    function NS.Script:Speak(voice, string)
        local IsTextToSpeech = INTDB.profile.INT_TTS

        local Voice = (voice or 1) - 1
        local Rate = INTDB.profile.INT_TTS_SPEED * .725
        local Volume = INTDB.profile.INT_TTS_VOLUME


        --------------------------------

        if IsTextToSpeech then
            C_VoiceChat.StopSpeakingText()

            --------------------------------

            addon.Libraries.AceTimer:ScheduleTimer(function()
                C_VoiceChat.SpeakText(Voice, string, Enum.VoiceTtsDestination.LocalPlayback, Rate, Volume)
            end, 0)
        end
    end

    function NS.Script:Stop()
        C_VoiceChat.StopSpeakingText()
    end
end
