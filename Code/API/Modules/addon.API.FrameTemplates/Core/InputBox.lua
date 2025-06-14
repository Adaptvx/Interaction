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
	-- Creates an input box.
	--
	-- Data Table
	----
	-- defaultTexture, highlightTexture,
	-- edgeSize, scale,
	-- textColor, font, fontSize, justifyH, justifyV, hint, valueChangedCallback
	---@param parent any
	---@param frameStrata string
	---@param frameLevel number
	---@param data table
	---@param name? string
	function NS:CreateInputBox(parent, frameStrata, frameLevel, data, name)
		local defaultTexture, highlightTexture,
		edgeSize, scale,
		textColor, font, fontSize, justifyH, justifyV, hint, valueChangedCallback =
			data.defaultTexture, data.highlightTexture,
			data.edgeSize, data.scale,
			data.textColor, data.font, data.fontSize, data.justifyH, data.justifyV, data.hint, data.valueChangedCallback

		--------------------------------

		local Frame = CreateFrame("EditBox", name or nil, parent)
		Frame:SetFrameStrata(frameStrata)
		Frame:SetFrameLevel(frameLevel + 1)
		Frame:SetFontObject(GameFontNormal)
		Frame:SetTextColor(textColor.r, textColor.g, textColor.b)
		Frame:SetAutoFocus(false)

		--------------------------------

		do -- ELEMENTS
			do -- BACKGROUND
				Frame.Background, Frame.BackgroundTexture = addon.API.FrameTemplates:CreateNineSlice(Frame, frameStrata, defaultTexture, edgeSize or 50, scale or 1, "$parent.Background")
				Frame.Background:SetPoint("TOPLEFT", Frame, -10, 0)
				Frame.Background:SetPoint("BOTTOMRIGHT", Frame, 10, 0)
				Frame.Background:SetFrameStrata(frameStrata)
				Frame.Background:SetFrameLevel(frameLevel)
				Frame.Background:SetAlpha(.5)
			end

			do -- TEXT
				Frame.Text = Frame:GetFontObject()
				Frame.Text:SetJustifyH(justifyH or "LEFT")
				Frame.Text:SetJustifyV(justifyV or "MIDDLE")
				Frame.Text:SetFont(font or GameFontNormal:GetFont(), fontSize or 12.5, "")
			end

			do -- PLACEHOLDER
				Frame.PlaceholderText = addon.API.FrameTemplates:CreateText(Frame, textColor, fontSize, justifyH or "LEFT", justifyV or "MIDDLE", addon.API.Fonts.CONTENT_LIGHT, "$parent.PlaceholderText")
				Frame.PlaceholderText:SetAllPoints(Frame)
				Frame.PlaceholderText:SetText(hint)
				Frame.PlaceholderText:SetAlpha(.5)
			end
		end

		do -- ANIMATIONS
			do -- ON ENTER
				function Frame:Animation_OnEnter_StopEvent()
					return not Frame.isMouseOver and not Frame:HasFocus()
				end

				function Frame:Animation_OnEnter(skipAnimation)
					Frame.BackgroundTexture:SetTexture(highlightTexture)
					Frame.BackgroundTexture:SetVertexColor(1, 1, 1)

					--------------------------------

					addon.API.Animation:Fade(Frame.Background, .125, Frame.Background:GetAlpha(), 1, nil, Frame.Animation_OnEnter_StopEvent)
				end
			end

			do -- ON LEAVE
				function Frame:Animation_OnLeave_StopEvent()
					return Frame.isMouseOver or not Frame:HasFocus()
				end

				function Frame:Animation_OnLeave(skipAnimation)
					Frame.BackgroundTexture:SetTexture(defaultTexture)
					Frame.BackgroundTexture:SetVertexColor(1, 1, 1)

					--------------------------------

					addon.API.Animation:Fade(Frame.Background, .125, Frame.Background:GetAlpha(), 1, nil, Frame.Animation_OnLeave_StopEvent)
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
			Frame.autoSelect = false
			Frame.isMouseOver = false
			Frame.isMouseDown = false

			Frame.enterCallbacks = {}
			Frame.leaveCallbacks = {}
			Frame.mouseDownCallbacks = {}
			Frame.mouseUpCallbacks = {}
			Frame.valueChangedCallbacks = {}

			--------------------------------

			do -- FUNCTIONS
				do -- SET

				end

				do -- LOGIC
					function Frame:UpdatePlaceholder()
						Frame.PlaceholderText:SetShown(Frame:GetText() == "")
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
					Frame.isMouseDown = false

					--------------------------------

					Frame:Animation_OnMouseUp(skipAnimation)

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

				function Frame:OnValueChanged(...)
					valueChangedCallback(...)

					--------------------------------

					do -- ON VALUE CHANGED
						if #Frame.valueChangedCallbacks >= 1 then
							local valueChangedCallbacks = Frame.valueChangedCallbacks

							for _, callback in pairs(valueChangedCallbacks) do
								callback(...)
							end
						end
					end
				end

				Frame:SetScript("OnEnter", Frame.OnEnter)
				Frame:SetScript("OnLeave", function()
					if not Frame:HasFocus() then
						Frame:OnLeave()
					end
				end)
				Frame:SetScript("OnEditFocusGained", Frame.OnEnter)
				Frame:SetScript("OnEditFocusLost", Frame.OnLeave)
				Frame:SetScript("OnEscapePressed", Frame.ClearFocus)
				Frame:SetScript("OnTextChanged", Frame.OnValueChanged)
				Frame:SetScript("OnShow", function()
					addon.Libraries.AceTimer:ScheduleTimer(function()
						if Frame.autoSelect then
							Frame:SetFocus()
						else
							Frame:ClearFocus()
						end
					end, 0)
				end)

				hooksecurefunc(Frame, "Show", Frame.UpdatePlaceholder)
				Frame:HookScript("OnTextChanged", Frame.UpdatePlaceholder)
			end
		end

		do -- SETUP
			Frame:UpdatePlaceholder()
			Frame:OnLeave(true)
		end

		--------------------------------

		return Frame
	end
end
