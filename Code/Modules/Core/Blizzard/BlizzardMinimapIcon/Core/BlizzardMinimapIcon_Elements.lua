local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local TemplateRegistry = addon.TemplateRegistry
local L = addon.Locales
local NS = addon.BlizzardMinimapIcon; addon.BlizzardMinimapIcon = NS

NS.Elements = {}

function NS.Elements:Load()

	do
		do -- Elements
			local function OnTooltipShowCallback(tooltip)
				if NS.Script.OnTooltipShow then
					NS.Script:OnTooltipShow(tooltip)
				end
			end

			local LDB = LibStub("LibDataBroker-1.1"):NewDataObject("Interaction", {
				type = "launcher",
				icon = NS.Variables.PATH .. "Library.png",
				OnClick = function()
					if InteractionReadableUIFrame then
						InteractionReadableUIFrame:ShowLibrary()
					end
				end,
				OnTooltipShow = OnTooltipShowCallback,
			})

			NS.Variables.Icon = LibStub("LibDBIcon-1.0")
			NS.Variables.Icon:Register("Interaction", LDB)
		end
	end

	local Icon = NS.Variables.Icon
	local Callback = NS.Script

end

NS.Elements:Load()
