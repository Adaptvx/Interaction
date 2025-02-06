local addonName, addon = ...
local CallbackRegistry = addon.CallbackRegistry
local L = addon.Locales
local NS = addon.Audiobook

--------------------------------

NS.Elements = {}

--------------------------------

function NS.Elements:Load()
	--------------------------------
	-- CREATE ELEMENTS
	--------------------------------

	do
		do -- CREATE ELEMENTS
			InteractionAudiobookFrame = CreateFrame("Frame", "$parent.InteractionAudiobookFrame", InteractionFrame)
			InteractionAudiobookFrame:SetSize(NS.Variables.FRAME_WIDTH, NS.Variables.FRAME_HEIGHT)
			InteractionAudiobookFrame:SetPoint("TOP", UIParent, 0, -25)
			InteractionAudiobookFrame:SetFrameStrata("FULLSCREEN")
			InteractionAudiobookFrame:SetFrameLevel(50)

			InteractionAudiobookFrame:SetMovable(true)

			--------------------------------

			local Frame = InteractionAudiobookFrame

			--------------------------------

			do -- ELEMENTS
				local PADDING = NS.Variables:RATIO(2.25)

				--------------------------------

				do -- MOUSE RESPONDER
					Frame.MouseResponder = CreateFrame("Frame", "$parent.MouseResponder", Frame)
					Frame.MouseResponder:SetAllPoints(Frame, true)
					Frame.MouseResponder:SetFrameStrata("FULLSCREEN")
					Frame.MouseResponder:SetFrameLevel(51)
				end

				do -- BACKGROUND
					Frame.Background, Frame.BackgroundTexture = AdaptiveAPI.FrameTemplates:CreateNineSlice(Frame, "FULLSCREEN", NS.Variables.AUDIOBOOKUI_PATH .. "background.png", 32, 2.5, "$parent.Background")
					Frame.Background:SetSize(Frame:GetWidth() + 125, Frame:GetHeight() + 125)
					Frame.Background:SetPoint("CENTER", Frame)
					Frame.Background:SetFrameStrata("FULLSCREEN")
					Frame.Background:SetFrameLevel(49)
					Frame.BackgroundTexture:SetAlpha(.75)
				end

				do -- CONTENT
					Frame.Content = CreateFrame("Frame", "$parent.Content", Frame)
					Frame.Content:SetSize(Frame:GetSize())
					Frame.Content:SetPoint("CENTER", Frame)
					Frame.Content:SetFrameStrata("FULLSCREEN")
					Frame.Content:SetFrameLevel(52)

					--------------------------------

					do -- PLAYBACK BUTTON
						Frame.Content.PlaybackButton = CreateFrame("Frame", "$parent.PlaybackButton", Frame.Content)
						Frame.Content.PlaybackButton:SetSize(Frame.Content:GetHeight(), Frame.Content:GetHeight())
						Frame.Content.PlaybackButton:SetPoint("LEFT", Frame.Content)
						Frame.Content.PlaybackButton:SetFrameStrata("FULLSCREEN")
						Frame.Content.PlaybackButton:SetFrameLevel(53)

						AdaptiveAPI:AnchorToCenter(Frame.Content.PlaybackButton)

						--------------------------------

						do -- BACKGROUND
							Frame.Content.PlaybackButton.Background, Frame.Content.PlaybackButton.BackgroundTexture = AdaptiveAPI.FrameTemplates:CreateTexture(Frame.Content.PlaybackButton, "FULLSCREEN", NS.Variables.AUDIOBOOKUI_PATH .. "button-playback-background.png", "$parent.Background")
							Frame.Content.PlaybackButton.Background:SetPoint("TOPLEFT", Frame.Content.PlaybackButton, -5, 5)
							Frame.Content.PlaybackButton.Background:SetPoint("BOTTOMRIGHT", Frame.Content.PlaybackButton, 5, -5)
							Frame.Content.PlaybackButton.Background:SetFrameStrata("FULLSCREEN")
							Frame.Content.PlaybackButton.Background:SetFrameLevel(52)
						end

						do -- IMAGE
							local IMAGE_PADDING = NS.Variables:RATIO(2.25)

							Frame.Content.PlaybackButton.Image, Frame.Content.PlaybackButton.ImageTexture = AdaptiveAPI.FrameTemplates:CreateTexture(Frame.Content.PlaybackButton, "FULLSCREEN", NS.Variables.AUDIOBOOKUI_PATH .. "button-playback-play.png", "$parent.Image")
							Frame.Content.PlaybackButton.Image:SetPoint("TOPLEFT", Frame.Content.PlaybackButton, IMAGE_PADDING, -IMAGE_PADDING)
							Frame.Content.PlaybackButton.Image:SetPoint("BOTTOMRIGHT", Frame.Content.PlaybackButton, -IMAGE_PADDING, IMAGE_PADDING)
							Frame.Content.PlaybackButton.Image:SetFrameStrata("FULLSCREEN")
							Frame.Content.PlaybackButton.Image:SetFrameLevel(54)
						end

						do -- CLICK EVENTS
							Frame.Content.PlaybackButton.Enter = function()
								Frame.Content.PlaybackButton.isMouseOver = true

								--------------------------------

								Frame.Content.PlaybackButton.BackgroundTexture:SetTexture(NS.Variables.AUDIOBOOKUI_PATH .. "button-playback-background-highlighted.png")
							end

							Frame.Content.PlaybackButton.Leave = function()
								Frame.Content.PlaybackButton.isMouseOver = false

								--------------------------------

								Frame.Content.PlaybackButton.BackgroundTexture:SetTexture(NS.Variables.AUDIOBOOKUI_PATH .. "button-playback-background.png")
							end

							Frame.Content.PlaybackButton.MouseDown = function()
								Frame.Content.PlaybackButton.isMouseDown = true

								--------------------------------

								Frame.Content.PlaybackButton:SetAlpha(.75)
								AdaptiveAPI.Animation:Scale(Frame.Content.PlaybackButton, .25, Frame.Content.PlaybackButton:GetScale(), .875, nil, nil, function() return not Frame.Content.PlaybackButton.isMouseDown end)
							end

							Frame.Content.PlaybackButton.MouseUp = function()
								Frame.Content.PlaybackButton.isMouseDown = false

								--------------------------------

								Frame.Content.PlaybackButton:SetAlpha(1)
								AdaptiveAPI.Animation:Scale(Frame.Content.PlaybackButton, .075, Frame.Content.PlaybackButton:GetScale(), 1, nil, nil, function() return Frame.Content.PlaybackButton.isMouseDown end)
							end

							Frame.Content.PlaybackButton:SetScript("OnEnter", Frame.Content.PlaybackButton.Enter)
							Frame.Content.PlaybackButton:SetScript("OnLeave", Frame.Content.PlaybackButton.Leave)
							Frame.Content.PlaybackButton:SetScript("OnMouseDown", Frame.Content.PlaybackButton.MouseDown)
							Frame.Content.PlaybackButton:SetScript("OnMouseUp", Frame.Content.PlaybackButton.MouseUp)
						end
					end

					do -- SLIDER
						Frame.Content.Slider = CreateFrame("Slider", nil, Frame.Content, "MinimalSliderTemplate")
						Frame.Content.Slider:SetSize(Frame.Content:GetWidth() * .75, 20)
						Frame.Content.Slider:SetPoint("BOTTOMLEFT", Frame.Content, Frame.Content.PlaybackButton:GetWidth() + (PADDING / 2), (PADDING * .25))
						Frame.Content.Slider:SetFrameStrata("FULLSCREEN")
						Frame.Content.Slider:SetFrameLevel(53)
						Frame.Content.Slider:SetMinMaxValues(1, 10)
						Frame.Content.Slider:SetValueStep(1)

						--------------------------------

						do -- STYLE
							local COLOR_Default = { r = 1, g = 1, b = 1, a = .25 }
							local COLOR_Thumb = { r = 1, g = 1, b = 1, a = 1 }

							AdaptiveAPI.FrameTemplates.Styles:Slider(Frame.Content.Slider, {
								customColor = COLOR_Default,
								customThumbColor = COLOR_Thumb,
								grid = false
							})
						end
					end

					do -- TEXT
						Frame.Content.Text = CreateFrame("Frame", "$parent.Text", Frame.Content)
						Frame.Content.Text:SetSize(Frame.Content.Slider:GetWidth(), 25)
						Frame.Content.Text:SetPoint("TOP", Frame.Content.Slider, 0, (PADDING))
						Frame.Content.Text:SetFrameStrata("FULLSCREEN")
						Frame.Content.Text:SetFrameLevel(53)

						--------------------------------

						do -- INDEX
							Frame.Content.Text.Index = CreateFrame("Frame", "$parent.Index", Frame.Content.Text)
							Frame.Content.Text.Index:SetHeight(Frame.Content.Text:GetHeight())
							Frame.Content.Text.Index:SetPoint("RIGHT", Frame.Content.Text)
							Frame.Content.Text.Index:SetFrameStrata("FULLSCREEN")
							Frame.Content.Text.Index:SetFrameLevel(54)

							--------------------------------

							do -- BACKGROUND
								Frame.Content.Text.Index.Background, Frame.Content.Text.Index.BackgroundTexture = AdaptiveAPI.FrameTemplates:CreateNineSlice(Frame.Content.Text.Index, "FULLSCREEN", AdaptiveAPI.Presets.NINESLICE_INSCRIBED, 64, .5, "$parent.Background")
								Frame.Content.Text.Index.Background:SetAllPoints(Frame.Content.Text.Index, true)
								Frame.Content.Text.Index.BackgroundTexture:SetVertexColor(1, 1, 1, .125)
								Frame.Content.Text.Index.Background:SetFrameStrata("FULLSCREEN")
								Frame.Content.Text.Index.Background:SetFrameLevel(53)
							end

							do -- TEXT
								Frame.Content.Text.Index.Text = AdaptiveAPI.FrameTemplates:CreateText(Frame.Content.Text.Index, addon.Theme.RGB_WHITE, 15, "CENTER", "MIDDLE", AdaptiveAPI.Fonts.Content_Light, "$parent.Text")
								Frame.Content.Text.Index.Text:SetAllPoints(Frame.Content.Text.Index, true)
							end
						end

						do -- TITLE
							Frame.Content.Text.Title = AdaptiveAPI.FrameTemplates:CreateText(Frame.Content.Text, addon.Theme.RGB_WHITE, 15, "LEFT", "MIDDLE", AdaptiveAPI.Fonts.Content_Light, "$parent.Title")
							Frame.Content.Text.Title:SetHeight(Frame.Content.Text:GetHeight())
							Frame.Content.Text.Title:SetPoint("LEFT", Frame.Content.Text, 0, 0)
						end

						do -- EVENTS
							local function UpdateSize()
								Frame.Content.Text.Index.Text:SetWidth(1000)

								---------------------------------

								local stringWidth, stringHeight = AdaptiveAPI:GetStringSize(Frame.Content.Text.Index.Text, nil, nil)
								local width = (PADDING / 2) + stringWidth + (PADDING / 2)

								---------------------------------

								Frame.Content.Text.Title:SetWidth(Frame.Content.Text:GetWidth() - width - PADDING)
								Frame.Content.Text.Index:SetWidth(width)
							end
							UpdateSize()

							hooksecurefunc(Frame.Content.Text.Index.Text, "SetText", UpdateSize)
						end
					end
				end

				do -- TEXT PREVIEW
					Frame.TextPreviewFrame = CreateFrame("Frame", "$parent.TextPreviewFrame", Frame.Content)
					Frame.TextPreviewFrame:SetPoint("TOP", Frame, 0, -Frame:GetHeight() - (PADDING * 2))
					Frame.TextPreviewFrame:SetFrameStrata("FULLSCREEN")
					Frame.TextPreviewFrame:SetFrameLevel(51)

					--------------------------------

					do -- BACKGROUND
						Frame.TextPreviewFrame.Background, Frame.TextPreviewFrame.BackgroundTexture = AdaptiveAPI.FrameTemplates:CreateNineSlice(Frame.TextPreviewFrame, "FULLSCREEN", NS.Variables.AUDIOBOOKUI_PATH .. "background.png", 32, 1, "$parent.Background")
						Frame.TextPreviewFrame.Background:SetPoint("TOPLEFT", Frame.TextPreviewFrame, -35, 35)
						Frame.TextPreviewFrame.Background:SetPoint("BOTTOMRIGHT", Frame.TextPreviewFrame, 35, -35)
						Frame.TextPreviewFrame.Background:SetFrameStrata("FULLSCREEN")
						Frame.TextPreviewFrame.Background:SetFrameLevel(50)
						Frame.TextPreviewFrame.BackgroundTexture:SetAlpha(.5)
					end

					do -- CONTENT
						Frame.TextPreviewFrame.Content = CreateFrame("Frame", "$parent.Content", Frame.TextPreviewFrame)
						Frame.TextPreviewFrame.Content:SetAllPoints(Frame.TextPreviewFrame, true)
						Frame.TextPreviewFrame.Content:SetFrameStrata("FULLSCREEN")
						Frame.TextPreviewFrame.Content:SetFrameLevel(51)
						Frame.TextPreviewFrame.Content:SetClipsChildren(true)

						--------------------------------

						do -- TEXT
							Frame.TextPreviewFrame.Content.Text = AdaptiveAPI.FrameTemplates:CreateText(Frame.TextPreviewFrame.Content, addon.Theme.RGB_CHAT_MSG_SAY, 12.5, "LEFT", "TOP", AdaptiveAPI.Fonts.Content_Light, "$parent.Text")
							Frame.TextPreviewFrame.Content.Text:SetSize(Frame.TextPreviewFrame.Content:GetSize())
							Frame.TextPreviewFrame.Content.Text:SetPoint("CENTER", Frame.TextPreviewFrame.Content)

							--------------------------------

							do -- EVENTS
								local function UpdateSize()
									Frame.TextPreviewFrame.Content.Text:SetSize(Frame.TextPreviewFrame.Content:GetSize())
								end

								hooksecurefunc(Frame.TextPreviewFrame, "SetSize", UpdateSize)
								hooksecurefunc(Frame.TextPreviewFrame, "SetWidth", UpdateSize)
								hooksecurefunc(Frame.TextPreviewFrame, "SetHeight", UpdateSize)
							end
						end
					end

					do -- EVENTS
						local function UpdateSize()
							local maxWidth = Frame.Content:GetWidth() * .75
							local stringWidth, stringHeight = AdaptiveAPI:GetStringSize(Frame.TextPreviewFrame.Content.Text, maxWidth, nil)

							--------------------------------

							Frame.TextPreviewFrame:SetSize(stringWidth + 1, stringHeight + 1) -- to account for trunacted y axis text.

							--------------------------------

							if Frame.TextPreviewFrame.NewTextAnimation then
								Frame.TextPreviewFrame.NewTextAnimation()
							end
						end

						hooksecurefunc(Frame.TextPreviewFrame.Content.Text, "SetText", UpdateSize)
					end
				end
			end

			do -- CLICK EVENTS
				Frame.Animation_DragStart = function()
					AdaptiveAPI.Animation:Fade(Frame.Content, .075, Frame.Content:GetAlpha(), 0, nil, function() return not Frame.moving or Frame.hidden end)
					AdaptiveAPI.Animation:Scale(Frame.Background, .25, Frame.Background:GetScale(), .875, nil, AdaptiveAPI.Animation.EaseSine, function() return not Frame.moving or Frame.hidden end)
				end

				Frame.Animation_DragStop = function()
					AdaptiveAPI.Animation:Fade(Frame.Content, .075, Frame.Content:GetAlpha(), 1, nil, function() return Frame.moving or Frame.hidden end)
					AdaptiveAPI.Animation:Scale(Frame.Background, .25, Frame.Background:GetScale(), 1, nil, AdaptiveAPI.Animation.EaseExpo, function() return Frame.moving or Frame.hidden end)
				end

				Frame.Animation_CloseStart = function()
					AdaptiveAPI.Animation:Fade(Frame.Content, .075, Frame.Content:GetAlpha(), 0, nil, function() return Frame.moving or Frame.hidden end)
					AdaptiveAPI.Animation:Scale(Frame.Background, .25, Frame.Background:GetScale(), 1.05, nil, AdaptiveAPI.Animation.EaseSine, function() return Frame.moving or Frame.hidden end)
				end

				Frame.Animation_CloseStop = function()
					Frame.Content:SetAlpha(0)
					Frame.Background:SetScale(1)
				end

				Frame.MouseResponder:SetScript("OnMouseDown", function(_, button)
					if button == "LeftButton" then
						Frame.moving = true
						Frame:StartMoving(true)

						--------------------------------

						Frame.Animation_DragStart()
					end

					if button == "RightButton" then
						Frame.Animation_CloseStart()
					end
				end)

				Frame.MouseResponder:SetScript("OnMouseUp", function(_, button)
					if button == "LeftButton" then
						Frame.moving = false
						Frame:StopMovingOrSizing()

						--------------------------------

						Frame.Animation_DragStop()
					end

					if button == "RightButton" then
						Frame.Animation_CloseStop()
					end
				end)
			end
		end
	end

	--------------------------------
	-- REFERENCES
	--------------------------------

	local Frame = InteractionAudiobookFrame
	local Callback = NS.Script

	--------------------------------
	-- SETUP
	--------------------------------

	do
		Frame.hidden = true
		Frame:Hide()

		Frame.TextPreviewFrame.hidden = true
		Frame.TextPreviewFrame:Hide()
	end
end
