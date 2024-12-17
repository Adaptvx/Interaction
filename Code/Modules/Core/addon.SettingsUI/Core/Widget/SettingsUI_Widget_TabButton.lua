local addonName, addon = ...
local CallbackRegistry = addon.CallbackRegistry
local L = addon.Locales
local NS = addon.SettingsUI

--------------------------------

-- Creates a clickable Tab Button. Child Frames: Button
function NS.Widgets:CreateTabButton(parent, click)
	local Frame = CreateFrame("Frame")
	Frame:SetParent(parent)
	Frame:SetSize(parent:GetWidth(), InteractionSettingsFrame.Content.Header:GetHeight())
	Frame:SetPoint("TOP", parent)

	--------------------------------

	local function Button()
		Frame.button = CreateFrame("Button", nil, Frame, "UIPanelButtonTemplate")
		Frame.button:SetSize(Frame:GetWidth(), Frame:GetHeight())
		Frame.button:SetPoint("CENTER", Frame)
		Frame.button:SetText("Placeholder")

		--------------------------------

		local DefaultColor
		local HighlightColor
		local ActiveColor
		local TextColor
		local TextHighlightColor

		local function UpdateTheme()
			if addon.Theme.IsDarkTheme then
				DefaultColor = addon.Theme.Settings.Tertiary_DarkTheme
				HighlightColor = addon.Theme.Settings.Tertiary_DarkTheme
				ActiveColor = addon.Theme.Settings.Secondary_DarkTheme
				TextColor = addon.Theme.Settings.Text_Default_DarkTheme
				TextHighlightColor = addon.Theme.Settings.Text_Highlight_DarkMode
			else
				DefaultColor = addon.Theme.Settings.Tertiary_LightTheme
				HighlightColor = addon.Theme.Settings.Tertiary_LightTheme
				ActiveColor = addon.Theme.Settings.Secondary_LightTheme
				TextColor = addon.Theme.Settings.Text_Default_LightTheme
				TextHighlightColor = addon.Theme.Settings.Text_Highlight_LightMode
			end

			AdaptiveAPI.FrameTemplates.Styles:UpdateButton(Frame.button, {
				customColor = DefaultColor,
				customHighlightColor = HighlightColor,
				customActiveColor = ActiveColor,
				customTextColor = TextColor,
				customTextHighlightColor = TextHighlightColor
			})

			--------------------------------

			if Frame.button and Frame.button.Leave then
				Frame.button.Leave()
			end
		end

		UpdateTheme()
		addon.API:RegisterThemeUpdate(UpdateTheme, 3)

		AdaptiveAPI.FrameTemplates.Styles:Button(Frame.button, {
			defaultTexture = AdaptiveAPI.PATH .. "empty",
			playAnimation = false,
			color = DefaultColor,
			highlightColor = HighlightColor,
			activeColor = ActiveColor,
			textColor = TextColor,
			textHighlightColor = TextHighlightColor,
		})

		--------------------------------

		addon.SoundEffects:SetButton(Frame.button, addon.SoundEffects.Settings_TabButton_Enter, addon.SoundEffects.Settings_TabButton_Leave, addon.SoundEffects.Settings_TabButton_MouseDown, addon.SoundEffects.Settings_TabButton_MouseUp)

		--------------------------------

		local function Text()
			Frame.button.text = Frame.button:GetFontString()
			Frame.button.text:SetSize(Frame.button:GetWidth() - NS.Variables:RATIO(6), Frame.button:GetWidth() - NS.Variables:RATIO(6))
			Frame.button.text:SetFont(AdaptiveAPI.Fonts.Content_Light, 17.5, "")
			Frame.button.text:SetJustifyH("LEFT")
			Frame.button.text:SetJustifyV("MIDDLE")
		end

		local function Icon()
			Frame.button.leftIcon, Frame.button.leftIconTexture = AdaptiveAPI.FrameTemplates:CreateTexture(Frame.button, Frame.button:GetFrameStrata(), nil, "$parent.leftIcon")
			Frame.button.leftIcon:SetSize(35, 35)
			Frame.button.leftIcon:SetPoint("LEFT", Frame.button, 12.5, 0)
			Frame.button.rightIcon, Frame.button.rightIconTexture = AdaptiveAPI.FrameTemplates:CreateTexture(Frame.button, Frame.button:GetFrameStrata(), nil, "$parent.rightIcon")
			Frame.button.rightIcon:SetSize(35, 35)
			Frame.button.rightIcon:SetPoint("RIGHT", Frame.button, -12.5, 0)

			--------------------------------

			addon.API:RegisterThemeUpdate(function()
				local TEXTURE_LEFT
				local TEXTURE_RIGHT

				if addon.Theme.IsDarkTheme then
					TEXTURE_LEFT = addon.Variables.PATH .. "Art/Platform/Platform-LB-Tab-Light.png"
					TEXTURE_RIGHT = addon.Variables.PATH .. "Art/Platform/Platform-RB-Tab-Light.png"
				else
					TEXTURE_LEFT = addon.Variables.PATH .. "Art/Platform/Platform-LB-Tab.png"
					TEXTURE_RIGHT = addon.Variables.PATH .. "Art/Platform/Platform-RB-Tab.png"
				end

				Frame.button.leftIconTexture:SetTexture(TEXTURE_LEFT)
				Frame.button.rightIconTexture:SetTexture(TEXTURE_RIGHT)
			end, 5)
		end

		--------------------------------

		Text()
		Icon()

		--------------------------------

		Frame.button.SetGuide = function()
			Frame.button.text:SetWidth(Frame.button:GetWidth() - 95)
			Frame.button.text:SetJustifyH("CENTER")

			Frame.button.leftIcon:Show()
			Frame.button.rightIcon:Show()
		end

		Frame.button.ClearGuide = function()
			Frame.button.text:SetWidth(Frame.button:GetWidth() - NS.Variables:RATIO(6))
			Frame.button.text:SetJustifyH("LEFT")

			Frame.button.leftIcon:Hide()
			Frame.button.rightIcon:Hide()
		end

		Frame.button:SetScript("OnClick", function()
			click(Frame.button)
		end)

		--------------------------------

		Frame.button.ClearGuide()
	end

	--------------------------------

	Button()

	--------------------------------

	return Frame
end
