local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local TemplateRegistry = addon.TemplateRegistry
local L = addon.Locales
local NS = addon.Support.BtWQuests; addon.Support.BtWQuests = NS

NS.Script = {}

function NS.Script:Load()

	local Callback = NS.Script

	do
		do -- Get
			do -- Reference
			end

			local function ProcessChain(chainID)
				local result = {}

				local chain = BtWQuestsDatabase:GetChainByID(chainID)
				if chain then
					local chainItems = chain.items
					for item, item_content in ipairs(chainItems) do
						if item_content.id and item_content.type and item_content.type == "quest" then
							table.insert(result, item_content.id)
						end

						if item_content.variations then
							for variation, variation_content in ipairs(item_content.variations) do
								if variation_content.id and variation_content.type and variation_content.type == "quest" then
									if not variation_content.restrictions then
										table.insert(result, variation_content.id)
									end
								end
							end
						end
					end
				end

				return result
			end

			function Callback:GetChainIDFromQuest(questID)
				local quest = BtWQuestsDatabase:GetQuestItem(questID, BtWQuestsCharacters:GetPlayer())
				if quest then
					if quest.item and type(quest.item) == "table" and quest.item.type == "chain" then
						return quest.item.id
					end
				end
			end

			function Callback:GetChainInfoFromChainID(chainID)
				local result = {}

				local chain = BtWQuestsDatabase:GetChainByID(chainID)
				local chainName = BtWQuestsDatabase:GetChainName(chainID)
				local chainAllQuestID = ProcessChain(chainID)

				result = {
					name = chainName,
					allQuestID = chainAllQuestID
				}

				return result
			end

			function Callback:GetChainInfoFromQuestID(questID)
				local result = {}

				local chainID = Callback:GetChainIDFromQuest(questID)
				local chainInfo = Callback:GetChainInfoFromChainID(chainID)

				result = {
					chainID = chainID,
					chainInfo = chainInfo
				}

				return result
			end

			function Callback:GetTooltipText(questID)
				local success = false
				local text = ""

				local chain = Callback:GetChainInfoFromQuestID(questID)
				local chainInfo = chain.chainInfo

				if chainInfo and chainInfo.name then
					local quests = chainInfo.allQuestID

					text = text .. chainInfo.name .. "\n"
					text = text .. addon.Theme:TOOLTIP_DIVIDER(250) .. "\n"

					for i = 1, #quests do
						local id = quests[i]
						local name = BtWQuestsDatabase:GetQuestName(id)
						local isCompleted = C_QuestLog.IsQuestFlaggedCompleted(id)
						local isActive = C_QuestLog.IsOnQuest(id) or (questID == id)

						if name then
							if isCompleted then
								text = text .. L["SupportedAddons - BtWQuests - Tooltip - Quest - Completed - Subtext 1"] .. name .. L["SupportedAddons - BtWQuests - Tooltip - Quest - Completed - Subtext 2"] .. "\n"
							elseif isActive then
								text = text .. L["SupportedAddons - BtWQuests - Tooltip - Quest - Active - Subtext 1"] .. name .. L["SupportedAddons - BtWQuests - Tooltip - Quest - Active - Subtext 2"] .. "\n"
							else
								text = text .. L["SupportedAddons - BtWQuests - Tooltip - Quest - Incomplete - Subtext 1"] .. name .. L["SupportedAddons - BtWQuests - Tooltip - Quest - Incomplete - Subtext 2"] .. "\n"
							end
						end
					end

					text = text .. addon.Theme:TOOLTIP_DIVIDER(250) .. "\n"
					text = text .. L["SupportedAddons - BtWQuests - Tooltip - Call to Action"]

					success = true
					return success, text
				else
					success = false
					return success, text
				end
			end
		end

		do -- Set

			function Callback:SetStorylineFrame(questID)
				local success, tooltipText = Callback:GetTooltipText(questID)

				if success then
					InteractionFrame.QuestFrame.REF_HEADER_STORYLINE.Storyline:SetInfo(nil, addon.Variables.PATH_ART .. "Icons\\link.png", success, tooltipText, function()
						Callback:OpenQuestInBtWQuestsWindow(questID)
					end)
				end
			end
		end

		do -- Functions

			function Callback:OpenQuestInBtWQuestsWindow(questID)
				local chainID = Callback:GetChainIDFromQuest(questID)
				local chain = BtWQuestsDatabase:GetChainByID(chainID)

				local link = chain:GetLink()
				BtWQuestsFrame:Show()
				C_Timer.After(0, function()
					local scrollTo = nil
					BtWQuestsFrame:SelectFromLink(link, scrollTo)
				end)
				addon.Interaction.Script:Stop(true)
			end
		end
	end

	do
		CallbackRegistry:Add("Quest.Storyline.Update", function(questID)
			Callback:SetStorylineFrame(questID)
		end)
	end
end
