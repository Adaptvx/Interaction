local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local TemplateRegistry = addon.TemplateRegistry
local L = addon.Locales
local NS = addon.Readable; addon.Readable = NS

NS.Variables = {}

NS.Variables.Frame = nil
NS.Variables.ReadableUIFrame = nil
NS.Variables.LibraryUIFrame = nil
NS.Variables.RATIO_REFERENCE = addon.API.Main:GetScreenHeight()
function NS.Variables:RATIO(level)
    return NS.Variables.RATIO_REFERENCE / addon.Variables:RAW_RATIO(level)
end
NS.Variables.READABLE_UI_PATH = addon.Variables.PATH_ART .. "Readable\\"
NS.Variables.SCREEN_WIDTH = addon.API.Main:GetScreenWidth()
NS.Variables.SCREEN_HEIGHT = addon.API.Main:GetScreenHeight()
NS.Variables.TEXTURE_BUTTON_DEFAULT = NS.Variables.READABLE_UI_PATH .. "Elements\\Button.png"
NS.Variables.TEXTURE_BUTTON_HEAVY = NS.Variables.READABLE_UI_PATH .. "Elements\\HeavyButton.png"
NS.Variables.TEXTURE_BUTTON_HIGHLIGHT = NS.Variables.READABLE_UI_PATH .. "Elements\\ButtonHighlighted.png"
NS.Variables.TEXTURE_RUSTIC = addon.API.Presets.TEXTURE_RUSTIC_FILLED
NS.Variables.TEXTURE_RUSTIC_BORDER = addon.API.Presets.TEXTURE_RUSTIC_BORDER
NS.Variables.TEXTURE_CHECK = NS.Variables.READABLE_UI_PATH .. "Elements\\Checkbox-Checked.png"
