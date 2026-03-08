local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local TemplateRegistry = addon.TemplateRegistry
local L = addon.Locales
local NS = addon.Support.ElvUI; addon.Support.ElvUI = NS

NS.Variables = {}
NS.Variables.DIALOG_BACKGROUND = addon.Variables.PATH_ART .. "SupportedAddons\\ElvUI\\dialog-background.png"
