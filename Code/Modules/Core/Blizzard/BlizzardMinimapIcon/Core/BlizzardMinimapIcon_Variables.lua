local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local TemplateRegistry = addon.TemplateRegistry
local L = addon.Locales
local NS = addon.BlizzardMinimapIcon; addon.BlizzardMinimapIcon = NS

NS.Variables = {}

NS.Variables.Icon = nil
NS.Variables.PATH = addon.Variables.PATH_ART .. "Icons\\"
