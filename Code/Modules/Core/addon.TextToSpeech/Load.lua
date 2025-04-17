local addonName, addon = ...
local CallbackRegistry = addon.CallbackRegistry
local PrefabRegistry = addon.PrefabRegistry
local L = addon.Locales

--------------------------------

addon.TextToSpeech = {}
local NS = addon.TextToSpeech

--------------------------------

function NS:Load()
	local function Modules()
		NS.Script:Load()
	end

	--------------------------------

	Modules()
end
