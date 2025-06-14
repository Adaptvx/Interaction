---@class addon
local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local PrefabRegistry = addon.PrefabRegistry
local L = addon.Locales

--------------------------------

addon.Interaction.Gossip = {}
local NS = addon.Interaction.Gossip; addon.Interaction.Gossip = NS

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
		NS.AutoSelect:Load()
		NS.FriendshipBar:Load()
	end

	--------------------------------

	Prefabs()
	Modules()

	addon.Libraries.AceTimer:ScheduleTimer(function()
		Submodules()
	end, 0)
end
