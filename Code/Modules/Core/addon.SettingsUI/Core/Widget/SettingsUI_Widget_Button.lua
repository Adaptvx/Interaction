local addonName, addon = ...
local CallbackRegistry = addon.CallbackRegistry
local L = addon.Locales
local NS = addon.SettingsUI

--------------------------------

-- Creates a clickable Button. Child Frames: Button
function NS.Widgets:CreateButton(parent, click, subcategory, tooltipText, tooltipImage, tooltipImageType, hidden, locked)
	local Frame = NS.Widgets:CreateContainer(parent, subcategory, true, NS.Variables:RATIO(4.5), tooltipText, tooltipImage, tooltipImageType, hidden, locked)

	--------------------------------

	local function Button()
		Frame.button = CreateFrame("Button", nil, Frame.container, "UIPanelButtonTemplate")
		Frame.button:SetSize(Frame.container:GetWidth() - 5, Frame.container:GetHeight() - 5)
		Frame.button:SetPoint("CENTER", Frame.container)
		Frame.button:SetText("Placeholder")

		--------------------------------

		local DefaultColor
		local HighlightColor
		local ActiveColor

		local function UpdateTheme()
			if addon.Theme.IsDarkTheme then
				DefaultColor = addon.Theme.Settings.Element_Default_DarkTheme
				HighlightColor = addon.Theme.Settings.Element_Highlight_DarkTheme
				ActiveColor = addon.Theme.Settings.Element_Active_DarkTheme
			else
				DefaultColor = addon.Theme.Settings.Element_Default_LightTheme
				HighlightColor = addon.Theme.Settings.Element_Highlight_LightTheme
				ActiveColor = addon.Theme.Settings.Element_Active_LightTheme
			end

			AdaptiveAPI.FrameTemplates.Styles:UpdateButton(Frame.button, {
				color = DefaultColor,
				highlightColor = HighlightColor,
				activeColor = ActiveColor
			})
		end

		UpdateTheme()
		addon.API:RegisterThemeUpdate(UpdateTheme, 3)

		AdaptiveAPI.FrameTemplates.Styles:Button(Frame.button, {
			edgeSize = 25,
			scale = .25,
			playAnimation = false,
			color = DefaultColor,
			highlightColor = HighlightColor,
			activeColor = ActiveColor,
			disableMouseHighlight = true,
		})

		--------------------------------

		addon.SoundEffects:SetButton(Frame.button, addon.SoundEffects.Settings_Button_Enter, addon.SoundEffects.Settings_Button_Leave, addon.SoundEffects.Settings_Button_MouseDown, addon.SoundEffects.Settings_Button_MouseUp)

		--------------------------------

		Frame.button:SetScript("OnClick", function()
			click(Frame.button)
		end)
	end

	--------------------------------

	Button()

	--------------------------------

	return Frame
end
