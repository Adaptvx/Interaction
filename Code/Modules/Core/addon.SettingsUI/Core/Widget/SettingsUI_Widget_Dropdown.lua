---@class addon
local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local PrefabRegistry = addon.PrefabRegistry
local L = addon.Locales
local NS = addon.SettingsUI; addon.SettingsUI = NS

--------------------------------

-- Creates a clickable Dropdown. Child Frames: Dropdown
function NS.Widgets:CreateDropdown(parent, optionsTable, openListFunc, closeListFunc, autoCloseList, getFunc, setFunc, enableFunc, subcategory, tooltipText, tooltipTextDynamic, tooltipImage, tooltipImageType, hidden, locked, opacity)
	local OffsetX = 0

	--------------------------------

	local Frame = NS.Widgets:CreateContainer(parent, subcategory, true, nil, tooltipText, tooltipTextDynamic, tooltipImage, tooltipImageType, hidden, locked, opacity)

	--------------------------------

	do -- DROPDOWN
		Frame.Dropdown = addon.API.FrameTemplates:CreateDropdown(InteractionSettingsFrame, Frame.Container, Frame:GetFrameStrata(), {
			valuesFunc = optionsTable,
			openListFunc = openListFunc,
			closeListFunc = closeListFunc,
			autoCloseList = autoCloseList,
			getFunc = getFunc,
			setFunc = setFunc,
			enableFunc = enableFunc,
		}, "$parent.Dropdown")
		Frame.Dropdown:SetSize(225, Frame.Container:GetHeight())
		Frame.Dropdown:SetPoint("RIGHT", Frame.Container)

		--------------------------------

		local COLOR_Default
		local COLOR_Highlight
		local COLOR_DefaultText
		local COLOR_HighlightText
		local COLOR_LIST
		local COLOR_LIST_Element
		local COLOR_LIST_Primary
		local COLOR_LIST_ElementText
		local COLOR_LIST_ElementHighlightText

		local function UpdateTheme()
			if addon.Theme.IsDarkTheme then
				COLOR_Default = addon.Theme.Settings.Secondary_DarkTheme
				COLOR_Highlight = addon.Theme.Settings.Element_Highlight_DarkTheme
				COLOR_DefaultText = addon.Theme.RGB_WHITE
				COLOR_HighlightText = addon.Theme.RGB_WHITE
				COLOR_LIST = { r = 1, g = 1, b = 1, a = 1 }
				COLOR_LIST_Element = { r = 1, g = 1, b = 1, a = .25 }
				COLOR_LIST_Primary = { r = 1, g = 1, b = 1, a = 1 }
				COLOR_LIST_ElementText = { r = 1, g = 1, b = 1, a = .5 }
				COLOR_LIST_ElementHighlightText = { r = 1, g = 1, b = 1, a = 1 }
			else
				COLOR_Default = addon.Theme.Settings.Secondary_LightTheme
				COLOR_Highlight = addon.Theme.Settings.Element_Default_LightTheme
				COLOR_DefaultText = addon.Theme.RGB_BLACK
				COLOR_HighlightText = addon.Theme.RGB_WHITE
				COLOR_LIST = { r = 1, g = 1, b = 1, a = 1 }
				COLOR_LIST_Element = { r = .741, g = .513, b = .301, a = .25 }
				COLOR_LIST_Primary = { r = .494, g = .360, b = .250, a = 1 }
				COLOR_LIST_ElementText = { r = .494, g = .360, b = .250, a = .75 }
				COLOR_LIST_ElementHighlightText = addon.Theme.Settings.Element_Default_LightTheme
			end

			addon.API.FrameTemplates:UpdateDropdownTheme(Frame.Dropdown, {
				defaultColor = COLOR_Default,
				highlightColor = COLOR_Highlight,
				defaultTextColor = COLOR_DefaultText,
				highlightTextColor = COLOR_HighlightText,
				listColor = COLOR_LIST,
				listElementColor = COLOR_LIST_Element,
				listPrimaryColor = COLOR_LIST_Primary,
				listElementTextColor = COLOR_LIST_ElementText,
				listElementHighlightTextColor = COLOR_LIST_ElementHighlightText,
			})
		end

		UpdateTheme()
		addon.API.Main:RegisterThemeUpdate(UpdateTheme, 3)

		--------------------------------

		addon.SoundEffects:SetDropdown(Frame.Dropdown, addon.SoundEffects.Settings_Dropdown_Enter, addon.SoundEffects.Settings_Dropdown_Leave, addon.SoundEffects.Settings_Dropdown_MouseDown, addon.SoundEffects.Settings_Dropdown_MouseUp, addon.SoundEffects.Settings_Dropdown_ListElementEnter, addon.SoundEffects.Settings_Dropdown_ListElementLeave, addon.SoundEffects.Settings_Dropdown_ListElementMouseDown, addon.SoundEffects.Settings_Dropdown_ListElementMouseUp, addon.SoundEffects.Settings_Dropdown_ValueChanged)

		--------------------------------

		InteractionSettingsFrame.Content.ScrollFrame:HookScript("OnMouseWheel", function(self, delta)
			if not addon.API.Main:IsElementInScrollFrame(InteractionSettingsFrame.Content.ScrollFrame, Frame) then
				if Frame.Dropdown.List:IsVisible() then
					Frame.Dropdown.List:HideList()
					Frame.Dropdown.Leave()
				end
			end
		end)
	end

	--------------------------------

	return Frame
end
