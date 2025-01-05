local addonName, addon = ...
local CallbackRegistry = addon.CallbackRegistry
local L = addon.Locales
local NS = addon.SettingsUI

--------------------------------

-- Creates a clickable Checkbox. Child Frames: Icon (if applicable), Container, Checkbox, Label
function NS.Widgets:CreateCheckbox(parent, setFunc, getFunc, subcategory, tooltipText, tooltipImage, tooltipImageType, hidden, locked)
	local OffsetX = 0

	--------------------------------

	local Frame = NS.Widgets:CreateContainer(parent, subcategory, true, nil, tooltipText, tooltipImage, tooltipImageType, hidden, locked)

	--------------------------------

	do -- CHECKBOX
		local TEXTURE_Check
		local TEXTURE_CheckHighlight
		local COLOR_Default

		local function UpdateTheme()
			if addon.Theme.IsDarkTheme then
				TEXTURE_Check = AdaptiveAPI.PATH .. "Elements/check-light.png"
				TEXTURE_CheckHighlight = AdaptiveAPI.PATH .. "Elements/check-dark.png"
				COLOR_Default = addon.Theme.Settings.Element_Default_DarkTheme
			else
				TEXTURE_Check = addon.Variables.PATH .. "Art/Settings/check-dark.png"
				TEXTURE_CheckHighlight = AdaptiveAPI.PATH .. "Elements/check-light.png"
				COLOR_Default = addon.Theme.Settings.Element_Default_LightTheme
			end

			if Frame.Checkbox then
				AdaptiveAPI.FrameTemplates:UpdateCheckboxTheme(Frame.Checkbox, {
					checkTexture = TEXTURE_Check,
					checkHighlightTexture = TEXTURE_CheckHighlight,
					defaultColor = COLOR_Default
				})
			end
		end

		UpdateTheme()
		addon.API:RegisterThemeUpdate(UpdateTheme, 3)

		--------------------------------

		Frame.Checkbox = AdaptiveAPI.FrameTemplates:CreateCheckbox(Frame.Container, Frame:GetFrameStrata(), {
			scale = .425,
			customColor = COLOR_Default,
			callbackFunction = setFunc
		}, "$parent.Checkbox")
		Frame.Checkbox:SetSize(Frame.Container:GetHeight(), Frame.Container:GetHeight())
		Frame.Checkbox:SetPoint("RIGHT", Frame.Container)

		--------------------------------

		local function UpdateState()
			Frame.Checkbox.SetChecked(getFunc())
		end

		--------------------------------

		table.insert(Frame.Checkbox.MouseUpCallbacks, UpdateState)
		CallbackRegistry:Add("START_SETTING", UpdateState, 0)

		--------------------------------

		addon.SoundEffects:SetCheckbox(Frame.Checkbox, addon.SoundEffects.Settings_Checkbox_Enter, addon.SoundEffects.Settings_Checkbox_Leave, addon.SoundEffects.Settings_Checkbox_MouseDown, addon.SoundEffects.Settings_Checkbox_MouseUp)
	end

	--------------------------------

	return Frame
end
