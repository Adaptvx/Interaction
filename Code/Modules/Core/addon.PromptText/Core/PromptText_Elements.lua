---@class addon
local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local PrefabRegistry = addon.PrefabRegistry
local L = addon.Locales
local NS = addon.PromptText; addon.PromptText = NS

--------------------------------

NS.Elements = {}

--------------------------------

function NS.Elements:Load()
	--------------------------------
	-- CREATE ELEMENTS
	--------------------------------

	do
		do -- ELEMENTS
			InteractionTextPromptFrame = CreateFrame("Frame", "InteractionTextPromptFrame", InteractionFrame)
			InteractionTextPromptFrame:SetSize(375, 500)
			InteractionTextPromptFrame:SetFrameStrata("FULLSCREEN_DIALOG")
			InteractionTextPromptFrame:SetFrameLevel(100)
			InteractionTextPromptFrame:EnableMouse(true)

			local Frame = InteractionTextPromptFrame

			--------------------------------

			local PADDING = 10

			do -- BACKGROUND
				Frame.Background, Frame.BackgroundTexture = addon.API.FrameTemplates:CreateNineSlice(Frame, "FULLSCREEN_DIALOG", nil, 75, 1, "$parent.Background")
				Frame.Background:SetSize(Frame:GetWidth() + 25, Frame:GetHeight() + 25)
				Frame.Background:SetPoint("CENTER", Frame)
				Frame.Background:SetFrameStrata("FULLSCREEN_DIALOG")
				Frame.Background:SetFrameLevel(99)
				Frame.BackgroundTexture:SetVertexColor(.1, .1, .1, .975)

				addon.API.Main:RegisterThemeUpdate(function()
					local TEXTURE_Background

					if addon.Theme.IsDarkTheme then
						TEXTURE_Background = addon.API.Presets.NINESLICE_INSCRIBED_FILLED_HIGHLIGHT
					else
						TEXTURE_Background = addon.API.Presets.NINESLICE_INSCRIBED_FILLED_HIGHLIGHT
					end

					Frame.BackgroundTexture:SetTexture(TEXTURE_Background)
				end, 5)
			end

			do -- CONTENT
				Frame.Content = CreateFrame("Frame", "$parent.Content", Frame)
				Frame.Content:SetSize(Frame:GetWidth() - 10, Frame:GetHeight())
				Frame.Content:SetPoint("CENTER", Frame)
				Frame.Content:SetFrameStrata("FULLSCREEN_DIALOG")
				Frame.Content:SetFrameLevel(101)

				Frame.TitleArea = CreateFrame("Frame", "$parent.TitleArea", Frame.Content)
				Frame.TitleArea:SetSize(Frame.Content:GetWidth(), Frame.Content:GetHeight() * .075)
				Frame.TitleArea:SetPoint("TOP", Frame.Content)
				Frame.TitleArea:SetFrameStrata("FULLSCREEN_DIALOG")
				Frame.TitleArea:SetFrameLevel(101)

				Frame.InputArea = CreateFrame("ScrollFrame", "$parent.InputArea", Frame.Content, "ScrollFrameTemplate")
				Frame.InputArea:SetSize(Frame.Content:GetWidth() - 25, Frame.Content:GetHeight() * .8)
				Frame.InputArea:SetPoint("TOPLEFT", Frame.Content, 0, -Frame.TitleArea:GetHeight())
				Frame.InputArea:SetFrameStrata("FULLSCREEN_DIALOG")
				Frame.InputArea:SetFrameLevel(101)
				Frame.InputArea.ScrollBar:Hide()

				Frame.ButtonArea = CreateFrame("Frame", "$parent.ButtonArea", Frame.Content)
				Frame.ButtonArea:SetSize(Frame.Content:GetWidth(), Frame.Content:GetHeight() * .125)
				Frame.ButtonArea:SetPoint("TOP", Frame.Content, 0, -Frame.TitleArea:GetHeight() - Frame.InputArea:GetHeight())
				Frame.ButtonArea:SetFrameStrata("FULLSCREEN_DIALOG")
				Frame.ButtonArea:SetFrameLevel(101)

				--------------------------------

				do -- TITLE
					do -- TEXT
						Frame.TitleArea.Title = addon.API.FrameTemplates:CreateText(Frame.TitleArea, addon.Theme.RGB_WHITE, 15, "LEFT", "MIDDLE", addon.API.Fonts.CONTENT_LIGHT, "$parent.Title")
						Frame.TitleArea.Title:SetSize(Frame.TitleArea:GetWidth(), Frame.TitleArea:GetHeight())
						Frame.TitleArea.Title:SetPoint("CENTER", Frame.TitleArea)
					end

					do -- BUTTONS
						do -- CLOSE
							Frame.TitleArea.CloseButton = addon.API.FrameTemplates:CreateCustomButton(Frame.TitleArea, 25, 25, "FULLSCREEN_DIALOG", {
								defaultTexture = NS.Variables.NINESLICE_HEAVY,
								highlightTexture = NS.Variables.NINESLICE_HIGHLIGHT,
								edgeSize = 25,
								scale = 1,
								theme = 2,
								playAnimation = false,
								customColor = nil,
								customHighlightColor = nil,
								customActiveColor = nil,
							}, "$parent.CloseButton")
							Frame.TitleArea.CloseButton:SetPoint("RIGHT", Frame.TitleArea)

							Frame.TitleArea.CloseButton:SetScript("OnClick", function()
								addon.PromptText.Script:HideTextFrame()
							end)

							---------------------------------

							do -- IMAGE
								Frame.TitleArea.CloseButton.Image, Frame.TitleArea.CloseButton.ImageTexture = addon.API.FrameTemplates:CreateTexture(Frame.TitleArea.CloseButton, "FULLSCREEN_DIALOG", addon.Variables.PATH_ART .. "Elements/Elements/close.png", "$parent.Image")
								Frame.TitleArea.CloseButton.Image:SetSize(Frame.TitleArea.CloseButton:GetWidth() - 10, Frame.TitleArea.CloseButton:GetHeight() - 10)
								Frame.TitleArea.CloseButton.Image:SetPoint("CENTER", Frame.TitleArea.CloseButton)
								Frame.TitleArea.CloseButton.Image:SetAlpha(.5)
							end
						end
					end
				end

				do -- INPUT BOX
					Frame.InputArea.InputBox = CreateFrame("EditBox", "$parent.InputBox", Frame.InputArea)
					Frame.InputArea.InputBox:SetSize(Frame.InputArea:GetWidth(), Frame.InputArea:GetHeight())
					Frame.InputArea.InputBox:SetPoint("TOP", Frame.InputArea)
					Frame.InputArea.InputBox:SetFont(addon.API.Fonts.CONTENT_LIGHT, 12.5, "")
					Frame.InputArea.InputBox:SetTextColor(addon.Theme.RGB_WHITE.r, addon.Theme.RGB_WHITE.g, addon.Theme.RGB_WHITE.b)
					Frame.InputArea.InputBox:SetMultiLine(true)
					Frame.InputArea.InputBox:SetAutoFocus(false)
					Frame.InputArea.InputBox:SetJustifyH("LEFT")
					Frame.InputArea.InputBox:SetJustifyV("TOP")
					Frame.InputArea.InputBox:SetAlpha(.75)
					Frame.InputArea.InputBox:SetFrameStrata("FULLSCREEN_DIALOG")
					Frame.InputArea.InputBox:SetFrameLevel(102)

					--------------------------------

					do -- HINT
						Frame.InputArea.InputBox.Hint = addon.API.FrameTemplates:CreateText(Frame.InputArea.InputBox, addon.Theme.RGB_WHITE, 12.5, "LEFT", "TOP", addon.API.Fonts.CONTENT_LIGHT, "$parent.Hint")
						Frame.InputArea.InputBox.Hint:SetSize(Frame.InputArea.InputBox:GetSize())
						Frame.InputArea.InputBox.Hint:SetPoint("TOP", Frame.InputArea.InputBox)
						Frame.InputArea.InputBox.Hint:SetAlpha(.75)
					end

					do -- SCROLL BAR
						Frame.InputArea.Scrollbar = addon.API.FrameTemplates:CreateScrollbar(Frame.InputArea, "FULLSCREEN_DIALOG", Frame.InputArea:GetFrameLevel() + 9, {
							scrollFrame = Frame.InputArea,
							scrollChildFrame = Frame.InputArea.InputBox,
							sizeX = 5,
							sizeY = Frame.InputArea:GetHeight(),
							theme = 2,
							isHorizontal = false,
						}, "$parent.Scrollbar")
						Frame.InputArea.Scrollbar:SetPoint("RIGHT", Frame.InputArea, 15, 0)
						Frame.InputArea.ScrollBar:SetFrameStrata("FULLSCREEN_DIALOG")
						Frame.InputArea.Scrollbar:SetFrameLevel(102)
					end

					--------------------------------

					do -- EVENTS
						Frame.InputArea.InputBox:SetScript("OnEscapePressed", function(self)
							self:ClearFocus()
						end)

						Frame.InputArea.InputBox:SetScript("OnEnterPressed", function()
							if Frame.ButtonArea.Button1:IsVisible() then
								Frame.ButtonArea.Button1:Click()
							end
						end)

						Frame.InputArea.InputBox:SetScript("OnTextChanged", function()
							if Frame.InputArea.InputBox:GetText() == nil or Frame.InputArea.InputBox:GetText() == "" then
								Frame.InputArea.InputBox.Hint:SetAlpha(.75)
							else
								Frame.InputArea.InputBox.Hint:SetAlpha(0)
							end
						end)
					end

					--------------------------------

					Frame.InputArea:SetScrollChild(Frame.InputArea.InputBox)
				end

				do -- BUTTONS
					do -- BUTTON 1
						Frame.ButtonArea.Button1 = addon.API.FrameTemplates:CreateCustomButton(Frame.ButtonArea, Frame.ButtonArea:GetWidth() - PADDING, Frame.ButtonArea:GetHeight() / 2, "FULLSCREEN_DIALOG", {
							defaultTexture = nil,
							highlightTexture = nil,
							edgeSize = 25,
							scale = .25,
							theme = 2,
							playAnimation = false,
							customColor = nil,
							customHighlightColor = nil,
							customActiveColor = nil,
						}, "$parent.Button1")
						Frame.ButtonArea.Button1:SetPoint("LEFT", Frame.ButtonArea, PADDING / 2, 0)
					end
				end
			end
		end
	end

	--------------------------------
	-- REFERENCES
	--------------------------------

	local Frame = InteractionTextPromptFrame
	local Callback = NS.Script; NS.Script = Callback

	--------------------------------
	-- SETUP
	--------------------------------

	do
		Frame:Hide()
		Frame.hidden = true
	end
end
