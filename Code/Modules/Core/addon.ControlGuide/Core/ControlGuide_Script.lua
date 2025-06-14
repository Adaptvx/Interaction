-- [!] [addon.ControlGuide] is used to display relevant keybinds for the current context.
-- [ControlGuide_Script.lua] is the back-end (logic & behavior)
-- for [ControlGuide_Elements.lua].

---@class addon
local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local PrefabRegistry = addon.PrefabRegistry
local L = addon.Locales
local NS = addon.ControlGuide; addon.ControlGuide = NS

--------------------------------

NS.Script = {}

--------------------------------

function NS.Script:Load()
	--------------------------------
	-- REFERENCES
	--------------------------------

	local Frame = InteractionFrame.ControlGuideFrame
	local Callback = NS.Script; NS.Script = Callback

	--------------------------------
	-- FUNCTIONS (MAIN)
	--------------------------------

	do
		function Frame:UpdateData()
			local isControlGuideEnabled = (addon.Database.DB_GLOBAL.profile.INT_CONTROLGUIDE)

			--------------------------------

			if isControlGuideEnabled then
				local isInteraction = (addon.Interaction.Variables.Active)
				local isDialog = (addon.Interaction.Dialog.Variables.Playback_Valid)
				local isGossip = (not InteractionFrame.GossipFrame.hidden)
				local isQuest = (not InteractionFrame.QuestFrame.hidden)

				local isController = (addon.Input.Variables.IsControllerEnabled or addon.Input.Variables.SimulateController)
				local isGossipOption = (addon.Interaction.Gossip.Variables.NumCurrentButtons > 0)
				local isGossipRefresh = (addon.Interaction.Gossip.Variables.RefreshInProgress)

				--------------------------------

				local data = {}

				if isInteraction and not isGossipRefresh then
					if isDialog then
						local nextAvailable = (not addon.Interaction.Dialog.Variables.Playback_Finished)

						--------------------------------

						local back = {
							text =
								L["ControlGuide - Back"],
							keybindVariable = addon.Input.Variables:GetKeybindForPlatform(addon.Input.Variables.Key_Previous)
						}
						local next = {
							text =
								L["ControlGuide - Next"],
							keybindVariable = addon.Input.Variables:GetKeybindForPlatform(addon.Input.Variables.Key_Next)
						}
						local skip = {
							text =
								L["ControlGuide - Skip"],
							keybindVariable = addon.Input.Variables:GetKeybindForPlatform(addon.Input.Variables.Key_Progress)
						}

						--------------------------------

						if back.text and back.keybindVariable then table.insert(data, back) end
						if next.text and next.keybindVariable and nextAvailable then table.insert(data, next) end
						if skip.text and skip.keybindVariable and nextAvailable and not isQuest and ((isController and (not isGossip or not isGossipOption)) or (not isController)) then table.insert(data, skip) end
					end

					if isGossip then
						local interact = {
							text =
								L["ControlGuide - Gossip Option Interact"],
							keybindVariable = addon.Input.Variables:GetKeybindForPlatform(addon.Input.Variables.Key_Interact)
						}

						--------------------------------

						if interact.text and interact.keybindVariable and isController and isGossip and isGossipOption then table.insert(data, interact) end
					end

					if isQuest then
						local isAccept = (QuestFrameAcceptButton:IsEnabled() and QuestFrameAcceptButton:IsVisible())
						local isContinue = (QuestFrameCompleteButton:IsEnabled() and QuestFrameCompleteButton:IsVisible())
						local isComplete = (QuestFrameCompleteQuestButton:IsEnabled() and QuestFrameCompleteQuestButton:IsVisible())
						local isGoodbye = (isComplete or addon.Interaction.Variables.CurrentSession.type == "quest-progress")
						local isDecline = (not isGoodbye)
						local isAutoAccept = (addon.API.Main:IsAutoAccept())
						local isRewardSelection = (isComplete and addon.Interaction.Quest.Variables.Num_Choice > 1)
						local isRewardSelectionValid = (isRewardSelection and addon.Interaction.Quest.Variables.Button_Choice_Selected)
						local isRewardSelectionValidController = (isRewardSelection and addon.Input.Variables.CurrentFrame == addon.Interaction.Quest.Variables.Button_Choice_Selected)

						--------------------------------

						local rewardSelection = {
							text =
								L["ControlGuide - Quest Next Reward"],
							keybindVariable = addon.Input.Variables:GetKeybindForPlatform(addon.Input.Variables.Key_Quest_NextReward)
						}
						local accept = {
							text =
								(isAccept and L["ControlGuide - Accept"]) or
								(isContinue and L["ControlGuide - Continue"]) or
								(isComplete and isController and ((not isRewardSelection) or (isRewardSelection and isRewardSelectionValidController))) and L["ControlGuide - Complete"] or
								(isComplete and not isController and ((not isRewardSelection) or (isRewardSelection and isRewardSelectionValid))) and L["ControlGuide - Complete"],
							keybindVariable = addon.Input.Variables:GetKeybindForPlatform(addon.Input.Variables.Key_Progress)
						}
						local decline = {
							text =
								(isAutoAccept) and L["ControlGuide - Got it"] or
								(isGoodbye) and L["ControlGuide - Goodbye"] or
								(isDecline) and L["ControlGuide - Decline"],
							keybindVariable = isAutoAccept and addon.Input.Variables:GetKeybindForPlatform(addon.Input.Variables.Key_Progress) or addon.Input.Variables:GetKeybindForPlatform(addon.Input.Variables.Key_Close)
						}

						--------------------------------

						if rewardSelection.text and rewardSelection.keybindVariable and isRewardSelection then table.insert(data, rewardSelection) end
						if accept.text and accept.keybindVariable then table.insert(data, accept) end
						if decline.text and decline.keybindVariable then table.insert(data, decline) end
					end
				end

				if data then
					Frame:ShowWithAnimation()

					--------------------------------

					Frame:SetData(data)
				else
					Frame:HideWithAnimation()
				end
			else
				Frame:HideWithAnimation()
			end
		end

		function Frame:UpdatePosition()
			local isStatusBarVisible = (InteractionPlayerStatusBarFrame:IsVisible())

			--------------------------------

			if isStatusBarVisible then
				Frame:SetPoint("BOTTOM", UIParent, 0, InteractionPlayerStatusBarFrame:GetHeight() + NS.Variables:RATIO(1.5))
			else
				Frame:SetPoint("BOTTOM", UIParent, 0, NS.Variables:RATIO(1.5))
			end
		end

		function Frame:UpdateLayout()
			CallbackRegistry:Trigger("LayoutGroupSort ControlGuide.Content")
		end
	end

	--------------------------------
	-- FUNCTIONS (DATA)
	--------------------------------

	do
		function Frame:SetData(data)
			local elements = NS.Variables.Elements

			--------------------------------

			for i = 1, #elements do
				if i > #data then
					elements[i]:Hide()
				end
			end

			for i = 1, #data do
				local currentElement = elements[i]
				local currentEntry = data[i]
				local currentText = currentEntry.text
				local currentKeybindVariable = currentEntry.keybindVariable

				--------------------------------

				if not currentElement:IsVisible() or currentElement:GetText() ~= currentText then
					currentElement:ShowWithAnimation()
				else
					currentElement:ShowWithAnimation(true)
				end

				currentElement:SetInfo(currentText, currentKeybindVariable)
			end

			--------------------------------

			Frame:UpdateLayout()
		end
	end

	--------------------------------
	-- FUNCTIONS (ANIMATION)
	--------------------------------

	do
		do -- SHOW
			function Frame:ShowWithAnimation_StopEvent()
				return Frame.hidden
			end

			function Frame:ShowWithAnimation()
				if not Frame.hidden then
					return
				end
				Frame.hidden = false
				Frame:Show()

				--------------------------------

				addon.API.Animation:Fade(Frame, .125, Frame:GetAlpha(), 1, nil, Frame.ShowWithAnimation_StopEvent)
			end
		end

		do -- HIDE
			function Frame:HideWithAnimation_StopEvent()
				return not Frame.hidden
			end

			function Frame:HideWithAnimation()
				if Frame.hidden then
					return
				end
				Frame.hidden = true

				addon.Libraries.AceTimer:ScheduleTimer(function()
					if Frame.hidden then
						Frame:Hide()
					end
				end, .125)

				--------------------------------

				addon.API.Animation:Fade(Frame, .125, Frame:GetAlpha(), 0, nil, Frame.HideWithAnimation_StopEvent)
			end
		end
	end

	--------------------------------
	-- FUNCTIONS (FOCUS)
	--------------------------------

	do

	end

	--------------------------------
	-- SETTINGS
	--------------------------------

	do

	end

	--------------------------------
	-- EVENTS
	--------------------------------

	do
		CallbackRegistry:Add("START_INTERACTION", Frame.UpdateData, 5)
		CallbackRegistry:Add("STOP_INTERACTION", Frame.UpdateData, 5)
		CallbackRegistry:Add("UPDATE_DIALOG", Frame.UpdateData, 5)
		CallbackRegistry:Add("INIT_DIALOG", Frame.UpdateData, 5)
		CallbackRegistry:Add("START_DIALOG", Frame.UpdateData, 5)
		CallbackRegistry:Add("STOP_DIALOG", Frame.UpdateData, 5)
		CallbackRegistry:Add("START_GOSSIP", Frame.UpdateData, 5)
		CallbackRegistry:Add("STOP_GOSSIP", Frame.UpdateData, 5)
		CallbackRegistry:Add("UPDATE_GOSSIP_READY", Frame.UpdateData, 5)
		CallbackRegistry:Add("START_QUEST", Frame.UpdateData, 5)
		CallbackRegistry:Add("STOP_QUEST", Frame.UpdateData, 5)
		CallbackRegistry:Add("QUEST_REWARD_SELECTED", Frame.UpdateData, 5)
		CallbackRegistry:Add("QUEST_REWARD_HIGHLIGHTED", Frame.UpdateData, 5)
		CallbackRegistry:Add("START_READABLE_UI", Frame.UpdateData, 5)
		CallbackRegistry:Add("STOP_READABLE_UI", Frame.UpdateData, 5)
		CallbackRegistry:Add("START_READABLE", Frame.UpdateData, 5)
		CallbackRegistry:Add("STOP_READABLE", Frame.UpdateData, 5)
		CallbackRegistry:Add("START_LIBRARY", Frame.UpdateData, 5)
		CallbackRegistry:Add("STOP_LIBRARY", Frame.UpdateData, 5)

		CallbackRegistry:Add("START_STATUSBAR", Frame.UpdatePosition, 0)
		CallbackRegistry:Add("STOP_STATUSBAR", Frame.UpdatePosition, 0)
	end
end
