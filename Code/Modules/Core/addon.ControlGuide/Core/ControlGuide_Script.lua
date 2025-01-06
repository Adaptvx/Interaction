local addonName, addon = ...
local CallbackRegistry = addon.CallbackRegistry
local L = addon.Locales
local NS = addon.ControlGuide

--------------------------------

NS.Script = {}

--------------------------------

function NS.Script:Load()
	--------------------------------
	-- REFERENCES
	--------------------------------

	local Frame = InteractionControlGuideFrame
	local Callback = NS.Script

	--------------------------------
	-- FUNCTIONS (BUTTONS)
	--------------------------------

	do
		Frame.GetElements = function()
			return Frame.Elements
		end
	end

	--------------------------------
	-- FUNCTIONS (MAIN)
	--------------------------------

	do
		Frame.UpdateVisibility = function()
			local isControlGuideEnabled = (INTDB.profile.INT_CONTROLGUIDE)

			--------------------------------

			if isControlGuideEnabled then
				local isInteraction = (addon.Interaction.Variables.Active)
				local isDialog = (addon.Interaction.Dialog.Variables.IsInInteraction)
				local isGossip = (not InteractionGossipFrame.hidden)
				local isQuest = (not InteractionQuestFrame.hidden)

				local isController = (addon.Input.Variables.IsControllerEnabled)
				local isGossipOption = (#InteractionGossipFrame.GetButtons() > 0)

				--------------------------------

				local data = {}

				if isInteraction then
					if isDialog then
						local nextAvailable = (not addon.Interaction.Dialog.Variables.Finished)

						local back = {
							text = L["ControlGuide - Back"],
							keybindVariable = addon.Input.Variables:GetKeybindForPlatform(addon.Input.Variables.Key_Previous)
						}
						local next = {
							text = L["ControlGuide - Next"],
							keybindVariable = addon.Input.Variables:GetKeybindForPlatform(addon.Input.Variables.Key_Next)
						}
						local skip = {
							text = L["ControlGuide - Skip"],
							keybindVariable = addon.Input.Variables:GetKeybindForPlatform(addon.Input.Variables.Key_Progress)
						}
						local interact = {
							text = L["ControlGuide - Gossip Option Interact"],
							keybindVariable = addon.Input.Variables:GetKeybindForPlatform(addon.Input.Variables.Key_Interact)
						}

						table.insert(data, back)
						if nextAvailable then if next.text then table.insert(data, next) end end
						if ((isController and (not isGossip or not isGossipOption)) or (not isController)) and nextAvailable and not isQuest then if skip.text then table.insert(data, skip) end end
						if isController and isGossip and isGossipOption then table.insert(data, interact) end
					end

					if isQuest then
						local isAccept = (QuestFrameAcceptButton:IsEnabled() and QuestFrameAcceptButton:IsVisible())
						local isContinue = (QuestFrameCompleteButton:IsEnabled() and QuestFrameCompleteButton:IsVisible())
						local isComplete = (QuestFrameCompleteQuestButton:IsEnabled() and QuestFrameCompleteQuestButton:IsVisible())
						local isGoodbye = (addon.Interaction.Variables.Type == "quest-progress")
						local isDecline = (not isGoodbye)
						local isAutoAccept = (addon.API:IsAutoAccept())

						local accept = {
							text = isAccept and L["ControlGuide - Accept"] or isContinue and L["ControlGuide - Continue"] or isComplete and L["ControlGuide - Complete"],
							keybindVariable = addon.Input.Variables:GetKeybindForPlatform(addon.Input.Variables.Key_Progress)
						}
						local decline = {
							text = isAutoAccept and L["ControlGuide - Got it"] or isGoodbye and L["ControlGuide - Goodbye"] or isDecline and L["ControlGuide - Decline"],
							keybindVariable = isAutoAccept and addon.Input.Variables:GetKeybindForPlatform(addon.Input.Variables.Key_Progress) or addon.Input.Variables:GetKeybindForPlatform(addon.Input.Variables.Key_Close)
						}


						if accept.text then table.insert(data, accept) end
						if decline.text then table.insert(data, decline) end
					end
				end

				if data then
					Frame.ShowWithAnimation()

					--------------------------------

					Frame.SetData(data)
				else
					Frame.HideWithAnimation()
				end
			else
				Frame.HideWithAnimation()
			end
		end

		Frame.UpdateLayout = function()
			local elements = Frame.GetElements()

			local padding = NS.Variables.PADDING
			local currentOffset = 0

			--------------------------------

			for i = 1, #elements do
				local currentElement = elements[i]

				--------------------------------

				currentElement.UpdateSize()

				--------------------------------

				if currentElement:IsShown() then
					currentElement:ClearAllPoints()
					currentElement:SetPoint("LEFT", Frame, currentOffset, 0)

					--------------------------------

					currentOffset = currentOffset + elements[i]:GetWidth() + padding
				end
			end

			Frame:SetWidth(currentOffset)
		end

		Frame.UpdatePosition = function()
			local IsStatusBarVisible = (InteractionPlayerStatusBarFrame:IsVisible())

			--------------------------------

			if IsStatusBarVisible then
				InteractionControlGuideFrame:SetPoint("BOTTOM", UIParent, 0, InteractionPlayerStatusBarFrame:GetHeight() + NS.Variables:RATIO(1.5))
			else
				InteractionControlGuideFrame:SetPoint("BOTTOM", UIParent, 0, NS.Variables:RATIO(1.5))
			end
		end
	end

	--------------------------------
	-- FUNCTIONS (DATA)
	--------------------------------

	do
		Frame.SetData = function(data)
			local elements = Frame.GetElements()

			--------------------------------

			for i = 1, #elements do
				if i > #data then
					elements[i]:Hide()
				end
			end

			--------------------------------

			for i = 1, #data do
				local currentElement = elements[i]

				local currentEntry = data[i]
				local currentText = currentEntry.text
				local currentKeybindVariable = currentEntry.keybindVariable

				--------------------------------

				if not currentElement:IsVisible() or currentElement.Text:GetText() ~= currentText then
					currentElement:Show()

					--------------------------------

					AdaptiveAPI.Animation:Fade(currentElement, .25, 0, 1, nil, function() return not currentElement:IsVisible() end)
					AdaptiveAPI.Animation:Move(currentElement, .5, "LEFT", -12.5, 0, "y", nil, function() return not currentElement:IsVisible() end)
				else
					currentElement:Show()

					--------------------------------

					currentElement:SetAlpha(1)
				end

				--------------------------------

				currentElement.Text:SetText(currentText)
				addon.API:SetButtonToPlatform(currentElement, currentElement.Text, currentKeybindVariable)
			end

			--------------------------------

			Frame:UpdateLayout()
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
			Frame:Show()

			--------------------------------

			AdaptiveAPI.Animation:Fade(Frame, .125, Frame:GetAlpha(), 1, nil, function() return Frame.hidden end)
		end

		Frame.HideWithAnimation = function()
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

			AdaptiveAPI.Animation:Fade(Frame, .125, Frame:GetAlpha(), 0, nil, function() return not Frame.hidden end)
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
		CallbackRegistry:Add("START_INTERACTION", Frame.UpdateVisibility, 5)
		CallbackRegistry:Add("STOP_INTERACTION", Frame.UpdateVisibility, 5)
		CallbackRegistry:Add("UPDATE_DIALOG", Frame.UpdateVisibility, 5)
		CallbackRegistry:Add("START_DIALOG", Frame.UpdateVisibility, 5)
		CallbackRegistry:Add("STOP_DIALOG", Frame.UpdateVisibility, 5)
		CallbackRegistry:Add("START_GOSSIP", Frame.UpdateVisibility, 5)
		CallbackRegistry:Add("STOP_GOSSIP", Frame.UpdateVisibility, 5)
		CallbackRegistry:Add("START_QUEST", Frame.UpdateVisibility, 5)
		CallbackRegistry:Add("STOP_QUEST", Frame.UpdateVisibility, 5)
		CallbackRegistry:Add("START_READABLE_UI", Frame.UpdateVisibility, 5)
		CallbackRegistry:Add("STOP_READABLE_UI", Frame.UpdateVisibility, 5)
		CallbackRegistry:Add("START_READABLE", Frame.UpdateVisibility, 5)
		CallbackRegistry:Add("STOP_READABLE", Frame.UpdateVisibility, 5)
		CallbackRegistry:Add("START_LIBRARY", Frame.UpdateVisibility, 5)
		CallbackRegistry:Add("STOP_LIBRARY", Frame.UpdateVisibility, 5)

		CallbackRegistry:Add("START_STATUSBAR", Frame.UpdatePosition, 0)
		CallbackRegistry:Add("STOP_STATUSBAR", Frame.UpdatePosition, 0)
	end
end
