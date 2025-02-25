local addonName, addon = ...
local PrefabRegistry = addon.PrefabRegistry
local CallbackRegistry = addon.CallbackRegistry
local L = addon.Locales

--------------------------------

addon.SettingsUI = {}
local NS = addon.SettingsUI

--------------------------------

function NS:Load()
	local function Modules()
		NS.Utils:Load()

		NS.Elements:Load()
		NS.Script:Load()

		NS.Data:Load()
	end

	--------------------------------

	Modules()
end
