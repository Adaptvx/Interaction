local addonName, addon = ...
local CallbackRegistry = addon.CallbackRegistry
local PrefabRegistry = addon.PrefabRegistry
local L = addon.Locales
local NS = addon.SettingsUI

--------------------------------

-- Creates a clickable Button. Child Frames: Button
function NS.Widgets:CreateGroup(parent, hidden, locked, opacity)
    local Frame = NS.Widgets:CreateContainer(parent, nil, nil, 0, nil, nil, nil, nil, hidden, locked, opacity)

    --------------------------------

    return Frame
end
