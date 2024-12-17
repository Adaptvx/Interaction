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

	local function Checkbox()
		local TEXTURE_Check
		local TEXTURE_CheckHighlight
		local COLOR_Default

		local function UpdateTheme()
			if addon.Theme.IsDarkTheme then
				TEXTURE_Check = AdaptiveAPI.PATH .. "Elements/check-dark-mode.png"
				TEXTURE_CheckHighlight = AdaptiveAPI.PATH .. "Elements/check-light-mode.png"
				COLOR_Default = addon.Theme.Settings.Element_Default_DarkTheme
			else
				TEXTURE_Check = addon.Variables.PATH .. "Art/Settings/check-light-mode.png"
				TEXTURE_CheckHighlight = AdaptiveAPI.PATH .. "Elements/check-dark-mode.png"
				COLOR_Default = addon.Theme.Settings.Element_Default_LightTheme
			end

			if Frame.checkbox then
				AdaptiveAPI.FrameTemplates:UpdateCheckboxTheme(Frame.checkbox, {
					checkTexture = TEXTURE_Check,
					checkHighlightTexture = TEXTURE_CheckHighlight,
					customColor = COLOR_Default
				})
			end
		end

		UpdateTheme()
		addon.API:RegisterThemeUpdate(UpdateTheme, 3)

		--------------------------------

		Frame.checkbox = AdaptiveAPI.FrameTemplates:CreateCheckbox(Frame.container, Frame:GetFrameStrata(), {
			scale = .425,
			customColor = COLOR_Default,
			callbackFunction = setFunc
		}, "$parent.checkbox")
		Frame.checkbox:SetSize(Frame.container:GetHeight(), Frame.container:GetHeight())
		Frame.checkbox:SetPoint("RIGHT", Frame.container)

		--------------------------------

		local function UpdateState()
			Frame.checkbox.SetChecked(getFunc())
		end

		--------------------------------

		table.insert(Frame.checkbox.MouseUpCallbacks, UpdateState)
		CallbackRegistry:Add("START_SETTING", UpdateState, 0)

		--------------------------------

		addon.SoundEffects:SetCheckbox(Frame.checkbox, addon.SoundEffects.Settings_Checkbox_Enter, addon.SoundEffects.Settings_Checkbox_Leave, addon.SoundEffects.Settings_Checkbox_MouseDown, addon.SoundEffects.Settings_Checkbox_MouseUp)
	end

	--------------------------------

	Checkbox()

	--------------------------------

	return Frame
end
