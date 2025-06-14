---@class addon
local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local PrefabRegistry = addon.PrefabRegistry
local L = addon.Locales
local NS = addon.HideUI; addon.HideUI = NS

--------------------------------

NS.Variables = {}

--------------------------------
-- VARIABLES
--------------------------------

do
	NS.Variables.Active = false
	NS.Variables.WorldActive = false
	NS.Variables.Lock = false
end

--------------------------------
-- EVENTS
--------------------------------
