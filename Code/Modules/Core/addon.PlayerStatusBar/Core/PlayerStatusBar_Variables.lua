local addonName, addon = ...
local CallbackRegistry = addon.CallbackRegistry
local L = addon.Locales
local NS = addon.PlayerStatusBar

--------------------------------

NS.Variables = {}

--------------------------------
-- VARIABLES
--------------------------------

do -- MAIN

end

do -- CONSTANTS
	NS.Variables.PATH = addon.Variables.PATH .. "Art/PlayerStatusBar/"
	NS.Variables.TEXTURE_Background = NS.Variables.PATH .. "background.png"
	NS.Variables.TEXTURE_Notch = NS.Variables.PATH .. "notch.png"
	NS.Variables.TEXTURE_Progress = NS.Variables.PATH .. "progress.png"
	NS.Variables.TEXTURE_Flare = NS.Variables.PATH .. "flare.png"
end

--------------------------------
-- EVENTS
--------------------------------
