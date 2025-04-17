local addonName, addon = ...
local CallbackRegistry = addon.CallbackRegistry
local PrefabRegistry = addon.PrefabRegistry
local L = addon.Locales

--------------------------------

local function Load()
	if GetLocale() ~= "koKR" then
		return
	end
end

Load()
