---@class addon
local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local PrefabRegistry = addon.PrefabRegistry
local L = addon.Locales
local NS = addon.PlayerStatusBar; addon.PlayerStatusBar = NS

--------------------------------

NS.Variables = {}

--------------------------------
-- VARIABLES
--------------------------------

do -- MAIN

end

do -- CONSTANTS
	NS.Variables.PATH = addon.Variables.PATH_ART .. "PlayerStatusBar/"
	NS.Variables.TEXTURE_Background = NS.Variables.PATH .. "background.png"
	NS.Variables.TEXTURE_Notch = NS.Variables.PATH .. "notch.png"
	NS.Variables.TEXTURE_Progress = NS.Variables.PATH .. "progress.png"
	NS.Variables.TEXTURE_Flare = NS.Variables.PATH .. "flare.png"
end

--------------------------------
-- EVENTS
--------------------------------
