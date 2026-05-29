local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local TemplateRegistry = addon.TemplateRegistry
local L = addon.Locales
local NS = addon.Audiobook; addon.Audiobook = NS

NS.Variables = {}

NS.Variables.IsPlaying = nil
NS.Variables.LastPlayTime = nil
NS.Variables.PlaybackLineIndex = nil
NS.Variables.PlaybackTimer = nil
NS.Variables.Title = nil
NS.Variables.NumPages = nil
NS.Variables.Content = nil
NS.Variables.Lines = nil
NS.Variables.FRAME_WIDTH = 350
NS.Variables.FRAME_HEIGHT = 50
NS.Variables.RATIO_REFERENCE = 50
function NS.Variables:RATIO(level)
    return NS.Variables.RATIO_REFERENCE / addon.Variables:RAW_RATIO(level)
end
NS.Variables.AUDIOBOOKUI_PATH = addon.Variables.PATH_ART .. "Audiobook\\"
NS.Variables.READABLEUI_PATH = addon.Variables.PATH_ART .. "Readable\\"
NS.Variables.TEXTURE_BUTTON_DEFAULT = NS.Variables.READABLEUI_PATH .. "Elements\\Button.png"
NS.Variables.TEXTURE_BUTTON_HEAVY = NS.Variables.READABLEUI_PATH .. "Elements\\HeavyButton.png"
NS.Variables.TEXTURE_BUTTON_HIGHLIGHT = NS.Variables.READABLEUI_PATH .. "Elements\\ButtonHighlighted.png"
NS.Variables.PADDING = 10
