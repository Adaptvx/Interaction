local addon = select(2, ...)
local NS = addon.API.FrameTemplates; addon.API.FrameTemplates = NS
local CallbackRegistry = addon.CallbackRegistry


do
	function NS:CreateText(parent, textColor, textSize, alignH, alignV, fontFile, name, createHtml)
		if not parent then
			return
		end

		if type(name) ~= "string" then
			name = nil
		end

		if type(createHtml) ~= "boolean" then
			createHtml = false
		end

		local isRecommendedColor = false

		local Parent = CreateFrame("Frame", name or nil, parent)
		Parent:SetAllPoints(parent, true)

		local Frame = CreateFrame("Frame", name or nil, Parent)
		Frame:SetAllPoints(Parent, true)

		do -- Text
			Frame.Text = Frame:CreateFontString(name or nil, "OVERLAY")

			Frame.Text:SetFont(fontFile, textSize or 11, "")
			Frame.Text:SetJustifyH(alignH or "CENTER")
			Frame.Text:SetJustifyV(alignV or "MIDDLE")
			Frame.Text:SetTextColor(textColor.r or 1, textColor.g or 1, textColor.b or 1)
		end

		do -- Html
			if createHtml then
				local _, fontHeight, _ = Frame.Text:GetFont()
				if fontHeight <= 0 then
					fontHeight = addon.Database.DB_GLOBAL.profile.INT_CONTENT_SIZE
				end

				Frame.Html = CreateFrame("SimpleHTML", (name and name .. "HTML") or nil, Frame)
				Frame.Html:SetFont("P", QuestFont:GetFont(), fontHeight, "")
				Frame.Html:SetFont("H1", GameFontNormal:GetFont(), 48, "")
				Frame.Html:SetFont("H2", Game20Font:GetFont(), fontHeight, "")
				Frame.Html:SetFont("H3", GameFontNormal:GetFont(), 28, "")
				Frame.Html:SetTextColor("P", textColor.r, textColor.g, textColor.b)
				Frame.Html:SetTextColor("H1", textColor.r, textColor.g, textColor.b)
				Frame.Html:SetTextColor("H2", textColor.r, textColor.g, textColor.b)
				Frame.Html:SetTextColor("H3", textColor.r, textColor.g, textColor.b)
				Frame.Html:Hide()

				function Frame:UpdateFormatting()
					if Frame:GetAlpha() == 0 then
						Frame.Html:Hide()
						return
					end

					local _, fontHeight, _ = Frame.Text:GetFont()
					if fontHeight <= 0 then
						fontHeight = addon.Database.DB_GLOBAL.profile.INT_CONTENT_SIZE
					end

					Frame.Html:SetFont("P", QuestFont:GetFont(), fontHeight, "")
					Frame.Html:SetFont("H2", Game20Font:GetFont(), fontHeight, "")

					local text = Frame.Text:GetText()
					if text and addon.API.Util:FindString(text, "<HTML>") then
						Frame.Html:SetSize(Frame.Text:GetWidth() * 1.5, Frame.Text:GetStringHeight())
						Frame.Html:SetScale(.625)
						Frame.Html:SetPoint("TOP", Frame.Text)

						local formattedText = text:gsub('<IMG src="Interface\\Common\\spacer.->', '')

						Frame.Html:SetText(formattedText)

						Frame.Html:Show()
						Frame.Text:Hide()
					else
						Frame.Html:Hide()
						Frame.Text:Show()
					end
				end

				hooksecurefunc(Frame.Text, "SetText", function()
					Frame:UpdateFormatting()
				end)
				hooksecurefunc(Frame.Text, "SetFont", function()
					Frame:UpdateFormatting()
				end)
			end
		end

		local function UpdateTheme()
			if textColor == addon.API.Util.RGB_RECOMMENDED or textColor == addon.Theme.RGB_RECOMMENDED then
				isRecommendedColor = true
			end

			if isRecommendedColor then
				Frame.Text:SetTextColor(addon.API.Util.RGB_RECOMMENDED.r, addon.API.Util.RGB_RECOMMENDED.g, addon.API.Util.RGB_RECOMMENDED.b)
			end
		end

		UpdateTheme()
		addon.API.Main:RegisterThemeUpdateWithNativeAPI(UpdateTheme, 5)

		if createHtml then
			return Frame
		else
			return Frame.Text
		end
	end
end
