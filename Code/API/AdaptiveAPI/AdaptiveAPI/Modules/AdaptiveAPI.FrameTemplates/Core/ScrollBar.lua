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
	-- Creates a scrollbar.
	--
	-- Data Table
	----
	-- scrollFrame, scrollChildFrame, sizeX, sizeY, theme,
	-- customDefaultTexture, customHighlightTexture, customThumbTexture, customThumbHighlightTexture,
	-- customColor, customHighlightColor, customThumbColor, customThumbHighlightColor, isHorizontal
	---@param parent any
	---@param frameStrata string
	---@param data table
	---@param name? string
	function NS:CreateScrollbar(parent, frameStrata, data, name)
		local scrollFrame, scrollChildFrame, sizeX, sizeY, theme, customDefaultTexture, customHighlightTexture, customThumbTexture, customThumbHighlightTexture, customColor, customHighlightColor, customThumbColor, customThumbHighlightColor, isHorizontal =
			data.scrollFrame, data.scrollChildFrame, data.sizeX, data.sizeY, data.theme, data.customDefaultTexture, data.customHighlightTexture, data.customThumbTexture, data.customThumbHighlightTexture, data.customColor, data.customHighlightColor, data.customThumbColor, data.customThumbHighlightColor, data.isHorizontal

		--------------------------------

		local Frame = CreateFrame("Frame", name or "$parent.Scrollbar", parent)
		Frame:SetSize(sizeX, sizeY)
		Frame:SetFrameStrata(frameStrata)
		Frame:SetFrameLevel(10)

		Frame._DefaultTexture = nil
		Frame._HighlightTexture = nil
		Frame._ThumbTexture = nil
		Frame._ThumbHighlightTexture = nil
		Frame._DefaultColor = nil
		Frame._HighlightColor = nil
		Frame._ThumbColor = nil
		Frame._ThumbHighlightColor = nil

		Frame._CustomDefaultTexture = customDefaultTexture
		Frame._CustomHighlightTexture = customHighlightTexture
		Frame._CustomThumbTexture = customThumbTexture
		Frame._CustomThumbHighlightTexture = customThumbHighlightTexture
		Frame._CustomDefaultColor = customColor
		Frame._CustomHighlightColor = customHighlightColor
		Frame._CustomThumbColor = customThumbColor
		Frame._CustomThumbHighlightColor = customThumbHighlightColor

		--------------------------------

		do -- THEME
			local function UpdateTheme()
				if (theme and theme == 2) or (not theme and AdaptiveAPI.IsDarkTheme) then
					Frame._DefaultTexture = Frame._CustomDefaultTexture or AdaptiveAPI.PATH .. "Elements/scrollbar-background.png"
					Frame._HighlightTexture = Frame._CustomHighlightTexture or AdaptiveAPI.PATH .. "Elements/scrollbar-background-highlighted.png"
					Frame._ThumbTexture = Frame._CustomThumbTexture or AdaptiveAPI.PATH .. "Elements/scrollbar-thumb.png"
					Frame._ThumbHighlightTexture = Frame._CustomThumbHighlightTexture or AdaptiveAPI.PATH .. "Elements/scrollbar-thumb-highlighted.png"
					Frame._DefaultColor = Frame._CustomDefaultColor or { r = 1, g = 1, b = 1, a = .1 }
					Frame._HighlightColor = Frame._CustomHighlightColor or { r = 1, g = 1, b = 1, a = .1 }
					Frame._ThumbColor = Frame._CustomThumbColor or { r = 1, g = 1, b = 1, a = .25 }
					Frame._ThumbHighlightColor = Frame._CustomHighlightColor or { r = 1, g = 1, b = 1, a = .75 }
				end

				if (theme and theme == 1) or (not theme and not AdaptiveAPI.IsDarkTheme) then
					Frame._DefaultTexture = Frame._CustomDefaultTexture or AdaptiveAPI.PATH .. "Elements/scrollbar-background.png"
					Frame._HighlightTexture = Frame._CustomHighlightTexture or AdaptiveAPI.PATH .. "Elements/scrollbar-background-highlighted.png"
					Frame._ThumbTexture = Frame._CustomThumbTexture or AdaptiveAPI.PATH .. "Elements/scrollbar-thumb.png"
					Frame._ThumbHighlightTexture = Frame._CustomThumbHighlightTexture or AdaptiveAPI.PATH .. "Elements/scrollbar-thumb-highlighted.png"
					Frame._DefaultColor = Frame._CustomDefaultColor or { r = .1, g = .1, b = .1, a = .1 }
					Frame._HighlightColor = Frame._CustomHighlightColor or { r = .1, g = .1, b = .1, a = .1 }
					Frame._ThumbColor = Frame._CustomThumbColor or { r = .1, g = .1, b = .1, a = .5 }
					Frame._ThumbHighlightColor = Frame._CustomThumbHighlightColor or { r = .1, g = .1, b = .1, a = .75 }
				end
			end

			AdaptiveAPI:RegisterThemeUpdateWithNativeAPI(function()
				UpdateTheme()
			end, 4)
		end

		do -- ELEMENTS
			do -- BACKGROUND
				Frame.Background, Frame.BackgroundTexture = AdaptiveAPI.FrameTemplates:CreateNineSlice(Frame, frameStrata, Frame._DefaultTexture, 25, .5, "$parent.Background")
				Frame.Background:SetSize(isHorizontal and Frame:GetWidth() or Frame:GetWidth() * .5, isHorizontal and Frame:GetHeight() * .5 or Frame:GetHeight())
				Frame.Background:SetPoint("CENTER", Frame, 0, 0)
				Frame.Background:SetFrameStrata(frameStrata)
				Frame.Background:SetFrameLevel(9)

				AdaptiveAPI:RegisterThemeUpdateWithNativeAPI(function()
					Frame.BackgroundTexture:SetTexture(Frame._DefaultTexture)
					Frame.BackgroundTexture:SetVertexColor(Frame._DefaultColor.r, Frame._DefaultColor.g, Frame._DefaultColor.b, Frame._DefaultColor.a)
				end, 5)
			end

			do -- THUMB
				Frame.Thumb, Frame.ThumbTexture = AdaptiveAPI.FrameTemplates:CreateNineSlice(Frame, frameStrata, Frame._ThumbTexture, 25, .5, "$parent.Thumb")
				Frame.Thumb:SetSize(isHorizontal and 25 or Frame:GetWidth(), isHorizontal and Frame:GetHeight() or 25)
				Frame.Thumb:SetPoint(isHorizontal and "LEFT" or "TOP", Frame, isHorizontal and 0 or 0, isHorizontal and 0 or 0)
				Frame.ThumbTexture:SetVertexColor(Frame._ThumbColor.r, Frame._ThumbColor.g, Frame._ThumbColor.b, Frame._ThumbColor.a)

				AdaptiveAPI:RegisterThemeUpdateWithNativeAPI(function()
					Frame.ThumbTexture:SetTexture(Frame._ThumbTexture)
					Frame.ThumbTexture:SetVertexColor(Frame._ThumbColor.r, Frame._ThumbColor.g, Frame._ThumbColor.b, Frame._ThumbColor.a)
				end, 5)
			end
		end

		--------------------------------

		do -- CLICK EVENTS
			Frame.Enter = function()
				Frame.BackgroundTexture:SetTexture(Frame._HighlightTexture)
				Frame.BackgroundTexture:SetVertexColor(Frame._HighlightColor.r, Frame._HighlightColor.g, Frame._HighlightColor.b, Frame._HighlightColor.a)

				Frame.ThumbTexture:SetTexture(Frame._ThumbTexture)
				Frame.ThumbTexture:SetVertexColor(Frame._ThumbHighlightColor.r, Frame._ThumbHighlightColor.g, Frame._ThumbHighlightColor.b, Frame._ThumbHighlightColor.a)

				if isHorizontal then
					AdaptiveAPI.Animation:Scale(Frame.Thumb, .5, Frame.Thumb:GetHeight(), Frame:GetHeight() * 2, "y", AdaptiveAPI.Animation.EaseExpo, function() return not Frame.MouseOver end)
				else
					AdaptiveAPI.Animation:Scale(Frame.Thumb, .5, Frame.Thumb:GetWidth(), Frame:GetWidth() * 2, "x", AdaptiveAPI.Animation.EaseExpo, function() return not Frame.MouseOver end)
				end
			end

			Frame.Leave = function()
				Frame.BackgroundTexture:SetTexture(Frame._DefaultTexture)
				Frame.BackgroundTexture:SetVertexColor(Frame._DefaultColor.r, Frame._DefaultColor.g, Frame._DefaultColor.b, Frame._DefaultColor.a)

				Frame.ThumbTexture:SetTexture(Frame._ThumbTexture)
				Frame.ThumbTexture:SetVertexColor(Frame._ThumbColor.r, Frame._ThumbColor.g, Frame._ThumbColor.b, Frame._ThumbColor.a)

				if isHorizontal then
					AdaptiveAPI.Animation:Scale(Frame.Thumb, .5, Frame.Thumb:GetHeight(), Frame:GetHeight(), "y", AdaptiveAPI.Animation.EaseExpo, function() return Frame.MouseOver end)
				else
					AdaptiveAPI.Animation:Scale(Frame.Thumb, .5, Frame.Thumb:GetWidth(), Frame:GetWidth(), "x", AdaptiveAPI.Animation.EaseExpo, function() return Frame.MouseOver end)
				end
			end

			Frame.MouseDown = function()
				Frame:SetAlpha(.75)
			end

			Frame.MouseUp = function()
				Frame:SetAlpha(1)
			end

			Frame.Thumb:SetScript("OnEnter", function()
				Frame.MouseOver = true
				Frame.Enter()
			end)

			Frame.Thumb:SetScript("OnLeave", function()
				Frame.MouseOver = false
				if not Frame.Thumb.isDragging then
					Frame.Leave()
				end
			end)

			Frame.Thumb:SetScript("OnMouseDown", function()
				Frame.MouseDown()
			end)

			Frame.Thumb:SetScript("OnMouseUp", function()
				Frame.MouseUp()

				if not Frame.MouseOver then
					Frame.Leave()
				end
			end)
		end

		do -- DRAGGING
			Frame.Thumb.isDragging = false

			local originX
			local originY
			local startX
			local startY

			function Scrollbar_LimitThumbToFrame(thumb, boundaryFrame, restrictAxis)
				local point, relativeTo, relativePoint, offsetX, offsetY = thumb:GetPoint()
				local height = boundaryFrame:GetHeight()
				local width = boundaryFrame:GetWidth()

				local newX = offsetX
				local newY = offsetY

				if restrictAxis == "X" then
					if math.abs(offsetX) + thumb:GetWidth() > width then
						if offsetX < 0 then
							newX = -(width - thumb:GetWidth())
						else
							newX = width - thumb:GetWidth()
						end
					end

					if offsetX < 0 then
						newX = 0
					end

					thumb:ClearAllPoints()
					thumb:SetPoint("LEFT", boundaryFrame, newX, 0)

					local value = (newX) / (width - thumb:GetWidth())
					return value
				else
					if math.abs(offsetY) + thumb:GetHeight() > height then
						if offsetY < 0 then
							newY = -(height - thumb:GetHeight())
						else
							newY = height - thumb:GetHeight()
						end
					end

					if offsetY > 0 then
						newY = 0
					end

					thumb:ClearAllPoints()
					thumb:SetPoint("TOP", boundaryFrame, 0, newY)

					local value = (newY) / (height - thumb:GetHeight())
					return value
				end
			end

			local function GetMouseOffset(startX, startY)
				local offsetX, offsetY = AdaptiveAPI:GetMouseDelta(startX, startY)
				return offsetX, offsetY
			end

			local function Scrollbar_OnMouseDown()
				local point, relativeTo, relativePoint, offsetX, offsetY = Frame.Thumb:GetPoint()
				originX = offsetX
				originY = offsetY

				startX, startY = GetCursorPosition()

				Frame.Thumb.isDragging = true
			end

			local function Scrollbar_OnMouseUp()
				originX = nil
				originY = nil
				startX, startY = nil, nil
				Frame.Thumb.isDragging = false
			end

			local function Scrollbar_OnUpdate()
				local verticalScrollRange = scrollFrame:GetVerticalScrollRange()
				local horizontalScrollRange = scrollFrame:GetHorizontalScrollRange()
				local verticalScroll = scrollFrame:GetVerticalScroll()
				local horizontalScroll = scrollFrame:GetHorizontalScroll()

				if (not isHorizontal and verticalScrollRange > 0) or (isHorizontal and horizontalScrollRange > 0) then
					if Frame.Thumb.isDragging then
						local offsetX, offsetY = GetMouseOffset(startX, startY)

						Frame.Thumb:ClearAllPoints()
						if isHorizontal then
							Frame.Thumb:SetPoint("LEFT", Frame, originX + (offsetX / Frame:GetEffectiveScale()), 0)
							Frame.Value = Scrollbar_LimitThumbToFrame(Frame.Thumb, Frame, "X")
							scrollFrame:SetHorizontalScroll((horizontalScrollRange) * Frame.Value)
						else
							Frame.Thumb:SetPoint("TOP", Frame, 0, originY - (offsetY / Frame:GetEffectiveScale()))
							Frame.Value = Scrollbar_LimitThumbToFrame(Frame.Thumb, Frame, "Y")
							scrollFrame:SetVerticalScroll(math.abs((scrollChildFrame:GetHeight() - scrollFrame:GetHeight()) * Frame.Value))
						end
					else
						local frameHeight = Frame:GetHeight()
						local thumbHeight = Frame.Thumb:GetHeight()
						local frameWidth = Frame:GetWidth()
						local thumbWidth = Frame.Thumb:GetWidth()

						if isHorizontal then
							Frame.Thumb:SetPoint("LEFT", Frame, (frameWidth - thumbWidth) * (horizontalScroll / horizontalScrollRange), 0)
						else
							Frame.Thumb:SetPoint("TOP", Frame, 0, -(frameHeight - thumbHeight) * (verticalScroll / verticalScrollRange))
						end
					end

					local newThumbSize = isHorizontal and math.max(25, Frame:GetWidth() * (scrollFrame:GetWidth() / scrollChildFrame:GetWidth())) or math.max(25, Frame:GetHeight() * (scrollFrame:GetHeight() / scrollChildFrame:GetHeight()))

					if isHorizontal then
						if newThumbSize < Frame:GetWidth() then
							Frame.Thumb:Show()
							Frame.Thumb:SetWidth(newThumbSize)
						else
							Frame.Thumb:Hide()
						end
					else
						if newThumbSize < Frame:GetHeight() then
							Frame.Thumb:Show()
							Frame.Thumb:SetHeight(newThumbSize)
						else
							Frame.Thumb:Hide()
						end
					end
				else
					Frame.Thumb:Hide()
				end
			end

			Frame.Thumb:HookScript("OnMouseDown", Scrollbar_OnMouseDown)
			Frame.Thumb:HookScript("OnMouseUp", Scrollbar_OnMouseUp)
			Frame:SetScript("OnUpdate", Scrollbar_OnUpdate)
		end

		--------------------------------

		return Frame
	end

	-- Updates the theme of a scrollbar.
	--
	-- Data Table
	----
	-- customDefaultTexture, customHighlightTexture, customThumbTexture, customThumbHighlightTexture,
	-- customColor, customHighlightColor, customThumbColor, customThumbHighlightColor
	---@param scrollbar any
	---@param data table
	function NS:UpdateScrollbarTheme(scrollbar, data)
		local customDefaultTexture, customHighlightTexture, customThumbTexture, customThumbHighlightTexture, customColor, customHighlightColor, customThumbColor, customThumbHighlightColor =
			data.customDefaultTexture, data.customHighlightTexture, data.customThumbTexture, data.customThumbHighlightTexture, data.customColor, data.customHighlightColor, data.customThumbColor, data.customThumbHighlightColor

		--------------------------------

		if customDefaultTexture then scrollbar._CustomDefaultTexture = customDefaultTexture end
		if customHighlightTexture then scrollbar._CustomHighlightTexture = customHighlightTexture end
		if customThumbTexture then scrollbar._CustomThumbTexture = customThumbTexture end
		if customThumbHighlightTexture then scrollbar._CustomThumbHighlightTexture = customThumbHighlightTexture end
		if customColor then scrollbar._CustomDefaultColor = customColor end
		if customHighlightColor then scrollbar._CustomHighlightColor = customHighlightColor end
		if customThumbColor then scrollbar._CustomThumbColor = customThumbColor end
		if customThumbHighlightColor then scrollbar._CustomThumbHighlightColor = customThumbHighlightColor end
	end
end
