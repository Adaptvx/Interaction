---@class addon
local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local PrefabRegistry = addon.PrefabRegistry
local L = addon.Locales
local NS = addon.SettingsUI; addon.SettingsUI = NS

--------------------------------

-- Creates a clickable Tab Button. Child Frames: Button
function NS.Widgets:CreateTabButton(parent, setFunc)
	local Frame = CreateFrame("Frame")
	Frame:SetParent(parent)
	Frame:SetSize(parent:GetWidth(), InteractionSettingsFrame.Content.Header:GetHeight())
	Frame:SetPoint("TOP", parent)

	--------------------------------

	do -- BUTTON
		Frame.Button = CreateFrame("Button", nil, Frame, "UIPanelButtonTemplate")
		Frame.Button:SetSize(Frame:GetWidth(), Frame:GetHeight())
		Frame.Button:SetPoint("CENTER", Frame)
		Frame.Button:SetText("Placeholder")

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

			addon.API.FrameTemplates.Styles:UpdateButton(Frame.Button, {
				customColor = DefaultColor,
				customHighlightColor = HighlightColor,
				customActiveColor = ActiveColor,
				customTextColor = TextColor,
				customTextHighlightColor = TextHighlightColor
			})

			--------------------------------

			if Frame.Button and Frame.Button.Leave then
				Frame.Button.Leave()
			end
		end

		UpdateTheme()
		addon.API.Main:RegisterThemeUpdate(UpdateTheme, 3)

		addon.API.FrameTemplates.Styles:Button(Frame.Button, {
			defaultTexture = addon.Variables.PATH_ART .. "Elements/empty",
			playAnimation = false,
			color = DefaultColor,
			highlightColor = HighlightColor,
			activeColor = ActiveColor,
			textColor = TextColor,
			textHighlightColor = TextHighlightColor,
		})

		--------------------------------

		addon.SoundEffects:SetButton(Frame.Button, addon.SoundEffects.Settings_TabButton_Enter, addon.SoundEffects.Settings_TabButton_Leave, addon.SoundEffects.Settings_TabButton_MouseDown, addon.SoundEffects.Settings_TabButton_MouseUp)

		--------------------------------

		do -- TEXT
			Frame.Button.Text = Frame.Button:GetFontString()
			Frame.Button.Text:SetSize(Frame.Button:GetWidth() - NS.Variables:RATIO(6), Frame.Button:GetWidth() - NS.Variables:RATIO(6))
			Frame.Button.Text:SetFont(addon.API.Fonts.CONTENT_LIGHT, 17.5, "")
			Frame.Button.Text:SetJustifyH("LEFT")
			Frame.Button.Text:SetJustifyV("MIDDLE")
		end

		do -- ICON
			Frame.Button.Left_Icon, Frame.Button.Left_IconTexture = addon.API.FrameTemplates:CreateTexture(Frame.Button, Frame.Button:GetFrameStrata(), nil, "$parent.leftIcon")
			Frame.Button.Left_Icon:SetSize(35, 35)
			Frame.Button.Left_Icon:SetPoint("LEFT", Frame.Button, 12.5, 0)
			Frame.Button.Right_Icon, Frame.Button.Right_IconTexture = addon.API.FrameTemplates:CreateTexture(Frame.Button, Frame.Button:GetFrameStrata(), nil, "$parent.rightIcon")
			Frame.Button.Right_Icon:SetSize(35, 35)
			Frame.Button.Right_Icon:SetPoint("RIGHT", Frame.Button, -12.5, 0)

			--------------------------------

			addon.API.Main:RegisterThemeUpdate(function()
				local TEXTURE_LEFT
				local TEXTURE_RIGHT

				if addon.Theme.IsDarkTheme then
					TEXTURE_LEFT = addon.Variables.PATH_ART .. "Platform/Platform-LB-Tab-Light.png"
					TEXTURE_RIGHT = addon.Variables.PATH_ART .. "Platform/Platform-RB-Tab-Light.png"
				else
					TEXTURE_LEFT = addon.Variables.PATH_ART .. "Platform/Platform-LB-Tab.png"
					TEXTURE_RIGHT = addon.Variables.PATH_ART .. "Platform/Platform-RB-Tab.png"
				end

				Frame.Button.Left_IconTexture:SetTexture(TEXTURE_LEFT)
				Frame.Button.Right_IconTexture:SetTexture(TEXTURE_RIGHT)
			end, 5)
		end

		--------------------------------

		Frame.Button.SetGuide = function()
			Frame.Button.Text:SetWidth(Frame.Button:GetWidth() - 95)
			Frame.Button.Text:SetJustifyH("CENTER")

			Frame.Button.Left_Icon:Show()
			Frame.Button.Right_Icon:Show()
		end

		Frame.Button.ClearGuide = function()
			Frame.Button.Text:SetWidth(Frame.Button:GetWidth() - NS.Variables:RATIO(6))
			Frame.Button.Text:SetJustifyH("LEFT")

			Frame.Button.Left_Icon:Hide()
			Frame.Button.Right_Icon:Hide()
		end

		Frame.Button:SetScript("OnClick", function()
			setFunc(Frame.Button)
		end)

		--------------------------------

		Frame.Button.ClearGuide()
	end

	--------------------------------

	return Frame
end
