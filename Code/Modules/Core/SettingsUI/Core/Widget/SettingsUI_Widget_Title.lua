local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local TemplateRegistry = addon.TemplateRegistry
local L = addon.Locales
local NS = addon.SettingsUI; addon.SettingsUI = NS

function NS.Widgets:CreateTitle(parent, isSubtitle, textSize, subcategory, tooltipText, tooltipTextDynamic, tooltipImage, tooltipImageSize, hidden, locked, opacity)
	--------------------------------

	local Frame = NS.Widgets:CreateContainer(parent, subcategory, tooltipText and true or false, isSubtitle and 35 or 45, tooltipText, tooltipTextDynamic, tooltipImage, tooltipImageSize, hidden, locked, opacity)

	do -- Label
		local width = isSubtitle and Frame.Container:GetWidth() or Frame:GetWidth() - 10
        local height = isSubtitle and Frame.Container:GetHeight() or Frame:GetHeight()
        local offsetX = isSubtitle and 12.5 or 0
        local offsetY = 0

		Frame.Label = addon.API.FrameTemplates:CreateText(Frame.Container, addon.Theme.RGB_RECOMMENDED, textSize, "LEFT", "MIDDLE", GameFontNormal:GetFont())
		Frame.Label:SetSize(width, height)
		Frame.Label:SetPoint("LEFT", Frame.Container, offsetX, offsetY)
		Frame.Label:SetAlpha(1)
	end

	return Frame
end
