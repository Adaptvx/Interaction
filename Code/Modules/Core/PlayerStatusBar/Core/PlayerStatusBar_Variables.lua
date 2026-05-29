local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local TemplateRegistry = addon.TemplateRegistry
local L = addon.Locales
local NS = addon.PlayerStatusBar; addon.PlayerStatusBar = NS

NS.Variables = {}

NS.Variables.PATH = addon.Variables.PATH_ART .. "PlayerStatusBar\\"
NS.Variables.TEXTURE_Background = NS.Variables.PATH .. "Background.png"
NS.Variables.TEXTURE_Notch = NS.Variables.PATH .. "Notch.png"
NS.Variables.TEXTURE_Progress = NS.Variables.PATH .. "Progress.png"
NS.Variables.TEXTURE_Flare = NS.Variables.PATH .. "Flare.png"
