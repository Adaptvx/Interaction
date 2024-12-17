local addonName, addon = ...
local CallbackRegistry = addon.CallbackRegistry
local L = addon.Locales
local NS = addon.Readable

--------------------------------

NS.ItemUI.Variables = {}

--------------------------------
-- VARIABLES
--------------------------------

do -- MAIN
    NS.ItemUI.Variables.ItemID = nil
    NS.ItemUI.Variables.ItemLink = nil
    NS.ItemUI.Variables.Type = nil
    NS.ItemUI.Variables.Title = nil
    NS.ItemUI.Variables.NumPages = 0
    NS.ItemUI.Variables.Content = {}
    NS.ItemUI.Variables.CurrentPage = 0
    NS.ItemUI.Variables.IsItemInInventory = false
	NS.ItemUI.Variables.PlayerName = {}
end

do -- CONSTANTS

end

--------------------------------
-- EVENTS
--------------------------------
