local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local NS = addon.SettingsUI; addon.SettingsUI = NS

NS.Script = {}; local CB = NS.Script

function NS.Script:Load()
	local Frame = InteractionSettingsFrame

	do -- Tooltip
		function CB:ShowTooltip(frame, text, image, imageType, skipAnimation)
			if not text or text == "" then return end
			Frame.Tooltip.frame = frame
			Frame.Tooltip:Show()

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

			local showImageFrame = image and image ~= ""
			Frame.Tooltip.Content.Image:SetShown(showImageFrame)
			Frame.Tooltip.Content.Text:SetText(text)

			if showImageFrame then
				Frame.Tooltip.Content.ImageTexture:SetTexture(image)

				local width = imageType == "Small" and Frame.Tooltip.Content:GetWidth() / 2 or Frame.Tooltip.Content:GetWidth()
				local height = imageType == "Small" and width or width / 2
				Frame.Tooltip.Content.Image:SetSize(width, height)
			end
		end

		function CB:HideTooltip(skipAnimation)
			Frame.Tooltip.frame = nil

			local startPos = Frame.Tooltip:GetWidth() - 15
			local endPos = Frame.Tooltip:GetWidth()

			if skipAnimation then
				Frame.Tooltip:Hide()
			else
				addon.Libraries.AceTimer:ScheduleTimer(function()
					if Frame.Tooltip.frame == nil then
						Frame.Tooltip:Hide()
					end
				end, .25)

				addon.Libraries.AceTimer:ScheduleTimer(function()
					if not Frame.Tooltip.frame then
						addon.API.Animation:Fade(Frame.Tooltip, .125, Frame.Tooltip:GetAlpha(), 0)
						addon.API.Animation:Move(Frame.Tooltip, .25, "RIGHT", endPos, startPos, "x", addon.API.Animation.EaseExpo)
					end
				end, .1)
			end
		end
	end

	do -- Frame
		function CB:SelectTab(button, tabIndex)
			local tabPool = Frame.Content.ScrollFrame.tabPool

			local tab = tabPool[tabIndex]
			local tabButton = button
			local tabIndex = tabIndex

			do -- Tab Button
				do -- Reset All
					local widgetPool = Frame.Sidebar.Legend.widgetPool

					for i = 1, #widgetPool do
						if widgetPool[i].Button then
							local button = widgetPool[i].Button
							button:SetActive(false)
						end
					end
				end

				do -- Set
					tabButton:SetActive(true)
				end
			end

			do -- Tab
				do -- Hide All
					for i = 1, #tabPool do
						local currentTab = tabPool[i]
						local elements = currentTab.widgetPool

						currentTab:Hide()

						for e = 1, #elements do
							elements[e]:OnLeave()
						end
					end
				end

				do -- Show
					tab:Show()
					addon.API.Animation:Fade(tab, .25, 0, 1)
				end


				Frame.Content.ScrollFrame.tabIndex = tabIndex
			end

			CB:HideTooltip(true)
			Frame.Content.Header.Content.Title:SetText(tabButton:GetText())
			Frame.Content.ScrollFrame:SetVerticalScroll(0)

			CallbackRegistry:Trigger("SETTING_TAB_CHANGED", tab, tabButton, tabIndex)
		end

		function CB:ShowSettingsUI(bypass, focus)
			if (not addon.Initialize.Ready) then
				return
			end

			if (Frame.hidden) or (bypass) then
				Frame.hidden = false

				if bypass then Frame:Show() else
					Frame:ShowWithAnimation()
				end

				if focus then
					addon.HideUI.Variables.Lock = true
					addon.HideUI.Script:HideUI(true)
				end

				CB:SelectTab(Frame.Sidebar.Legend.widgetPool[1].Button, 1)
				CallbackRegistry:Trigger("START_SETTING")
			end
		end

		function CB:HideSettingsUI(bypass, focus)
			if not Frame.hidden or bypass then
				Frame.hidden = true

				if bypass then
					Frame:Hide()
				else
					Frame:HideWithAnimation()
				end

				if focus or addon.HideUI.Variables.Lock then
					addon.HideUI.Variables.Lock = false
					addon.HideUI.Script:ShowUI(true)
				end

				CallbackRegistry:Trigger("STOP_SETTING")
			end
		end

		function Interaction_ShowSettingsUI()
			CB:ShowSettingsUI(false, true)
		end







		local SPACING_CONTENT = 0
		local SPACING_LEGEND = .5

		function Frame.Content.ScrollFrame.Update(preventRepeat)
			if Frame.Content.ScrollFrame.tabIndex == nil then return end
			if preventRepeat and Frame.Content.ScrollFrame.LastUpdateTab == Frame.Content.ScrollFrame.tabIndex then return end

			Frame.Content.ScrollFrame.LastUpdateTab = Frame.Content.ScrollFrame.tabIndex
			C_Timer.After(.25, function() Frame.Content.ScrollFrame.LastUpdateTab = nil end)

			local widgetPool = Frame.Content.ScrollFrame.tabPool[Frame.Content.ScrollFrame.tabIndex].widgetPool
			if not widgetPool then return end

			local totalHeight = 0

			for i = 1, #widgetPool do
				local widget = widgetPool[i]
				local widgetType = widget.Type
				local widgetOpacity = widget.Opacity
				local widgetHeight = widget:GetHeight()
				local widgetVisible = widget:IsVisible()

				if widgetVisible then
					widget:SetAlpha(widgetOpacity)

					widget:ClearAllPoints()
					widget:SetPoint("TOP", Frame.Content.ScrollChildFrame, 0, -totalHeight)

					if widgetType ~= "Group" then
						totalHeight = totalHeight + widgetHeight + SPACING_CONTENT
					end
				else
					widget:SetAlpha(0)
				end
			end

			Frame.Content.ScrollChildFrame:SetHeight(totalHeight)
		end

		function Frame.Sidebar.Legend.Update()
			local widgetPool = Frame.Sidebar.Legend.widgetPool
			if not widgetPool then return end

			local totalHeight = 0
			for i = 1, #widgetPool do
				local widget = widgetPool[i]
				local widgetHeight = widget:GetHeight()
				local widgetVisible = widget:GetAlpha() > 0

				if widgetVisible then
					widget:Show()

					widget:ClearAllPoints()
					widget:SetPoint("TOP", Frame.Sidebar.LegendScrollChildFrame, 0, -totalHeight)

					totalHeight = totalHeight + widgetHeight + SPACING_LEGEND
				end
			end
			Frame.Sidebar.LegendScrollChildFrame:SetHeight(totalHeight)

			local isController = (addon.Input.Variables.IsController or addon.Input.Variables.SimulateController)
			Frame.Sidebar.Legend.GamePad:SetShown(isController)
			if isController then Frame.Sidebar.Legend:SetHeight(totalHeight) end
		end
	end

	do -- Animations
		do -- Show
			function Frame:ShowWithAnimation_StopEvent()
				return Frame.hidden
			end
			function Frame:ShowWithAnimation()
				Frame.PreventMouse = true
				addon.Libraries.AceTimer:ScheduleTimer(function()
					Frame.PreventMouse = false
				end, .25)

				Frame:Show()

				Frame:SetAlpha(0)
				Frame.Background:SetScale(2)
				Frame.Container:SetAlpha(0)

				addon.API.Animation:Fade(Frame, .25, 0, 1, nil, Frame.ShowWithAnimation_StopEvent)
				addon.API.Animation:Scale(Frame.Background, .5, 2, 1, nil, addon.API.Animation.EaseExpo, Frame.ShowWithAnimation_StopEvent)

				addon.Libraries.AceTimer:ScheduleTimer(function()
					addon.API.Animation:Fade(Frame.Container, .5, 0, 1, nil, Frame.ShowWithAnimation_StopEvent)
				end, .325)
			end
		end

		do -- Hide
			function Frame:HideWithAnimation_StopEvent()
				return not Frame.hidden
			end
			function Frame:HideWithAnimation()
				Frame.PreventMouse = true
				addon.Libraries.AceTimer:ScheduleTimer(function()
					Frame.PreventMouse = false

					if Frame.hidden then
						Frame:Hide()
					end
				end, .25)

				CB:HideTooltip(true)
				addon.API.Animation:Fade(Frame, .25, 1, 0, nil, Frame.HideWithAnimation_StopEvent)
				addon.API.Animation:Scale(Frame.Background, .5, 1, .875, nil, addon.API.Animation.EaseExpo, Frame.HideWithAnimation_StopEvent)
				addon.API.Animation:Fade(Frame.Container, .125, Frame.Container:GetAlpha(), 0, nil, Frame.HideWithAnimation_StopEvent)
			end
		end

		do -- Move
			do -- Active
				function CB:MoveActive_StopEvent()
					return not Frame.moving or Frame.hidden
				end

				function CB:MoveActive()
					addon.API.Animation:Scale(Frame.Background, .25, Frame.Background:GetScale(), .975, nil, addon.API.Animation.EaseExpo, CB.MoveActive_StopEvent)
					addon.API.Animation:Fade(Frame, .125, Frame:GetAlpha(), .75, nil, CB.MoveActive_StopEvent)
					addon.API.Animation:Fade(Frame.Container, .075, Frame.Container:GetAlpha(), 0, nil, CB.MoveActive_StopEvent)
				end
			end

			do -- Disabled
				function CB:MoveDisabled_StopEvent()
					return Frame.moving or Frame.hidden
				end

				function CB:MoveDisabled()
					addon.API.Animation:Scale(Frame.Background, .25, Frame.Background:GetScale(), 1, nil, addon.API.Animation.EaseExpo, CB.MoveDisabled_StopEvent)
					addon.API.Animation:Fade(Frame, .125, Frame:GetAlpha(), 1, nil, CB.MoveDisabled_StopEvent)
					addon.API.Animation:Fade(Frame.Container, .075, Frame.Container:GetAlpha(), 1, nil, CB.MoveDisabled_StopEvent)
				end
			end
		end
	end

	CB:HideSettingsUI(true)
end
