local addonName, addon = ...
local CallbackRegistry = addon.CallbackRegistry
local L = addon.Locales
local NS = addon.SettingsUI

--------------------------------

-- Creates a clickable Dropdown. Child Frames:
function NS.Widgets:CreateDropdown(parent, optionsTable, openListFunc, closeListFunc, autoCloseList, setFunc, getFunc, subcategory, tooltipText, tooltipImage, tooltipImageType, hidden, locked)
    local OffsetX = 0

    --------------------------------

    local Frame = NS.Widgets:CreateContainer(parent, subcategory, true, nil, tooltipText, tooltipImage, tooltipImageType, hidden, locked)

    --------------------------------

    local function Dropdown()
        Frame.Dropdown = AdaptiveAPI.FrameTemplates:CreateDropdown(InteractionSettingsFrame, Frame.container, Frame:GetFrameStrata(), {
			valuesFunc = optionsTable,
			openListFunc = openListFunc,
			closeListFunc = closeListFunc,
			autoCloseList = autoCloseList,
			getFunc = getFunc,
			setFunc = setFunc,
		}, "$parent.Dropdown")
        Frame.Dropdown:SetSize(325, Frame.container:GetHeight())
        Frame.Dropdown:SetPoint("RIGHT", Frame.container)

		--------------------------------

		local COLOR_Default
		local COLOR_Highlight

		local function UpdateTheme()
			if addon.Theme.IsDarkTheme then
				COLOR_Default = addon.Theme.Settings.Secondary_DarkTheme
				COLOR_Highlight = addon.Theme.Settings.Element_Highlight_DarkTheme
			else
				COLOR_Default = addon.Theme.Settings.Secondary_LightTheme
				COLOR_Highlight = addon.Theme.Settings.Element_Default_LightTheme
			end

			AdaptiveAPI.FrameTemplates:UpdateDropdownTheme(Frame.Dropdown, {
				defaultColor = COLOR_Default,
				highlightColor = COLOR_Highlight
			})
		end

		UpdateTheme()
		addon.API:RegisterThemeUpdate(UpdateTheme, 3)

		--------------------------------

		addon.SoundEffects:SetDropdown(Frame.Dropdown, addon.SoundEffects.Settings_Dropdown_Enter, addon.SoundEffects.Settings_Dropdown_Leave, addon.SoundEffects.Settings_Dropdown_MouseDown, addon.SoundEffects.Settings_Dropdown_MouseUp, addon.SoundEffects.Settings_Dropdown_ListElementEnter, addon.SoundEffects.Settings_Dropdown_ListElementLeave, addon.SoundEffects.Settings_Dropdown_ListElementMouseDown, addon.SoundEffects.Settings_Dropdown_ListElementMouseUp, addon.SoundEffects.Settings_Dropdown_ValueChanged)
    end

    --------------------------------

    Dropdown()

    --------------------------------

    return Frame
end
