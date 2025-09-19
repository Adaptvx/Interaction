-- [!] [addon.Interaction.Quest] is a replacement for Blizzard's Quest Frame.
-- [Quest_Script.lua] is the back-end (logic & behavior)
-- for [Quest_Elements.lua].

---@class addon
local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local PrefabRegistry = addon.PrefabRegistry
local L = addon.Locales
local NS = addon.Interaction.Quest; addon.Interaction.Quest = NS

--------------------------------

NS.Script = {}

--------------------------------

function NS.Script:Load()
	--------------------------------
	-- REFERENCES
	--------------------------------

	local Frame = InteractionFrame.QuestFrame
	local Callback = NS.Script; NS.Script = Callback

	--------------------------------
	-- FUNCTIONS (BUTTONS)
	--------------------------------

	do
		Frame.REF_FOOTER_CONTENT.AcceptButton:SetScript("OnClick", function()
			Frame:HideWithAnimation()

			--------------------------------

			AcceptQuest()
		end)

		Frame.REF_FOOTER_CONTENT.ContinueButton:SetScript("OnClick", function()
			Frame:HideWithAnimation()

			--------------------------------

			CompleteQuest()
		end)

		Frame.REF_FOOTER_CONTENT.CompleteButton:SetScript("OnClick", function()
			local numChoices = (GetNumQuestChoices())
			local choiceIndex

			--------------------------------

			if numChoices == 0 then
				choiceIndex = 0
			elseif numChoices == 1 then
				choiceIndex = 1
			else
				choiceIndex = QuestInfoFrame.itemChoice
			end

			--------------------------------

			Frame:HideWithAnimation()

			--------------------------------

			addon.Libraries.AceTimer:ScheduleTimer(function()
				GetQuestReward(choiceIndex)
			end, .35)
		end)

		Frame.REF_FOOTER_CONTENT.DeclineButton:SetScript("OnClick", function()
			Frame:HideWithAnimation(true)
		end)

		Frame.REF_FOOTER_CONTENT.GoodbyeButton:SetScript("OnClick", function()
			Frame:HideWithAnimation(true)
		end)

		Frame.REF_HEADER_DIVIDER.MouseResponder:SetScript("OnEnter", function()
			Frame.REF_HEADER_DIVIDER:SetAlpha(.75)
		end)

		Frame.REF_HEADER_DIVIDER.MouseResponder:SetScript("OnLeave", function()
			Frame.REF_HEADER_DIVIDER:SetAlpha(1)
		end)
	end

	--------------------------------
	-- FUNCTIONS (FRAME)
	--------------------------------

	do
		function Frame:UpdateAll()
			Frame:UpdateLayout()
			Frame:UpdateWarbandHeader()
			Frame:UpdateScrollIndicator()
			Frame:UpdateFocus()
		end

		function Frame:UpdateLayout()
			CallbackRegistry:Trigger("UpdateDynamicSize Quest.Content.Main")

			CallbackRegistry:Trigger("LayoutGroupSort Quest.Content")
			CallbackRegistry:Trigger("LayoutGroupSort Quest.Content.Header")
			CallbackRegistry:Trigger("LayoutGroupSort Quest.Content.Main")
		end

		function Frame:UpdateWarbandHeader()
			local isWarbandComplete = (C_QuestLog.IsQuestFlaggedCompletedOnAccount and C_QuestLog.IsQuestFlaggedCompletedOnAccount(GetQuestID())) or false

			--------------------------------

			Frame.REF_HEADER_DIVIDER:SetAlpha(1)

			if isWarbandComplete then
				Frame.REF_HEADER_DIVIDER.MouseResponder:EnableMouse(true)
				addon.API.Util:AddTooltip(Frame.REF_HEADER_DIVIDER.MouseResponder, ACCOUNT_COMPLETED_QUEST_NOTICE, "ANCHOR_TOPRIGHT", 0, 0)
			else
				Frame.REF_HEADER_DIVIDER.MouseResponder:EnableMouse(false)
				addon.API.Util:RemoveTooltip(Frame.REF_HEADER_DIVIDER.MouseResponder)
			end

			--------------------------------

			local TEXTURE_Background

			if addon.Theme.IsDarkTheme then
				if isWarbandComplete then
					TEXTURE_Background = NS.Variables.QUEST_PATH .. "header-complete-dark.png"
				else
					TEXTURE_Background = NS.Variables.QUEST_PATH .. "header-dark.png"
				end
			else
				if isWarbandComplete then
					TEXTURE_Background = NS.Variables.QUEST_PATH .. "header-complete-light.png"
				else
					TEXTURE_Background = NS.Variables.QUEST_PATH .. "header-light.png"
				end
			end

			Frame.REF_HEADER_DIVIDER.BackgroundTexture:SetTexture(TEXTURE_Background)
		end

		function Frame:UpdateScrollIndicator()
			if Frame.REF_MAIN_SCROLLFRAME:IsVisible() and (Frame.REF_MAIN_SCROLLFRAME:GetVerticalScroll() < Frame.REF_MAIN_SCROLLFRAME:GetVerticalScrollRange() - 10) then
				Frame.REF_MAIN_SCROLLFRAME_SCROLLINDICATOR:Show()
			elseif QuestProgressScrollFrame:IsVisible() and (QuestProgressScrollFrame:GetVerticalScroll() < QuestProgressScrollFrame:GetVerticalScrollRange() - 10) then
				Frame.REF_MAIN_SCROLLFRAME_SCROLLINDICATOR:Show()
			elseif QuestRewardScrollFrame:IsVisible() and (QuestRewardScrollFrame:GetVerticalScroll() < QuestRewardScrollFrame:GetVerticalScrollRange() - 10) then
				Frame.REF_MAIN_SCROLLFRAME_SCROLLINDICATOR:Show()
			else
				Frame.REF_MAIN_SCROLLFRAME_SCROLLINDICATOR:Hide()
			end
		end
	end

	--------------------------------
	-- FUNCTIONS (NAVIGATION)
	--------------------------------

	do
		function Frame:SetChoiceSelected(frame)
			NS.Variables.Button_Choice_Selected = frame

			--------------------------------

			Frame:UpdateCompleteButton()
		end

		function Frame:ClearButton_Choice_Selected()
			QuestInfoFrame.itemChoice = 0

			--------------------------------

			NS.Variables.Button_Choice_Selected = nil

			--------------------------------

			Frame:UpdateCompleteButton()
		end

		function Frame:DisableCompleteButton()
			Frame.REF_FOOTER_CONTENT.CompleteButton:SetEnabled(false)
			Frame.REF_FOOTER_CONTENT.CompleteButton:SetAlpha(.5)
		end

		function Frame:EnableCompleteButton()
			Frame.REF_FOOTER_CONTENT.CompleteButton:SetEnabled(true)
			Frame.REF_FOOTER_CONTENT.CompleteButton:SetAlpha(1)
		end

		function Frame:UpdateCompleteButton()
			local isController = (addon.Input.Variables.IsControllerEnabled or addon.Input.Variables.SimulateController)
			local isCurrentHighlightedButtonSelected = (addon.Input.Variables.CurrentFrame == NS.Variables.Button_Choice_Selected)
			local isCompleteButtonHighlighted = (addon.Input.Variables.CurrentFrame == Frame.REF_FOOTER_CONTENT.CompleteButton)

			local isRewardSelection = (NS.Variables.Num_Choice > 1 and QuestFrameCompleteQuestButton:IsVisible())
			local isButton_Choice_Selected = (NS.Variables.Button_Choice_Selected ~= nil)

			--------------------------------

			if (not isRewardSelection) or (isRewardSelection and ((not isController) or (isController and (isCurrentHighlightedButtonSelected or isCompleteButtonHighlighted))) and (isButton_Choice_Selected)) then
				Frame:EnableCompleteButton()
			else
				Frame:DisableCompleteButton()
			end
		end
	end

	--------------------------------
	-- FUNCTIONS (DATA)
	--------------------------------

	do
		do -- UTILITIES
			local TYPE_ITEM = 0
			local TYPE_CURRENCY = 1

			function Callback:GetQuestRewardType(type, index)
				if type == "spell" then
					return "spell"
				else
					local questItemInfoType = GetQuestItemInfoLootType and GetQuestItemInfoLootType(type, index) or 0

					--------------------------------

					if questItemInfoType == TYPE_ITEM then
						local name, texture, count, quality, isUsable, itemID = GetQuestItemInfo(type, index)

						if #name <= 1 then
							return "currency"
						else
							return "item"
						end
					end

					if questItemInfoType == TYPE_CURRENCY then
						return "currency"
					end
				end
			end
		end

		do -- BUTTONS
			do -- GET
				function Frame:GetButtons_Choice()
					return NS.Variables.Buttons_Choice
				end

				function Frame:GetButtons_Reward()
					return NS.Variables.Buttons_Reward
				end

				function Frame:GetButtons_Spell()
					return NS.Variables.Buttons_Spell
				end

				function Frame:GetButtons_Required()
					return NS.Variables.Buttons_Required
				end
			end

			do -- SET
				function Frame:DeselectAllButtons()
					local Buttons_Choice = Frame:GetButtons_Choice()
					local Buttons_Reward = Frame:GetButtons_Reward()
					local Buttons_Required = Frame:GetButtons_Required()
					local Buttons_Spell = Frame:GetButtons_Spell()

					--------------------------------

					for i = 1, #Buttons_Choice do
						Buttons_Choice[i]:OnLeave()
					end

					for i = 1, #Buttons_Reward do
						Buttons_Reward[i]:OnLeave()
					end

					for i = 1, #Buttons_Required do
						Buttons_Required[i]:OnLeave()
					end

					for i = 1, #Buttons_Spell do
						Buttons_Spell[i]:OnLeave()
					end
				end
			end

			do -- UPDATE
				function Frame:UpdateAllButtonStates()
					local numChoices = NS.Variables.Num_Choice
					local numRewards = NS.Variables.Num_Reward
					local numRequired = NS.Variables.Num_Required
					local numSpell = NS.Variables.Num_Spell

					--------------------------------

					for i = 1, numChoices do
						NS.Variables.Buttons_Choice[i]:UpdateState()
					end

					for i = 1, numRewards do
						NS.Variables.Buttons_Reward[i]:UpdateState()
					end

					for i = 1, numRequired do
						NS.Variables.Buttons_Required[i]:UpdateState()
					end

					for i = 1, numSpell do
						NS.Variables.Buttons_Spell[i]:UpdateState()
					end
				end
			end
		end

		do -- HIDE
			function Frame:HideQuestChoice()
				NS.Variables.Num_Choice = 0
				Frame.REF_MAIN_SCROLLFRAME_CONTENT.Rewards_Choice:Hide()

				--------------------------------

				for i = 1, #Frame:GetButtons_Choice() do
					local CurrentButton = Frame:GetButtons_Choice()[i]
					CurrentButton:Hide()
				end
			end

			function Frame:HideReceive()
				NS.Variables.Num_Reward = 0
				Frame.REF_MAIN_SCROLLFRAME_CONTENT.Rewards_Receive:Hide()

				--------------------------------

				for i = 1, #Frame:GetButtons_Reward() do
					local CurrentButton = Frame:GetButtons_Reward()[i]
					CurrentButton:Hide()
				end
			end

			function Frame:HideSpell()
				NS.Variables.Num_Spell = 0
				Frame.REF_MAIN_SCROLLFRAME_CONTENT.Rewards_Spell:Hide()

				--------------------------------

				for i = 1, #Frame:GetButtons_Spell() do
					local CurrentButton = Frame:GetButtons_Spell()[i]
					CurrentButton:Hide()
				end
			end

			function Frame:HideRequired()
				NS.Variables.Num_Required = 0
				Frame.REF_MAIN_SCROLLFRAME_CONTENT.Progress_Header:Hide()

				--------------------------------

				for i = 1, #Frame:GetButtons_Required() do
					local CurrentButton = Frame:GetButtons_Required()[i]
					CurrentButton:Hide()
				end
			end
		end

		do -- SET
			function Frame:SetChoice(callbacks)
				NS.Variables.Num_Choice = #callbacks

				--------------------------------

				Frame.REF_MAIN_SCROLLFRAME_CONTENT.Rewards_Choice:Show()

				--------------------------------

				local Buttons = Frame:GetButtons_Choice()

				for i = 1, #Buttons do
					Buttons[i]:Hide()
				end

				for i = 1, NS.Variables.Num_Choice do
					Buttons[i]:Show()
					Buttons[i].index = i
					Buttons[i].type = "choice"
					Buttons[i].callback = callbacks[i]

					--------------------------------

					local CALLBACK_LABEL = _G[callbacks[i]:GetDebugName() .. "Name"]
					local CALLBACK_ICON = _G[callbacks[i]:GetDebugName() .. "IconTexture"]
					local CALLBACK_COUNT_LABEL = _G[callbacks[i]:GetDebugName() .. "Count"]
					local numCallbackCount = callbacks[i].count

					--------------------------------

					do -- TEXT
						if CALLBACK_LABEL then
							Buttons[i].Label:SetText(CALLBACK_LABEL:GetText())
						end
					end

					do -- ICON
						if CALLBACK_ICON then
							if CALLBACK_ICON:GetAtlas() then
								Buttons[i].Image.IconTexture:SetAtlas(CALLBACK_ICON:GetAtlas())
							else
								Buttons[i].Image.IconTexture:SetTexture(CALLBACK_ICON:GetTexture())
							end
						end
					end

					do -- COUNT
						if CALLBACK_COUNT_LABEL and numCallbackCount and numCallbackCount > 1 then
							Buttons[i].Image.Text:Show()
							Buttons[i].Image.Text.Label:SetTextColor(CALLBACK_COUNT_LABEL:GetTextColor())
							Buttons[i].Image.Text.Label:SetText(numCallbackCount)
						else
							Buttons[i].Image.Text:Hide()
							Buttons[i].Image.Text.Label:SetText("")
						end
					end

					do -- STATE
						Buttons[i]:SetStateAuto()
					end
				end
			end

			function Frame:SetReward(callbacks)
				NS.Variables.Num_Reward = #callbacks

				--------------------------------

				Frame.REF_MAIN_SCROLLFRAME_CONTENT.Rewards_Receive:Show()

				--------------------------------

				local Buttons = Frame:GetButtons_Reward()

				for i = 1, #Buttons do
					Buttons[i]:Hide()
				end

				for i = 1, NS.Variables.Num_Reward do
					Buttons[i]:Show()
					Buttons[i].index = i
					Buttons[i].type = "reward"
					Buttons[i].callback = callbacks[i]

					--------------------------------

					local CALLBACK_LABEL = _G[callbacks[i]:GetDebugName() .. "Name"]
					local CALLBACK_ICON = callbacks[i].Icon
					local CALLBACK_COUNT_LABEL = _G[callbacks[i]:GetDebugName() .. "Count"]
					local numCallbackCount = callbacks[i].count or 0

					--------------------------------

					do -- TEXT
						if CALLBACK_LABEL then
							Buttons[i].Label:SetText(CALLBACK_LABEL:GetText())
						end
					end

					do -- ICON
						if CALLBACK_ICON then
							if CALLBACK_ICON:GetAtlas() then
								Buttons[i].Image.IconTexture:SetAtlas(CALLBACK_ICON:GetAtlas())
							else
								Buttons[i].Image.IconTexture:SetTexture(CALLBACK_ICON:GetTexture())
							end
						end
					end

					do -- COUNT
						if CALLBACK_COUNT_LABEL and numCallbackCount and numCallbackCount > 1 then
							Buttons[i].Image.Text:Show()
							Buttons[i].Image.Text.Label:SetTextColor(CALLBACK_COUNT_LABEL:GetTextColor())
							Buttons[i].Image.Text.Label:SetText(numCallbackCount)
						else
							Buttons[i].Image.Text:Hide()
							Buttons[i].Image.Text.Label:SetText("")
						end
					end

					do -- STATE
						Buttons[i]:SetStateAuto()
					end
				end
			end

			function Frame:SetSpell(callbacks)
				NS.Variables.Num_Spell = #callbacks

				--------------------------------

				Frame.REF_MAIN_SCROLLFRAME_CONTENT.Rewards_Spell:Show()

				--------------------------------

				local Buttons = Frame:GetButtons_Spell()

				for i = 1, #Buttons do
					Buttons[i]:Hide()
				end

				for i = 1, NS.Variables.Num_Spell do
					Buttons[i]:Show()
					Buttons[i].index = i
					Buttons[i].type = "spell"
					Buttons[i].callback = callbacks[i]

					--------------------------------

					local CALLBACK_LABEL = callbacks[i].Name
					local CALLBACK_ICON = callbacks[i].Icon
					local CALLBACK_COUNT_LABEL = _G[callbacks[i]:GetDebugName() .. "Count"]
					local numCallbackCount = callbacks[i].count

					--------------------------------

					do -- TEXT
						if CALLBACK_LABEL then
							Buttons[i].Label:SetText(CALLBACK_LABEL:GetText())
						end
					end

					do -- ICON
						if CALLBACK_ICON then
							if CALLBACK_ICON:GetAtlas() then
								Buttons[i].Image.IconTexture:SetAtlas(CALLBACK_ICON:GetAtlas())
							else
								Buttons[i].Image.IconTexture:SetTexture(CALLBACK_ICON:GetTexture())
							end
						end
					end

					do -- COUNT
						if CALLBACK_COUNT_LABEL and numCallbackCount and numCallbackCount > 1 then
							Buttons[i].Image.Text:Show()
							Buttons[i].Image.Text.Label:SetTextColor(CALLBACK_COUNT_LABEL:GetTextColor())
							Buttons[i].Image.Text.Label:SetText(numCallbackCount)
						else
							Buttons[i].Image.Text:Hide()
							Buttons[i].Image.Text.Label:SetText("")
						end
					end

					do -- STATE
						Buttons[i]:SetStateAuto()
					end
				end
			end

			function Frame:SetRequired(callbacks)
				NS.Variables.Num_Required = #callbacks

				--------------------------------

				Frame.REF_MAIN_SCROLLFRAME_CONTENT.Progress_Header:Show()

				--------------------------------

				local Buttons = Frame:GetButtons_Required()

				for i = 1, #Buttons do
					Buttons[i]:Hide()
				end

				for i = 1, NS.Variables.Num_Required do
					Buttons[i]:Show()
					Buttons[i].index = i
					Buttons[i].type = "required"
					Buttons[i].callback = callbacks[i]

					--------------------------------

					local CALLBACK_LABEL = _G[callbacks[i]:GetDebugName() .. "Name"]
					local CALLBACK_ICON = _G[callbacks[i]:GetDebugName() .. "IconTexture"]
					local CALLBACK_COUNT_LABEL = _G[callbacks[i]:GetDebugName() .. "Count"]
					local numCallbackCount = callbacks[i].count

					--------------------------------

					do -- TEXT
						if CALLBACK_LABEL then
							Buttons[i].Label:SetText(CALLBACK_LABEL:GetText())
						end
					end

					do -- ICON
						if CALLBACK_ICON then
							if CALLBACK_ICON:GetAtlas() then
								Buttons[i].Image.IconTexture:SetAtlas(CALLBACK_ICON:GetAtlas())
							else
								Buttons[i].Image.IconTexture:SetTexture(CALLBACK_ICON:GetTexture())
							end
						end
					end

					do -- COUNT
						if CALLBACK_COUNT_LABEL and numCallbackCount and numCallbackCount > 1 then
							Buttons[i].Image.Text:Show()
							Buttons[i].Image.Text.Label:SetTextColor(CALLBACK_COUNT_LABEL:GetTextColor())
							Buttons[i].Image.Text.Label:SetText(numCallbackCount)
						else
							Buttons[i].Image.Text:Hide()
							Buttons[i].Image.Text.Label:SetText("")
						end
					end

					do -- STATE
						Buttons[i]:SetStateAuto()
					end
				end
			end
		end

		do -- DATA
			local function QuestFrame_GetRewards(type)
				local results = {}

				--------------------------------

				local frame = QuestInfoRewardsFrame
				for f1 = 1, frame:GetNumChildren() do
					local _frameIndex1 = select(f1, frame:GetChildren())

					if addon.API.Util:FindString(_frameIndex1:GetDebugName(), "QuestInfoItem") and _frameIndex1:IsVisible() and _frameIndex1:GetPoint() and _frameIndex1.type == type then
						table.insert(results, _frameIndex1)
					end
				end

				--------------------------------

				return results
			end

			local function QuestFrame_GetRequired()
				local results = {}

				--------------------------------

				local frame = QuestProgressScrollChildFrame
				for f1 = 1, frame:GetNumChildren() do
					local _frameIndex1 = select(f1, frame:GetChildren())

					if addon.API.Util:FindString(_frameIndex1:GetDebugName(), "QuestProgressItem") and not addon.API.Util:FindString(_frameIndex1:GetDebugName(), "Highlight") and _frameIndex1:IsVisible() and _frameIndex1.type == "required" then
						table.insert(results, _frameIndex1)
					end
				end

				--------------------------------

				return results
			end

			local function QuestFrame_GetSpells()
				local title
				local results = {}

				--------------------------------

				local frame = QuestInfoRewardsFrame
				for f1 = 1, frame:GetNumChildren() do
					local _frameIndex1 = select(f1, frame:GetChildren())

					if addon.API.Util:FindString(_frameIndex1:GetDebugName(), "0") and _frameIndex1:IsVisible() then
						table.insert(results, _frameIndex1)
					end
				end
				for f1 = 1, frame:GetNumRegions() do
					local _frameIndex1 = select(f1, frame:GetRegions())

					if addon.API.Util:FindString(_frameIndex1:GetDebugName(), "0") and _frameIndex1:IsVisible() then
						title = _frameIndex1
					end
				end

				--------------------------------

				return title, results
			end

			--------------------------------

			function Frame:SetData()
				do -- TEXT
					if not QuestFrame:IsVisible() then
						return
					end

					local TITLE = QuestInfoTitleHeader
					local TITLE_PROGRESS = QuestProgressTitleText
					local HEADER_OBJECTIVES = QuestInfoObjectivesHeader
					local TEXT_OBJECTIVES = QuestInfoObjectivesText
					local HEADER_REWARDS = QuestInfoRewardsFrame.Header
					local TEXT_REWARDS_CHOICE = QuestInfoRewardsFrame.ItemChooseText
					local TEXT_REWARDS_RECEIVE = QuestInfoRewardsFrame.ItemReceiveText
					local TEXT_REWARDS_PARTYSYNC = (not addon.Variables.IS_WOW_VERSION_CLASSIC_ALL) and QuestInfoRewardsFrame.QuestSessionBonusReward or nil
					local TEXT_REWARDS_SPELL, _ = QuestFrame_GetSpells()
					local HEADER_REQUIRE = QuestProgressRequiredItemsText

					local questID = GetQuestID()
					local storylineInfo = (not addon.Variables.IS_WOW_VERSION_CLASSIC_ALL and C_QuestLine.GetQuestLineInfo(questID) and C_QuestLine.GetQuestLineInfo(questID).questLineName) or (addon.Variables.IS_WOW_VERSION_CLASSIC_ALL and nil)
					local experience = UnitLevel("player") < GetMaxPlayerLevel() and GetRewardXP() or nil
					local experiencePercentage = string.format("%.2f%%", tostring((GetRewardXP() / UnitXPMax("player")) * 100))
					local gold, silver, copper = addon.API.Util:FormatMoney(GetRewardMoney())
					local honor = GetRewardHonor()

					if addon.Variables.IS_WOW_VERSION_CLASSIC_ALL and GetClassicExpansionLevel() >= 3 then
						honor = honor / 100
					end

					--------------------------------

					do -- TEXT (STORYLINE)
						Frame.REF_HEADER_STORYLINE:SetShown(storylineInfo)

						--------------------------------

						if storylineInfo then
							Frame.REF_HEADER_STORYLINE.Storyline:SetInfo(storylineInfo, nil, false, nil, nil)

							--------------------------------

							CallbackRegistry:Trigger("Quest.Storyline.Update", questID)
						end
					end

					do -- TEXT (TITLE)
						if not TITLE_PROGRESS:IsVisible() then
							Frame.REF_HEADER_TITLE:SetShown(TITLE:IsVisible())

							--------------------------------

							if TITLE:IsVisible() then
								Frame.REF_HEADER_TITLE.Text:SetText(addon.API.Util:RemoveAtlasMarkup(TITLE:GetText(), true))
							end
						else
							Frame.REF_HEADER_TITLE:SetShown(TITLE_PROGRESS:IsVisible())

							--------------------------------

							if TITLE_PROGRESS:IsVisible() then
								Frame.REF_HEADER_TITLE.Text:SetText(addon.API.Util:RemoveAtlasMarkup(TITLE_PROGRESS:GetText(), true))
							end
						end
					end

					do -- TEXT (OBJECTIVES)
						Frame.REF_MAIN_SCROLLFRAME_CONTENT.Objectives_Header:SetShown(HEADER_OBJECTIVES:IsVisible())
						Frame.REF_MAIN_SCROLLFRAME_CONTENT.Objectives_Text:SetShown(TEXT_OBJECTIVES:IsVisible())

						--------------------------------

						if HEADER_OBJECTIVES:IsVisible() then
							Frame.REF_MAIN_SCROLLFRAME_CONTENT.Objectives_Text:SetText(TEXT_OBJECTIVES:GetText())
						end
					end

					do -- REWARDS
						do -- HEADER
							Frame.REF_MAIN_SCROLLFRAME_CONTENT.Rewards_Header:SetShown(HEADER_REWARDS:IsVisible() and not TITLE_PROGRESS:IsVisible())
						end

						do -- EXPERIENCE
							Frame.REF_MAIN_SCROLLFRAME_CONTENT.Rewards_Experience:SetShown(experience and experience > 0 and not TITLE_PROGRESS:IsVisible())

							--------------------------------

							if experience and experience > 0 then
								Frame.REF_MAIN_SCROLLFRAME_CONTENT.Rewards_Experience.Text:SetText(addon.API.Util:InlineIcon(addon.Variables.PATH_ART .. "Icons/xp.png", 25, 25, 0, 0) .. " " .. addon.API.Util:FormatNumber(experience) .. " " .. "(" .. experiencePercentage .. ")")
							end
						end

						do -- CURRENCY
							Frame.REF_MAIN_SCROLLFRAME_CONTENT.Rewards_Currency:SetShown(GetRewardMoney() > 0 and not TITLE_PROGRESS:IsVisible())

							--------------------------------

							if GetRewardMoney() > 0 then
								local _gold, _silver, _copper

								--------------------------------

								if gold > 0 then
									_gold = addon.API.Util:InlineIcon(addon.Variables.PATH_ART .. "Icons/gold.png", 20, 20, 0, 0) .. " " .. "|cffEBD596" .. gold .. "|r" .. " "
								end

								if silver > 0 then
									_silver = addon.API.Util:InlineIcon(addon.Variables.PATH_ART .. "Icons/silver.png", 20, 20, 0, 0) .. " " .. "|cffC6C6C6" .. silver .. "|r" .. " "
								end

								if copper > 0 then
									_copper = addon.API.Util:InlineIcon(addon.Variables.PATH_ART .. "Icons/copper.png", 20, 20, 0, 0) .. " " .. "|cffD9AC86" .. copper .. "|r" .. " "
								end

								--------------------------------

								Frame.REF_MAIN_SCROLLFRAME_CONTENT.Rewards_Currency.Text:SetText((_gold or "") .. (_silver or "") .. (_copper or ""))
							end
						end

						do -- HONOR
							Frame.REF_MAIN_SCROLLFRAME_CONTENT.Rewards_Honor:SetShown(honor > 0 and not TITLE_PROGRESS:IsVisible())

							--------------------------------

							if honor > 0 then
								Frame.REF_MAIN_SCROLLFRAME_CONTENT.Rewards_Honor.Text:SetText(addon.API.Util:InlineIcon(addon.Variables.PATH_ART .. "Icons/honor.png", 25, 25, 0, 0) .. " " .. "|cffD7B473" .. addon.API.Util:FormatNumber(honor) .. "|r")
							end
						end

						do -- CHOICE
							Frame.REF_MAIN_SCROLLFRAME_CONTENT.Rewards_Choice:SetShown(TEXT_REWARDS_CHOICE:IsVisible())

							--------------------------------

							Frame.REF_MAIN_SCROLLFRAME_CONTENT.Rewards_Choice:SetText(TEXT_REWARDS_CHOICE:GetText())
						end

						do -- RECIEVE
							Frame.REF_MAIN_SCROLLFRAME_CONTENT.Rewards_Receive:SetShown(TEXT_REWARDS_PARTYSYNC and TEXT_REWARDS_PARTYSYNC:IsVisible() or TEXT_REWARDS_RECEIVE:IsVisible())

							--------------------------------

							if TEXT_REWARDS_PARTYSYNC and TEXT_REWARDS_PARTYSYNC:IsVisible() then
								Frame.REF_MAIN_SCROLLFRAME_CONTENT.Rewards_Receive:SetText(TEXT_REWARDS_PARTYSYNC:GetText())
							else
								Frame.REF_MAIN_SCROLLFRAME_CONTENT.Rewards_Receive:SetText(TEXT_REWARDS_RECEIVE:GetText())
							end
						end

						do -- SPELL
							Frame.REF_MAIN_SCROLLFRAME_CONTENT.Rewards_Spell:SetShown(TEXT_REWARDS_SPELL and TEXT_REWARDS_SPELL:IsVisible())

							--------------------------------

							if TEXT_REWARDS_SPELL then
								Frame.REF_MAIN_SCROLLFRAME_CONTENT.Rewards_Spell:SetText(TEXT_REWARDS_SPELL:GetText())
							end
						end

						do -- PROGRESS
							Frame.REF_MAIN_SCROLLFRAME_CONTENT.Progress_Header:SetShown(HEADER_REQUIRE:IsVisible())
						end
					end
				end

				do -- CONTEXT ICON
					local ContextIcon = addon.ContextIcon:GetContextIcon()

					--------------------------------

					Frame.REF_CONTEXTICON.Text:SetText(ContextIcon)
				end

				do -- REWARDS
					local choices = QuestFrame_GetRewards("choice")
					local reward = QuestFrame_GetRewards("reward")
					local _, spells = QuestFrame_GetSpells()
					local required = QuestFrame_GetRequired()

					--------------------------------

					if #choices >= 1 then
						Frame:SetChoice(choices)
					else
						Frame:HideQuestChoice()
					end

					if #reward >= 1 then
						Frame:SetReward(reward)
					else
						Frame:HideReceive()
					end

					if #spells >= 1 then
						Frame:SetSpell(spells)
					else
						Frame:HideSpell()
					end

					if #required >= 1 then
						Frame:SetRequired(required)
					else
						Frame:HideRequired()
					end

					--------------------------------

					Frame:SetQuality()
					Frame:UpdateAllButtonStates()
				end

				do -- BUTTONS
					local BUTTON_COMPLETE = QuestFrameCompleteQuestButton
					local BUTTON_CONTINUE = QuestFrameCompleteButton
					local BUTTON_ACCEPT = QuestFrameAcceptButton
					local BUTTON_DECLINE = QuestFrameDeclineButton
					local BUTTON_GOODBYE = QuestFrameGoodbyeButton

					-- Can't seem to query if the quest log is full - C_QuestLog.GetNumQuestWatches() returns values
					-- higher than C_QuestLog.GetMaxNumQuestsCanAccept() even though it is still within the limit?
					local isQuestLogFull = false -- (select(2, C_QuestLog.GetNumQuestWatches()) >= C_QuestLog.GetMaxNumQuestsCanAccept())
					local isAutoAccept = addon.API.Main:IsAutoAccept()

					--------------------------------

					Frame.REF_FOOTER_CONTENT.CompleteButton:SetShown(BUTTON_COMPLETE:IsVisible())
					Frame.REF_FOOTER_CONTENT.ContinueButton:SetShown(BUTTON_CONTINUE:IsVisible() and BUTTON_CONTINUE:IsEnabled())
					Frame.REF_FOOTER_CONTENT.AcceptButton:SetShown(BUTTON_ACCEPT:IsVisible())
					Frame.REF_FOOTER_CONTENT.DeclineButton:SetShown(BUTTON_DECLINE:IsVisible())
					Frame.REF_FOOTER_CONTENT.GoodbyeButton:SetShown(not BUTTON_DECLINE:IsVisible())

					--------------------------------

					Frame.REF_FOOTER_CONTENT.CompleteButton:SetEnabled(BUTTON_COMPLETE:IsEnabled())
					Frame.REF_FOOTER_CONTENT.ContinueButton:SetEnabled(BUTTON_CONTINUE:IsEnabled())
					Frame.REF_FOOTER_CONTENT.AcceptButton:SetEnabled(not isQuestLogFull)
					Frame.REF_FOOTER_CONTENT.DeclineButton:SetEnabled(true)
					Frame.REF_FOOTER_CONTENT.GoodbyeButton:SetEnabled(true)

					--------------------------------

					local function SetButtonText(frame, text, keybindVariable)
						frame:SetText(text)

						--------------------------------

						do -- ACCEPT
							if frame == Frame.REF_FOOTER_CONTENT.AcceptButton then
								if isQuestLogFull then
									frame:SetText(L["InteractionFrame.QuestFrame - Accept - Quest Log Full"])
								end

								if isAutoAccept then
									frame:SetText(L["InteractionFrame.QuestFrame - Accept - Auto Accept"])
								end

								--------------------------------

								frame:SetEnabled(not isQuestLogFull and not isAutoAccept)
							end
						end

						do -- GOODBYE
							if frame == Frame.REF_FOOTER_CONTENT.GoodbyeButton then
								if isAutoAccept then
									frame:SetText(L["InteractionFrame.QuestFrame - Goodbye - Auto Accept"])
									keybindVariable = addon.Input.Variables:GetKeybindForPlatform(addon.Input.Variables.Key_Progress)
								end
							end
						end

						--------------------------------

						if frame:IsEnabled() then
							addon.API.Main:SetButtonToPlatform(frame, frame.Text, keybindVariable)
						else
							addon.API.Main:SetButtonToPlatform(frame, frame.Text, "")
						end
					end

					if BUTTON_CONTINUE:IsEnabled() then
						SetButtonText(Frame.REF_FOOTER_CONTENT.ContinueButton, L["InteractionFrame.QuestFrame - Continue"], addon.Input.Variables:GetKeybindForPlatform(addon.Input.Variables.Key_Progress))
					else
						SetButtonText(Frame.REF_FOOTER_CONTENT.ContinueButton, L["InteractionFrame.QuestFrame - In Progress"], addon.Input.Variables:GetKeybindForPlatform(addon.Input.Variables.Key_Progress))
					end

					SetButtonText(Frame.REF_FOOTER_CONTENT.CompleteButton, L["InteractionFrame.QuestFrame - Complete"], addon.Input.Variables:GetKeybindForPlatform(addon.Input.Variables.Key_Progress))
					SetButtonText(Frame.REF_FOOTER_CONTENT.AcceptButton, L["InteractionFrame.QuestFrame - Accept"], addon.Input.Variables:GetKeybindForPlatform(addon.Input.Variables.Key_Progress))
					SetButtonText(Frame.REF_FOOTER_CONTENT.DeclineButton, L["InteractionFrame.QuestFrame - Decline"], addon.Input.Variables:GetKeybindForPlatform(addon.Input.Variables.Key_Close))
					SetButtonText(Frame.REF_FOOTER_CONTENT.GoodbyeButton, L["InteractionFrame.QuestFrame - Goodbye"], addon.Input.Variables:GetKeybindForPlatform(addon.Input.Variables.Key_Close))
				end

				--------------------------------

				Frame:UpdateCompleteButton()
				Frame:DeselectAllButtons()

				--------------------------------

				CallbackRegistry:Trigger("QUEST_DATA_LOADED")

				addon.Libraries.AceTimer:ScheduleTimer(Frame.UpdateLayout, 0)
				addon.Libraries.AceTimer:ScheduleTimer(Frame.UpdateAll, .1)
			end
		end

		do -- QUALITY
			local itemIndex = 1
			local currencyIndex = 1

			--------------------------------

			local function GetQuestItem(type)
				local name, texture, count, quality, isUsable, itemID = GetQuestItemInfo(type, itemIndex)

				-- useful
				local link = GetQuestItemLink(type, itemIndex)
				if link and not itemID then
					itemID = GetItemInfoFromHyperlink and GetItemInfoFromHyperlink(link)
				end

				--------------------------------

				if #name > 1 then
					itemIndex = itemIndex + 1
				end

				--------------------------------

				return name, texture, count, quality, isUsable, itemID
			end

			local function GetQuestCurrency(type)
				local quality

				--------------------------------

				if type == "reward" or type == "choice" then
					if addon.Variables.IS_WOW_VERSION_RETAIL then
						local currencyInfo = C_QuestOffer.GetQuestRewardCurrencyInfo(type, currencyIndex)

						--------------------------------

						if currencyInfo then
							quality = currencyInfo.quality
						end
					elseif addon.Variables.IS_WOW_VERSION_CLASSIC_ALL then
						local currencyInfo = GetQuestCurrencyInfo(type, currencyIndex)

						--------------------------------

						if currencyInfo then
							quality = currencyInfo.quality
						end
					end
				elseif type == "required" then
					if addon.Variables.IS_WOW_VERSION_RETAIL then
						local currencyInfo = C_QuestOffer.GetQuestRequiredCurrencyInfo(currencyIndex)

						--------------------------------

						if currencyInfo then
							quality = currencyInfo.quality
						end
					elseif addon.Variables.IS_WOW_VERSION_CLASSIC_ALL then
						local currencyInfo = GetQuestCurrencyInfo(type, currencyIndex)

						--------------------------------

						if currencyInfo then
							quality = currencyInfo.quality
						end
					end
				end

				--------------------------------

				currencyIndex = currencyIndex + 1

				--------------------------------

				return quality
			end

			local function ParseType(type, index)
				local rewardType = Callback:GetQuestRewardType(type, index)
				local resultQuality, resultValue

				--------------------------------

				if rewardType == "item" then
					local name, _, _, quality, _, itemID = GetQuestItem(type)
					resultQuality = quality

					--------------------------------

					if #name <= 1 then
						resultQuality = GetQuestCurrency(type)
					end

					-- useful
					if itemID and C_Item.GetItemInfoInstant(itemID) then
						_, _, _, _, _, _, _, _, _, _, resultValue = C_Item.GetItemInfo(itemID)
					end

					--------------------------------

					return resultQuality, resultValue
				end

				if rewardType == "currency" then
					resultQuality = GetQuestCurrency(type)

					--------------------------------

					return resultQuality
				end

				if rewardType == "spell" then
					return Enum.ItemQuality.Common
				end
			end

			local function ResetIndex()
				itemIndex = 1
				currencyIndex = 1
			end

			--------------------------------

			function Frame:SetQuality()
				local numChoices = NS.Variables.Num_Choice
				local numRewards = NS.Variables.Num_Reward
				local numRequired = NS.Variables.Num_Required

				--------------------------------

				do -- CHOICES
					ResetIndex()
					-- :SetQuality() makes sense or we'd have to repeat the loop
					-- Price could be a property NS.Variables.Buttons_Choice[i].Price
					-- if we ever wanted to show the actual money string somewhere
					local bestPrice, highPrice, Price
					for i = 1, numChoices do
						NS.Variables.Buttons_Choice[i].Quality, Price = ParseType("choice", i)
						NS.Variables.Buttons_Choice[i].BestPrice = nil
						if Price and (Price > (highPrice or 0)) then
							highPrice = Price
							bestPrice = i
						end
					end
					if bestPrice and numChoices > 1 then
						NS.Variables.Buttons_Choice[bestPrice].BestPrice = true
					end
				end

				do -- REWARDS
					ResetIndex()
					for i = 1, numRewards do
						NS.Variables.Buttons_Reward[i].Quality = ParseType("reward", i)
					end
				end

				do -- REQUIRED
					ResetIndex()
					for i = 1, numRequired do
						NS.Variables.Buttons_Required[i].Quality = ParseType("required", i)
					end
				end
			end
		end
	end

	--------------------------------
	-- FUNCTIONS (ANIMATION)
	--------------------------------

	do
		function Frame:ShowWithAnimation_StopEvent(sessionID)
			return Frame.hidden or Frame.showWithAnimation_sessionID ~= sessionID
		end

		function Frame:ShowWithAnimation()
			if not Frame.hidden then
				return
			end
			Frame.hidden = false

			addon.Libraries.AceTimer:ScheduleTimer(function()
				if not Frame.hidden then
					Frame:Show()
				end
			end, .025)

			--------------------------------

			Frame.animation = true

			addon.Libraries.AceTimer:ScheduleTimer(function()
				if not Frame.hidden then
					Frame.animation = false
				end
			end, .175)

			--------------------------------

			local showWithAnimation_sessionID = math.random(1, 9999999)
			Frame.showWithAnimation_sessionID = showWithAnimation_sessionID

			--------------------------------

			Frame.REF_MAIN_SCROLLFRAME:SetVerticalScroll(0)

			--------------------------------

			Frame:SetAlpha(0)
			Frame.Background:SetAlpha(0)
			Frame.REF_HEADER_TITLE.Text:SetAlpha(0)
			Frame.REF_HEADER_STORYLINE.Storyline:SetAlpha(0)
			Frame.REF_MAIN_SCROLLFRAME:SetAlpha(0)
			Frame.REF_MAIN_SCROLLFRAME:Hide()
			Frame.REF_FOOTER_CONTENT:SetAlpha(0)
			Frame.REF_FOOTER_CONTENT:Hide()

			--------------------------------

			addon.API.Animation:Fade(Frame, .25, 0, 1, nil, function() return Frame:ShowWithAnimation_StopEvent(showWithAnimation_sessionID) end)
			addon.API.Animation:Fade(Frame.REF_CONTEXTICON.Text, .5, 0, 1, nil, function() return Frame:ShowWithAnimation_StopEvent(showWithAnimation_sessionID) end)
			addon.API.Animation:Scale(Frame.REF_CONTEXTICON, .5, 5, 1, nil, addon.API.Animation.EaseExpo, function() return Frame:ShowWithAnimation_StopEvent(showWithAnimation_sessionID) end)

			do -- BACKGROUND
				addon.API.Animation:Fade(Frame.Background, .375, 0, 1, nil, function() return Frame:ShowWithAnimation_StopEvent(showWithAnimation_sessionID) end)
			end

			do -- CONTENT
				if not Frame.hidden and Frame.showWithAnimation_sessionID == showWithAnimation_sessionID then
					addon.API.Animation:Fade(Frame.REF_HEADER_TITLE.Text, .375, 0, .75, nil, function() return Frame:ShowWithAnimation_StopEvent(showWithAnimation_sessionID) end)
					addon.API.Animation:Fade(Frame.REF_HEADER_STORYLINE.Storyline, .375, 0, 1, nil, function() return Frame:ShowWithAnimation_StopEvent(showWithAnimation_sessionID) end)

					--------------------------------

					Frame.REF_MAIN_SCROLLFRAME:Hide()
					Frame.REF_MAIN_SCROLLFRAME_CONTENT:Sort()

					--------------------------------

					addon.Libraries.AceTimer:ScheduleTimer(function()
						if not Frame.hidden and Frame.showWithAnimation_sessionID == showWithAnimation_sessionID then
							addon.API.Animation:Fade(Frame.REF_MAIN_SCROLLFRAME, .375, 0, 1, nil, function() return Frame:ShowWithAnimation_StopEvent(showWithAnimation_sessionID) end)

							--------------------------------

							addon.Libraries.AceTimer:ScheduleTimer(function()
								Frame.REF_MAIN_SCROLLFRAME:Show()
							end, 0)
						end
					end, .05)

					addon.Libraries.AceTimer:ScheduleTimer(function()
						if not Frame.hidden and Frame.showWithAnimation_sessionID == showWithAnimation_sessionID then
							addon.API.Animation:Fade(Frame.REF_FOOTER_CONTENT, .5, 0, 1, addon.API.Animation.EaseSine, function() return Frame:ShowWithAnimation_StopEvent(showWithAnimation_sessionID) end)

							--------------------------------

							addon.Libraries.AceTimer:ScheduleTimer(function()
								Frame.REF_FOOTER_CONTENT:Show()
							end, 0)
						end
					end, .125)
				end
			end

			do -- SET
				addon.Libraries.AceTimer:ScheduleTimer(function()
					if not Frame.hidden and Frame.showWithAnimation_sessionID == showWithAnimation_sessionID then
						Frame:SetData()
					end
				end, .1)
			end

			do -- UPDATE
				addon.Libraries.AceTimer:ScheduleTimer(function()
					if not Frame.hidden and Frame.showWithAnimation_sessionID == showWithAnimation_sessionID then
						Frame:UpdateAll()
					end
				end, .225)
			end

			--------------------------------

			-- addon.SoundEffects:PlaySoundFile(addon.SoundEffects.Quest_Show)
		end

		function Frame:HideWithAnimation_StopEvent()
			return not Frame.hidden
		end

		function Frame:HideWithAnimation(stopSession)
			if Frame.hidden then
				return
			end
			Frame.hidden = true

			addon.Libraries.AceTimer:ScheduleTimer(function()
				if Frame.hidden then
					Frame:Hide()
				end
			end, .25)

			--------------------------------

			Frame.animation = true

			addon.Libraries.AceTimer:ScheduleTimer(function()
				if Frame.hidden then
					Frame.animation = false
				end
			end, .25)

			--------------------------------

			Frame.validForNotification = true

			addon.Libraries.AceTimer:ScheduleTimer(function()
				if Frame.hidden then
					Frame.validForNotification = false
				end
			end, 1)

			--------------------------------

			addon.API.Animation:Fade(Frame, .175, Frame:GetAlpha(), 0, nil, Frame.HideWithAnimation_StopEvent)
			addon.API.Animation:Fade(Frame.REF_CONTEXTICON.Text, .175, Frame.REF_CONTEXTICON.Text:GetAlpha(), 0, nil, Frame.HideWithAnimation_StopEvent)
			addon.API.Animation:Scale(Frame.REF_CONTEXTICON, 2.5, Frame.REF_CONTEXTICON:GetScale(), 2.75, nil, addon.API.Animation.EaseExpo, Frame.HideWithAnimation_StopEvent)

			--------------------------------

			if stopSession then
				addon.Interaction.Script:Stop(true)
			end

			--------------------------------

			CallbackRegistry:Trigger("STOP_QUEST")

			--------------------------------

			-- addon.SoundEffects:PlaySoundFile(addon.SoundEffects.Quest_Hide)
		end
	end

	--------------------------------
	-- FUNCTIONS (TOOLTIP)
	--------------------------------

	do
		function Frame:UpdateGameTooltip()
			local isRewardButton = (InteractionFrame.GameTooltip.RewardButton)
			local isFrame = (Frame:IsVisible())

			if isFrame and isRewardButton then
				InteractionFrame.GameTooltip.reward = true
				InteractionFrame.GameTooltip.bypass = true

				InteractionFrame.GameTooltip:SetAnchorType("ANCHOR_NONE")
				InteractionFrame.GameTooltip:ClearAllPoints()
				InteractionFrame.GameTooltip:SetPoint("TOP", InteractionFrame.GameTooltip.RewardButton, 0, InteractionFrame.GameTooltip:GetHeight() + 12.5)
			elseif not isFrame and InteractionFrame.GameTooltip.reward then
				InteractionFrame.GameTooltip.reward = false
				InteractionFrame.GameTooltip.bypass = false

				InteractionFrame.GameTooltip:Hide()
			end
		end
	end

	--------------------------------
	-- FUNCTIONS (FOCUS)
	--------------------------------

	do
		function Frame:OnEnter()
			Frame.mouseOver = true

			--------------------------------

			Frame:UpdateFocus()
		end

		function Frame:OnLeave()
			Frame.mouseOver = false

			--------------------------------

			Frame:UpdateFocus()
		end

		function Frame:UpdateFocus()
			if not addon.Input.Variables.IsController then
				local IsMouseOver = (Frame.mouseOver)
				local IsInDialog = (not InteractionFrame.DialogFrame.hidden)

				--------------------------------

				if IsInDialog and not IsMouseOver then
					Frame.focused = false
				else
					Frame.focused = true
				end

				--------------------------------

				if Frame.focused then
					addon.API.Animation:Fade(InteractionFrame.QuestParent, .25, InteractionFrame.QuestParent:GetAlpha(), 1, nil, function() return not Frame.focused end)
				else
					addon.API.Animation:Fade(InteractionFrame.QuestParent, .25, InteractionFrame.QuestParent:GetAlpha(), 1, nil, function() return Frame.focused end)
				end
			else
				InteractionFrame.QuestParent:SetAlpha(1)
			end
		end

		addon.API.FrameTemplates:CreateMouseResponder(Frame, { enterCallback = Frame.OnEnter, leaveCallback = Frame.OnLeave }, { x = 175, y = 175 })

		CallbackRegistry:Add("START_DIALOG", Frame.UpdateFocus, 0)
		CallbackRegistry:Add("STOP_DIALOG", Frame.UpdateFocus, 0)
	end

	--------------------------------
	-- SETTINGS
	--------------------------------

	do
		local function Settings_ThemeUpdate()
			if Frame:IsVisible() then
				Frame:UpdateWarbandHeader()
			end
		end
		Settings_ThemeUpdate()

		local function Settings_UIDirection()
			local Settings_UIDirection = addon.Database.DB_GLOBAL.profile.INT_UIDIRECTION

			local offsetY = 0
			local usableWidth = InteractionFrame.QuestParent:GetWidth()
			local frameWidth = Frame:GetWidth()
			local dialogMaxWidth = 350
			local quarterWidth = (usableWidth - dialogMaxWidth) / 2
			local quarterEdgePadding = (quarterWidth - frameWidth) / 2
			local offsetX

			-- 1 -> LEFT
			-- 2 -> RIGHT

			Frame:ClearAllPoints()
			if Settings_UIDirection == 1 then
				if Frame.Target and Frame.Target:IsVisible() then
					offsetX = quarterEdgePadding

					--------------------------------

					Frame:SetPoint("LEFT", InteractionFrame.QuestParent, quarterEdgePadding + Frame.Target:GetWidth(), offsetY)
				else
					offsetX = quarterEdgePadding

					--------------------------------

					Frame:SetPoint("LEFT", InteractionFrame.QuestParent, quarterEdgePadding, offsetY)
				end
			else
				offsetX = usableWidth - frameWidth - quarterEdgePadding

				--------------------------------

				Frame:SetPoint("LEFT", InteractionFrame.QuestParent, offsetX, offsetY)
			end
		end
		Settings_UIDirection()

		local function Settings_QuestFrameSize()
			local presetSizeModifier = {
				[1] = .75,
				[2] = .875,
				[3] = 1,
				[4] = 1.05,
			}
			local presetWidthModifier = {
				[1] = .825,
				[2] = .75,
				[3] = .75,
				[4] = .725,
			}

			local widthModifier = presetWidthModifier[addon.Database.DB_GLOBAL.profile.INT_QUESTFRAME_SIZE]
			local sizeModifier = presetSizeModifier[addon.Database.DB_GLOBAL.profile.INT_QUESTFRAME_SIZE]
			local defaultSize = { x = 625 * widthModifier, y = 625 }
			local targetSize = { x = defaultSize.x * sizeModifier, y = defaultSize.y * sizeModifier }

			--------------------------------

			NS.Variables:UpdateScaleModifier(targetSize.x)
			Frame:SetSize(targetSize.x, targetSize.y)

			--------------------------------

			if not Frame.hidden then
				Frame:SetData() -- Refresh Formatting
				Settings_UIDirection() -- Refresh Position
			end

			--------------------------------

			CallbackRegistry:Trigger("Quest.Settings_QuestFrameSize")
		end
		Settings_QuestFrameSize()

		--------------------------------

		CallbackRegistry:Add("THEME_UPDATE", Settings_ThemeUpdate, 10)
		CallbackRegistry:Add("SETTINGS_UIDIRECTION_CHANGED", Settings_UIDirection, 1)
		CallbackRegistry:Add("BLIZZARD_SETTINGS_RESOLUTION_CHANGED", Settings_UIDirection, 1)
		CallbackRegistry:Add("START_QUEST", Settings_UIDirection, 1)
		CallbackRegistry:Add("SETTINGS_QUESTFRAME_SIZE_CHANGED", Settings_QuestFrameSize, 1)

		if QuestModelScene then -- Fix for Classic Era
			hooksecurefunc(QuestModelScene, "Show", Settings_UIDirection)
		end
	end

	--------------------------------
	-- EVENTS
	--------------------------------

	do
		CallbackRegistry:Add("QUEST_DATA_LOADED", function()
			Frame:UpdateAll()
		end, 5)

		CallbackRegistry:Add("INPUT_NAVIGATION_HIGHLIGHTED", function()
			Frame:UpdateCompleteButton()
		end, 0)

		--------------------------------

		Frame:SetScript("OnMouseUp", function(self, button)
			if not addon.Database.DB_GLOBAL.profile.INT_ALWAYS_SHOW_QUEST then
				if addon.Database.DB_GLOBAL.profile.INT_FLIPMOUSE == false and button == "RightButton" then
					addon.Interaction.Dialog.Script:Restart()
				elseif addon.Database.DB_GLOBAL.profile.INT_FLIPMOUSE == true and button == "LeftButton" then
					addon.Interaction.Dialog.Script:Restart()
				end
			end
		end)

		hooksecurefunc(Frame, "Show", function()
			CallbackRegistry:Trigger("START_QUEST")

			--------------------------------

			Frame:ClearButton_Choice_Selected()
		end)

		hooksecurefunc(Frame, "Hide", function()
			CallbackRegistry:Trigger("STOP_QUEST")

			--------------------------------

			Frame:ClearButton_Choice_Selected()
			InteractionFrame.QuestFrame:UpdateGameTooltip()
			InteractionFrame.GameTooltip:Clear()
		end)

		table.insert(Frame.REF_MAIN_SCROLLFRAME.onSmoothScrollCallbacks, Frame.UpdateScrollIndicator)
	end

	--------------------------------
	-- SETUP
	--------------------------------
end
