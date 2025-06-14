---@class addon
local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local PrefabRegistry = addon.PrefabRegistry
local L = addon.Locales

--------------------------------

addon.TextToSpeech = {}
local NS = addon.TextToSpeech; addon.TextToSpeech = NS

--------------------------------

function NS:Load()
	local function Modules()
		NS.Script:Load()
	end

	--------------------------------

	Modules()
end
