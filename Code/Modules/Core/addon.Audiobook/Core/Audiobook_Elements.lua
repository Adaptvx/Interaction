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
			InteractionAudiobookFrame:SetSize(350, 42.5)
			InteractionAudiobookFrame:SetPoint("TOP", UIParent, 0, -25)
			InteractionAudiobookFrame:SetFrameStrata("FULLSCREEN")
			InteractionAudiobookFrame:SetFrameLevel(50)

			--------------------------------

			local Frame = InteractionAudiobookFrame

			--------------------------------

			Frame:SetMovable(true)

			Frame:SetScript("OnMouseDown", function()
				Frame.moving = true
				Frame:StartMoving(true)

				--------------------------------

				Frame.Content.MainFrame.Right.Header.Title:SetAlphaGradient(1, 35)

				--------------------------------

				AdaptiveAPI.Animation:Fade(Frame, .125, Frame:GetAlpha(), .75, nil, function() return not Frame.moving end)
				AdaptiveAPI.Animation:Fade(Frame.Content, .25, Frame.Content:GetAlpha(), 0, nil, function() return not Frame.moving end)
				AdaptiveAPI.Animation:Scale(Frame.Content, .425, Frame.Content:GetScale(), 1.175, nil, AdaptiveAPI.Animation.EaseExpo, function() return not Frame.moving or Frame.hidden end)
				AdaptiveAPI.Animation:Scale(Frame.Background, .5, Frame.Background:GetScale(), 1.125, nil, AdaptiveAPI.Animation.EaseExpo, function() return not Frame.moving or Frame.hidden end)
			end)

			Frame:SetScript("OnMouseUp", function()
				Frame.moving = false
				Frame:StopMovingOrSizing()

				--------------------------------

				AdaptiveAPI.Animation:FadeText(Frame.Content.MainFrame.Right.Header.Title, .75, 35, 1, nil, function() return Frame.moving or Frame.hidden end)

				--------------------------------

				AdaptiveAPI.Animation:Fade(Frame, .125, Frame:GetAlpha(), 1, nil, function() return Frame.movin or Frame.hiddeng end)
				AdaptiveAPI.Animation:Fade(Frame.Content, .25, Frame.Content:GetAlpha(), 1, nil, function() return Frame.moving or Frame.hidden end)
				AdaptiveAPI.Animation:Scale(Frame.Content, .425, Frame.Content:GetScale(), 1, nil, AdaptiveAPI.Animation.EaseExpo, function() return Frame.moving or Frame.hidden end)
				AdaptiveAPI.Animation:Scale(Frame.Background, .5, Frame.Background:GetScale(), 1, nil, AdaptiveAPI.Animation.EaseExpo, function() return Frame.moving or Frame.hidden end)
			end)

			--------------------------------

			do -- BACKGROUND
				Frame.Background, Frame.BackgroundTexture = AdaptiveAPI.FrameTemplates:CreateTexture(Frame, "FULLSCREEN", NS.Variables.AUDIOBOOKUI_PATH .. "background.png", "$parent.Background")
				Frame.Background:SetSize(Frame:GetWidth(), Frame:GetHeight() + 25)
				Frame.Background:SetPoint("CENTER", Frame, -12.5, 0)
				Frame.Background:SetFrameStrata("FULLSCREEN")
				Frame.Background:SetFrameLevel(49)
			end

			do -- CONTENT
				Frame.Content = CreateFrame("Frame", "$parent.Content", Frame)
				Frame.Content:SetSize(Frame:GetSize())
				Frame.Content:SetPoint("CENTER", Frame)
				Frame.Content:SetFrameStrata("FULLSCREEN")
				Frame.Content:SetFrameLevel(50)

				local Box = Frame.Content:GetHeight()

				--------------------------------

				do -- CONTENT BUTTONS
					Frame.Content.ButtonFrame = CreateFrame("Frame", "$parent.ButtonFrame", Frame.Content)
					Frame.Content.ButtonFrame:SetSize(Box, Box)
					Frame.Content.ButtonFrame:SetPoint("LEFT", Frame.Content)
					Frame.Content.ButtonFrame:SetFrameStrata("FULLSCREEN")
					Frame.Content.ButtonFrame:SetFrameLevel(51)

					--------------------------------

					do -- PLAYBACK BUTTON
						Frame.Content.ButtonFrame.PlaybackButton = AdaptiveAPI.FrameTemplates:CreateCustomButton(Frame.Content.ButtonFrame, Box * .75, Box * .75, "FULLSCREEN", {
							defaultTexture = NS.Variables.NINESLICE_DEFAULT,
							highlightTexture = NS.Variables.NINESLICE_HIGHLIGHT,
							edgeSize = 25,
							scale = 1,
							theme = 2,
							playAnimation = false,
							customColor = nil,
							customHighlightColor = nil,
							customActiveColor = nil,
						}, "$parent.PlaybackButton")
						Frame.Content.ButtonFrame.PlaybackButton:SetPoint("CENTER", Frame.Content.ButtonFrame, 0, 0)
						Frame.Content.ButtonFrame.PlaybackButton:SetFrameStrata("FULLSCREEN")
						Frame.Content.ButtonFrame.PlaybackButton:SetFrameLevel(52)

						Frame.Content.ButtonFrame.PlaybackButton:SetScript("OnClick", function()
							NS.Script:TogglePlayback()
						end)

						--------------------------------

						do -- IMAGE
							Frame.Content.ButtonFrame.PlaybackButton.Image, Frame.Content.ButtonFrame.PlaybackButton.ImageTexture = AdaptiveAPI.FrameTemplates:CreateTexture(Frame.Content.ButtonFrame.PlaybackButton, "FULLSCREEN", nil, "$parent.Image")
							Frame.Content.ButtonFrame.PlaybackButton.Image:SetSize(Frame.Content.ButtonFrame.PlaybackButton:GetHeight() * .75, Frame.Content.ButtonFrame.PlaybackButton:GetHeight() * .75)
							Frame.Content.ButtonFrame.PlaybackButton.Image:SetPoint("CENTER", Frame.Content.ButtonFrame.PlaybackButton, 0, 0)
							Frame.Content.ButtonFrame.PlaybackButton.Image:SetFrameStrata("FULLSCREEN")
							Frame.Content.ButtonFrame.PlaybackButton.Image:SetFrameLevel(53)
						end
					end

					do -- DIVIDER
						Frame.Content.ButtonFrame.Divider, Frame.Content.ButtonFrame.DividerTexture = AdaptiveAPI.FrameTemplates:CreateTexture(Frame.Content.ButtonFrame, "FULLSCREEN", NS.Variables.AUDIOBOOKUI_PATH .. "seperator.png", "$parent.Divider")
						Frame.Content.ButtonFrame.Divider:SetSize(1, Box * .75)
						Frame.Content.ButtonFrame.Divider:SetPoint("RIGHT", Frame.Content.ButtonFrame)
						Frame.Content.ButtonFrame.Divider:SetFrameStrata("FULLSCREEN")
						Frame.Content.ButtonFrame.Divider:SetFrameLevel(52)
					end
				end

				do -- CONTENT MAIN
					Frame.Content.MainFrame = CreateFrame("Frame", "$parent.MainFrame", Frame.Content)
					Frame.Content.MainFrame:SetSize(Frame:GetWidth() - Box, Box)
					Frame.Content.MainFrame:SetPoint("LEFT", Frame.Content, Box, 0)
					Frame.Content.MainFrame:SetFrameStrata("FULLSCREEN")
					Frame.Content.MainFrame:SetFrameLevel(51)

					--------------------------------

					do -- LEFT
						Frame.Content.MainFrame.Left = CreateFrame("Frame", "$parent.Left", Frame.Content.MainFrame)
						Frame.Content.MainFrame.Left:SetSize(Box, Box)
						Frame.Content.MainFrame.Left:SetPoint("LEFT", Frame.Content.MainFrame)
						Frame.Content.MainFrame.Left:SetFrameStrata("FULLSCREEN")
						Frame.Content.MainFrame.Left:SetFrameLevel(52)

						--------------------------------

						do -- STATUS TEXT
							Frame.Content.MainFrame.Left.StatusText = AdaptiveAPI.FrameTemplates:CreateText(Frame.Content.MainFrame.Left, addon.Theme.RGB_WHITE, 12.5, "CENTER", "MIDDLE", AdaptiveAPI.Fonts.Title_Medium, "$parent.StatusText")
							Frame.Content.MainFrame.Left.StatusText:SetSize(Frame.Content.MainFrame.Left:GetSize())
							Frame.Content.MainFrame.Left.StatusText:SetPoint("CENTER", Frame.Content.MainFrame.Left)
							Frame.Content.MainFrame.Left.StatusText:SetAlpha(.5)
						end
					end

					do -- RIGHT
						Frame.Content.MainFrame.Right = CreateFrame("Frame", "$parent.Right", Frame.Content.MainFrame)
						Frame.Content.MainFrame.Right:SetSize(Frame.Content.MainFrame:GetWidth() - Box, Box)
						Frame.Content.MainFrame.Right:SetPoint("LEFT", Frame.Content.MainFrame, Box, 0)
						Frame.Content.MainFrame.Right:SetFrameStrata("FULLSCREEN")
						Frame.Content.MainFrame.Right:SetFrameLevel(52)

						local LocalBox = Frame.Content.MainFrame.Right:GetHeight()

						--------------------------------

						do -- HEADER
							Frame.Content.MainFrame.Right.Header = CreateFrame("Frame", "$parent.Header", Frame.Content.MainFrame.Right)
							Frame.Content.MainFrame.Right.Header:SetSize(Frame.Content.MainFrame.Right:GetWidth(), LocalBox / 2)
							Frame.Content.MainFrame.Right.Header:SetPoint("TOP", Frame.Content.MainFrame.Right, 0, 0)
							Frame.Content.MainFrame.Right.Header:SetFrameStrata("FULLSCREEN")
							Frame.Content.MainFrame.Right.Header:SetFrameLevel(53)

							local HeaderLocalBox = Frame.Content.MainFrame.Right.Header:GetHeight()

							--------------------------------

							do -- ICON
								Frame.Content.MainFrame.Right.Header.Icon, Frame.Content.MainFrame.Right.Header.IconTexture = AdaptiveAPI.FrameTemplates:CreateTexture(Frame.Content.MainFrame.Right.Header, "FULLSCREEN", NS.Variables.AUDIOBOOKUI_PATH .. "audio-speaker.png", "$parent.Icon")
								Frame.Content.MainFrame.Right.Header.Icon:SetSize(HeaderLocalBox * .75, HeaderLocalBox * .75)
								Frame.Content.MainFrame.Right.Header.Icon:SetPoint("LEFT", Frame.Content.MainFrame.Right.Header, 0, 0)
								Frame.Content.MainFrame.Right.Header.Icon:SetAlpha(.5)
								Frame.Content.MainFrame.Right.Header.Icon:SetFrameStrata("FULLSCREEN")
								Frame.Content.MainFrame.Right.Header.Icon:SetFrameLevel(54)
							end

							do -- TITLE
								Frame.Content.MainFrame.Right.Header.Title = AdaptiveAPI.FrameTemplates:CreateText(Frame.Content.MainFrame.Right.Header, addon.Theme.RGB_WHITE, 15, "LEFT", "MIDDLE", AdaptiveAPI.Fonts.Title_Bold, "$parent.Title")
								Frame.Content.MainFrame.Right.Header.Title:SetSize(Frame.Content.MainFrame.Right.Header:GetWidth() - Frame.Content.MainFrame.Right.Header.Icon:GetWidth() - 50, HeaderLocalBox)
								Frame.Content.MainFrame.Right.Header.Title:SetPoint("LEFT", Frame.Content.MainFrame.Right.Header, Frame.Content.MainFrame.Right.Header.Icon:GetWidth() + NS.Variables.PADDING, -1)
								Frame.Content.MainFrame.Right.Header.Title:SetAlpha(.5)
							end

							do -- CLOSE BUTTON
								Frame.Content.MainFrame.Right.Header.CloseButton = AdaptiveAPI.FrameTemplates:CreateCustomButton(Frame.Content.MainFrame.Right.Header, 25, 25, "FULLSCREEN", {
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
								Frame.Content.MainFrame.Right.Header.CloseButton:SetPoint("RIGHT", Frame.Content.MainFrame.Right.Header)
								Frame.Content.MainFrame.Right.Header.CloseButton:SetFrameStrata("FULLSCREEN")
								Frame.Content.MainFrame.Right.Header.CloseButton:SetFrameLevel(54)

								Frame.Content.MainFrame.Right.Header.CloseButton:SetScript("OnClick", function()
									NS.Script:Stop()
								end)

								--------------------------------

								do -- IMAGE
									Frame.Content.MainFrame.Right.Header.CloseButton.Image, Frame.Content.MainFrame.Right.Header.CloseButton.ImageTexture = AdaptiveAPI.FrameTemplates:CreateTexture(Frame.Content.MainFrame.Right.Header.CloseButton, "FULLSCREEN", AdaptiveAPI.PATH .. "Elements/close.png", "$parent.Image")
									Frame.Content.MainFrame.Right.Header.CloseButton.Image:SetSize(Frame.Content.MainFrame.Right.Header.CloseButton:GetWidth() - 10, Frame.Content.MainFrame.Right.Header.CloseButton:GetHeight() - 10)
									Frame.Content.MainFrame.Right.Header.CloseButton.Image:SetPoint("CENTER", Frame.Content.MainFrame.Right.Header.CloseButton)
									Frame.Content.MainFrame.Right.Header.CloseButton.Image:SetFrameStrata("FULLSCREEN")
									Frame.Content.MainFrame.Right.Header.CloseButton.Image:SetFrameLevel(55)
									Frame.Content.MainFrame.Right.Header.CloseButton.Image:SetAlpha(.5)
								end
							end
						end

						do -- FOOTER
							Frame.Content.MainFrame.Right.Footer = CreateFrame("Frame", "$parent.Footer", Frame.Content.MainFrame.Right)
							Frame.Content.MainFrame.Right.Footer:SetSize(Frame.Content.MainFrame.Right:GetWidth(), LocalBox / 2)
							Frame.Content.MainFrame.Right.Footer:SetPoint("TOP", Frame.Content.MainFrame.Right, 0, -LocalBox / 2)
							Frame.Content.MainFrame.Right.Footer:SetFrameStrata("FULLSCREEN")
							Frame.Content.MainFrame.Right.Footer:SetFrameLevel(53)

							local FooterLocalBox = Frame.Content.MainFrame.Right.Footer:GetHeight()

							--------------------------------

							do -- STATUS BAR
								Frame.Content.MainFrame.Right.Footer.StatusBar = CreateFrame("Slider", "$parent.StatusBar", Frame.Content.MainFrame.Right.Footer, "MinimalSliderTemplate")
								Frame.Content.MainFrame.Right.Footer.StatusBar:SetSize(Frame.Content.MainFrame.Right.Footer:GetWidth(), FooterLocalBox * .75)
								Frame.Content.MainFrame.Right.Footer.StatusBar:SetPoint("LEFT", Frame.Content.MainFrame.Right.Footer, 0, 0)
								Frame.Content.MainFrame.Right.Footer.StatusBar:SetFrameStrata("FULLSCREEN")
								Frame.Content.MainFrame.Right.Footer.StatusBar:SetFrameLevel(54)

								local StatusBar = Frame.Content.MainFrame.Right.Footer.StatusBar
								local Thumb = Frame.Content.MainFrame.Right.Footer.StatusBar.Thumb

								--------------------------------

								do -- BLIZZARD
									StatusBar.Left:Hide()
									StatusBar.Right:Hide()
									StatusBar.Middle:Hide()
									Thumb:Hide()
								end

								do -- BACKGROUND
									StatusBar.Background, StatusBar.BackgroundTexture = AdaptiveAPI.FrameTemplates:CreateTexture(StatusBar, "FULLSCREEN", NS.Variables.AUDIOBOOKUI_PATH .. "slider-background.png", "$parent.Background")
									StatusBar.Background:SetSize(StatusBar:GetWidth(), 7.5)
									StatusBar.Background:SetPoint("CENTER", StatusBar)
									StatusBar.Background:SetFrameStrata("FULLSCREEN")
									StatusBar.Background:SetFrameLevel(55)
									StatusBar.BackgroundTexture:SetVertexColor(.25, .25, .25, 1)
								end

								do -- PROGRESS BAR
									StatusBar.ProgressBar, StatusBar.ProgressBarTexture = AdaptiveAPI.FrameTemplates:CreateTexture(StatusBar, "FULLSCREEN", NS.Variables.AUDIOBOOKUI_PATH .. "slider-thumb.png", "$parent.ProgressBar")
									StatusBar.ProgressBar:SetHeight(7.5)
									StatusBar.ProgressBar:SetPoint("LEFT", StatusBar)
									StatusBar.ProgressBar:SetFrameStrata("FULLSCREEN")
									StatusBar.ProgressBar:SetFrameLevel(56)
								end

								--------------------------------

								StatusBar:SetScript("OnValueChanged", function()
									local CurrentValue = StatusBar:GetValue()
									local Min, Max = StatusBar:GetMinMaxValues()
									local Percentage = (CurrentValue - Min) / (Max - Min)
									local Width = StatusBar:GetWidth() * Percentage

									StatusBar.ProgressBar:SetWidth(Width)

									if StatusBar.MouseDown then
										InteractionAudiobookFrame.SetIndexOnValue()
									end

									InteractionAudiobookFrame.UpdateText()
								end)

								StatusBar:SetScript("OnMouseDown", function()
									StatusBar.MouseDown = true

									NS.Script:StopPlayback()
									InteractionAudiobookFrame.SetSteps()

									addon.Libraries.AceTimer:ScheduleTimer(function()
										InteractionAudiobookFrame.UpdateState()
									end, .1)
								end)

								StatusBar:SetScript("OnMouseUp", function()
									StatusBar.MouseDown = false

									InteractionAudiobookFrame:RemoveSteps()
									InteractionAudiobookFrame.SetIndexOnValue()
								end)
							end
						end
					end
				end
			end
		end
	end

	--------------------------------
	-- SETUP
	--------------------------------

	InteractionAudiobookFrame.hidden = true
	InteractionAudiobookFrame:Hide()
end
