local addon = select(2, ...)
addon.ContextIcon = {}
local NS = addon.ContextIcon


local PATH = addon.Variables.PATH_ART .. "ContextIcons\\"
local ICON_MAP = {
	["132053"] = "Gossip",

	["132048"] = "CompleteQuest",
	["132049"] = "AvailableQuest",
	["-1746"] = "AvailableQuest", -- Cata classic bug?

	["136788"] = "AvailableQuest",

	["importantactivequesticon"] = "CompleteImportantQuest",
	["importantavailablequesticon"] = "AvailableImportantQuest",
	["importantincompletequesticon"] = "IncompleteImportantQuest",

	["Recurringactivequesticon"] = "CompleteRecurringQuest",
	["Recurringavailablequesticon"] = "AvailableRecurringQuest",
	["Recurringincompletequesticon"] = "IncompleteRecurringQuest",

	["Repeatableactivequesticon"] = "CompleteRepeatableQuest",
	["Repeatableavailablequesticon"] = "AvailableRepeatableQuest",
	["Repeatableicnompletequesticon"] = "IncompleteRepeatableQuest",

	["CampaignActiveQuestIcon"] = "CompleteCampaignQuest",
	["CampaignAvailableQuestIcon"] = "AvailableCampaignQuest",
	["CampaignIncompleteQuestIcon"] = "IncompleteCampaignQuest",
	["CampaignActiveDailyQuestIcon"] = "CompleteCallingQuest",
	["CampaignAvailableDailyQuestIcon"] = "AvailableCallingQuest",

	["Wrapperactivequesticon"] = "CompleteMetaQuest",
	["Wrapperavailablequesticon"] = "AvailableMetaQuest",
	["Wrapperincompletequesticon"] = "IncompleteMetaQuest",

	["legendaryactivequesticon"] = "CompleteLegendaryQuest",
	["legendaryavailablequesticon"] = "AvailableLegendaryQuest",
	["legendaryincompletequesticon"] = "IncompleteLegendaryQuest",

	["CampaignInProgressQuestIcon"] = "IncompleteCampaignQuest",
	["RepeatableInProgressquesticon"] = "IncompleteRecurringQuest",
	["SideInProgressquesticon"] = "IncompleteQuest",
	["importantInProgressquesticon"] = "IncompleteImportantQuest",
	["WrapperInProgressquesticon"] = "IncompleteMetaQuest",
	["legendaryInProgressquesticon"] = "IncompleteLegendaryQuest",
}
local IS_RETAIL = addon.Variables.IS_WOW_VERSION_RETAIL
local IS_CLASSIC_ALL = addon.Variables.IS_WOW_VERSION_CLASSIC_ALL
local IS_CLASSIC_PROGRESSION = addon.Variables.IS_WOW_VERSION_CLASSIC_PROGRESSION
local IS_CLASSIC_ERA = addon.Variables.IS_WOW_VERSION_CLASSIC_ERA


local IsQuestComplete = IsQuestComplete
local function ReadyForTurnInMakeshiftAPI(questID)
	local result = false
	if (IS_RETAIL and IsQuestComplete(questID)) or (not IS_RETAIL and IsQuestComplete(questID)) then
		result = true
	else
		if QuestFrameCompleteQuestButton:IsVisible() or QuestFrameCompleteButton:IsVisible() and QuestFrameCompleteButton:IsEnabled() then
			result = true
		end
	end
	return result
end
local GetQuestClassification = C_QuestInfoSystem.GetQuestClassification
local GetQuestType = C_QuestLog.GetQuestType
local GetQuestTagInfo = C_QuestLog and C_QuestLog.GetQuestTagInfo or GetQuestTagInfo
local GetQuestLogTitle = GetQuestLogTitle
local GetQuestLogIndexByID = GetQuestLogIndexByID
local IsRepeatableQuest = C_QuestLog.IsRepeatableQuest
local IsOnQuest = C_QuestLog.IsOnQuest
local IsReadyForTurnIn = C_QuestLog.ReadyForTurnIn or ReadyForTurnInMakeshiftAPI
local IsAutoAccept = addon.API.Main.IsAutoAccept
local pairs, ipairs = pairs, ipairs
local tostring = tostring



function NS:Load()
	do -- Util

		function NS:ConvertToInlineIcon(iconName, isTexture)
			local iconPath = isTexture and iconName or (PATH .. iconName .. ".png")
			return addon.API.Util:InlineIcon(iconPath, 16, 16, 0, 0)
		end
	end

	do -- Replacement

		function NS:ReplaceIcon(texture)
			local result = texture
			for k, v in pairs(ICON_MAP) do
				if tostring(texture) == tostring(k) then
					result = PATH .. v .. ".png"
					break
				end
			end
			return result
		end
	end

	do -- Get
		local function GetRetailQuestInfo(questID)
			local questClassification = GetQuestClassification(questID)
			local questType           = GetQuestType(questID)

			local isAvailable         = (QuestFrameAcceptButton:IsVisible() or IsAutoAccept())
			local isCompleted         = (IsReadyForTurnIn(questID)) and not isAvailable
			local isOnQuest           = (IsOnQuest(questID) and not isAvailable)
			local isDefault           = (questClassification == Enum.QuestClassification.Normal)
			local isImportant         = (questClassification == Enum.QuestClassification.Important)
			local isCampaign          = (questClassification == Enum.QuestClassification.Campaign)
			local isCalling           = (questClassification == Enum.QuestClassification.Calling)
			local isMeta              = (questClassification == Enum.QuestClassification.Meta)
			local isRecurring         = (questClassification == Enum.QuestClassification.Recurring)
			local isRepeatable        = (IsRepeatableQuest(questID))

			local isAccount           = (questType == Enum.QuestTag.Account)
			local isCombatAlly        = (questType == Enum.QuestTag.CombatAlly)
			local isDelve             = (questType == Enum.QuestTag.Delve)
			local isDungeon           = (questType == Enum.QuestTag.Dungeon)
			local isGroup             = (questType == Enum.QuestTag.Group)
			local isHeroic            = (questType == Enum.QuestTag.Heroic)
			local isLegendary         = (questClassification == Enum.QuestClassification.Legendary or questType == Enum.QuestTag.Legendary)
			local isArtifact          = (questType == 107) -- Artifact
			local isPvP               = (questType == Enum.QuestTag.PvP)
			local isRaid              = (questType == Enum.QuestTag.Raid)
			local isRaid10            = (questType == Enum.QuestTag.Raid10)
			local isRaid25            = (questType == Enum.QuestTag.Raid25)
			local isScenario          = (questType == Enum.QuestTag.Scenario)

			return {
				isAvailable  = isAvailable,
				isCompleted  = isCompleted,
				isOnQuest    = isOnQuest,
				isDefault    = isDefault,
				isImportant  = isImportant,
				isCampaign   = isCampaign,
				isCalling    = isCalling,
				isMeta       = isMeta,
				isRecurring  = isRecurring,
				isRepeatable = isRepeatable,
				isAccount    = isAccount,
				isCombatAlly = isCombatAlly,
				isDelve      = isDelve,
				isDungeon    = isDungeon,
				isGroup      = isGroup,
				isHeroic     = isHeroic,
				isLegendary  = isLegendary,
				isArtifact   = isArtifact,
				isPvP        = isPvP,
				isRaid       = isRaid,
				isRaid10     = isRaid10,
				isRaid25     = isRaid25,
				isScenario   = isScenario,
			}
		end

		local FREQUENCY_NORMAL = 0
		local FREQUENCY_DAILY = 1
		local FREQUENCY_WEEKLY = 2

		local function GetClassicQuestInfo(questID, gossipButtonInfo)
			local questInfo = {}

			if gossipButtonInfo then
				questInfo = { GetQuestLogTitle(GetQuestLogIndexByID(questID)) }

				questInfo.isComplete = (gossipButtonInfo.isComplete or questInfo.isComplete)
				questInfo.isOnQuest = (gossipButtonInfo.isOnQuest or false)
				questInfo.frequency = gossipButtonInfo.frequency
			else
				questInfo = { GetQuestLogTitle(GetQuestLogIndexByID(questID)) }

				if questInfo.isOnQuest == nil then questInfo.isOnQuest = (IsOnQuest and IsOnQuest(questID)) or false end
				if questInfo.frequency == nil then questInfo.frequency = 0 end
				if not questInfo.isComplete then questInfo.isComplete = (IsReadyForTurnIn and IsReadyForTurnIn(questID)) or false end
				if QuestFrameAcceptButton:IsVisible() then questInfo.isComplete = false end
			end

			local questType                  = GetQuestTagInfo(questID)
			local isAvailable                = (QuestFrameAcceptButton:IsVisible() or IsAutoAccept())
			local isCompleted                = (((questInfo.isComplete) or (IsReadyForTurnIn and IsReadyForTurnIn(questID))) and not isAvailable)
			local isOnQuest                  = (((questInfo.isOnQuest) or (IsOnQuest and IsOnQuest(questID)) or questInfo.missingQuestID) and not isAvailable)
			local isRecurring                = (questInfo.frequency == FREQUENCY_DAILY or questInfo.frequency == FREQUENCY_WEEKLY)
			local isRecurringWeekly          = (questInfo.frequency == FREQUENCY_WEEKLY)
			local isDefault                  = (not isRecurring)

			local isGroup                    = (questType == 1)
			local isPvP                      = (questType == 41)
			local isRaid                     = (questType == 62)
			local isDungeon                  = (questType == 81)
			local isLegendary                = (questType == 83)
			local isHeroic                   = (questType == 85)
			local isScenario                 = (questType == 98)
			local isAccount                  = (questType == 102)
			local isLeatherworkingWorldQuest = (questType == 117)

			return {
				isAvailable = isAvailable,
				isCompleted = isCompleted,
				isOnQuest = isOnQuest,
				isRecurring = isRecurring,
				isRecurringWeekly = isRecurringWeekly,
				isDefault = isDefault,
				isGroup = isGroup,
				isPvP = isPvP,
				isRaid = isRaid,
				isDungeon = isDungeon,
				isLegendary = isLegendary,
				isHeroic = isHeroic,
				isScenario = isScenario,
				isAccount = isAccount,
				isLeatherworkingWorldQuest = isLeatherworkingWorldQuest,
			}
		end

		function NS:GetQuestInfo(questID, gossipButtonInfo)
			return IS_RETAIL and GetRetailQuestInfo(questID) or GetClassicQuestInfo(questID, gossipButtonInfo)
		end

		function NS:GetContextIcon(gossipButtonInfo, gossipButtonOptionTexture)
			local isQuest = (QuestFrame:IsVisible() and not QuestFrameGreetingPanel:IsVisible())

			local queryQuest = (gossipButtonInfo ~= nil or isQuest)
			local queryGossip = (not queryQuest)


			local result
			local resultTexture

			do -- Retail
				if IS_RETAIL then
					local resultPath

					if queryQuest then
						local questID

						if gossipButtonInfo then
							questID = gossipButtonInfo.questID or nil
						else
							questID = GetQuestID()
						end

						if questID then
							local questInfo = NS:GetQuestInfo(questID)
							local isAvailable, isCompleted, isOnQuest, isDefault, isImportant,
							isCampaign, isCalling, isMeta, isRecurring, isRepeatable, isAccount,
							isCombatAlly, isDelve, isDungeon, isGroup, isHeroic, isLegendary, isArtifact,
							isPvP, isRaid, isRaid10, isRaid25, isScenario =
								questInfo.isAvailable, questInfo.isCompleted, questInfo.isOnQuest, questInfo.isDefault, questInfo.isImportant,
								questInfo.isCampaign, questInfo.isCalling, questInfo.isMeta, questInfo.isRecurring, questInfo.isRepeatable, questInfo.isAccount,
								questInfo.isCombatAlly, questInfo.isDelve, questInfo.isDungeon, questInfo.isGroup, questInfo.isHeroic, questInfo.isLegendary, questInfo.isArtifact,
								questInfo.isPvP, questInfo.isRaid, questInfo.isRaid10, questInfo.isRaid25, questInfo.isScenario


							if isCompleted then
								if isDefault then
									resultPath = "CompleteQuest"
								elseif isImportant then
									resultPath = "CompleteImportantQuest"
								elseif isCampaign then
									resultPath = "CompleteCampaignQuest"
								elseif isLegendary then
									resultPath = "CompleteLegendaryQuest"
								elseif isArtifact then
									resultPath = "CompleteLegendaryQuest"
								elseif isCalling then
									resultPath = "CompleteCallingQuest"
								elseif isMeta then
									resultPath = "CompleteMetaQuest"
								elseif isRecurring then
									resultPath = "CompleteRecurringQuest"
								elseif isRepeatable then
									resultPath = "CompleteRepeatableQuest"
								end
							elseif isOnQuest then
								if isDefault then
									resultPath = "IncompleteQuest"
								elseif isImportant then
									resultPath = "IncompleteImportantQuest"
								elseif isCampaign then
									resultPath = "IncompleteCampaignQuest"
								elseif isLegendary then
									resultPath = "IncompleteLegendaryQuest"
								elseif isArtifact then
									resultPath = "IncompleteLegendaryQuest"
								elseif isCalling then
									resultPath = "IncompleteCallingQuest"
								elseif isMeta then
									resultPath = "IncompleteMetaQuest"
								elseif isRecurring then
									resultPath = "IncompleteRecurringQuest"
								elseif isRepeatable then
									resultPath = "IncompleteRepeatableQuest"
								end
							else
								if isDefault then
									resultPath = "AvailableQuest"
								elseif isImportant then
									resultPath = "AvailableImportantQuest"
								elseif isCampaign then
									resultPath = "AvailableCampaignQuest"
								elseif isLegendary then
									resultPath = "AvailableLegendaryQuest"
								elseif isArtifact then
									resultPath = "AvailableLegendaryQuest"
								elseif isCalling then
									resultPath = "AvailableCallingQuest"
								elseif isMeta then
									resultPath = "AvailableMetaQuest"
								elseif isRecurring then
									resultPath = "AvailableRecurringQuest"
								elseif isRepeatable then
									resultPath = "AvailableRepeatableQuest"
								end
							end
						else
							if gossipButtonOptionTexture then
								local new = NS:ReplaceIcon(gossipButtonOptionTexture)
								resultPath = nil
								resultTexture = new
							end
						end


						if resultPath and not resultTexture then
							result = NS:ConvertToInlineIcon(resultPath)
							resultTexture = addon.Variables.PATH_ART .. "ContextIcons\\" .. resultPath .. ".png"
						else
						end
					end

					if queryGossip then
						resultPath = "Gossip"


						if resultPath then
							result = NS:ConvertToInlineIcon(resultPath)
							resultTexture = addon.Variables.PATH_ART .. "ContextIcons\\" .. resultPath .. ".png"
						else
						end
					end
				end
			end

			do -- Classic mop
				if IS_CLASSIC_PROGRESSION then
					local resultPath


					if queryQuest then
						local questID; if gossipButtonInfo then questID = gossipButtonInfo.questID or nil else questID = GetQuestID() end


						if questID then
							local questInfo = NS:GetQuestInfo(questID, gossipButtonInfo)
							local isAvailable, isCompleted, isOnQuest, isDefault,
							isRecurring, isRecurringWeekly, isGroup, isPvP, isRaid, isDungeon, isLegendary,
							isHeroic, isScenario, isAccount, isLeatherworkingWorldQuest =
								questInfo.isAvailable, questInfo.isCompleted, questInfo.isOnQuest, questInfo.isDefault,
								questInfo.isRecurring, questInfo.isRecurringWeekly, questInfo.isGroup, questInfo.isPvP, questInfo.isRaid, questInfo.isDungeon, questInfo.isLegendary,
								questInfo.isHeroic, questInfo.isScenario, questInfo.isAccount, questInfo.isLeatherworkingWorldQuest


							if isCompleted then
								if isDefault then
									resultPath = "CompleteQuest"
								elseif isRecurring then
									if isRecurringWeekly then
										resultPath = "CompleteWeeklyQuest"
									else
										resultPath = "CompleteRepeatableQuest"
									end
								end
							elseif isOnQuest then
								if isDefault then
									resultPath = "IncompleteQuest"
								elseif isRecurring then
									if isRecurringWeekly then
										resultPath = "IncompleteWeeklyQuest"
									else
										resultPath = "IncompleteRepeatableQuest"
									end
								end
							else
								if isDefault then
									resultPath = "AvailableQuest"
								elseif isRecurring then
									if isRecurringWeekly then
										resultPath = "AvailableWeeklyQuest"
									else
										resultPath = "AvailableRepeatableQuest"
									end
								end
							end
						else
							if gossipButtonOptionTexture then
								local new = NS:ReplaceIcon(gossipButtonOptionTexture)
								resultPath = nil
								resultTexture = new
							end
						end


						if resultPath and not resultTexture then
							result = NS:ConvertToInlineIcon(resultPath)
							resultTexture = addon.Variables.PATH_ART .. "ContextIcons\\" .. resultPath .. ".png"
						else
						end
					end

					if queryGossip then
						resultPath = "Gossip"


						if resultPath then
							result = NS:ConvertToInlineIcon(resultPath)
							resultTexture = addon.Variables.PATH_ART .. "ContextIcons\\" .. resultPath .. ".png"
						else
						end
					end
				end
			end

			do -- Classic era
				if IS_CLASSIC_ERA then
					local resultPath


					if queryQuest then
						local questID; if gossipButtonInfo then questID = gossipButtonInfo.questID or nil else questID = GetQuestID() end


						if questID then
							local questInfo = NS:GetQuestInfo(questID, gossipButtonInfo)
							local isAvailable, isCompleted, isOnQuest, isDefault,
							isRecurring, isGroup, isPvP, isRaid, isDungeon, isLegendary,
							isHeroic, isScenario, isAccount, isLeatherworkingWorldQuest =
								questInfo.isAvailable, questInfo.isCompleted, questInfo.isOnQuest, questInfo.isDefault,
								questInfo.isRecurring, questInfo.isGroup, questInfo.isPvP, questInfo.isRaid, questInfo.isDungeon, questInfo.isLegendary,
								questInfo.isHeroic, questInfo.isScenario, questInfo.isAccount, questInfo.isLeatherworkingWorldQuest


							if isCompleted then
								if isDefault then
									resultPath = "CompleteQuest"
								elseif isRecurring then
									resultPath = "CompleteRecurringQuest"
								end
							elseif isOnQuest then
								if isDefault then
									resultPath = "IncompleteQuest"
								elseif isRecurring then
									resultPath = "IncompleteRecurringQuest"
								end
							else
								if isDefault then
									resultPath = "AvailableQuest"
								elseif isRecurring then
									resultPath = "AvailableRecurringQuest"
								end
							end
						else
							if gossipButtonOptionTexture then
								local new = NS:ReplaceIcon(gossipButtonOptionTexture)
								resultPath = nil
								resultTexture = new
							end
						end


						if resultPath and not resultTexture then
							result = NS:ConvertToInlineIcon(resultPath)
							resultTexture = addon.Variables.PATH_ART .. "ContextIcons\\" .. resultPath .. ".png"
						else
						end
					end

					if queryGossip then
						resultPath = "Gossip"


						if resultPath then
							result = NS:ConvertToInlineIcon(resultPath)
							resultTexture = addon.Variables.PATH_ART .. "ContextIcons\\" .. resultPath .. ".png"
						else
						end
					end
				end
			end


			return result, resultTexture
		end
	end
end
