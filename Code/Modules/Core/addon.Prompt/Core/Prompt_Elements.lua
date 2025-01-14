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

			--------------------------------

			do -- BACKDROP
				InteractionPromptFrame.Backdrop, InteractionPromptFrame.BackdropTexture = AdaptiveAPI.FrameTemplates:CreateTexture(InteractionPromptFrame, "FULLSCREEN_DIALOG", addon.Variables.PATH .. "Art/Settings/background-backdrop.png", "$parent.backdrop.png")
				InteractionPromptFrame.Backdrop:SetSize(500, 500)
				InteractionPromptFrame.Backdrop:SetPoint("CENTER", InteractionPromptFrame)
				InteractionPromptFrame.Backdrop:SetFrameStrata("FULLSCREEN_DIALOG")
				InteractionPromptFrame.Backdrop:SetFrameLevel(49)
				InteractionPromptFrame.Backdrop:SetAlpha(.5)
			end

			do -- BACKGROUND
				InteractionPromptFrame.Background, InteractionPromptFrame.BackgroundTexture = AdaptiveAPI.FrameTemplates:CreateNineSlice(InteractionPromptFrame, "FULLSCREEN_DIALOG", nil, 128, .575, "$parent.Background")
				InteractionPromptFrame.Background:SetPoint("CENTER", InteractionPromptFrame)
				InteractionPromptFrame.Background:SetFrameStrata("FULLSCREEN_DIALOG")
				InteractionPromptFrame.Background:SetFrameLevel(50)

				addon.API:RegisterThemeUpdate(function()
					local TEXTURE_Background

					if addon.Theme.IsDarkTheme then
						TEXTURE_Background = AdaptiveAPI.Presets.NINESLICE_STYLISED_SCROLL_02
					else
						TEXTURE_Background = AdaptiveAPI.Presets.NINESLICE_STYLISED_SCROLL
					end

					InteractionPromptFrame.BackgroundTexture:SetTexture(TEXTURE_Background)
				end, 5)
			end

			do -- CONTENT
				InteractionPromptFrame.Content = CreateFrame("Frame", "$parent.Content", InteractionPromptFrame)
				InteractionPromptFrame.Content:SetSize(InteractionPromptFrame:GetWidth(), InteractionPromptFrame:GetHeight())
				InteractionPromptFrame.Content:SetPoint("CENTER", InteractionPromptFrame)

				InteractionPromptFrame.Content.TextArea = CreateFrame("Frame", "$parent.TextArea", InteractionPromptFrame.Content)
				InteractionPromptFrame.Content.TextArea:SetSize(InteractionPromptFrame.Content:GetWidth(), 1000)
				InteractionPromptFrame.Content.TextArea:SetPoint("TOP", InteractionPromptFrame.Content)

				InteractionPromptFrame.Content.ButtonArea = CreateFrame("Frame", "$parent.ButtonArea", InteractionPromptFrame.Content)
				InteractionPromptFrame.Content.ButtonArea:SetSize(InteractionPromptFrame.Content:GetWidth(), NS.Variables.BUTTON_HEIGHT)
				InteractionPromptFrame.Content.ButtonArea:SetPoint("BOTTOM", InteractionPromptFrame.ClearPoint)

				--------------------------------

				do -- TEXT
					InteractionPromptFrame.Content.TextArea.Text = AdaptiveAPI.FrameTemplates:CreateText(InteractionPromptFrame.Content.TextArea, addon.Theme.RGB_RECOMMENDED, 15, "CENTER", "MIDDLE", AdaptiveAPI.Fonts.Content_Light, "$parent.Text")
					InteractionPromptFrame.Content.TextArea.Text:SetPoint("CENTER", InteractionPromptFrame.Content.TextArea)
				end

				do -- BUTTONS
					do -- BUTTON 1
						InteractionPromptFrame.Content.ButtonArea.Button1 = AdaptiveAPI.FrameTemplates:CreateCustomButton(InteractionPromptFrame.Content.ButtonArea, InteractionPromptFrame.Content.ButtonArea:GetWidth() / 2 - NS.Variables.PADDING, NS.Variables.BUTTON_HEIGHT, "FULLSCREEN_DIALOG", {
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
						InteractionPromptFrame.Content.ButtonArea.Button1:SetPoint("LEFT", InteractionPromptFrame.Content.ButtonArea, 0, 0)
						addon.SoundEffects:SetButton(InteractionPromptFrame.Content.ButtonArea.Button1, addon.SoundEffects.Prompt_Button_Enter, addon.SoundEffects.Prompt_Button_Leave, addon.SoundEffects.Prompt_Button_MouseDown, addon.SoundEffects.Prompt_Button_MouseUp)
					end

					do -- BUTTON 2
						InteractionPromptFrame.Content.ButtonArea.Button2 = AdaptiveAPI.FrameTemplates:CreateCustomButton(InteractionPromptFrame.Content.ButtonArea, InteractionPromptFrame.Content.ButtonArea:GetWidth() / 2 - NS.Variables.PADDING, NS.Variables.BUTTON_HEIGHT, "FULLSCREEN_DIALOG", {
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
						InteractionPromptFrame.Content.ButtonArea.Button2:SetPoint("LEFT", InteractionPromptFrame.Content.ButtonArea, InteractionPromptFrame.Content.ButtonArea:GetWidth() / 2 + NS.Variables.PADDING, 0)
						addon.SoundEffects:SetButton(InteractionPromptFrame.Content.ButtonArea.Button2, addon.SoundEffects.Prompt_Button_Enter, addon.SoundEffects.Prompt_Button_Leave, addon.SoundEffects.Prompt_Button_MouseDown, addon.SoundEffects.Prompt_Button_MouseUp)
					end
				end
			end

			--------------------------------

			do -- EVENTS
				local function UpdateLayout()
					InteractionPromptFrame.Content.TextArea.Text:SetHeight(1000)

					local textHeight = InteractionPromptFrame.Content.TextArea.Text:GetStringHeight()
					local buttonAreaHeight = NS.Variables.BUTTON_HEIGHT

					InteractionPromptFrame:SetHeight(NS.Variables.PADDING + textHeight + buttonAreaHeight + NS.Variables.PADDING)
					InteractionPromptFrame.Background:SetSize(InteractionPromptFrame:GetWidth() + NS.Variables:RATIO(4), InteractionPromptFrame:GetHeight() + NS.Variables:RATIO(4))

					InteractionPromptFrame.Content:SetSize(InteractionPromptFrame:GetSize())
					InteractionPromptFrame.Content.TextArea:SetSize(InteractionPromptFrame.Content:GetWidth(), textHeight)
					InteractionPromptFrame.Content.ButtonArea:SetSize(InteractionPromptFrame.Content:GetWidth(), NS.Variables.BUTTON_HEIGHT)
					InteractionPromptFrame.Content.TextArea.Text:SetSize(InteractionPromptFrame.Content.TextArea:GetWidth(), InteractionPromptFrame.Content.TextArea:GetHeight())
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
