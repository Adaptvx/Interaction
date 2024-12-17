local addonName, addon = ...
local CallbackRegistry = addon.CallbackRegistry
local L = addon.Locales
local NS = addon.SettingsUI

--------------------------------

NS.Script = {}

--------------------------------

function NS.Script:Load()
	--------------------------------
	-- FUNCTIONS (TOOLTIP)
	--------------------------------

	do -- TOOLTIP
		function NS.Script:ShowTooltip(frame, text, image, imageType, skipAnimation)
			if not text or text == "" then
				return
			end

			--------------------------------

			InteractionSettingsFrame.Tooltip.frame = frame

			--------------------------------

			InteractionSettingsFrame.Tooltip:Show()

			--------------------------------

			local startPos = InteractionSettingsFrame.Tooltip:GetWidth() - 15
			local endPos = InteractionSettingsFrame.Tooltip:GetWidth()

			InteractionSettingsFrame.Tooltip:SetPoint("RIGHT", InteractionSettingsFrame.Tooltip.frame, 225, 0)

			if not skipAnimation then
				AdaptiveAPI.Animation:Fade(InteractionSettingsFrame.Tooltip, .125, InteractionSettingsFrame.Tooltip:GetAlpha(), 1, nil, function() return not InteractionSettingsFrame:IsVisible() end)
				AdaptiveAPI.Animation:Move(InteractionSettingsFrame.Tooltip, .25, "RIGHT", startPos, endPos, "x", AdaptiveAPI.Animation.EaseExpo, function() return not InteractionSettingsFrame:IsVisible() end)
			else
				InteractionSettingsFrame.Tooltip:SetAlpha(1)
				InteractionSettingsFrame.Tooltip:SetPoint("RIGHT", InteractionSettingsFrame.Tooltip.frame, endPos, 0)
			end

			--------------------------------

			if image and image ~= "" then
				InteractionSettingsFrame.Tooltip.Content.Image:Show()
				InteractionSettingsFrame.Tooltip.Content.ImageTexture:SetTexture(image)

				--------------------------------

				local width = imageType == "Small" and InteractionSettingsFrame.Tooltip.Content:GetWidth() / 2 or InteractionSettingsFrame.Tooltip.Content:GetWidth()
				local height = imageType == "Small" and width or width / 2

				--------------------------------

				if imageType == "Small" then
					InteractionSettingsFrame.Tooltip.Content.Image:SetSize(width, height)
				end

				if imageType == "Large" then
					InteractionSettingsFrame.Tooltip.Content.Image:SetSize(width, height)
				end
			else
				InteractionSettingsFrame.Tooltip.Content.Image:Hide()
			end

			--------------------------------

			InteractionSettingsFrame.Tooltip.Content.Text:SetText(text)
		end

		function NS.Script:HideTooltip(skipAnimation)
			InteractionSettingsFrame.Tooltip.frame = nil

			--------------------------------

			local startPos = InteractionSettingsFrame.Tooltip:GetWidth() - 15
			local endPos = InteractionSettingsFrame.Tooltip:GetWidth()

			--------------------------------

			if skipAnimation then
				InteractionSettingsFrame.Tooltip:Hide()
			else
				addon.Libraries.AceTimer:ScheduleTimer(function()
					if InteractionSettingsFrame.Tooltip.frame == nil then
						InteractionSettingsFrame.Tooltip:Hide()
					end
				end, .25)

				--------------------------------

				addon.Libraries.AceTimer:ScheduleTimer(function()
					if not InteractionSettingsFrame.Tooltip.frame then
						AdaptiveAPI.Animation:Fade(InteractionSettingsFrame.Tooltip, .125, InteractionSettingsFrame.Tooltip:GetAlpha(), 0)
						AdaptiveAPI.Animation:Move(InteractionSettingsFrame.Tooltip, .25, "RIGHT", endPos, startPos, "x", AdaptiveAPI.Animation.EaseExpo)
					end
				end, .1)
			end
		end
	end

	--------------------------------
	-- FUNCTIONS (FRAME)
	--------------------------------

	do -- FRAME
		function NS.Script:SelectTab(button, tabIndex)
			local tabPool = InteractionSettingsFrame.Content.ScrollFrame.tabPool

			local tab = tabPool[tabIndex]
			local tabButton = button
			local tabIndex = tabIndex

			--------------------------------

			local function TabButton()
				local function ResetAll()
					local widgetPool = InteractionSettingsFrame.Sidebar.Legend.widgetPool

					--------------------------------

					for i = 1, #widgetPool do
						if widgetPool[i].button then
							local button = widgetPool[i].button
							button.SetActive(false)
						end
					end
				end

				local function SetCurrent()
					tabButton.SetActive(true)
				end

				--------------------------------

				ResetAll()
				SetCurrent()
			end

			local function Tab()
				local function HideAll()
					for i = 1, #tabPool do
						local currentTab = tabPool[i]
						local elements = currentTab.widgetPool

						--------------------------------

						currentTab:Hide()

						--------------------------------

						for element = 1, #elements do
							elements[element].Leave()
						end
					end
				end

				local function ShowCurrent()
					tab:Show()
					AdaptiveAPI.Animation:Fade(tab, .25, 0, 1)
				end

				--------------------------------

				HideAll()
				ShowCurrent()

				--------------------------------

				InteractionSettingsFrame.Content.ScrollFrame.tabIndex = tabIndex
			end

			--------------------------------

			TabButton()
			Tab()

			--------------------------------

			NS.Script:HideTooltip(true)
			InteractionSettingsFrame.Content.Header.Content.Title:SetText(tabButton:GetText())
			InteractionSettingsFrame.Content.ScrollFrame:SetVerticalScroll(0)

			--------------------------------

			CallbackRegistry:Trigger("SETTING_TAB_CHANGED", tab, tabButton, tabIndex)
		end

		function NS.Script:ShowSettingsUI(bypass, focus)
			if (not addon.Initialize.Ready) then
				return
			end

			--------------------------------

			if (InteractionSettingsFrame.hidden) or (bypass) then
				InteractionSettingsFrame.hidden = false

				--------------------------------

				if bypass then
					InteractionSettingsFrame:Show()
				else
					InteractionSettingsFrame.ShowWithAnimation()
				end

				--------------------------------

				NS.Script:SelectTab(InteractionSettingsFrame.Sidebar.Legend.widgetPool[1].button, 1)

				--------------------------------

				if focus then
					addon.HideUI.Variables.Lock = true
					addon.HideUI.Script:HideUI(true)
				end

				--------------------------------

				CallbackRegistry:Trigger("START_SETTING")

				--------------------------------

				addon.SoundEffects:PlaySoundFile(addon.SoundEffects.Settings_Open)
			end
		end

		function NS.Script:HideSettingsUI(bypass, focus)
			if not InteractionSettingsFrame.hidden or bypass then
				InteractionSettingsFrame.hidden = true

				--------------------------------

				if bypass then
					InteractionSettingsFrame:Hide()
				else
					InteractionSettingsFrame.HideWithAnimation()
				end

				--------------------------------

				if focus or addon.HideUI.Variables.Lock then
					addon.HideUI.Variables.Lock = false
					addon.HideUI.Script:ShowUI(true)
				end

				--------------------------------

				CallbackRegistry:Trigger("STOP_SETTING")

				--------------------------------

				if not bypass then
					addon.SoundEffects:PlaySoundFile(addon.SoundEffects.Settings_Close)
				end
			end
		end

		function Interaction_ShowSettingsUI()
			NS.Script:ShowSettingsUI(false, true)
		end
	end

	do -- SCROLL FRAME
		InteractionSettingsFrame.Content.ScrollFrame.Update = function(PreventRepeat)
			if InteractionSettingsFrame.Content.ScrollFrame.tabIndex == nil then
				return
			end

			--------------------------------

			if PreventRepeat then
				if InteractionSettingsFrame.Content.ScrollFrame.LastUpdateTab == InteractionSettingsFrame.Content.ScrollFrame.tabIndex then
					return
				end
			end

			InteractionSettingsFrame.Content.ScrollFrame.LastUpdateTab = InteractionSettingsFrame.Content.ScrollFrame.tabIndex
			addon.Libraries.AceTimer:ScheduleTimer(function()
				InteractionSettingsFrame.Content.ScrollFrame.LastUpdateTab = nil
			end, .25)

			--------------------------------

			local WidgetPool = InteractionSettingsFrame.Content.ScrollFrame.tabPool[InteractionSettingsFrame.Content.ScrollFrame.tabIndex].widgetPool

			if not WidgetPool then
				return
			end

			--------------------------------

			local TotalHeight = 0
			local Spacing = 0
			for i = 1, #WidgetPool do
				local Widget = WidgetPool[i]
				local Widget_Type = Widget.Type
				local Widget_Height = Widget:GetHeight()
				local Widget_Visible = Widget:IsVisible()

				--------------------------------

				if Widget_Visible then
					Widget:SetAlpha(1)

					--------------------------------

					Widget:ClearAllPoints()
					Widget:SetPoint("TOP", InteractionSettingsFrame.Content.ScrollChildFrame, 0, -TotalHeight)

					--------------------------------

					if Widget_Type ~= "Group" then
						TotalHeight = TotalHeight + Widget_Height + Spacing
					end
				else
					Widget:SetAlpha(0)
				end
			end

			--------------------------------

			InteractionSettingsFrame.Content.ScrollChildFrame:SetHeight(TotalHeight)
		end

		InteractionSettingsFrame.Sidebar.Legend.Update = function()
			local WidgetPool = InteractionSettingsFrame.Sidebar.Legend.widgetPool

			if WidgetPool == nil then
				return
			end

			--------------------------------

			local TotalHeight = 0
			local Spacing = .5

			for i = 1, #WidgetPool do
				local Widget = WidgetPool[i]
				local Widget_Height = Widget:GetHeight()
				local Widget_Visible = Widget:GetAlpha() > 0

				if Widget_Visible then
					Widget:Show()

					--------------------------------

					Widget:ClearAllPoints()
					Widget:SetPoint("TOP", InteractionSettingsFrame.Sidebar.LegendScrollChildFrame, 0, -TotalHeight)

					--------------------------------

					TotalHeight = TotalHeight + Widget_Height + Spacing
				end
			end

			--------------------------------

			InteractionSettingsFrame.Sidebar.LegendScrollChildFrame:SetHeight(TotalHeight)

			--------------------------------

			local IsController = (addon.Input.Variables.IsController or addon.Input.Variables.SimulateController)

			InteractionSettingsFrame.Sidebar.Legend.GamePad:SetShown(IsController)
			if IsController then
				InteractionSettingsFrame.Sidebar.Legend:SetHeight(TotalHeight)
			end
		end
	end

	--------------------------------
	-- FUNCTIONS (ANIMATION)
	--------------------------------

	do -- ANIMATION
		InteractionSettingsFrame.ShowWithAnimation = function()
			InteractionSettingsFrame:Show()

			--------------------------------

			InteractionSettingsFrame:SetAlpha(0)
			InteractionSettingsFrame:SetScale(.75)
			InteractionSettingsFrame.Container:SetAlpha(0)

			--------------------------------

			AdaptiveAPI.Animation:Fade(InteractionSettingsFrame, .25, 0, 1, nil, function() return InteractionSettingsFrame.hidden end)
			AdaptiveAPI.Animation:Scale(InteractionSettingsFrame, .5, 2, 1, nil, AdaptiveAPI.Animation.EaseExpo, function() return InteractionSettingsFrame.hidden end)

			addon.Libraries.AceTimer:ScheduleTimer(function()
				AdaptiveAPI.Animation:Fade(InteractionSettingsFrame.Container, .5, 0, 1, nil, function() return InteractionSettingsFrame.hidden end)
			end, .325)
		end

		InteractionSettingsFrame.HideWithAnimation = function()
			addon.Libraries.AceTimer:ScheduleTimer(function()
				if InteractionSettingsFrame.hidden then
					InteractionSettingsFrame:Hide()
				end
			end, .25)

			--------------------------------

			AdaptiveAPI.Animation:Fade(InteractionSettingsFrame, .25, 1, 0, nil, function() return not InteractionSettingsFrame.hidden end)
			AdaptiveAPI.Animation:Scale(InteractionSettingsFrame, .5, 1, .875, nil, AdaptiveAPI.Animation.EaseExpo, function() return not InteractionSettingsFrame.hidden end)
			AdaptiveAPI.Animation:Fade(InteractionSettingsFrame.Container, .125, InteractionSettingsFrame.Container:GetAlpha(), 0, nil, function() return not InteractionSettingsFrame.hidden end)
		end

		function NS.Script:MoveActive()
			AdaptiveAPI.Animation:Scale(InteractionSettingsFrame.Background, .25, InteractionSettingsFrame.Background:GetScale(), .975, nil, AdaptiveAPI.Animation.EaseExpo, function() return not InteractionSettingsFrame.moving or InteractionSettingsFrame.hidden end)
			AdaptiveAPI.Animation:Fade(InteractionSettingsFrame, .125, InteractionSettingsFrame:GetAlpha(), .75, nil, function() return not InteractionSettingsFrame.moving or InteractionSettingsFrame.hidden end)
			AdaptiveAPI.Animation:Fade(InteractionSettingsFrame.Container, .075, InteractionSettingsFrame.Container:GetAlpha(), 0, nil, function() return not InteractionSettingsFrame.moving or InteractionSettingsFrame.hidden end)
		end

		function NS.Script:MoveDisabled()
			AdaptiveAPI.Animation:Scale(InteractionSettingsFrame.Background, .25, InteractionSettingsFrame.Background:GetScale(), 1, nil, AdaptiveAPI.Animation.EaseExpo, function() return InteractionSettingsFrame.moving or InteractionSettingsFrame.hidden end)
			AdaptiveAPI.Animation:Fade(InteractionSettingsFrame, .125, InteractionSettingsFrame:GetAlpha(), 1, nil, function() return InteractionSettingsFrame.moving or InteractionSettingsFrame.hidden end)
			AdaptiveAPI.Animation:Fade(InteractionSettingsFrame.Container, .075, InteractionSettingsFrame.Container:GetAlpha(), 1, nil, function() return InteractionSettingsFrame.moving or InteractionSettingsFrame.hidden end)
		end
	end

	--------------------------------
	-- SETTINGS
	--------------------------------

	do
		-- USE FOR GLOBAL TEXT SCALE WHEN IMPLEMENTED

		-- local function Settings_ContentSize()
		-- 	local TextSize = INTDB.profile.INT_CONTENT_SIZE

		-- 	local TargetScale = TextSize / 17.5
		-- 	InteractionSettingsParent:SetScale(TargetScale)
		-- end
		-- Settings_ContentSize()

		-- --------------------------------

		-- CallbackRegistry:Add("SETTINGS_CONTENT_SIZE_CHANGED", Settings_ContentSize, 2)
	end

	--------------------------------
	-- EVENTS
	--------------------------------

	do -- EVENTS

	end

	--------------------------------
	-- SETUP
	--------------------------------

	NS.Script:HideSettingsUI(true)
end
