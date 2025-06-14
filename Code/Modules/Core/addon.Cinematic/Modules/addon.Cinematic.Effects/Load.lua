---@class addon
local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local PrefabRegistry = addon.PrefabRegistry
local L = addon.Locales

--------------------------------

addon.Cinematic.Effects = {}
local NS = addon.Cinematic.Effects; addon.Cinematic.Effects = NS

--------------------------------

function NS:Load()
	local function Modules()
		NS.Elements:Load()
		NS.Script:Load()
	end

	--------------------------------

	Modules()
end
