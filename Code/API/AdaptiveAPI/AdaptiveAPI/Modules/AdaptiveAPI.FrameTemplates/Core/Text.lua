local addonName, addon = ...
local NS = AdaptiveAPI.FrameTemplates
local CallbackRegistry = addon.CallbackRegistry

--------------------------------
-- VARIABLES
--------------------------------

do -- MAIN

end

do -- CONSTANTS

end

--------------------------------
-- TEMPLATES
--------------------------------

do
	-- Creates a text. Optional HTML rendering support.
	---@param parent any
	---@param textColor table
	---@param textSize number
	---@param alignH string
	---@param alignV string
	---@param fontFile string
	---@param name? string
	---@param createHtml? boolean
	function NS:CreateText(parent, textColor, textSize, alignH, alignV, fontFile, name, createHtml)
		if not parent then
			return
		end

		--------------------------------

		local RecommendedColor = false

		--------------------------------

        local Parent = CreateFrame("Frame", name or nil, parent)
		Parent:SetAllPoints(parent)

		local Frame = CreateFrame("Frame", name or nil, Parent)
		Frame:SetAllPoints(Parent)

		local HTML
		local Label

		--------------------------------

		Label = Frame:CreateFontString(name or nil, "OVERLAY")
		if createHtml then
			local _, fontHeight, _ = Label:GetFont()
			if fontHeight <= 0 then
				fontHeight = DB_GLOBAL.profile.INT_CONTENT_SIZE
			end

			--------------------------------

			HTML = CreateFrame("SimpleHTML", (name and name .. "HTML") or nil, Frame)
			HTML:SetFont("P", QuestFont:GetFont(), fontHeight, "")
			HTML:SetFont("H1", AdaptiveAPI.Fonts.Title_Medium, 48, "")
			HTML:SetFont("H2", Game20Font:GetFont(), fontHeight, "")
			HTML:SetFont("H3", AdaptiveAPI.Fonts.Title_Medium, 28, "")
			HTML:SetTextColor("P", textColor.r, textColor.g, textColor.b)
			HTML:SetTextColor("H1", textColor.r, textColor.g, textColor.b)
			HTML:SetTextColor("H2", textColor.r, textColor.g, textColor.b)
			HTML:SetTextColor("H3", textColor.r, textColor.g, textColor.b)

			--------------------------------

			local function UpdateFormatting()
				local _, fontHeight, _ = Label:GetFont()
				if fontHeight <= 0 then
					fontHeight = DB_GLOBAL.profile.INT_CONTENT_SIZE
				end

				--------------------------------

				HTML:SetFont("P", QuestFont:GetFont(), fontHeight, "")
				HTML:SetFont("H2", Game20Font:GetFont(), fontHeight, "")

				--------------------------------

				if AdaptiveAPI:FindString(Label:GetText(), "<HTML>") then
					HTML:SetSize(Label:GetWidth() * 1.5, Label:GetStringHeight())
					HTML:SetScale(.625)
					HTML:SetPoint("TOP", Label)

					local text = Label:GetText()
					local formattedText = text:gsub('<IMG src="Interface\\Common\\spacer.->', '')

					HTML:SetText(formattedText)

					HTML:SetAlpha(1)
					Label:SetAlpha(0)
				else
					HTML:SetAlpha(0)
					Label:SetAlpha(1)
				end
			end

			hooksecurefunc(Label, "SetText", UpdateFormatting)
			hooksecurefunc(Label, "SetFont", UpdateFormatting)
		end

		--------------------------------

		if fontFile then
			Label:SetFont(fontFile, 11, "")
		end

		if textSize then
			Label:SetFont(fontFile, textSize, "")
		end

		if alignH then
			Label:SetJustifyH(alignH)
		end

		if alignV then
			Label:SetJustifyV(alignV)
		end

		if textColor then
			Label:SetTextColor(textColor.r, textColor.g, textColor.b)
		end

		--------------------------------

		local function UpdateTheme()
			if textColor == AdaptiveAPI.RGB_RECOMMENDED or textColor == AdaptiveAPI.NativeCallback.Theme.RGB_RECOMMENDED then
				RecommendedColor = true
			end

			--------------------------------

			if RecommendedColor then
				Label:SetTextColor(AdaptiveAPI.RGB_RECOMMENDED.r, AdaptiveAPI.RGB_RECOMMENDED.g, AdaptiveAPI.RGB_RECOMMENDED.b)
			end
		end

		UpdateTheme()
		AdaptiveAPI:RegisterThemeUpdateWithNativeAPI(UpdateTheme, 5)

		--------------------------------

		return Label
	end
end
