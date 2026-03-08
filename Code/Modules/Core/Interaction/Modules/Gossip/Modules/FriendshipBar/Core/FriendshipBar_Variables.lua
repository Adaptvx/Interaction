local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local TemplateRegistry = addon.TemplateRegistry
local L = addon.Locales
local NS = addon.Interaction.Gossip.FriendshipBar; addon.Interaction.Gossip.FriendshipBar = NS

NS.Variables = {}
NS.Variables.PATH = addon.Variables.PATH_ART .. "FriendshipBar\\"
