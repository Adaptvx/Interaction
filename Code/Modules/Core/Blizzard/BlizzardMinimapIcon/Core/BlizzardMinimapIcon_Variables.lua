local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local TemplateRegistry = addon.TemplateRegistry
local L = addon.Locales
local NS = addon.BlizzardMinimapIcon; addon.BlizzardMinimapIcon = NS

NS.Variables = {}

-- Variables
----------------------------------------------------------------------------------------------------

do -- Main
	NS.Variables.Icon = nil
end

do -- Constants
	NS.Variables.PATH = addon.Variables.PATH_ART .. "Icons\\"
end

-- Events
----------------------------------------------------------------------------------------------------
