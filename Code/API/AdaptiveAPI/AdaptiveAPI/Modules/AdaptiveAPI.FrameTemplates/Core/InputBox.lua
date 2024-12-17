local addonName, addon = ...
local NS = AdaptiveAPI.FrameTemplates

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

		local function Background()
			Frame.Background, Frame.BackgroundTexture = AdaptiveAPI.FrameTemplates:CreateNineSlice(Frame, frameStrata, defaultTexture, edgeSize or 50, scale or 1, "$parent.Background")
			Frame.Background:SetPoint("CENTER", Frame)
			Frame.Background:SetAlpha(.5)
		end

		local function Text()
			Frame.Text = Frame:GetFontObject()
			Frame.Text:SetJustifyH(justifyH or "LEFT")
			Frame.Text:SetJustifyV(justifyV or "MIDDLE")
			Frame.Text:SetFont(font or GameFontNormal:GetFont(), fontSize or 12.5, "")
		end

		local function Placeholder()
			Frame.PlaceholderText = AdaptiveAPI.FrameTemplates:CreateText(Frame, textColor, fontSize, justifyH or "LEFT", justifyV or "MIDDLE", AdaptiveAPI.Fonts.Content_Light, "$parent.PlaceholderText")
			Frame.PlaceholderText:SetPoint("CENTER", Frame)
			Frame.PlaceholderText:SetText(hint)
			Frame.PlaceholderText:SetAlpha(.5)
		end

		--------------------------------

		Background()
		Text()
		Placeholder()

		--------------------------------

		Frame.Enter = function()
			Frame.BackgroundTexture:SetTexture(highlightTexture)
			Frame.BackgroundTexture:SetVertexColor(1, 1, 1)

			--------------------------------

			AdaptiveAPI.Animation:Fade(Frame.Background, .125, Frame.Background:GetAlpha(), 1, nil,
				function()
					return not Frame.BackgroundTexture:GetTexture() == highlightTexture
				end
			)

			--------------------------------

			local MouseEnterCallbacks = Frame.EnterCallbacks

			--------------------------------

			for callback = 1, #MouseEnterCallbacks do
				MouseEnterCallbacks[callback]()
			end
		end

		Frame.Leave = function()
			Frame.BackgroundTexture:SetTexture(defaultTexture)
			Frame.BackgroundTexture:SetVertexColor(1, 1, 1)

			--------------------------------

			AdaptiveAPI.Animation:Fade(Frame.Background, .125, Frame.Background:GetAlpha(), 1, nil,
				function()
					return not Frame.BackgroundTexture:GetTexture() == highlightTexture
				end
			)

			--------------------------------

			local LeaveCallbacks = Frame.LeaveCallbacks

			for callback = 1, #LeaveCallbacks do
				LeaveCallbacks[callback]()
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

		Frame:SetScript("OnEnter", function()
			Frame.Enter()
		end)

		Frame:SetScript("OnLeave", function()
			if not Frame:HasFocus() then
				Frame.Leave()
			end
		end)

		Frame:SetScript("OnEditFocusGained", function()
			Frame.Enter()
		end)

		Frame:SetScript("OnEditFocusLost", function()
			Frame.Leave()
		end)

		Frame:SetScript("OnEscapePressed", function()
			Frame:ClearFocus()
		end)

		Frame:SetScript("OnTextChanged", function(...)
			Frame.ValueUpdate(...)
		end)

		Frame:SetScript("OnShow", function()
			addon.Libraries.AceTimer:ScheduleTimer(function()
				if Frame.AutoSelect then
					Frame:SetFocus()
				else
					Frame:ClearFocus()
				end
			end, 0)
		end)

		--------------------------------

		local function UpdateSize()
			Frame.Background:SetSize(Frame:GetWidth() + 20, Frame:GetHeight())
			Frame.PlaceholderText:SetSize(Frame:GetWidth(), Frame:GetHeight())
		end

		local function UpdatePlaceholder()
			Frame.PlaceholderText:SetShown(Frame:GetText() == "")
		end

		UpdatePlaceholder()

		hooksecurefunc(Frame, "Show", UpdatePlaceholder)
		hooksecurefunc(Frame, "SetWidth", UpdateSize)
		hooksecurefunc(Frame, "SetHeight", UpdateSize)
		hooksecurefunc(Frame, "SetSize", UpdateSize)
		Frame:HookScript("OnTextChanged", UpdatePlaceholder)

		--------------------------------

		Frame.Leave()

		--------------------------------

		return Frame
	end
end
