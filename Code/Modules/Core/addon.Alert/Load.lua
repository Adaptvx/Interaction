local addonName, addon = ...
local CallbackRegistry = addon.CallbackRegistry
local L = addon.Locales

--------------------------------

addon.Alert = {}
local NS = addon.Alert

--------------------------------

function NS:Load()
	local function Modules()
		NS.Elements:Load()
		NS.Script:Load()
	end

	--------------------------------

	Modules()
end
