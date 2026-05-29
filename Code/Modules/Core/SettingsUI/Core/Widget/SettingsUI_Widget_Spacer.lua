local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local TemplateRegistry = addon.TemplateRegistry
local L = addon.Locales
local NS = addon.SettingsUI; addon.SettingsUI = NS

function NS.Widgets:CreateSpacer(parent, spacing)
	local HEIGHT = 45 * spacing

	local Frame = NS.Widgets:CreateContainer(parent, 0, false, HEIGHT, nil, nil, nil, nil, function() return false end, function() return false end, nil)

	return Frame
end
