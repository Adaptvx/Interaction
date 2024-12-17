local addonName, addon = ...
local CallbackRegistry = addon.CallbackRegistry
local L = addon.Locales
local NS = addon.SettingsUI

--------------------------------

-- Creates a clickable Slider. Child Frames: Slider, Slider Label, Label
function NS.Widgets:CreateSlider(parent, valueStep, min, max, grid, valueTextFunc, setFunc, getFunc, subcategory, tooltipText, tooltipImage, tooltipImageType, hidden, locked)
    local OffsetX = 0

    --------------------------------

    local Frame = NS.Widgets:CreateContainer(parent, subcategory, true, nil, tooltipText, tooltipImage, tooltipImageType, hidden, locked)

    --------------------------------

    local function Slider()
        Frame.SliderFrame = CreateFrame("Frame", "$parent.SliderFrame", Frame.container)
        Frame.SliderFrame:SetSize(325, Frame.container:GetHeight())
        Frame.SliderFrame:SetPoint("RIGHT", Frame.container)

        --------------------------------

        local function Slider()
            Frame.SliderFrame.Slider = CreateFrame("Slider", nil, Frame, "MinimalSliderTemplate")
            Frame.SliderFrame.Slider:SetSize(325, Frame.container:GetHeight() + 10)
            Frame.SliderFrame.Slider:SetPoint("RIGHT", Frame.container)
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

				AdaptiveAPI.FrameTemplates.Styles:UpdateSlider(Frame.SliderFrame.Slider, {
					customColor = COLOR_Default,
					customThumbColor = COLOR_Thumb
				})
			end

			UpdateTheme()
			addon.API:RegisterThemeUpdate(UpdateTheme, 3)

			AdaptiveAPI.FrameTemplates.Styles:Slider(Frame.SliderFrame.Slider, {
				customColor = COLOR_Default,
				customThumbColor = COLOR_Thumb,
				grid = grid
			})

			--------------------------------

			addon.SoundEffects:SetSlider(Frame.SliderFrame.Slider, addon.SoundEffects.Settings_Slider_Enter, addon.SoundEffects.Settings_Slider_Leave, addon.SoundEffects.Settings_Slider_MouseDown, addon.SoundEffects.Settings_Slider_MouseUp, addon.SoundEffects.Settings_Slider_ValueChanged)
        end

        local function Label()
            Frame.SliderFrame.Label = AdaptiveAPI.FrameTemplates:CreateText(Frame.SliderFrame, addon.Theme.RGB_RECOMMENDED, 15, "CENTER", "MIDDLE", AdaptiveAPI.Fonts.Content_Light)
            Frame.SliderFrame.Label:SetSize(100, Frame.container:GetHeight())
            Frame.SliderFrame.Label:SetPoint("CENTER", Frame.SliderFrame, 0, 5)
        end

        local function Events()
            local function UpdateState()
                if not InteractionSettingsFrame:IsVisible() then
                    return
                end

                local value = getFunc(Frame.SliderFrame.Slider)

                Frame.SliderFrame.Slider:SetValue(value)
                setFunc(Frame.SliderFrame.Slider, value)
            end

            Frame.SliderFrame.Slider:SetScript("OnValueChanged", function(self, new)
                if not InteractionSettingsFrame:IsVisible() then
                    return
                end

                if valueTextFunc == nil then
                    valueTextFunc = function(value)
                        return string.format("%.2f", value)
                    end
                end

                setFunc(Frame.SliderFrame.Slider, new)

                local text = valueTextFunc(new)
                Frame.SliderFrame.Label:SetText(text)

                if getFunc(Frame.SliderFrame.Slider) ~= Frame.SliderFrame.Slider:GetValue() then
                    UpdateState()
                end
            end)

            -- UPDATE
            -- AdaptiveAPI:OnUpdate(Frame.SliderFrame.Slider, function(self)
            --     UpdateState()
            -- end)

            -- CALLBACK
            -- CallbackRegistry:Add("SETTING_CHANGED", function(frame)
            --     if getFunc(Frame.SliderFrame.Slider) ~= Frame.SliderFrame.Slider:GetValue() then
            --         UpdateState()
            --     end
            -- end, 0)

            CallbackRegistry:Add("START_SETTING", UpdateState, 0)
        end

        --------------------------------

        Slider()
        Label()
        Events()
    end

    --------------------------------

    Slider()

    --------------------------------

    return Frame
end
