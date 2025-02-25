local addonName, addon = ...
local PrefabRegistry = addon.PrefabRegistry
local CallbackRegistry = addon.CallbackRegistry
local L = addon.Locales

--------------------------------

local function Load()
	if GetLocale() ~= "esMX" then
		return
	end
end

Load()
