local addonName, addon = ...
local CallbackRegistry = addon.CallbackRegistry
local L = addon.Locales
local NS = addon.ContextIcon

--------------------------------

NS.Variables = {}

--------------------------------
-- VARIABLES
--------------------------------

do -- MAIN
	NS.Variables.IsRetail = not addon.Variables.IS_CLASSIC and not addon.Variables.IS_CLASSIC_ERA
	NS.Variables.IsClassicCata = addon.Variables.IS_CLASSIC and not addon.Variables.IS_CLASSIC_ERA
	NS.Variables.IsClassicEra = addon.Variables.IS_CLASSIC_ERA
end

do -- CONSTANTS
	NS.Variables.ICON_MAP = {
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

	NS.Variables.PATH = addon.Variables.PATH .. "Art/ContextIcons/"
end

--------------------------------
-- EVENTS
--------------------------------
