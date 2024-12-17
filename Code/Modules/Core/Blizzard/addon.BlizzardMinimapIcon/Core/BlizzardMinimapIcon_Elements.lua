local addonName, addon = ...
local CallbackRegistry = addon.CallbackRegistry
local L = addon.Locales
local NS = addon.BlizzardMinimapIcon

--------------------------------

NS.Elements = {}

--------------------------------

function NS.Elements:Load()
	--------------------------------
	-- CREATE ELEMENTS
	--------------------------------

	do
		do -- CREATE ELEMENTS
			local LDB = LibStub("LibDataBroker-1.1"):NewDataObject("Interaction", {
				type = "data source",
				text = L["MinimapIcon - Text"],
				icon = NS.Variables.PATH .. "library.png",
				OnClick = function()
					InteractionReadableUIFrame.ShowLibrary()
				end,
			})

			--------------------------------

			NS.Variables.Icon = LibStub("LibDBIcon-1.0")
			NS.Variables.Icon:Register("Interaction", LDB, INTDB.profile.LibDBIcon)
		end
	end

	--------------------------------
	-- REFERENCES
	--------------------------------

	local Icon = NS.Variables.Icon
	local Callback = NS.Script

	--------------------------------
	-- SETUP
	--------------------------------
end
