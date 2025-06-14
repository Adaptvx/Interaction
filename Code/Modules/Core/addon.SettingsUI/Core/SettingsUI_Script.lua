---@class addon
local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local PrefabRegistry = addon.PrefabRegistry
local L = addon.Locales
local NS = addon.SettingsUI; addon.SettingsUI = NS

--------------------------------

NS.Script = {}

--------------------------------

function NS.Script:Load()
	--------------------------------
	-- REFERENCES
	--------------------------------

	local Frame = InteractionSettingsFrame
	local Callback = NS.Script; NS.Script = Callback

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
				addon.API.Animation:Fade(Frame.Tooltip, .125, Frame.Tooltip:GetAlpha(), 1, nil, function() return not Frame:IsVisible() end)
				addon.API.Animation:Move(Frame.Tooltip, .25, "RIGHT", startPos, endPos, "x", addon.API.Animation.EaseExpo, function() return not Frame:IsVisible() end)
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
						addon.API.Animation:Fade(Frame.Tooltip, .125, Frame.Tooltip:GetAlpha(), 0)
						addon.API.Animation:Move(Frame.Tooltip, .25, "RIGHT", endPos, startPos, "x", addon.API.Animation.EaseExpo)
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

				do -- TAB BUTTON
					do -- RESET ALL
						local widgetPool = Frame.Sidebar.Legend.widgetPool

						--------------------------------

						for i = 1, #widgetPool do
							if widgetPool[i].Button then
								local button = widgetPool[i].Button
								button:SetActive(false)
							end
						end
					end

					do -- SET
						tabButton:SetActive(true)
					end
				end

				do -- TAB
					do -- HIDE ALL
						for i = 1, #tabPool do
							local currentTab = tabPool[i]
							local elements = currentTab.widgetPool

							--------------------------------

							currentTab:Hide()

							--------------------------------

							for element = 1, #elements do
								elements[element]:OnLeave()
							end
						end
					end

					do -- SHOW
						tab:Show()

						--------------------------------

						addon.API.Animation:Fade(tab, .25, 0, 1)
					end

					--------------------------------

					Frame.Content.ScrollFrame.tabIndex = tabIndex
				end

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
						Frame:ShowWithAnimation()
					end

					if focus then
						addon.HideUI.Variables.Lock = true
						addon.HideUI.Script:HideUI(true)
					end

					--------------------------------

					Callback:SelectTab(Frame.Sidebar.Legend.widgetPool[1].Button, 1)

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
						Frame:HideWithAnimation()
					end

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

				local widgetPool = Frame.Content.ScrollFrame.tabPool[Frame.Content.ScrollFrame.tabIndex].widgetPool

				if not widgetPool then
					return
				end

				--------------------------------

				local totalHeight = 0
				local spacing = 0

				for i = 1, #widgetPool do
					local widget = widgetPool[i]
					local widget_type = widget.Type
					local widget_opacity = widget.Opacity
					local widget_height = widget:GetHeight()
					local widget_visible = widget:IsVisible()

					--------------------------------

					if widget_visible then
						widget:SetAlpha(widget_opacity)

						--------------------------------

						widget:ClearAllPoints()
						widget:SetPoint("TOP", Frame.Content.ScrollChildFrame, 0, -totalHeight)

						--------------------------------

						if widget_type ~= "Group" then
							totalHeight = totalHeight + widget_height + spacing
						end
					else
						widget:SetAlpha(0)
					end
				end

				--------------------------------

				Frame.Content.ScrollChildFrame:SetHeight(totalHeight)
			end

			Frame.Sidebar.Legend.Update = function()
				local widgetPool = Frame.Sidebar.Legend.widgetPool

				if not widgetPool then
					return
				end

				--------------------------------

				local totalHeight = 0
				local spacing = .5

				for i = 1, #widgetPool do
					local widget = widgetPool[i]
					local widget_height = widget:GetHeight()
					local widget_visible = widget:GetAlpha() > 0

					if widget_visible then
						widget:Show()

						--------------------------------

						widget:ClearAllPoints()
						widget:SetPoint("TOP", Frame.Sidebar.LegendScrollChildFrame, 0, -totalHeight)

						--------------------------------

						totalHeight = totalHeight + widget_height + spacing
					end
				end

				--------------------------------

				Frame.Sidebar.LegendScrollChildFrame:SetHeight(totalHeight)

				--------------------------------

				local isController = (addon.Input.Variables.IsController or addon.Input.Variables.SimulateController)

				Frame.Sidebar.Legend.GamePad:SetShown(isController)
				if isController then
					Frame.Sidebar.Legend:SetHeight(totalHeight)
				end
			end
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

				addon.API.Animation:Fade(Frame, .25, 0, 1, nil, Frame.ShowWithAnimation_StopEvent)
				addon.API.Animation:Scale(Frame.Background, .5, 2, 1, nil, addon.API.Animation.EaseExpo, Frame.ShowWithAnimation_StopEvent)

				addon.Libraries.AceTimer:ScheduleTimer(function()
					addon.API.Animation:Fade(Frame.Container, .5, 0, 1, nil, Frame.ShowWithAnimation_StopEvent)
				end, .325)
			end
		end

		do -- HIDE
			function Frame:HideWithAnimation_StopEvent()
				return not Frame.hidden
			end

			function Frame:HideWithAnimation()
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

				addon.API.Animation:Fade(Frame, .25, 1, 0, nil, Frame.HideWithAnimation_StopEvent)
				addon.API.Animation:Scale(Frame.Background, .5, 1, .875, nil, addon.API.Animation.EaseExpo, Frame.HideWithAnimation_StopEvent)
				addon.API.Animation:Fade(Frame.Container, .125, Frame.Container:GetAlpha(), 0, nil, Frame.HideWithAnimation_StopEvent)
			end
		end

		do -- MOVE
			do -- ACTIVE
				function Callback:MoveActive_StopEvent()
					return not Frame.moving or Frame.hidden
				end

				function Callback:MoveActive()
					addon.API.Animation:Scale(Frame.Background, .25, Frame.Background:GetScale(), .975, nil, addon.API.Animation.EaseExpo, Callback.MoveActive_StopEvent)
					addon.API.Animation:Fade(Frame, .125, Frame:GetAlpha(), .75, nil, Callback.MoveActive_StopEvent)
					addon.API.Animation:Fade(Frame.Container, .075, Frame.Container:GetAlpha(), 0, nil, Callback.MoveActive_StopEvent)
				end
			end

			do -- DISABLED
				function Callback:MoveDisabled_StopEvent()
					return Frame.moving or Frame.hidden
				end

				function Callback:MoveDisabled()
					addon.API.Animation:Scale(Frame.Background, .25, Frame.Background:GetScale(), 1, nil, addon.API.Animation.EaseExpo, Callback.MoveDisabled_StopEvent)
					addon.API.Animation:Fade(Frame, .125, Frame:GetAlpha(), 1, nil, Callback.MoveDisabled_StopEvent)
					addon.API.Animation:Fade(Frame.Container, .075, Frame.Container:GetAlpha(), 1, nil, Callback.MoveDisabled_StopEvent)
				end
			end
		end
	end

	--------------------------------
	-- SETTINGS
	--------------------------------

	do
		-- USE FOR GLOBAL TEXT SCALE WHEN IMPLEMENTED

		-- local function Settings_ContentSize()
		-- 	local TextSize = addon.Database.DB_GLOBAL.profile.INT_CONTENT_SIZE

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

	do
		Callback:HideSettingsUI(true)
	end
end
