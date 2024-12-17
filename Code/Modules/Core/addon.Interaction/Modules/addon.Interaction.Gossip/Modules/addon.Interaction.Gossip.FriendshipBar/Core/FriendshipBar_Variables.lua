local addonName, addon = ...
local CallbackRegistry = addon.CallbackRegistry
local L = addon.Locales
local NS = addon.Interaction.Gossip.FriendshipBar

--------------------------------

NS.Variables = {}

--------------------------------
-- VARIABLES
--------------------------------

do -- MAIN
	NS.Variables.Parent = nil
	NS.Variables.Frame = nil
end

do -- CONSTANTS
	NS.Variables.PATH = addon.Variables.PATH .. "Art/FriendshipBar/"
	NS.Variables.BLIZZARD_BAR_FRIENDSHIP = nil; if not addon.Variables.IS_CLASSIC then NS.Variables.BLIZZARD_BAR_FRIENDSHIP = GossipFrame.FriendshipStatusBar else NS.Variables.BLIZZARD_BAR_FRIENDSHIP = NPCFriendshipStatusBar end
end

--------------------------------
-- EVENTS
--------------------------------
