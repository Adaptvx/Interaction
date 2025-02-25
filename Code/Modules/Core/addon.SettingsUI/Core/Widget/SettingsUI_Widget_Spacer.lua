local addonName, addon = ...
local PrefabRegistry = addon.PrefabRegistry
local CallbackRegistry = addon.CallbackRegistry
local L = addon.Locales
local NS = addon.SettingsUI

--------------------------------

-- Creates a Spacer.
function NS.Widgets:CreateSpacer(parent, spacing)
	local HEIGHT = 45 * spacing

	--------------------------------

	local Frame = NS.Widgets:CreateContainer(parent, 0, false, HEIGHT, nil, nil, nil, nil, function() return false end, function() return false end, nil)

	--------------------------------

	return Frame
end
