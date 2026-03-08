local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local TemplateRegistry = addon.TemplateRegistry
local L = addon.Locales
local NS = addon.HideUI; addon.HideUI = NS

NS.Variables = {}

do
	NS.Variables.Active = false
	NS.Variables.WorldActive = false
	NS.Variables.Lock = false
end
