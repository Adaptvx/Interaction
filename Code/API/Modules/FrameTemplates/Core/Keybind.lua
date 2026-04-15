local addon = select(2, ...)
local NS = addon.API.FrameTemplates; addon.API.FrameTemplates = NS
local CallbackRegistry = addon.CallbackRegistry


do

	function NS:CreateKeybindButton(parent, frameStrata, frameLevel, data, name)
		local getFunc, setFunc, enableFunc, theme, defaultTexture, highlightTexture, activeTexture, defaultColor, textColor, textHighlightColor, textSize =
			data.getFunc, data.setFunc, data.enableFunc, data.theme, data.defaultTexture, data.highlightTexture, data.activeTexture, data.defaultColor, data.textColor, data.textHighlightColor, data.textSize

		local Frame = CreateFrame("Frame", name or nil, parent)
		Frame:SetFrameStrata(frameStrata)
		Frame:SetFrameLevel(frameLevel + 1)

		Frame._DefaultTexture = nil
		Frame._HighlightTexture = nil
		Frame._ActiveTexture = nil
		Frame._DefaultColor = nil
		Frame._TextColor = nil
		Frame._TextHighlightColor = nil
		Frame._TextSize = nil

		Frame._CustomDefaultTexture = defaultTexture
		Frame._CustomHighlightTexture = highlightTexture
		Frame._CustomActiveTexture = activeTexture
		Frame._CustomDefaultColor = defaultColor
		Frame._CustomTextColor = textColor
		Frame._CustomTextHighlightColor = textHighlightColor
		Frame._CustomTextSize = textSize

		do -- Theme
			local function UpdateTheme()
				if (theme and theme == 2) or (theme == nil and addon.API.Main:GetDarkTheme()) then -- Dark mode
					Frame._DefaultTexture = Frame._CustomDefaultTexture or addon.Variables.PATH_ART .. "Elements\\Elements\\keybind-background-light-outline.png"
					Frame._HighlightTexture = Frame._CustomHighlightTexture or addon.Variables.PATH_ART .. "Elements\\Elements\\keybind-background-highlighted-light.png"
					Frame._ActiveTexture = Frame._CustomActiveTexture or addon.Variables.PATH_ART .. "Elements\\Elements\\keybind-background-active-light.png"
					Frame._DefaultColor = Frame._CustomDefaultColor or { r = 1, g = 1, b = 1, a = 1 }
					Frame._TextColor = Frame._CustomTextColor or { r = 1, g = 1, b = 1, a = 1 }
					Frame._TextHighlightColor = Frame._CustomTextHighlightColor or { r = 0, g = 0, b = 0, a = 1 }
					Frame._TextSize = Frame._CustomTextSize or 12.5
				elseif (theme and theme == 1) or (theme == nil and not addon.API.Main:GetDarkTheme()) then -- Light mode
					Frame._DefaultTexture = Frame._CustomDefaultTexture or addon.Variables.PATH_ART .. "Elements\\Elements\\keybind-background-light.png"
					Frame._HighlightTexture = Frame._CustomHighlightTexture or addon.Variables.PATH_ART .. "Elements\\Elements\\keybind-background-highlighted-light.png"
					Frame._ActiveTexture = Frame._CustomActiveTexture or addon.Variables.PATH_ART .. "Elements\\Elements\\keybind-background-active-light.png"
					Frame._DefaultColor = Frame._CustomDefaultColor or { r = .1, g = .1, b = .1, a = 1 }
					Frame._TextColor = Frame._CustomTextColor or { r = .1, g = .1, b = .1, a = 1 }
					Frame._TextHighlightColor = Frame._CustomTextHighlightColor or { r = 1, g = 1, b = 1, a = 1 }
					Frame._TextSize = Frame._CustomTextSize or 12.5
				end
			end

			addon.API.Main:RegisterThemeUpdateWithNativeAPI(UpdateTheme, 4)
		end

		do -- Elements
			do -- Keybind frame
				Frame.KeybindFrame = CreateFrame("Frame", "$parent.KeybindFrame", Frame)
			end

			do -- Background
				Frame.Background, Frame.BackgroundTexture = NS:CreateNineSlice(Frame, frameStrata, Frame._DefaultTexture, 64, .175, "$parent.Background")
				Frame.Background:SetAllPoints(Frame, true)
				Frame.Background:SetFrameStrata(frameStrata)
				Frame.Background:SetFrameLevel(frameLevel)

				do -- Theme
					addon.API.Main:RegisterThemeUpdateWithNativeAPI(function()
						Frame.BackgroundTexture:SetVertexColor(Frame._DefaultColor.r, Frame._DefaultColor.g, Frame._DefaultColor.b, Frame._DefaultColor.a)
						Frame.BackgroundTexture:SetTexture(Frame._DefaultTexture)
					end, 5)
				end
			end

			do -- Text
				Frame.Text = addon.API.FrameTemplates:CreateText(Frame, Frame._TextColor, Frame._TextSize, "CENTER", "MIDDLE", GameFontNormal:GetFont(), "$parent.Text")
				Frame.Text:SetAllPoints(Frame, true)

				do -- Theme
					addon.API.Main:RegisterThemeUpdateWithNativeAPI(function()
						Frame.Text:SetTextColor(Frame._TextColor.r, Frame._TextColor.g, Frame._TextColor.b, Frame._TextColor.a)
					end, 5)
				end
			end
		end

		do -- Animations
			do -- On enter

				function Frame:Animation_OnEnter_StopEvent()
					return not Frame.isMouseOver
				end

				function Frame:Animation_OnEnter(skipAnimation)
					Frame.BackgroundTexture:SetTexture(Frame._HighlightTexture)
					Frame.Text:SetTextColor(Frame._TextColor.r, Frame._TextColor.g, Frame._TextColor.b, Frame._TextColor.a)
				end
			end

			do -- On leave

				function Frame:Animation_OnLeave_StopEvent()
					return Frame.isMouseOver
				end

				function Frame:Animation_OnLeave(skipAnimation)
					Frame.BackgroundTexture:SetTexture(Frame._DefaultTexture)
					Frame.Text:SetTextColor(Frame._TextColor.r, Frame._TextColor.g, Frame._TextColor.b, Frame._TextColor.a)
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
			Frame.key = nil
			Frame.keybindMode = false
			Frame.isMouseOver = false
			Frame.isMouseDown = false

			Frame.enterCallbacks = {}
			Frame.leaveCallbacks = {}
			Frame.mouseDownCallbacks = {}
			Frame.mouseUpCallbacks = {}
			Frame.valueChangedCallbacks = {}

			do -- Functions
				do -- Set

					function Frame:UpdateValue()
						Frame.key = getFunc()

						Frame.Text:SetText(tostring(Frame.key))
					end

					function Frame:ToggleKeybindMode()
						if Frame.keybindMode then
							Frame:StopKeybindMode()
						else
							if enableFunc() then
								Frame:StartKeybindMode()
							end
						end
					end

					function Frame:StartKeybindMode()
						Frame.keybindMode = true
						Frame.KeybindFrame:Show()

						Frame.BackgroundTexture:SetTexture(Frame._ActiveTexture)
						Frame.Text:SetTextColor(Frame._TextHighlightColor.r, Frame._TextHighlightColor.g, Frame._TextHighlightColor.b, Frame._TextHighlightColor.a)
					end

					function Frame:StopKeybindMode()
						Frame.keybindMode = false
						Frame.KeybindFrame:Hide()

						if Frame:IsMouseOver() then
							Frame.BackgroundTexture:SetTexture(Frame._HighlightTexture)
							Frame.Text:SetTextColor(Frame._TextColor.r, Frame._TextColor.g, Frame._TextColor.b, Frame._TextColor.a)
						else
							Frame.BackgroundTexture:SetTexture(Frame._DefaultTexture)
							Frame.Text:SetTextColor(Frame._TextColor.r, Frame._TextColor.g, Frame._TextColor.b, Frame._TextColor.a)
						end
					end

					function Frame:SetKeybind(key)
						Frame:SetValue(key)
					end
				end

				do -- Logic

					function Frame:SetValue(key)
						setFunc(Frame, key)

						Frame:UpdateValue()

						if Frame.keybindMode then
							Frame:StopKeybindMode()

							local valueChangedCallbacks = Frame.valueChangedCallbacks

							for callback = 1, #valueChangedCallbacks do
								valueChangedCallbacks[callback]()
							end
						end
					end
				end
			end

			do -- Events

				function Frame:OnEnter(skipAnimation)
					if Frame.keybindMode then
						return
					end

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
					if Frame.keybindMode then
						return
					end

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

					Frame:ToggleKeybindMode()

					do -- On mouse up
						if #Frame.mouseUpCallbacks >= 1 then
							local mouseUpCallbacks = Frame.mouseUpCallbacks

							for callback = 1, #mouseUpCallbacks do
								mouseUpCallbacks[callback](skipAnimation)
							end
						end
					end
				end

				function Frame:OnKeyDown(key)
					if Frame.keybindMode then
						Frame:SetKeybind(key)
					end
				end

				addon.API.FrameTemplates:CreateMouseResponder(Frame, { enterCallback = Frame.OnEnter, leaveCallback = Frame.OnLeave, mouseDownCallback = Frame.OnMouseDown, mouseUpCallback = Frame.OnMouseUp })
				Frame.KeybindFrame:SetScript("OnKeyDown", Frame.OnKeyDown)

				local f = CreateFrame("Frame")
				f:RegisterEvent("GLOBAL_MOUSE_UP")
				f:SetScript("OnEvent", function(self, event, ...)
					if event == "GLOBAL_MOUSE_UP" then
						if Frame.keybindMode and not Frame:IsMouseOver() then
							Frame:OnMouseUp()
						end
					end
				end)
			end
		end

		do -- Setup
			Frame:OnLeave(true)
			Frame.KeybindFrame:Hide()
		end

		return Frame
	end

	function NS:UpdateKeybindButtonTheme(keybindButton, data)
		local defaultTexture, highlightTexture, activeTexture, defaultColor, textColor, textHighlightColor, textSize =
			data.defaultTexture, data.highlightTexture, data.activeTexture, data.defaultColor, data.textColor, data.textHighlightColor, data.textSize

		if defaultTexture then keybindButton._CustomDefaultTexture = defaultTexture end
		if highlightTexture then keybindButton._CustomHighlightTexture = highlightTexture end
		if activeTexture then keybindButton._CustomActiveTexture = activeTexture end
		if defaultColor then keybindButton._CustomDefaultColor = defaultColor end
		if textColor then keybindButton._CustomTextColor = textColor end
		if textHighlightColor then keybindButton._CustomTextHighlightColor = textHighlightColor end
		if textSize then keybindButton._CustomTextSize = textSize end
	end
end
