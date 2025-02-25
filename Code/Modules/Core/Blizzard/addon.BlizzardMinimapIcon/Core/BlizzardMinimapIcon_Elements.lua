local addonName, addon = ...
local PrefabRegistry = addon.PrefabRegistry
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
			local function OnTooltipShowCallback(tooltip)
				NS.Script:OnTooltipShow(tooltip)
			end

			local LDB = LibStub("LibDataBroker-1.1"):NewDataObject("Interaction", {
				type = "data source",
				icon = NS.Variables.PATH .. "library.png",
				OnClick = function()
					InteractionReadableUIFrame.ShowLibrary()
				end,
				OnTooltipShow = OnTooltipShowCallback,
			})

			--------------------------------

			NS.Variables.Icon = LibStub("LibDBIcon-1.0")
			NS.Variables.Icon:Register("Interaction", LDB, addon.Database.DB_GLOBAL.profile.LibDBIcon)
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
