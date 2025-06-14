---@class addon
local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local PrefabRegistry = addon.PrefabRegistry
local L = addon.Locales
local NS = addon.Audiobook; addon.Audiobook = NS

--------------------------------

NS.Elements = {}

--------------------------------

function NS.Elements:Load()
	--------------------------------
	-- CREATE ELEMENTS
	--------------------------------

	do
		do -- ELEMENTS
			InteractionAudiobookFrame = CreateFrame("Frame", "$parent.InteractionAudiobookFrame", InteractionFrame)
			InteractionAudiobookFrame:SetSize(NS.Variables.FRAME_WIDTH, NS.Variables.FRAME_HEIGHT)
			InteractionAudiobookFrame:SetPoint("TOP", UIParent, 0, -25)
			InteractionAudiobookFrame:SetFrameStrata("FULLSCREEN")
			InteractionAudiobookFrame:SetFrameLevel(50)

			InteractionAudiobookFrame:SetMovable(true)

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
					Frame.Background, Frame.BackgroundTexture = addon.API.FrameTemplates:CreateNineSlice(Frame, "FULLSCREEN", NS.Variables.AUDIOBOOKUI_PATH .. "background.png", 32, 2.5, "$parent.Background")
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

						addon.API.FrameUtil:AnchorToCenter(Frame.Content.PlaybackButton)

						--------------------------------

						do -- ELEMENTS
							do -- BACKGROUND
								Frame.Content.PlaybackButton.Background, Frame.Content.PlaybackButton.BackgroundTexture = addon.API.FrameTemplates:CreateTexture(Frame.Content.PlaybackButton, "FULLSCREEN", NS.Variables.AUDIOBOOKUI_PATH .. "button-playback-background.png", "$parent.Background")
								Frame.Content.PlaybackButton.Background:SetPoint("TOPLEFT", Frame.Content.PlaybackButton, -5, 5)
								Frame.Content.PlaybackButton.Background:SetPoint("BOTTOMRIGHT", Frame.Content.PlaybackButton, 5, -5)
								Frame.Content.PlaybackButton.Background:SetFrameStrata("FULLSCREEN")
								Frame.Content.PlaybackButton.Background:SetFrameLevel(52)
							end

							do -- IMAGE
								local IMAGE_PADDING = NS.Variables:RATIO(2.25)

								Frame.Content.PlaybackButton.Image, Frame.Content.PlaybackButton.ImageTexture = addon.API.FrameTemplates:CreateTexture(Frame.Content.PlaybackButton, "FULLSCREEN", NS.Variables.AUDIOBOOKUI_PATH .. "button-playback-play.png", "$parent.Image")
								Frame.Content.PlaybackButton.Image:SetPoint("TOPLEFT", Frame.Content.PlaybackButton, IMAGE_PADDING, -IMAGE_PADDING)
								Frame.Content.PlaybackButton.Image:SetPoint("BOTTOMRIGHT", Frame.Content.PlaybackButton, -IMAGE_PADDING, IMAGE_PADDING)
								Frame.Content.PlaybackButton.Image:SetFrameStrata("FULLSCREEN")
								Frame.Content.PlaybackButton.Image:SetFrameLevel(54)
							end
						end

						do -- ANIMATIONS
							do -- ON ENTER
								function Frame.Content.PlaybackButton:Animation_OnEnter_StopEvent()
									return not Frame.isMouseOver
								end

								function Frame.Content.PlaybackButton:Animation_OnEnter(skipAnimation)
									Frame.Content.PlaybackButton.BackgroundTexture:SetTexture(NS.Variables.AUDIOBOOKUI_PATH .. "button-playback-background-highlighted.png")
								end
							end

							do -- ON LEAVE
								function Frame.Content.PlaybackButton:Animation_OnLeave_StopEvent()
									return Frame.isMouseOver
								end

								function Frame.Content.PlaybackButton:Animation_OnLeave(skipAnimation)
									Frame.Content.PlaybackButton.BackgroundTexture:SetTexture(NS.Variables.AUDIOBOOKUI_PATH .. "button-playback-background.png")
								end
							end

							do -- ON MOUSE DOWN
								function Frame.Content.PlaybackButton:Animation_OnMouseDown_StopEvent()
									return not Frame.isMouseDown
								end

								function Frame.Content.PlaybackButton:Animation_OnMouseDown(skipAnimation)
									Frame.Content.PlaybackButton:SetAlpha(.75)
									addon.API.Animation:Scale(Frame.Content.PlaybackButton, .25, Frame.Content.PlaybackButton:GetScale(), .875, nil, nil, Frame.Content.PlaybackButton.Animation_OnMouseDown_StopEvent)
								end
							end

							do -- ON MOUSE UP
								function Frame.Content.PlaybackButton:Animation_OnMouseUp_StopEvent()
									return Frame.isMouseDown
								end

								function Frame.Content.PlaybackButton:Animation_OnMouseUp(skipAnimation)
									Frame.Content.PlaybackButton:SetAlpha(1)
									addon.API.Animation:Scale(Frame.Content.PlaybackButton, .075, Frame.Content.PlaybackButton:GetScale(), 1, nil, nil, Frame.Content.PlaybackButton.Animation_OnMouseUp_StopEvent)
								end
							end
						end

						do -- LOGIC
							Frame.Content.PlaybackButton.isMouseOver = false
							Frame.Content.PlaybackButton.isMouseDown = false

							Frame.Content.PlaybackButton.enterCallbacks = {}
							Frame.Content.PlaybackButton.leaveCallbacks = {}
							Frame.Content.PlaybackButton.mouseDownCallbacks = {}
							Frame.Content.PlaybackButton.mouseUpCallbacks = {}

							do -- FUNCTIONS

							end

							do -- EVENTS
								function Frame.Content.PlaybackButton:OnEnter(skipAnimation)
									Frame.Content.PlaybackButton.isMouseOver = true

									--------------------------------

									Frame.Content.PlaybackButton:Animation_OnEnter(skipAnimation)

									--------------------------------

									do -- ON ENTER
										if #Frame.Content.PlaybackButton.enterCallbacks >= 1 then
											local enterCallbacks = Frame.Content.PlaybackButton.enterCallbacks

											for callback = 1, #enterCallbacks do
												enterCallbacks[callback](skipAnimation)
											end
										end
									end
								end

								function Frame.Content.PlaybackButton:OnLeave(skipAnimation)
									Frame.Content.PlaybackButton.isMouseOver = false

									--------------------------------

									Frame.Content.PlaybackButton:Animation_OnLeave(skipAnimation)

									--------------------------------

									do -- ON LEAVE
										if #Frame.Content.PlaybackButton.leaveCallbacks >= 1 then
											local leaveCallbacks = Frame.Content.PlaybackButton.leaveCallbacks

											for callback = 1, #leaveCallbacks do
												leaveCallbacks[callback](skipAnimation)
											end
										end
									end
								end

								function Frame.Content.PlaybackButton:OnMouseDown(skipAnimation)
									Frame.Content.PlaybackButton.isMouseDown = true

									--------------------------------

									Frame.Content.PlaybackButton:Animation_OnMouseDown(skipAnimation)

									--------------------------------

									do -- ON MOUSE DOWN
										if #Frame.Content.PlaybackButton.mouseDownCallbacks >= 1 then
											local mouseDownCallbacks = Frame.Content.PlaybackButton.mouseDownCallbacks

											for callback = 1, #mouseDownCallbacks do
												mouseDownCallbacks[callback](skipAnimation)
											end
										end
									end
								end

								function Frame.Content.PlaybackButton:OnMouseUp(skipAnimation)
									Frame.Content.PlaybackButton.isMouseDown = false

									--------------------------------

									Frame.Content.PlaybackButton:Animation_OnMouseUp(skipAnimation)

									--------------------------------

									do -- ON MOUSE UP
										if #Frame.Content.PlaybackButton.mouseUpCallbacks >= 1 then
											local mouseUpCallbacks = Frame.Content.PlaybackButton.mouseUpCallbacks

											for callback = 1, #mouseUpCallbacks do
												mouseUpCallbacks[callback](skipAnimation)
											end
										end
									end
								end

								addon.API.FrameTemplates:CreateMouseResponder(Frame.Content.PlaybackButton, { enterCallback = Frame.Content.PlaybackButton.OnEnter, leaveCallback = Frame.Content.PlaybackButton.OnLeave, mouseDownCallback = Frame.Content.PlaybackButton.OnMouseDown, mouseUpCallback = Frame.Content.PlaybackButton.OnMouseUp })
							end
						end

						do -- SETUP
							Frame.Content.PlaybackButton:OnLeave(true)
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

							addon.API.FrameTemplates.Styles:Slider(Frame.Content.Slider, {
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
								Frame.Content.Text.Index.Background, Frame.Content.Text.Index.BackgroundTexture = addon.API.FrameTemplates:CreateNineSlice(Frame.Content.Text.Index, "FULLSCREEN", addon.API.Presets.NINESLICE_INSCRIBED, 64, .5, "$parent.Background")
								Frame.Content.Text.Index.Background:SetAllPoints(Frame.Content.Text.Index, true)
								Frame.Content.Text.Index.BackgroundTexture:SetVertexColor(1, 1, 1, .125)
								Frame.Content.Text.Index.Background:SetFrameStrata("FULLSCREEN")
								Frame.Content.Text.Index.Background:SetFrameLevel(53)
							end

							do -- TEXT
								Frame.Content.Text.Index.Text = addon.API.FrameTemplates:CreateText(Frame.Content.Text.Index, addon.Theme.RGB_WHITE, 15, "CENTER", "MIDDLE", addon.API.Fonts.CONTENT_LIGHT, "$parent.Text")
								Frame.Content.Text.Index.Text:SetAllPoints(Frame.Content.Text.Index, true)
							end
						end

						do -- TITLE
							Frame.Content.Text.Title = addon.API.FrameTemplates:CreateText(Frame.Content.Text, addon.Theme.RGB_WHITE, 15, "LEFT", "MIDDLE", addon.API.Fonts.CONTENT_LIGHT, "$parent.Title")
							Frame.Content.Text.Title:SetHeight(Frame.Content.Text:GetHeight())
							Frame.Content.Text.Title:SetPoint("LEFT", Frame.Content.Text, 0, 0)
						end

						do -- EVENTS
							local function UpdateSize()
								Frame.Content.Text.Index.Text:SetWidth(1000)

								---------------------------------

								local stringWidth, stringHeight = addon.API.Util:GetStringSize(Frame.Content.Text.Index.Text, nil, nil)
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
						Frame.TextPreviewFrame.Background, Frame.TextPreviewFrame.BackgroundTexture = addon.API.FrameTemplates:CreateNineSlice(Frame.TextPreviewFrame, "FULLSCREEN", NS.Variables.AUDIOBOOKUI_PATH .. "background.png", 32, 1, "$parent.Background")
						Frame.TextPreviewFrame.Background:SetPoint("TOPLEFT", Frame.TextPreviewFrame, -35, 35)
						Frame.TextPreviewFrame.Background:SetPoint("BOTTOMRIGHT", Frame.TextPreviewFrame, 35, -35)
						Frame.TextPreviewFrame.Background:SetFrameStrata("FULLSCREEN")
						Frame.TextPreviewFrame.Background:SetFrameLevel(50)
						Frame.TextPreviewFrame.BackgroundTexture:SetAlpha(.5)
					end

					do -- CONTENT
						Frame.TextPreviewFrame.Content = CreateFrame("Frame", "$parent.Content", Frame.TextPreviewFrame)
						Frame.TextPreviewFrame.Content:SetPoint("CENTER", Frame.TextPreviewFrame)
						Frame.TextPreviewFrame.Content:SetFrameStrata("FULLSCREEN")
						Frame.TextPreviewFrame.Content:SetFrameLevel(51)
						Frame.TextPreviewFrame.Content:SetClipsChildren(true)
						addon.API.FrameUtil:SetDynamicSize(Frame.TextPreviewFrame.Content, Frame.TextPreviewFrame, 0, 0)

						--------------------------------

						do -- TEXT
							Frame.TextPreviewFrame.Content.Text = addon.API.FrameTemplates:CreateText(Frame.TextPreviewFrame.Content, addon.Theme.RGB_CHAT_MSG_SAY, 12.5, "LEFT", "TOP", addon.API.Fonts.CONTENT_LIGHT, "$parent.Text")
							Frame.TextPreviewFrame.Content.Text:SetSize(Frame.TextPreviewFrame.Content:GetSize())
							Frame.TextPreviewFrame.Content.Text:SetPoint("CENTER", Frame.TextPreviewFrame.Content)
							addon.API.FrameUtil:SetDynamicSize(Frame.TextPreviewFrame.Content.Text, Frame.TextPreviewFrame.Content, 0, 0)
						end
					end

					do -- EVENTS
						local function UpdateSize()
							local maxWidth = Frame.Content:GetWidth() * .75
							local stringWidth, stringHeight = addon.API.Util:GetStringSize(Frame.TextPreviewFrame.Content.Text, maxWidth, nil)

							--------------------------------

							Frame.TextPreviewFrame:SetSize(stringWidth, stringHeight)

							--------------------------------

							if Frame.TextPreviewFrame.NewTextAnimation then
								Frame.TextPreviewFrame:NewTextAnimation()
							end
						end

						hooksecurefunc(Frame.TextPreviewFrame.Content.Text, "SetText", UpdateSize)
					end
				end
			end

			do -- CLICK EVENTS
				Frame.Animation_DragStart = function()
					addon.API.Animation:Fade(Frame.Content, .075, Frame.Content:GetAlpha(), 0, nil, function() return not Frame.moving or Frame.hidden end)
					addon.API.Animation:Scale(Frame.Background, .25, Frame.Background:GetScale(), .875, nil, addon.API.Animation.EaseSine, function() return not Frame.moving or Frame.hidden end)
				end

				Frame.Animation_DragStop = function()
					addon.API.Animation:Fade(Frame.Content, .075, Frame.Content:GetAlpha(), 1, nil, function() return Frame.moving or Frame.hidden end)
					addon.API.Animation:Scale(Frame.Background, .25, Frame.Background:GetScale(), 1, nil, addon.API.Animation.EaseExpo, function() return Frame.moving or Frame.hidden end)
				end

				Frame.Animation_CloseStart = function()
					addon.API.Animation:Fade(Frame.Content, .075, Frame.Content:GetAlpha(), 0, nil, function() return Frame.moving or Frame.hidden end)
					addon.API.Animation:Scale(Frame.Background, .25, Frame.Background:GetScale(), 1.05, nil, addon.API.Animation.EaseSine, function() return Frame.moving or Frame.hidden end)
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
	local Callback = NS.Script; NS.Script = Callback

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
