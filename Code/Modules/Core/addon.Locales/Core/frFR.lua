---@class addon
local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local PrefabRegistry = addon.PrefabRegistry
local L = addon.Locales

--------------------------------

local function Load()
    if GetLocale() ~= "frFR" then
        return
    end
end

Load()
