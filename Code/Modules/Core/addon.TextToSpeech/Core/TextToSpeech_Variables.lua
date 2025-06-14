---@class addon
local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local PrefabRegistry = addon.PrefabRegistry
local L = addon.Locales
local NS = addon.TextToSpeech; addon.TextToSpeech = NS

--------------------------------

NS.Variables = {}

--------------------------------
-- VARIABLES
--------------------------------

do -- MAIN
	NS.Variables.IsPlaybackActive = false
end

do -- CONSTANTS

end
