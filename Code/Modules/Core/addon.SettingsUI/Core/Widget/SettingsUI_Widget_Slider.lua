---@class addon
local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local PrefabRegistry = addon.PrefabRegistry
local L = addon.Locales
local NS = addon.SettingsUI; addon.SettingsUI = NS

--------------------------------

-- Creates a clickable Slider. Child Frames: Slider, Slider Label, Label
function NS.Widgets:CreateSlider(parent, valueStep, min, max, grid, valueTextFunc, finishFunc, getFunc, setFunc, subcategory, tooltipText, tooltipTextDynamic, tooltipImage, tooltipImageType, hidden, locked, opacity)
	local OffsetX = 0

	--------------------------------

	local Frame = NS.Widgets:CreateContainer(parent, subcategory, true, nil, tooltipText, tooltipTextDynamic, tooltipImage, tooltipImageType, hidden, locked, opacity)

	--------------------------------

	do -- FRAME (SLIDER)
		Frame.SliderFrame = CreateFrame("Frame", "$parent.SliderFrame", Frame.Container)
		Frame.SliderFrame:SetSize(225, Frame.Container:GetHeight())
		Frame.SliderFrame:SetPoint("RIGHT", Frame.Container)

		--------------------------------

		do -- SLIDER
			Frame.SliderFrame.Slider = CreateFrame("Slider", nil, Frame, "MinimalSliderTemplate")
			Frame.SliderFrame.Slider:SetSize(Frame.SliderFrame:GetWidth(), Frame.Container:GetHeight() + 10)
			Frame.SliderFrame.Slider:SetPoint("RIGHT", Frame.Container)
			Frame.SliderFrame.Slider:SetMinMaxValues(min, max)
			Frame.SliderFrame.Slider:SetValueStep(valueStep)

			--------------------------------

			local COLOR_Default
			local COLOR_Thumb

			local function UpdateTheme()
				if addon.Theme.IsDarkTheme then
					COLOR_Default = addon.Theme.Settings.Secondary_DarkTheme
					COLOR_Thumb = addon.Theme.Settings.Element_Default_DarkTheme
				else
					COLOR_Default = addon.Theme.Settings.Secondary_LightTheme
					COLOR_Thumb = addon.Theme.Settings.Element_Default_LightTheme
				end

				addon.API.FrameTemplates.Styles:UpdateSlider(Frame.SliderFrame.Slider, {
					customColor = COLOR_Default,
					customThumbColor = COLOR_Thumb
				})
			end

			UpdateTheme()
			addon.API.Main:RegisterThemeUpdate(UpdateTheme, 3)

			addon.API.FrameTemplates.Styles:Slider(Frame.SliderFrame.Slider, {
				customColor = COLOR_Default,
				customThumbColor = COLOR_Thumb,
				grid = grid
			})

			--------------------------------

			addon.SoundEffects:SetSlider(Frame.SliderFrame.Slider, addon.SoundEffects.Settings_Slider_Enter, addon.SoundEffects.Settings_Slider_Leave, addon.SoundEffects.Settings_Slider_MouseDown, addon.SoundEffects.Settings_Slider_MouseUp, addon.SoundEffects.Settings_Slider_ValueChanged)
		end

		do -- TEXT
			Frame.SliderFrame.Text = addon.API.FrameTemplates:CreateText(Frame.SliderFrame, addon.Theme.RGB_RECOMMENDED, 14, "CENTER", "MIDDLE", addon.API.Fonts.CONTENT_LIGHT)
			Frame.SliderFrame.Text:SetSize(Frame.SliderFrame:GetWidth(), Frame.Container:GetHeight())
			Frame.SliderFrame.Text:SetPoint("CENTER", Frame.SliderFrame, 0, 7.5)
			Frame.SliderFrame.Text:SetAlpha(.75)
		end

		do -- EVENTS
			local target

			--------------------------------

			local function UpdateValueText()
				local value = target or getFunc(Frame.SliderFrame.Slider)

				--------------------------------

				local text = valueTextFunc(value)
				Frame.SliderFrame.Text:SetText(text)
			end

			local function UpdateState()
				if not InteractionSettingsFrame:IsVisible() then
					return
				end

				--------------------------------

				local value = target or getFunc(Frame.SliderFrame.Slider)

				--------------------------------

				Frame.SliderFrame.Slider:SetValue(value)
				setFunc(Frame.SliderFrame.Slider, value)

				--------------------------------

				UpdateValueText()
			end

			--------------------------------

			do -- CLICK EVENTS
				Frame.Set = function()
					local new = target
					target = nil

					--------------------------------

					setFunc(Frame.SliderFrame.Slider, new)

					--------------------------------

					UpdateState()
				end

				Frame.OnValueChanged = function(self, new, userInput)
					if not InteractionSettingsFrame:IsVisible() then
						return
					end

					--------------------------------

					if valueTextFunc == nil then
						valueTextFunc = function(value)
							return string.format("%.2f", value)
						end
					end

					--------------------------------

					if getFunc(Frame.SliderFrame.Slider) ~= new then
						target = new

						--------------------------------

						Frame.Set()
					else
						target = new

						--------------------------------

						Frame.Set()
					end
				end

				Frame.OnMouseUp = function()
					finishFunc()
				end

				Frame.SliderFrame.Slider:SetScript("OnValueChanged", Frame.OnValueChanged)
				Frame.SliderFrame.Slider:SetScript("OnMouseUp", Frame.OnMouseUp)
			end

			--------------------------------

			CallbackRegistry:Add("START_SETTING", UpdateState, 0)
		end
	end

	--------------------------------

	return Frame
end
