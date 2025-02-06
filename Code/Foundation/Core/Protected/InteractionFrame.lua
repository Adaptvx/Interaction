local addonName, addon = ...
local CallbackRegistry = addon.CallbackRegistry
local L = addon.Locales

--------------------------------
-- VARIABLES
--------------------------------

addon.InteractionFrame = {}
local NS = addon.InteractionFrame

do -- MAIN

end

do -- CONSTANTS

end

--------------------------------
-- FUNCTIONS (MAIN)
--------------------------------

function NS:Load()
	--------------------------------
	-- CREATE ELEMENTS
	--------------------------------

	do
		do -- CREATE ELEMENTS
			do -- FRAME
				InteractionFrame = CreateFrame("Frame", "InteractionFrame", nil)
				InteractionFrame:SetSize(addon.API:GetScreenWidth(), addon.API:GetScreenHeight())
				InteractionFrame:SetPoint("CENTER", nil)

				addon.Libraries.AceTimer:ScheduleTimer(function()
					InteractionFrame:SetScale(addon.API.UIScale)
				end, .1)

				--------------------------------

				do -- PREVENT MOUSE
					InteractionFrame.PreventMouse = CreateFrame("Frame")
					InteractionFrame.PreventMouse:SetSize(addon.API:GetScreenWidth(), addon.API:GetScreenHeight())
					InteractionFrame.PreventMouse:SetPoint("CENTER", UIParent)
					InteractionFrame.PreventMouse:SetFrameStrata("FULLSCREEN_DIALOG")
					InteractionFrame.PreventMouse:SetFrameLevel(999)
					InteractionFrame.PreventMouse:EnableMouse(true)

					--------------------------------

					InteractionFrame.PreventMouse:Hide()
				end

				do -- KEYBIND FRAME
					InteractionFrame.KeybindFrame = CreateFrame("Frame", "$parent.KeybindFrame", InteractionFrame)
					InteractionFrame.KeybindFrame:SetPropagateKeyboardInput(true)
				end
			end

			do -- PRIORITY FRAME
				InteractionPriorityFrame = CreateFrame("Frame", "InteractionPriorityFrame", nil)
				InteractionPriorityFrame:SetSize(UIParent:GetWidth(), UIParent:GetHeight())
				InteractionPriorityFrame:SetPoint("CENTER", nil)
				InteractionPriorityFrame:SetFrameStrata("FULLSCREEN_DIALOG")
				InteractionPriorityFrame:SetFrameLevel(0)

				addon.Libraries.AceTimer:ScheduleTimer(function()
					InteractionPriorityFrame:SetScale(UIParent:GetScale())
				end, .1)
			end
		end
	end

	--------------------------------
	-- REFERENCES
	--------------------------------

	local Frame = InteractionFrame
	local PriorityFrame = InteractionPriorityFrame
	local Callback = NS

	--------------------------------
	-- FUNCTIONS (MAIN)
	--------------------------------

	do
		function NS:SetupReferences()
			function NS.SetReferences(frame)
				frame.Label = select(3, frame:GetRegions())
				frame.Background = select(2, frame:GetRegions())

				-- CLASSIC ERA
				if frame.Icon == nil then
					frame.Icon = _G[frame:GetDebugName() .. "QuestIcon"]
				end
			end

			--------------------------------

			hooksecurefunc(GossipFrame.GreetingPanel.ScrollBox, "Update", function(frame)
				GossipFrame.GreetingPanel.ScrollBox:ForEachFrame(function(self)
					local elementData = self:GetElementData()

					--------------------------------

					if elementData.buttonType ~= GOSSIP_BUTTON_TYPE_DIVIDER and elementData.buttonType ~= GOSSIP_BUTTON_TYPE_TITLE then
						NS.SetReferences(self)
					end
				end)
			end)

			--------------------------------

			if not addon.Variables.IS_CLASSIC then -- RETAIL
				hooksecurefunc(QuestFrameGreetingPanel, "Show", function(frame)
					local function UpdateQuestFrameGreetingPanel()
						local numButtons = 0

						--------------------------------

						for button in frame.titleButtonPool:EnumerateActive() do
							numButtons = numButtons + 1
						end

						--------------------------------

						if QuestFrameGreetingPanel:IsVisible() and numButtons > 0 then
							for button in frame.titleButtonPool:EnumerateActive() do
								NS.SetReferences(button)
							end

							--------------------------------

							addon.Libraries.AceTimer:ScheduleTimer(UpdateQuestFrameGreetingPanel, .1)
						end
					end

					--------------------------------

					addon.Libraries.AceTimer:ScheduleTimer(function()
						UpdateQuestFrameGreetingPanel()
					end, 0)
				end)
			elseif addon.Variables.IS_CLASSIC then -- CLASSIC
				local IsQuestTitleButtons = (QuestTitleButton1)

				--------------------------------

				if IsQuestTitleButtons then
					for i = 1, 40 do
						if _G["QuestTitleButton" .. i] then
							local CurrentFrame = _G["QuestTitleButton" .. i]
							NS.SetReferences(CurrentFrame)
						end
					end
				end
			end
		end
	end

	--------------------------------
	-- FUNCTIONS (ANIMATION)
	--------------------------------

	do
		Frame.ChangeThemeAnimation = function()
			if Frame.ThemeTransition then
				return
			end
			Frame.ThemeTransition = true

			--------------------------------

			AdaptiveAPI.Animation:Fade(Frame, .125, .99, 0, nil, function() return not Frame.ThemeTransition end)

			--------------------------------

			C_Timer.After(.5, function()
				if Frame.ThemeTransition then
					AdaptiveAPI.Animation:Fade(Frame, .25, 0, 1, nil, function() return not Frame.ThemeTransition end)

					--------------------------------

					C_Timer.After(.35, function()
						if Frame.ThemeTransition and Frame:GetAlpha() >= .99 then
							Frame.ThemeTransition = false
						end
					end)
				end
			end)
		end
	end

	--------------------------------
	-- EVENTS
	--------------------------------

	do
		local Events = CreateFrame("Frame")
		Events:RegisterEvent("CINEMATIC_START")
		Events:RegisterEvent("PLAY_MOVIE")
		Events:RegisterEvent("CINEMATIC_STOP")
		Events:RegisterEvent("STOP_MOVIE")
		Events:SetScript("OnEvent", function(self, event, ...)
			if event == "CINEMATIC_START" or event == "PLAY_MOVIE" then
				InteractionFrame:Hide()
				InteractionPriorityFrame:Hide()
			end

			if event == "CINEMATIC_STOP" or event == "STOP_MOVIE" then
				InteractionFrame:Show()
				InteractionPriorityFrame:Show()
			end
		end)

		CallbackRegistry:Add("THEME_UPDATE_ANIMATION", function()
			Frame.ChangeThemeAnimation()
		end, 0)
	end

	--------------------------------
	-- SETUP
	--------------------------------

	do
		NS:SetupReferences()
	end
end
