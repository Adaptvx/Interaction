---@class addon
local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local PrefabRegistry = addon.PrefabRegistry
local L = addon.Locales

--------------------------------

addon.GameTooltip = {}
local NS = addon.GameTooltip; addon.GameTooltip = NS

--------------------------------

function NS:Load()
	local function Modules()
		NS.Elements:Load()
		NS.Script:Load()
	end

	--------------------------------

	Modules()
end
