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

		local isRecommendedColor = false

		--------------------------------

		local Parent = CreateFrame("Frame", name or nil, parent)
		Parent:SetAllPoints(parent, true)

		local Frame = CreateFrame("Frame", name or nil, Parent)
		Frame:SetAllPoints(Parent, true)

		--------------------------------

		do -- TEXT
			Frame.Text = Frame:CreateFontString(name or nil, "OVERLAY")

			if fontFile then
				Frame.Text:SetFont(fontFile, 11, "")
			end

			if textSize then
				Frame.Text:SetFont(fontFile, textSize, "")
			end

			if alignH then
				Frame.Text:SetJustifyH(alignH)
			end

			if alignV then
				Frame.Text:SetJustifyV(alignV)
			end

			if textColor then
				Frame.Text:SetTextColor(textColor.r, textColor.g, textColor.b)
			end
		end

		do -- HTML
			if createHtml then
				local _, fontHeight, _ = Frame.Text:GetFont()
				if fontHeight <= 0 then
					fontHeight = addon.Database.DB_GLOBAL.profile.INT_CONTENT_SIZE
				end

				--------------------------------

				Frame.Html = CreateFrame("SimpleHTML", (name and name .. "HTML") or nil, Frame)
				Frame.Html:SetFont("P", QuestFont:GetFont(), fontHeight, "")
				Frame.Html:SetFont("H1", AdaptiveAPI.Fonts.Title_Medium, 48, "")
				Frame.Html:SetFont("H2", Game20Font:GetFont(), fontHeight, "")
				Frame.Html:SetFont("H3", AdaptiveAPI.Fonts.Title_Medium, 28, "")
				Frame.Html:SetTextColor("P", textColor.r, textColor.g, textColor.b)
				Frame.Html:SetTextColor("H1", textColor.r, textColor.g, textColor.b)
				Frame.Html:SetTextColor("H2", textColor.r, textColor.g, textColor.b)
				Frame.Html:SetTextColor("H3", textColor.r, textColor.g, textColor.b)

				--------------------------------

				local function UpdateFormatting()
					local _, fontHeight, _ = Frame.Text:GetFont()
					if fontHeight <= 0 then
						fontHeight = addon.Database.DB_GLOBAL.profile.INT_CONTENT_SIZE
					end

					--------------------------------

					Frame.Html:SetFont("P", QuestFont:GetFont(), fontHeight, "")
					Frame.Html:SetFont("H2", Game20Font:GetFont(), fontHeight, "")

					--------------------------------

					if AdaptiveAPI:FindString(Frame.Text:GetText(), "<HTML>") then
						Frame.Html:SetSize(Frame.Text:GetWidth() * 1.5, Frame.Text:GetStringHeight())
						Frame.Html:SetScale(.625)
						Frame.Html:SetPoint("TOP", Frame.Text)

						local text = Frame.Text:GetText()
						local formattedText = text:gsub('<IMG src="Interface\\Common\\spacer.->', '')

						Frame.Html:SetText(formattedText)

						Frame.Html:SetAlpha(1)
						Frame.Text:SetAlpha(0)
					else
						Frame.Html:SetAlpha(0)
						Frame.Text:SetAlpha(1)
					end
				end

				hooksecurefunc(Frame.Text, "SetText", UpdateFormatting)
				hooksecurefunc(Frame.Text, "SetFont", UpdateFormatting)
			end
		end

		--------------------------------

		local function UpdateTheme()
			if textColor == AdaptiveAPI.RGB_RECOMMENDED or textColor == AdaptiveAPI.NativeCallback.Theme.RGB_RECOMMENDED then
				isRecommendedColor = true
			end

			--------------------------------

			if isRecommendedColor then
				Frame.Text:SetTextColor(AdaptiveAPI.RGB_RECOMMENDED.r, AdaptiveAPI.RGB_RECOMMENDED.g, AdaptiveAPI.RGB_RECOMMENDED.b)
			end
		end

		UpdateTheme()
		AdaptiveAPI:RegisterThemeUpdateWithNativeAPI(UpdateTheme, 5)

		--------------------------------

		return Frame.Text
	end
end
