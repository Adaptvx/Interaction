---@class addon
local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local PrefabRegistry = addon.PrefabRegistry
local L = addon.Locales

--------------------------------

addon.Interaction.Quest = {}
local NS = addon.Interaction.Quest; addon.Interaction.Quest = NS

--------------------------------

function NS:Load()
	local function Modules()
		NS.Elements:Load()
		NS.Script:Load()
	end

	local function Prefabs()
		NS.Prefabs:Load()
	end

	local function Submodules()
		NS.Target:Load()
	end

	--------------------------------

	Prefabs()
	Modules()

	addon.Libraries.AceTimer:ScheduleTimer(function()
		Submodules()
	end, 0)
end
