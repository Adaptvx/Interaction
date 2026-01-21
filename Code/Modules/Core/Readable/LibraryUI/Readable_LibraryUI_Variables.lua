local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local TemplateRegistry = addon.TemplateRegistry
local L = addon.Locales
local NS = addon.Readable; addon.Readable = NS

NS.LibraryUI.Variables = {}

-- Variables
----------------------------------------------------------------------------------------------------

do -- Main
	NS.LibraryUI.Variables.LibraryDB = nil
	NS.LibraryUI.Variables.SelectedIndex = nil
	NS.LibraryUI.Variables.CurrentPage = 1
end

do -- Constants
	NS.LibraryUI.Variables.LIBRARY_LOCAL = nil
	NS.LibraryUI.Variables.LIBRARY_GLOBAL = nil
	NS.LibraryUI.Variables.MAX_ENTRIES_PER_PAGE = 10
end

-- Events
----------------------------------------------------------------------------------------------------
