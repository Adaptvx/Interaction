local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local TemplateRegistry = addon.TemplateRegistry
local L = addon.Locales
local NS = addon.Interaction.Gossip; addon.Interaction.Gossip = NS

NS.Variables = {}

NS.Variables.NumCurrentButtons = 0
NS.Variables.State = ""
NS.Variables.RefreshInProgress = false
NS.Variables.CurrentSession = {
    ["npc"] = nil
}
NS.Variables.BUTTON_SPACING = -5
NS.Variables.RATIO_REFERENCE = 45
function NS.Variables:RATIO(level)
    return NS.Variables.RATIO_REFERENCE / addon.Variables:RAW_RATIO(level)
end
NS.Variables.PATH = addon.Variables.PATH_ART .. "Gossip\\"
NS.Variables.PADDING = 10
NS.Variables.FRAME_STRATA = "HIGH"
NS.Variables.FRAME_LEVEL = 99
NS.Variables.FRAME_LEVEL_MAX = 999
NS.Variables.Buttons = {}
