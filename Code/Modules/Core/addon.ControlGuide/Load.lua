---@class addon
local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local PrefabRegistry = addon.PrefabRegistry
local L = addon.Locales

--------------------------------

addon.ControlGuide = {}
local NS = addon.ControlGuide; addon.ControlGuide = NS

--------------------------------

function NS:Load()
	local function Modules()
		NS.Elements:Load()
		NS.Script:Load()
	end

	local function Prefabs()
		NS.Prefabs:Load()
	end

	--------------------------------

	Prefabs()
	Modules()
end
