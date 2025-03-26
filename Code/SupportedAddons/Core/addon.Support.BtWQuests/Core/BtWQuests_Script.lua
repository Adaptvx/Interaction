local addonName, addon = ...
local PrefabRegistry = addon.PrefabRegistry
local CallbackRegistry = addon.CallbackRegistry
local L = addon.Locales
local NS = addon.Support.BtWQuests

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
		do -- GET
			-- Table Format:
			-- 		[storylineID] = {
			-- 			["chainID"] = chainID
			--			["quests"] = {...}
			-- 		}

			function Callback:GetQuestChains()
				local questChains = {}
				local questChainReferences = {}

				------------------------------

				if BtWQuests.Constant.Chain then
					local infoType
					local chainID

					--------------------------------

					for expansionName, expansionInfo in pairs(BtWQuests.Constant.Chain) do
						for name, chainInfo in pairs(expansionInfo) do
							infoType = type(chainInfo)

							--------------------------------

							if infoType == "table" then
								for _, chainID in pairs(chainInfo) do
									local item = BtWQuestsDatabase:GetChainByID(chainID)
									local items = item.items
									local itemName = item.name
									local quests = Callback:ProcessQuests(items)

									--------------------------------

									do -- QUEST CHAINS
										local nameType = type(itemName)
										local nameText = nil

										if nameType == "string" then -- STRING
											nameText = itemName
										elseif nameType == "function" then -- ACHIEVEMENT // BtWQuests_GetAchievementNameDelayed(achievementID)
											nameText = itemName()
										elseif nameType == "table" then -- TABLE
											local nameSubtype = itemName.type

											--------------------------------

											if nameSubtype == "quest" then -- NAME FROM QUEST
												nameText = BtWQuestsDatabase:GetQuestByID(itemName.id).name
											end
										end

										--------------------------------

										local entry = {
											["name"] = nameText,
											["items"] = items,
											["quests"] = quests
										}

										questChains[chainID] = entry
									end

									do -- QUEST CHAIN REFERENCES
										for i = 1, #quests do
											local currentQuest = quests[i]
											local id = currentQuest.id
											local name = currentQuest.name

											--------------------------------

											questChainReferences[id] = chainID
										end
									end
								end
							elseif infoType == "number" then
								chainID = chainInfo

								--------------------------------

								local item = BtWQuestsDatabase:GetChainByID(chainID)
								local questLineID = item.questline
								local quests = item.items

								--------------------------------

								local entry = {
									["chainID"] = chainID,
									["quests"] = quests
								}

								if questLineID then
									questChains[questLineID] = entry
								end
							end
						end
					end
				end

				------------------------------

				return questChains, questChainReferences
			end

			-- Quest Table Format:
			-- 		[1] = {
			-- 			[1] = {
			-- 			id = 213983,
			-- 			type = "npc",
			-- 			connections = {
			-- 				[1] = 1
			-- 			},
			-- 				x = 0
			-- 		},
			-- 		[2] = {
			-- 			variations = {
			-- 				[1] = {
			-- 					id = 83551,
			-- 					type = "quest",
			-- 					restrictions = {
			-- 						id = 83551,
			-- 						type = "quest",
			-- 						status = {
			-- 							[1] = "active",
			-- 							[2] = "completed"
			-- 						}
			-- 					}
			-- 				},
			-- 				[2] = {
			-- 					id = 78658,
			-- 					type = "quest"
			-- 				}
			-- 			},
			-- 			connections = {
			-- 				[1] = 1
			-- 			},
			-- 			x = 0
			-- 		},
			-- 		[3] = {
			-- 			id = 78659,
			-- 			type = "quest",
			-- 			connections = {
			-- 				[1] = 1,
			-- 				[2] = 2
			-- 			},
			-- 			x = 0
			-- 		},
			-- 		[4] = {
			-- 			id = 78665,
			-- 			type = "quest",
			-- 			connections = {
			-- 				[1] = 2,
			-- 				[2] = 3
			-- 			},
			-- 			x = -1
			-- 		},
			-- 		[5] = {
			-- 			id = 79999,
			-- 			type = "quest",
			-- 			connections = {
			-- 				[1] = 1,
			-- 				[2] = 2
			-- 			}
			-- 		},
			-- 		[6] = {
			-- 			id = 78666,
			-- 			type = "quest",
			-- 			connections = {
			-- 				[1] = 2
			-- 			},
			-- 			x = -1
			-- 		},
			-- 		[7] = {
			-- 			id = 78667,
			-- 			type = "quest",
			-- 			connections = {
			-- 				[1] = 1
			-- 			}
			-- 		},
			-- 		[8] = {
			-- 			id = 78668,
			-- 			type = "quest",
			-- 			connections = {
			-- 				[1] = 1,
			-- 				[2] = 2
			-- 			},
			-- 			x = 0
			-- 		},
			-- 		[9] = {
			-- 			id = 78669,
			-- 			type = "quest",
			-- 			connections = {
			-- 				[1] = 2
			-- 			},
			-- 			x = -1
			-- 		},
			-- 		[10] = {
			-- 			id = 78670,
			-- 			type = "quest",
			-- 			connections = {
			-- 				[1] = 1
			-- 			}
			-- 		},
			-- 		[11] = {
			-- 			id = 82836,
			-- 			type = "quest",
			-- 			connections = {
			-- 				[1] = 1
			-- 			},
			-- 			x = 0
			-- 		},
			-- 		[12] = {
			-- 			id = 78671,
			-- 			type = "quest",
			-- 			x = 0
			-- 		}

			function Callback:ProcessQuests(quests)
				local results = {}

				--------------------------------

				for i = 1, #quests do
					local currentQuest = quests[i]
					local isVariation = currentQuest.variations

					--------------------------------

					if not isVariation then
						local questType = currentQuest.type

						--------------------------------

						if questType == "quest" then
							local questID = currentQuest.id
							local questInfo = BtWQuestsDatabase:GetQuestByID(questID)

							--------------------------------

							table.insert(results, questInfo)
						end
					end
				end

				------------------------------

				return results
			end

			function Callback:UpdateQuestChainInfo()
				NS.Variables.QuestChains, NS.Variables.QuestChainReferences = Callback:GetQuestChains()
			end

			-- Against the Current

			-- ----------------------

			-- Surface Bound
			-- The Fleet Arrives
			-- Embassies and Envoys
			-- There's Always Another Secret
			-- What's Hidden Beneath Dornogal
			-- Preparing for the Unknown
			-- Urban Odyssey

			-- ----------------------

			-- Click to open quest chain in BtWQuests

			function Callback:GetTooltipText(questID)
				local success = false
				local text = ""

				--------------------------------

				local chain = NS.Variables.QuestChains[NS.Variables.QuestChainReferences[questID]];

				if chain then
					local quests = chain.quests

					--------------------------------

					text = text .. chain.name .. "\n"
					text = text .. addon.Theme:TOOLTIP_DIVIDER(250) .. "\n"

					for i = 1, #quests do
						local currentQuest = quests[i]
						local currentQuest_questID = currentQuest.id
						local currentQuest_questName = currentQuest.name
						local currentQuest_isCompleted = C_QuestLog.IsQuestFlaggedCompleted(currentQuest_questID)
						local currentQuest_isActive = C_QuestLog.IsOnQuest(currentQuest_questID) or (questID == currentQuest_questID)

						--------------------------------

						if currentQuest_isCompleted then
							text = text .. L["SupportedAddons - BtWQuests - Tooltip - Quest - Completed - Subtext 1"] .. currentQuest_questName .. L["SupportedAddons - BtWQuests - Tooltip - Quest - Completed - Subtext 2"] .. "\n"
						elseif currentQuest_isActive then
							text = text .. L["SupportedAddons - BtWQuests - Tooltip - Quest - Active - Subtext 1"] .. currentQuest_questName .. L["SupportedAddons - BtWQuests - Tooltip - Quest - Active - Subtext 2"] .. "\n"
						else
							text = text .. L["SupportedAddons - BtWQuests - Tooltip - Quest - Incomplete - Subtext 1"] .. currentQuest_questName .. L["SupportedAddons - BtWQuests - Tooltip - Quest - Incomplete - Subtext 2"] .. "\n"
						end
					end

					text = text .. addon.Theme:TOOLTIP_DIVIDER(250) .. "\n"
					text = text .. L["SupportedAddons - BtWQuests - Tooltip - Call to Action"]

					--------------------------------

					success = true
					return success, text
				else
					success = false
					return success, text
				end
			end
		end

		do -- SET
			function Callback:SetStorylineFrame(questID)
				local success, tooltipText = Callback:GetTooltipText(questID)

				--------------------------------

				if success then
					InteractionQuestFrame.Storyline:SetInfo(nil, addon.Variables.PATH_ART .. "Icons/link.png", success, tooltipText, function()
						Callback:OpenQuestInBtWQuestsWindow(questID)
					end)
				end
			end
		end

		do -- FUNCTIONS
			function Callback:OpenQuestInBtWQuestsWindow(questID)
				local item = BtWQuestsDatabase:GetQuestItem(questID, BtWQuestsCharacters:GetPlayer())

				--------------------------------

				if item then
					BtWQuestsFrame:SelectCharacter(UnitName("player"), GetRealmName())
					BtWQuestsFrame:SelectItem(item.item)
				end

				--------------------------------

				addon.Interaction.Script:Stop(true)
			end
		end
	end

	--------------------------------
	-- EVENTS
	--------------------------------

	do
		CallbackRegistry:Add("Quest.Storyline.Update", function(questID)
			Callback:SetStorylineFrame(questID)
		end)
	end

	--------------------------------
	-- SETUP
	--------------------------------

	do
		Callback:UpdateQuestChainInfo()
	end
end
