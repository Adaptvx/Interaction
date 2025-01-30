local addonName, addon = ...
local CallbackRegistry = addon.CallbackRegistry
local L = addon.Locales
local NS = addon.Interaction.Gossip.AutoSelectOptions

--------------------------------

NS.Script = {}

--------------------------------

function NS.Script:Load()
	--------------------------------
	-- REFERENCES
	--------------------------------

	local Callback = NS.Script

	--------------------------------
	-- FUNCTIONS (MAIN)
	--------------------------------

	do
		function Callback:SelectOption(index)
			C_GossipInfo.SelectOptionByIndex(index)

			--------------------------------

			addon.Libraries.AceTimer:ScheduleTimer(function()
				addon.Interaction.Script:Stop(true)
			end, .25)
		end
	end

	--------------------------------
	-- EVENTS
	--------------------------------

	local Events = CreateFrame("Frame")
	Events:RegisterEvent("GOSSIP_SHOW")
	Events:SetScript("OnEvent", function(self, event, ...)
		local AutoSelectOptions = DB_GLOBAL.profile.INT_AUTO_SELECT_OPTION
		if not AutoSelectOptions then
			return
		end

		--------------------------------

		if event == "GOSSIP_SHOW" then
			local GossipOptions = C_GossipInfo.GetOptions()

			--------------------------------

			for i = 1, #GossipOptions do
				local GossipOption = GossipOptions[i]

				local Flags = GossipOption.flags
				local GossipOptionID = GossipOption.gossipOptionID
				local Name = GossipOption.name
				local Status = GossipOption.status
				local OrderIndex = GossipOption.orderIndex
				local Icon = GossipOption.icon
				local SelectOptionWhenOnlyOption = GossipOption.selectOptionWhenOnlyOption

				--------------------------------

				for key, value in pairs(NS.Variables.DB) do
					if key == GossipOptionID then
						if value == NS.Variables.ALWAYS then
							Callback:SelectOption(OrderIndex)
						elseif value == NS.Variables.ONLY_OPTION then
							if OrderIndex == 0 then
								Callback:SelectOption(OrderIndex)
							end
						end
					end
				end
			end
		end
	end)
end
