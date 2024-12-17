local addonName, addon = ...
local CallbackRegistry = addon.CallbackRegistry
local L = addon.Locales

--------------------------------

addon.PlayerStatusBar = {}
local NS = addon.PlayerStatusBar

--------------------------------

function NS:Load()
	local function Modules()
		NS.Elements:Load()
		NS.Script:Load()
	end

	--------------------------------

	Modules()
end
