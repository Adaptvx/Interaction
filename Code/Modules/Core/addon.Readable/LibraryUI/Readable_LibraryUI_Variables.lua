---@class addon
local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local PrefabRegistry = addon.PrefabRegistry
local L = addon.Locales
local NS = addon.Readable; addon.Readable = NS

--------------------------------

NS.LibraryUI.Variables = {}

--------------------------------
-- VARIABLES
--------------------------------

do -- MAIN
	NS.LibraryUI.Variables.LibraryDB = nil
	NS.LibraryUI.Variables.SelectedIndex = nil
	NS.LibraryUI.Variables.CurrentPage = 1
end

do -- CONSTANTS
	NS.LibraryUI.Variables.LIBRARY_LOCAL = nil
	NS.LibraryUI.Variables.LIBRARY_GLOBAL = nil
	NS.LibraryUI.Variables.MAX_ENTRIES_PER_PAGE = 10
end

--------------------------------
-- EVENTS
--------------------------------
