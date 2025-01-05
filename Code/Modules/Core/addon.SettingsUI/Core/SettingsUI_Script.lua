local addonName, addon = ...
local CallbackRegistry = addon.CallbackRegistry
local L = addon.Locales
local NS = addon.SettingsUI

--------------------------------

NS.Script = {}

--------------------------------

function NS.Script:Load()
	--------------------------------
	-- REFERENCES
	--------------------------------

	local Frame = InteractionSettingsFrame
	local Callback = NS.Script

	--------------------------------
	-- FUNCTIONS (TOOLTIP)
	--------------------------------

	do
		function Callback:ShowTooltip(frame, text, image, imageType, skipAnimation)
			if not text or text == "" then
				return
			end

			--------------------------------

			Frame.Tooltip.frame = frame

			--------------------------------

			Frame.Tooltip:Show()

			--------------------------------

			local startPos = Frame.Tooltip:GetWidth() - 15
			local endPos = Frame.Tooltip:GetWidth()

			Frame.Tooltip:SetPoint("RIGHT", Frame.Tooltip.frame, 225, 0)

			if not skipAnimation then
				AdaptiveAPI.Animation:Fade(Frame.Tooltip, .125, Frame.Tooltip:GetAlpha(), 1, nil, function() return not Frame:IsVisible() end)
				AdaptiveAPI.Animation:Move(Frame.Tooltip, .25, "RIGHT", startPos, endPos, "x", AdaptiveAPI.Animation.EaseExpo, function() return not Frame:IsVisible() end)
			else
				Frame.Tooltip:SetAlpha(1)
				Frame.Tooltip:SetPoint("RIGHT", Frame.Tooltip.frame, endPos, 0)
			end

			--------------------------------

			if image and image ~= "" then
				Frame.Tooltip.Content.Image:Show()
				Frame.Tooltip.Content.ImageTexture:SetTexture(image)

				--------------------------------

				local width = imageType == "Small" and Frame.Tooltip.Content:GetWidth() / 2 or Frame.Tooltip.Content:GetWidth()
				local height = imageType == "Small" and width or width / 2

				--------------------------------

				if imageType == "Small" then
					Frame.Tooltip.Content.Image:SetSize(width, height)
				end

				if imageType == "Large" then
					Frame.Tooltip.Content.Image:SetSize(width, height)
				end
			else
				Frame.Tooltip.Content.Image:Hide()
			end

			--------------------------------

			Frame.Tooltip.Content.Text:SetText(text)
		end

		function Callback:HideTooltip(skipAnimation)
			Frame.Tooltip.frame = nil

			--------------------------------

			local startPos = Frame.Tooltip:GetWidth() - 15
			local endPos = Frame.Tooltip:GetWidth()

			--------------------------------

			if skipAnimation then
				Frame.Tooltip:Hide()
			else
				addon.Libraries.AceTimer:ScheduleTimer(function()
					if Frame.Tooltip.frame == nil then
						Frame.Tooltip:Hide()
					end
				end, .25)

				--------------------------------

				addon.Libraries.AceTimer:ScheduleTimer(function()
					if not Frame.Tooltip.frame then
						AdaptiveAPI.Animation:Fade(Frame.Tooltip, .125, Frame.Tooltip:GetAlpha(), 0)
						AdaptiveAPI.Animation:Move(Frame.Tooltip, .25, "RIGHT", endPos, startPos, "x", AdaptiveAPI.Animation.EaseExpo)
					end
				end, .1)
			end
		end
	end

	--------------------------------
	-- FUNCTIONS (FRAME)
	--------------------------------

	do
		do -- FRAME
			function Callback:SelectTab(button, tabIndex)
				local tabPool = Frame.Content.ScrollFrame.tabPool

				local tab = tabPool[tabIndex]
				local tabButton = button
				local tabIndex = tabIndex

				--------------------------------

				local function TabButton()
					local function ResetAll()
						local widgetPool = Frame.Sidebar.Legend.widgetPool

						--------------------------------

						for i = 1, #widgetPool do
							if widgetPool[i].Button then
								local button = widgetPool[i].Button
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

					Frame.Content.ScrollFrame.tabIndex = tabIndex
				end

				--------------------------------

				TabButton()
				Tab()

				--------------------------------

				Callback:HideTooltip(true)
				Frame.Content.Header.Content.Title:SetText(tabButton:GetText())
				Frame.Content.ScrollFrame:SetVerticalScroll(0)

				--------------------------------

				CallbackRegistry:Trigger("SETTING_TAB_CHANGED", tab, tabButton, tabIndex)
			end

			function Callback:ShowSettingsUI(bypass, focus)
				if (not addon.Initialize.Ready) then
					return
				end

				--------------------------------

				if (Frame.hidden) or (bypass) then
					Frame.hidden = false

					--------------------------------

					if bypass then
						Frame:Show()
					else
						Frame.ShowWithAnimation()
					end

					--------------------------------

					Callback:SelectTab(Frame.Sidebar.Legend.widgetPool[1].Button, 1)

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

			function Callback:HideSettingsUI(bypass, focus)
				if not Frame.hidden or bypass then
					Frame.hidden = true

					--------------------------------

					if bypass then
						Frame:Hide()
					else
						Frame.HideWithAnimation()
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
				Callback:ShowSettingsUI(false, true)
			end
		end

		do -- SCROLL FRAME
			Frame.Content.ScrollFrame.Update = function(PreventRepeat)
				if Frame.Content.ScrollFrame.tabIndex == nil then
					return
				end

				--------------------------------

				if PreventRepeat then
					if Frame.Content.ScrollFrame.LastUpdateTab == Frame.Content.ScrollFrame.tabIndex then
						return
					end
				end

				Frame.Content.ScrollFrame.LastUpdateTab = Frame.Content.ScrollFrame.tabIndex
				addon.Libraries.AceTimer:ScheduleTimer(function()
					Frame.Content.ScrollFrame.LastUpdateTab = nil
				end, .25)

				--------------------------------

				local WidgetPool = Frame.Content.ScrollFrame.tabPool[Frame.Content.ScrollFrame.tabIndex].widgetPool

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
						Widget:SetPoint("TOP", Frame.Content.ScrollChildFrame, 0, -TotalHeight)

						--------------------------------

						if Widget_Type ~= "Group" then
							TotalHeight = TotalHeight + Widget_Height + Spacing
						end
					else
						Widget:SetAlpha(0)
					end
				end

				--------------------------------

				Frame.Content.ScrollChildFrame:SetHeight(TotalHeight)
			end

			Frame.Sidebar.Legend.Update = function()
				local WidgetPool = Frame.Sidebar.Legend.widgetPool

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
						Widget:SetPoint("TOP", Frame.Sidebar.LegendScrollChildFrame, 0, -TotalHeight)

						--------------------------------

						TotalHeight = TotalHeight + Widget_Height + Spacing
					end
				end

				--------------------------------

				Frame.Sidebar.LegendScrollChildFrame:SetHeight(TotalHeight)

				--------------------------------

				local IsController = (addon.Input.Variables.IsController or addon.Input.Variables.SimulateController)

				Frame.Sidebar.Legend.GamePad:SetShown(IsController)
				if IsController then
					Frame.Sidebar.Legend:SetHeight(TotalHeight)
				end
			end
		end
	end

	--------------------------------
	-- FUNCTIONS (ANIMATION)
	--------------------------------

	do
		Frame.ShowWithAnimation = function()
			Frame.PreventMouse = true
			addon.Libraries.AceTimer:ScheduleTimer(function()
				Frame.PreventMouse = false
			end, .25)

			--------------------------------

			Frame:Show()

			--------------------------------

			Frame:SetAlpha(0)
			Frame.Background:SetScale(2)
			Frame.Container:SetAlpha(0)

			--------------------------------

			AdaptiveAPI.Animation:Fade(Frame, .25, 0, 1, nil, function() return Frame.hidden end)
			AdaptiveAPI.Animation:Scale(Frame.Background, .5, 2, 1, nil, AdaptiveAPI.Animation.EaseExpo, function() return Frame.hidden end)

			addon.Libraries.AceTimer:ScheduleTimer(function()
				AdaptiveAPI.Animation:Fade(Frame.Container, .5, 0, 1, nil, function() return Frame.hidden end)
			end, .325)
		end

		Frame.HideWithAnimation = function()
			Frame.PreventMouse = true
			addon.Libraries.AceTimer:ScheduleTimer(function()
				Frame.PreventMouse = false

				--------------------------------

				if Frame.hidden then
					Frame:Hide()
				end
			end, .25)

			--------------------------------

			Callback:HideTooltip(true)

			--------------------------------

			AdaptiveAPI.Animation:Fade(Frame, .25, 1, 0, nil, function() return not Frame.hidden end)
			AdaptiveAPI.Animation:Scale(Frame.Background, .5, 1, .875, nil, AdaptiveAPI.Animation.EaseExpo, function() return not Frame.hidden end)
			AdaptiveAPI.Animation:Fade(Frame.Container, .125, Frame.Container:GetAlpha(), 0, nil, function() return not Frame.hidden end)
		end

		function Callback:MoveActive()
			AdaptiveAPI.Animation:Scale(Frame.Background, .25, Frame.Background:GetScale(), .975, nil, AdaptiveAPI.Animation.EaseExpo, function() return not Frame.moving or Frame.hidden end)
			AdaptiveAPI.Animation:Fade(Frame, .125, Frame:GetAlpha(), .75, nil, function() return not Frame.moving or Frame.hidden end)
			AdaptiveAPI.Animation:Fade(Frame.Container, .075, Frame.Container:GetAlpha(), 0, nil, function() return not Frame.moving or Frame.hidden end)
		end

		function Callback:MoveDisabled()
			AdaptiveAPI.Animation:Scale(Frame.Background, .25, Frame.Background:GetScale(), 1, nil, AdaptiveAPI.Animation.EaseExpo, function() return Frame.moving or Frame.hidden end)
			AdaptiveAPI.Animation:Fade(Frame, .125, Frame:GetAlpha(), 1, nil, function() return Frame.moving or Frame.hidden end)
			AdaptiveAPI.Animation:Fade(Frame.Container, .075, Frame.Container:GetAlpha(), 1, nil, function() return Frame.moving or Frame.hidden end)
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

	do

	end

	--------------------------------
	-- SETUP
	--------------------------------

	Callback:HideSettingsUI(true)
end
