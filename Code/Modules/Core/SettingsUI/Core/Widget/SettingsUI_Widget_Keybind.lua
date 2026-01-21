local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local TemplateRegistry = addon.TemplateRegistry
local L = addon.Locales
local NS = addon.SettingsUI; addon.SettingsUI = NS

function NS.Widgets:CreateKeybindButton(parent, getFunc, setFunc, enableFunc, subcategory, tooltipText, tooltipTextDynamic, tooltipImage, tooltipImageType, hidden, locked, opacity)
	local OffsetX = 0

	local Frame = NS.Widgets:CreateContainer(parent, subcategory, true, nil, tooltipText, tooltipTextDynamic, tooltipImage, tooltipImageType, hidden, locked, opacity)

	do -- Keybind
		Frame.KeybindButton = addon.API.FrameTemplates:CreateKeybindButton(Frame.Container, Frame:GetFrameStrata(), Frame:GetFrameLevel() + 1, {
			getFunc = getFunc,
			setFunc = setFunc,
			enableFunc = enableFunc
		}, "$parent.KeybindButton")
		Frame.KeybindButton:SetSize(225, Frame.Container:GetHeight())
		Frame.KeybindButton:SetPoint("RIGHT", Frame.Container)

		local function UpdateTheme()
			local COLOR_Default

			if addon.Theme.IsDarkTheme then
				COLOR_Default = { r = addon.Theme.Settings.Element_Default_DarkTheme.r, g = addon.Theme.Settings.Element_Default_DarkTheme.g, b = addon.Theme.Settings.Element_Default_DarkTheme.b, a = .75}
			else
				COLOR_Default = addon.Theme.Settings.Element_Default_LightTheme
			end

			if Frame.KeybindButton then
				addon.API.FrameTemplates:UpdateKeybindButtonTheme(Frame.KeybindButton, {
					defaultColor = COLOR_Default
				})
			end
		end

		UpdateTheme()
		addon.API.Main:RegisterThemeUpdate(UpdateTheme, 3)

		addon.SoundEffects:SetKeybind(Frame.KeybindButton)

		CallbackRegistry:Add("START_SETTING", Frame.KeybindButton.UpdateValue, 0)
	end

	return Frame
end
