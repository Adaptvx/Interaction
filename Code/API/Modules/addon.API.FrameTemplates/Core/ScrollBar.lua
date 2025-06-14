---@class addon
local addon = select(2, ...)
local NS = addon.API.FrameTemplates; addon.API.FrameTemplates = NS
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
	---@param frameLevel number
	---@param data table
	---@param name? string
	function NS:CreateScrollbar(parent, frameStrata, frameLevel, data, name)
		local scrollFrame, scrollChildFrame, sizeX, sizeY, theme, customDefaultTexture, customHighlightTexture, customThumbTexture, customThumbHighlightTexture, customColor, customHighlightColor, customThumbColor, customThumbHighlightColor, isHorizontal =
			data.scrollFrame, data.scrollChildFrame, data.sizeX, data.sizeY, data.theme, data.customDefaultTexture, data.customHighlightTexture, data.customThumbTexture, data.customThumbHighlightTexture, data.customColor, data.customHighlightColor, data.customThumbColor, data.customThumbHighlightColor, data.isHorizontal

		--------------------------------

		local Frame = CreateFrame("Frame", name or "$parent.Scrollbar", parent)
		Frame:SetSize(sizeX, sizeY)
		Frame:SetFrameStrata(frameStrata)
		Frame:SetFrameLevel(frameLevel + 1)

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
				if (theme and theme == 2) or (not theme and addon.API.Util.IsDarkTheme) then
					Frame._DefaultTexture = Frame._CustomDefaultTexture or addon.Variables.PATH_ART .. "Elements/Elements/scrollbar-background.png"
					Frame._HighlightTexture = Frame._CustomHighlightTexture or addon.Variables.PATH_ART .. "Elements/Elements/scrollbar-background-highlighted.png"
					Frame._ThumbTexture = Frame._CustomThumbTexture or addon.Variables.PATH_ART .. "Elements/Elements/scrollbar-thumb.png"
					Frame._ThumbHighlightTexture = Frame._CustomThumbHighlightTexture or addon.Variables.PATH_ART .. "Elements/Elements/scrollbar-thumb-highlighted.png"
					Frame._DefaultColor = Frame._CustomDefaultColor or { r = 1, g = 1, b = 1, a = .1 }
					Frame._HighlightColor = Frame._CustomHighlightColor or { r = 1, g = 1, b = 1, a = .1 }
					Frame._ThumbColor = Frame._CustomThumbColor or { r = 1, g = 1, b = 1, a = .25 }
					Frame._ThumbHighlightColor = Frame._CustomHighlightColor or { r = 1, g = 1, b = 1, a = .75 }
				end

				if (theme and theme == 1) or (not theme and not addon.API.Util.IsDarkTheme) then
					Frame._DefaultTexture = Frame._CustomDefaultTexture or addon.Variables.PATH_ART .. "Elements/Elements/scrollbar-background.png"
					Frame._HighlightTexture = Frame._CustomHighlightTexture or addon.Variables.PATH_ART .. "Elements/Elements/scrollbar-background-highlighted.png"
					Frame._ThumbTexture = Frame._CustomThumbTexture or addon.Variables.PATH_ART .. "Elements/Elements/scrollbar-thumb.png"
					Frame._ThumbHighlightTexture = Frame._CustomThumbHighlightTexture or addon.Variables.PATH_ART .. "Elements/Elements/scrollbar-thumb-highlighted.png"
					Frame._DefaultColor = Frame._CustomDefaultColor or { r = .1, g = .1, b = .1, a = .1 }
					Frame._HighlightColor = Frame._CustomHighlightColor or { r = .1, g = .1, b = .1, a = .1 }
					Frame._ThumbColor = Frame._CustomThumbColor or { r = .1, g = .1, b = .1, a = .5 }
					Frame._ThumbHighlightColor = Frame._CustomThumbHighlightColor or { r = .1, g = .1, b = .1, a = .75 }
				end
			end

			addon.API.Main:RegisterThemeUpdateWithNativeAPI(function()
				UpdateTheme()
			end, 4)
		end

		do -- ELEMENTS
			do -- BACKGROUND
				Frame.Background, Frame.BackgroundTexture = addon.API.FrameTemplates:CreateNineSlice(Frame, frameStrata, Frame._DefaultTexture, 25, .5, "$parent.Background")
				Frame.Background:SetSize(isHorizontal and Frame:GetWidth() or Frame:GetWidth() * .5, isHorizontal and Frame:GetHeight() * .5 or Frame:GetHeight())
				Frame.Background:SetPoint("CENTER", Frame, 0, 0)
				Frame.Background:SetFrameStrata(frameStrata)
				Frame.Background:SetFrameLevel(frameLevel)

				--------------------------------

				do -- THEME
					addon.API.Main:RegisterThemeUpdateWithNativeAPI(function()
						Frame.BackgroundTexture:SetTexture(Frame._DefaultTexture)
						Frame.BackgroundTexture:SetVertexColor(Frame._DefaultColor.r, Frame._DefaultColor.g, Frame._DefaultColor.b, Frame._DefaultColor.a)
					end, 5)
				end
			end

			do -- THUMB
				Frame.Thumb, Frame.ThumbTexture = addon.API.FrameTemplates:CreateNineSlice(Frame, frameStrata, Frame._ThumbTexture, 25, .5, "$parent.Thumb")
				Frame.Thumb:SetSize(isHorizontal and 25 or Frame:GetWidth(), isHorizontal and Frame:GetHeight() or 25)
				Frame.Thumb:SetPoint(isHorizontal and "LEFT" or "TOP", Frame, isHorizontal and 0 or 0, isHorizontal and 0 or 0)
				Frame.Thumb:SetFrameStrata(frameStrata)
				Frame.Thumb:SetFrameLevel(frameLevel + 2)
				Frame.ThumbTexture:SetVertexColor(Frame._ThumbColor.r, Frame._ThumbColor.g, Frame._ThumbColor.b, Frame._ThumbColor.a)

				--------------------------------

				do -- THEME
					addon.API.Main:RegisterThemeUpdateWithNativeAPI(function()
						Frame.ThumbTexture:SetTexture(Frame._ThumbTexture)
						Frame.ThumbTexture:SetVertexColor(Frame._ThumbColor.r, Frame._ThumbColor.g, Frame._ThumbColor.b, Frame._ThumbColor.a)
					end, 5)
				end
			end
		end

		do -- ANIMATIONS
			do -- ON ENTER
				function Frame:Animation_OnEnter_StopEvent()
					return not Frame.isMouseOver
				end

				function Frame:Animation_OnEnter(skipAnimation)
					Frame.BackgroundTexture:SetTexture(Frame._HighlightTexture)
					Frame.BackgroundTexture:SetVertexColor(Frame._HighlightColor.r, Frame._HighlightColor.g, Frame._HighlightColor.b, Frame._HighlightColor.a)

					Frame.ThumbTexture:SetTexture(Frame._ThumbTexture)
					Frame.ThumbTexture:SetVertexColor(Frame._ThumbHighlightColor.r, Frame._ThumbHighlightColor.g, Frame._ThumbHighlightColor.b, Frame._ThumbHighlightColor.a)

					if isHorizontal then
						addon.API.Animation:Scale(Frame.Thumb, .5, Frame.Thumb:GetHeight(), Frame:GetHeight() * 2, "y", addon.API.Animation.EaseExpo, Frame.Animation_OnEnter_StopEvent)
					else
						addon.API.Animation:Scale(Frame.Thumb, .5, Frame.Thumb:GetWidth(), Frame:GetWidth() * 2, "x", addon.API.Animation.EaseExpo, Frame.Animation_OnEnter_StopEvent)
					end
				end
			end

			do -- ON LEAVE
				function Frame:Animation_OnLeave_StopEvent()
					return Frame.isMouseOver
				end

				function Frame:Animation_OnLeave(skipAnimation)
					Frame.BackgroundTexture:SetTexture(Frame._DefaultTexture)
					Frame.BackgroundTexture:SetVertexColor(Frame._DefaultColor.r, Frame._DefaultColor.g, Frame._DefaultColor.b, Frame._DefaultColor.a)

					Frame.ThumbTexture:SetTexture(Frame._ThumbTexture)
					Frame.ThumbTexture:SetVertexColor(Frame._ThumbColor.r, Frame._ThumbColor.g, Frame._ThumbColor.b, Frame._ThumbColor.a)

					if isHorizontal then
						addon.API.Animation:Scale(Frame.Thumb, .5, Frame.Thumb:GetHeight(), Frame:GetHeight(), "y", addon.API.Animation.EaseExpo, Frame.Animation_OnLeave_StopEvent)
					else
						addon.API.Animation:Scale(Frame.Thumb, .5, Frame.Thumb:GetWidth(), Frame:GetWidth(), "x", addon.API.Animation.EaseExpo, Frame.Animation_OnLeave_StopEvent)
					end
				end
			end

			do -- ON MOUSE DOWN
				function Frame:Animation_OnMouseDown_StopEvent()
					return not Frame.isMouseDown
				end

				function Frame:Animation_OnMouseDown(skipAnimation)
					Frame:SetAlpha(.75)
				end
			end

			do -- ON MOUSE UP
				function Frame:Animation_OnMouseUp_StopEvent()
					return Frame.isMouseDown
				end

				function Frame:Animation_OnMouseUp(skipAnimation)
					Frame:SetAlpha(1)
				end
			end
		end

		do -- LOGIC
			Frame.isDragging = false
			Frame.isMouseOver = false
			Frame.isMouseDown = false

			Frame.enterCallbacks = {}
			Frame.leaveCallbacks = {}
			Frame.mouseDownCallbacks = {}
			Frame.mouseUpCallbacks = {}

			--------------------------------

			do -- FUNCTIONS
				do -- SET

				end

				do -- LOGIC
					local originX
					local originY
					local startX
					local startY

					--------------------------------

					function Frame:Scrollbar_LimitThumbToFrame(thumb, boundaryFrame, restrictAxis)
						local point, relativeTo, relativePoint, offsetX, offsetY = thumb:GetPoint()
						local height = boundaryFrame:GetHeight()
						local width = boundaryFrame:GetWidth()

						local newX = offsetX
						local newY = offsetY

						--------------------------------

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

							--------------------------------

							thumb:ClearAllPoints()
							thumb:SetPoint("LEFT", boundaryFrame, newX, 0)

							--------------------------------

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

							--------------------------------

							thumb:ClearAllPoints()
							thumb:SetPoint("TOP", boundaryFrame, 0, newY)

							--------------------------------

							local value = (newY) / (height - thumb:GetHeight())
							return value
						end
					end

					function Frame:Scrollbar_GetMouseOffset(startX, startY)
						local offsetX, offsetY = addon.API.FrameUtil:GetMouseDelta(startX, startY)
						return offsetX, offsetY
					end

					function Frame:Scrollbar_OnMouseDown()
						Frame.isDragging = true

						--------------------------------

						local point, relativeTo, relativePoint, offsetX, offsetY = Frame.Thumb:GetPoint()
						originX = offsetX
						originY = offsetY
						startX, startY = GetCursorPosition()
					end

					function Frame:Scrollbar_OnMouseUp()
						Frame.isDragging = false

						--------------------------------

						originX = nil
						originY = nil
						startX, startY = nil, nil
					end

					function Frame:Scrollbar_OnUpdate()
						local verticalScrollRange = scrollFrame:GetVerticalScrollRange()
						local horizontalScrollRange = scrollFrame:GetHorizontalScrollRange()
						local verticalScroll = scrollFrame:GetVerticalScroll()
						local horizontalScroll = scrollFrame:GetHorizontalScroll()

						--------------------------------

						if (not isHorizontal and verticalScrollRange > 0) or (isHorizontal and horizontalScrollRange > 0) then
							if Frame.isDragging then
								local offsetX, offsetY = Frame:Scrollbar_GetMouseOffset(startX, startY)

								--------------------------------

								Frame.Thumb:ClearAllPoints()

								if isHorizontal then
									Frame.Thumb:SetPoint("LEFT", Frame, originX + (offsetX / Frame:GetEffectiveScale()), 0)
									Frame.Value = Frame:Scrollbar_LimitThumbToFrame(Frame.Thumb, Frame, "X")
									scrollFrame:SetHorizontalScroll((horizontalScrollRange) * Frame.Value, true)
								else
									Frame.Thumb:SetPoint("TOP", Frame, 0, originY - (offsetY / Frame:GetEffectiveScale()))
									Frame.Value = Frame:Scrollbar_LimitThumbToFrame(Frame.Thumb, Frame, "Y")
									scrollFrame:SetVerticalScroll(math.abs((scrollChildFrame:GetHeight() - scrollFrame:GetHeight()) * Frame.Value), true)
								end
							else
								local frameHeight = Frame:GetHeight()
								local thumbHeight = Frame.Thumb:GetHeight()
								local frameWidth = Frame:GetWidth()
								local thumbWidth = Frame.Thumb:GetWidth()

								--------------------------------

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
				end
			end

			do -- EVENTS
				function Frame:OnEnter(skipAnimation)
					Frame.isMouseOver = true

					--------------------------------

					Frame:Animation_OnEnter(skipAnimation)

					--------------------------------

					do -- ON ENTER
						if #Frame.enterCallbacks >= 1 then
							local enterCallbacks = Frame.enterCallbacks

							for callback = 1, #enterCallbacks do
								enterCallbacks[callback](skipAnimation)
							end
						end
					end
				end

				function Frame:OnLeave(skipAnimation)
					if not Frame.isDragging then
						Frame.isMouseOver = false

						--------------------------------

						Frame:Animation_OnLeave(skipAnimation)

						--------------------------------

						do -- ON LEAVE
							if #Frame.leaveCallbacks >= 1 then
								local leaveCallbacks = Frame.leaveCallbacks

								for callback = 1, #leaveCallbacks do
									leaveCallbacks[callback](skipAnimation)
								end
							end
						end
					end
				end

				function Frame:OnMouseDown(button, skipAnimation)
					Frame.isMouseDown = true

					--------------------------------

					Frame:Animation_OnMouseDown(skipAnimation)

					--------------------------------

					do -- ON MOUSE DOWN
						if #Frame.mouseDownCallbacks >= 1 then
							local mouseDownCallbacks = Frame.mouseDownCallbacks

							for callback = 1, #mouseDownCallbacks do
								mouseDownCallbacks[callback](skipAnimation)
							end
						end
					end
				end

				function Frame:OnMouseUp(button, skipAnimation)
					if not Frame.isMouseOver then
						Frame.isMouseDown = false

						--------------------------------

						Frame:Animation_OnMouseUp()

						--------------------------------

						do -- ON MOUSE UP
							if #Frame.mouseUpCallbacks >= 1 then
								local mouseUpCallbacks = Frame.mouseUpCallbacks

								for callback = 1, #mouseUpCallbacks do
									mouseUpCallbacks[callback](skipAnimation)
								end
							end
						end
					end
				end

				addon.API.FrameTemplates:CreateMouseResponder(Frame.Thumb, { enterCallback = Frame.OnEnter, leaveCallback = Frame.OnLeave, mouseDownCallback = Frame.OnMouseDown, mouseUpCallback = Frame.OnMouseUp })
				Frame.Thumb:SetScript("OnMouseDown", Frame.Scrollbar_OnMouseDown)
				Frame.Thumb:SetScript("OnMouseUp", Frame.Scrollbar_OnMouseUp)
				Frame:SetScript("OnUpdate", Frame.Scrollbar_OnUpdate)
			end
		end

		do -- SETUP
			Frame:OnLeave(true)
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
