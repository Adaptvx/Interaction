local addonName, addon = ...
local CallbackRegistry = addon.CallbackRegistry
local L = addon.Locales
local NS = addon.SettingsUI

--------------------------------

-- Creates a clickable Button. Child Frames: Button
function NS.Widgets:CreateGroup(parent, hidden, locked)
    local Frame = NS.Widgets:CreateContainer(parent, nil, nil, 0, nil, nil, nil, nil, hidden, locked)

    --------------------------------

    return Frame
end
