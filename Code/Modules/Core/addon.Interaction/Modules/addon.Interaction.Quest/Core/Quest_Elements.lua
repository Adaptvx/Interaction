-- [!] [addon.Interaction.Quest] is a replacement for Blizzard's Quest Frame.
-- [Quest_Elements.lua] is the front-end (UI)
-- for the custom Quest Frame.

---@class addon
local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local PrefabRegistry = addon.PrefabRegistry
local L = addon.Locales
local NS = addon.Interaction.Quest; addon.Interaction.Quest = NS

--------------------------------

NS.Elements = {}

--------------------------------

function NS.Elements:Load()
	--------------------------------
	-- CREATE ELEMENTS
	--------------------------------

	do
		do -- ELEMENTS
			InteractionFrame.QuestParent = CreateFrame("Frame", "$parent.QuestParent", InteractionFrame)
			InteractionFrame.QuestParent:SetAllPoints(InteractionFrame)
			InteractionFrame.QuestParent:SetFrameStrata(NS.Variables.FRAME_STRATA)
			InteractionFrame.QuestParent:SetFrameLevel(NS.Variables.FRAME_LEVEL)

			InteractionFrame.QuestFrame = CreateFrame("Frame", "$parent.QuestFrame", InteractionFrame.QuestParent)
			InteractionFrame.QuestFrame:SetSize(NS.Variables.FRAME_SIZE.x, NS.Variables.FRAME_SIZE.y)
			InteractionFrame.QuestFrame:SetPoint("CENTER", nil)
			InteractionFrame.QuestFrame:SetFrameStrata(NS.Variables.FRAME_STRATA)
			InteractionFrame.QuestFrame:SetFrameLevel(NS.Variables.FRAME_LEVEL)

            local Frame = InteractionFrame.QuestFrame

			--------------------------------

			local TITLE_TEXT_SIZE = 25
			local CONTENT_TEXT_SIZE = 15
			local TOOLTIP_TEXT_SIZE = 12.5

			local PADDING = NS.Variables:RATIO(7.5)
			local FRAME_MAIN_INSET_WIDTH = 37.5
			local FRAME_MAIN_INSET_HEIGHT = PADDING
			local FRAME_FOOTER_HEIGHT = 55

			do -- BACKGROUND
				do -- BACKGROUND
					Frame.Background, Frame.BackgroundTexture = addon.API.FrameTemplates:CreateTexture(Frame, "HIGH", nil)
					Frame.Background:SetFrameStrata(NS.Variables.FRAME_STRATA)
					Frame.Background:SetFrameLevel(NS.Variables.FRAME_LEVEL + 1)

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
					Frame.Border:SetFrameStrata(NS.Variables.FRAME_STRATA)
					Frame.Border:SetFrameLevel(NS.Variables.FRAME_LEVEL + 2)

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
			end

			do -- CONTEXT ICON
				Frame.ContextIcon = CreateFrame("Frame", "$parent.ContextIcon", Frame)
				Frame.ContextIcon:SetSize(NS.Variables:RATIO(3), NS.Variables:RATIO(3))
				Frame.ContextIcon:SetPoint("TOPLEFT", Frame, -Frame.ContextIcon:GetWidth() * .5625, Frame.ContextIcon:GetHeight() * .5875)
				Frame.ContextIcon:SetFrameStrata(NS.Variables.FRAME_STRATA)
				Frame.ContextIcon:SetFrameLevel(NS.Variables.FRAME_LEVEL + 10)
				addon.API.FrameUtil:AnchorToCenter(Frame.ContextIcon)

				local ContextIcon = Frame.ContextIcon

				--------------------------------

				do -- BACKGROUND
					ContextIcon.Background, ContextIcon.BackgroundTexture = addon.API.FrameTemplates:CreateTexture(ContextIcon, NS.Variables.FRAME_STRATA, nil, "$parent.Background")
					ContextIcon.Background:SetAllPoints(ContextIcon, true)
					ContextIcon.Background:SetFrameStrata("HIGH")
					ContextIcon.Background:SetFrameLevel(NS.Variables.FRAME_LEVEL + 9)

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

						ContextIcon.BackgroundTexture:SetTexture(TEXTURE_Background)
					end, 5)
				end

				do -- TEXT
					ContextIcon.Text = addon.API.FrameTemplates:CreateText(ContextIcon, addon.Theme.RGB_WHITE, 35, "CENTER", "MIDDLE", addon.API.Fonts.TITLE_BOLD, "$parent.Text")
					ContextIcon.Text:SetPoint("TOPLEFT", ContextIcon, 1, -1)
					ContextIcon.Text:SetPoint("BOTTOMRIGHT", ContextIcon, 1, -1)
				end
			end

			do -- CONTENT
				Frame.Content = CreateFrame("Frame", "$parent.Content", Frame)
				Frame.Content:SetPoint("CENTER", Frame, 0, -7.5)
				Frame.Content:SetFrameStrata(NS.Variables.FRAME_STRATA)
				Frame.Content:SetFrameLevel(NS.Variables.FRAME_LEVEL + 5)
				addon.API.FrameUtil:SetDynamicSize(Frame.Content, Frame, 0, 0)

				local Content = Frame.Content

				--------------------------------

				do -- LAYOUT GROUP
					Content.LayoutGroup, Content.LayoutGroup_Sort = addon.API.FrameTemplates:CreateLayoutGroup(Content, { point = "TOP", direction = "vertical", resize = false, padding = 0, distribute = false, distributeResizeElements = false, excludeHidden = true, autoSort = true, customOffset = nil, customLayoutSort = nil}, "$parent.LayoutGroup")
					Content.LayoutGroup:SetPoint("CENTER", Content)
					Content.LayoutGroup:SetFrameStrata(NS.Variables.FRAME_STRATA)
					Content.LayoutGroup:SetFrameLevel(NS.Variables.FRAME_LEVEL + 6)
					addon.API.FrameUtil:SetDynamicSize(Content.LayoutGroup, Content, 0, 0)
					CallbackRegistry:Add("LayoutGroupSort Quest.Content", Content.LayoutGroup_Sort)

					local LayoutGroup = Content.LayoutGroup

					--------------------------------

					do -- HEADER
						LayoutGroup.Header = CreateFrame("Frame", "$parent.Header", LayoutGroup)
						LayoutGroup.Header:SetFrameStrata(NS.Variables.FRAME_STRATA)
						LayoutGroup.Header:SetFrameLevel(NS.Variables.FRAME_LEVEL + 7)
						addon.API.FrameUtil:SetDynamicSize(LayoutGroup.Header, LayoutGroup, FRAME_MAIN_INSET_WIDTH, nil)
						LayoutGroup:AddElement(LayoutGroup.Header)

						local Header = LayoutGroup.Header

						--------------------------------

						local HEADER_WIDTH_INSET = NS.Variables:RATIO(5.75)
						local HEADER_HEIGHT_INSET_TOP = NS.Variables:RATIO(8.75)
						local HEADER_HEIGHT_INSET_BOTTOM = NS.Variables:RATIO(6.25)

						do -- CONTENT
							Header.Content = CreateFrame("Frame", "$parent.Content", Header)
							Header.Content:SetPoint("RIGHT", Header)
							Header.Content:SetFrameStrata(NS.Variables.FRAME_STRATA)
							Header.Content:SetFrameLevel(NS.Variables.FRAME_LEVEL + 8)
							addon.API.FrameUtil:SetDynamicSize(Header.Content, Header, HEADER_WIDTH_INSET, 0)

							local Header_Content = Header.Content

							--------------------------------

							do -- LAYOUT GROUP
								Header_Content.LayoutGroup, Header_Content.LayoutGroup_Sort = addon.API.FrameTemplates:CreateLayoutGroup(Header_Content, { point = "TOP", direction = "vertical", resize = true, padding = PADDING / 2, distribute = false, distributeResizeElements = false, excludeHidden = true, autoSort = true, customOffset = nil, customLayoutSort = nil }, "$parent.LayoutGroup")
								Header_Content.LayoutGroup:SetPoint("TOP", Header_Content, 0, -HEADER_HEIGHT_INSET_TOP)
								Header_Content.LayoutGroup:SetFrameStrata(NS.Variables.FRAME_STRATA)
								Header_Content.LayoutGroup:SetFrameLevel(NS.Variables.FRAME_LEVEL + 9)
								addon.API.FrameUtil:SetDynamicSize(Header_Content.LayoutGroup, Header_Content, 0, nil)
								addon.API.FrameUtil:SetDynamicSize(Header, Header_Content.LayoutGroup, nil, -HEADER_HEIGHT_INSET_BOTTOM)
								CallbackRegistry:Add("LayoutGroupSort Quest.Content.Header", Header_Content.LayoutGroup_Sort)

								local Header_LayoutGroup = Header_Content.LayoutGroup

								--------------------------------

								local STORYLINE_HEIGHT = NS.Variables:RATIO(6.25)

								do -- ELEMENTS
									do -- TITLE FRAME
										Header_LayoutGroup.TitleFrame = CreateFrame("Frame", "$parent.TitleFrame", Header_LayoutGroup)
										Header_LayoutGroup.TitleFrame:SetFrameStrata(NS.Variables.FRAME_STRATA)
										Header_LayoutGroup.TitleFrame:SetFrameLevel(NS.Variables.FRAME_LEVEL + 10)
										addon.API.FrameUtil:SetDynamicSize(Header_LayoutGroup.TitleFrame, Header_LayoutGroup, 0, nil)
										Header_LayoutGroup:AddElement(Header_LayoutGroup.TitleFrame)

										local TitleFrame = Header_LayoutGroup.TitleFrame

										--------------------------------

										do -- TEXT
											TitleFrame.Text = addon.API.FrameTemplates:CreateText(TitleFrame, addon.Theme.RGB_WHITE, TITLE_TEXT_SIZE, "LEFT", "TOP", addon.API.Fonts.CONTENT_LIGHT, "$parent.Text")
											TitleFrame.Text:SetPoint("LEFT", TitleFrame)
											addon.API.FrameUtil:SetDynamicTextSize(TitleFrame.Text, TitleFrame, nil, nil, nil, nil)
											addon.API.FrameUtil:SetDynamicSize(TitleFrame, TitleFrame.Text, nil, 0)
										end
									end

									do -- STORYLINE FRAME
										Header_LayoutGroup.StorylineFrame = CreateFrame("Frame", "$parent.StorylineFrame", Header_LayoutGroup)
										Header_LayoutGroup.StorylineFrame:SetHeight(STORYLINE_HEIGHT)
										Header_LayoutGroup.StorylineFrame:SetFrameStrata(NS.Variables.FRAME_STRATA)
										Header_LayoutGroup.StorylineFrame:SetFrameLevel(NS.Variables.FRAME_LEVEL + 10)
										addon.API.FrameUtil:SetDynamicSize(Header_LayoutGroup.StorylineFrame, Header_LayoutGroup, 0, nil)
										Header_LayoutGroup:AddElement(Header_LayoutGroup.StorylineFrame)

										local StorylineFrame = Header_LayoutGroup.StorylineFrame

										--------------------------------

										do -- STORYLINE
											StorylineFrame.Storyline = PrefabRegistry:Create("Quest.Storyline", StorylineFrame, NS.Variables.FRAME_STRATA, NS.Variables.FRAME_LEVEL + 11, "$parent.Storyline")
											StorylineFrame.Storyline:SetPoint("LEFT", StorylineFrame, 0, 0)
											StorylineFrame.Storyline:SetFrameStrata(NS.Variables.FRAME_STRATA)
											StorylineFrame.Storyline:SetFrameLevel(NS.Variables.FRAME_LEVEL + 11)
											addon.API.FrameUtil:SetDynamicSize(StorylineFrame.Storyline, StorylineFrame, nil, 0)
										end
									end
								end
							end
						end

						do -- DIVIDER
							local TEXTURE_RATIO = .14

							--------------------------------

							Header.Divider = CreateFrame("Frame", "$parent.Divider", Header)
							Header.Divider:SetPoint("BOTTOM", Header, "BOTTOM", 0, 0)
							Header.Divider:SetFrameStrata(NS.Variables.FRAME_STRATA)
							Header.Divider:SetFrameLevel(NS.Variables.FRAME_LEVEL + 8)
							addon.API.FrameUtil:SetDynamicSize(Header.Divider, Header, function(relativeWidth, relativeHeight) return relativeWidth end, function(relativeWidth, relativeHeight) return relativeWidth * TEXTURE_RATIO end)

							local Divider = Header.Divider

							----------------------------------

							do -- BACKGROUND
								Divider.Background, Divider.BackgroundTexture = addon.API.FrameTemplates:CreateTexture(Divider, NS.Variables.FRAME_STRATA, nil, "$parent.Background")
								Divider.Background:SetAllPoints(Divider)
								Divider.Background:SetFrameStrata(NS.Variables.FRAME_STRATA)
								Divider.Background:SetFrameLevel(NS.Variables.FRAME_LEVEL + 9)
							end

							do -- MOUSE RESPONDER
								local SIZE = 50

								Divider.MouseResponder = CreateFrame("Frame", "$parent.MouseResponder", Divider)
								Divider.MouseResponder:SetSize(SIZE, SIZE)
								Divider.MouseResponder:SetPoint("BOTTOMRIGHT", Divider, SIZE / 4, -SIZE / 4)
							end
						end
					end

					do -- MAIN
						LayoutGroup.Main = CreateFrame("Frame", "$parent.Main", LayoutGroup)
						LayoutGroup.Main:SetPoint("CENTER", LayoutGroup)
						LayoutGroup.Main:SetFrameStrata(NS.Variables.FRAME_STRATA)
						LayoutGroup.Main:SetFrameLevel(NS.Variables.FRAME_LEVEL + 7)
						CallbackRegistry:Add("UpdateDynamicSize Quest.Content.Main", addon.API.FrameUtil:SetDynamicSize(LayoutGroup.Main, LayoutGroup, 0, function(relativeWidth, relativeHeight) return relativeHeight - LayoutGroup.Header:GetHeight() - FRAME_FOOTER_HEIGHT end, nil, nil, "Quest.Main"))
						LayoutGroup:AddElement(LayoutGroup.Main)

						local Main = LayoutGroup.Main

						----------------------------------

						do -- CONTENT
							Main.Content = CreateFrame("Frame", "$parent.Content", Main)
							Main.Content:SetPoint("CENTER", Main)
							Main.Content:SetFrameStrata(NS.Variables.FRAME_STRATA)
							Main.Content:SetFrameLevel(NS.Variables.FRAME_LEVEL + 8)
							addon.API.FrameUtil:SetDynamicSize(Main.Content, Main, FRAME_MAIN_INSET_WIDTH, FRAME_MAIN_INSET_HEIGHT)

							local Main_Content = Main.Content

							----------------------------------

							do -- SCROLL FRAME
								Main_Content.ScrollFrame, Main_Content.ScrollChildFrame = addon.API.FrameTemplates:CreateScrollFrame(Main_Content, { direction = "vertical", smoothScrollingRatio = 5 }, "$parent.ScrollFrame", "$parent.ScrollChildFrame")
								Main_Content.ScrollFrame:SetPoint("CENTER", Main_Content)
								Main_Content.ScrollFrame:SetFrameStrata(NS.Variables.FRAME_STRATA)
								Main_Content.ScrollFrame:SetFrameLevel(NS.Variables.FRAME_LEVEL + 9)
								addon.API.FrameUtil:SetDynamicSize(Main_Content.ScrollFrame, Main_Content, 0, 0)

								local ScrollFrame, ScrollChildFrame = Main_Content.ScrollFrame, Main_Content.ScrollChildFrame

								--------------------------------

								do -- SCROLL BAR
									ScrollFrame.ScrollBar:Hide()
								end

								do -- SCROLL INDICATOR
									local TEXTURE_RATIO = .25

									--------------------------------

									ScrollFrame.ScrollIndicator, ScrollFrame.ScrollIndicatorTexture = addon.API.FrameTemplates:CreateTexture(Frame, NS.Variables.FRAME_STRATA, nil, "$parent.ScrollIndicator")
									ScrollFrame.ScrollIndicator:SetPoint("BOTTOM", ScrollFrame, "BOTTOM", 0, -PADDING)
									ScrollFrame.ScrollIndicator:SetFrameStrata(NS.Variables.FRAME_STRATA)
									ScrollFrame.ScrollIndicator:SetFrameLevel(NS.Variables.FRAME_LEVEL_MAX)
									addon.API.FrameUtil:SetDynamicSize(ScrollFrame.ScrollIndicator, Main, function(relativeWidth, relativeHeight) return relativeWidth end, function(relativeWidth, relativeHeight) return relativeWidth * TEXTURE_RATIO end)
									ScrollFrame.ScrollIndicator:SetAlpha(.25)

									--------------------------------

									addon.API.Main:RegisterThemeUpdate(function()
										local ScrollFrameIndicatorTexture

										if addon.Theme.IsDarkTheme then
											ScrollFrameIndicatorTexture = NS.Variables.QUEST_PATH .. "footer-dark.png"
										else
											ScrollFrameIndicatorTexture = NS.Variables.QUEST_PATH .. "footer-light.png"
										end

										ScrollFrame.ScrollIndicatorTexture:SetTexture(ScrollFrameIndicatorTexture)
									end, 5)
								end

								do -- LAYOUT GROUP
									ScrollChildFrame.LayoutGroup, ScrollChildFrame.LayoutGroup_Sort = addon.API.FrameTemplates:CreateLayoutGroup(ScrollChildFrame, { point = "TOP", direction = "vertical", resize = true, padding = NS.Variables.PADDING, distribute = false, distributeResizeElements = false, excludeHidden = true, autoSort = true, customOffset = nil, customLayoutSort = nil }, "$parent.LayoutGroup")
									ScrollChildFrame.LayoutGroup:SetPoint("TOP", ScrollChildFrame)
									ScrollChildFrame.LayoutGroup:SetFrameStrata(NS.Variables.FRAME_STRATA)
									ScrollChildFrame.LayoutGroup:SetFrameLevel(NS.Variables.FRAME_LEVEL + 5)
									addon.API.FrameUtil:SetDynamicSize(ScrollChildFrame.LayoutGroup, ScrollChildFrame, 0, nil)
									addon.API.FrameUtil:SetDynamicSize(ScrollChildFrame, ScrollChildFrame.LayoutGroup, nil, 0)
									CallbackRegistry:Add("LayoutGroupSort Quest.Content.Main", ScrollChildFrame.LayoutGroup_Sort)

									local ScrollChildFrame_LayoutGroup = ScrollChildFrame.LayoutGroup

									--------------------------------

									do -- ELEMENTS
										local function CreateHeader(parent)
											local Header = PrefabRegistry:Create("Quest.Content.Header", parent, ScrollChildFrame_LayoutGroup, NS.Variables.FRAME_STRATA, NS.Variables.FRAME_LEVEL + 4, "$parent.Header")

											--------------------------------

											return Header
										end

										local function CreateHeaderReward(parent)
											local Header = PrefabRegistry:Create("Quest.Content.Header.Reward", parent, ScrollChildFrame_LayoutGroup, NS.Variables.FRAME_STRATA, NS.Variables.FRAME_LEVEL + 4, "$parent.HeaderReward")
											return Header
										end

										local function CreateReward(parent, selectable)
											local Reward = PrefabRegistry:Create("Quest.Content.Reward", parent, selectable, NS.Variables.FRAME_STRATA, NS.Variables.FRAME_LEVEL + 4, "$parent.Reward")
											return Reward
										end

										local function CreateText(parent)
											local Text = addon.API.FrameTemplates:CreateText(parent, addon.Theme.RGB_WHITE, CONTENT_TEXT_SIZE, "LEFT", "TOP", addon.API.Fonts.CONTENT_LIGHT)
											Text:SetAlpha(.75)
											addon.API.FrameUtil:SetDynamicTextSize(Text, parent, function(relativeWidth, relativeHeight) return relativeWidth end, nil, true, nil)

											--------------------------------

											return Text
										end

										local function RegisterElement(frame, type)
											frame.type = type

											--------------------------------

											ScrollChildFrame_LayoutGroup:AddElement(frame)
											table.insert(NS.Variables.Elements, frame)
										end

										--------------------------------

										do -- OBJECTIVES
											do -- HEADER
												ScrollChildFrame_LayoutGroup.Objectives_Header = CreateHeader(ScrollChildFrame_LayoutGroup)
												ScrollChildFrame_LayoutGroup.Objectives_Header:SetText(L["InteractionFrame.QuestFrame - Objectives"])

												--------------------------------

												RegisterElement(ScrollChildFrame_LayoutGroup.Objectives_Header, "Header")
											end

											do -- TEXT
												ScrollChildFrame_LayoutGroup.Objectives_Text = CreateText(ScrollChildFrame_LayoutGroup)

												--------------------------------

												RegisterElement(ScrollChildFrame_LayoutGroup.Objectives_Text, "Text")
											end
										end

										do -- REWARDS
											do -- HEADER
												ScrollChildFrame_LayoutGroup.Rewards_Header = CreateHeader(ScrollChildFrame_LayoutGroup)
												ScrollChildFrame_LayoutGroup.Rewards_Header:SetText(L["InteractionFrame.QuestFrame - Rewards"])

												--------------------------------

												RegisterElement(ScrollChildFrame_LayoutGroup.Rewards_Header, "Header")
											end

											--------------------------------

											do -- EXPERIENCE TEXT
												ScrollChildFrame_LayoutGroup.Rewards_Experience = CreateHeaderReward(ScrollChildFrame_LayoutGroup)

												--------------------------------

												RegisterElement(ScrollChildFrame_LayoutGroup.Rewards_Experience, "RewardText")
											end

											do -- CURRENCY TEXT
												ScrollChildFrame_LayoutGroup.Rewards_Currency = CreateHeaderReward(ScrollChildFrame_LayoutGroup)

												--------------------------------

												RegisterElement(ScrollChildFrame_LayoutGroup.Rewards_Currency, "RewardText")
											end

											do -- HONOR TEXT
												ScrollChildFrame_LayoutGroup.Rewards_Honor = CreateHeaderReward(ScrollChildFrame_LayoutGroup)

												--------------------------------

												RegisterElement(ScrollChildFrame_LayoutGroup.Rewards_Honor, "RewardText")
											end

											do -- CHOICE
												do -- CHOICE
													ScrollChildFrame_LayoutGroup.Rewards_Choice = CreateText(ScrollChildFrame_LayoutGroup)

													--------------------------------

													RegisterElement(ScrollChildFrame_LayoutGroup.Rewards_Choice, "Text")
												end

												do -- CHOICE BUTTONS
													local buttons = {}
													for i = 1, 10 do
														local Button = CreateReward(ScrollChildFrame_LayoutGroup, true)

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
													ScrollChildFrame_LayoutGroup.Rewards_Receive = CreateText(ScrollChildFrame_LayoutGroup)

													--------------------------------

													RegisterElement(ScrollChildFrame_LayoutGroup.Rewards_Receive, "Text")
												end

												do -- RECEIVE BUTTONS
													local buttons = {}
													for i = 1, 10 do
														local Button = CreateReward(ScrollChildFrame_LayoutGroup, false)

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
													ScrollChildFrame_LayoutGroup.Rewards_Spell = CreateText(ScrollChildFrame_LayoutGroup)

													--------------------------------

													RegisterElement(ScrollChildFrame_LayoutGroup.Rewards_Spell, "Text")
												end

												do -- SPELL BUTTONS
													local buttons = {}
													for i = 1, 10 do
														local Button = CreateReward(ScrollChildFrame_LayoutGroup, false)

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
												ScrollChildFrame_LayoutGroup.Progress_Header = CreateHeader(ScrollChildFrame_LayoutGroup)
												ScrollChildFrame_LayoutGroup.Progress_Header:SetText(L["InteractionFrame.QuestFrame - Required Items"])

												--------------------------------

												RegisterElement(ScrollChildFrame_LayoutGroup.Progress_Header, "Header")
											end

											do -- REQUIRED ITEM BUTTONS
												local buttons = {}
												for i = 1, 10 do
													local Button = CreateReward(ScrollChildFrame_LayoutGroup, false)

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
						end
					end

					do -- FOOTER
						LayoutGroup.Footer = CreateFrame("Frame", "$parent.Footer", LayoutGroup)
						LayoutGroup.Footer:SetHeight(FRAME_FOOTER_HEIGHT)
						LayoutGroup.Footer:SetFrameStrata(NS.Variables.FRAME_STRATA)
						LayoutGroup.Footer:SetFrameLevel(NS.Variables.FRAME_LEVEL + 7)
						addon.API.FrameUtil:SetDynamicSize(LayoutGroup.Footer, LayoutGroup, 0, nil)
						LayoutGroup:AddElement(LayoutGroup.Footer)

						local Footer = LayoutGroup.Footer

						----------------------------------

						do -- CONTENT
							Footer.Content = CreateFrame("Frame", "$parent.Content", Footer)
							Footer.Content:SetPoint("CENTER", Footer)
							Footer.Content:SetFrameStrata(NS.Variables.FRAME_STRATA)
							Footer.Content:SetFrameLevel(NS.Variables.FRAME_LEVEL + 8)
							addon.API.FrameUtil:SetDynamicSize(Footer.Content, Footer, PADDING, PADDING)

							local Footer_Content = Footer.Content

							----------------------------------

							do -- BUTTONS
								local function CreateButton(name, color, highlightColor, color_darkTheme, highlightColor_darkTheme)
									local Button = PrefabRegistry:Create("Quest.ButtonContainer.Button", Footer_Content, color, highlightColor, color_darkTheme, highlightColor_darkTheme, NS.Variables.FRAME_STRATA, NS.Variables.FRAME_LEVEL + 9, name)
									return Button
								end

								--------------------------------

								do -- ACCEPT
									Footer_Content.AcceptButton = CreateButton("$parent.AcceptButton", addon.Theme.Quest.Secondary_LightTheme, addon.Theme.Quest.Primary_LightTheme, addon.Theme.Quest.Secondary_DarkTheme, addon.Theme.Quest.Primary_DarkTheme)
									Footer_Content.AcceptButton:SetWidth(NS.Variables:RATIO(3))
									Footer_Content.AcceptButton:SetPoint("LEFT", Footer_Content)
									addon.API.FrameUtil:SetDynamicSize(Footer_Content.AcceptButton, Footer_Content, nil, 0)
								end

								do -- CONTINUE
									Footer_Content.ContinueButton = CreateButton("$parent.ContinueButton", addon.Theme.Quest.Secondary_LightTheme, addon.Theme.Quest.Primary_LightTheme, addon.Theme.Quest.Secondary_DarkTheme, addon.Theme.Quest.Primary_DarkTheme)
									Footer_Content.ContinueButton:SetWidth(NS.Variables:RATIO(3))
									Footer_Content.ContinueButton:SetPoint("LEFT", Footer_Content)
									addon.API.FrameUtil:SetDynamicSize(Footer_Content.ContinueButton, Footer_Content, nil, 0)
								end

								do -- COMPLETE
									Footer_Content.CompleteButton = CreateButton("$parent.CompleteButton", addon.Theme.Quest.Secondary_LightTheme, addon.Theme.Quest.Primary_LightTheme, addon.Theme.Quest.Secondary_DarkTheme, addon.Theme.Quest.Primary_DarkTheme)
									Footer_Content.CompleteButton:SetWidth(NS.Variables:RATIO(3))
									Footer_Content.CompleteButton:SetPoint("LEFT", Footer_Content)
									addon.API.FrameUtil:SetDynamicSize(Footer_Content.CompleteButton, Footer_Content, nil, 0)
								end

								do -- DECLINE
									Footer_Content.DeclineButton = CreateButton("$parent.DeclineButton", addon.Theme.Quest.Highlight_Tertiary_LightTheme, addon.Theme.Quest.Highlight_Secondary_LightTheme, addon.Theme.Quest.Highlight_Tertiary_DarkTheme, addon.Theme.Quest.Highlight_Secondary_DarkTheme)
									Footer_Content.DeclineButton:SetWidth(NS.Variables:RATIO(3))
									Footer_Content.DeclineButton:SetPoint("RIGHT", Footer_Content)
									addon.API.FrameUtil:SetDynamicSize(Footer_Content.DeclineButton, Footer_Content, nil, 0)
								end

								do -- GOODBYE
									Footer_Content.GoodbyeButton = CreateButton("$parent.GoodbyeButton", addon.Theme.Quest.Highlight_Tertiary_LightTheme, addon.Theme.Quest.Highlight_Secondary_LightTheme, addon.Theme.Quest.Highlight_Tertiary_DarkTheme, addon.Theme.Quest.Highlight_Secondary_DarkTheme)
									Footer_Content.GoodbyeButton:SetWidth(NS.Variables:RATIO(3))
									Footer_Content.GoodbyeButton:SetPoint("RIGHT", Footer_Content)
									addon.API.FrameUtil:SetDynamicSize(Footer_Content.GoodbyeButton, Footer_Content, nil, 0)
								end
							end
						end
					end
				end
			end

			do -- EVENTS
				local function UpdateSize()
					do -- BACKGROUND
						Frame.Background:ClearAllPoints()
						Frame.Background:SetPoint("TOPLEFT", Frame, (-57.5 * NS.Variables.ScaleModifier), (65 * NS.Variables.ScaleModifier))
						Frame.Background:SetPoint("BOTTOMRIGHT", Frame, (57.5 * NS.Variables.ScaleModifier), (-70 * NS.Variables.ScaleModifier))
					end

					do -- BORDER
						Frame.Border:ClearAllPoints()
						Frame.Border:SetPoint("TOPLEFT", Frame, (-57.5 * NS.Variables.ScaleModifier), (65 * NS.Variables.ScaleModifier))
						Frame.Border:SetPoint("BOTTOMRIGHT", Frame, (57.5 * NS.Variables.ScaleModifier), (-70 * NS.Variables.ScaleModifier))
					end

					do -- CONTEXT ICON
						Frame.ContextIcon:SetScale(1 * NS.Variables.ScaleModifier)
					end
				end

				Frame:HookScript("OnSizeChanged", UpdateSize)
				CallbackRegistry:Add("Quest.Settings_QuestFrameSize", UpdateSize)
			end
		end

		do -- REFERENCES
			local Frame = InteractionFrame.QuestFrame

			--------------------------------

			-- CORE
			Frame.REF_CONTEXTICON = Frame.ContextIcon
			Frame.REF_HEADER = Frame.Content.LayoutGroup.Header
			Frame.REF_MAIN = Frame.Content.LayoutGroup.Main
			Frame.REF_FOOTER = Frame.Content.LayoutGroup.Footer

			-- HEADER
			Frame.REF_HEADER_TITLE = Frame.REF_HEADER.Content.LayoutGroup.TitleFrame
			Frame.REF_HEADER_STORYLINE = Frame.REF_HEADER.Content.LayoutGroup.StorylineFrame
			Frame.REF_HEADER_DIVIDER = Frame.REF_HEADER.Divider

			-- MAIN
			Frame.REF_MAIN_SCROLLFRAME = Frame.REF_MAIN.Content.ScrollFrame
			Frame.REF_MAIN_SCROLLCHILDFRAME = Frame.REF_MAIN.Content.ScrollChildFrame
			Frame.REF_MAIN_SCROLLFRAME_SCROLLINDICATOR = Frame.REF_MAIN_SCROLLFRAME.ScrollIndicator
			Frame.REF_MAIN_SCROLLFRAME_CONTENT = Frame.REF_MAIN_SCROLLCHILDFRAME.LayoutGroup

			-- FOOTER
			Frame.REF_FOOTER_CONTENT = Frame.REF_FOOTER.Content
		end
	end

	--------------------------------
	-- REFERENCES
	--------------------------------

	local Frame = InteractionFrame.QuestFrame
	local Callback = NS.Script; NS.Script = Callback

	--------------------------------
	-- SETUP
	--------------------------------

	do
		Frame:Hide()
		Frame.hidden = true
	end
end
