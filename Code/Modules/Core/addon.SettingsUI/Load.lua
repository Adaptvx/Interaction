---@class addon
local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local PrefabRegistry = addon.PrefabRegistry
local L = addon.Locales

--------------------------------

addon.SettingsUI = {}
local NS = addon.SettingsUI; addon.SettingsUI = NS

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
