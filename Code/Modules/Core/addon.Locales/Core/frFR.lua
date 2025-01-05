local addonName, addon = ...
local CallbackRegistry = addon.CallbackRegistry
local L = addon.Locales

--------------------------------

local function Load()
    if GetLocale() ~= "frFR" then
        return
    end
end

Load()
