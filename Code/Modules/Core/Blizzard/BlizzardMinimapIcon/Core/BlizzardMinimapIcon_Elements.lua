local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local TemplateRegistry = addon.TemplateRegistry
local L = addon.Locales
local NS = addon.BlizzardMinimapIcon; addon.BlizzardMinimapIcon = NS

NS.Elements = {}

function NS.Elements:Load()

	-- Create elements
	----------------------------------------------------------------------------------------------------

	do
		do -- Elements
			local function OnTooltipShowCallback(tooltip)
				NS.Script:OnTooltipShow(tooltip)
			end

			local LDB = LibStub("LibDataBroker-1.1"):NewDataObject("Interaction", {
				type = "data source",
				icon = NS.Variables.PATH .. "library.png",
				OnClick = function()
					InteractionReadableUIFrame:ShowLibrary()
				end,
				OnTooltipShow = OnTooltipShowCallback,
			})

			NS.Variables.Icon = LibStub("LibDBIcon-1.0")
			NS.Variables.Icon:Register("Interaction", LDB, addon.Database.DB_GLOBAL.profile.LibDBIcon)
		end
	end

	-- References
	----------------------------------------------------------------------------------------------------

	local Icon = NS.Variables.Icon
	local Callback = NS.Script

	-- Setup
	----------------------------------------------------------------------------------------------------
end
