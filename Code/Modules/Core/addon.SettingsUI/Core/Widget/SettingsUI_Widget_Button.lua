---@class addon
local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local PrefabRegistry = addon.PrefabRegistry
local L = addon.Locales
local NS = addon.SettingsUI; addon.SettingsUI = NS

--------------------------------

-- Creates a clickable Button. Child Frames: Button
function NS.Widgets:CreateButton(parent, setFunc, subcategory, tooltipText, tooltipTextDynamic, tooltipImage, tooltipImageType, hidden, locked, opacity)
	local Frame = NS.Widgets:CreateContainer(parent, subcategory, true, NS.Variables:RATIO(4.5), tooltipText, tooltipTextDynamic, tooltipImage, tooltipImageType, hidden, locked, opacity)

	--------------------------------

	do -- BUTTON
		Frame.Button = CreateFrame("Button", nil, Frame.Container, "UIPanelButtonTemplate")
		Frame.Button:SetSize(Frame.Container:GetWidth() - 5, Frame.Container:GetHeight() - 5)
		Frame.Button:SetPoint("CENTER", Frame.Container)
		Frame.Button:SetText("Placeholder")

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

			addon.API.FrameTemplates.Styles:UpdateButton(Frame.Button, {
				color = DefaultColor,
				highlightColor = HighlightColor,
				activeColor = ActiveColor
			})
		end

		UpdateTheme()
		addon.API.Main:RegisterThemeUpdate(UpdateTheme, 3)

		addon.API.FrameTemplates.Styles:Button(Frame.Button, {
			edgeSize = 25,
			scale = .25,
			playAnimation = false,
			color = DefaultColor,
			highlightColor = HighlightColor,
			activeColor = ActiveColor,
			disableMouseHighlight = true,
		})

		--------------------------------

		addon.SoundEffects:SetButton(Frame.Button, addon.SoundEffects.Settings_Button_Enter, addon.SoundEffects.Settings_Button_Leave, addon.SoundEffects.Settings_Button_MouseDown, addon.SoundEffects.Settings_Button_MouseUp)

		--------------------------------

		Frame.Button:SetScript("OnClick", function()
			setFunc(Frame.Button)
		end)
	end

	--------------------------------

	return Frame
end
