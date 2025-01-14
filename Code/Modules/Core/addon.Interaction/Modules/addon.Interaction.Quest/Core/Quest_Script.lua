local addonName, addon = ...
local CallbackRegistry = addon.CallbackRegistry
local L = addon.Locales
local NS = addon.Interaction.Quest

--------------------------------

NS.Script = {}

--------------------------------

function NS.Script:Load()
	--------------------------------
	-- REFERENCES
	--------------------------------

	local Frame = InteractionQuestFrame
	local Callback = NS.Script

	--------------------------------
	-- FUNCTIONS (BUTTONS)
	--------------------------------

	do
		Frame.ButtonContainer.AcceptButton:SetScript("OnClick", function()
			Frame.HideWithAnimation()

			--------------------------------

			AcceptQuest()
		end)

		Frame.ButtonContainer.ContinueButton:SetScript("OnClick", function()
			Frame.HideWithAnimation()

			--------------------------------

			CompleteQuest()
		end)

		Frame.ButtonContainer.CompleteButton:SetScript("OnClick", function()
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

			Frame.HideWithAnimation()

			--------------------------------

			addon.Libraries.AceTimer:ScheduleTimer(function()
				GetQuestReward(choiceIndex)
			end, .35)
		end)

		Frame.ButtonContainer.DeclineButton:SetScript("OnClick", function()
			Frame.HideWithAnimation(true)
		end)

		Frame.ButtonContainer.GoodbyeButton:SetScript("OnClick", function()
			Frame.HideWithAnimation(true)
		end)

		Frame.TitleHeader.MouseResponder:SetScript("OnEnter", function()
			Frame.TitleHeader:SetAlpha(.75)
		end)

		Frame.TitleHeader.MouseResponder:SetScript("OnLeave", function()
			Frame.TitleHeader:SetAlpha(1)
		end)
	end

	--------------------------------
	-- FUNCTIONS (FRAME)
	--------------------------------

	do
		Frame.ScrollChildFrame.UpdateLayout = function()
			local elements = Frame.ScrollChildFrame.Elements
			local currentOffset = 0

			--------------------------------

			for element = 1, #elements do
				if elements[element]:IsShown() then
					local currentElement = elements[element]
					local nextElement = elements[element + 1]

					local currentElementHeight = 0

					--------------------------------

					if currentElement.GetStringHeight then
						currentElementHeight = currentElement:GetStringHeight()
					elseif currentElement.GetHeight then
						currentElementHeight = currentElement:GetHeight()
					end

					--------------------------------

					currentElement:ClearAllPoints()
					currentElement:SetPoint("TOP", Frame.ScrollChildFrame, 0, -currentOffset)

					--------------------------------

					if (currentElement.type == "RewardText") and (nextElement and nextElement:IsShown() and nextElement.type == "RewardText") then
						currentOffset = currentOffset + currentElementHeight + NS.Variables.PADDING
					else
						currentOffset = currentOffset + currentElementHeight + NS.Variables.PADDING
					end
				end
			end

			--------------------------------

			Frame.ScrollChildFrame:SetHeight(currentOffset)
		end

		Frame.UpdateAll = function()
			Frame.UpdateWarbandHeader()
			Frame.UpdateScrollFrameFormat()
			Frame.UpdateScrollIndicator()
			Frame.UpdateFocus()
		end

		Frame.UpdateWarbandHeader = function()
			local WarbandCompleted = C_QuestLog.IsQuestFlaggedCompletedOnAccount and C_QuestLog.IsQuestFlaggedCompletedOnAccount(GetQuestID()) or false

			--------------------------------

			Frame.TitleHeader:SetAlpha(1)

			if WarbandCompleted then
				Frame.TitleHeader.MouseResponder:EnableMouse(true)
				AdaptiveAPI:AddTooltip(Frame.TitleHeader.MouseResponder, ACCOUNT_COMPLETED_QUEST_NOTICE, "ANCHOR_TOPRIGHT", 0, 0, true)
			else
				Frame.TitleHeader.MouseResponder:EnableMouse(false)
				AdaptiveAPI:RemoveTooltip(Frame.TitleHeader.MouseResponder)
			end

			--------------------------------

			local Texture

			if addon.Theme.IsDarkTheme then
				if WarbandCompleted then
					Texture = NS.Variables.QUEST_PATH .. "header-complete-dark.png"
				else
					Texture = NS.Variables.QUEST_PATH .. "header-dark.png"
				end
			else
				if WarbandCompleted then
					Texture = NS.Variables.QUEST_PATH .. "header-complete-light.png"
				else
					Texture = NS.Variables.QUEST_PATH .. "header-light.png"
				end
			end

			Frame.TitleHeaderTexture:SetTexture(Texture)
		end

		Frame.UpdateScrollFrameFormat = function()
			if not Frame.Title then return end

			if Frame.Storyline:IsShown() then
				local TitleHeight = Frame.Title:GetStringHeight() + Frame.TitleHeader:GetHeight() + NS.Variables.PADDING
				Frame.ScrollFrame:SetHeight(Frame:GetHeight() - (75 / NS.Variables.ScaleModifier) - TitleHeight)
			else
				local TitleHeight = Frame.Title:GetStringHeight() + Frame.TitleHeader:GetHeight() + NS.Variables.PADDING
				Frame.ScrollFrame:SetHeight(Frame:GetHeight() - (52.5 / NS.Variables.ScaleModifier) - TitleHeight)
			end

			Frame.ScrollFrame:ClearAllPoints()
			Frame.ScrollFrame:SetPoint("BOTTOM", Frame, 0, 65)
		end

		Frame.UpdateScrollIndicator = function()
			if Frame.ScrollFrame:IsVisible() and (Frame.ScrollFrame:GetVerticalScroll() < Frame.ScrollFrame:GetVerticalScrollRange() - 10) then
				Frame.Background.ScrollFrameIndicator:Show()
			elseif QuestProgressScrollFrame:IsVisible() and (QuestProgressScrollFrame:GetVerticalScroll() < QuestProgressScrollFrame:GetVerticalScrollRange() - 10) then
				Frame.Background.ScrollFrameIndicator:Show()
			elseif QuestRewardScrollFrame:IsVisible() and (QuestRewardScrollFrame:GetVerticalScroll() < QuestRewardScrollFrame:GetVerticalScrollRange() - 10) then
				Frame.Background.ScrollFrameIndicator:Show()
			else
				Frame.Background.ScrollFrameIndicator:Hide()
			end
		end
	end

	--------------------------------
	-- FUNCTIONS (NAVIGATION)
	--------------------------------

	do
		Frame.SetChoiceSelected = function()
			NS.Variables.ChoiceSelected = true

			--------------------------------

			Frame.UpdateCompleteButton()
		end

		Frame.ClearChoiceSelected = function()
			QuestInfoFrame.itemChoice = 0

			--------------------------------

			NS.Variables.ChoiceSelected = false

			--------------------------------

			Frame.UpdateCompleteButton()
		end

		Frame.DisableCompleteButton = function()
			Frame.ButtonContainer.CompleteButton:SetEnabled(false)
			Frame.ButtonContainer.CompleteButton:SetAlpha(.5)
		end

		Frame.EnableCompleteButton = function()
			Frame.ButtonContainer.CompleteButton:SetEnabled(true)
			Frame.ButtonContainer.CompleteButton:SetAlpha(1)
		end

		Frame.UpdateCompleteButton = function()
			local IsController = (addon.Input.Variables.IsController or addon.Input.Variables.SimulateController)
			local IsCurrentHighlightedButtonSelected = (addon.Input.Variables.CurrentFrame == NS.Variables.ChoiceSelected)
			local IsCompleteButtonHighlighted = (addon.Input.Variables.CurrentFrame == InteractionQuestFrame.ButtonContainer.CompleteButton)

			local IsRewardSelection = (NS.Variables.Num_Choice > 1 and QuestFrameCompleteQuestButton:IsVisible())
			local IsChoiceSelected = (NS.Variables.ChoiceSelected)

			if (not IsRewardSelection) or (IsRewardSelection and ((not IsController) or (IsController and (IsCurrentHighlightedButtonSelected or IsCompleteButtonHighlighted))) and (IsChoiceSelected)) then
				Frame.EnableCompleteButton()
			else
				Frame.DisableCompleteButton()
			end
		end
	end

	--------------------------------
	-- FUNCTIONS (DATA)
	--------------------------------

	do
		do -- BUTTONS
			do -- GET
				Frame.GetButtons_Choice = function()
					return NS.Variables.Buttons_Choice
				end

				Frame.GetButtons_Reward = function()
					return NS.Variables.Buttons_Reward
				end

				Frame.GetButtons_Spell = function()
					return NS.Variables.Buttons_Spell
				end

				Frame.GetButtons_Required = function()
					return NS.Variables.Buttons_Required
				end
			end

			do -- UPDATE
				Frame.UpdateAllButtonStates = function()
					local numChoices = NS.Variables.Num_Choice
					local numRewards = NS.Variables.Num_Reward
					local numRequired = NS.Variables.Num_Required
					local numSpell = NS.Variables.Num_Spell

					--------------------------------

					for i = 1, numChoices do
						NS.Variables.Buttons_Choice[i].UpdateState()
					end

					for i = 1, numRewards do
						NS.Variables.Buttons_Reward[i].UpdateState()
					end

					for i = 1, numRequired do
						NS.Variables.Buttons_Required[i].UpdateState()
					end

					for i = 1, numSpell do
						NS.Variables.Buttons_Spell[i].UpdateState()
					end
				end
			end
		end

		do -- HIDE
			Frame.HideQuestChoice = function()
				NS.Variables.Num_Choice = 0
				Frame.Rewards_Choice:Hide()

				for i = 1, #Frame.GetButtons_Choice() do
					local CurrentButton = Frame.GetButtons_Choice()[i]

					CurrentButton:Hide()
				end
			end

			Frame.HideReceive = function()
				NS.Variables.Num_Reward = 0
				Frame.Rewards_Receive:Hide()

				for i = 1, #Frame.GetButtons_Reward() do
					local CurrentButton = Frame.GetButtons_Reward()[i]

					CurrentButton:Hide()
				end
			end

			Frame.HideSpell = function()
				NS.Variables.Num_Spell = 0
				Frame.Rewards_Spell:Hide()

				for i = 1, #Frame.GetButtons_Spell() do
					local CurrentButton = Frame.GetButtons_Spell()[i]

					CurrentButton:Hide()
				end
			end

			Frame.HideRequired = function()
				NS.Variables.Num_Required = 0
				Frame.Progress_Header:Hide()

				for i = 1, #Frame.GetButtons_Required() do
					local CurrentButton = Frame.GetButtons_Required()[i]

					CurrentButton:Hide()
				end
			end
		end

		do -- SET
			Frame.SetChoice = function(callbacks)
				NS.Variables.Num_Choice = #callbacks

				--------------------------------

				Frame.Rewards_Choice:Show()

				--------------------------------

				local Buttons = Frame.GetButtons_Choice()

				for i = 1, #Buttons do
					Buttons[i]:Hide()
				end

				for i = 1, NS.Variables.Num_Choice do
					Buttons[i]:Show()
					Buttons[i].Index = i
					Buttons[i].Type = "choice"
					Buttons[i].Callback = callbacks[i]

					--------------------------------

					local CallbackLabelText = _G[callbacks[i]:GetDebugName() .. "Name"]
					local CallbackIcon = _G[callbacks[i]:GetDebugName() .. "IconTexture"]
					local CallbackCountText = _G[callbacks[i]:GetDebugName() .. "Count"]
					local CallbackCount = callbacks[i].count

					--------------------------------

					do -- TEXT
						Buttons[i].Label:SetText(CallbackLabelText:GetText())
					end

					do -- ICON
						if CallbackIcon:GetAtlas() then
							Buttons[i].Image.IconTexture:SetAtlas(CallbackIcon:GetAtlas())
						else
							Buttons[i].Image.IconTexture:SetTexture(CallbackIcon:GetTexture())
						end
					end

					do -- COUNT
						if CallbackCount > 1 then
							Buttons[i].Image.Text:Show()
							Buttons[i].Image.Text.Label:SetTextColor(CallbackCountText:GetTextColor())
							Buttons[i].Image.Text.Label:SetText(CallbackCount)
						else
							Buttons[i].Image.Text:Hide()
							Buttons[i].Image.Text.Label:SetText("")
						end
					end

					do -- STATE
						Buttons[i].SetStateAuto()
					end
				end
			end

			Frame.SetReward = function(callbacks)
				NS.Variables.Num_Reward = #callbacks

				--------------------------------

				Frame.Rewards_Receive:Show()

				--------------------------------

				local Buttons = Frame.GetButtons_Reward()

				for i = 1, #Buttons do
					Buttons[i]:Hide()
				end

				for i = 1, NS.Variables.Num_Reward do
					Buttons[i]:Show()
					Buttons[i].Index = i
					Buttons[i].Type = "reward"
					Buttons[i].Callback = callbacks[i]

					--------------------------------

					local CallbackLabelText = _G[callbacks[i]:GetDebugName() .. "Name"]
					local CallbackIcon = _G[callbacks[i]:GetDebugName() .. "IconTexture"]
					local CallbackCountText = _G[callbacks[i]:GetDebugName() .. "Count"]
					local CallbackCount = callbacks[i].count or 0

					--------------------------------

					do -- TEXT
						Buttons[i].Label:SetText(CallbackLabelText:GetText())
					end

					do -- ICON
						if CallbackIcon:GetAtlas() then
							Buttons[i].Image.IconTexture:SetAtlas(CallbackIcon:GetAtlas())
						else
							Buttons[i].Image.IconTexture:SetTexture(CallbackIcon:GetTexture())
						end
					end

					do -- COUNT
						if CallbackCount > 1 then
							Buttons[i].Image.Text:Show()
							Buttons[i].Image.Text.Label:SetTextColor(CallbackCountText:GetTextColor())
							Buttons[i].Image.Text.Label:SetText(CallbackCount)
						else
							Buttons[i].Image.Text:Hide()
							Buttons[i].Image.Text.Label:SetText("")
						end
					end

					do -- STATE
						Buttons[i].SetStateAuto()
					end
				end
			end

			Frame.SetSpell = function(callbacks)
				NS.Variables.Num_Spell = #callbacks

				--------------------------------

				Frame.Rewards_Spell:Show()

				--------------------------------

				local Buttons = Frame.GetButtons_Spell()

				for i = 1, #Buttons do
					Buttons[i]:Hide()
				end

				for i = 1, NS.Variables.Num_Spell do
					Buttons[i]:Show()
					Buttons[i].Index = i
					Buttons[i].Type = "spell"
					Buttons[i].Callback = callbacks[i]

					--------------------------------

					local CallbackLabelText = callbacks[i].Name
					local CallbackIcon = callbacks[i].Icon
					local CallbackCountText = _G[callbacks[i]:GetDebugName() .. "Count"]
					local CallbackCount = callbacks[i].count

					--------------------------------

					do -- TEXT
						Buttons[i].Label:SetText(CallbackLabelText:GetText())
					end

					do -- ICON
						if CallbackIcon:GetAtlas() then
							Buttons[i].Image.IconTexture:SetAtlas(CallbackIcon:GetAtlas())
						else
							Buttons[i].Image.IconTexture:SetTexture(CallbackIcon:GetTexture())
						end
					end

					do -- COUNT
						if CallbackCount and CallbackCount > 1 then
							Buttons[i].Image.Text:Show()
							Buttons[i].Image.Text.Label:SetTextColor(CallbackCountText:GetTextColor())
							Buttons[i].Image.Text.Label:SetText(CallbackCount)
						else
							Buttons[i].Image.Text:Hide()
							Buttons[i].Image.Text.Label:SetText("")
						end
					end

					do -- STATE
						Buttons[i].SetStateAuto()
					end
				end
			end

			Frame.SetRequired = function(callbacks)
				NS.Variables.Num_Required = #callbacks

				--------------------------------

				Frame.Progress_Header:Show()

				--------------------------------

				local Buttons = Frame.GetButtons_Required()

				for i = 1, #Buttons do
					Buttons[i]:Hide()
				end

				for i = 1, NS.Variables.Num_Required do
					Buttons[i]:Show()
					Buttons[i].Index = i
					Buttons[i].Type = "required"
					Buttons[i].Callback = callbacks[i]

					--------------------------------

					local CallbackLabelText = _G[callbacks[i]:GetDebugName() .. "Name"]
					local CallbackIcon = _G[callbacks[i]:GetDebugName() .. "IconTexture"]
					local CallbackCountText = _G[callbacks[i]:GetDebugName() .. "Count"]
					local CallbackCount = callbacks[i].count

					--------------------------------

					do -- TEXT
						Buttons[i].Label:SetText(CallbackLabelText:GetText())
					end

					do -- ICON
						if CallbackIcon:GetAtlas() then
							Buttons[i].Image.IconTexture:SetAtlas(CallbackIcon:GetAtlas())
						else
							Buttons[i].Image.IconTexture:SetTexture(CallbackIcon:GetTexture())
						end
					end

					do -- COUNT
						if CallbackCount > 1 then
							Buttons[i].Image.Text:Show()
							Buttons[i].Image.Text.Label:SetTextColor(CallbackCountText:GetTextColor())
							Buttons[i].Image.Text.Label:SetText(CallbackCount)
						else
							Buttons[i].Image.Text:Hide()
							Buttons[i].Image.Text.Label:SetText("")
						end
					end

					do -- STATE
						Buttons[i].SetStateAuto()
					end
				end
			end
		end

		do -- DATA
			local function QuestFrame_GetRewards(type)
				local results = {}

				local frame = QuestInfoRewardsFrame
				for f1 = 1, frame:GetNumChildren() do
					local _frameIndex1 = select(f1, frame:GetChildren())

					if AdaptiveAPI:FindString(_frameIndex1:GetDebugName(), "QuestInfoItem") and _frameIndex1:IsVisible() and _frameIndex1:GetPoint() and _frameIndex1.type == type then
						table.insert(results, _frameIndex1)
					end
				end

				return results
			end

			local function QuestFrame_GetRequired()
				local results = {}

				local frame = QuestProgressScrollChildFrame
				for f1 = 1, frame:GetNumChildren() do
					local _frameIndex1 = select(f1, frame:GetChildren())

					if AdaptiveAPI:FindString(_frameIndex1:GetDebugName(), "QuestProgressItem") and not AdaptiveAPI:FindString(_frameIndex1:GetDebugName(), "Highlight") and _frameIndex1:IsVisible() and _frameIndex1.type == "required" then
						table.insert(results, _frameIndex1)
					end
				end

				return results
			end

			local function QuestFrame_GetSpells()
				local title
				local results = {}

				local frame = QuestInfoRewardsFrame
				for f1 = 1, frame:GetNumChildren() do
					local _frameIndex1 = select(f1, frame:GetChildren())

					if AdaptiveAPI:FindString(_frameIndex1:GetDebugName(), "0") and _frameIndex1:IsVisible() then
						table.insert(results, _frameIndex1)
					end
				end
				for f1 = 1, frame:GetNumRegions() do
					local _frameIndex1 = select(f1, frame:GetRegions())

					if AdaptiveAPI:FindString(_frameIndex1:GetDebugName(), "0") and _frameIndex1:IsVisible() then
						title = _frameIndex1
					end
				end

				return title, results
			end

			--------------------------------

			Frame.SetData = function()
				do -- TEXT
					local Title = QuestInfoTitleHeader
					local ProgressTitle = QuestProgressTitleText
					local ObjectivesHeader = QuestInfoObjectivesHeader
					local Objectives = QuestInfoObjectivesText
					local RewardsHeader = QuestInfoRewardsFrame.Header
					local RewardsItemChoose = QuestInfoRewardsFrame.ItemChooseText
					local RewardsItemReceive = QuestInfoRewardsFrame.ItemReceiveText
					local RewardsItemPartySync = (not addon.Variables.IS_CLASSIC and QuestInfoRewardsFrame.QuestSessionBonusReward) or (addon.Variables.IS_CLASSIC and nil)
					local RewardsItemSpell, _ = QuestFrame_GetSpells()
					local ProgressRequireItemHeader = QuestProgressRequiredItemsText
					local StorylineInfo = (not addon.Variables.IS_CLASSIC and C_QuestLine.GetQuestLineInfo(GetQuestID()) and C_QuestLine.GetQuestLineInfo(GetQuestID()).questLineName) or (addon.Variables.IS_CLASSIC and nil)

					local Experience = GetRewardXP()
					local ExperiencePercentage = string.format("%.2f%%", tostring((GetRewardXP() / UnitXPMax("player")) * 100))
					local Gold, Silver, Copper = AdaptiveAPI:FormatMoney(GetRewardMoney())
					local Honor = GetRewardHonor()

					--------------------------------

					do -- TEXT (STORYLINE)
						Frame.Storyline:SetShown(StorylineInfo and not ProgressTitle:IsVisible())

						--------------------------------

						if StorylineInfo then
							Frame.Storyline.Content.Text:SetText(StorylineInfo)
						end
					end

					do -- TEXT (TITLE)
						if not ProgressTitle:IsVisible() then
							Frame.Title:SetShown(Title:IsVisible())

							--------------------------------

							if Title:IsVisible() then
								Frame.Title:SetText(AdaptiveAPI:RemoveAtlasMarkup(Title:GetText(), true))

								--------------------------------

								Frame.Title:ClearAllPoints()
								if StorylineInfo then
									Frame.Title:SetPoint("TOPLEFT", Frame, 55, -NS.Variables:RATIO(7))
								else
									Frame.Title:SetPoint("TOPLEFT", Frame, 55, -NS.Variables:RATIO(7))
								end
							end
						else
							Frame.Title:SetShown(ProgressTitle:IsVisible())

							--------------------------------

							Frame.Title:SetText(AdaptiveAPI:RemoveAtlasMarkup(ProgressTitle:GetText(), true))

							--------------------------------

							Frame.Title:ClearAllPoints()
							if StorylineInfo then
								Frame.Title:SetPoint("TOPLEFT", Frame, 55, -NS.Variables:RATIO(7))
							else
								Frame.Title:SetPoint("TOPLEFT", Frame, 55, -NS.Variables:RATIO(7))
							end
						end
					end

					do -- TEXT (OBJECTIVES)
						Frame.Objectives_Header:SetShown(ObjectivesHeader:IsVisible())
						Frame.Objectives_Text:SetShown(Objectives:IsVisible())

						--------------------------------

						if ObjectivesHeader:IsVisible() then
							Frame.Objectives_Text:SetText(Objectives:GetText())
						end
					end

					do -- REWARDS
						do -- HEADER
							Frame.Rewards_Header:SetShown(RewardsHeader:IsVisible() and not ProgressTitle:IsVisible())
						end

						do -- EXPERIENCE
							Frame.Rewards_Experience:SetShown(Experience > 0 and not ProgressTitle:IsVisible())

							--------------------------------

							if Experience > 0 then
								Frame.Rewards_Experience.Text:SetText(AdaptiveAPI:InlineIcon(addon.Variables.PATH .. "Art/Icons/xp.png", 25, 25, 0, 0) .. " " .. AdaptiveAPI:FormatNumber(Experience) .. " " .. "(" .. ExperiencePercentage .. ")")
							end
						end

						do -- CURRENCY
							Frame.Rewards_Currency:SetShown(GetRewardMoney() > 0 and not ProgressTitle:IsVisible())

							--------------------------------

							if GetRewardMoney() > 0 then
								local gold, silver, copper

								--------------------------------

								if Gold > 0 then
									gold = AdaptiveAPI:InlineIcon(addon.Variables.PATH .. "Art/Icons/gold.png", 20, 20, 0, 0) .. " " .. "|cffEBD596" .. Gold .. "|r" .. " "
								end

								if Silver > 0 then
									silver = AdaptiveAPI:InlineIcon(addon.Variables.PATH .. "Art/Icons/silver.png", 20, 20, 0, 0) .. " " .. "|cffC6C6C6" .. Silver .. "|r" .. " "
								end

								if Copper > 0 then
									copper = AdaptiveAPI:InlineIcon(addon.Variables.PATH .. "Art/Icons/copper.png", 20, 20, 0, 0) .. " " .. "|cffD9AC86" .. Copper .. "|r" .. " "
								end

								--------------------------------

								Frame.Rewards_Currency.Text:SetText((gold or "") .. (silver or "") .. (copper or ""))
							end
						end

						do -- HONOR
							Frame.Rewards_Honor:SetShown(Honor > 0 and not ProgressTitle:IsVisible())

							--------------------------------

							if Honor > 0 then
								Frame.Rewards_Honor.Text:SetText(AdaptiveAPI:InlineIcon(addon.Variables.PATH .. "Art/Icons/honor.png", 25, 25, 0, 0) .. " " .. "|cffD7B473" .. Honor .. "|r")
							end
						end

						do -- CHOICE
							Frame.Rewards_Choice:SetShown(RewardsItemChoose:IsVisible())

							--------------------------------

							Frame.Rewards_Choice:SetText(RewardsItemChoose:GetText())
						end

						do -- RECIEVE
							Frame.Rewards_Receive:SetShown(RewardsItemPartySync and RewardsItemPartySync:IsVisible() or RewardsItemReceive:IsVisible())

							--------------------------------

							if RewardsItemPartySync and RewardsItemPartySync:IsVisible() then
								Frame.Rewards_Receive:SetText(RewardsItemPartySync:GetText())
							else
								Frame.Rewards_Receive:SetText(RewardsItemReceive:GetText())
							end
						end

						do -- SPELL
							Frame.Rewards_Spell:SetShown(RewardsItemSpell and RewardsItemSpell:IsVisible())

							--------------------------------

							if RewardsItemSpell then
								Frame.Rewards_Spell:SetText(RewardsItemSpell:GetText())
							end
						end

						do -- PROGRESS
							Frame.Progress_Header:SetShown(ProgressRequireItemHeader:IsVisible())
						end
					end
				end

				do -- CONTEXT ICON
					local ContextIcon = addon.ContextIcon.Script:GetContextIcon()

					--------------------------------

					Frame.ContextIcon.Label:SetText(ContextIcon)
				end

				do -- REWARDS
					local choices = QuestFrame_GetRewards("choice")
					local reward = QuestFrame_GetRewards("reward")
					local _, spells = QuestFrame_GetSpells()
					local required = QuestFrame_GetRequired()

					--------------------------------

					if #choices >= 1 then
						Frame.SetChoice(choices)
					else
						Frame.HideQuestChoice()
					end

					if #reward >= 1 then
						Frame.SetReward(reward)
					else
						Frame.HideReceive()
					end

					if #spells >= 1 then
						Frame.SetSpell(spells)
					else
						Frame.HideSpell()
					end

					if #required >= 1 then
						Frame.SetRequired(required)
					else
						Frame.HideRequired()
					end

					--------------------------------

					Frame.SetQuality()
					Frame.UpdateAllButtonStates()
				end

				do -- BUTTONS
					local CompleteButton = QuestFrameCompleteQuestButton
					local ContinueButton = QuestFrameCompleteButton
					local AcceptButton = QuestFrameAcceptButton
					local DeclineButton = QuestFrameDeclineButton
					local GoodbyeButton = QuestFrameGoodbyeButton

					-- Can't seem to query if the quest log is full - C_QuestLog.GetNumQuestWatches() returns values
					-- higher than C_QuestLog.GetMaxNumQuestsCanAccept() even though it is still within the limit?
					local QuestLogFull = false -- (select(2, C_QuestLog.GetNumQuestWatches()) >= C_QuestLog.GetMaxNumQuestsCanAccept())
					local IsAutoAccept = addon.API:IsAutoAccept()

					--------------------------------

					AdaptiveAPI:SetVisibility(Frame.ButtonContainer.CompleteButton, CompleteButton:IsVisible())
					AdaptiveAPI:SetVisibility(Frame.ButtonContainer.ContinueButton, ContinueButton:IsVisible() and ContinueButton:IsEnabled())
					AdaptiveAPI:SetVisibility(Frame.ButtonContainer.AcceptButton, AcceptButton:IsVisible())
					AdaptiveAPI:SetVisibility(Frame.ButtonContainer.DeclineButton, DeclineButton:IsVisible())
					AdaptiveAPI:SetVisibility(Frame.ButtonContainer.GoodbyeButton, not DeclineButton:IsVisible())

					--------------------------------

					Frame.ButtonContainer.CompleteButton:SetEnabled(CompleteButton:IsEnabled())
					Frame.ButtonContainer.ContinueButton:SetEnabled(ContinueButton:IsEnabled())
					Frame.ButtonContainer.AcceptButton:SetEnabled(not QuestLogFull)
					Frame.ButtonContainer.DeclineButton:SetEnabled(true)
					Frame.ButtonContainer.GoodbyeButton:SetEnabled(true)

					--------------------------------

					local function SetButtonText(frame, text, keybindVariable)
						frame:SetText(text)

						--------------------------------

						do -- ACCEPT
							if frame == Frame.ButtonContainer.AcceptButton then
								if QuestLogFull then
									frame:SetText(L["InteractionQuestFrame - Accept - Quest Log Full"])
								end

								if IsAutoAccept then
									frame:SetText(L["InteractionQuestFrame - Accept - Auto Accept"])
								end

								--------------------------------

								frame:SetEnabled(not QuestLogFull and not IsAutoAccept)
							end
						end

						do -- GOODBYE
							if frame == Frame.ButtonContainer.GoodbyeButton then
								if IsAutoAccept then
									frame:SetText(L["InteractionQuestFrame - Goodbye - Auto Accept"])
									keybindVariable = addon.Input.Variables:GetKeybindForPlatform(addon.Input.Variables.Key_Progress)
								end
							end
						end

						--------------------------------

						if frame:IsEnabled() then
							addon.API:SetButtonToPlatform(frame, frame.Text, keybindVariable)
						else
							addon.API:SetButtonToPlatform(frame, frame.Text, "")
						end
					end

					if ContinueButton:IsEnabled() then
						SetButtonText(Frame.ButtonContainer.ContinueButton, L["InteractionQuestFrame - Continue"], addon.Input.Variables:GetKeybindForPlatform(addon.Input.Variables.Key_Progress))
					else
						SetButtonText(Frame.ButtonContainer.ContinueButton, L["InteractionQuestFrame - In Progress"], addon.Input.Variables:GetKeybindForPlatform(addon.Input.Variables.Key_Progress))
					end

					SetButtonText(Frame.ButtonContainer.CompleteButton, L["InteractionQuestFrame - Complete"], addon.Input.Variables:GetKeybindForPlatform(addon.Input.Variables.Key_Progress))
					SetButtonText(Frame.ButtonContainer.AcceptButton, L["InteractionQuestFrame - Accept"], addon.Input.Variables:GetKeybindForPlatform(addon.Input.Variables.Key_Progress))
					SetButtonText(Frame.ButtonContainer.DeclineButton, L["InteractionQuestFrame - Decline"], addon.Input.Variables:GetKeybindForPlatform(addon.Input.Variables.Key_Close))
					SetButtonText(Frame.ButtonContainer.GoodbyeButton, L["InteractionQuestFrame - Goodbye"], addon.Input.Variables:GetKeybindForPlatform(addon.Input.Variables.Key_Close))
				end

				--------------------------------

				CallbackRegistry:Trigger("QUEST_DATA_LOADED")

				--------------------------------

				Frame.ScrollChildFrame.UpdateLayout()
				Frame.UpdateCompleteButton()

				--------------------------------

				CallbackRegistry:Trigger("QUEST_DATA_READY")

				--------------------------------

				addon.Libraries.AceTimer:ScheduleTimer(Frame.UpdateAll, .1)
			end
		end

		do -- QUALITY
			local TYPE_ITEM = 0
			local TYPE_CURRENCY = 1

			local itemIndex = 1
			local currencyIndex = 1

			--------------------------------

			local function GetQuestItem(type)
				local name, texture, count, quality, isUsable, itemID = GetQuestItemInfo(type, itemIndex)

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
					if not addon.Variables.IS_CLASSIC then -- Retail
						local currencyInfo = C_QuestOffer.GetQuestRewardCurrencyInfo(type, currencyIndex)

						--------------------------------

						if currencyInfo then
							quality = currencyInfo.quality
						end
					else -- Classic
						local currencyInfo = GetQuestCurrencyInfo(type, currencyIndex)

						--------------------------------

						if currencyInfo then
							quality = currencyInfo.quality
						end
					end
				elseif type == "required" then
					if not addon.Variables.IS_CLASSIC then -- Retail
						local currencyInfo = C_QuestOffer.GetQuestRequiredCurrencyInfo(type, currencyIndex)

						--------------------------------

						if currencyInfo then
							quality = currencyInfo.quality
						end
					else -- Classic
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
				local questItemInfoType = GetQuestItemInfoLootType and GetQuestItemInfoLootType(type, index) or 0
				local resultQuality

				--------------------------------

				if questItemInfoType == TYPE_ITEM then
					local name, _, _, quality, _, _ = GetQuestItem(type)
					resultQuality = quality

					--------------------------------

					if #name <= 1 then
						resultQuality = GetQuestCurrency(type)
					end

					--------------------------------

					return resultQuality
				end

				if questItemInfoType == TYPE_CURRENCY then
					resultQuality = GetQuestCurrency(type)

					--------------------------------

					return resultQuality
				end
			end

			local function ResetIndex()
				itemIndex = 1
				currencyIndex = 1
			end

			--------------------------------

			Frame.SetQuality = function()
				local numChoices = NS.Variables.Num_Choice
				local numRewards = NS.Variables.Num_Reward
				local numRequired = NS.Variables.Num_Required

				--------------------------------

				do -- CHOICES
					ResetIndex()
					for i = 1, numChoices do
						NS.Variables.Buttons_Choice[i].Quality = ParseType("choice", i)
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
		Frame.ShowWithAnimation = function()
			if not Frame.hidden then
				return
			end
			Frame.hidden = false

			addon.Libraries.AceTimer:ScheduleTimer(function()
				if not Frame.hidden then
					Frame:Show()
				end
			end, .075)

			--------------------------------

			Frame.animation = true

			addon.Libraries.AceTimer:ScheduleTimer(function()
				if not Frame.hidden then
					Frame.animation = false
				end
			end, .175)

			--------------------------------

			Frame.ScrollFrame:SetVerticalScroll(0)

			--------------------------------

			Frame:SetAlpha(0)
			Frame.Background:SetAlpha(0)
			Frame.Title:SetAlpha(0)
			Frame.Storyline:SetAlpha(0)
			Frame.ScrollFrame:SetAlpha(0)
			Frame.ScrollFrame:Hide()
			Frame.ButtonContainer:SetAlpha(0)
			Frame.ButtonContainer:Hide()

			--------------------------------

			AdaptiveAPI.Animation:Fade(Frame, .25, 0, 1, nil, function() return Frame.hidden end)
			AdaptiveAPI.Animation:Fade(Frame.ContextIcon.Label, .5, 0, 1, nil, function() return Frame.hidden end)
			AdaptiveAPI.Animation:Scale(Frame.ContextIcon, .5, 10, 1, nil, AdaptiveAPI.Animation.EaseExpo, function() return Frame.hidden end)

			addon.Libraries.AceTimer:ScheduleTimer(function()
				AdaptiveAPI.Animation:Fade(Frame.Background, .375, 0, 1, nil, function() return Frame.hidden end)
			end, .175)

			addon.Libraries.AceTimer:ScheduleTimer(function()
				if not Frame.hidden then
					AdaptiveAPI.Animation:Fade(Frame.Title, .375, 0, .75, nil, function() return Frame.hidden end)

					if Frame.Storyline:IsShown() then
						AdaptiveAPI.Animation:Fade(Frame.Storyline, .375, 0, .5, nil, function() return Frame.hidden end)
					end

					--------------------------------

					Frame.ScrollFrame:Hide()
					Frame.ScrollChildFrame.UpdateLayout()

					--------------------------------

					addon.Libraries.AceTimer:ScheduleTimer(function()
						if not Frame.hidden then
							AdaptiveAPI.Animation:Fade(Frame.ScrollFrame, .375, 0, 1, nil, function() return Frame.hidden end)

							--------------------------------

							addon.Libraries.AceTimer:ScheduleTimer(function()
								Frame.ScrollFrame:Show()
							end, 0)
						end
					end, .05)

					addon.Libraries.AceTimer:ScheduleTimer(function()
						if not Frame.hidden then
							AdaptiveAPI.Animation:Fade(Frame.ButtonContainer, .5, 0, 1, AdaptiveAPI.Animation.EaseSine, function() return Frame.hidden end)

							--------------------------------

							addon.Libraries.AceTimer:ScheduleTimer(function()
								Frame.ButtonContainer:Show()
							end, 0)
						end
					end, .125)
				end
			end, .125)

			addon.Libraries.AceTimer:ScheduleTimer(function()
				if not Frame.hidden then
					Frame.SetData()
				end
			end, .025)

			--------------------------------

			addon.SoundEffects:PlaySoundFile(addon.SoundEffects.Quest_Show)
		end

		Frame.HideWithAnimation = function(stopSession)
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

			AdaptiveAPI.Animation:Fade(Frame, .25, Frame:GetAlpha(), 0, nil, function() return not Frame.hidden end)
			AdaptiveAPI.Animation:Fade(Frame.ContextIcon.Label, .175, Frame.ContextIcon.Label:GetAlpha(), 0, nil, function() return not Frame.hidden end)
			AdaptiveAPI.Animation:Scale(Frame.ContextIcon, 2.5, Frame.ContextIcon:GetScale(), 3.75, nil, AdaptiveAPI.Animation.EaseExpo, function() return not Frame.hidden end)

			--------------------------------

			addon.Libraries.AceTimer:ScheduleTimer(function()
				addon.BlizzardGameTooltip.Script:StopCustom()
			end, .375)

			--------------------------------

			if stopSession then
				addon.Interaction.Script:Stop(true)
			end

			--------------------------------

			CallbackRegistry:Trigger("STOP_QUEST")

			--------------------------------

			addon.SoundEffects:PlaySoundFile(addon.SoundEffects.Quest_Hide)
		end
	end

	--------------------------------
	-- FUNCTIONS (GAME-TOOLTIP)
	--------------------------------

	do
		InteractionQuestFrame.UpdateGameTooltip = function()
			local IsRewardButton = (GameTooltip.RewardButton)
			local IsFrame = (Frame:IsVisible())

			if IsFrame and IsRewardButton then
				GameTooltip.reward = true
				GameTooltip.bypass = true

				addon.BlizzardGameTooltip.Script:StartCustom()

				GameTooltip:SetAnchorType("ANCHOR_NONE")
				GameTooltip:ClearAllPoints()
				GameTooltip:SetPoint("TOP", GameTooltip.RewardButton, 0, GameTooltip:GetHeight() + 12.5)
			elseif not IsFrame and GameTooltip.reward then
				GameTooltip.reward = false
				GameTooltip.bypass = false

				GameTooltip:Hide()
			end
		end
	end

	--------------------------------
	-- FUNCTIONS (FOCUS)
	--------------------------------

	do
		function Frame.Enter()
			Frame.mouseOver = true

			--------------------------------

			Frame.UpdateFocus()
		end

		function Frame.Leave()
			Frame.mouseOver = false

			--------------------------------

			Frame.UpdateFocus()
		end

		function Frame.UpdateFocus()
			if not addon.Input.Variables.IsController then
				local IsMouseOver = (Frame.mouseOver)
				local IsInDialog = (not InteractionDialogFrame.hidden)

				--------------------------------

				if IsInDialog and not IsMouseOver then
					Frame.focused = false
				else
					Frame.focused = true
				end

				--------------------------------

				if Frame.focused then
					AdaptiveAPI.Animation:Fade(InteractionQuestParent, .25, InteractionQuestParent:GetAlpha(), 1, nil, function() return not Frame.focused end)
				else
					AdaptiveAPI.Animation:Fade(InteractionQuestParent, .25, InteractionQuestParent:GetAlpha(), 1, nil, function() return Frame.focused end)
				end
			else
				InteractionQuestParent:SetAlpha(1)
			end
		end

		AdaptiveAPI.FrameTemplates:CreateMouseResponder(Frame, Frame.Enter, Frame.Leave, nil, nil, { x = 175, y = 175 })

		CallbackRegistry:Add("START_DIALOG", Frame.UpdateFocus, 0)
		CallbackRegistry:Add("STOP_DIALOG", Frame.UpdateFocus, 0)
	end

	--------------------------------
	-- SETTINGS
	--------------------------------

	do
		local function Settings_ThemeUpdate()
			if Frame:IsVisible() then
				Frame.UpdateWarbandHeader()
			end
		end
		Settings_ThemeUpdate()

		local function Settings_UIDirection()
			local Settings_UIDirection = INTDB.profile.INT_UIDIRECTION

			local offsetY = 0
			local screenWidth = addon.API:GetScreenWidth()
			local frameWidth = Frame:GetWidth()
			local dialogMaxWidth = 350
			local quarterWidth = (screenWidth - dialogMaxWidth) / 2
			local quarterEdgePadding = (quarterWidth - frameWidth) / 2
			local offsetX

			-- 1 -> LEFT
			-- 2 -> RIGHT

			Frame:ClearAllPoints()
			if Settings_UIDirection == 1 then
				if QuestModelScene and QuestModelScene:IsVisible() then
					offsetX = quarterEdgePadding

					--------------------------------

					Frame:SetPoint("LEFT", UIParent, quarterEdgePadding + InteractionQuestFrame.Target:GetWidth(), offsetY)
				else
					offsetX = quarterEdgePadding

					--------------------------------

					Frame:SetPoint("LEFT", UIParent, quarterEdgePadding, offsetY)
				end
			else
				offsetX = screenWidth - frameWidth - quarterEdgePadding

				--------------------------------

				Frame:SetPoint("LEFT", UIParent, offsetX, offsetY)
			end
		end
		Settings_UIDirection()

		local function Settings_QuestFrameSize()
			local presetSizeModifier = {
				[1] = .75,
				[2] = .875,
				[3] = 1,
				[4] = 1.125,
			}
			local presetWidthModifier = {
				[1] = .825,
				[2] = .75,
				[3] = .75,
				[4] = .75,
			}

			local widthModifier = presetWidthModifier[INTDB.profile.INT_QUESTFRAME_SIZE]
			local sizeModifier = presetSizeModifier[INTDB.profile.INT_QUESTFRAME_SIZE]
			local defaultSize = { x = 625 * widthModifier, y = 625 }
			local targetSize = { x = defaultSize.x * sizeModifier, y = defaultSize.y * sizeModifier }

			--------------------------------

			NS.Variables:UpdateScaleModifier(targetSize.x)
			Frame:SetSize(targetSize.x, targetSize.y)

			--------------------------------

			if not Frame.hidden then
				Frame.SetData() -- Refresh Formatting
				Settings_UIDirection() -- Refresh Position
			end
		end
		Settings_QuestFrameSize()

		--------------------------------

		CallbackRegistry:Add("THEME_UPDATE", Settings_ThemeUpdate, 10)
		CallbackRegistry:Add("SETTINGS_UIDIRECTION_CHANGED", Settings_UIDirection, 0)
		CallbackRegistry:Add("BLIZZARD_SETTINGS_RESOLUTION_CHANGED", Settings_UIDirection, 0)
		CallbackRegistry:Add("START_QUEST", Settings_UIDirection, 0)
		CallbackRegistry:Add("SETTINGS_QUESTFRAME_SIZE_CHANGED", Settings_QuestFrameSize, 0)

		if QuestModelScene then -- Fix for Classic Era
			hooksecurefunc(QuestModelScene, "Show", Settings_UIDirection)
		end
	end

	function UpdateScale(modifier)
		INTDB.profile.INT_QUESTFRAME_SIZE = modifier

		--------------------------------

		CallbackRegistry:Trigger("QUEST_FRAME_SIZE_CHANGED")
	end

	--------------------------------
	-- EVENTS
	--------------------------------

	do
		CallbackRegistry:Add("QUEST_DATA_LOADED", function()
			Frame.UpdateAll()
		end, 5)

		CallbackRegistry:Add("INPUT_NAVIGATION_HIGHLIGHTED", function()
			Frame.UpdateCompleteButton()
		end, 0)

		--------------------------------

		Frame:SetScript("OnMouseUp", function(self, button)
			if INTDB.profile.INT_FLIPMOUSE == false and button == "RightButton" then
				InteractionDialogFrame.ReturnToPreviousDialog()
			elseif INTDB.profile.INT_FLIPMOUSE == true and button == "LeftButton" then
				InteractionDialogFrame.ReturnToPreviousDialog()
			end
		end)

		hooksecurefunc(Frame, "Show", function()
			CallbackRegistry:Trigger("START_QUEST")

			--------------------------------

			Frame.ClearChoiceSelected()
		end)

		hooksecurefunc(Frame, "Hide", function()
			CallbackRegistry:Trigger("STOP_QUEST")

			--------------------------------

			Frame.ClearChoiceSelected()
			InteractionQuestFrame.UpdateGameTooltip()
		end)

		hooksecurefunc(Frame.ScrollFrame, "SetVerticalScroll", function()
			Frame.UpdateScrollIndicator()
		end)
	end

	--------------------------------
	-- SETUP
	--------------------------------
end
