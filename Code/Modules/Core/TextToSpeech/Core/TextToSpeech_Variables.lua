local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local TemplateRegistry = addon.TemplateRegistry
local L = addon.Locales
local NS = addon.TextToSpeech; addon.TextToSpeech = NS

NS.Variables = {}

-- Variables
----------------------------------------------------------------------------------------------------

do -- Main
	NS.Variables.IsPlaybackActive = false
end

