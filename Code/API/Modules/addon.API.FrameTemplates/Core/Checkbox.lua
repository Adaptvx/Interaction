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
	-- Creates a checkbox.
	--
	-- Data Table
	----
	-- theme, defaultTexture, highlightTexture, checkTexture,
	-- checkHighlightTexture, edgeSize, scale, customColor, callbackFunction
	---@param parent any
	---@param frameStrata string
	---@param frameLevel number
	---@param data table
	---@param name? string
	function NS:CreateCheckbox(parent, frameStrata, frameLevel, data, name)
		local Frame = CreateFrame("Frame", name, parent)
		Frame:SetFrameStrata(frameStrata)
		Frame:SetFrameLevel(frameLevel)

		--------------------------------

		local theme, defaultTexture, highlightTexture, checkTexture, checkHighlightTexture,
		edgeSize, scale, customColor, callbackFunction =
			data.theme, data.defaultTexture, data.highlightTexture, data.checkTexture, data.checkHighlightTexture,
			data.edgeSize, data.scale, data.customColor, data.callbackFunction

		--------------------------------

		Frame._DefaultTexture = nil
		Frame._HighlightTexture = nil
		Frame._CheckTexture = nil
		Frame._HighlightCheckTexture = nil
		Frame._Color = nil

		Frame._CustomDefaultTexture = defaultTexture
		Frame._CustomHighlightTexture = highlightTexture
		Frame._CustomCheckTexture = checkTexture
		Frame._CustomCheckHighlightTexture = checkHighlightTexture
		Frame._CustomColor = customColor

		--------------------------------

		do -- THEME
			local function UpdateTheme()
				if (theme and theme == 2) or (theme == nil and addon.API.Util.NativeAPI:GetDarkTheme()) then
					Frame._DefaultTexture = Frame._CustomDefaultTexture or addon.Variables.PATH_ART .. "Elements/Elements/check-background.png"
					Frame._HighlightTexture = Frame._CustomHighlightTexture or addon.Variables.PATH_ART .. "Elements/Elements/check-background-highlighted.png"
					Frame._CheckTexture = Frame._CustomCheckTexture or addon.Variables.PATH_ART .. "Elements/Elements/check-dark.png"
					Frame._HighlightCheckTexture = Frame._CustomCheckHighlightTexture or addon.Variables.PATH_ART .. "Elements/Elements/check-dark.png"
					Frame._Color = Frame._CustomColor or { r = 1, g = 1, b = 1 }
				elseif (theme and theme == 1) or (theme == nil and not addon.API.Util.NativeAPI:GetDarkTheme()) then
					Frame._DefaultTexture = Frame._CustomDefaultTexture or addon.Variables.PATH_ART .. "Elements/Elements/check-background.png"
					Frame._HighlightTexture = Frame._CustomHighlightTexture or addon.Variables.PATH_ART .. "Elements/Elements/check-background-highlighted.png"
					Frame._CheckTexture = Frame._CustomCheckTexture or addon.Variables.PATH_ART .. "Elements/Elements/check-dark.png"
					Frame._HighlightCheckTexture = Frame._CustomCheckHighlightTexture or addon.Variables.PATH_ART .. "Elements/Elements/check-light.png"
					Frame._Color = Frame._CustomColor or { r = .1, g = .1, b = .1 }
				end
			end

			addon.API.Main:RegisterThemeUpdateWithNativeAPI(UpdateTheme, 4)
		end

		do -- ELEMENTS
			Frame.Checkbox = CreateFrame("Frame", "$parent.Checkbox", Frame)
			Frame.Checkbox:SetPoint("LEFT", Frame)
			Frame.Checkbox:SetFrameStrata(frameStrata)
			Frame.Checkbox:SetFrameLevel(frameLevel + 2)
			addon.API.FrameUtil:SetDynamicSize(Frame.Checkbox, Frame, function(relativeWidth, relativeHeight) return relativeHeight end, function(relativeWidth, relativeHeight) return relativeHeight end)

			local Checkbox = Frame.Checkbox

			--------------------------------

			do -- BACKGROUND
				Checkbox.Background, Checkbox.BackgroundTexture = addon.API.FrameTemplates:CreateNineSlice(Frame.Checkbox, frameStrata, Frame._DefaultTexture, edgeSize or 50, scale or 1, "$parent.Background")
				Checkbox.Background:SetAllPoints(Checkbox)
				Checkbox.Background:SetFrameStrata(frameStrata)
				Checkbox.Background:SetFrameLevel(frameLevel + 1)
				Checkbox.Background:SetAlpha(1)

				--------------------------------

				do -- THEME
					addon.API.Main:RegisterThemeUpdateWithNativeAPI(function()
						Checkbox.BackgroundTexture:SetVertexColor(Frame._Color.r, Frame._Color.g, Frame._Color.b, Frame._Color.a or 1)
					end, 5)
				end
			end

			do -- ICON
				Checkbox.Icon, Checkbox.IconTexture = addon.API.FrameTemplates:CreateTexture(Frame.Checkbox, frameStrata, Frame._CheckTexture, "$parent.Icon")
				Checkbox.Icon:SetPoint("TOPLEFT", Frame.Checkbox, 5, -5)
				Checkbox.Icon:SetPoint("BOTTOMRIGHT", Frame.Checkbox, -5, 5)
				Checkbox.Icon:SetFrameStrata(frameStrata)
				Checkbox.Icon:SetFrameLevel(frameLevel + 3)

				--------------------------------

				do -- THEME
					addon.API.Main:RegisterThemeUpdateWithNativeAPI(function()
						Checkbox.IconTexture:SetTexture(Frame._CheckTexture)
					end, 5)
				end
			end
		end

		do -- ANIMATIONS
			do -- ON ENTER
				function Frame:Animation_OnEnter_StopEvent()
					return not Frame.isMouseOver or not Frame.checked
				end

				function Frame:Animation_OnEnter(skipAnimation)
					Frame.Checkbox.BackgroundTexture:SetTexture(Frame._HighlightTexture)
					Frame.Checkbox.IconTexture:SetTexture(Frame._HighlightCheckTexture)

					--------------------------------

					addon.API.Animation:Fade(Frame.Checkbox.Background, .125, Frame.Checkbox.Background:GetAlpha(), 1, nil, Frame.Animation_OnEnter_StopEvent)
				end
			end

			do -- ON LEAVE
				function Frame:Animation_OnLeave_StopEvent()
					return not Frame.isMouseOver or not Frame.checked
				end

				function Frame:Animation_OnLeave(skipAnimation)
					Frame.Checkbox.BackgroundTexture:SetTexture(Frame._DefaultTexture)
					Frame.Checkbox.IconTexture:SetTexture(Frame._CheckTexture)

					--------------------------------

					addon.API.Animation:Fade(Frame.Checkbox.Background, .125, Frame.Checkbox.Background:GetAlpha(), 1, nil, Frame.Animation_OnLeave_StopEvent)
				end
			end

			do -- ON MOUSE DOWN
				function Frame:Animation_OnMouseDown_StopEvent()
					return not Frame.isMouseDown
				end

				function Frame:Animation_OnMouseDown(skipAnimation)

				end
			end

			do -- ON MOUSE UP
				function Frame:Animation_OnMouseUp_StopEvent()
					return Frame.isMouseDown
				end

				function Frame:Animation_OnMouseUp(skipAnimation)

				end
			end
		end

		do -- LOGIC
			Frame.checked = false
			Frame.isMouseOver = false
			Frame.isMouseDown = false

			Frame.enterCallbacks = {}
			Frame.leaveCallbacks = {}
			Frame.mouseDownCallbacks = {}
			Frame.mouseUpCallbacks = {}
			Frame.clickCallbacks = {}

			--------------------------------

			do -- FUNCTIONS
				do -- SET
					function Frame:SetChecked(value)
						Frame.checked = value

						--------------------------------

						Frame:UpdateChecked()
					end
				end

				do -- LOGIC
					function Frame:UpdateChecked()
						Frame.Checkbox.Icon:SetShown(Frame.checked)
					end
				end
			end

			do -- EVENTS
				local function Logic_OnEnter()

				end

				local function Logic_OnLeave()

				end

				local function Logic_OnMouseDown()

				end

				local function Logic_OnMouseUp()

				end

				local function Logic_OnClick()
					Frame:SetChecked(not Frame.checked)

					--------------------------------

					callbackFunction(Frame, Frame.checked)
				end

				function Frame:OnEnter(skipAnimation)
					Frame.isMouseOver = true

					--------------------------------

					Frame:Animation_OnEnter(skipAnimation)
					Logic_OnEnter()

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
					Frame.isMouseOver = false

					--------------------------------

					Frame:Animation_OnLeave(skipAnimation)
					Logic_OnLeave()

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

				function Frame:OnMouseDown(button, skipAnimation)
					Frame.isMouseDown = false

					--------------------------------

					Frame:Animation_OnMouseDown(skipAnimation)
					Logic_OnMouseDown()

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
					Frame.isMouseDown = false

					--------------------------------

					Frame:Animation_OnMouseUp(skipAnimation)
					Logic_OnMouseUp()
					Logic_OnClick()

					--------------------------------

					do -- ON MOUSE UP
						if #Frame.mouseUpCallbacks >= 1 then
							local mouseUpCallbacks = Frame.mouseUpCallbacks

							for callback = 1, #mouseUpCallbacks do
								mouseUpCallbacks[callback](skipAnimation)
							end
						end
					end

					do -- ON CLICK
						if #Frame.clickCallbacks >= 1 then
							local clickCallbacks = Frame.clickCallbacks

							for callback = 1, #clickCallbacks do
								clickCallbacks[callback](skipAnimation)
							end
						end
					end
				end

				addon.API.FrameTemplates:CreateMouseResponder(Frame, { enterCallback = Frame.OnEnter, leaveCallback = Frame.OnLeave, mouseDownCallback = Frame.OnMouseDown, mouseUpCallback = Frame.OnMouseUp })
			end
		end

		do -- SETUP
			Frame:OnLeave(true)
		end

		--------------------------------

		return Frame
	end

	-- Updates the theme of a checkbox.
	--
	-- Data Table
	----
	-- defaultTexture, highlightTexture, checkTexture, checkHighlightTexture, defaultColor
	---@param checkbox any
	---@param data table
	function NS:UpdateCheckboxTheme(checkbox, data)
		local defaultTexture, highlightTexture, checkTexture, checkHighlightTexture, defaultColor = data.defaultTexture, data.highlightTexture, data.checkTexture, data.checkHighlightTexture, data.defaultColor

		--------------------------------

		if defaultTexture then checkbox._CustomDefaultTexture = defaultTexture end
		if highlightTexture then checkbox._CustomHighlightTexture = highlightTexture end
		if checkTexture then checkbox._CustomCheckTexture = checkTexture end
		if checkHighlightTexture then checkbox._CustomCheckHighlightTexture = checkHighlightTexture end
		if defaultColor then checkbox._CustomColor = defaultColor end
	end
end
