local addonName, addon = ...
local CallbackRegistry = addon.CallbackRegistry
local L = addon.Locales

--------------------------------

addon.BlizzardGameTooltip = {}
local NS = addon.BlizzardGameTooltip

--------------------------------

function NS:Load()
	local function Modules()
		NS.Elements:Load()
		NS.Script:Load()
	end

	--------------------------------

	Modules()
end
