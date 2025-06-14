---@class addon
local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local PrefabRegistry = addon.PrefabRegistry
local L = addon.Locales

--------------------------------

addon.AlertNotification = {}
local NS = addon.AlertNotification; addon.AlertNotification = NS

--------------------------------

function NS:Load()
	local function Modules()
		NS.Elements:Load()
		NS.Script:Load()
	end

	--------------------------------

	Modules()
end
