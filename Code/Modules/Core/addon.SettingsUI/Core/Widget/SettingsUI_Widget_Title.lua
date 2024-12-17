local addonName, addon = ...
local CallbackRegistry = addon.CallbackRegistry
local L = addon.Locales
local NS = addon.SettingsUI

--------------------------------

-- Creates a Title Container. Child Frames: Icon, IconTexture, Label, Divider, Divider Texture
function NS.Widgets:CreateTitle(parent, iconPath, textSize, subcategory, hidden, locked)

    --------------------------------

    local Frame = NS.Widgets:CreateContainer(parent, subcategory, false, 45, nil, nil, nil, hidden, locked)

    --------------------------------

    local function Icon()
        Frame.icon, Frame.iconTexture = AdaptiveAPI.FrameTemplates:CreateTexture(Frame, "HIGH", iconPath)
        Frame.icon:SetSize(Frame:GetHeight() - 10, Frame:GetHeight() - 10)
        Frame.icon:SetPoint("LEFT", Frame, 5, 0)
    end

    local function Label()
        Frame.label = AdaptiveAPI.FrameTemplates:CreateText(Frame.container, addon.Theme.RGB_RECOMMENDED, textSize, "LEFT", "MIDDLE", AdaptiveAPI.Fonts.Content_Light)

        if iconPath then
            Frame.label:SetSize(Frame:GetWidth() - Frame.icon:GetWidth() - 5, Frame:GetHeight())
            Frame.label:SetPoint("LEFT", Frame.container, Frame.icon:GetWidth() + 5, 0)
            Frame.label:SetAlpha(1)
        else
            Frame.label:SetSize(Frame:GetWidth() - 10, Frame:GetHeight())
            Frame.label:SetPoint("LEFT", Frame.container)
            Frame.label:SetAlpha(1)
        end
    end

    local function Divider()
        Frame.divider, Frame.dividerTexture = AdaptiveAPI.FrameTemplates:CreateTexture(Frame, "HIGH", AdaptiveAPI.Presets.BASIC_SQUARE)
        Frame.divider:SetSize(Frame:GetWidth(), 1)
        Frame.divider:SetPoint("BOTTOM", Frame)

        --------------------------------

        local function UpdateTheme()
            local DividerColor
            if addon.Theme.IsDarkTheme then
                DividerColor = { r = 1, g = 1, b = 1, a = .125 }
            else
                DividerColor = { r = .1, g = .1, b = .1, a = 1 }
            end

            Frame.dividerTexture:SetVertexColor(DividerColor.r, DividerColor.g, DividerColor.b, DividerColor.a)
        end

        UpdateTheme()
        addon.API:RegisterThemeUpdate(UpdateTheme, 5)
    end

    --------------------------------

    Icon()
    Label()

    --------------------------------

    return Frame
end
