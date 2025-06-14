---@class addon
local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local PrefabRegistry = addon.PrefabRegistry
local L = addon.Locales

--------------------------------

addon.Support = {}
local NS = addon.Support; addon.Support = NS

--------------------------------

function NS:Load()
	local function Modules()

	end

	--------------------------------

	Modules()
end
