local addonName, addon = ...
local CallbackRegistry = addon.CallbackRegistry
local L = addon.Locales
local NS = addon.ContextIcon

--------------------------------

NS.Script = {}

--------------------------------

local CONTEXT_ICON_PATH = addon.Variables.PATH .. "Art/ContextIcons/"
local ICON_MAP = {
	-- GOSSIP
	["132053"] = "gossip-bubble",

	-- DEFAULT
	["132048"] = "quest-complete",
	["132049"] = "quest-available",
	["-1746"] = "quest-available", -- Cata classic bug?

	-- CLASSIC ERA
	["136788"] = "quest-available",

	-- IMPORTANT
	["importantactivequesticon"] = "quest-important-complete",
	["importantavailablequesticon"] = "quest-important-available",
	["importantincompletequesticon"] = "quest-important-active",

	-- RECURRING
	["Recurringactivequesticon"] = "quest-recurring-complete",
	["Recurringavailablequesticon"] = "quest-recurring-available",
	["Recurringincompletequesticon"] = "quest-recurring-active",

	-- REPEATABLE
	["Repeatableactivequesticon"] = "quest-repeatable-complete",
	["Repeatableavailablequesticon"] = "quest-repeatable-available",
	["Repeatableicnompletequesticon"] = "quest-repeatable-active",

	-- CAMPAIGN
	["CampaignActiveQuestIcon"] = "quest-campaign-complete",
	["CampaignAvailableQuestIcon"] = "quest-campaign-available",
	["CampaignIncompleteQuestIcon"] = "quest-campaign-active",
	["CampaignActiveDailyQuestIcon"] = "quest-campaign-recurring-complete",
	["CampaignAvailableDailyQuestIcon"] = "quest-campaign-recurring-available",

	-- META
	["Wrapperactivequesticon"] = "quest-meta-complete",
	["Wrapperavailablequesticon"] = "quest-meta-available",
	["Wrapperincompletequesticon"] = "quest-meta-active",

	-- LEGENDARY
	["legendaryactivequesticon"] = "quest-legendary-complete",
	["legendaryavailablequesticon"] = "quest-legendary-available",
	["legendaryincompletequesticon"] = "quest-legendary-active",

	-- IN_PROGRESS
	["CampaignInProgressQuestIcon"] = "quest-campaign-active",
	["RepeatableInProgressquesticon"] = "quest-recurring-active",
	["SideInProgressquesticon"] = "quest-active",
	["importantInProgressquesticon"] = "quest-important-active",
	["WrapperInProgressquesticon"] = "quest-meta-active",
	["legendaryInProgressquesticon"] = "quest-legendary-active",
}

local function MissingAPI()
	return false
end
local function ReadyForTurnInMakeshiftAPI(questID)
	local isRetail = not addon.Variables.IS_CLASSIC and not addon.Variables.IS_CLASSIC_ERA
	local result = false

	--------------------------------

	if (isRetail and C_QuestLog.IsQuestComplete(questID)) or (not isRetail and IsQuestComplete(questID)) then
		result = true
	else
		if QuestFrameCompleteQuestButton:IsVisible() or QuestFrameCompleteButton:IsVisible() and QuestFrameCompleteButton:IsEnabled() then
			result = true
		end
	end

	--------------------------------

	return result
end

local IsOnQuest = C_QuestLog.IsOnQuest or MissingAPI
local IsReadyForTurnIn = C_QuestLog.ReadyForTurnIn or ReadyForTurnInMakeshiftAPI or MissingAPI
local IsAutoAccept = addon.API.IsAutoAccept
local GetAvailableQuestInfo = GetAvailableQuestInfo or function() return false, 0, false, false, 0 end

--------------------------------

function addon.ContextIcon.Script:Load()
	--------------------------------
	-- REFERENCES
	--------------------------------

	local DB = ICON_MAP

	--------------------------------
	-- FUNCTIONS
	--------------------------------

	do
		do -- UTILITIES
			function addon.ContextIcon.Script:ConvertToInlineIcon(name, isTexture)
				local iconPath = isTexture and name or (CONTEXT_ICON_PATH .. name .. ".png")
				return AdaptiveAPI:InlineIcon(iconPath, 16, 16, 0, 0)
			end
		end

		do -- REPLACEMENT
			function addon.ContextIcon.Script:ReplaceIcon(texture)
				local Result = texture

				for k, v in pairs(DB) do
					if tostring(texture) == tostring(k) then
						Result = addon.Variables.PATH .. "Art/ContextIcons/" .. v .. ".png"
					end
				end

				return Result
			end

			function addon.ContextIcon.Script:ChangeIcon(texture)
				return addon.ContextIcon.Script:ReplaceIcon(texture)
			end
		end

		do -- GET
			function addon.ContextIcon.Script:GetContextIcon(gossipButtonInfo, gossipButtonOptionTexture)
				local isRetail = not addon.Variables.IS_CLASSIC and not addon.Variables.IS_CLASSIC_ERA
				local isClassicCata = addon.Variables.IS_CLASSIC and not addon.Variables.IS_CLASSIC_ERA
				local isClassicEra = addon.Variables.IS_CLASSIC_ERA

				local isGossip = (GossipFrame:IsVisible() or QuestFrameGreetingPanel:IsVisible())
				local isQuest = (QuestFrame:IsVisible() and not QuestFrameGreetingPanel:IsVisible())

				local queryQuest = (gossipButtonInfo ~= nil or isQuest)
				local queryGossip = (not queryQuest)

				--------------------------------

				local result
				local resultTexture

				--------------------------------

				do -- RETAIL
					if isRetail then
						local resultPath

						--------------------------------

						if queryQuest then
							local questID

							--------------------------------

							if gossipButtonInfo then
								questID = gossipButtonInfo.questID or nil
							else
								questID = GetQuestID()
							end

							--------------------------------

							if questID then
								local questClassification = C_QuestInfoSystem.GetQuestClassification(questID)
								local questType = C_QuestLog.GetQuestType(questID)

								local isAvailable = (QuestFrameAcceptButton:IsVisible() or IsAutoAccept())
								local isCompleted = (IsReadyForTurnIn(questID)) and not isAvailable
								local isOnQuest = (C_QuestLog.IsOnQuest(questID) and not isAvailable)
								local isDefault = (questClassification == Enum.QuestClassification.Normal)
								local isImportant = (questClassification == Enum.QuestClassification.Important)
								local isCampaign = (questClassification == Enum.QuestClassification.Campaign)
								local isLegendary = (questClassification == Enum.QuestClassification.Legendary)
								local isCalling = (questClassification == Enum.QuestClassification.Calling)
								local isMeta = (questClassification == Enum.QuestClassification.Meta)
								local isRecurring = (questClassification == Enum.QuestClassification.Recurring)
								local isRepeatable = (C_QuestLog.IsQuestRepeatableType(questID))

								local isAccount = (questType == Enum.QuestTag.Account)
								local isCombatAlly = (questType == Enum.QuestTag.CombatAlly)
								local isDelve = (questType == Enum.QuestTag.Delve)
								local isDungeon = (questType == Enum.QuestTag.Dungeon)
								local isGroup = (questType == Enum.QuestTag.Group)
								local isHeroic = (questType == Enum.QuestTag.Heroic)
								local isLegendary = (questType == Enum.QuestTag.Legendary)
								local isArtifact = (questType == 107) -- Artifact
								local isPvP = (questType == Enum.QuestTag.PvP)
								local isRaid = (questType == Enum.QuestTag.Raid)
								local isRaid10 = (questType == Enum.QuestTag.Raid10)
								local isRaid25 = (questType == Enum.QuestTag.Raid25)
								local isScenario = (questType == Enum.QuestTag.Scenario)

								--------------------------------

								if isCompleted then
									if isDefault then
										resultPath = "quest-complete"
									elseif isImportant then
										resultPath = "quest-important-complete"
									elseif isCampaign then
										resultPath = "quest-campaign-complete"
									elseif isLegendary then
										resultPath = "quest-legendary-complete"
									elseif isArtifact then
										resultPath = "quest-artifact-complete"
									elseif isCalling then
										resultPath = "quest-campaign-recurring-complete"
									elseif isMeta then
										resultPath = "quest-meta-complete"
									elseif isRecurring then
										resultPath = "quest-recurring-complete"
									elseif isRepeatable then
										resultPath = "quest-repeatable-complete"
									end
								elseif isOnQuest then
									if isDefault then
										resultPath = "quest-active"
									elseif isImportant then
										resultPath = "quest-important-active"
									elseif isCampaign then
										resultPath = "quest-campaign-active"
									elseif isLegendary then
										resultPath = "quest-legendary-active"
									elseif isArtifact then
										resultPath = "quest-artifact-active"
									elseif isCalling then
										resultPath = "quest-campaign-recurring-active"
									elseif isMeta then
										resultPath = "quest-meta-active"
									elseif isRecurring then
										resultPath = "quest-recurring-active"
									elseif isRepeatable then
										resultPath = "quest-repeatable-active"
									end
								else
									if isDefault then
										resultPath = "quest-available"
									elseif isImportant then
										resultPath = "quest-important-available"
									elseif isCampaign then
										resultPath = "quest-campaign-available"
									elseif isLegendary then
										resultPath = "quest-legendary-available"
									elseif isArtifact then
										resultPath = "quest-artifact-available"
									elseif isCalling then
										resultPath = "quest-campaign-recurring-available"
									elseif isMeta then
										resultPath = "quest-meta-available"
									elseif isRecurring then
										resultPath = "quest-recurring-available"
									elseif isRepeatable then
										resultPath = "quest-repeatable-available"
									end
								end
							else
								if gossipButtonOptionTexture then
									local new = addon.ContextIcon.Script:ReplaceIcon(gossipButtonOptionTexture)
									resultPath = nil
									resultTexture = new
								end
							end

							--------------------------------

							if resultPath and not resultTexture then
								result = addon.ContextIcon.Script:ConvertToInlineIcon(resultPath)
								resultTexture = addon.Variables.PATH .. "Art/ContextIcons/" .. resultPath .. ".png"
							else
								-- print("Invalid Texture")
							end
						end

						if queryGossip then
							resultPath = "gossip-bubble"

							--------------------------------

							if resultPath then
								result = addon.ContextIcon.Script:ConvertToInlineIcon(resultPath)
								resultTexture = addon.Variables.PATH .. "Art/ContextIcons/" .. resultPath .. ".png"
							else
								-- print("Invalid Texture")
							end
						end
					end
				end

				do -- CLASSIC CATA
					if isClassicCata then
						local resultPath

						--------------------------------

						local questInfo = {}
						local currentQuestInfo = {}

						--------------------------------

						if queryQuest then
							local questID

							--------------------------------

							if gossipButtonInfo then
								-- QUEST ID
								questID = gossipButtonInfo.questID or nil

								-- FILL DATA
								currentQuestInfo.isComplete = gossipButtonInfo.isComplete or false
							else
								-- QUEST ID
								questID = GetQuestID()

								-- FILL DATA
								currentQuestInfo.title,
								currentQuestInfo.level,
								currentQuestInfo.suggestedGroup,
								currentQuestInfo.isHeader,
								currentQuestInfo.isCollapsed,
								currentQuestInfo.isComplete,
								currentQuestInfo.frequency,
								currentQuestInfo.questID,
								currentQuestInfo.startEvent,
								currentQuestInfo.displayQuestID,
								currentQuestInfo.isOnMap,
								currentQuestInfo.hasLocalPOI,
								currentQuestInfo.isTask,
								currentQuestInfo.isBounty,
								currentQuestInfo.isStory,
								currentQuestInfo.isHidden,
								currentQuestInfo.isScaling = GetQuestLogTitle(GetQuestLogIndexByID(questID))

								-- QUERY MISSING REFERENCES
								if currentQuestInfo.isOnQuest == nil then
									currentQuestInfo.isOnQuest = (IsOnQuest and IsOnQuest(questID)) or false
								end

								if not currentQuestInfo.isComplete then
									currentQuestInfo.isComplete = (IsReadyForTurnIn and IsReadyForTurnIn(questID)) or false
								end

								if QuestFrameAcceptButton:IsVisible() then
									currentQuestInfo.isComplete = false
								end
							end

							--------------------------------

							if questID then
								local questType = GetQuestTagInfo(questID)

								local isAvailable = (QuestFrameAcceptButton:IsVisible() or IsAutoAccept())
								local isCompleted = (((currentQuestInfo.isComplete) or (IsReadyForTurnIn and IsReadyForTurnIn(questID))) and not isAvailable)
								local isOnQuest = (((currentQuestInfo.isOnQuest) or (IsOnQuest and IsOnQuest(questID)) or questInfo.missingQuestID) and not isAvailable)
								local isRecurring = ((currentQuestInfo.frequency or 0) == (2)) -- 1 = Default, 2 = Daily, 3 = Weekly. Sometimes non-weekly quests get flagged as weekly by Blizzard?
								local isDefault = (not isRecurring)

								local isGroup = (questType == 1)
								local isPvP = (questType == 41)
								local isRaid = (questType == 62)
								local isDungeon = (questType == 81)
								local isLegendary = (questType == 83)
								local isHeroic = (questType == 85)
								local isScenario = (questType == 98)
								local isAccount = (questType == 102)
								local isLeatherworkingWorldQuest = (questType == 117)

								--------------------------------

								if isCompleted then
									if isDefault then
										resultPath = "quest-complete"
									elseif isRecurring then
										resultPath = "quest-recurring-complete"
									end
								elseif isOnQuest then
									if isDefault then
										resultPath = "quest-active"
									elseif isRecurring then
										resultPath = "quest-recurring-active"
									end
								else
									if isDefault then
										resultPath = "quest-available"
									elseif isRecurring then
										resultPath = "quest-recurring-available"
									end
								end
							else
								if gossipButtonOptionTexture then
									local new = addon.ContextIcon.Script:ReplaceIcon(gossipButtonOptionTexture)
									resultPath = nil
									resultTexture = new
								end
							end

							--------------------------------

							if resultPath and not resultTexture then
								result = addon.ContextIcon.Script:ConvertToInlineIcon(resultPath)
								resultTexture = addon.Variables.PATH .. "Art/ContextIcons/" .. resultPath .. ".png"
							else
								-- print("Invalid Texture")
							end
						end

						if queryGossip then
							resultPath = "gossip-bubble"

							--------------------------------

							if resultPath then
								result = addon.ContextIcon.Script:ConvertToInlineIcon(resultPath)
								resultTexture = addon.Variables.PATH .. "Art/ContextIcons/" .. resultPath .. ".png"
							else
								-- print("Invalid Texture")
							end
						end
					end
				end

				do -- CLASSIC ERA
					if isClassicEra then
						local resultPath

						--------------------------------

						local questInfo = {}
						local currentQuestInfo = {}

						--------------------------------

						if queryQuest then
							local questID

							--------------------------------

							if gossipButtonInfo then
								-- QUEST ID
								questID = gossipButtonInfo.questID or nil

								-- FILL DATA
								currentQuestInfo.isComplete = gossipButtonInfo.isComplete or false
							else
								-- QUEST ID
								questID = GetQuestID()

								-- FILL DATA
								currentQuestInfo.title,
								currentQuestInfo.level,
								currentQuestInfo.suggestedGroup,
								currentQuestInfo.isHeader,
								currentQuestInfo.isCollapsed,
								currentQuestInfo.isComplete,
								currentQuestInfo.frequency,
								currentQuestInfo.questID,
								currentQuestInfo.startEvent,
								currentQuestInfo.displayQuestID,
								currentQuestInfo.isOnMap,
								currentQuestInfo.hasLocalPOI,
								currentQuestInfo.isTask,
								currentQuestInfo.isBounty,
								currentQuestInfo.isStory,
								currentQuestInfo.isHidden,
								currentQuestInfo.isScaling = GetQuestLogTitle(GetQuestLogIndexByID(questID))

								-- QUERY MISSING REFERENCES
								if currentQuestInfo.isOnQuest == nil then
									currentQuestInfo.isOnQuest = (IsOnQuest and IsOnQuest(questID)) or false
								end

								if not currentQuestInfo.isComplete then
									currentQuestInfo.isComplete = (IsReadyForTurnIn and IsReadyForTurnIn(questID)) or false
								end

								if QuestFrameAcceptButton:IsVisible() then
									currentQuestInfo.isComplete = false
								end
							end

							--------------------------------

							if questID then
								local QuestType = GetQuestTagInfo(questID)

								local IsAvailable = (QuestFrameAcceptButton:IsVisible() or IsAutoAccept())
								local IsCompleted = (((currentQuestInfo.isComplete) or (IsReadyForTurnIn and IsReadyForTurnIn(questID))) and not IsAvailable)
								local IsOnQuest = (((currentQuestInfo.isOnQuest) or (IsOnQuest and IsOnQuest(questID)) or questInfo.missingQuestID) and not IsAvailable)
								local IsRecurring = ((currentQuestInfo.frequency or 0) == (2)) -- 1 = Default, 2 = Daily, 3 = Weekly. Sometimes non-weekly quests get flagged as weekly by Blizzard?
								local IsDefault = (not IsRecurring)

								local IsGroup = (QuestType == 1)
								local IsPvP = (QuestType == 41)
								local IsRaid = (QuestType == 62)
								local IsDungeon = (QuestType == 81)
								local IsLegendary = (QuestType == 83)
								local IsHeroic = (QuestType == 85)
								local IsScenario = (QuestType == 98)
								local IsAccount = (QuestType == 102)
								local IsLeatherworkingWorldQuest = (QuestType == 117)

								--------------------------------

								if IsCompleted then
									if IsDefault then
										resultPath = "quest-complete"
									elseif IsRecurring then
										resultPath = "quest-recurring-complete"
									end
								elseif IsOnQuest then
									if IsDefault then
										resultPath = "quest-active"
									elseif IsRecurring then
										resultPath = "quest-recurring-active"
									end
								else
									if IsDefault then
										resultPath = "quest-available"
									elseif IsRecurring then
										resultPath = "quest-recurring-available"
									end
								end
							else
								if gossipButtonOptionTexture then
									local new = addon.ContextIcon.Script:ReplaceIcon(gossipButtonOptionTexture)
									resultPath = nil
									resultTexture = new
								end
							end

							--------------------------------

							if resultPath and not resultTexture then
								result = addon.ContextIcon.Script:ConvertToInlineIcon(resultPath)
								resultTexture = addon.Variables.PATH .. "Art/ContextIcons/" .. resultPath .. ".png"
							else
								-- print("Invalid Texture")
							end
						end

						if queryGossip then
							resultPath = "gossip-bubble"

							--------------------------------

							if resultPath then
								result = addon.ContextIcon.Script:ConvertToInlineIcon(resultPath)
								resultTexture = addon.Variables.PATH .. "Art/ContextIcons/" .. resultPath .. ".png"
							else
								-- print("Invalid Texture")
							end
						end
					end
				end

				--------------------------------

				return result, resultTexture
			end
		end
	end

	--------------------------------
	-- EVENTS
	--------------------------------

	--------------------------------
	-- SETUP
	--------------------------------
end
