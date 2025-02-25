local addonName, addon = ...
local NS = addon.API.FrameTemplates
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
	-- Creates a keybind button.
	--
	-- Data Table
	----
	-- getFunc, setFunc, enableFunc, theme, defaultTexture, highlightTexture, activeTexture, defaultColor, textColor, textSize
	---@param parent any
	---@param frameStrata string
	---@param data table
	---@param name? string
	function NS:CreateKeybindButton(parent, frameStrata, data, name)
		local getFunc, setFunc, enableFunc, theme, defaultTexture, highlightTexture, activeTexture, defaultColor, textColor, textHighlightColor, textSize =
			data.getFunc, data.setFunc, data.enableFunc, data.theme, data.defaultTexture, data.highlightTexture, data.activeTexture, data.defaultColor, data.textColor, data.textHighlightColor, data.textSize

		--------------------------------

		local Frame = CreateFrame("Frame", name or nil, parent)

		Frame.IsKeybindMode = false
		Frame.Key = nil

		--------------------------------

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

		--------------------------------

		Frame.EnterCallbacks = {}
		Frame.LeaveCallbacks = {}
		Frame.MouseDownCallbacks = {}
		Frame.MouseUpCallbacks = {}
		Frame.ValueChangedCallbacks = {}

		--------------------------------

		local function UpdateTheme()
			if (theme and theme == 2) or (theme == nil and addon.API.Util.NativeAPI:GetDarkTheme()) then -- DARK MODE
				Frame._DefaultTexture = Frame._CustomDefaultTexture or addon.API.Util.PATH .. "Elements/keybind-background-light-outline.png"
				Frame._HighlightTexture = Frame._CustomHighlightTexture or addon.API.Util.PATH .. "Elements/keybind-background-highlighted-light.png"
				Frame._ActiveTexture = Frame._CustomActiveTexture or addon.API.Util.PATH .. "Elements/keybind-background-active-light.png"
				Frame._DefaultColor = Frame._CustomDefaultColor or { r = 1, g = 1, b = 1, a = 1 }
				Frame._TextColor = Frame._CustomTextColor or { r = 1, g = 1, b = 1, a = 1 }
				Frame._TextHighlightColor = Frame._CustomTextHighlightColor or { r = 0, g = 0, b = 0, a = 1 }
				Frame._TextSize = Frame._CustomTextSize or 12.5
			elseif (theme and theme == 1) or (theme == nil and not addon.API.Util.NativeAPI:GetDarkTheme()) then -- LIGHT MODE
				Frame._DefaultTexture = Frame._CustomDefaultTexture or addon.API.Util.PATH .. "Elements/keybind-background-light.png"
				Frame._HighlightTexture = Frame._CustomHighlightTexture or addon.API.Util.PATH .. "Elements/keybind-background-highlighted-light.png"
				Frame._ActiveTexture = Frame._CustomActiveTexture or addon.API.Util.PATH .. "Elements/keybind-background-active-light.png"
				Frame._DefaultColor = Frame._CustomDefaultColor or { r = .1, g = .1, b = .1, a = 1 }
				Frame._TextColor = Frame._CustomTextColor or { r = .1, g = .1, b = .1, a = 1 }
				Frame._TextHighlightColor = Frame._CustomTextHighlightColor or { r = 1, g = 1, b = 1, a = 1 }
				Frame._TextSize = Frame._CustomTextSize or 12.5
			end
		end

		addon.API.Main:RegisterThemeUpdateWithNativeAPI(UpdateTheme, 4)

		--------------------------------

		do -- KEYBIND FRAME
			Frame.KeybindFrame = CreateFrame("Frame", "$parent.KeybindFrame", Frame)
		end

		do -- BACKGROUND
			Frame.Background, Frame.BackgroundTexture = NS:CreateNineSlice(Frame, frameStrata, Frame._DefaultTexture, 64, .175, "$parent.Background")
			Frame.Background:SetAllPoints(Frame, true)

			--------------------------------

			addon.API.Main:RegisterThemeUpdateWithNativeAPI(function()
				Frame.BackgroundTexture:SetVertexColor(Frame._DefaultColor.r, Frame._DefaultColor.g, Frame._DefaultColor.b, Frame._DefaultColor.a)
				Frame.BackgroundTexture:SetTexture(Frame._DefaultTexture)
			end, 5)
		end

		do -- TEXT
			Frame.Text = addon.API.FrameTemplates:CreateText(Frame, Frame._TextColor, Frame._TextSize, "CENTER", "MIDDLE", addon.API.Fonts.Content_Light, "$parent.Text")
			Frame.Text:SetAllPoints(Frame, true)

			--------------------------------

			addon.API.Main:RegisterThemeUpdateWithNativeAPI(function()
				Frame.Text:SetTextColor(Frame._TextColor.r, Frame._TextColor.g, Frame._TextColor.b, Frame._TextColor.a)
			end, 5)
		end

		--------------------------------

		do -- FUNCTIONS
			Frame.UpdateValue = function()
				Frame.Key = getFunc()

				--------------------------------

				Frame.Text:SetText(tostring(Frame.Key))
			end

			Frame.SetValue = function(key)
				setFunc(Frame, key)

				--------------------------------

				Frame.UpdateValue()

				--------------------------------

				if Frame.IsKeybindMode then
					Frame.StopKeybindMode()

					--------------------------------

					local ValueChangedCallbacks = Frame.ValueChangedCallbacks

					for callback = 1, #ValueChangedCallbacks do
						ValueChangedCallbacks[callback]()
					end
				end
			end

			Frame.Enter = function()
				if Frame.IsKeybindMode then
					return
				end

				--------------------------------

				Frame.BackgroundTexture:SetTexture(Frame._HighlightTexture)
				Frame.Text:SetTextColor(Frame._TextColor.r, Frame._TextColor.g, Frame._TextColor.b, Frame._TextColor.a)

				--------------------------------

				local enterCallbacks = Frame.EnterCallbacks

				for callback = 1, #enterCallbacks do
					enterCallbacks[callback]()
				end
			end

			Frame.Leave = function()
				if Frame.IsKeybindMode then
					return
				end

				--------------------------------

				Frame.BackgroundTexture:SetTexture(Frame._DefaultTexture)
				Frame.Text:SetTextColor(Frame._TextColor.r, Frame._TextColor.g, Frame._TextColor.b, Frame._TextColor.a)

				--------------------------------

				local leaveCallbacks = Frame.LeaveCallbacks

				for callback = 1, #leaveCallbacks do
					leaveCallbacks[callback]()
				end
			end

			Frame.MouseUp = function()
				Frame.ToggleKeybindMode()

				--------------------------------

				local mouseUpCallbacks = Frame.MouseUpCallbacks

				for callback = 1, #mouseUpCallbacks do
					mouseUpCallbacks[callback]()
				end
			end

			Frame.KeyDown = function(self, key)
				if Frame.IsKeybindMode then
					if key == "ESCAPE" then
						Frame.StopKeybindMode()
					else
						Frame.SetKeybind(key)
					end
				end
			end

			Frame.ToggleKeybindMode = function()
				if Frame.IsKeybindMode then
					Frame.StopKeybindMode()
				else
					if enableFunc() then
						Frame.StartKeybindMode()
					end
				end
			end

			Frame.StartKeybindMode = function()
				Frame.IsKeybindMode = true
				Frame.KeybindFrame:Show()

				--------------------------------

				Frame.BackgroundTexture:SetTexture(Frame._ActiveTexture)
				Frame.Text:SetTextColor(Frame._TextHighlightColor.r, Frame._TextHighlightColor.g, Frame._TextHighlightColor.b, Frame._TextHighlightColor.a)
			end

			Frame.StopKeybindMode = function()
				Frame.IsKeybindMode = false
				Frame.KeybindFrame:Hide()

				--------------------------------

				if Frame:IsMouseOver() then
					Frame.BackgroundTexture:SetTexture(Frame._HighlightTexture)
					Frame.Text:SetTextColor(Frame._TextColor.r, Frame._TextColor.g, Frame._TextColor.b, Frame._TextColor.a)
				else
					Frame.BackgroundTexture:SetTexture(Frame._DefaultTexture)
					Frame.Text:SetTextColor(Frame._TextColor.r, Frame._TextColor.g, Frame._TextColor.b, Frame._TextColor.a)
				end
			end

			Frame.SetKeybind = function(key)
				Frame.SetValue(key)
			end

			Frame:SetScript("OnEnter", Frame.Enter)
			Frame:SetScript("OnLeave", Frame.Leave)
			Frame:SetScript("OnMouseUp", Frame.MouseUp)
			Frame:SetScript("OnMouseUp", Frame.MouseUp)
			Frame.KeybindFrame:SetScript("OnKeyDown", Frame.KeyDown)

			local Events = CreateFrame("Frame")
			Events:RegisterEvent("GLOBAL_MOUSE_UP")
			Events:SetScript("OnEvent", function(self, event, ...)
				if event == "GLOBAL_MOUSE_UP" then
					if Frame.IsKeybindMode and not Frame:IsMouseOver() then
						Frame.MouseUp()
					end
				end
			end)
		end

		do -- EVENTS

		end

		do -- SETUP
			Frame.KeybindFrame:Hide()
		end

		--------------------------------

		return Frame
	end

	-- Updates the theme of a keybind button.
	--
	-- Data Table
	----
	-- defaultTexture, highlightTexture, defaultColor, textColor, textHighlightColor, textSize
	---@param keybindButton any
	---@param data table
	function NS:UpdateKeybindButtonTheme(keybindButton, data)
		local defaultTexture, highlightTexture, activeTexture, defaultColor, textColor, textHighlightColor, textSize =
			data.defaultTexture, data.highlightTexture, data.activeTexture, data.defaultColor, data.textColor, data.textHighlightColor, data.textSize

		--------------------------------

		if defaultTexture then keybindButton._CustomDefaultTexture = defaultTexture end
		if highlightTexture then keybindButton._CustomHighlightTexture = highlightTexture end
		if activeTexture then keybindButton._CustomActiveTexture = activeTexture end
		if defaultColor then keybindButton._CustomDefaultColor = defaultColor end
		if textColor then keybindButton._CustomTextColor = textColor end
		if textHighlightColor then keybindButton._CustomTextHighlightColor = textHighlightColor end
		if textSize then keybindButton._CustomTextSize = textSize end
	end
end
