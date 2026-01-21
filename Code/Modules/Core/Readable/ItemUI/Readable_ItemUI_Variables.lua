local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local TemplateRegistry = addon.TemplateRegistry
local L = addon.Locales
local NS = addon.Readable; addon.Readable = NS

NS.ItemUI.Variables = {}

-- Variables
----------------------------------------------------------------------------------------------------

do -- Main
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


-- Events
----------------------------------------------------------------------------------------------------
