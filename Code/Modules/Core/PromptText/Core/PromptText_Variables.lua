local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local TemplateRegistry = addon.TemplateRegistry
local L = addon.Locales
local NS = addon.PromptText; addon.PromptText = NS

NS.Variables = {}

NS.Variables.PATH = addon.Variables.PATH_ART .. "Readable\\"
NS.Variables.TEXTURE_BUTTON_DEFAULT = NS.Variables.PATH .. "Elements\\Button.png"
NS.Variables.TEXTURE_BUTTON_HEAVY = NS.Variables.PATH .. "Elements\\HeavyButton.png"
NS.Variables.TEXTURE_BUTTON_HIGHLIGHT = NS.Variables.PATH .. "Elements\\ButtonHighlighted.png"
