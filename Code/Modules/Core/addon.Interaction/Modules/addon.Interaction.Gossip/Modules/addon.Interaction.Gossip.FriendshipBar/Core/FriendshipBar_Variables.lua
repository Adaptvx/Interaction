---@class addon
local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local PrefabRegistry = addon.PrefabRegistry
local L = addon.Locales
local NS = addon.Interaction.Gossip.FriendshipBar; addon.Interaction.Gossip.FriendshipBar = NS

--------------------------------

NS.Variables = {}

--------------------------------
-- VARIABLES
--------------------------------

do -- MAIN

end

do -- CONSTANTS
	NS.Variables.PATH = addon.Variables.PATH_ART .. "FriendshipBar/"
end

--------------------------------
-- EVENTS
--------------------------------
