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
	-- EVENTS
	--------------------------------

	local Events = CreateFrame("Frame")
	Events:RegisterEvent("GOSSIP_SHOW")
	Events:SetScript("OnEvent", function(self, event, ...)
		local AutoSelectOptions = INTDB.profile.INT_AUTO_SELECT_OPTION
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
							C_GossipInfo.SelectOptionByIndex(OrderIndex)
						elseif value == NS.Variables.ONLY_OPTION then
							if OrderIndex == 0 then
								C_GossipInfo.SelectOptionByIndex(OrderIndex)
							end
						end
					end
				end
			end
		end
	end)
end
