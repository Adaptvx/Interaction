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
	-- Creates a checkbox.
	--
	-- Data Table
	----
	-- theme, defaultTexture, highlightTexture, checkTexture,
	-- checkHighlightTexture, edgeSize, scale, customColor, callbackFunction
	---@param parent any
	---@param frameStrata string
	---@param data table
	---@param name? string
	function NS:CreateCheckbox(parent, frameStrata, data, name)
		local Frame = CreateFrame("Frame", name, parent)
		Frame:SetFrameStrata(frameStrata)

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

		Frame.EnterCallbacks = {}
		Frame.LeaveCallbacks = {}
		Frame.MouseDownCallbacks = {}
		Frame.MouseUpCallbacks = {}

		local function UpdateTheme()
			if (theme and theme == 2) or (theme == nil and AdaptiveAPI.NativeAPI:GetDarkTheme()) then
				Frame._DefaultTexture = Frame._CustomDefaultTexture or AdaptiveAPI.PATH .. "Elements/check-background.png"
				Frame._HighlightTexture = Frame._CustomHighlightTexture or AdaptiveAPI.PATH .. "Elements/check-background-highlighted.png"
				Frame._CheckTexture = Frame._CustomCheckTexture or AdaptiveAPI.PATH .. "Elements/check-dark.png"
				Frame._HighlightCheckTexture = Frame._CustomCheckHighlightTexture or AdaptiveAPI.PATH .. "Elements/check-dark.png"
				Frame._Color = Frame._CustomColor or { r = 1, g = 1, b = 1 }
			elseif (theme and theme == 1) or (theme == nil and not AdaptiveAPI.NativeAPI:GetDarkTheme()) then
				Frame._DefaultTexture = Frame._CustomDefaultTexture or AdaptiveAPI.PATH .. "Elements/check-background.png"
				Frame._HighlightTexture = Frame._CustomHighlightTexture or AdaptiveAPI.PATH .. "Elements/check-background-highlighted.png"
				Frame._CheckTexture = Frame._CustomCheckTexture or AdaptiveAPI.PATH .. "Elements/check-dark.png"
				Frame._HighlightCheckTexture = Frame._CustomCheckHighlightTexture or AdaptiveAPI.PATH .. "Elements/check-light.png"
				Frame._Color = Frame._CustomColor or { r = .1, g = .1, b = .1 }
			end
		end

		AdaptiveAPI:RegisterThemeUpdateWithNativeAPI(UpdateTheme, 4)

		--------------------------------

		Frame.Checkbox = CreateFrame("Frame", "$parent.Checkbox", Frame)
		Frame.Checkbox:SetPoint("LEFT", Frame)
		Frame.Checkbox:SetFrameStrata(frameStrata)

		--------------------------------

		Frame.Checkbox.Background, Frame.Checkbox.BackgroundTexture = AdaptiveAPI.FrameTemplates:CreateNineSlice(Frame.Checkbox, frameStrata, Frame._DefaultTexture, edgeSize or 50, scale or 1, "$parent.Background")
		Frame.Checkbox.Background:SetPoint("CENTER", Frame.Checkbox)
		Frame.Checkbox.Background:SetFrameLevel(Frame.Checkbox:GetFrameLevel() + 1)
		Frame.Checkbox.Background:SetAlpha(1)

		AdaptiveAPI:RegisterThemeUpdateWithNativeAPI(function()
			Frame.Checkbox.BackgroundTexture:SetVertexColor(Frame._Color.r, Frame._Color.g, Frame._Color.b, Frame._Color.a or 1)
		end, 5)

		--------------------------------

		Frame.Checkbox.Icon, Frame.Checkbox.IconTexture = AdaptiveAPI.FrameTemplates:CreateTexture(Frame.Checkbox, frameStrata, Frame._CheckTexture, "$parent.Icon")
		Frame.Checkbox.Icon:SetPoint("CENTER", Frame.Checkbox)
		Frame.Checkbox.Icon:SetFrameLevel(Frame.Checkbox:GetFrameLevel() + 2)

		AdaptiveAPI:RegisterThemeUpdateWithNativeAPI(function()
			Frame.Checkbox.IconTexture:SetTexture(Frame._CheckTexture)
		end, 5)

		--------------------------------

		Frame.UpdateChecked = function()
			Frame.Checkbox.Icon:SetShown(Frame.Checked)
		end

		Frame.SetChecked = function(value)
			Frame.Checked = value

			--------------------------------

			Frame.UpdateChecked()
		end

		--------------------------------

		Frame.Enter = function()
			Frame.Checkbox.BackgroundTexture:SetTexture(Frame._HighlightTexture)
			Frame.Checkbox.IconTexture:SetTexture(Frame._HighlightCheckTexture)

			--------------------------------

			AdaptiveAPI.Animation:Fade(Frame.Checkbox.Background, .125, Frame.Checkbox.Background:GetAlpha(), 1, nil,
				function()
					return not Frame.Checkbox.BackgroundTexture:GetTexture() == Frame._HighlightTexture
				end
			)

			--------------------------------

			local EnterCallbacks = Frame.EnterCallbacks

			--------------------------------

			for callback = 1, #EnterCallbacks do
				EnterCallbacks[callback]()
			end
		end

		Frame.Leave = function()
			Frame.Checkbox.BackgroundTexture:SetTexture(Frame._DefaultTexture)
			Frame.Checkbox.IconTexture:SetTexture(Frame._CheckTexture)

			--------------------------------

			AdaptiveAPI.Animation:Fade(Frame.Checkbox.Background, .125, Frame.Checkbox.Background:GetAlpha(), 1, nil,
				function()
					return not Frame.Checkbox.BackgroundTexture:GetTexture() == Frame._HighlightTexture
				end
			)

			--------------------------------

			local LeaveCallbacks = Frame.LeaveCallbacks

			for callback = 1, #LeaveCallbacks do
				LeaveCallbacks[callback]()
			end
		end

		Frame.MouseDown = function()
			local MouseDownCallbacks = Frame.MouseDownCallbacks

			for callback = 1, #MouseDownCallbacks do
				MouseDownCallbacks[callback]()
			end
		end

		Frame.Click = function()
			Frame.SetChecked(not Frame.Checked)

			--------------------------------

			callbackFunction(Frame, Frame.Checked)

			--------------------------------

			local MouseUpCallbacks = Frame.MouseUpCallbacks

			for callback = 1, #MouseUpCallbacks do
				MouseUpCallbacks[callback]()
			end
		end

		--------------------------------

		Frame:SetScript("OnEnter", function()
			Frame.Enter()
		end)

		Frame:SetScript("OnLeave", function()
			Frame.Leave()
		end)

		Frame:SetScript("OnMouseDown", function()
			Frame.MouseDown()
		end)

		Frame:SetScript("OnMouseUp", function()
			Frame.Click()
		end)

		--------------------------------

		local function UpdateSize()
			Frame.Checkbox:SetSize(Frame:GetHeight(), Frame:GetHeight())
			Frame.Checkbox.Background:SetSize(Frame.Checkbox:GetSize())
			Frame.Checkbox.Icon:SetSize(Frame.Checkbox:GetWidth() - 10, Frame.Checkbox:GetHeight() - 10)
		end

		hooksecurefunc(Frame, "SetWidth", UpdateSize)
		hooksecurefunc(Frame, "SetHeight", UpdateSize)
		hooksecurefunc(Frame, "SetSize", UpdateSize)

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

	-- Creates an advanced checkbox.
	--
	-- Data Table
	----
	-- defaultTexture, highlightTexture, checkTexture,
	-- edgeSize, scale, labelText, textColor, textSize, callbackFunction
	---@param parent any
	---@param frameStrata string
	---@param data table
	---@param name? string
	function NS:CreateAdvancedCheckbox(parent, frameStrata, data, name)
		local Frame = CreateFrame("Frame", name, parent)
		Frame:SetFrameStrata(frameStrata)

		--------------------------------

		local defaultTexture, highlightTexture, checkTexture, edgeSize, scale,
		labelText, textColor, textSize, callbackFunction =
			data.defaultTexture, data.highlightTexture, data.checkTexture, data.edgeSize, data.scale,
			data.labelText, data.textColor, data.textSize, data.callbackFunction

		--------------------------------

		local DefaultTexture = AdaptiveAPI.Presets.NINESLICE_INSCRIBED_BORDER
		local HighlightTexture = AdaptiveAPI.Presets.NINESLICE_INSCRIBED
		local CheckTexture = AdaptiveAPI.PATH .. "Elements/check.png"

		--------------------------------

		Frame.Checked = false

		Frame.EnterCallbacks = {}
		Frame.LeaveCallbacks = {}
		Frame.MouseDownCallbacks = {}
		Frame.MouseUpCallbacks = {}

		--------------------------------

		local function Checkbox()
			Frame.Checkbox = CreateFrame("Frame", "$parent.Checkbox", Frame)
			Frame.Checkbox:SetPoint("LEFT", Frame)
			Frame.Checkbox:SetFrameStrata(frameStrata)

			--------------------------------

			local function Background()
				Frame.Checkbox.Background, Frame.Checkbox.BackgroundTexture = AdaptiveAPI.FrameTemplates:CreateNineSlice(Frame.Checkbox, frameStrata, defaultTexture or DefaultTexture, edgeSize or 50, scale or 1, "$parent.Background")
				Frame.Checkbox.Background:SetPoint("CENTER", Frame.Checkbox)
				Frame.Checkbox.Background:SetFrameLevel(Frame.Checkbox:GetFrameLevel() + 1)
				Frame.Checkbox.Background:SetAlpha(.5)
			end

			local function Icon()
				Frame.Checkbox.Icon, Frame.Checkbox.IconTexture = AdaptiveAPI.FrameTemplates:CreateTexture(Frame.Checkbox, frameStrata, checkTexture or CheckTexture, "$parent.Icon")
				Frame.Checkbox.Icon:SetPoint("CENTER", Frame.Checkbox)
				Frame.Checkbox.Icon:SetFrameLevel(Frame.Checkbox:GetFrameLevel() + 2)
			end

			--------------------------------

			Background()
			Icon()
		end

		local function Label()
			Frame.Label = AdaptiveAPI.FrameTemplates:CreateText(Frame, { r = textColor.r, g = textColor.g, b = textColor.b }, textSize, "LEFT", "MIDDLE", AdaptiveAPI.Fonts.Content_Light)
			Frame.Label:SetText(labelText)
		end

		--------------------------------

		Checkbox()
		Label()

		--------------------------------

		Frame.UpdateChecked = function()
			Frame.Checkbox.Icon:SetShown(Frame.Checked)
		end

		Frame.SetChecked = function(value)
			Frame.Checked = value

			--------------------------------

			Frame.UpdateChecked()
		end

		--------------------------------

		Frame.Enter = function()
			Frame.Checkbox.Background:SetAlpha(1)
			Frame.Checkbox.BackgroundTexture:SetTexture(highlightTexture or HighlightTexture)

			--------------------------------

			local EnterCallbacks = Frame.EnterCallbacks

			for callback = 1, #EnterCallbacks do
				EnterCallbacks[callback]()
			end
		end

		Frame.Leave = function()
			Frame.Checkbox.Background:SetAlpha(.5)
			Frame.Checkbox.BackgroundTexture:SetTexture(defaultTexture or DefaultTexture)

			--------------------------------

			local LeaveCallbacks = Frame.LeaveCallbacks

			for callback = 1, #LeaveCallbacks do
				LeaveCallbacks[callback]()
			end
		end

		Frame.MouseDown = function()
			local MouseDownCallbacks = Frame.MouseDownCallbacks

			for callback = 1, #MouseDownCallbacks do
				MouseDownCallbacks[callback]()
			end
		end

		Frame.Click = function()
			Frame.SetChecked(not Frame.Checked)

			--------------------------------

			callbackFunction(Frame, Frame.Checked)

			--------------------------------

			local MouseUpCallbacks = Frame.MouseUpCallbacks

			for callback = 1, #MouseUpCallbacks do
				MouseUpCallbacks[callback]()
			end
		end

		--------------------------------

		Frame:SetScript("OnEnter", function()
			Frame.Enter()
		end)

		Frame:SetScript("OnLeave", function()
			Frame.Leave()
		end)

		Frame:SetScript("OnMouseDown", function()
			Frame.MouseDown()
		end)

		Frame:SetScript("OnMouseUp", function()
			Frame.Click()
		end)

		--------------------------------

		local function UpdateSize()
			Frame.Checkbox:SetSize(Frame:GetHeight(), Frame:GetHeight())
			Frame.Checkbox.Background:SetSize(Frame.Checkbox:GetSize())
			Frame.Checkbox.Icon:SetSize(Frame.Checkbox:GetWidth() - 10, Frame.Checkbox:GetHeight() - 10)

			Frame.Label:SetSize(Frame:GetWidth() - 5 - Frame.Checkbox:GetWidth() - 5, Frame:GetHeight())
			Frame.Label:SetPoint("LEFT", Frame, 5 + Frame.Checkbox:GetWidth() + 5, 0)
		end

		hooksecurefunc(Frame, "SetWidth", UpdateSize)
		hooksecurefunc(Frame, "SetHeight", UpdateSize)
		hooksecurefunc(Frame, "SetSize", UpdateSize)

		--------------------------------

		return Frame
	end
end
