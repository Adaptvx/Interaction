local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local TemplateRegistry = addon.TemplateRegistry
local L = addon.Locales
local NS = addon.SettingsUI; addon.SettingsUI = NS

NS.Variables = {}

NS.Variables.FRAME_SIZE = { x = 875, y = 875 * .65 }
NS.Variables.RATIO_REFERENCE = 568.75
function NS.Variables:RATIO(level)
    return NS.Variables.RATIO_REFERENCE / addon.Variables:RAW_RATIO(level)
end
NS.Variables.SETTINGS_PATH = addon.Variables.PATH_ART .. "Settings\\"
NS.Variables.TOOLTIP_PATH = addon.Variables.PATH_ART .. "Settings\\Tooltip\\"
