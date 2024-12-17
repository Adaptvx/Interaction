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
			Frame.HideWithAnimation(true)

			--------------------------------

			addon.Libraries.AceTimer:ScheduleTimer(function()
				AcceptQuest()
			end, .35)
		end)

		Frame.ButtonContainer.ContinueButton:SetScript("OnClick", function()
			Frame.HideWithAnimation(true)

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

			Frame.HideWithAnimation(true)

			--------------------------------

			addon.Libraries.AceTimer:ScheduleTimer(function()
				GetQuestReward(choiceIndex)
			end, .35)
		end)

		Frame.ButtonContainer.DeclineButton:SetScript("OnClick", function()
			Frame.HideWithAnimation()
		end)

		Frame.ButtonContainer.GoodbyeButton:SetScript("OnClick", function()
			Frame.HideWithAnimation()
		end)
	end

	--------------------------------
	-- FUNCTIONS (FRAME)
	--------------------------------

	do
		Frame.UpdateVisibility = function()
			local IsReady = addon.Initialize.Ready
			if not IsReady then
				return
			end

			--------------------------------

			local IsFinishedDialog = (addon.Interaction.Dialog.Variables.Finished)
			local IsGossip = (GossipFrame:IsVisible() or QuestFrameGreetingPanel:IsVisible())
			local IsQuest = (QuestFrame:IsVisible() and not QuestFrameGreetingPanel:IsVisible())
			local IsHidden = (Frame.hidden)

			--------------------------------

			if INTDB.profile.INT_ALWAYS_SHOW_QUEST then
				if IsQuest and not IsGossip and IsHidden then
					Frame.ShowWithAnimation()
				end
			else
				if IsQuest and not IsGossip and IsFinishedDialog and IsHidden then
					Frame.ShowWithAnimation()
				end
			end

			if not IsQuest and not IsHidden then
				Frame.HideWithAnimation()
			end
		end

		Frame.UpdateWarbandHeader = function()
			local WarbandCompleted = C_QuestLog.IsQuestFlaggedCompletedOnAccount and C_QuestLog.IsQuestFlaggedCompletedOnAccount(GetQuestID()) or false

			--------------------------------

			if WarbandCompleted then
				AdaptiveAPI:AddTooltip(Frame.TitleHeader, ACCOUNT_COMPLETED_QUEST_NOTICE, "ANCHOR_TOP", 0, -47.5, true)
			else
				AdaptiveAPI:RemoveTooltip(Frame.TitleHeader)
			end

			--------------------------------

			local Texture

			if addon.Theme.IsDarkTheme then
				if WarbandCompleted then
					Texture = NS.Variables.QUEST_PATH .. "header-complete-dark-mode.png"
				else
					Texture = NS.Variables.QUEST_PATH .. "header-dark-mode.png"
				end
			else
				if WarbandCompleted then
					Texture = NS.Variables.QUEST_PATH .. "header-complete-light-mode.png"
				else
					Texture = NS.Variables.QUEST_PATH .. "header-light-mode.png"
				end
			end

			Frame.TitleHeaderTexture:SetTexture(Texture)
		end

		Frame.UpdateScrollFrameFormat = function()
			if not Frame.Title then return end

			if Frame.Storyline:IsVisible() then
				local TitleHeight = Frame.Title:GetStringHeight() + Frame.TitleHeader:GetHeight() + NS.Variables.PADDING
				Frame.ScrollFrame:SetHeight(Frame:GetHeight() - 70 - TitleHeight)
			else
				local TitleHeight = Frame.Title:GetStringHeight() + Frame.TitleHeader:GetHeight() + NS.Variables.PADDING
				Frame.ScrollFrame:SetHeight(Frame:GetHeight() - 52.5 - TitleHeight)
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
		Frame.SetChoiceSelected = function(frame)
			NS.Variables.ChoiceSelected = frame

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

			local IsRewardSelection = (NS.Variables.NumChoices > 1 and QuestFrameCompleteQuestButton:IsVisible())
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
		Frame.GetChoiceButtons = function()
			return NS.Variables.ChoiceButtons
		end

		Frame.GetReceiveButtons = function()
			return NS.Variables.ReceiveButtons
		end

		Frame.GetSpellButtons = function()
			return NS.Variables.SpellButtons
		end

		Frame.GetRequireItemButtons = function()
			return NS.Variables.RequireItemButtons
		end

		--------------------------------

		Frame.HideQuestChoice = function()
			NS.Variables.NumChoices = 0
			Frame.Rewards_Choice:Hide()

			for i = 1, #Frame.GetChoiceButtons() do
				local CurrentButton = Frame.GetChoiceButtons()[i]

				CurrentButton:Hide()
			end
		end

		Frame.HideReceive = function()
			NS.Variables.NumReceive = 0
			Frame.Rewards_Receive:Hide()

			for i = 1, #Frame.GetReceiveButtons() do
				local CurrentButton = Frame.GetReceiveButtons()[i]

				CurrentButton:Hide()
			end
		end

		Frame.HideSpell = function()
			NS.Variables.NumSpell = 0
			Frame.Rewards_Spell:Hide()

			for i = 1, #Frame.GetSpellButtons() do
				local CurrentButton = Frame.GetSpellButtons()[i]

				CurrentButton:Hide()
			end
		end

		Frame.HideRequireItems = function()
			NS.Variables.NumRequireItem = 0
			Frame.Progress_Header:Hide()

			for i = 1, #Frame.GetRequireItemButtons() do
				local CurrentButton = Frame.GetRequireItemButtons()[i]

				CurrentButton:Hide()
			end
		end

		--------------------------------

		Frame.SetChoice = function(callbacks)
			NS.Variables.NumChoices = #callbacks

			--------------------------------

			Frame.Rewards_Choice:Show()

			--------------------------------

			local Buttons = Frame.GetChoiceButtons()

			for i = 1, #Buttons do
				Buttons[i]:Hide()
			end

			for i = 1, NS.Variables.NumChoices do
				Buttons[i]:Show()
				Buttons[i].Index = i
				Buttons[i].Type = "choice"
				Buttons[i].Callback = callbacks[i]

				--------------------------------

				local CallbackLabelText = _G[callbacks[i]:GetDebugName() .. "Name"]
				local CallbackContextIcon = callbacks[i].QuestRewardContextIcon
				local CallbackIcon = _G[callbacks[i]:GetDebugName() .. "IconTexture"]
				local CallbackCountText = _G[callbacks[i]:GetDebugName() .. "Count"]
				local CallbackCount = callbacks[i].count

				--------------------------------

				local function Text()
					if CallbackContextIcon and CallbackContextIcon:IsVisible() then
						if CallbackContextIcon:GetAtlas() then
							Buttons[i].Label:SetText(AdaptiveAPI:InlineIcon(CallbackContextIcon:GetAtlas(), 15, 15, 0, 0, "Atlas") .. " " .. CallbackLabelText:GetText())
						else
							Buttons[i].Label:SetText(AdaptiveAPI:InlineIcon(CallbackContextIcon:GetTexture(), 15, 15, 0, 0, "|T") .. " " .. CallbackLabelText:GetText())
						end
					else
						Buttons[i].Label:SetText(CallbackLabelText:GetText())
					end
				end

				local function Icon()
					if CallbackIcon:GetAtlas() then
						Buttons[i].Image.IconTexture:SetAtlas(CallbackIcon:GetAtlas())
					else
						Buttons[i].Image.IconTexture:SetTexture(CallbackIcon:GetTexture())
					end
				end

				local function Count()
					if CallbackCount > 1 then
						Buttons[i].Image.LabelFrame:Show()
						Buttons[i].Image.LabelFrame.Label:SetTextColor(CallbackCountText:GetTextColor())
						Buttons[i].Image.LabelFrame.Label:SetText(CallbackCount)
					else
						Buttons[i].Image.LabelFrame:Hide()
						Buttons[i].Image.LabelFrame.Label:SetText("")
					end
				end

				local function State()
					Buttons[i].SetStateAuto()
				end

				--------------------------------

				Text()
				Icon()
				Count()
				State()
			end
		end

		Frame.SetReceive = function(callbacks)
			NS.Variables.NumReceive = #callbacks

			--------------------------------

			Frame.Rewards_Receive:Show()

			--------------------------------

			local Buttons = Frame.GetReceiveButtons()

			for i = 1, #Buttons do
				Buttons[i]:Hide()
			end

			for i = 1, NS.Variables.NumReceive do
				Buttons[i]:Show()
				Buttons[i].Index = i
				Buttons[i].Type = "reward"
				Buttons[i].Callback = callbacks[i]

				--------------------------------

				local CallbackLabelText = _G[callbacks[i]:GetDebugName() .. "Name"]
				local CallbackContextIcon = callbacks[i].QuestRewardContextIcon
				local CallbackIcon = _G[callbacks[i]:GetDebugName() .. "IconTexture"]
				local CallbackCountText = _G[callbacks[i]:GetDebugName() .. "Count"]
				local CallbackCount = callbacks[i].count or 0

				--------------------------------

				local function Text()
					if CallbackContextIcon and CallbackContextIcon:IsVisible() then
						if CallbackContextIcon:GetAtlas() then
							Buttons[i].Label:SetText(AdaptiveAPI:InlineIcon(CallbackContextIcon:GetAtlas(), 15, 15, 0, 0, "Atlas") .. " " .. CallbackLabelText:GetText())
						else
							Buttons[i].Label:SetText(AdaptiveAPI:InlineIcon(CallbackContextIcon:GetTexture(), 15, 15, 0, 0, "|T") .. " " .. CallbackLabelText:GetText())
						end
					else
						Buttons[i].Label:SetText(CallbackLabelText:GetText())
					end
				end

				local function Icon()
					if CallbackIcon:GetAtlas() then
						Buttons[i].Image.IconTexture:SetAtlas(CallbackIcon:GetAtlas())
					else
						Buttons[i].Image.IconTexture:SetTexture(CallbackIcon:GetTexture())
					end
				end

				local function Count()
					if CallbackCount > 1 then
						Buttons[i].Image.LabelFrame:Show()
						Buttons[i].Image.LabelFrame.Label:SetTextColor(CallbackCountText:GetTextColor())
						Buttons[i].Image.LabelFrame.Label:SetText(CallbackCount)
					else
						Buttons[i].Image.LabelFrame:Hide()
						Buttons[i].Image.LabelFrame.Label:SetText("")
					end
				end

				local function State()
					Buttons[i].SetStateAuto()
				end

				--------------------------------

				Text()
				Icon()
				Count()
				State()
			end
		end

		Frame.SetSpell = function(callbacks)
			NS.Variables.NumSpell = #callbacks

			--------------------------------

			Frame.Rewards_Spell:Show()

			--------------------------------

			local Buttons = Frame.GetSpellButtons()

			for i = 1, #Buttons do
				Buttons[i]:Hide()
			end

			for i = 1, NS.Variables.NumSpell do
				Buttons[i]:Show()
				Buttons[i].Index = i
				Buttons[i].Type = "spell"
				Buttons[i].Callback = callbacks[i]

				--------------------------------

				local CallbackLabelText = callbacks[i].Name
				local CallbackContextIcon = callbacks[i].QuestRewardContextIcon
				local CallbackIcon = callbacks[i].Icon
				local CallbackCountText = _G[callbacks[i]:GetDebugName() .. "Count"]
				local CallbackCount = callbacks[i].count

				--------------------------------

				local function Text()
					if CallbackContextIcon and CallbackContextIcon:IsVisible() then
						if CallbackContextIcon:GetAtlas() then
							Buttons[i].Label:SetText(AdaptiveAPI:InlineIcon(CallbackContextIcon:GetAtlas(), 15, 15, 0, 0, "Atlas") .. " " .. CallbackLabelText:GetText())
						else
							Buttons[i].Label:SetText(AdaptiveAPI:InlineIcon(CallbackContextIcon:GetTexture(), 15, 15, 0, 0, "|T") .. " " .. CallbackLabelText:GetText())
						end
					else
						Buttons[i].Label:SetText(CallbackLabelText:GetText())
					end
				end

				local function Icon()
					if CallbackIcon:GetAtlas() then
						Buttons[i].Image.IconTexture:SetAtlas(CallbackIcon:GetAtlas())
					else
						Buttons[i].Image.IconTexture:SetTexture(CallbackIcon:GetTexture())
					end
				end

				local function Count()
					if CallbackCount and CallbackCount > 1 then
						Buttons[i].Image.LabelFrame:Show()
						Buttons[i].Image.LabelFrame.Label:SetTextColor(CallbackCountText:GetTextColor())
						Buttons[i].Image.LabelFrame.Label:SetText(CallbackCount)
					else
						Buttons[i].Image.LabelFrame:Hide()
						Buttons[i].Image.LabelFrame.Label:SetText("")
					end
				end

				local function State()
					Buttons[i].SetStateAuto()
				end

				--------------------------------

				Text()
				Icon()
				Count()
				State()
			end
		end

		Frame.SetRequireItem = function(callbacks)
			NS.Variables.NumRequireItem = #callbacks

			--------------------------------

			Frame.Progress_Header:Show()

			--------------------------------

			local Buttons = Frame.GetRequireItemButtons()

			for i = 1, #Buttons do
				Buttons[i]:Hide()
			end

			for i = 1, NS.Variables.NumRequireItem do
				Buttons[i]:Show()
				Buttons[i].Index = i
				Buttons[i].Type = "required"
				Buttons[i].Callback = callbacks[i]

				--------------------------------

				local CallbackLabelText = _G[callbacks[i]:GetDebugName() .. "Name"]
				local CallbackContextIcon = callbacks[i].QuestRewardContextIcon
				local CallbackIcon = _G[callbacks[i]:GetDebugName() .. "IconTexture"]
				local CallbackCountText = _G[callbacks[i]:GetDebugName() .. "Count"]
				local CallbackCount = callbacks[i].count

				--------------------------------

				local function Text()
					if CallbackContextIcon and CallbackContextIcon:IsVisible() then
						if CallbackContextIcon:GetAtlas() then
							Buttons[i].Label:SetText(AdaptiveAPI:InlineIcon(CallbackContextIcon:GetAtlas(), 15, 15, 0, 0, "Atlas") .. " " .. CallbackLabelText:GetText())
						else
							Buttons[i].Label:SetText(AdaptiveAPI:InlineIcon(CallbackContextIcon:GetTexture(), 15, 15, 0, 0, "|T") .. " " .. CallbackLabelText:GetText())
						end
					else
						Buttons[i].Label:SetText(CallbackLabelText:GetText())
					end
				end

				local function Icon()
					if CallbackIcon:GetAtlas() then
						Buttons[i].Image.IconTexture:SetAtlas(CallbackIcon:GetAtlas())
					else
						Buttons[i].Image.IconTexture:SetTexture(CallbackIcon:GetTexture())
					end
				end

				local function Count()
					if CallbackCount > 1 then
						Buttons[i].Image.LabelFrame:Show()
						Buttons[i].Image.LabelFrame.Label:SetTextColor(CallbackCountText:GetTextColor())
						Buttons[i].Image.LabelFrame.Label:SetText(CallbackCount)
					else
						Buttons[i].Image.LabelFrame:Hide()
						Buttons[i].Image.LabelFrame.Label:SetText("")
					end
				end

				local function State()
					Buttons[i].SetStateAuto()
				end

				--------------------------------

				Text()
				Icon()
				Count()
				State()
			end
		end

		--------------------------------

		QuestFrame.GetRewards = function(type)
			local results = {}

			local frame = QuestInfoRewardsFrame
			for f1 = 1, frame:GetNumChildren() do
				local _frameIndex1 = select(f1, frame:GetChildren())

				if AdaptiveAPI:FindString(_frameIndex1:GetDebugName(), "QuestInfoItem") and not AdaptiveAPI:FindString(_frameIndex1:GetDebugName(), "Highlight") and _frameIndex1:IsVisible() and _frameIndex1.type == type then
					if _frameIndex1:IsVisible() and _frameIndex1:GetPoint() then
						table.insert(results, _frameIndex1)
					end
				end
			end

			return results
		end

		QuestFrame.GetProgressRequireItems = function()
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

		QuestFrame.GetSpells = function()
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

		Frame.SetData = function()
			local function Text()
				local Title = QuestInfoTitleHeader
				local ProgressTitle = QuestProgressTitleText
				local ObjectivesHeader = QuestInfoObjectivesHeader
				local Objectives = QuestInfoObjectivesText
				local RewardsHeader = QuestInfoRewardsFrame.Header
				local RewardsItemChoose = QuestInfoRewardsFrame.ItemChooseText
				local RewardsItemReceive = QuestInfoRewardsFrame.ItemReceiveText
				local RewardsItemPartySync = (not addon.Variables.IS_CLASSIC and QuestInfoRewardsFrame.QuestSessionBonusReward) or (addon.Variables.IS_CLASSIC and nil)
				local RewardsItemSpell, _ = QuestFrame.GetSpells()
				local ProgressRequireItemHeader = QuestProgressRequiredItemsText
				local StorylineInfo = (not addon.Variables.IS_CLASSIC and C_QuestLine.GetQuestLineInfo(GetQuestID()) and C_QuestLine.GetQuestLineInfo(GetQuestID()).questLineName) or (addon.Variables.IS_CLASSIC and nil)

				local Experience = GetRewardXP()
				local ExperiencePercentage = string.format("%.2f%%", tostring((GetRewardXP() / UnitXPMax("player")) * 100))
				local Gold, Silver, Copper = AdaptiveAPI:FormatMoney(GetRewardMoney())
				local Honor = GetRewardHonor()

				--------------------------------

				local function Text_Storyline()
					Frame.Storyline:SetShown(StorylineInfo and not ProgressTitle:IsVisible())

					--------------------------------

					if StorylineInfo then
						Frame.Storyline.Text:SetText(StorylineInfo)
					end
				end

				local function Text_Title()
					if not ProgressTitle:IsVisible() then
						Frame.Title:SetShown(Title:IsVisible())

						--------------------------------

						if Title:IsVisible() then
							Frame.Title:SetText(AdaptiveAPI:RemoveAtlasMarkup(Title:GetText(), true))

							--------------------------------

							Frame.Title:ClearAllPoints()
							if StorylineInfo then
								Frame.Title:SetPoint("TOPLEFT", Frame, 60, -NS.Variables:RATIO(7))
							else
								Frame.Title:SetPoint("TOPLEFT", Frame, 60, -NS.Variables:RATIO(7))
							end
						end
					else
						Frame.Title:SetShown(ProgressTitle:IsVisible())

						--------------------------------

						Frame.Title:SetText(AdaptiveAPI:RemoveAtlasMarkup(ProgressTitle:GetText(), true))

						--------------------------------

						Frame.Title:ClearAllPoints()
						if StorylineInfo then
							Frame.Title:SetPoint("TOPLEFT", Frame, 60, -NS.Variables:RATIO(7))
						else
							Frame.Title:SetPoint("TOPLEFT", Frame, 60, -NS.Variables:RATIO(7))
						end
					end
				end

				local function Text_Objectives()
					Frame.Objectives_Header:SetShown(ObjectivesHeader:IsVisible())
					Frame.Objectives_Text:SetShown(Objectives:IsVisible())

					--------------------------------

					if ObjectivesHeader:IsVisible() then
						Frame.Objectives_Header.Label:SetText(ObjectivesHeader:GetText())
						Frame.Objectives_Text:SetText(Objectives:GetText())
					end
				end

				local function Rewards()
					local function Rewards_Header()
						Frame.Rewards_Header:SetShown(RewardsHeader:IsVisible() and not ProgressTitle:IsVisible())
						Frame.Rewards_Header.Label:SetText(RewardsHeader:GetText())
					end

					local function Rewards_Experience()
						Frame.Rewards_Experience:SetShown(Experience > 0 and not ProgressTitle:IsVisible())

						--------------------------------

						if Experience > 0 then
							Frame.Rewards_Experience.Text:SetText(AdaptiveAPI:InlineIcon(addon.Variables.PATH .. "Art/Icons/xp.png", 25, 25, 0, 0) .. " " .. AdaptiveAPI:FormatNumber(Experience) .. " " .. "(" .. ExperiencePercentage .. ")")
						end
					end

					local function Rewards_Currency()
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

					local function Rewards_Honor()
						Frame.Rewards_Honor:SetShown(Honor > 0 and not ProgressTitle:IsVisible())

						--------------------------------

						if Honor > 0 then
							Frame.Rewards_Honor.Text:SetText(AdaptiveAPI:InlineIcon(addon.Variables.PATH .. "Art/Icons/honor.png", 12.5, 12.5, 0, 0) .. Honor)
						end
					end

					local function Rewards_Choice()
						Frame.Rewards_Choice:SetShown(RewardsItemChoose:IsVisible())

						--------------------------------

						Frame.Rewards_Choice:SetText(RewardsItemChoose:GetText())
					end

					local function Rewards_Receive()
						Frame.Rewards_Receive:SetShown(RewardsItemPartySync and RewardsItemPartySync:IsVisible() or RewardsItemReceive:IsVisible())

						--------------------------------

						if RewardsItemPartySync and RewardsItemPartySync:IsVisible() then
							Frame.Rewards_Receive:SetText(RewardsItemPartySync:GetText())
						else
							Frame.Rewards_Receive:SetText(RewardsItemReceive:GetText())
						end
					end

					local function Rewards_Spell()
						Frame.Rewards_Spell:SetShown(RewardsItemSpell and RewardsItemSpell:IsVisible())

						--------------------------------

						if RewardsItemSpell then
							Frame.Rewards_Spell:SetText(RewardsItemSpell:GetText())
						end
					end

					local function Rewards_Progress()
						Frame.Progress_Header:SetShown(ProgressRequireItemHeader:IsVisible())

						--------------------------------

						if ProgressRequireItemHeader:IsVisible() then
							Frame.Progress_Header.Label:SetText(ProgressRequireItemHeader:GetText())
						end
					end

					--------------------------------

					Rewards_Header()
					Rewards_Experience()
					Rewards_Currency()
					Rewards_Honor()
					Rewards_Choice()
					Rewards_Receive()
					Rewards_Spell()
					Rewards_Progress()
				end

				--------------------------------

				Text_Storyline()
				Text_Title()
				Text_Objectives()
				Rewards()
			end

			local function ContextIcon()
				local ContextIcon = addon.ContextIcon.Script:GetContextIcon()

				--------------------------------

				Frame.ContextIcon.Label:SetText(ContextIcon)
			end

			local function Rewards()
				local choices = QuestFrame.GetRewards("choice")
				local receive = QuestFrame.GetRewards("reward")
				local _, spells = QuestFrame.GetSpells()
				local requireItems = QuestFrame.GetProgressRequireItems()

				--------------------------------

				if #choices >= 1 then
					Frame.SetChoice(choices)
				else
					Frame.HideQuestChoice()
				end

				--------------------------------

				if #receive >= 1 then
					Frame.SetReceive(receive)
				else
					Frame.HideReceive()
				end

				--------------------------------

				if #spells >= 1 then
					Frame.SetSpell(spells)
				else
					Frame.HideSpell()
				end

				--------------------------------

				if #requireItems >= 1 then
					Frame.SetRequireItem(requireItems)
				else
					Frame.HideRequireItems()
				end
			end

			local function Buttons()
				local CompleteButton = QuestFrameCompleteQuestButton
				local ContinueButton = QuestFrameCompleteButton
				local AcceptButton = QuestFrameAcceptButton
				local DeclineButton = QuestFrameDeclineButton
				local GoodbyeButton = QuestFrameGoodbyeButton

				-- Can't seem to query if the quest log is full - C_QuestLog.GetNumQuestWatches() returns values
				-- higher than C_QuestLog.GetMaxNumQuestsCanAccept() even though it is still within the limit?

				local QuestLogFull = false -- (select(2, C_QuestLog.GetNumQuestWatches()) >= C_QuestLog.GetMaxNumQuestsCanAccept())

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

				local function SetButtonText(frame, reference, text, buttonType)
					frame:SetText(text)
					addon.API:SetButtonToPlatform(frame, buttonType, true, frame.Text)

					if frame == Frame.ButtonContainer.AcceptButton then
						if QuestLogFull then
							frame:SetText(L["InteractionQuestFrame - Quest Log Full"])
						end
					end
				end

				if ContinueButton:IsEnabled() then
					SetButtonText(Frame.ButtonContainer.ContinueButton, ContinueButton, L["InteractionQuestFrame - Continue"], "Accept")
				else
					SetButtonText(Frame.ButtonContainer.ContinueButton, ContinueButton, L["InteractionQuestFrame - In Progress"], "Accept")
				end

				SetButtonText(Frame.ButtonContainer.CompleteButton, CompleteButton, L["InteractionQuestFrame - Complete"], "Accept")
				SetButtonText(Frame.ButtonContainer.AcceptButton, AcceptButton, L["InteractionQuestFrame - Accept"], "Accept")
				SetButtonText(Frame.ButtonContainer.DeclineButton, DeclineButton, L["InteractionQuestFrame - Decline"], "Decline")
				SetButtonText(Frame.ButtonContainer.GoodbyeButton, GoodbyeButton, L["InteractionQuestFrame - Goodbye"], "Decline")
			end

			--------------------------------

			Text()
			ContextIcon()
			Rewards()
			Buttons()

			--------------------------------

			addon.Libraries.AceTimer:ScheduleTimer(function()
				CallbackRegistry:Trigger("QUEST_DATA_LOADED")
			end, .1)

			addon.Libraries.AceTimer:ScheduleTimer(function()
				Frame.ScrollChildFrame.SetLayout()

				addon.Libraries.AceTimer:ScheduleTimer(function()
					CallbackRegistry:Trigger("QUEST_DATA_READY")
				end, .1)
			end, .2)

			--------------------------------

			addon.Libraries.AceTimer:ScheduleTimer(function()
				Frame.UpdateCompleteButton()
			end, .3)
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
			addon.Libraries.AceTimer:ScheduleTimer(function()
				if not Frame.hidden then
					Frame:Show()
				end
			end, .075)
			Frame.hidden = false

			--------------------------------

			Frame.Animation = true
			addon.Libraries.AceTimer:ScheduleTimer(function()
				if not Frame.hidden then
					Frame.Animation = false
				end
			end, .25)

			--------------------------------

			Frame.ScrollFrame:SetVerticalScroll(0)

			--------------------------------

			Frame:SetAlpha(0)
			Frame.Background:SetAlpha(0)
			Frame.Title:SetAlpha(0)
			Frame.Storyline.Text:SetAlpha(0)
			Frame.ScrollFrame:SetAlpha(0)
			Frame.ScrollFrame:Hide()
			Frame.ButtonContainer:SetAlpha(0)
			Frame.ButtonContainer:Hide()

			--------------------------------

			AdaptiveAPI.Animation:Fade(Frame, .375, 0, 1, nil, function() return w end)
			AdaptiveAPI.Animation:Fade(Frame.ContextIcon.Label, .5, 0, 1, nil, function() return Frame.hidden end)
			AdaptiveAPI.Animation:Scale(Frame.ContextIcon, .5, 10, 1, nil, AdaptiveAPI.Animation.EaseExpo, function() return Frame.hidden end)
			AdaptiveAPI.Animation:Scale(Frame.Background, 1, 200, Frame:GetHeight() + 50, "y", AdaptiveAPI.Animation.EaseExpo, function() return Frame.hidden end)

			addon.Libraries.AceTimer:ScheduleTimer(function()
				AdaptiveAPI.Animation:Fade(Frame.Background, .5, 0, 1, nil, function() return Frame.hidden end)
			end, .25)

			addon.Libraries.AceTimer:ScheduleTimer(function()
				if not Frame.hidden then
					AdaptiveAPI.Animation:Fade(Frame.Title, .5, 0, 1, nil, function() return Frame.hidden end)

					if Frame.Storyline:IsVisible() then
						AdaptiveAPI.Animation:Fade(Frame.Storyline.Text, .5, 0, 1, nil, function() return Frame.hidden end)
					end

					--------------------------------

					Frame.ScrollFrame:Hide()
					Frame.ScrollChildFrame.SetLayout()

					--------------------------------

					addon.Libraries.AceTimer:ScheduleTimer(function()
						if not Frame.hidden then
							AdaptiveAPI.Animation:Fade(Frame.ScrollFrame, .5, 0, 1, nil, function() return Frame.hidden end)

							--------------------------------

							addon.Libraries.AceTimer:ScheduleTimer(function()
								Frame.ScrollFrame:Show()
							end, 0)
						end
					end, .075)

					addon.Libraries.AceTimer:ScheduleTimer(function()
						if not Frame.hidden then
							AdaptiveAPI.Animation:Fade(Frame.ButtonContainer, .75, 0, 1, AdaptiveAPI.Animation.EaseSine, function() return Frame.hidden end)

							--------------------------------

							addon.Libraries.AceTimer:ScheduleTimer(function()
								Frame.ButtonContainer:Show()
							end, 0)
						end
					end, .175)
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

		Frame.HideWithAnimation = function(bypass)
			if Frame.hidden then
				return
			end
			Frame.hidden = true

			--------------------------------

			Frame.Animation = true
			addon.Libraries.AceTimer:ScheduleTimer(function()
				if Frame.hidden then
					Frame.Animation = false
				end
			end, .25)

			--------------------------------

			AdaptiveAPI.Animation:Fade(Frame, .25, Frame:GetAlpha(), 0, nil, function() return not Frame.hidden end)
			AdaptiveAPI.Animation:Fade(Frame.ContextIcon.Label, .25, Frame.ContextIcon.Label:GetAlpha(), 0, nil, function() return not Frame.hidden end)
			AdaptiveAPI.Animation:Scale(Frame.ContextIcon, 2.5, Frame.ContextIcon:GetScale(), 3.75, nil, AdaptiveAPI.Animation.EaseExpo, function() return not Frame.hidden end)

			addon.Libraries.AceTimer:ScheduleTimer(function()
				if Frame.hidden then
					AdaptiveAPI.Animation:Scale(Frame.Background, .25, Frame.Background:GetHeight(), 200, "y", AdaptiveAPI.Animation.EaseSine, function() return not Frame.hidden end)
				end
			end, .125)

			addon.Libraries.AceTimer:ScheduleTimer(function()
				if Frame.hidden then
					if bypass then
						Frame:Hide()
						Frame.hidden = true
					else
						Frame:Hide()
						-- addon.Interaction.Script:Stop(true)
					end
				end
			end, .35)

			--------------------------------

			addon.Libraries.AceTimer:ScheduleTimer(function()
				addon.BlizzardGameTooltip.Script:StopCustom()
			end, .5)

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

					Frame:SetPoint("LEFT", UIParent, quarterEdgePadding, offsetY)
				else
					offsetX = quarterEdgePadding

					--------------------------------

					Frame:SetPoint("LEFT", UIParent, quarterEdgePadding, offsetY)
				end

				--------------------------------

				Frame.GradientTexture:SetTexture(NS.Variables.QUEST_PATH .. "gradient-left.png")
			else
				offsetX = screenWidth - frameWidth - quarterEdgePadding

				--------------------------------

				Frame:SetPoint("LEFT", UIParent, offsetX, offsetY)

				--------------------------------

				Frame.GradientTexture:SetTexture(NS.Variables.QUEST_PATH .. "gradient-right.png")
			end
		end
		Settings_UIDirection()

		--------------------------------

		CallbackRegistry:Add("THEME_UPDATE", Settings_ThemeUpdate, 10)
		CallbackRegistry:Add("SETTINGS_UIDIRECTION_CHANGED", Settings_UIDirection, 0)
		CallbackRegistry:Add("BLIZZARD_SETTINGS_RESOLUTION_CHANGED", Settings_UIDirection, 0)

		if QuestModelScene then -- Fix for Classic Era
			hooksecurefunc(QuestModelScene, "Show", Settings_UIDirection)
		end
	end

	--------------------------------
	-- EVENTS
	--------------------------------

	do
		local function UpdateAll()
			Frame.UpdateVisibility()
			Frame.UpdateFocus()
		end

		CallbackRegistry:Add("START_INTERACTION", function()
			UpdateAll()
		end, 5)

		CallbackRegistry:Add("STOP_INTERACTION", function()
			if Frame:IsVisible() then
				Frame.HideWithAnimation()
			else
				Frame.hidden = true
				Frame:Hide()
			end
		end, 5)

		CallbackRegistry:Add("START_DIALOG", function()
			UpdateAll()

			--------------------------------

			if not INTDB.profile.INT_ALWAYS_SHOW_QUEST then
				if Frame:IsVisible() then
					Frame.HideWithAnimation(true)
				else
					Frame:Hide()
				end
			end
		end, 5)

		CallbackRegistry:Add("FINISH_DIALOG", function()
			UpdateAll()
		end, 5)

		CallbackRegistry:Add("PREVIOUS_DIALOG", function()
			UpdateAll()
		end, 5)

		CallbackRegistry:Add("QUEST_DATA_LOADED", function()
			UpdateAll()

			--------------------------------

			Frame.UpdateWarbandHeader()
			Frame.UpdateScrollFrameFormat()

			--------------------------------

			addon.Libraries.AceTimer:ScheduleTimer(function()
				Frame.UpdateScrollIndicator()
			end, .1)
		end, 5)

		CallbackRegistry:Add("INPUT_NAVIGATION_HIGHLIGHTED", function()
			Frame.UpdateCompleteButton()
		end, 0)

		--------------------------------

		function Frame.UpdateFocus()
			local IsFocused = (Frame.Focused)
			local IsMouseOver = (Frame.MouseOver)
			local IsInDialog = (InteractionDialogFrame:IsVisible())

			if IsInDialog and not IsMouseOver then
				Frame.Focused = false
			else
				Frame.Focused = true
			end
		end

		function Frame.SetFocusTransition()
			local IsFocused = (Frame.Focused)
			local IsMouseOver = (Frame.MouseOver)
			local IsInDialog = (InteractionDialogFrame:IsVisible())

			if IsFocused then
				AdaptiveAPI.Animation:Fade(InteractionQuestParent, .25, InteractionQuestParent:GetAlpha(), 1, nil, function() return not IsFocused end)
			else
				AdaptiveAPI.Animation:Fade(InteractionQuestParent, .25, InteractionQuestParent:GetAlpha(), .875, nil, function() return IsFocused end)
			end
		end

		Frame:SetScript("OnMouseUp", function(self, button)
			if INTDB.profile.INT_FLIPMOUSE == false and button == "RightButton" then
				InteractionDialogFrame.ReturnToPreviousDialog()
			elseif INTDB.profile.INT_FLIPMOUSE == true and button == "LeftButton" then
				InteractionDialogFrame.ReturnToPreviousDialog()
			end
		end)

		hooksecurefunc(Frame, "Show", function()
			Frame.ClearChoiceSelected()

			--------------------------------

			CallbackRegistry:Trigger("START_QUEST")
		end)

		hooksecurefunc(Frame, "Hide", function()
			CallbackRegistry:Trigger("STOP_QUEST")

			--------------------------------

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
