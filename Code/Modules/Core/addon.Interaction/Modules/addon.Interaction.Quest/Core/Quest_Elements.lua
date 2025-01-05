local addonName, addon = ...
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
			InteractionQuestParent:SetSize(addon.API:GetScreenWidth(), addon.API:GetScreenHeight())
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

				hooksecurefunc(Frame, "SetHeight", UpdateSize)
				hooksecurefunc(Frame, "SetWidth", UpdateSize)
				hooksecurefunc(Frame, "SetSize", UpdateSize)

				--------------------------------

				do -- BACKGROUND
					Frame.Background, Frame.BackgroundTexture = AdaptiveAPI.FrameTemplates:CreateTexture(Frame, "HIGH", nil)
					Frame.Background:SetFrameStrata("HIGH")
					Frame.Background:SetFrameLevel(2)

					--------------------------------

					addon.API:RegisterThemeUpdate(function()
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
					Frame.Border, Frame.BorderTexture = AdaptiveAPI.FrameTemplates:CreateTexture(Frame, "HIGH", nil)
					Frame.Border:SetFrameStrata("HIGH")
					Frame.Border:SetFrameLevel(3)

					--------------------------------

					addon.API:RegisterThemeUpdate(function()
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
					Frame.Background.ScrollFrameIndicator, Frame.Background.ScrollFrameIndicatorTexture = AdaptiveAPI.FrameTemplates:CreateTexture(Frame, "HIGH", nil)
					Frame.Background.ScrollFrameIndicator:SetPoint("BOTTOM", Frame, 0, 42.5)
					Frame.Background.ScrollFrameIndicator:SetFrameLevel(500)
					Frame.Background.ScrollFrameIndicator:SetAlpha(.25)

					--------------------------------

					addon.API:RegisterThemeUpdate(function()
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

					AdaptiveAPI.FrameTemplates.Styles:Button(button, {
						defaultTexture = AdaptiveAPI.Presets.NINESLICE_INSCRIBED_FILLED_HIGHLIGHT,
						highlightTexture = AdaptiveAPI.Presets.NINESLICE_INSCRIBED_FILLED_HIGHLIGHT,
						edgeSize = 25,
						scale = .5,
						playAnimation = false,
						customColor = color,
						customHighlightColor = highlightColor,
						customTextColor = addon.Theme.RGB_WHITE,
					})

					--------------------------------

					addon.API:RegisterThemeUpdate(function()
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

						AdaptiveAPI.FrameTemplates.Styles:UpdateButton(button, {
							customColor = FilledColor,
							customHighlightColor = FilledHighlightColor
						})
					end, 3)

					--------------------------------

					return button
				end

				--------------------------------

				do -- ACCEPT
					Frame.ButtonContainer.AcceptButton = CreateButton("$parent.AcceptButton", addon.Theme.Quest.Secondary_LightTheme, addon.Theme.Quest.Primary_LightTheme, addon.Theme.Quest.Highlight_Secondary_DarkTheme, addon.Theme.Quest.Highlight_Primary_DarkTheme)
					Frame.ButtonContainer.AcceptButton:SetSize(NS.Variables:RATIO(3), Frame.ButtonContainer:GetHeight())
					Frame.ButtonContainer.AcceptButton:SetPoint("LEFT", Frame.ButtonContainer)
				end

				do -- CONTINUE
					Frame.ButtonContainer.ContinueButton = CreateButton("$parent.ContinueButton", addon.Theme.Quest.Secondary_LightTheme, addon.Theme.Quest.Primary_LightTheme, addon.Theme.Quest.Highlight_Secondary_DarkTheme, addon.Theme.Quest.Highlight_Primary_DarkTheme)
					Frame.ButtonContainer.ContinueButton:SetSize(NS.Variables:RATIO(3), Frame.ButtonContainer:GetHeight())
					Frame.ButtonContainer.ContinueButton:SetPoint("LEFT", Frame.ButtonContainer)
				end

				do -- COMPLETE
					Frame.ButtonContainer.CompleteButton = CreateButton("$parent.CompleteButton", addon.Theme.Quest.Secondary_LightTheme, addon.Theme.Quest.Primary_LightTheme, addon.Theme.Quest.Highlight_Secondary_DarkTheme, addon.Theme.Quest.Highlight_Primary_DarkTheme)
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
				Frame.ScrollFrame, Frame.ScrollChildFrame = AdaptiveAPI.FrameTemplates:CreateScrollFrame(Frame)
				Frame.ScrollFrame:SetPoint("BOTTOM", Frame, 0, 65)

				--------------------------------

				do -- SCROLL BAR
					Frame.ScrollFrame.ScrollBar:Hide()
				end
			end

			do -- CONTEXT ICON
				Frame.ContextIcon = CreateFrame("Frame", "$parent.ContextIcon", Frame)
				Frame.ContextIcon:SetSize(NS.Variables:RATIO(3), NS.Variables:RATIO(3))
				Frame.ContextIcon:SetPoint("TOPLEFT", Frame, -Frame.ContextIcon:GetWidth() * .575, Frame.ContextIcon:GetHeight() * .5975)
				Frame.ContextIcon:SetFrameStrata("HIGH")
				Frame.ContextIcon:SetFrameLevel(10)

				AdaptiveAPI:AnchorToCenter(Frame.ContextIcon)

				--------------------------------

				do -- BACKGROUND
					Frame.ContextIcon.Background, Frame.ContextIcon.BackgroundTexture = AdaptiveAPI.FrameTemplates:CreateTexture(Frame.ContextIcon, "HIGH", nil, "$parent.Background")
					Frame.ContextIcon.Background:SetAllPoints(Frame.ContextIcon, true)
					Frame.ContextIcon.Background:SetFrameStrata("HIGH")
					Frame.ContextIcon.Background:SetFrameLevel(9)

					--------------------------------

					addon.API:RegisterThemeUpdate(function()
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
					Frame.ContextIcon.Label = AdaptiveAPI.FrameTemplates:CreateText(Frame.ContextIcon, addon.Theme.RGB_WHITE, 35, "CENTER", "MIDDLE", AdaptiveAPI.Fonts.Title_Bold, "$parent.Label")
					Frame.ContextIcon.Label:SetAllPoints(Frame.ContextIcon, true)
				end
			end

			do -- CONTENT
				local SCROLL_FRAME = Frame.ScrollChildFrame

				local textSize_Title = 25
				local textSize_Content = 15
				local textSize_Tooltip = 12.5
				local textSize_Reward = 15

				--------------------------------

				SCROLL_FRAME.Elements = {}

				--------------------------------

				local function CreateHeader(parent)
					local Header = CreateFrame("Frame", "$parent.Header", parent)
					Header:SetSize(SCROLL_FRAME:GetWidth(), NS.Variables:RATIO(5.25))

					--------------------------------

					do -- BACKGROUND
						Header.Background, Header.BackgroundTexture = AdaptiveAPI.FrameTemplates:CreateNineSlice(Header, "HIGH", NS.Variables.THEME.INSCRIBED_HEADER, 86, .125, "$parent.Header", Enum.UITextureSliceMode.Stretched)
						Header.Background:SetPoint("TOPLEFT", Header, -3.75, 2.5)
						Header.Background:SetPoint("BOTTOMRIGHT", Header, 3.75, -2.5)
					end

					do -- TEXT
						Header.Label = AdaptiveAPI.FrameTemplates:CreateText(Header, { r = 1, g = 1, b = 1 }, 15, "LEFT", "MIDDLE", AdaptiveAPI.Fonts.Content_Light)
						Header.Label:SetSize(Header:GetWidth() - NS.Variables:RATIO(6.5), Header:GetHeight() - NS.Variables:RATIO(6.5))
						Header.Label:SetPoint("CENTER", Header)
						Header.Label:SetAlpha(.75)
					end

					do -- EVENTS
						local function UpdateSize()
							Header:SetSize(SCROLL_FRAME:GetWidth(), NS.Variables:RATIO(5.25))
							Header.Label:SetSize(Header:GetWidth() - NS.Variables:RATIO(6.5), Header:GetHeight() - NS.Variables:RATIO(6.5))
						end

						hooksecurefunc(SCROLL_FRAME, "SetHeight", UpdateSize)
						hooksecurefunc(SCROLL_FRAME, "SetWidth", UpdateSize)
						hooksecurefunc(SCROLL_FRAME, "SetSize", UpdateSize)
					end

					--------------------------------

					return Header
				end

				local function CreateRewardText(parent)
					local Background, BackgroundTexture = AdaptiveAPI.FrameTemplates:CreateNineSlice(parent, "HIGH", nil, 50, 3.25, "$parent.Background")
					Background:SetSize(SCROLL_FRAME:GetWidth(), NS.Variables:RATIO(6.5))

					addon.API:RegisterThemeUpdate(function()
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
						Background.Text = AdaptiveAPI.FrameTemplates:CreateText(Background, { r = 1, g = 1, b = 1 }, textSize_Content, "LEFT", "MIDDLE", AdaptiveAPI.Fonts.Content_Light, "$parent.Label")
						Background.Text:SetSize(Background:GetWidth(), Background:GetHeight() - NS.Variables:RATIO(7.5))
						Background.Text:SetPoint("CENTER", Background)
						Background.Text:SetAlpha(.75)
					end

					do -- EVENTS
						local function UpdateSize()
							Background:SetSize(SCROLL_FRAME:GetWidth(), NS.Variables:RATIO(6.5))
							Background.Text:SetSize(Background:GetWidth(), Background:GetHeight() - NS.Variables:RATIO(7.5))
						end

						hooksecurefunc(SCROLL_FRAME, "SetHeight", UpdateSize)
						hooksecurefunc(SCROLL_FRAME, "SetWidth", UpdateSize)
						hooksecurefunc(SCROLL_FRAME, "SetSize", UpdateSize)
					end

					--------------------------------

					return Background, Background.Text
				end

				local function CreateReward(parent, selectable)
					local PADDING = NS.Variables:RATIO(9.5)
					local TEXT_PADDING = NS.Variables:RATIO(7.5)

					--------------------------------

					local Button = CreateFrame("Frame", nil, parent)
					Button:SetSize(parent:GetWidth(), NS.Variables:RATIO(5.5))
					Button:SetPoint("CENTER", parent)

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
									AdaptiveAPI.Animation:Fade(Button, .25, currentAlpha, targetAlpha, AdaptiveAPI.Animation.EaseExpo)
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
								Frame.SetChoiceSelected(Button)
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
							GameTooltip.RewardButton = Button

							--------------------------------

							if Button.Callback then
								-- Lua Taint?
								-- Blizzard GameTooltip Code

								GameTooltip:SetOwner(Button, "ANCHOR_TOPRIGHT", 0, 0);

								if (Button.Type == "spell") then
									if (Button.Callback.factionID) then
										local wrapText = false
										GameTooltip_SetTitle(GameTooltip, QUEST_REPUTATION_REWARD_TITLE:format(Button.Callback.factionName), HIGHLIGHT_FONT_COLOR, wrapText)
										if C_Reputation.IsAccountWideReputation(Button.Callback.factionID) then
											GameTooltip_AddColoredLine(GameTooltip, REPUTATION_TOOLTIP_ACCOUNT_WIDE_LABEL, ACCOUNT_WIDE_FONT_COLOR)
										end
										GameTooltip_AddNormalLine(GameTooltip, QUEST_REPUTATION_REWARD_TOOLTIP:format(Button.Callback.rewardAmount, Button.Callback.factionName))
									else
										GameTooltip:SetSpellByID(Button.Callback.rewardSpellID)
									end
								elseif (Button.Callback.objectType == "item") then
									GameTooltip:SetQuestItem(Button.Callback.type, Button.Callback:GetID())
									GameTooltip_ShowCompareItem(GameTooltip)
								elseif (Button.Callback.objectType == "currency") then
									GameTooltip:SetQuestCurrency(Button.Callback.type, Button.Callback:GetID())
								end

								if (Button.Callback.rewardContextLine) then
									GameTooltip_AddBlankLineToTooltip(GameTooltip)
									GameTooltip_AddColoredLine(GameTooltip, Button.Callback.rewardContextLine, QUEST_REWARD_CONTEXT_FONT_COLOR)
								end

								GameTooltip:Show()
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
							GameTooltip.RewardButton = nil

							--------------------------------

							GameTooltip:Hide()
							addon.BlizzardGameTooltip.Script:StopCustom()
							InteractionQuestFrame.UpdateGameTooltip()

							--------------------------------

							if Button.Callback then
								GameTooltip:Hide()
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
							Button.Background, Button.BackgroundTexture = AdaptiveAPI.FrameTemplates:CreateNineSlice(Button, "HIGH", NS.Variables.THEME.INSCRIBED_BACKGROUND, 50, 3.25, "$parent.Background")
							Button.Background:SetSize(Button:GetWidth() + 2.5, Button:GetHeight() + 2.5)
							Button.Background:SetPoint("CENTER", Button, 0, 0)
							Button.Background:SetFrameStrata("HIGH")
							Button.Background:SetFrameLevel(1)
						end

						do -- IMAGE
							Button.Image = CreateFrame("Frame", "$parent.Image", Button)
							Button.Image:SetSize(Button:GetHeight(), Button:GetHeight())
							Button.Image:SetPoint("LEFT", Button)
							Button.Image:SetFrameLevel(2)

							--------------------------------

							do -- BACKGROUND
								Button.Image.Background, Button.Image.BackgroundTexture = AdaptiveAPI.FrameTemplates:CreateTexture(Button.Image, "HIGH", AdaptiveAPI.Presets.BASIC_SQUARE, "$parent.Background")
								Button.Image.Background:SetSize(Button.Image:GetWidth(), Button.Image:GetHeight())
								Button.Image.Background:SetPoint("CENTER", Button.Image)
								Button.Image.Background:SetFrameLevel(3)
							end

							do -- ICON
								Button.Image.Icon, Button.Image.IconTexture = AdaptiveAPI.FrameTemplates:CreateTexture(Button.Image, "HIGH", nil, "$parent.Texture")
								Button.Image.Icon:SetSize(Button.Image:GetWidth() - PADDING, Button.Image:GetHeight() - PADDING)
								Button.Image.Icon:SetPoint("CENTER", Button.Image)
								Button.Image.Icon:SetFrameLevel(4)
								Button.Image.IconTexture:SetSize(Button.Image.Icon:GetWidth(), Button.Image.Icon:GetHeight())
								Button.Image.IconTexture:SetPoint("CENTER", Button.Image.Icon)
								Button.Image.IconTexture:SetTexCoord(.15, .85, .15, .85)
							end

							do -- TEXT
								Button.Image.LabelFrame = CreateFrame("Frame", "$parent.LabelFrame", Button.Image)
								Button.Image.LabelFrame:SetSize(Button.Image:GetWidth() - PADDING, Button.Image:GetHeight() / (addon.Variables.GOLDEN_RATIO ^ 2))
								Button.Image.LabelFrame:SetPoint("BOTTOM", Button.Image, 0, PADDING / 2)
								Button.Image.LabelFrame:SetFrameLevel(6)

								--------------------------------

								do -- BACKGROUND
									Button.Image.LabelFrame.Background, Button.Image.LabelFrame.BackgroundTexture = AdaptiveAPI.FrameTemplates:CreateTexture(Button.Image.LabelFrame, "HIGH", AdaptiveAPI.Presets.BASIC_SQUARE, "$parent.Background")
									Button.Image.LabelFrame.Background:SetSize(Button.Image.LabelFrame:GetWidth(), Button.Image.LabelFrame:GetHeight())
									Button.Image.LabelFrame.Background:SetPoint("CENTER", Button.Image.LabelFrame)
									Button.Image.LabelFrame.Background:SetFrameLevel(5)
									Button.Image.LabelFrame.BackgroundTexture:SetVertexColor(.1, .1, .1, .825)
								end

								do -- LABEL
									Button.Image.LabelFrame.Label = AdaptiveAPI.FrameTemplates:CreateText(Button.Image.LabelFrame, { r = 1, g = 1, b = 1 }, textSize_Tooltip, "CENTER", "MIDDLE", AdaptiveAPI.Fonts.Content_Light, "$parent.Label")
									Button.Image.LabelFrame.Label:SetSize(Button.Image.LabelFrame:GetWidth(), Button.Image.LabelFrame:GetHeight())
									Button.Image.LabelFrame.Label:SetPoint("CENTER", Button.Image.LabelFrame)
								end
							end
						end

						do -- LABEL
							Button.Label = AdaptiveAPI.FrameTemplates:CreateText(Button, { r = 1, g = 1, b = 1 }, 15, "LEFT", "MIDDLE", AdaptiveAPI.Fonts.Content_Light)
							Button.Label:SetSize(Button:GetWidth() - TEXT_PADDING - Button.Image:GetWidth() - TEXT_PADDING, Button:GetHeight())
							Button.Label:SetPoint("LEFT", Button, Button.Image:GetWidth() + TEXT_PADDING, 0)
							Button.Label:SetAlpha(.75)
						end

						do -- HIGHLIGHT
							Button.Highlight = CreateFrame("Frame", "$parent.Highlight", Button)
							Button.Highlight:SetAllPoints(Button, true)
							Button.Highlight:SetFrameStrata("HIGH")
							Button.Highlight:SetFrameLevel(5)

							--------------------------------

							do -- BACKGROUND
								Button.Highlight.Background, Button.Highlight.BackgroundTexture = AdaptiveAPI.FrameTemplates:CreateTexture(Button.Highlight, "HIGH", NS.Variables.QUEST_PATH .. "reward-highlight-add.png", "$parent.Texture")
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

								AdaptiveAPI.Animation:Fade(Button.Highlight, .075, Button.Highlight:GetAlpha(), 1, AdaptiveAPI.Animation.EaseExpo, function() return not Button.MouseOver end)
							end

							Button.Leave = function()
								Button.MouseOver = false

								--------------------------------

								AdaptiveAPI.Animation:Fade(Button.Highlight, .075, Button.Highlight:GetAlpha(), 0, AdaptiveAPI.Animation.EaseSine, function() return Button.MouseOver end)
							end

							--------------------------------

							Button.Highlight:SetAlpha(0)
						end

						do -- EVENTS
							CallbackRegistry:Add("START_QUEST", function() Button.SetStateAuto() end, 0)
							CallbackRegistry:Add("QUEST_REWARD_SELECTED", function() Button.SetStateAuto() end, 0)

							--------------------------------

							addon.API:RegisterThemeUpdate(function()
								Button.UpdateState()
							end, 10)
						end
					end

					do -- EVENTS
						local function UpdateSize()
							Button:SetSize(parent:GetWidth(), NS.Variables:RATIO(5.5))
							Button.Background:SetSize(Button:GetWidth() + 2.5, Button:GetHeight() + 2.5)
							Button.Image:SetSize(Button:GetHeight(), Button:GetHeight())
							Button.Image.Background:SetSize(Button.Image:GetWidth(), Button.Image:GetHeight())
							Button.Image.Icon:SetSize(Button.Image:GetWidth() - PADDING, Button.Image:GetHeight() - PADDING)
							Button.Image.LabelFrame:SetSize(Button.Image:GetWidth() - PADDING, Button.Image:GetHeight() / (addon.Variables.GOLDEN_RATIO ^ 2))
							Button.Image.LabelFrame.Background:SetSize(Button.Image.LabelFrame:GetWidth(), Button.Image.LabelFrame:GetHeight())
							Button.Image.LabelFrame.Label:SetSize(Button.Image.LabelFrame:GetWidth(), Button.Image.LabelFrame:GetHeight())
							Button.Label:SetSize(Button:GetWidth() - TEXT_PADDING - Button.Image:GetWidth() - TEXT_PADDING, Button:GetHeight())
						end

						hooksecurefunc(parent, "SetHeight", UpdateSize)
						hooksecurefunc(parent, "SetWidth", UpdateSize)
						hooksecurefunc(parent, "SetSize", UpdateSize)
					end

					--------------------------------

					return Button
				end

				local function SetAutoTextHeight(frame, customWidthModifier)
					local function Update()
						frame:SetWidth(Frame.ScrollChildFrame:GetWidth() * (customWidthModifier or 1))
						frame:SetHeight(100)
					end

					Update()

					--------------------------------

					hooksecurefunc(frame, "SetText", Update)
				end

				local function RegisterElement(frame, type)
					frame.type = type
					table.insert(Frame.ScrollChildFrame.Elements, frame)
				end

				--------------------------------

				do -- TITLE
					Frame.Title = AdaptiveAPI.FrameTemplates:CreateText(Frame, addon.Theme.RGB_WHITE, textSize_Title, "LEFT", "TOP", AdaptiveAPI.Fonts.Title_Bold)
					Frame.Title:SetPoint("TOPLEFT", Frame, 55, NS.Variables:RATIO(7))

					--------------------------------

					SetAutoTextHeight(Frame.Title, .85)
				end

				do -- TITLE HEADER
					Frame.TitleHeader, Frame.TitleHeaderTexture = AdaptiveAPI.FrameTemplates:CreateTexture(Frame, "HIGH", nil, "$parent.TitleHeader")
					Frame.TitleHeader:SetSize(Frame:GetWidth() - 20, (Frame:GetWidth() - 20) * .14)
					Frame.TitleHeader:SetPoint("TOP", Frame.ScrollFrame, 0, (Frame.TitleHeader:GetHeight() + NS.Variables.PADDING))

					--------------------------------

					do -- EVENTS
						local function UpdateSize()
							Frame.TitleHeader:SetSize(Frame:GetWidth() - 20, (Frame:GetWidth() - 20) * .14)
							Frame.TitleHeader:SetPoint("TOP", Frame.ScrollFrame, 0, (Frame.TitleHeader:GetHeight() + NS.Variables.PADDING))
						end

						hooksecurefunc(Frame, "SetHeight", UpdateSize)
						hooksecurefunc(Frame, "SetWidth", UpdateSize)
						hooksecurefunc(Frame, "SetSize", UpdateSize)
					end
				end

				do -- STORYLINE
					Frame.Storyline = CreateFrame("Frame", "$parent.Storyline", Frame)
					Frame.Storyline:SetSize(Frame.ScrollChildFrame:GetWidth(), 15)
					Frame.Storyline:SetPoint("BOTTOM", Frame.TitleHeader, 33.75, 20)

					--------------------------------

					do -- TEXT
						Frame.Storyline.Text = AdaptiveAPI.FrameTemplates:CreateText(Frame.Storyline, addon.Theme.RGB_WHITE, textSize_Content, "LEFT", "MIDDLE", AdaptiveAPI.Fonts.Title_Medium)
						Frame.Storyline.Text:SetAllPoints(Frame.Storyline, true)
					end

					do -- EVENTS
						local function UpdateSize()
							Frame.Storyline:SetSize(Frame.ScrollChildFrame:GetWidth(), 15)
						end

						hooksecurefunc(Frame, "SetHeight", UpdateSize)
						hooksecurefunc(Frame, "SetWidth", UpdateSize)
						hooksecurefunc(Frame, "SetSize", UpdateSize)
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
						Frame.Objectives_Text = AdaptiveAPI.FrameTemplates:CreateText(SCROLL_FRAME, addon.Theme.RGB_WHITE, textSize_Content, "LEFT", "TOP", AdaptiveAPI.Fonts.Content_Light)
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
							Frame.Rewards_Choice = AdaptiveAPI.FrameTemplates:CreateText(SCROLL_FRAME, addon.Theme.RGB_WHITE, textSize_Content, "LEFT", "TOP", AdaptiveAPI.Fonts.Content_Light)
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
							Frame.Rewards_Receive = AdaptiveAPI.FrameTemplates:CreateText(SCROLL_FRAME, addon.Theme.RGB_WHITE, textSize_Content, "LEFT", "TOP", AdaptiveAPI.Fonts.Content_Light)
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
							Frame.Rewards_Spell = AdaptiveAPI.FrameTemplates:CreateText(SCROLL_FRAME, addon.Theme.RGB_WHITE, textSize_Content, "LEFT", "TOP", AdaptiveAPI.Fonts.Content_Light)
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
