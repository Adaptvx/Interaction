local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local TemplateRegistry = addon.TemplateRegistry
local L = addon.Locales
local NS = addon.ControlGuide; addon.ControlGuide = NS

NS.Variables = {}

NS.Variables.RATIO_REFERENCE = 35
function NS.Variables:RATIO(level)
    return NS.Variables.RATIO_REFERENCE / addon.Variables:RAW_RATIO(level)
end
NS.Variables.PADDING = NS.Variables:RATIO(1)
NS.Variables.FRAME_STRATA = "HIGH"
NS.Variables.FRAME_LEVEL = 1
NS.Variables.FRAME_LEVEL_MAX = 999
NS.Variables.Elements = {}
