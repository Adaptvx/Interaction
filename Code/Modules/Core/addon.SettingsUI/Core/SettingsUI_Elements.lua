local addonName, addon = ...
local CallbackRegistry = addon.CallbackRegistry
local L = addon.Locales
local NS = addon.SettingsUI

--------------------------------

NS.Elements = {}

--------------------------------

function NS.Elements:Load()
	--------------------------------
	-- CREATE ELEMENTS
	--------------------------------

	do
		do -- CREATE ELEMENTS
			InteractionSettingsParent = CreateFrame("Frame", "$parent.SettingsParent", InteractionFrame)
			InteractionSettingsParent:SetSize(addon.API:GetScreenWidth(), addon.API:GetScreenHeight())
			InteractionSettingsParent:SetPoint("CENTER", nil)
			InteractionSettingsParent:SetFrameStrata("FULLSCREEN")

			InteractionSettingsFrame = CreateFrame("Frame", "$parent.SettingsFrame", InteractionSettingsParent)
			InteractionSettingsFrame:SetSize(875, 875 * .65)
			InteractionSettingsFrame:SetPoint("CENTER", InteractionSettingsParent)
			InteractionSettingsFrame:SetFrameStrata("FULLSCREEN_DIALOG")
			InteractionSettingsFrame:SetMovable(true)

			--------------------------------

			do -- BACKGROUND
				InteractionSettingsFrame.Background, InteractionSettingsFrame.BackgroundTexture = AdaptiveAPI.FrameTemplates:CreateNineSlice(InteractionSettingsFrame, "FULLSCREEN_DIALOG", nil, 350, .375, "$parent.Background")
				InteractionSettingsFrame.Background:SetSize(InteractionSettingsFrame:GetWidth() + NS.Variables:RATIO(4), InteractionSettingsFrame:GetHeight() + NS.Variables:RATIO(4))
				InteractionSettingsFrame.Background:SetPoint("CENTER", InteractionSettingsFrame)
				InteractionSettingsFrame.Background:EnableMouse(true)
				InteractionSettingsFrame.Background:SetFrameLevel(2)

				--------------------------------

				local function UpdateTheme()
					local BackgroundTexture

					if addon.Theme.IsDarkTheme then
						BackgroundTexture = NS.Variables.SETTINGS_PATH .. "background-nineslice-dark-mode.png"
					else
						BackgroundTexture = NS.Variables.SETTINGS_PATH .. "background-nineslice-light-mode.png"
					end

					InteractionSettingsFrame.BackgroundTexture:SetTexture(BackgroundTexture)
				end

				UpdateTheme()
				addon.API:RegisterThemeUpdate(UpdateTheme, 5)
			end

			do -- MOVERS
				InteractionSettingsFrame.Mover = CreateFrame("Frame", "InteractionSettingsFrame.Mover", InteractionSettingsFrame)
				InteractionSettingsFrame.Mover:SetSize(InteractionSettingsFrame.Background:GetWidth(), 125)
				InteractionSettingsFrame.Mover:SetPoint("TOP", InteractionSettingsFrame.Background)
				InteractionSettingsFrame.Mover:EnableMouse(true)
				InteractionSettingsFrame.Mover:SetFrameLevel(3)

				--------------------------------

				InteractionSettingsFrame.Mover:SetScript("OnMouseDown", function()
					InteractionSettingsFrame.moving = true
					InteractionSettingsFrame:StartMoving(true)

					NS.Script:MoveActive()
				end)

				InteractionSettingsFrame.Mover:SetScript("OnMouseUp", function()
					InteractionSettingsFrame.moving = false
					InteractionSettingsFrame:StopMovingOrSizing()

					NS.Script:MoveDisabled()
				end)
			end

			do -- CONTENT
				InteractionSettingsFrame.Container = CreateFrame("Frame", "InteractionSettingsFrame.Container", InteractionSettingsFrame.Background)
				InteractionSettingsFrame.Container:SetSize(InteractionSettingsFrame:GetWidth(), InteractionSettingsFrame:GetHeight())
				InteractionSettingsFrame.Container:SetPoint("CENTER", InteractionSettingsFrame.Background)
				InteractionSettingsFrame.Container:SetFrameLevel(3)

				--------------------------------

				local function CreateScrollFrame(parent)
					local frame, scrollChildFrame = AdaptiveAPI.FrameTemplates:CreateScrollFrame(parent, "vertical")
					frame.ScrollBar:Hide()

					return frame, scrollChildFrame
				end

				--------------------------------

				local PADDING = (NS.Variables:RATIO(9))

				local CONTENT_WIDTH = (NS.Variables.BASELINE_WIDTH - NS.Variables:RATIO(9))
				local CONTENT_HEIGHT = (NS.Variables.BASELINE_HEIGHT - NS.Variables:RATIO(9))
				local SECONDARY_WIDTH = (addon.Variables:RATIO(CONTENT_WIDTH, 3))
				local PRIMARY_WIDTH = (CONTENT_WIDTH - addon.Variables:RATIO(CONTENT_WIDTH, 3) - NS.Variables:RATIO(8))
				local PRIMARY_CONTENT_WIDTH = (PRIMARY_WIDTH - NS.Variables:RATIO(6))
				local HEADER_HEIGHT = (addon.Variables:RATIO(CONTENT_HEIGHT, 5))

				local DIVIDER_WIDTH = NS.Variables:RATIO(11)
				local DIVIDER_HEIGHT = CONTENT_HEIGHT
				local DIVIDER_POS = {
					["x"] = (SECONDARY_WIDTH + (NS.Variables.BASELINE_WIDTH - (SECONDARY_WIDTH + PRIMARY_WIDTH)) / 2) - (DIVIDER_WIDTH),
					["y"] = 0
				}

				--------------------------------

				do -- DIVIDER
					InteractionSettingsFrame.Divider = CreateFrame("Frame", "$parent.Divider", InteractionSettingsFrame.Container)
					InteractionSettingsFrame.Divider:SetSize(DIVIDER_WIDTH, DIVIDER_HEIGHT)
					InteractionSettingsFrame.Divider:SetPoint("LEFT", InteractionSettingsFrame.Container, DIVIDER_POS.x, DIVIDER_POS.y)
					InteractionSettingsFrame.Divider:SetFrameLevel(3)

					--------------------------------

					do -- BACKGROUND
						InteractionSettingsFrame.Divider.Background, InteractionSettingsFrame.Divider.BackgroundTexture = AdaptiveAPI.FrameTemplates:CreateTexture(InteractionSettingsFrame.Divider, "FULLSCREEN_DIALOG", nil, "$parent.Background")
						InteractionSettingsFrame.Divider.Background:SetAllPoints(InteractionSettingsFrame.Divider, true)
						InteractionSettingsFrame.Divider.Background:SetFrameLevel(3)

						--------------------------------

						addon.API:RegisterThemeUpdate(function()
							local TEXTURE_Background

							if addon.Theme.IsDarkTheme then
								TEXTURE_Background = NS.Variables.SETTINGS_PATH .. "divider-vertical-dark-mode.png"
							else
								TEXTURE_Background = NS.Variables.SETTINGS_PATH .. "divider-vertical-light-mode.png"
							end

							InteractionSettingsFrame.Divider.BackgroundTexture:SetTexture(TEXTURE_Background)
						end, 5)
					end
				end

				do -- PRIMARY
					InteractionSettingsFrame.Content = CreateFrame("Frame", "$parent.Content", InteractionSettingsFrame.Container)
					InteractionSettingsFrame.Content:SetSize(PRIMARY_WIDTH - PADDING, CONTENT_HEIGHT)
					InteractionSettingsFrame.Content:SetPoint("RIGHT", InteractionSettingsFrame.Container, -PADDING / 2, 0)
					InteractionSettingsFrame.Content:SetFrameLevel(3)

					--------------------------------

					do -- HEADER
						InteractionSettingsFrame.Content.Header = CreateFrame("Frame", "$parent.Header", InteractionSettingsFrame.Content)
						InteractionSettingsFrame.Content.Header:SetSize(PRIMARY_WIDTH, HEADER_HEIGHT)
						InteractionSettingsFrame.Content.Header:SetPoint("TOP", InteractionSettingsFrame.Content, 0, 0)
						InteractionSettingsFrame.Content.Header:SetFrameLevel(4)

						--------------------------------

						do -- BACKGROUND
							InteractionSettingsFrame.Content.Header.Background, InteractionSettingsFrame.Content.Header.BackgroundTexture = AdaptiveAPI.FrameTemplates:CreateNineSlice(InteractionSettingsFrame.Content.Header, "FULLSCREEN_DIALOG", AdaptiveAPI.Presets.NINESLICE_INSCRIBED, 50, 3.75, "$parent.Background")
							InteractionSettingsFrame.Content.Header.Background:SetAllPoints(InteractionSettingsFrame.Content.Header, true)
							InteractionSettingsFrame.Content.Header.Background:SetFrameLevel(3)

							--------------------------------

							addon.API:RegisterThemeUpdate(function()
								local COLOR_Background

								if addon.Theme.IsDarkTheme then
									COLOR_Background = addon.Theme.Settings.Secondary_DarkTheme
								else
									COLOR_Background = addon.Theme.Settings.Tertiary_LightTheme
								end

								InteractionSettingsFrame.Content.Header.BackgroundTexture:SetVertexColor(COLOR_Background.r, COLOR_Background.g, COLOR_Background.b, COLOR_Background.a)
							end, 5)
						end

						do -- CONTENT
							InteractionSettingsFrame.Content.Header.Content = CreateFrame("Frame", "$parent.Content", InteractionSettingsFrame.Content.Header)
							InteractionSettingsFrame.Content.Header.Content:SetSize(InteractionSettingsFrame.Content.Header:GetWidth() - NS.Variables:RATIO(7), InteractionSettingsFrame.Content.Header:GetHeight() - NS.Variables:RATIO(7))
							InteractionSettingsFrame.Content.Header.Content:SetPoint("CENTER", InteractionSettingsFrame.Content.Header)
							InteractionSettingsFrame.Content.Header.Content:SetFrameLevel(5)

							--------------------------------

							do -- DIVIDER
								InteractionSettingsFrame.Content.Header.Content.Divider, InteractionSettingsFrame.Content.Header.Content.DividerTexture = AdaptiveAPI.FrameTemplates:CreateNineSlice(InteractionSettingsFrame.Content.Header.Content, "FULLSCREEN_DIALOG", AdaptiveAPI.Presets.NINESLICE_INSCRIBED, 50, 1, "$parent.Divider")
								InteractionSettingsFrame.Content.Header.Content.Divider:SetSize(NS.Variables:RATIO(10), InteractionSettingsFrame.Content.Header.Content:GetHeight())
								InteractionSettingsFrame.Content.Header.Content.Divider:SetPoint("LEFT", InteractionSettingsFrame.Content.Header.Content, 0, 0)
								InteractionSettingsFrame.Content.Header.Content.Divider:SetFrameLevel(5)

								--------------------------------

								addon.API:RegisterThemeUpdate(function()
									local COLOR_Background

									if addon.Theme.IsDarkTheme then
										COLOR_Background = addon.Theme.Settings.Element_Default_DarkTheme
									else
										COLOR_Background = addon.Theme.Settings.Element_Default_LightTheme
									end

									InteractionSettingsFrame.Content.Header.Content.DividerTexture:SetVertexColor(COLOR_Background.r, COLOR_Background.g, COLOR_Background.b, COLOR_Background.a)
								end, 5)
							end

							do -- TITLE
								InteractionSettingsFrame.Content.Header.Content.Title = AdaptiveAPI.FrameTemplates:CreateText(InteractionSettingsFrame.Content.Header, addon.Theme.RGB_RECOMMENDED, 17.5, "LEFT", "MIDDLE", AdaptiveAPI.Fonts.Content_Light, "$parent.Title")
								InteractionSettingsFrame.Content.Header.Content.Title:SetSize(InteractionSettingsFrame.Content.Header.Content:GetWidth(), InteractionSettingsFrame.Content.Header.Content:GetHeight())
								InteractionSettingsFrame.Content.Header.Content.Title:SetPoint("LEFT", InteractionSettingsFrame.Content.Header.Content, NS.Variables:RATIO(8), 0)
							end

							do -- BUTTONS
								InteractionSettingsFrame.Content.Header.Content.ButtonContainer = CreateFrame("Frame", "$parent.ButtonContainer", InteractionSettingsFrame.Content.Header.Content)
								InteractionSettingsFrame.Content.Header.Content.ButtonContainer:SetSize(InteractionSettingsFrame.Content.Header.Content:GetWidth(), InteractionSettingsFrame.Content.Header.Content:GetHeight())
								InteractionSettingsFrame.Content.Header.Content.ButtonContainer:SetPoint("CENTER", InteractionSettingsFrame.Content.Header.Content)

								--------------------------------

								do -- CLOSE
									InteractionSettingsFrame.Content.Header.Content.ButtonContainer.CloseButton = AdaptiveAPI.FrameTemplates:CreateCustomButton(InteractionSettingsFrame.Content.Header.Content.ButtonContainer, NS.Variables:RATIO(5), InteractionSettingsFrame.Content.Header.Content.ButtonContainer:GetHeight(), "FULLSCREEN_DIALOG", {
										defaultTexture = AdaptiveAPI.Presets.NINESLICE_INSCRIBED,
										highlightTexture = AdaptiveAPI.Presets.NINESLICE_INSCRIBED,
										edgeSize = 50,
										scale = 1,
										theme = nil,
										playAnimation = false,
										customColor = nil,
										customHighlightColor = nil,
										customActiveColor = nil,
									}, "$parent.CloseButton")
									InteractionSettingsFrame.Content.Header.Content.ButtonContainer.CloseButton:SetPoint("RIGHT", InteractionSettingsFrame.Content.Header.Content.ButtonContainer)
									InteractionSettingsFrame.Content.Header.Content.ButtonContainer.CloseButton:SetFrameStrata("FULLSCREEN_DIALOG")
									InteractionSettingsFrame.Content.Header.Content.ButtonContainer.CloseButton:SetFrameLevel(6)

									addon.API:RegisterThemeUpdate(function()
										local FilledColor
										local FilledHighlightColor

										if addon.Theme.IsDarkTheme then
											FilledColor = addon.Theme.Settings.Primary_DarkTheme
											FilledHighlightColor = addon.Theme.Settings.Secondary_DarkTheme
										else
											FilledColor = addon.Theme.Settings.Element_Default_LightTheme
											FilledHighlightColor = addon.Theme.Settings.Element_Highlight_LightTheme
										end

										AdaptiveAPI.FrameTemplates.Styles:UpdateButton(InteractionSettingsFrame.Content.Header.Content.ButtonContainer.CloseButton, {
											customColor = FilledColor,
											customHighlightColor = FilledHighlightColor
										})
									end, 3)

									InteractionSettingsFrame.Content.Header.Content.ButtonContainer.CloseButton:SetScript("OnClick", function()
										NS.Script:HideSettingsUI()
									end)

									--------------------------------

									do -- IMAGE
										InteractionSettingsFrame.Content.Header.Content.ButtonContainer.CloseButton.Image, InteractionSettingsFrame.Content.Header.Content.ButtonContainer.CloseButton.ImageTexture = AdaptiveAPI.FrameTemplates:CreateTexture(InteractionSettingsFrame.Content.Header.Content.ButtonContainer.CloseButton, "FULLSCREEN", AdaptiveAPI.PATH .. "Elements/close.png", "$parent.Image")
										InteractionSettingsFrame.Content.Header.Content.ButtonContainer.CloseButton.Image:SetSize(InteractionSettingsFrame.Content.Header.Content.ButtonContainer.CloseButton:GetHeight() - NS.Variables:RATIO(8), InteractionSettingsFrame.Content.Header.Content.ButtonContainer.CloseButton:GetHeight() - NS.Variables:RATIO(8))
										InteractionSettingsFrame.Content.Header.Content.ButtonContainer.CloseButton.Image:SetPoint("CENTER", InteractionSettingsFrame.Content.Header.Content.ButtonContainer.CloseButton)
										InteractionSettingsFrame.Content.Header.Content.ButtonContainer.CloseButton.Image:SetFrameStrata("FULLSCREEN_DIALOG")
										InteractionSettingsFrame.Content.Header.Content.ButtonContainer.CloseButton.Image:SetFrameLevel(7)
										InteractionSettingsFrame.Content.Header.Content.ButtonContainer.CloseButton.Image:SetAlpha(.5)
										InteractionSettingsFrame.Content.Header.Content.ButtonContainer.CloseButton.ImageTexture:SetVertexColor(1, 1, 1)
									end
								end
							end
						end
					end

					do -- SCROLL FRAME
						local PADDING_SCROLLBAR = NS.Variables:RATIO(8)

						InteractionSettingsFrame.Content.ScrollFrame, InteractionSettingsFrame.Content.ScrollChildFrame = CreateScrollFrame(InteractionSettingsFrame.Content)
						InteractionSettingsFrame.Content.ScrollFrame:SetSize(PRIMARY_CONTENT_WIDTH - PADDING_SCROLLBAR, InteractionSettingsFrame.Content:GetHeight() - InteractionSettingsFrame.Content.Header:GetHeight() - NS.Variables:RATIO(9))
						InteractionSettingsFrame.Content.ScrollFrame:SetPoint("TOP", InteractionSettingsFrame.Content, -PADDING_SCROLLBAR, -InteractionSettingsFrame.Content.Header:GetHeight() - NS.Variables:RATIO(9))
						InteractionSettingsFrame.Content.ScrollFrame:SetFrameLevel(3)

						--------------------------------

						InteractionSettingsFrame.Content.ScrollFrame.tabPool = {}
						InteractionSettingsFrame.Content.ScrollFrame.CreateTab = function(index)
							local Tab = CreateFrame("Frame")
							Tab:SetParent(InteractionSettingsFrame.Content.ScrollChildFrame)
							Tab:SetSize(InteractionSettingsFrame.Content.ScrollFrame:GetWidth(), 1)
							Tab:SetPoint("TOP", InteractionSettingsFrame.Content.ScrollChildFrame)

							--------------------------------

							table.insert(InteractionSettingsFrame.Content.ScrollFrame.tabPool, index, Tab)

							--------------------------------

							return Tab
						end

						--------------------------------

						do -- SCROLL BAR
							InteractionSettingsFrame.Content.ScrollFrame.Scrollbar = AdaptiveAPI.FrameTemplates:CreateScrollbar(InteractionSettingsFrame.Content.ScrollFrame, "FULLSCREEN_DIALOG", {
								scrollFrame = InteractionSettingsFrame.Content.ScrollFrame,
								scrollChildFrame = InteractionSettingsFrame.Content.ScrollChildFrame,
								sizeX = 5,
								sizeY = InteractionSettingsFrame.Content.ScrollFrame:GetHeight(),
								theme = nil,
								isHorizontal = false,
							}, "$parent.Scrollbar")
							InteractionSettingsFrame.Content.ScrollFrame.Scrollbar:SetPoint("RIGHT", InteractionSettingsFrame.Content.ScrollFrame, (InteractionSettingsFrame.Content.ScrollFrame.Scrollbar:GetWidth() / 2) + (NS.Variables:RATIO(6)), 0)

							--------------------------------

							addon.API:RegisterThemeUpdate(function()
								local COLOR_Default
								local COLOR_Highlight
								local COLOR_Default_Thumb
								local COLOR_Highlight_Thumb

								if addon.Theme.IsDarkTheme then
									COLOR_Default = addon.Theme.Settings.Secondary_DarkTheme
									COLOR_Highlight = addon.Theme.Settings.Secondary_DarkTheme
									COLOR_Default_Thumb = addon.Theme.Settings.Primary_DarkTheme
									COLOR_Highlight_Thumb = addon.Theme.Settings.Element_Default_DarkTheme
								else
									COLOR_Default = addon.Theme.Settings.Secondary_LightTheme
									COLOR_Highlight = addon.Theme.Settings.Secondary_LightTheme
									COLOR_Default_Thumb = addon.Theme.Settings.Primary_LightTheme
									COLOR_Highlight_Thumb = addon.Theme.Settings.Element_Default_LightTheme
								end

								AdaptiveAPI.FrameTemplates:UpdateScrollbarTheme(InteractionSettingsFrame.Content.ScrollFrame.Scrollbar, {
									customColor = COLOR_Default,
									customHighlightColor = COLOR_Highlight,
									customThumbColor = COLOR_Default_Thumb,
									customThumbHighlightColor = COLOR_Highlight_Thumb,
								})
							end, 3)
						end
					end
				end

				do -- SECONDARY
					InteractionSettingsFrame.Sidebar = CreateFrame("Frame", "$parent.Sidebar", InteractionSettingsFrame.Container)
					InteractionSettingsFrame.Sidebar:SetSize(SECONDARY_WIDTH - PADDING, CONTENT_HEIGHT)
					InteractionSettingsFrame.Sidebar:SetPoint("LEFT", InteractionSettingsFrame.Container)
					InteractionSettingsFrame.Sidebar:SetFrameLevel(3)

					--------------------------------

					do -- LEGEND
						InteractionSettingsFrame.Sidebar.Legend, InteractionSettingsFrame.Sidebar.LegendScrollChildFrame = CreateScrollFrame(InteractionSettingsFrame.Container)
						InteractionSettingsFrame.Sidebar.Legend:SetSize(InteractionSettingsFrame.Sidebar:GetWidth(), InteractionSettingsFrame.Sidebar:GetHeight())
						InteractionSettingsFrame.Sidebar.Legend:SetPoint("CENTER", InteractionSettingsFrame.Sidebar)
						InteractionSettingsFrame.Sidebar.Legend:SetFrameLevel(3)
						InteractionSettingsFrame.Sidebar.LegendScrollChildFrame:SetWidth(InteractionSettingsFrame.Sidebar.Legend:GetWidth())

						--------------------------------

						do -- GAMEPAD
							InteractionSettingsFrame.Sidebar.Legend.GamePad = CreateFrame("Frame", "$parent.GamePad", InteractionSettingsFrame.Sidebar.Legend)
							InteractionSettingsFrame.Sidebar.Legend.GamePad:SetSize(InteractionSettingsFrame.Sidebar.Legend:GetSize())
							InteractionSettingsFrame.Sidebar.Legend.GamePad:SetPoint("CENTER", InteractionSettingsFrame.Sidebar.Legend)
							InteractionSettingsFrame.Sidebar.Legend.GamePad:SetFrameLevel(4)

							hooksecurefunc(InteractionSettingsFrame.Sidebar.Legend, "SetWidth", function(self, width)
								InteractionSettingsFrame.Sidebar.Legend.GamePad:SetWidth(width)
							end)

							hooksecurefunc(InteractionSettingsFrame.Sidebar.Legend, "SetHeight", function(self, height)
								InteractionSettingsFrame.Sidebar.Legend.GamePad:SetHeight(height)
							end)

							hooksecurefunc(InteractionSettingsFrame.Sidebar.Legend, "SetSize", function(self, width, height)
								InteractionSettingsFrame.Sidebar.Legend.GamePad:SetSize(width, height)
							end)

							--------------------------------

							do -- TOP
								InteractionSettingsFrame.Sidebar.Legend.GamePad.Top = CreateFrame("Frame", "$parent.Top", InteractionSettingsFrame.Sidebar.Legend.GamePad)
								InteractionSettingsFrame.Sidebar.Legend.GamePad.Top:SetSize(InteractionSettingsFrame.Sidebar.Legend.GamePad:GetWidth(), 50)
								InteractionSettingsFrame.Sidebar.Legend.GamePad.Top:SetPoint("TOP", InteractionSettingsFrame.Sidebar.Legend.GamePad, 0, InteractionSettingsFrame.Sidebar.Legend.GamePad.Top:GetHeight() + NS.Variables:RATIO(8))
								InteractionSettingsFrame.Sidebar.Legend.GamePad.Top:SetFrameLevel(5)

								--------------------------------

								do -- ICON
									InteractionSettingsFrame.Sidebar.Legend.GamePad.Top.Icon, InteractionSettingsFrame.Sidebar.Legend.GamePad.Top.IconTexture = AdaptiveAPI.FrameTemplates:CreateTexture(InteractionSettingsFrame.Sidebar.Legend.GamePad.Top, "FULLSCREEN_DIALOG", nil, "$parent.Icon")
									InteractionSettingsFrame.Sidebar.Legend.GamePad.Top.Icon:SetSize(InteractionSettingsFrame.Sidebar.Legend.GamePad.Top:GetHeight(), InteractionSettingsFrame.Sidebar.Legend.GamePad.Top:GetHeight())
									InteractionSettingsFrame.Sidebar.Legend.GamePad.Top.Icon:SetPoint("CENTER", InteractionSettingsFrame.Sidebar.Legend.GamePad.Top)

									addon.API:RegisterThemeUpdate(function()
										local TEXTURE

										if addon.Theme.IsDarkTheme then
											TEXTURE = addon.Variables.PATH .. "Art/Platform/Platform-LB-Up-Light.png"
										else
											TEXTURE = addon.Variables.PATH .. "Art/Platform/Platform-LB-Up.png"
										end

										InteractionSettingsFrame.Sidebar.Legend.GamePad.Top.IconTexture:SetTexture(TEXTURE)
									end, 5)
								end
							end

							do -- BOTTOM
								InteractionSettingsFrame.Sidebar.Legend.GamePad.Bottom = CreateFrame("Frame", "$parent.Bottom", InteractionSettingsFrame.Sidebar.Legend.GamePad)
								InteractionSettingsFrame.Sidebar.Legend.GamePad.Bottom:SetSize(InteractionSettingsFrame.Sidebar.Legend.GamePad:GetWidth(), 50)
								InteractionSettingsFrame.Sidebar.Legend.GamePad.Bottom:SetPoint("BOTTOM", InteractionSettingsFrame.Sidebar.Legend.GamePad, 0, -InteractionSettingsFrame.Sidebar.Legend.GamePad.Bottom:GetHeight() - NS.Variables:RATIO(8))
								InteractionSettingsFrame.Sidebar.Legend.GamePad.Bottom:SetFrameLevel(5)

								--------------------------------

								do -- ICON
									InteractionSettingsFrame.Sidebar.Legend.GamePad.Bottom.Icon, InteractionSettingsFrame.Sidebar.Legend.GamePad.Bottom.IconTexture = AdaptiveAPI.FrameTemplates:CreateTexture(InteractionSettingsFrame.Sidebar.Legend.GamePad.Bottom, "FULLSCREEN_DIALOG", nil, "$parent.Icon")
									InteractionSettingsFrame.Sidebar.Legend.GamePad.Bottom.Icon:SetSize(InteractionSettingsFrame.Sidebar.Legend.GamePad.Bottom:GetHeight(), InteractionSettingsFrame.Sidebar.Legend.GamePad.Bottom:GetHeight())
									InteractionSettingsFrame.Sidebar.Legend.GamePad.Bottom.Icon:SetPoint("CENTER", InteractionSettingsFrame.Sidebar.Legend.GamePad.Bottom)

									addon.API:RegisterThemeUpdate(function()
										local TEXTURE

										if addon.Theme.IsDarkTheme then
											TEXTURE = addon.Variables.PATH .. "Art/Platform/Platform-RB-Down-Light.png"
										else
											TEXTURE = addon.Variables.PATH .. "Art/Platform/Platform-RB-Down.png"
										end

										InteractionSettingsFrame.Sidebar.Legend.GamePad.Bottom.IconTexture:SetTexture(TEXTURE)
									end, 5)
								end
							end
						end
					end
				end
			end

			do -- TOOLTIP
				local Padding = NS.Variables:RATIO(6.5)

				--------------------------------

				InteractionSettingsFrame.Tooltip = CreateFrame("Frame", "$parent.Tooltip", InteractionSettingsFrame)
				InteractionSettingsFrame.Tooltip:SetSize(NS.Variables:RATIO(1.5), NS.Variables:RATIO(1.5))
				InteractionSettingsFrame.Tooltip:SetPoint("RIGHT", InteractionSettingsFrame, InteractionSettingsFrame.Tooltip:GetWidth() + NS.Variables:RATIO(5), 0)
				InteractionSettingsFrame.Tooltip:SetFrameStrata("FULLSCREEN_DIALOG")
				InteractionSettingsFrame.Tooltip:SetFrameLevel(99)

				InteractionSettingsFrame.Tooltip:SetScript("OnUpdate", function()
					InteractionSettingsFrame.Tooltip.Content.Text:ClearAllPoints()

					if InteractionSettingsFrame.Tooltip.Content.Image:IsVisible() then
						InteractionSettingsFrame.Tooltip:SetHeight(Padding + InteractionSettingsFrame.Tooltip.Content.Image:GetHeight() + Padding / 2 + InteractionSettingsFrame.Tooltip.Content.Text:GetStringHeight() + Padding)
						InteractionSettingsFrame.Tooltip.Content.Text:SetPoint("TOP", InteractionSettingsFrame.Tooltip.Content, 0, -InteractionSettingsFrame.Tooltip.Content.Image:GetHeight() - Padding / 2)
					else
						InteractionSettingsFrame.Tooltip:SetHeight(Padding + InteractionSettingsFrame.Tooltip.Content.Text:GetStringHeight() + Padding)
						InteractionSettingsFrame.Tooltip.Content.Text:SetPoint("TOP", InteractionSettingsFrame.Tooltip.Content, 0, 0)
					end

					InteractionSettingsFrame.Tooltip.Background:SetSize(InteractionSettingsFrame.Tooltip:GetWidth(), InteractionSettingsFrame.Tooltip:GetHeight())
					InteractionSettingsFrame.Tooltip.Content:SetSize(InteractionSettingsFrame.Tooltip:GetWidth() - Padding * 2, InteractionSettingsFrame.Tooltip:GetHeight() - Padding * 2)
				end)

				--------------------------------

				do -- BACKGROUND
					InteractionSettingsFrame.Tooltip.Background, InteractionSettingsFrame.Tooltip.BackgroundTexture = AdaptiveAPI.FrameTemplates:CreateNineSlice(InteractionSettingsFrame.Tooltip, "FULLSCREEN_DIALOG", nil, 256, .175, "$parent.Background")
					InteractionSettingsFrame.Tooltip.Background:SetSize(InteractionSettingsFrame.Tooltip:GetWidth(), InteractionSettingsFrame.Tooltip:GetHeight())
					InteractionSettingsFrame.Tooltip.Background:SetPoint("CENTER", InteractionSettingsFrame.Tooltip)
					InteractionSettingsFrame.Tooltip.Background:SetFrameLevel(98)
				end

				do -- CONTENT
					InteractionSettingsFrame.Tooltip.Content = CreateFrame("Frame", "$parent.Content", InteractionSettingsFrame.Tooltip)
					InteractionSettingsFrame.Tooltip.Content:SetSize(InteractionSettingsFrame.Tooltip:GetWidth() - Padding * 2, InteractionSettingsFrame.Tooltip:GetHeight() - Padding * 2)
					InteractionSettingsFrame.Tooltip.Content:SetPoint("CENTER", InteractionSettingsFrame.Tooltip)
					InteractionSettingsFrame.Tooltip.Content:SetFrameLevel(100)
				end

				do -- IMAGE
					InteractionSettingsFrame.Tooltip.Content.Image, InteractionSettingsFrame.Tooltip.Content.ImageTexture = AdaptiveAPI.FrameTemplates:CreateTexture(InteractionSettingsFrame.Tooltip.Content, "FULLSCREEN_DIALOG", nil, "$parent.Image")
					InteractionSettingsFrame.Tooltip.Content.Image:SetPoint("TOP", InteractionSettingsFrame.Tooltip.Content)
					InteractionSettingsFrame.Tooltip.Content.Image:SetFrameLevel(102)

					--------------------------------

					do -- BACKGROUND
						InteractionSettingsFrame.Tooltip.Content.Image.Background, InteractionSettingsFrame.Tooltip.Content.Image.BackgroundTexture = AdaptiveAPI.FrameTemplates:CreateNineSlice(InteractionSettingsFrame.Tooltip.Content.Image, "FULLSCREEN_DIALOG", NS.Variables.SETTINGS_PATH .. "tooltip-image-background.png", 50, 1, "$parent.Background")
						InteractionSettingsFrame.Tooltip.Content.Image.Background:SetSize(InteractionSettingsFrame.Tooltip.Content.Image:GetWidth() + NS.Variables:RATIO(9.5), InteractionSettingsFrame.Tooltip.Content.Image:GetHeight() + NS.Variables:RATIO(9.5))
						InteractionSettingsFrame.Tooltip.Content.Image.Background:SetPoint("CENTER", InteractionSettingsFrame.Tooltip.Content.Image)
						InteractionSettingsFrame.Tooltip.Content.Image.Background:SetFrameLevel(101)
						InteractionSettingsFrame.Tooltip.Content.Image.Background:SetAlpha(.25)

						--------------------------------

						addon.API:RegisterThemeUpdate(function()
							local TEXTURE_Background

							if addon.Theme.IsDarkTheme then
								TEXTURE_Background = NS.Variables.SETTINGS_PATH .. "tooltip-image-background-dark-mode.png"
							else
								TEXTURE_Background = NS.Variables.SETTINGS_PATH .. "tooltip-image-background.png"
							end

							InteractionSettingsFrame.Tooltip.Content.Image.BackgroundTexture:SetTexture(TEXTURE_Background)
						end, 5)

						--------------------------------

						hooksecurefunc(InteractionSettingsFrame.Tooltip.Content.Image, "SetWidth", function()
							InteractionSettingsFrame.Tooltip.Content.Image.Background:SetWidth(InteractionSettingsFrame.Tooltip.Content.Image:GetWidth() + 5)
						end)

						hooksecurefunc(InteractionSettingsFrame.Tooltip.Content.Image, "SetHeight", function()
							InteractionSettingsFrame.Tooltip.Content.Image.Background:SetHeight(InteractionSettingsFrame.Tooltip.Content.Image:GetHeight() + 5)
						end)

						hooksecurefunc(InteractionSettingsFrame.Tooltip.Content.Image, "SetSize", function()
							InteractionSettingsFrame.Tooltip.Content.Image.Background:SetSize(InteractionSettingsFrame.Tooltip.Content.Image:GetWidth() + 5, InteractionSettingsFrame.Tooltip.Content.Image:GetHeight() + 5)
						end)
					end
				end

				do -- TEXT
					InteractionSettingsFrame.Tooltip.Content.Text = AdaptiveAPI.FrameTemplates:CreateText(InteractionSettingsFrame.Tooltip.Content, addon.Theme.RGB_RECOMMENDED, 15, "LEFT", "TOP", AdaptiveAPI.Fonts.Content_Light, "$parent.Text")
					InteractionSettingsFrame.Tooltip.Content.Text:SetSize(InteractionSettingsFrame.Tooltip.Content:GetWidth(), 250)
				end

				--------------------------------

				local function UpdateTheme()
					local TEXTURE_Background

					if addon.Theme.IsDarkTheme then
						TEXTURE_Background = AdaptiveAPI.Presets.NINESLICE_STYLISED_SCROLL_02
					else
						TEXTURE_Background = AdaptiveAPI.Presets.NINESLICE_STYLISED_SCROLL
					end

					InteractionSettingsFrame.Tooltip.BackgroundTexture:SetTexture(TEXTURE_Background)
				end

				UpdateTheme()
				addon.API:RegisterThemeUpdate(UpdateTheme, 5)

				--------------------------------

				InteractionSettingsFrame.Tooltip:Hide()
			end
		end
	end
end
