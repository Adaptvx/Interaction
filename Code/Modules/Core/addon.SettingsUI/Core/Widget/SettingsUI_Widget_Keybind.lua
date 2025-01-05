local addonName, addon = ...
local CallbackRegistry = addon.CallbackRegistry
local L = addon.Locales
local NS = addon.SettingsUI

--------------------------------

-- Creates a keybind button. Child Frames: KeybindButton
function NS.Widgets:CreateKeybindButton(parent, setFunc, getFunc, enableFunc, subcategory, tooltipText, tooltipImage, tooltipImageType, hidden, locked)
	local OffsetX = 0

	--------------------------------

	local Frame = NS.Widgets:CreateContainer(parent, subcategory, true, nil, tooltipText, tooltipImage, tooltipImageType, hidden, locked)

	--------------------------------

	do -- KEYBIND
		Frame.KeybindButton = AdaptiveAPI.FrameTemplates:CreateKeybindButton(Frame.Container, Frame:GetFrameStrata(), {
			setFunc = setFunc,
			getFunc = getFunc,
			enableFunc = enableFunc
		}, "$parent.KeybindButton")
		Frame.KeybindButton:SetSize(150, Frame.Container:GetHeight())
		Frame.KeybindButton:SetPoint("RIGHT", Frame.Container)

		--------------------------------

		local function UpdateTheme()
			local COLOR_Default

			if addon.Theme.IsDarkTheme then
				COLOR_Default = addon.Theme.Settings.Element_Default_DarkTheme
			else
				COLOR_Default = addon.Theme.Settings.Element_Default_LightTheme
			end

			if Frame.KeybindButton then
				AdaptiveAPI.FrameTemplates:UpdateKeybindButtonTheme(Frame.KeybindButton, {
					defaultColor = COLOR_Default
				})
			end
		end

		UpdateTheme()
		addon.API:RegisterThemeUpdate(UpdateTheme, 3)

		--------------------------------

		addon.SoundEffects:SetKeybind(Frame.KeybindButton, addon.SoundEffects.Settings_Keybind_Enter, addon.SoundEffects.Settings_Keybind_Leave, addon.SoundEffects.Settings_Keybind_MouseDown, addon.SoundEffects.Settings_Keybind_MouseUp, addon.SoundEffects.Settings_Keybind_ValueChanged)

		--------------------------------

		CallbackRegistry:Add("START_SETTING", Frame.KeybindButton.UpdateValue, 0)
	end

	--------------------------------

	return Frame
end
