local addonName, addon = ...
local CallbackRegistry = addon.CallbackRegistry
local L = addon.Locales

--------------------------------

addon.ConsoleVariables = {}
local NS = addon.ConsoleVariables

--------------------------------

function NS:Load()
	local function Modules()
		NS.Script:Load()
	end

	--------------------------------

	Modules()
end
