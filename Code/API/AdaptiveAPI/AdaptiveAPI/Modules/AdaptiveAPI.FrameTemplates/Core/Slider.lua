local addonName, addon = ...
local NS = AdaptiveAPI.FrameTemplates
local CallbackRegistry = addon.CallbackRegistry

--------------------------------
-- VARIABLES
--------------------------------

do -- MAIN

end

do -- CONSTANTS

end

--------------------------------
-- TEMPLATES
--------------------------------

do
	function NS:CreateSlider(parent, frameStrata, theme, min, max, getFunc, setFunc, updateFunc, name)

	end
end


---------------------------------
-- STYLES
---------------------------------

do
	-- Style a slider.
	-- Data Table
	----
	-- theme, defaultTexture, highlightTexture, thumbTexture, thumbHighlightTexture, customColor, customThumbColor, grid
	---@param frame any
	---@param data table
	function NS.Styles:Slider(frame, data)
		local theme, defaultTexture, highlightTexture, thumbTexture, thumbHighlightTexture, customColor, customThumbColor, grid =
			data.theme, data.defaultTexture, data.highlightTexture, data.thumbTexture, data.thumbHighlightTexture, data.customColor, data.customThumbColor, data.grid

		--------------------------------

		frame._DefaultTexture = nil
		frame._HighlightTexture = nil
		frame._ThumbTexture = nil
		frame._ThumbHighlightTexture = nil
		frame._BackgroundColor = nil
		frame._ThumbColor = nil

		frame._CustomDefaultTexture = defaultTexture
		frame._CustomHighlightTexture = highlightTexture
		frame._CustomThumbTexture = thumbTexture
		frame._CustomThumbHighlightTexture = thumbHighlightTexture
		frame._CustomColor = customColor
		frame._CustomThumbColor = customThumbColor

		frame.EnterCallbacks = {}
		frame.LeaveCallbacks = {}
		frame.MouseDownCallbacks = {}
		frame.MouseUpCallbacks = {}
		frame.ValueChangedCallbacks = {}

		--------------------------------

		do -- THEME
			local function UpdateTheme()
				if (theme and theme == 2) or (not theme and AdaptiveAPI.IsDarkTheme) then
					frame._DefaultTexture = frame._CustomDefaultTexture or (AdaptiveAPI.PATH .. "Elements/slider-background.png")
					frame._HighlightTexture = frame._CustomHighlightTexture or (AdaptiveAPI.PATH .. "Elements/slider-background-highlighted.png")
					frame._ThumbTexture = frame._CustomThumbTexture or (AdaptiveAPI.PATH .. "Elements/slider-thumb.png")
					frame._ThumbHighlightTexture = frame._ThumbHighlightTexture or (AdaptiveAPI.PATH .. "Elements/slider-thumb-highlighted.png")

					frame._BackgroundColor = frame._CustomColor or AdaptiveAPI.RGB_WHITE
					frame._ThumbColor = frame._CustomThumbColor or { r = 1, g = 1, b = 1 }
				elseif (theme and theme == 1) or (not theme and not AdaptiveAPI.IsDarkTheme) then
					frame._DefaultTexture = frame._CustomDefaultTexture or (AdaptiveAPI.PATH .. "Elements/slider-background.png")
					frame._HighlightTexture = frame._CustomHighlightTexture or (AdaptiveAPI.PATH .. "Elements/slider-background-highlighted.png")
					frame._ThumbTexture = frame._CustomThumbTexture or (AdaptiveAPI.PATH .. "Elements/slider-thumb.png")
					frame._ThumbHighlightTexture = frame._ThumbHighlightTexture or (AdaptiveAPI.PATH .. "Elements/slider-thumb-highlighted.png")

					frame._BackgroundColor = frame._CustomColor or AdaptiveAPI.RGB_BLACK
					frame._ThumbColor = frame._CustomThumbColor or { r = .1, g = .1, b = .1 }
				end
			end

			AdaptiveAPI:RegisterThemeUpdateWithNativeAPI(UpdateTheme, 4)
		end

		do -- ELEMENTS
			do -- BACKGROUND
				frame.Background, frame.BackgroundTexture = AdaptiveAPI.FrameTemplates:CreateNineSlice(frame, frame:GetFrameStrata(), frame._DefaultTexture, 50, 1, "$parent.Background")
				frame.Background:SetPoint("BOTTOM", frame, 0, 5)
				frame.Background:SetFrameLevel(frame:GetFrameLevel() - 2)
				frame.BackgroundTexture:SetAlpha(.125)

				AdaptiveAPI:RegisterThemeUpdateWithNativeAPI(function()
					frame.BackgroundTexture:SetVertexColor(frame._BackgroundColor.r, frame._BackgroundColor.g, frame._BackgroundColor.b, frame._BackgroundColor.a)
				end, 5)
			end

			do -- THUMB
				frame.ThumbNew, frame.ThumbNewTexture = AdaptiveAPI.FrameTemplates:CreateTexture(frame, frame:GetFrameStrata(), frame._CustomThumbTexture or frame._ThumbTexture, "$parent.ThumbNew")
				frame.ThumbNew:SetFrameLevel(frame:GetFrameLevel() - 1)
				frame.ThumbNewTexture:SetAlpha(1)

				AdaptiveAPI:RegisterThemeUpdateWithNativeAPI(function()
					frame.ThumbNewTexture:SetVertexColor(frame._ThumbColor.r, frame._ThumbColor.g, frame._ThumbColor.b, frame._ThumbColor.a)
				end, 5)
			end

			do -- GRIDS
				if grid then
					addon.Libraries.AceTimer:ScheduleTimer(function()
						local function CreateGrid()
							local Grid, GridTexture = AdaptiveAPI.FrameTemplates:CreateNineSlice(frame, frame:GetFrameStrata(), frame._DefaultTexture, 50, .5)
							Grid:SetSize(2.5, 2.5)
							Grid:SetFrameLevel(frame:GetFrameLevel() - 2)
							GridTexture:SetVertexColor(frame._BackgroundColor.r, frame._BackgroundColor.g, frame._BackgroundColor.b, frame._BackgroundColor.a)
							GridTexture:SetAlpha(.125)

							AdaptiveAPI:RegisterThemeUpdateWithNativeAPI(function()
								GridTexture:SetVertexColor(frame._BackgroundColor.r, frame._BackgroundColor.g, frame._BackgroundColor.b, frame._BackgroundColor.a)
							end, 5)

							--------------------------------

							return Grid, GridTexture
						end

						--------------------------------

						local min, max = frame:GetMinMaxValues()
						local stepSize = frame:GetValueStep()
						local numSteps = (max / stepSize) + 1
						local numGrids = numSteps

						--------------------------------

						local grids = {}

						for i = 1, numGrids do
							local Grid, GridTexture = CreateGrid()

							--------------------------------

							table.insert(grids, Grid)
						end

						frame.Grids = grids
					end, 1)
				end
			end
		end

		do -- CLICK EVENTS
			addon.Libraries.AceTimer:ScheduleTimer(function()
				frame:HookScript("OnValueChanged", function(self, new, userInput)
					frame.Background:SetSize(frame:GetWidth(), 2.5)

					--------------------------------

					local value = frame:GetValue()
					local min, max = frame:GetMinMaxValues()
					local stepSize = frame:GetValueStep()
					local numSteps = (max / stepSize) + 1

					local thumbWidth = (frame:GetWidth()) / (numSteps - 1)
					if thumbWidth < 20 then
						thumbWidth = 20
					end
					local thumbPosition
					if value > min then
						thumbPosition = (frame:GetWidth() - thumbWidth) / ((max - min) / (value - min))
					else
						thumbPosition = 0
					end

					frame.ThumbNew:SetSize(thumbWidth, 5)
					frame.ThumbNew:SetPoint("BOTTOMLEFT", thumbPosition, 5)

					--------------------------------

					if frame.Grids then
						for i = 1, #frame.Grids do
							local currentGrid = frame.Grids[i]

							currentGrid:Hide()
						end

						for i = 1, numSteps do
							local currentGrid = frame.Grids[i]

							currentGrid:Show()
							currentGrid:ClearAllPoints()
							currentGrid:SetPoint("BOTTOMLEFT", frame, ((frame:GetWidth() - currentGrid:GetHeight()) / (numSteps - 1)) * (i - 1), 7.5)
						end
					end

					--------------------------------

					if userInput then
						local valueChangedCallbacks = frame.ValueChangedCallbacks

						for i = 1, #valueChangedCallbacks do
							valueChangedCallbacks[i]()
						end
					end
				end)
			end, .1)

			frame.Enter = function()
				frame.ThumbNewTexture:SetTexture(frame._ThumbHighlightTexture)

				--------------------------------

				local enterCallbacks = frame.EnterCallbacks

				for callback = 1, #enterCallbacks do
					enterCallbacks[callback]()
				end
			end

			frame.Leave = function()
				frame.ThumbNewTexture:SetTexture(frame._ThumbTexture)

				--------------------------------

				local leaveCallbacks = frame.LeaveCallbacks

				for callback = 1, #leaveCallbacks do
					leaveCallbacks[callback]()
				end
			end

			frame.MouseDown = function()
				local mouseDownCallbacks = frame.MouseDownCallbacks

				for callback = 1, #mouseDownCallbacks do
					mouseDownCallbacks[callback]()
				end
			end

			frame.MouseUp = function()
				local mouseUpCallbacks = frame.MouseUpCallbacks

				for callback = 1, #mouseUpCallbacks do
					mouseUpCallbacks[callback]()
				end
			end

			AdaptiveAPI.FrameTemplates:CreateMouseResponder(frame, frame.Enter, frame.Leave)

			frame.ThumbNew:SetScript("OnEnter", function()
				frame.ThumbNew:SetAlpha(.75)
			end)

			frame.ThumbNew:SetScript("OnLeave", function()
				frame.ThumbNew:SetAlpha(1)
			end)

			frame:SetScript("OnMouseDown", function()
				frame.MouseDown()
			end)

			frame:SetScript("OnMouseUp", function()
				frame.MouseUp()
			end)
		end

		--------------------------------

		do -- BLIZZARD
			frame.Left:Hide()
			frame.Middle:Hide()
			frame.Right:Hide()
			frame.Thumb:SetAlpha(0)
		end
	end

	-- Update a slider theme.
	-- Data Table
	----
	-- defaultTexture, highlightTexture, thumbTexture, thumbHighlightTexture, customColor, customThumbColor
	---@param frame any
	---@param data table
	function NS.Styles:UpdateSlider(frame, data)
		local defaultTexture, highlightTexture, thumbTexture, thumbHighlightTexture, customColor, customThumbColor =
			data.defaultTexture, data.highlightTexture, data.thumbTexture, data.thumbHighlightTexture, data.customColor, data.customThumbColor

		--------------------------------

		if defaultTexture then frame._CustomDefaultTexture = defaultTexture end
		if highlightTexture then frame._CustomHighlightTexture = highlightTexture end
		if thumbTexture then frame._CustomThumbTexture = thumbTexture end
		if thumbHighlightTexture then frame._CustomThumbHighlightTexture = thumbHighlightTexture end
		if customColor then frame._CustomColor = customColor end
		if customThumbColor then frame._CustomThumbColor = customThumbColor end
	end
end
