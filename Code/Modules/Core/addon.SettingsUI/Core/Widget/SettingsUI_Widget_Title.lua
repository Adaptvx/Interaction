local addonName, addon = ...
local CallbackRegistry = addon.CallbackRegistry
local L = addon.Locales
local NS = addon.SettingsUI

--------------------------------

-- Creates a Title Container. Child Frames: Icon, IconTexture, Label, Divider, Divider Texture
function NS.Widgets:CreateTitle(parent, iconPath, textSize, subcategory, hidden, locked)

    --------------------------------

    local Frame = NS.Widgets:CreateContainer(parent, subcategory, false, 45, nil, nil, nil, nil, hidden, locked)

    --------------------------------

	do -- ICON
        Frame.Icon, Frame.iconTexture = AdaptiveAPI.FrameTemplates:CreateTexture(Frame, "HIGH", iconPath)
        Frame.Icon:SetSize(Frame:GetHeight() - 10, Frame:GetHeight() - 10)
        Frame.Icon:SetPoint("LEFT", Frame, 5, 0)
    end

	do -- LABEL
        Frame.Label = AdaptiveAPI.FrameTemplates:CreateText(Frame.Container, addon.Theme.RGB_RECOMMENDED, textSize, "LEFT", "MIDDLE", AdaptiveAPI.Fonts.Content_Light)

		--------------------------------

        if iconPath then
            Frame.Label:SetSize(Frame:GetWidth() - Frame.Icon:GetWidth() - 5, Frame:GetHeight())
            Frame.Label:SetPoint("LEFT", Frame.Container, Frame.Icon:GetWidth() + 5, 0)
            Frame.Label:SetAlpha(1)
        else
            Frame.Label:SetSize(Frame:GetWidth() - 10, Frame:GetHeight())
            Frame.Label:SetPoint("LEFT", Frame.Container)
            Frame.Label:SetAlpha(1)
        end
    end

    --------------------------------

    return Frame
end
