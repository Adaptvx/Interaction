local addon = select(2, ...)
local NS = addon.API.FrameTemplates; addon.API.FrameTemplates = NS
local CallbackRegistry = addon.CallbackRegistry


-- Templates
----------------------------------------------------------------------------------------------------

do

	function NS:CreateInputBox(parent, frameStrata, frameLevel, data, name)
		local defaultTexture, highlightTexture,
		edgeSize, scale,
		textColor, font, fontSize, justifyH, justifyV, hint, valueChangedCallback =
			data.defaultTexture, data.highlightTexture,
			data.edgeSize, data.scale,
			data.textColor, data.font, data.fontSize, data.justifyH, data.justifyV, data.hint, data.valueChangedCallback

		local Frame = CreateFrame("EditBox", name or nil, parent)
		Frame:SetFrameStrata(frameStrata)
		Frame:SetFrameLevel(frameLevel + 1)
		Frame:SetFontObject(GameFontNormal)
		Frame:SetTextColor(textColor.r, textColor.g, textColor.b)
		Frame:SetAutoFocus(false)

		do -- Elements
			do -- Background
				Frame.Background, Frame.BackgroundTexture = addon.API.FrameTemplates:CreateNineSlice(Frame, frameStrata, defaultTexture, edgeSize or 50, scale or 1, "$parent.Background")
				Frame.Background:SetPoint("TOPLEFT", Frame, -10, 0)
				Frame.Background:SetPoint("BOTTOMRIGHT", Frame, 10, 0)
				Frame.Background:SetFrameStrata(frameStrata)
				Frame.Background:SetFrameLevel(frameLevel)
				Frame.Background:SetAlpha(.5)
			end

			do -- Text
				Frame.Text = Frame:GetFontObject()
				Frame.Text:SetJustifyH(justifyH or "LEFT")
				Frame.Text:SetJustifyV(justifyV or "MIDDLE")
				Frame.Text:SetFont(font or GameFontNormal:GetFont(), fontSize or 12.5, "")
			end

			do -- Placeholder
				Frame.PlaceholderText = addon.API.FrameTemplates:CreateText(Frame, textColor, fontSize, justifyH or "LEFT", justifyV or "MIDDLE", GameFontNormal:GetFont(), "$parent.PlaceholderText")
				Frame.PlaceholderText:SetAllPoints(Frame)
				Frame.PlaceholderText:SetText(hint)
				Frame.PlaceholderText:SetAlpha(.5)
			end
		end

		do -- Animations
			do -- On enter

				function Frame:Animation_OnEnter_StopEvent()
					return not Frame.isMouseOver and not Frame:HasFocus()
				end

				function Frame:Animation_OnEnter(skipAnimation)
					Frame.BackgroundTexture:SetTexture(highlightTexture)
					Frame.BackgroundTexture:SetVertexColor(1, 1, 1)

					addon.API.Animation:Fade(Frame.Background, .125, Frame.Background:GetAlpha(), 1, nil, Frame.Animation_OnEnter_StopEvent)
				end
			end

			do -- On leave

				function Frame:Animation_OnLeave_StopEvent()
					return Frame.isMouseOver or not Frame:HasFocus()
				end

				function Frame:Animation_OnLeave(skipAnimation)
					Frame.BackgroundTexture:SetTexture(defaultTexture)
					Frame.BackgroundTexture:SetVertexColor(1, 1, 1)

					addon.API.Animation:Fade(Frame.Background, .125, Frame.Background:GetAlpha(), 1, nil, Frame.Animation_OnLeave_StopEvent)
				end
			end

			do -- On mouse down

				function Frame:Animation_OnMouseDown_StopEvent()
					return not Frame.isMouseDown
				end

				function Frame:Animation_OnMouseDown(skipAnimation)

				end
			end

			do -- On mouse up

				function Frame:Animation_OnMouseUp_StopEvent()
					return Frame.isMouseDown
				end

				function Frame:Animation_OnMouseUp(skipAnimation)

				end
			end
		end

		do -- Logic
			Frame.autoSelect = false
			Frame.isMouseOver = false
			Frame.isMouseDown = false

			Frame.enterCallbacks = {}
			Frame.leaveCallbacks = {}
			Frame.mouseDownCallbacks = {}
			Frame.mouseUpCallbacks = {}
			Frame.valueChangedCallbacks = {}

			do -- Functions
				do -- Set

				end

				do -- Logic

					function Frame:UpdatePlaceholder()
						Frame.PlaceholderText:SetShown(Frame:GetText() == "")
					end
				end
			end

			do -- Events

				function Frame:OnEnter(skipAnimation)
					Frame.isMouseOver = true

					Frame:Animation_OnEnter(skipAnimation)

					do -- On enter
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

					Frame:Animation_OnLeave(skipAnimation)

					do -- On leave
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

					Frame:Animation_OnMouseDown(skipAnimation)

					do -- On mouse down
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

					Frame:Animation_OnMouseUp(skipAnimation)

					do -- On mouse up
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

					do -- On value changed
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
					C_Timer.After(0, function()
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

		do -- Setup
			Frame:UpdatePlaceholder()
			Frame:OnLeave(true)
		end

		return Frame
	end
end
