local addonName, addon = ...
local CallbackRegistry = addon.CallbackRegistry
local L = addon.Locales
local NS = addon.HideUI

--------------------------------

NS.Variables = {}

--------------------------------
-- VARIABLES
--------------------------------

do
	NS.Variables.Active = false
	NS.Variables.Lock = false
end

--------------------------------
-- EVENTS
--------------------------------
