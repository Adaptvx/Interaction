local addonName, addon = ...
local CallbackRegistry = addon.CallbackRegistry
local L = addon.Locales
local NS = addon.ContextIcon

--------------------------------

NS.Script = {}

--------------------------------

local function MissingAPI()
	return false
end

local function ReadyForTurnInMakeshiftAPI(questID)
	local result = false

	--------------------------------

	if IsQuestComplete(questID) then
		result = true
	else
		if QuestFrameCompleteQuestButton:IsVisible() or QuestFrameCompleteButton:IsVisible() and QuestFrameCompleteButton:IsEnabled() then
			result = true
		end
	end

	--------------------------------

	return result
end

--------------------------------

local IsOnQuest = C_QuestLog.IsOnQuest or MissingAPI
local IsReadyForTurnIn = C_QuestLog.ReadyForTurnIn or ReadyForTurnInMakeshiftAPI or MissingAPI
local IsAutoAccept = QuestGetAutoAccept or MissingAPI
local IsCampaign = C_CampaignInfo and C_CampaignInfo.IsCampaignQuest or MissingAPI
local IsLegendary = C_QuestLog.IsLegendaryQuest or MissingAPI
local IsImportant = C_QuestLog.IsImportantQuest or MissingAPI
local IsTrivial = C_QuestLog.IsQuestTrivial or MissingAPI
local IsMeta = C_QuestLog.IsMetaQuest or MissingAPI

local GetAvailableQuestInfo = GetAvailableQuestInfo or function() return false, 0, false, false, 0 end

local QUEST_FREQUENCY_DAILY = Enum.QuestFrequency.Daily
local QUEST_FREQUENCY_WEEKLY = Enum.QuestFrequency.Weekly
local QUEST_FREQUENCY_SCHEDULER = Enum.QuestFrequency.ResetByScheduler

if addon.Variables.IS_CLASSIC then
	QUEST_FREQUENCY_DAILY = 2
	QUEST_FREQUENCY_WEEKLY = 3
	QUEST_FREQUENCY_SCHEDULER = 999 -- Invalid
end

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

--------------------------------

function addon.ContextIcon.Script:Load()
	local DB = ICON_MAP

	--------------------------------
	-- FUNCTIONS
	--------------------------------

	function addon.ContextIcon.Script:ConvertToInlineIcon(name, isTexture)
		local iconPath = isTexture and name or (CONTEXT_ICON_PATH .. name .. ".png")
		return AdaptiveAPI:InlineIcon(iconPath, 16, 16, 0, 0)
	end

	--------------------------------

	function addon.ContextIcon.Script:ReplaceIcon(texture)
		local Result

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

	--------------------------------

	function addon.ContextIcon.Script:GetContextIcon(GossipButtonIndex)
		local IS_CLASSIC_ERA = addon.Variables.IS_CLASSIC_ERA
		local IS_CLASSIC = addon.Variables.IS_CLASSIC and not addon.Variables.IS_CLASSIC_ERA
		local IS_MODERN_WOW = not addon.Variables.IS_CLASSIC and not addon.Variables.IS_CLASSIC_ERA

		local IS_GOSSIP = (GossipFrame:IsVisible() or QuestFrameGreetingPanel:IsVisible())
		local IS_QUEST = (QuestFrame:IsVisible() and not QuestFrameGreetingPanel:IsVisible())

		local QUERY_QUEST = (GossipButtonIndex ~= nil or IS_QUEST)
		local QUERY_GOSSIP = (not QUERY_QUEST)

		--------------------------------

		local Result
		local ResultTexture

		--------------------------------

		if IS_MODERN_WOW then
			--------------------------------

			local ResultPath

			--------------------------------

			if QUERY_QUEST then
				local QuestID

				--------------------------------

				if GossipButtonIndex then
					local QuestInfo = {}

					local QuestFrameGreetingPanel_NumAvailableQuests = (GetNumAvailableQuests())
					local GossipFrame_NumAvailableQuests = (C_GossipInfo.GetNumAvailableQuests())

					local QuestFrameGreetingPanel_NumActiveQuests = (GetNumActiveQuests())
					local GossipFrame_NumActiveQuests = (C_GossipInfo.GetNumActiveQuests())

					if QuestFrameGreetingPanel_NumAvailableQuests >= 1 or GossipFrame_NumAvailableQuests >= 1 then
						if QuestFrameGreetingPanel_NumAvailableQuests >= 1 then
							for i = 1, QuestFrameGreetingPanel_NumAvailableQuests do
								local isTrivial, frequency, isRepeatable, isLegendary, questID, isImportant = GetAvailableQuestInfo(i)
								local questInfo = {
									isTrivial = isTrivial,
									frequency = frequency,
									isRepeatable = isRepeatable,
									isLegendary = isLegendary,
									questID = questID,
									isImportant = isImportant
								}
								table.insert(QuestInfo, questInfo)
							end
						end

						if GossipFrame_NumAvailableQuests >= 1 then
							for i = 1, GossipFrame_NumAvailableQuests do
								table.insert(QuestInfo, C_GossipInfo.GetAvailableQuests()[i])
							end
						end
					end

					if QuestFrameGreetingPanel_NumActiveQuests >= 1 or GossipFrame_NumActiveQuests >= 1 then
						if QuestFrameGreetingPanel_NumActiveQuests >= 1 then
							for i = 1, QuestFrameGreetingPanel_NumActiveQuests do
								local questInfo = {
									questID = GetActiveQuestID(i),
								}
								table.insert(QuestInfo, questInfo)
							end
						end

						if GossipFrame_NumActiveQuests >= 1 then
							for i = 1, GossipFrame_NumActiveQuests do
								table.insert(QuestInfo, C_GossipInfo.GetActiveQuests()[i])
							end
						end
					end

					QuestID = (GossipButtonIndex and (QuestInfo and #QuestInfo >= GossipButtonIndex and QuestInfo[GossipButtonIndex].questID)) or nil
				else
					QuestID = GetQuestID()
				end

				--------------------------------

				if QuestID then
					local QuestClassification = C_QuestInfoSystem.GetQuestClassification(QuestID)
					local QuestType = C_QuestLog.GetQuestType(QuestID)

					local IsAvailable = (QuestFrameAcceptButton:IsVisible() or IsAutoAccept())
					local IsCompleted = (IsReadyForTurnIn(QuestID) and not IsAvailable)
					local IsOnQuest = (C_QuestLog.IsOnQuest(QuestID) and not IsAvailable)
					local IsDefault = (QuestClassification == Enum.QuestClassification.Normal)
					local IsImportant = (QuestClassification == Enum.QuestClassification.Important)
					local IsCampaign = (QuestClassification == Enum.QuestClassification.Campaign)
					local IsLegendary = (QuestClassification == Enum.QuestClassification.Legendary)
					local IsCalling = (QuestClassification == Enum.QuestClassification.Calling)
					local IsMeta = (QuestClassification == Enum.QuestClassification.Meta)
					local IsRecurring = (QuestClassification == Enum.QuestClassification.Recurring)
					local IsRepeatable = (C_QuestLog.IsQuestRepeatableType(QuestID))

					local IsAccount = (QuestType == Enum.QuestTag.Account)
					local IsCombatAlly = (QuestType == Enum.QuestTag.CombatAlly)
					local IsDelve = (QuestType == Enum.QuestTag.Delve)
					local IsDungeon = (QuestType == Enum.QuestTag.Dungeon)
					local IsGroup = (QuestType == Enum.QuestTag.Group)
					local IsHeroic = (QuestType == Enum.QuestTag.Heroic)
					local IsLegendary = (QuestType == Enum.QuestTag.Legendary)
					local IsPvP = (QuestType == Enum.QuestTag.PvP)
					local IsRaid = (QuestType == Enum.QuestTag.Raid)
					local IsRaid10 = (QuestType == Enum.QuestTag.Raid10)
					local IsRaid25 = (QuestType == Enum.QuestTag.Raid25)
					local IsScenario = (QuestType == Enum.QuestTag.Scenario)

					--------------------------------

					if IsCompleted then
						if IsDefault then
							ResultPath = "quest-complete"
						elseif IsImportant then
							ResultPath = "quest-important-complete"
						elseif IsCampaign then
							ResultPath = "quest-campaign-complete"
						elseif IsLegendary then
							ResultPath = "quest-legendary-complete"
						elseif IsCalling then
							ResultPath = "quest-calling-complete"
						elseif IsMeta then
							ResultPath = "quest-meta-complete"
						elseif IsRecurring then
							ResultPath = "quest-recurring-complete"
						elseif IsRepeatable then
							ResultPath = "quest-repeatable-complete"
						end
					elseif IsOnQuest then
						if IsDefault then
							ResultPath = "quest-active"
						elseif IsImportant then
							ResultPath = "quest-important-active"
						elseif IsCampaign then
							ResultPath = "quest-campaign-active"
						elseif IsLegendary then
							ResultPath = "quest-legendary-active"
						elseif IsCalling then
							ResultPath = "quest-calling-active"
						elseif IsMeta then
							ResultPath = "quest-meta-active"
						elseif IsRecurring then
							ResultPath = "quest-recurring-active"
						elseif IsRepeatable then
							ResultPath = "quest-repeatable-active"
						end
					else
						if IsDefault then
							ResultPath = "quest-available"
						elseif IsImportant then
							ResultPath = "quest-important-available"
						elseif IsCampaign then
							ResultPath = "quest-campaign-available"
						elseif IsLegendary then
							ResultPath = "quest-legendary-available"
						elseif IsCalling then
							ResultPath = "quest-calling-available"
						elseif IsMeta then
							ResultPath = "quest-meta-available"
						elseif IsRecurring then
							ResultPath = "quest-recurring-available"
						elseif IsRepeatable then
							ResultPath = "quest-repeatable-available"
						end
					end
				else
					-- print("Invalid Texture")
				end

				-- elseif GossipButtonIndex then
				--     ResultPath = "gossip-bubble"
				-- end

				--------------------------------

				if ResultPath then
					Result = addon.ContextIcon.Script:ConvertToInlineIcon(ResultPath)
					ResultTexture = addon.Variables.PATH .. "Art/ContextIcons/" .. ResultPath .. ".png"
				else
					-- print("Invalid Texture")
				end
			end

			if QUERY_GOSSIP then
				ResultPath = "gossip-bubble"

				--------------------------------

				if ResultPath then
					Result = addon.ContextIcon.Script:ConvertToInlineIcon(ResultPath)
					ResultTexture = addon.Variables.PATH .. "Art/ContextIcons/" .. ResultPath .. ".png"
				else
					-- print("Invalid Texture")
				end
			end
		end

		if IS_CLASSIC then
			local ResultPath

			--------------------------------

			local QuestID = nil
			local QuestInfo = {}
			local CurrentQuestInfo = {}

			--------------------------------

			if QUERY_QUEST then
				--------------------------------

				local QuestID

				--------------------------------

				if GossipButtonIndex then
					local QuestInfo = {}

					--------------------------------

					local QuestFrameGreetingPanel_NumAvailableQuests = (GetNumAvailableQuests())
					local GossipFrame_NumAvailableQuests = (C_GossipInfo.GetNumAvailableQuests())

					local QuestFrameGreetingPanel_NumActiveQuests = (GetNumActiveQuests())
					local GossipFrame_NumActiveQuests = (C_GossipInfo.GetNumActiveQuests())

					--------------------------------

					if QuestFrameGreetingPanel_NumAvailableQuests >= 1 or GossipFrame_NumAvailableQuests >= 1 then
						if QuestFrameGreetingPanel_NumAvailableQuests >= 1 then
							for i = 1, QuestFrameGreetingPanel_NumAvailableQuests do
								local isTrivial, frequency, isRepeatable, isLegendary, questID, isImportant = GetAvailableQuestInfo(i)
								local questInfo = {
									isTrivial = isTrivial,
									frequency = frequency,
									isRepeatable = isRepeatable,
									isLegendary = isLegendary,
									questID = questID,
									isImportant = isImportant
								}
								table.insert(QuestInfo, questInfo)
							end
						end

						if GossipFrame_NumAvailableQuests >= 1 then
							for i = 1, GossipFrame_NumAvailableQuests do
								table.insert(QuestInfo, C_GossipInfo.GetAvailableQuests()[i])
							end
						end
					end

					if QuestFrameGreetingPanel_NumActiveQuests >= 1 or GossipFrame_NumActiveQuests >= 1 then
						if QuestFrameGreetingPanel_NumActiveQuests >= 1 then
							for i = 1, QuestFrameGreetingPanel_NumActiveQuests do
								local questInfo = {
                                    questID = GetActiveQuestID and GetActiveQuestID(i),
									missingQuestID = (not GetActiveQuestID)
								}
								table.insert(QuestInfo, questInfo)
							end
						end

						if GossipFrame_NumActiveQuests >= 1 then
							for i = 1, GossipFrame_NumActiveQuests do
								table.insert(QuestInfo, C_GossipInfo.GetActiveQuests()[i])
							end
						end
					end

					--------------------------------

					QuestID = (GossipButtonIndex and (QuestInfo and #QuestInfo >= GossipButtonIndex and QuestInfo[GossipButtonIndex].questID)) or nil
				else
					-- QUEST ID
					QuestID = GetQuestID()

					-- FILL DATA
					CurrentQuestInfo.title,
					CurrentQuestInfo.level,
					CurrentQuestInfo.suggestedGroup,
					CurrentQuestInfo.isHeader,
					CurrentQuestInfo.isCollapsed,
					CurrentQuestInfo.isComplete,
					CurrentQuestInfo.frequency,
					CurrentQuestInfo.questID,
					CurrentQuestInfo.startEvent,
					CurrentQuestInfo.displayQuestID,
					CurrentQuestInfo.isOnMap,
					CurrentQuestInfo.hasLocalPOI,
					CurrentQuestInfo.isTask,
					CurrentQuestInfo.isBounty,
					CurrentQuestInfo.isStory,
					CurrentQuestInfo.isHidden,
					CurrentQuestInfo.isScaling = GetQuestLogTitle(GetQuestLogIndexByID(QuestID))

					-- QUERY MISSING REFERENCES
					if CurrentQuestInfo.isOnQuest == nil then
						CurrentQuestInfo.isOnQuest = (IsOnQuest and IsOnQuest(QuestID)) or false
					end

					if not CurrentQuestInfo.isComplete then
						CurrentQuestInfo.isComplete = (IsReadyForTurnIn and IsReadyForTurnIn(QuestID)) or false
					end

					if QuestFrameAcceptButton:IsVisible() then
						CurrentQuestInfo.isComplete = false
					end
				end

				--------------------------------

				if QuestID then
					local QuestType = GetQuestTagInfo(QuestID)

					local IsAvailable = (QuestFrameAcceptButton:IsVisible() or IsAutoAccept())
					local IsCompleted = (((CurrentQuestInfo.isComplete) or (IsReadyForTurnIn and IsReadyForTurnIn(QuestID))) and not IsAvailable)
					local IsOnQuest = (((CurrentQuestInfo.isOnQuest) or (IsOnQuest and IsOnQuest(QuestID)) or QuestInfo.missingQuestID) and not IsAvailable)
					local IsRecurring = ((CurrentQuestInfo.frequency or 0) == (2)) -- 1 = Default, 2 = Daily, 3 = Weekly. Sometimes non-weekly quests get flagged as weekly by Blizzard?
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
							ResultPath = "quest-complete"
						elseif IsRecurring then
							ResultPath = "quest-recurring-complete"
						end
					elseif IsOnQuest then
						if IsDefault then
							ResultPath = "quest-active"
						elseif IsRecurring then
							ResultPath = "quest-recurring-active"
						end
					else
						if IsDefault then
							ResultPath = "quest-available"
						elseif IsRecurring then
							ResultPath = "quest-recurring-available"
						end
					end
				else
					-- print("Invalid Texture")
				end

				--------------------------------

				if ResultPath then
					Result = addon.ContextIcon.Script:ConvertToInlineIcon(ResultPath)
					ResultTexture = addon.Variables.PATH .. "Art/ContextIcons/" .. ResultPath .. ".png"
				else
					-- print("Invalid Texture")
				end
			end

			if QUERY_GOSSIP then
				ResultPath = "gossip-bubble"

				--------------------------------

				if ResultPath then
					Result = addon.ContextIcon.Script:ConvertToInlineIcon(ResultPath)
					ResultTexture = addon.Variables.PATH .. "Art/ContextIcons/" .. ResultPath .. ".png"
				else
					-- print("Invalid Texture")
				end
			end
		end

		if IS_CLASSIC_ERA then
			local ResultPath

			--------------------------------

			local QuestID = nil
			local QuestInfo = {}
			local CurrentQuestInfo = {}

			--------------------------------

			if QUERY_QUEST then
				--------------------------------

				local QuestID

				--------------------------------

				if GossipButtonIndex then
					local QuestInfo = {}

					--------------------------------

					local QuestFrameGreetingPanel_NumAvailableQuests = (GetNumAvailableQuests())
					local GossipFrame_NumAvailableQuests = (C_GossipInfo.GetNumAvailableQuests())

					local QuestFrameGreetingPanel_NumActiveQuests = (GetNumActiveQuests())
					local GossipFrame_NumActiveQuests = (C_GossipInfo.GetNumActiveQuests())

					--------------------------------

					if QuestFrameGreetingPanel_NumAvailableQuests >= 1 or GossipFrame_NumAvailableQuests >= 1 then
						if QuestFrameGreetingPanel_NumAvailableQuests >= 1 then
							for i = 1, QuestFrameGreetingPanel_NumAvailableQuests do
								local isTrivial, frequency, isRepeatable, isLegendary, questID, isImportant = GetAvailableQuestInfo(i)
								local questInfo = {
									isTrivial = isTrivial,
									frequency = frequency,
									isRepeatable = isRepeatable,
									isLegendary = isLegendary,
									questID = questID,
									isImportant = isImportant
								}
								table.insert(QuestInfo, questInfo)
							end
						end

						if GossipFrame_NumAvailableQuests >= 1 then
							for i = 1, GossipFrame_NumAvailableQuests do
								table.insert(QuestInfo, C_GossipInfo.GetAvailableQuests()[i])
							end
						end
					end

					if QuestFrameGreetingPanel_NumActiveQuests >= 1 or GossipFrame_NumActiveQuests >= 1 then
						if QuestFrameGreetingPanel_NumActiveQuests >= 1 then
							for i = 1, QuestFrameGreetingPanel_NumActiveQuests do
								local questInfo = {
                                    questID = GetActiveQuestID and GetActiveQuestID(i),
									missingQuestID = (not GetActiveQuestID)
								}
								table.insert(QuestInfo, questInfo)
							end
						end

						if GossipFrame_NumActiveQuests >= 1 then
							for i = 1, GossipFrame_NumActiveQuests do
								table.insert(QuestInfo, C_GossipInfo.GetActiveQuests()[i])
							end
						end
					end

					--------------------------------

					QuestID = (GossipButtonIndex and (QuestInfo and #QuestInfo >= GossipButtonIndex and QuestInfo[GossipButtonIndex].questID)) or nil
				else
					-- QUEST ID
					QuestID = GetQuestID()

					-- FILL DATA
					CurrentQuestInfo.title,
					CurrentQuestInfo.level,
					CurrentQuestInfo.suggestedGroup,
					CurrentQuestInfo.isHeader,
					CurrentQuestInfo.isCollapsed,
					CurrentQuestInfo.isComplete,
					CurrentQuestInfo.frequency,
					CurrentQuestInfo.questID,
					CurrentQuestInfo.startEvent,
					CurrentQuestInfo.displayQuestID,
					CurrentQuestInfo.isOnMap,
					CurrentQuestInfo.hasLocalPOI,
					CurrentQuestInfo.isTask,
					CurrentQuestInfo.isBounty,
					CurrentQuestInfo.isStory,
					CurrentQuestInfo.isHidden,
					CurrentQuestInfo.isScaling = GetQuestLogTitle(GetQuestLogIndexByID(QuestID))

					-- QUERY MISSING REFERENCES
					if CurrentQuestInfo.isOnQuest == nil then
						CurrentQuestInfo.isOnQuest = (IsOnQuest and IsOnQuest(QuestID)) or false
					end

					if not CurrentQuestInfo.isComplete then
						CurrentQuestInfo.isComplete = (IsReadyForTurnIn and IsReadyForTurnIn(QuestID)) or false
					end

					if QuestFrameAcceptButton:IsVisible() then
						CurrentQuestInfo.isComplete = false
					end
				end

				--------------------------------

				if QuestID then
					local QuestType = GetQuestTagInfo(QuestID)

					local IsAvailable = (QuestFrameAcceptButton:IsVisible() or IsAutoAccept())
					local IsCompleted = (((CurrentQuestInfo.isComplete) or (IsReadyForTurnIn and IsReadyForTurnIn(QuestID))) and not IsAvailable)
					local IsOnQuest = (((CurrentQuestInfo.isOnQuest) or (IsOnQuest and IsOnQuest(QuestID)) or QuestInfo.missingQuestID) and not IsAvailable)
					local IsRecurring = ((CurrentQuestInfo.frequency or 0) == (2)) -- 1 = Default, 2 = Daily, 3 = Weekly. Sometimes non-weekly quests get flagged as weekly by Blizzard?
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
							ResultPath = "quest-complete"
						elseif IsRecurring then
							ResultPath = "quest-recurring-complete"
						end
					elseif IsOnQuest then
						if IsDefault then
							ResultPath = "quest-active"
						elseif IsRecurring then
							ResultPath = "quest-recurring-active"
						end
					else
						if IsDefault then
							ResultPath = "quest-available"
						elseif IsRecurring then
							ResultPath = "quest-recurring-available"
						end
					end
				else
					-- print("Invalid Texture")
				end

				--------------------------------

				if ResultPath then
					Result = addon.ContextIcon.Script:ConvertToInlineIcon(ResultPath)
					ResultTexture = addon.Variables.PATH .. "Art/ContextIcons/" .. ResultPath .. ".png"
				else
					-- print("Invalid Texture")
				end
			end

			if QUERY_GOSSIP then
				ResultPath = "gossip-bubble"

				--------------------------------

				if ResultPath then
					Result = addon.ContextIcon.Script:ConvertToInlineIcon(ResultPath)
					ResultTexture = addon.Variables.PATH .. "Art/ContextIcons/" .. ResultPath .. ".png"
				else
					-- print("Invalid Texture")
				end
			end
		end

		--------------------------------

		return Result, ResultTexture
	end

	--------------------------------
	-- EVENTS
	--------------------------------

	--------------------------------
	-- SETUP
	--------------------------------
end
