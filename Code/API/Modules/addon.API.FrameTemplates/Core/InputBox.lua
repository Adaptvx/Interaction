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
	-- Creates an input box.
	--
	-- Data Table
	----
	-- defaultTexture, highlightTexture,
	-- edgeSize, scale,
	-- textColor, font, fontSize, justifyH, justifyV, hint, valueUpdateCallback
	---@param parent any
	---@param frameStrata string
	---@param data table
	---@param name? string
	function NS:CreateInputBox(parent, frameStrata, data, name)
		local defaultTexture, highlightTexture,
		edgeSize, scale,
		textColor, font, fontSize, justifyH, justifyV, hint, valueUpdateCallback =
			data.defaultTexture, data.highlightTexture,
			data.edgeSize, data.scale,
			data.textColor, data.font, data.fontSize, data.justifyH, data.justifyV, data.hint, data.valueUpdateCallback

		--------------------------------

		local Frame = CreateFrame("EditBox", name or nil, parent)
		Frame:SetFontObject(GameFontNormal)
		Frame:SetTextColor(textColor.r, textColor.g, textColor.b)
		Frame:SetAutoFocus(false)
		Frame.AutoSelect = false

		--------------------------------

		Frame.EnterCallbacks = {}
		Frame.LeaveCallbacks = {}
		Frame.MouseDownCallbacks = {}
		Frame.MouseUpCallbacks = {}
		Frame.ValueChangedCallbacks = {}

		--------------------------------

		do -- ELEMENTS
			do -- BACKGROUND
				Frame.Background, Frame.BackgroundTexture = addon.API.FrameTemplates:CreateNineSlice(Frame, frameStrata, defaultTexture, edgeSize or 50, scale or 1, "$parent.Background")
				Frame.Background:SetPoint("TOPLEFT", Frame, -10, 0)
				Frame.Background:SetPoint("BOTTOMRIGHT", Frame, 10, 0)
				Frame.Background:SetAlpha(.5)
			end

			do -- TEXT
				Frame.Text = Frame:GetFontObject()
				Frame.Text:SetJustifyH(justifyH or "LEFT")
				Frame.Text:SetJustifyV(justifyV or "MIDDLE")
				Frame.Text:SetFont(font or GameFontNormal:GetFont(), fontSize or 12.5, "")
			end

			do -- PLACEHOLDER
				Frame.PlaceholderText = addon.API.FrameTemplates:CreateText(Frame, textColor, fontSize, justifyH or "LEFT", justifyV or "MIDDLE", addon.API.Fonts.Content_Light, "$parent.PlaceholderText")
				Frame.PlaceholderText:SetAllPoints(Frame)
				Frame.PlaceholderText:SetText(hint)
				Frame.PlaceholderText:SetAlpha(.5)
			end
		end

		do -- CLICK EVENTS
			Frame.Enter = function()
				Frame.BackgroundTexture:SetTexture(highlightTexture)
				Frame.BackgroundTexture:SetVertexColor(1, 1, 1)

				--------------------------------

				addon.API.Animation:Fade(Frame.Background, .125, Frame.Background:GetAlpha(), 1, nil,
					function()
						return not Frame.BackgroundTexture:GetTexture() == highlightTexture
					end
				)

				--------------------------------

				local enterCallbacks = Frame.EnterCallbacks

				--------------------------------

				for callback = 1, #enterCallbacks do
					enterCallbacks[callback]()
				end
			end

			Frame.Leave = function()
				Frame.BackgroundTexture:SetTexture(defaultTexture)
				Frame.BackgroundTexture:SetVertexColor(1, 1, 1)

				--------------------------------

				addon.API.Animation:Fade(Frame.Background, .125, Frame.Background:GetAlpha(), 1, nil,
					function()
						return not Frame.BackgroundTexture:GetTexture() == highlightTexture
					end
				)

				--------------------------------

				local leaveCallbacks = Frame.LeaveCallbacks

				for callback = 1, #leaveCallbacks do
					leaveCallbacks[callback]()
				end
			end

			Frame.ValueUpdate = function(...)
				valueUpdateCallback(...)

				--------------------------------

				local ValueChangedCallbacks = Frame.ValueChangedCallbacks

				for _, Callback in pairs(ValueChangedCallbacks) do
					Callback(...)
				end
			end

			Frame:SetScript("OnEnter", Frame.Enter)
			Frame:SetScript("OnLeave", function()
				if not Frame:HasFocus() then
					Frame.Leave()
				end
			end)
			Frame:SetScript("OnEditFocusGained", Frame.Enter)
			Frame:SetScript("OnEditFocusLost", Frame.Leave)
			Frame:SetScript("OnEscapePressed", Frame.ClearFocus)
			Frame:SetScript("OnTextChanged", Frame.ValueUpdate)
			Frame:SetScript("OnShow", function()
				addon.Libraries.AceTimer:ScheduleTimer(function()
					if Frame.AutoSelect then
						Frame:SetFocus()
					else
						Frame:ClearFocus()
					end
				end, 0)
			end)
		end

		do -- EVENTS
			local function UpdatePlaceholder()
				Frame.PlaceholderText:SetShown(Frame:GetText() == "")
			end
			UpdatePlaceholder()

			hooksecurefunc(Frame, "Show", UpdatePlaceholder)
			Frame:HookScript("OnTextChanged", UpdatePlaceholder)
		end

		--------------------------------

		Frame.Leave()

		--------------------------------

		return Frame
	end
end
