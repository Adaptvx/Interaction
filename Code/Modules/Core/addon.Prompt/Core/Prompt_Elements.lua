local addonName, addon = ...
local CallbackRegistry = addon.CallbackRegistry
local L = addon.Locales
local NS = addon.Prompt

--------------------------------

NS.Elements = {}

--------------------------------

function NS.Elements:Load()
	--------------------------------
	-- CREATE ELEMENTS
	--------------------------------

	do
		do -- CREATE ELEMENTS
			InteractionPromptFrame = CreateFrame("Frame", "$parent.InteractionPromptFrame", InteractionFrame)
			InteractionPromptFrame:SetSize(350, 55)
			InteractionPromptFrame:SetPoint("TOP", UIParent, 0, -35)
			InteractionPromptFrame:SetFrameStrata("FULLSCREEN_DIALOG")
			InteractionPromptFrame:SetFrameLevel(51)

			local Frame = InteractionPromptFrame

			--------------------------------

			do -- BACKDROP
				Frame.Backdrop, Frame.BackdropTexture = AdaptiveAPI.FrameTemplates:CreateTexture(Frame, "FULLSCREEN_DIALOG", addon.Variables.PATH .. "Art/Settings/background-backdrop.png", "$parent.backdrop.png")
				Frame.Backdrop:SetSize(500, 500)
				Frame.Backdrop:SetPoint("CENTER", Frame)
				Frame.Backdrop:SetFrameStrata("FULLSCREEN_DIALOG")
				Frame.Backdrop:SetFrameLevel(49)
				Frame.Backdrop:SetAlpha(.5)
			end

			do -- BACKGROUND
				Frame.Background, Frame.BackgroundTexture = AdaptiveAPI.FrameTemplates:CreateNineSlice(Frame, "FULLSCREEN_DIALOG", nil, 128, .575, "$parent.Background")
				Frame.Background:SetPoint("CENTER", Frame)
				Frame.Background:SetFrameStrata("FULLSCREEN_DIALOG")
				Frame.Background:SetFrameLevel(50)

				addon.API:RegisterThemeUpdate(function()
					local TEXTURE_Background

					if addon.Theme.IsDarkTheme then
						TEXTURE_Background = AdaptiveAPI.Presets.NINESLICE_STYLISED_SCROLL_02
					else
						TEXTURE_Background = AdaptiveAPI.Presets.NINESLICE_STYLISED_SCROLL
					end

					Frame.BackgroundTexture:SetTexture(TEXTURE_Background)
				end, 5)
			end

			do -- CONTENT
				Frame.Content = CreateFrame("Frame", "$parent.Content", Frame)
				Frame.Content:SetSize(Frame:GetWidth(), Frame:GetHeight())
				Frame.Content:SetPoint("CENTER", Frame)

				Frame.Content.TextArea = CreateFrame("Frame", "$parent.TextArea", Frame.Content)
				Frame.Content.TextArea:SetSize(Frame.Content:GetWidth(), 1000)
				Frame.Content.TextArea:SetPoint("TOP", Frame.Content)

				Frame.Content.ButtonArea = CreateFrame("Frame", "$parent.ButtonArea", Frame.Content)
				Frame.Content.ButtonArea:SetSize(Frame.Content:GetWidth(), NS.Variables.BUTTON_HEIGHT)
				Frame.Content.ButtonArea:SetPoint("BOTTOM", Frame.ClearPoint)

				--------------------------------

				do -- TEXT
					Frame.Content.TextArea.Text = AdaptiveAPI.FrameTemplates:CreateText(Frame.Content.TextArea, addon.Theme.RGB_RECOMMENDED, 15, "CENTER", "MIDDLE", AdaptiveAPI.Fonts.Content_Light, "$parent.Text")
					Frame.Content.TextArea.Text:SetAllPoints(Frame.Content.TextArea)
				end

				do -- BUTTONS
					do -- BUTTON 1
						Frame.Content.ButtonArea.Button1 = AdaptiveAPI.FrameTemplates:CreateCustomButton(Frame.Content.ButtonArea, Frame.Content.ButtonArea:GetWidth() / 2 - NS.Variables.PADDING, NS.Variables.BUTTON_HEIGHT, "FULLSCREEN_DIALOG", {
							defaultTexture = nil,
							highlightTexture = nil,
							edgeSize = nil,
							scale = .25,
							theme = nil,
							playAnimation = false,
							customColor = nil,
							customHighlightColor = nil,
							customActiveColor = nil,
						}, "$parent.Content.TextArea.Button1")
						Frame.Content.ButtonArea.Button1:SetPoint("LEFT", Frame.Content.ButtonArea, 0, 0)
						addon.SoundEffects:SetButton(Frame.Content.ButtonArea.Button1, addon.SoundEffects.Prompt_Button_Enter, addon.SoundEffects.Prompt_Button_Leave, addon.SoundEffects.Prompt_Button_MouseDown, addon.SoundEffects.Prompt_Button_MouseUp)
					end

					do -- BUTTON 2
						Frame.Content.ButtonArea.Button2 = AdaptiveAPI.FrameTemplates:CreateCustomButton(Frame.Content.ButtonArea, Frame.Content.ButtonArea:GetWidth() / 2 - NS.Variables.PADDING, NS.Variables.BUTTON_HEIGHT, "FULLSCREEN_DIALOG", {
							defaultTexture = nil,
							highlightTexture = nil,
							edgeSize = nil,
							scale = .25,
							theme = nil,
							playAnimation = false,
							customColor = nil,
							customHighlightColor = nil,
							customActiveColor = nil,
						}, "$parent.Content.TextArea.Button2")
						Frame.Content.ButtonArea.Button2:SetPoint("LEFT", Frame.Content.ButtonArea, Frame.Content.ButtonArea:GetWidth() / 2 + NS.Variables.PADDING, 0)
						addon.SoundEffects:SetButton(Frame.Content.ButtonArea.Button2, addon.SoundEffects.Prompt_Button_Enter, addon.SoundEffects.Prompt_Button_Leave, addon.SoundEffects.Prompt_Button_MouseDown, addon.SoundEffects.Prompt_Button_MouseUp)
					end
				end
			end

			--------------------------------

			do -- EVENTS
				local function UpdateLayout()
					local _, textHeight = AdaptiveAPI:GetStringSize(Frame.Content.TextArea.Text)

					local textAreaHeight = textHeight
					local buttonAreaHeight = NS.Variables.BUTTON_HEIGHT

					--------------------------------

					Frame:SetHeight(NS.Variables.PADDING + textAreaHeight + buttonAreaHeight + NS.Variables.PADDING)
					Frame.Background:SetSize(Frame:GetWidth() + NS.Variables:RATIO(4), Frame:GetHeight() + NS.Variables:RATIO(4))

					Frame.Content:SetSize(Frame:GetSize())
					Frame.Content.TextArea:SetSize(Frame.Content:GetWidth(), textAreaHeight)
					Frame.Content.ButtonArea:SetSize(Frame.Content:GetWidth(), NS.Variables.BUTTON_HEIGHT)
					Frame.Content.TextArea.Text:SetSize(Frame.Content.TextArea:GetWidth(), Frame.Content.TextArea:GetHeight())
				end

				CallbackRegistry:Add("START_PROMPT", UpdateLayout, 0)
			end
		end
	end

	--------------------------------
	-- SETUP
	--------------------------------

	InteractionPromptFrame:Hide()
	InteractionPromptFrame.hidden = true
end
