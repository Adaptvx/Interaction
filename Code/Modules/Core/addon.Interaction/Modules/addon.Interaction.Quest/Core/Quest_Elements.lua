local addonName, addon = ...
local PrefabRegistry = addon.PrefabRegistry
local CallbackRegistry = addon.CallbackRegistry
local L = addon.Locales
local NS = addon.Interaction.Quest

--------------------------------

NS.Elements = {}

--------------------------------

function NS.Elements:Load()
	--------------------------------
	-- CREATE ELEMENTS
	--------------------------------

	do
		do -- CREATE ELEMENTS
			InteractionQuestParent = CreateFrame("Frame", "InteractionQuestParent", InteractionFrame)
			InteractionQuestParent:SetSize(addon.API.Main:GetScreenWidth(), addon.API.Main:GetScreenHeight())
			InteractionQuestParent:SetPoint("CENTER", nil)
			InteractionQuestParent:SetFrameStrata("HIGH")

			InteractionQuestFrame = CreateFrame("Frame", "InteractionQuestFrame", InteractionQuestParent)
			InteractionQuestFrame:SetSize(NS.Variables.FRAME_SIZE.x, NS.Variables.FRAME_SIZE.y)
			InteractionQuestFrame:SetPoint("CENTER", nil)
			InteractionQuestFrame:SetFrameStrata("HIGH")

			--------------------------------

			local Frame = InteractionQuestFrame

			--------------------------------

			do -- BACKGROUND
				do -- BACKGROUND
					Frame.Background, Frame.BackgroundTexture = addon.API.FrameTemplates:CreateTexture(Frame, "HIGH", nil)
					Frame.Background:SetFrameStrata("HIGH")
					Frame.Background:SetFrameLevel(2)

					--------------------------------

					addon.API.Main:RegisterThemeUpdate(function()
						local TEXTURE_Background

						--------------------------------

						if addon.Theme.IsDarkTheme then
							TEXTURE_Background = NS.Variables.QUEST_PATH .. "background-dark.png"
						else
							TEXTURE_Background = NS.Variables.QUEST_PATH .. "background-light.png"
						end

						--------------------------------

						Frame.BackgroundTexture:SetTexture(TEXTURE_Background)
					end, 5)
				end

				do -- BORDER
					Frame.Border, Frame.BorderTexture = addon.API.FrameTemplates:CreateTexture(Frame, "HIGH", nil)
					Frame.Border:SetFrameStrata("HIGH")
					Frame.Border:SetFrameLevel(3)

					--------------------------------

					addon.API.Main:RegisterThemeUpdate(function()
						local TEXTURE_Background

						--------------------------------

						if addon.Theme.IsDarkTheme then
							TEXTURE_Background = NS.Variables.QUEST_PATH .. "border-dark.png"
						else
							TEXTURE_Background = NS.Variables.QUEST_PATH .. "border-light.png"
						end

						--------------------------------

						Frame.BorderTexture:SetTexture(TEXTURE_Background)
					end, 5)
				end

				do -- SCROLL FRAME INDICATOR
					Frame.Background.ScrollFrameIndicator, Frame.Background.ScrollFrameIndicatorTexture = addon.API.FrameTemplates:CreateTexture(Frame, "HIGH", nil)
					Frame.Background.ScrollFrameIndicator:SetPoint("BOTTOM", Frame, 0, 42.5)
					Frame.Background.ScrollFrameIndicator:SetFrameLevel(500)
					Frame.Background.ScrollFrameIndicator:SetAlpha(.25)

					--------------------------------

					addon.API.Main:RegisterThemeUpdate(function()
						local ScrollFrameIndicatorTexture

						if addon.Theme.IsDarkTheme then
							ScrollFrameIndicatorTexture = NS.Variables.QUEST_PATH .. "footer-dark.png"
						else
							ScrollFrameIndicatorTexture = NS.Variables.QUEST_PATH .. "footer-light.png"
						end

						Frame.Background.ScrollFrameIndicatorTexture:SetTexture(ScrollFrameIndicatorTexture)
					end, 5)
				end
			end

			do -- BUTTONS
				Frame.ButtonContainer = CreateFrame("Frame", "$parent.ButtonContainer", Frame)
				Frame.ButtonContainer:SetHeight(NS.Variables:RATIO(5.75))
				Frame.ButtonContainer:SetPoint("BOTTOM", Frame, 0, 0)

				--------------------------------

				local function CreateButton(name, color, highlightColor, color_darkTheme, highlightColor_darkTheme)
					local button = CreateFrame("Button", name, Frame.ButtonContainer, "UIPanelButtonTemplate")
					button.Text = _G[button:GetDebugName() .. "Text"]

					--------------------------------

					addon.API.FrameTemplates.Styles:Button(button, {
						defaultTexture = addon.API.Presets.NINESLICE_INSCRIBED_FILLED_HIGHLIGHT,
						highlightTexture = addon.API.Presets.NINESLICE_INSCRIBED_FILLED_HIGHLIGHT,
						edgeSize = 25,
						scale = .5,
						playAnimation = false,
						customColor = color,
						customHighlightColor = highlightColor,
						customTextColor = addon.Theme.RGB_WHITE,
					})

					--------------------------------

					addon.API.Main:RegisterThemeUpdate(function()
						local FilledColor
						local FilledHighlightColor

						--------------------------------

						if addon.Theme.IsDarkTheme then
							FilledColor = color_darkTheme
							FilledHighlightColor = highlightColor_darkTheme
						else
							FilledColor = color
							FilledHighlightColor = highlightColor
						end

						--------------------------------

						addon.API.FrameTemplates.Styles:UpdateButton(button, {
							customColor = FilledColor,
							customHighlightColor = FilledHighlightColor
						})
					end, 3)

					--------------------------------

					return button
				end

				--------------------------------

				do -- ACCEPT
					Frame.ButtonContainer.AcceptButton = CreateButton("$parent.AcceptButton", addon.Theme.Quest.Secondary_LightTheme, addon.Theme.Quest.Primary_LightTheme, addon.Theme.Quest.Secondary_DarkTheme, addon.Theme.Quest.Primary_DarkTheme)
					Frame.ButtonContainer.AcceptButton:SetSize(NS.Variables:RATIO(3), Frame.ButtonContainer:GetHeight())
					Frame.ButtonContainer.AcceptButton:SetPoint("LEFT", Frame.ButtonContainer)
				end

				do -- CONTINUE
					Frame.ButtonContainer.ContinueButton = CreateButton("$parent.ContinueButton", addon.Theme.Quest.Secondary_LightTheme, addon.Theme.Quest.Primary_LightTheme, addon.Theme.Quest.Secondary_DarkTheme, addon.Theme.Quest.Primary_DarkTheme)
					Frame.ButtonContainer.ContinueButton:SetSize(NS.Variables:RATIO(3), Frame.ButtonContainer:GetHeight())
					Frame.ButtonContainer.ContinueButton:SetPoint("LEFT", Frame.ButtonContainer)
				end

				do -- COMPLETE
					Frame.ButtonContainer.CompleteButton = CreateButton("$parent.CompleteButton", addon.Theme.Quest.Secondary_LightTheme, addon.Theme.Quest.Primary_LightTheme, addon.Theme.Quest.Secondary_DarkTheme, addon.Theme.Quest.Primary_DarkTheme)
					Frame.ButtonContainer.CompleteButton:SetSize(NS.Variables:RATIO(3), Frame.ButtonContainer:GetHeight())
					Frame.ButtonContainer.CompleteButton:SetPoint("LEFT", Frame.ButtonContainer)
				end

				do -- DECLINE
					Frame.ButtonContainer.DeclineButton = CreateButton("$parent.DeclineButton", addon.Theme.Quest.Highlight_Tertiary_LightTheme, addon.Theme.Quest.Highlight_Secondary_LightTheme, addon.Theme.Quest.Highlight_Tertiary_DarkTheme, addon.Theme.Quest.Highlight_Secondary_DarkTheme)
					Frame.ButtonContainer.DeclineButton:SetSize(NS.Variables:RATIO(3), Frame.ButtonContainer:GetHeight())
					Frame.ButtonContainer.DeclineButton:SetPoint("RIGHT", Frame.ButtonContainer)
				end

				do -- GOODBYE
					Frame.ButtonContainer.GoodbyeButton = CreateButton("$parent.GoodbyeButton", addon.Theme.Quest.Highlight_Tertiary_LightTheme, addon.Theme.Quest.Highlight_Secondary_LightTheme, addon.Theme.Quest.Highlight_Tertiary_DarkTheme, addon.Theme.Quest.Highlight_Secondary_DarkTheme)
					Frame.ButtonContainer.GoodbyeButton:SetSize(NS.Variables:RATIO(3), Frame.ButtonContainer:GetHeight())
					Frame.ButtonContainer.GoodbyeButton:SetPoint("RIGHT", Frame.ButtonContainer)
				end
			end

			do -- SCROLL FRAME
				Frame.ScrollFrame, Frame.ScrollChildFrame = addon.API.FrameTemplates:CreateScrollFrame(Frame, { direction = "vertical", smoothScrollingRatio = 5 }, "$parent.ScrollFrame", "$parent.ScrollChildFrame")
				Frame.ScrollFrame:SetPoint("BOTTOM", Frame, 0, 65)

				--------------------------------

				do -- SCROLL BAR
					Frame.ScrollFrame.ScrollBar:Hide()
				end
			end

			do -- CONTEXT ICON
				Frame.ContextIcon = CreateFrame("Frame", "$parent.ContextIcon", Frame)
				Frame.ContextIcon:SetSize(NS.Variables:RATIO(3), NS.Variables:RATIO(3))
				Frame.ContextIcon:SetPoint("TOPLEFT", Frame, -Frame.ContextIcon:GetWidth() * .5625, Frame.ContextIcon:GetHeight() * .5875)
				Frame.ContextIcon:SetFrameStrata("HIGH")
				Frame.ContextIcon:SetFrameLevel(10)

				addon.API.FrameUtil:AnchorToCenter(Frame.ContextIcon)

				--------------------------------

				do -- BACKGROUND
					Frame.ContextIcon.Background, Frame.ContextIcon.BackgroundTexture = addon.API.FrameTemplates:CreateTexture(Frame.ContextIcon, "HIGH", nil, "$parent.Background")
					Frame.ContextIcon.Background:SetAllPoints(Frame.ContextIcon, true)
					Frame.ContextIcon.Background:SetFrameStrata("HIGH")
					Frame.ContextIcon.Background:SetFrameLevel(9)

					--------------------------------

					addon.API.Main:RegisterThemeUpdate(function()
						local TEXTURE_Background

						--------------------------------

						if addon.Theme.IsDarkTheme then
							TEXTURE_Background = NS.Variables.QUEST_PATH .. "context-background-dark.png"
						else
							TEXTURE_Background = NS.Variables.QUEST_PATH .. "context-background-light.png"
						end

						--------------------------------

						Frame.ContextIcon.BackgroundTexture:SetTexture(TEXTURE_Background)
					end, 5)
				end

				do -- LABEL
					Frame.ContextIcon.Label = addon.API.FrameTemplates:CreateText(Frame.ContextIcon, addon.Theme.RGB_WHITE, 35, "CENTER", "MIDDLE", addon.API.Fonts.Title_Bold, "$parent.Label")
                    Frame.ContextIcon.Label:SetPoint("TOPLEFT", Frame.ContextIcon, 1, -1)
					Frame.ContextIcon.Label:SetPoint("BOTTOMRIGHT", Frame.ContextIcon, 1, -1)
				end
			end

			do -- CONTENT
				local SCROLL_FRAME = Frame.ScrollChildFrame

				local TITLE_TEXT_SIZE = 25
				local CONTENT_TEXT_SIZE = 15
				local TOOLTIP_TEXT_SIZE = 12.5

				--------------------------------

				SCROLL_FRAME.Elements = {}

				--------------------------------

				local function CreateHeader(parent)
					local Header = CreateFrame("Frame", "$parent.Header", parent)
					Header:SetHeight(NS.Variables:RATIO(5.25))
					addon.API.FrameUtil:SetDynamicSize(Header, SCROLL_FRAME, 0, nil)

					--------------------------------

					do -- BACKGROUND
						Header.Background, Header.BackgroundTexture = addon.API.FrameTemplates:CreateNineSlice(Header, "HIGH", NS.Variables.THEME.INSCRIBED_HEADER, 86, .125, "$parent.Header", Enum.UITextureSliceMode.Stretched)
						Header.Background:SetPoint("TOPLEFT", Header, -3.75, 2.5)
						Header.Background:SetPoint("BOTTOMRIGHT", Header, 3.75, -2.5)
					end

					do -- TEXT
						local PADDING = NS.Variables:RATIO(6.5)

						Header.Label = addon.API.FrameTemplates:CreateText(Header, { r = 1, g = 1, b = 1 }, 15, "LEFT", "MIDDLE", addon.API.Fonts.Content_Light)
						Header.Label:SetPoint("TOPLEFT", Header, (PADDING / 2), -(PADDING / 2))
						Header.Label:SetPoint("BOTTOMRIGHT", Header, -(PADDING / 2), (PADDING / 2))
						Header.Label:SetAlpha(.75)
					end

					--------------------------------

					return Header
				end

				local function CreateRewardText(parent)
					local Background, BackgroundTexture = addon.API.FrameTemplates:CreateNineSlice(parent, "HIGH", nil, 50, 3.25, "$parent.Background")
					Background:SetHeight(NS.Variables:RATIO(6.5))
					addon.API.FrameUtil:SetDynamicSize(Background, SCROLL_FRAME, 0, nil)

					addon.API.Main:RegisterThemeUpdate(function()
						local COLOR_Background

						if addon.Theme.IsDarkTheme then
							COLOR_Background = addon.Theme.Quest.Highlight_Tertiary_DarkTheme
						else
							COLOR_Background = addon.Theme.Quest.Highlight_Tertiary_LightTheme
						end

						BackgroundTexture:SetVertexColor(COLOR_Background.r, COLOR_Background.g, COLOR_Background.b, COLOR_Background.a)
					end, 5)

					--------------------------------

					do -- TEXT
						local PADDING = NS.Variables:RATIO(7.5)

						Background.Text = addon.API.FrameTemplates:CreateText(Background, { r = 1, g = 1, b = 1 }, CONTENT_TEXT_SIZE, "LEFT", "MIDDLE", addon.API.Fonts.Content_Light, "$parent.Label")
						Background.Text:SetPoint("TOPLEFT", Background, 0, -(PADDING / 2))
						Background.Text:SetPoint("BOTTOMRIGHT", Background, 0, PADDING / 2)
						Background.Text:SetAlpha(.75)
					end

					--------------------------------

					return Background, Background.Text
				end

				local function CreateReward(parent, selectable)
					local PADDING = NS.Variables:RATIO(9.5)
					local TEXT_PADDING = NS.Variables:RATIO(7.5)

					--------------------------------

					local Button = CreateFrame("Frame", nil, parent)
					Button:SetHeight(NS.Variables:RATIO(5.5))
					Button:SetPoint("CENTER", parent)
					addon.API.FrameUtil:SetDynamicSize(Button, parent, 0, nil)

					--------------------------------

					Button.Index = nil
					Button.Type = nil
					Button.Callback = nil
					Button.Quality = nil
					Button.State = "DEFAULT"
					Button.SelectionState = "DEFAULT"

					Button.MouseOver = false

					--------------------------------

					do -- STATE
						Button.SetState = function(state, SelectionState)
							Button.State = state
							Button.SelectionState = SelectionState

							--------------------------------

							Button.UpdateState()
						end

						Button.SetStateAuto = function()
							if not Button.Type or not Button.Index then
								return
							end

							--------------------------------

							local type = Button.Type
							local index = Button.Index

							local state
							local selectionState
							local selectedReward = QuestInfoFrame.itemChoice

							--------------------------------

							do -- STATE
								if type ~= "spell" then
									local name, texture, count, quality, isUsable, itemID = GetQuestItemInfo(type, index)

									--------------------------------

									if addon.Variables.IS_CLASSIC and not isUsable then
										state = "INVALID"
									else
										state = "DEFAULT"
									end
								else
									state = "DEFAULT"
								end
							end

							do -- STATE (SELECTION)
								if selectedReward == index then
									selectionState = "SELECTED"
								else
									selectionState = "DEFAULT"
								end
							end

							--------------------------------

							Button.SetState(state, selectionState)
							Button.UpdateState()
						end

						Button.UpdateState = function()
							local state = Button.State
							local selectionState = Button.SelectionState

							--------------------------------

							do -- STATE
								if state == "DEFAULT" then
									local quality = Button.Quality
									local qualityColors = {
										[0] = { addon.Theme.Quest.Gradient_Quality_Poor_Start, addon.Theme.Quest.Gradient_Quality_Poor_End, addon.Theme.Quest.Text_Quality_Poor },
										[1] = { addon.Theme.Quest.Gradient_Quality_Common_Start, addon.Theme.Quest.Gradient_Quality_Common_End, addon.Theme.Quest.Text_Quality_Common },
										[2] = { addon.Theme.Quest.Gradient_Quality_Uncommon_Start, addon.Theme.Quest.Gradient_Quality_Uncommon_End, addon.Theme.Quest.Text_Quality_Uncommon },
										[3] = { addon.Theme.Quest.Gradient_Quality_Rare_Start, addon.Theme.Quest.Gradient_Quality_Rare_End, addon.Theme.Quest.Text_Quality_Rare },
										[4] = { addon.Theme.Quest.Gradient_Quality_Epic_Start, addon.Theme.Quest.Gradient_Quality_Epic_End, addon.Theme.Quest.Text_Quality_Epic },
										[5] = { addon.Theme.Quest.Gradient_Quality_Legendary_Start, addon.Theme.Quest.Gradient_Quality_Legendary_End, addon.Theme.Quest.Text_Quality_Legendary },
										[6] = { addon.Theme.Quest.Gradient_Quality_Artifact_Start, addon.Theme.Quest.Gradient_Quality_Artifact_End, addon.Theme.Quest.Text_Quality_Artifact },
										[7] = { addon.Theme.Quest.Gradient_Quality_Heirloom_Start, addon.Theme.Quest.Gradient_Quality_Heirloom_End, addon.Theme.Quest.Text_Quality_Heirloom },
										[8] = { addon.Theme.Quest.Gradient_Quality_WoWToken_Start, addon.Theme.Quest.Gradient_Quality_WoWToken_End, addon.Theme.Quest.Text_Quality_WoWToken },
									}

									local colors = qualityColors[quality] or (addon.Theme.IsDarkTheme and { addon.Theme.Quest.Highlight_Primary_DarkTheme, addon.Theme.Quest.Highlight_Secondary_DarkTheme, addon.Theme.RGB_WHITE } or { addon.Theme.Quest.Highlight_Primary_LightTheme, addon.Theme.Quest.Highlight_Secondary_LightTheme, addon.Theme.RGB_WHITE })
									local GRADIENT_Start, GRADIENT_End, COLOR_Text = unpack(colors)

									local COLOR_Background = addon.Theme.IsDarkTheme and addon.Theme.Quest.Highlight_Tertiary_DarkTheme or addon.Theme.Quest.Highlight_Tertiary_LightTheme
									local COLOR_Image = { r = 1, g = 1, b = 1, a = 1 }

									Button.Label:SetTextColor(COLOR_Text.r, COLOR_Text.g, COLOR_Text.b, 1)
									Button.BackgroundTexture:SetVertexColor(COLOR_Background.r, COLOR_Background.g, COLOR_Background.b, COLOR_Background.a)
									Button.Image.IconTexture:SetVertexColor(COLOR_Image.r, COLOR_Image.g, COLOR_Image.b, COLOR_Image.a)
									Button.Image.BackgroundTexture:SetGradient("VERTICAL", GRADIENT_Start, GRADIENT_End)
								end

								if state == "INVALID" then
									local COLOR_Background
									local COLOR_Image
									local GRADIENT_START_Image_Background
									local GRADIENT_END_Image_Background

									if addon.Theme.IsDarkTheme then
										COLOR_Background = addon.Theme.Quest.Invalid_Tertiary_DarkTheme
										COLOR_Image = addon.Theme.Quest.Invalid_Tint_DarkTheme

										local colorStart = addon.Theme.Quest.Invalid_Primary_DarkTheme
										local colorEnd = addon.Theme.Quest.Invalid_Secondary_DarkTheme
										GRADIENT_START_Image_Background = CreateColor(colorStart.r, colorStart.g, colorStart.b, colorStart.a)
										GRADIENT_END_Image_Background = CreateColor(colorEnd.r, colorEnd.g, colorEnd.b, colorEnd.a)
									else
										COLOR_Background = addon.Theme.Quest.Invalid_Tertiary_LightTheme
										COLOR_Image = addon.Theme.Quest.Invalid_Tint_DarkTheme

										local colorStart = addon.Theme.Quest.Invalid_Primary_LightTheme
										local colorEnd = addon.Theme.Quest.Invalid_Secondary_LightTheme
										GRADIENT_START_Image_Background = CreateColor(colorStart.r, colorStart.g, colorStart.b, colorStart.a)
										GRADIENT_END_Image_Background = CreateColor(colorEnd.r, colorEnd.g, colorEnd.b, colorEnd.a)
									end

									Button.BackgroundTexture:SetVertexColor(COLOR_Background.r, COLOR_Background.g, COLOR_Background.b, COLOR_Background.a)
									Button.Image.IconTexture:SetVertexColor(COLOR_Image.r, COLOR_Image.g, COLOR_Image.b, COLOR_Image.a)
									Button.Image.BackgroundTexture:SetGradient("VERTICAL", GRADIENT_START_Image_Background, GRADIENT_END_Image_Background)
								end
							end

							do -- STATE (SELECTION)
								local isSelectable = selectable
								local numChoices = NS.Variables.Num_Choice
								local selectedReward = QuestInfoFrame.itemChoice

								local currentAlpha = Button:GetAlpha()
								local targetAlpha = 1

								--------------------------------

								if selectionState == "SELECTED" or selectedReward == 0 then
									targetAlpha = 1
								elseif isSelectable and numChoices > 1 then
									targetAlpha = .25
								end

								--------------------------------

								if currentAlpha ~= targetAlpha then
									addon.API.Animation:Fade(Button, .25, currentAlpha, targetAlpha, addon.API.Animation.EaseExpo)
								else
									Button:SetAlpha(targetAlpha)
								end
							end
						end
					end

					do -- CLICK EVENTS
						Button.CanClick = function()
							if selectable then
								if NS.Variables.Num_Choice > 1 and QuestFrameCompleteQuestButton:IsVisible() then
									return true
								else
									return false
								end
							end
						end

						Button.Click = function()
							Button.Callback:Click()

							--------------------------------

							if Button.Type == "choice" then
								Frame.SetChoiceSelected()
							end

							--------------------------------

							CallbackRegistry:Trigger("QUEST_REWARD_SELECTED", Button)

							--------------------------------

							addon.SoundEffects:PlaySoundFile(addon.SoundEffects.Quest_Button_MouseUp)
						end

						Button.MouseDownCallback = function()
							addon.SoundEffects:PlaySoundFile(addon.SoundEffects.Quest_Button_MouseDown)
						end

						Button.MouseEnterCallback = function()
							InteractionFrame.GameTooltip.RewardButton = Button

							--------------------------------

							if Button.Callback then
								-- Lua Taint?
								-- Blizzard GameTooltip Code

								local rewardType = NS.Script:GetQuestRewardType(Button.Type, Button.Index)

								--------------------------------

								InteractionFrame.GameTooltip:SetOwner(Button, "ANCHOR_TOPRIGHT", 0, 0);

								if (Button.Type == "spell") then
									if (Button.Callback.factionID) then
										local wrapText = false
										GameTooltip_SetTitle(InteractionFrame.GameTooltip, QUEST_REPUTATION_REWARD_TITLE:format(Button.Callback.factionName), HIGHLIGHT_FONT_COLOR, wrapText)
										if C_Reputation.IsAccountWideReputation(Button.Callback.factionID) then
											GameTooltip_AddColoredLine(InteractionFrame.GameTooltip, REPUTATION_TOOLTIP_ACCOUNT_WIDE_LABEL, ACCOUNT_WIDE_FONT_COLOR)
										end
										GameTooltip_AddNormalLine(InteractionFrame.GameTooltip, QUEST_REPUTATION_REWARD_TOOLTIP:format(Button.Callback.rewardAmount, Button.Callback.factionName))
									else
										InteractionFrame.GameTooltip:SetSpellByID(Button.Callback.rewardSpellID)
									end
								elseif (rewardType == "item") then
									InteractionFrame.GameTooltip:SetQuestItem(Button.Callback.type, Button.Callback:GetID())
									InteractionFrame.GameTooltip:ShowComparison(InteractionFrame.GameTooltip)
								elseif (rewardType == "currency") then
									InteractionFrame.GameTooltip:SetQuestCurrency(Button.Callback.type, Button.Callback:GetID())
								end

								if (Button.Callback.rewardContextLine) then
									GameTooltip_AddBlankLineToTooltip(InteractionFrame.GameTooltip)
									GameTooltip_AddColoredLine(InteractionFrame.GameTooltip, Button.Callback.rewardContextLine, QUEST_REWARD_CONTEXT_FONT_COLOR)
								end

								InteractionFrame.GameTooltip:Show()
								CursorUpdate(Button.Callback)

								--------------------------------

								InteractionQuestFrame.UpdateGameTooltip()
							end

							--------------------------------

							Button.Enter()

							--------------------------------

							addon.SoundEffects:PlaySoundFile(addon.SoundEffects.Quest_Button_Enter)
						end

						Button.MouseLeaveCallback = function()
							InteractionFrame.GameTooltip.RewardButton = nil

							--------------------------------

							InteractionFrame.GameTooltip:Hide()
							InteractionQuestFrame.UpdateGameTooltip()

							--------------------------------

							if Button.Callback then
								InteractionFrame.GameTooltip:Hide()
							end

							--------------------------------

							Button.Leave()

							--------------------------------

							addon.SoundEffects:PlaySoundFile(addon.SoundEffects.Quest_Button_Leave)
						end

						--------------------------------

						Button:SetScript("OnEnter", function()
							Button.MouseEnterCallback()
						end)

						Button:SetScript("OnLeave", function()
							Button.MouseLeaveCallback()
						end)

						Button:SetScript("OnMouseDown", function()
							Button.MouseDownCallback()
						end)

						Button:SetScript("OnMouseUp", function()
							Button.Click()
						end)
					end

					do -- ELEMENTS
						do -- BACKGROUND
							Button.Background, Button.BackgroundTexture = addon.API.FrameTemplates:CreateNineSlice(Button, "HIGH", NS.Variables.THEME.INSCRIBED_BACKGROUND, 50, 3.25, "$parent.Background")
							Button.Background:SetPoint("TOPLEFT", Button, -1.25, 1.25)
							Button.Background:SetPoint("BOTTOMRIGHT", Button, 1.25, -1.25)
							Button.Background:SetFrameStrata("HIGH")
							Button.Background:SetFrameLevel(1)
						end

						do -- IMAGE
							Button.Image = CreateFrame("Frame", "$parent.Image", Button)
							Button.Image:SetPoint("LEFT", Button)
							Button.Image:SetFrameLevel(2)
							addon.API.FrameUtil:SetDynamicSize(Button.Image, Button, function(relativeWidth, relativeHeight) return relativeHeight - 2.5 end, function(relativeWidth, relativeHeight) return relativeHeight - 2.5 end)

							--------------------------------

							do -- BACKGROUND
								Button.Image.Background, Button.Image.BackgroundTexture = addon.API.FrameTemplates:CreateTexture(Button.Image, "HIGH", addon.API.Presets.BASIC_SQUARE, "$parent.Background")
								Button.Image.Background:SetAllPoints(Button.Image, true)
								Button.Image.Background:SetFrameLevel(3)
							end

							do -- ICON
								Button.Image.Icon, Button.Image.IconTexture = addon.API.FrameTemplates:CreateTexture(Button.Image, "HIGH", nil, "$parent.Texture")
								Button.Image.Icon:SetPoint("TOPLEFT", Button.Image, (PADDING / 2), -(PADDING / 2))
								Button.Image.Icon:SetPoint("BOTTOMRIGHT", Button.Image, -(PADDING / 2), (PADDING / 2))
								Button.Image.Icon:SetFrameLevel(4)
								Button.Image.IconTexture:SetTexCoord(.15, .85, .15, .85)
							end

							do -- TEXT
								Button.Image.Text = CreateFrame("Frame", "$parent.Text", Button.Image)
								Button.Image.Text:SetPoint("BOTTOM", Button.Image, 0, PADDING / 2)
								Button.Image.Text:SetFrameLevel(6)
								addon.API.FrameUtil:SetDynamicSize(Button.Image.Text, Button.Image, function(relativeWidth, relativeHeight) return relativeWidth - PADDING end, function(relativeWidth, relativeHeight) return relativeHeight / (addon.Variables.GOLDEN_RATIO ^ 2) end)

								--------------------------------

								do -- BACKGROUND
									Button.Image.Text.Background, Button.Image.Text.BackgroundTexture = addon.API.FrameTemplates:CreateTexture(Button.Image.Text, "HIGH", addon.API.Presets.BASIC_SQUARE, "$parent.Background")
									Button.Image.Text.Background:SetAllPoints(Button.Image.Text, true)
									Button.Image.Text.Background:SetFrameLevel(5)
									Button.Image.Text.BackgroundTexture:SetVertexColor(.1, .1, .1, .825)
								end

								do -- LABEL
									Button.Image.Text.Label = addon.API.FrameTemplates:CreateText(Button.Image.Text, { r = 1, g = 1, b = 1 }, TOOLTIP_TEXT_SIZE, "CENTER", "MIDDLE", addon.API.Fonts.Content_Light, "$parent.Label")
									Button.Image.Text.Label:SetAllPoints(Button.Image.Text, true)
								end
							end
						end

						do -- LABEL
							Button.Label = addon.API.FrameTemplates:CreateText(Button, { r = 1, g = 1, b = 1 }, 15, "LEFT", "MIDDLE", addon.API.Fonts.Content_Light)
							Button.Label:SetPoint("LEFT", Button, Button.Image:GetWidth() + TEXT_PADDING, 0)
							Button.Label:SetAlpha(.75)
							addon.API.FrameUtil:SetDynamicSize(Button.Label, Button, function(relativeWidth, relativeHeight) return relativeWidth - TEXT_PADDING - Button.Image:GetWidth() - TEXT_PADDING end, 0)
						end

						do -- HIGHLIGHT
							Button.Highlight = CreateFrame("Frame", "$parent.Highlight", Button)
							Button.Highlight:SetAllPoints(Button, true)
							Button.Highlight:SetFrameStrata("HIGH")
							Button.Highlight:SetFrameLevel(5)

							--------------------------------

							do -- BACKGROUND
								Button.Highlight.Background, Button.Highlight.BackgroundTexture = addon.API.FrameTemplates:CreateTexture(Button.Highlight, "HIGH", NS.Variables.QUEST_PATH .. "reward-highlight-add.png", "$parent.Texture")
								Button.Highlight.Background:SetAllPoints(Button.Highlight, true)
								Button.Highlight.Background:SetFrameStrata("HIGH")
								Button.Highlight.Background:SetFrameLevel(99)

								Button.Highlight.BackgroundTexture:SetBlendMode("ADD")
							end
						end

						do -- ANIMATION
							Button.Enter = function()
								Button.MouseOver = true

								--------------------------------

								addon.API.Animation:Fade(Button.Highlight, .075, Button.Highlight:GetAlpha(), 1, addon.API.Animation.EaseExpo, function() return not Button.MouseOver end)
							end

							Button.Leave = function()
								Button.MouseOver = false

								--------------------------------

								addon.API.Animation:Fade(Button.Highlight, .075, Button.Highlight:GetAlpha(), 0, addon.API.Animation.EaseSine, function() return Button.MouseOver end)
							end

							--------------------------------

							Button.Highlight:SetAlpha(0)
						end

						do -- EVENTS
							CallbackRegistry:Add("START_QUEST", function() Button.SetStateAuto() end, 0)
							CallbackRegistry:Add("QUEST_REWARD_SELECTED", function() Button.SetStateAuto() end, 0)

							--------------------------------

							addon.API.Main:RegisterThemeUpdate(function()
								Button.UpdateState()
							end, 10)
						end
					end

					--------------------------------

					return Button
				end

				local function SetAutoTextHeight(frame, customWidthModifier)
					local function UpdateSize()
						frame:SetWidth(Frame.ScrollChildFrame:GetWidth() * (customWidthModifier or 1))

						local _, textHeight = addon.API.Util:GetStringSize(frame, frame:GetWidth())
						frame:SetHeight(textHeight)
					end
					UpdateSize()

					--------------------------------

					hooksecurefunc(frame, "SetText", UpdateSize)
				end

				local function RegisterElement(frame, type)
					frame.type = type
					table.insert(Frame.ScrollChildFrame.Elements, frame)
				end

				--------------------------------

				do -- TITLE
					Frame.Title = addon.API.FrameTemplates:CreateText(Frame, addon.Theme.RGB_WHITE, TITLE_TEXT_SIZE, "LEFT", "TOP", addon.API.Fonts.Content_Light)
					Frame.Title:SetPoint("TOPLEFT", Frame, 55, NS.Variables:RATIO(7))

					--------------------------------

					SetAutoTextHeight(Frame.Title, .85)
				end

				do -- TITLE HEADER
					Frame.TitleHeader, Frame.TitleHeaderTexture = addon.API.FrameTemplates:CreateTexture(Frame, "HIGH", nil, "$parent.TitleHeader")
					Frame.TitleHeader:SetSize(Frame:GetWidth() - 20, (Frame:GetWidth() - 20) * .14)
					Frame.TitleHeader:SetPoint("TOP", Frame.ScrollFrame, 0, (Frame.TitleHeader:GetHeight() + NS.Variables.PADDING))

					--------------------------------

					do -- MOUSE RESPONDER
						local SIZE = 50

						Frame.TitleHeader.MouseResponder = CreateFrame("Frame", "$parent.MouseResponder", Frame.TitleHeader)
						Frame.TitleHeader.MouseResponder:SetSize(SIZE, SIZE)
						Frame.TitleHeader.MouseResponder:SetPoint("BOTTOMRIGHT", Frame.TitleHeader, SIZE / 4, -SIZE / 4)
					end

					do -- EVENTS
						local function UpdateSize()
							Frame.TitleHeader:SetSize(Frame:GetWidth() - 20, (Frame:GetWidth() - 20) * .14)
							Frame.TitleHeader:SetPoint("TOP", Frame.ScrollFrame, 0, (Frame.TitleHeader:GetHeight() + NS.Variables.PADDING))
						end

						Frame:HookScript("OnSizeChanged", UpdateSize)
					end
				end

				do -- STORYLINE
					local PADDING = NS.Variables:RATIO(9)

					Frame.Storyline = CreateFrame("Frame", "$parent.Storyline", Frame)
					Frame.Storyline:SetPoint("BOTTOMLEFT", Frame.TitleHeader, 45, 17.5)
					Frame.Storyline:SetFrameLevel(4)

					--------------------------------

					do -- BACKGROUND
						Frame.Storyline.Background, Frame.Storyline.BackgroundTexture = addon.API.FrameTemplates:CreateNineSlice(Frame.Storyline, "HIGH", NS.Variables.THEME.INSCRIBED_BACKGROUND, 25, .5, "$parent.Background")
						Frame.Storyline.Background:SetAllPoints(Frame.Storyline, true)
						Frame.Storyline.Background:SetFrameLevel(3)
						Frame.Storyline.Background:SetAlpha(.25)
					end

					do -- CONTENT
						Frame.Storyline.Content = CreateFrame("Frame", "$parent.Content", Frame.Storyline)
						Frame.Storyline.Content:SetPoint("TOPLEFT", Frame.Storyline, PADDING, -PADDING)
						Frame.Storyline.Content:SetPoint("BOTTOMRIGHT", Frame.Storyline, -PADDING, PADDING)
						Frame.Storyline.Content:SetFrameLevel(5)

						----------------------------------

						do -- TEXT
							Frame.Storyline.Content.Text = addon.API.FrameTemplates:CreateText(Frame.Storyline.Content, addon.Theme.RGB_WHITE, CONTENT_TEXT_SIZE, "LEFT", "MIDDLE", addon.API.Fonts.Content_Light)
							Frame.Storyline.Content.Text:SetAllPoints(Frame.Storyline.Content, true)
						end
					end

					do -- EVENTS
						local function UpdateSize()
							Frame.Storyline:SetSize(PADDING + Frame.Storyline.Content.Text:GetStringWidth() + PADDING, 27.5)
						end
						UpdateSize()

						Frame:HookScript("OnSizeChanged", UpdateSize)
						hooksecurefunc(Frame.Storyline.Content.Text, "SetText", UpdateSize)
					end
				end

				do -- OBJECTIVES
					do -- HEADER
						Frame.Objectives_Header = CreateHeader(SCROLL_FRAME)
						Frame.Objectives_Header.Label:SetText(L["InteractionQuestFrame - Objectives"])

						--------------------------------

						RegisterElement(Frame.Objectives_Header, "Header")
					end

					do -- TEXT
						Frame.Objectives_Text = addon.API.FrameTemplates:CreateText(SCROLL_FRAME, addon.Theme.RGB_WHITE, CONTENT_TEXT_SIZE, "LEFT", "TOP", addon.API.Fonts.Content_Light)
						Frame.Objectives_Text:SetAlpha(.75)

						--------------------------------

						SetAutoTextHeight(Frame.Objectives_Text)
						RegisterElement(Frame.Objectives_Text, "Text")
					end
				end

				do -- REWARDS
					do -- HEADER
						Frame.Rewards_Header = CreateHeader(SCROLL_FRAME)
						Frame.Rewards_Header.Label:SetText(L["InteractionQuestFrame - Rewards"])

						--------------------------------

						RegisterElement(Frame.Rewards_Header, "Header")
					end

					--------------------------------

					do -- EXPERIENCE TEXT
						Frame.Rewards_Experience = CreateRewardText(SCROLL_FRAME)

						--------------------------------

						RegisterElement(Frame.Rewards_Experience, "RewardText")
					end

					do -- CURRENCY TEXT
						Frame.Rewards_Currency = CreateRewardText(SCROLL_FRAME)

						--------------------------------

						RegisterElement(Frame.Rewards_Currency, "RewardText")
					end

					do -- HONOR TEXT
						Frame.Rewards_Honor = CreateRewardText(SCROLL_FRAME)

						--------------------------------

						RegisterElement(Frame.Rewards_Honor, "RewardText")
					end

					do -- CHOICE
						do -- CHOICE
							Frame.Rewards_Choice = addon.API.FrameTemplates:CreateText(SCROLL_FRAME, addon.Theme.RGB_WHITE, CONTENT_TEXT_SIZE, "LEFT", "TOP", addon.API.Fonts.Content_Light)
							Frame.Rewards_Choice:SetAlpha(.75)

							--------------------------------

							SetAutoTextHeight(Frame.Rewards_Choice)
							RegisterElement(Frame.Rewards_Choice, "Text")
						end

						do -- CHOICE BUTTONS
							local buttons = {}
							for i = 1, 10 do
								local Button = CreateReward(SCROLL_FRAME, true)

								--------------------------------

								RegisterElement(Button, "Button")

								--------------------------------

								table.insert(buttons, Button)
							end

							--------------------------------

							NS.Variables.Buttons_Choice = buttons
						end
					end

					do -- RECEIVE
						do -- TEXT
							Frame.Rewards_Receive = addon.API.FrameTemplates:CreateText(SCROLL_FRAME, addon.Theme.RGB_WHITE, CONTENT_TEXT_SIZE, "LEFT", "TOP", addon.API.Fonts.Content_Light)
							Frame.Rewards_Receive:SetAlpha(.75)

							--------------------------------

							SetAutoTextHeight(Frame.Rewards_Receive)
							RegisterElement(Frame.Rewards_Receive, "Text")
						end

						do -- RECEIVE BUTTONS
							local buttons = {}
							for i = 1, 10 do
								local Button = CreateReward(SCROLL_FRAME, false)

								--------------------------------

								RegisterElement(Button, "Button")

								--------------------------------

								table.insert(buttons, Button)
							end

							--------------------------------

							NS.Variables.Buttons_Reward = buttons
						end
					end

					do -- SPELL
						do -- TEXT
							Frame.Rewards_Spell = addon.API.FrameTemplates:CreateText(SCROLL_FRAME, addon.Theme.RGB_WHITE, CONTENT_TEXT_SIZE, "LEFT", "TOP", addon.API.Fonts.Content_Light)
							Frame.Rewards_Spell:SetAlpha(.75)

							--------------------------------

							SetAutoTextHeight(Frame.Rewards_Spell)
							RegisterElement(Frame.Rewards_Spell, "Text")
						end

						do -- SPELL BUTTONS
							local buttons = {}
							for i = 1, 10 do
								local Button = CreateReward(SCROLL_FRAME, false)

								--------------------------------

								RegisterElement(Button, "Button")

								--------------------------------

								table.insert(buttons, Button)
							end

							--------------------------------

							NS.Variables.Buttons_Spell = buttons
						end
					end
				end

				do -- PROGRESS
					do -- HEADER
						Frame.Progress_Header = CreateHeader(SCROLL_FRAME)
						Frame.Progress_Header.Label:SetText(L["InteractionQuestFrame - Required Items"])

						--------------------------------

						RegisterElement(Frame.Progress_Header, "Header")
					end

					do -- REQUIRED ITEM BUTTONS
						local buttons = {}
						for i = 1, 10 do
							local Button = CreateReward(SCROLL_FRAME, false)

							--------------------------------

							RegisterElement(Button, "Button")

							--------------------------------

							table.insert(buttons, Button)
						end

						--------------------------------

						NS.Variables.Buttons_Required = buttons
					end
				end
			end

			do -- EVENTS
				local function UpdateSize()
					Frame.Background:ClearAllPoints()
					Frame.Background:SetPoint("TOPLEFT", Frame, (-57.5 * NS.Variables.ScaleModifier), (65 * NS.Variables.ScaleModifier))
					Frame.Background:SetPoint("BOTTOMRIGHT", Frame, (57.5 * NS.Variables.ScaleModifier), (-70 * NS.Variables.ScaleModifier))

					Frame.Border:ClearAllPoints()
					Frame.Border:SetPoint("TOPLEFT", Frame, (-57.5 * NS.Variables.ScaleModifier), (65 * NS.Variables.ScaleModifier))
					Frame.Border:SetPoint("BOTTOMRIGHT", Frame, (57.5 * NS.Variables.ScaleModifier), (-70 * NS.Variables.ScaleModifier))

					Frame.ContextIcon:SetScale(1 * NS.Variables.ScaleModifier)

					Frame.Background.ScrollFrameIndicator:SetSize(Frame:GetWidth() - 50, (Frame:GetWidth() - 50) * .25)
					Frame.ButtonContainer:SetWidth(Frame:GetWidth() - NS.Variables:RATIO(7))
					Frame.ScrollFrame:SetSize(Frame:GetWidth() - NS.Variables:RATIO(5.5), Frame:GetHeight() - 70 - 35)
				end

				Frame:HookScript("OnSizeChanged", UpdateSize)
			end
		end
	end

	--------------------------------
	-- REFERENCES
	--------------------------------

	local Frame = InteractionQuestFrame
	local Callback = NS.Script

	--------------------------------
	-- SETUP
	--------------------------------

	do
		Frame:Hide()
		Frame.hidden = true
	end
end
