local addonName, addon = ...
local CallbackRegistry = addon.CallbackRegistry
local L = addon.Input

--------------------------------

addon.Input = {}
local NS = addon.Input

--------------------------------

function NS:Load()
	local function Modules()
		NS.Script:Load()
		NS.Navigation:Load()
	end

	--------------------------------

	Modules()
end
