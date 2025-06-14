---@class addon
local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local PrefabRegistry = addon.PrefabRegistry
local L = addon.Locales
local NS = addon.SettingsUI; addon.SettingsUI = NS

--------------------------------

NS.Elements = {}

--------------------------------

function NS.Elements:Load()
	--------------------------------
	-- CREATE ELEMENTS
	--------------------------------

	do
		do -- ELEMENTS
			InteractionSettingsParent = CreateFrame("Frame", "$parent.SettingsParent", InteractionFrame)
			InteractionSettingsParent:SetSize(addon.API.Main:GetScreenWidth(), addon.API.Main:GetScreenHeight())
			InteractionSettingsParent:SetPoint("CENTER", nil)
			InteractionSettingsParent:SetFrameStrata("FULLSCREEN")

			InteractionSettingsFrame = CreateFrame("Frame", "$parent.SettingsFrame", InteractionSettingsParent)
			InteractionSettingsFrame:SetSize(875, 875 * .65)
			InteractionSettingsFrame:SetPoint("CENTER", InteractionSettingsParent)
			InteractionSettingsFrame:SetFrameStrata("FULLSCREEN_DIALOG")
			InteractionSettingsFrame:SetMovable(true)

			local Frame = InteractionSettingsFrame

			--------------------------------

			do -- BACKGROUND
				Frame.Background, Frame.BackgroundTexture = addon.API.FrameTemplates:CreateNineSlice(Frame, "FULLSCREEN_DIALOG", nil, 350, .375, "$parent.Background")
				Frame.Background:SetSize(Frame:GetWidth() + NS.Variables:RATIO(4), Frame:GetHeight() + NS.Variables:RATIO(4))
				Frame.Background:SetPoint("CENTER", Frame)
				Frame.Background:EnableMouse(true)
				Frame.Background:SetFrameLevel(2)

				--------------------------------

				local function UpdateTheme()
					local BackgroundTexture

					if addon.Theme.IsDarkTheme then
						BackgroundTexture = NS.Variables.SETTINGS_PATH .. "background-nineslice-dark.png"
					else
						BackgroundTexture = NS.Variables.SETTINGS_PATH .. "background-nineslice-light.png"
					end

					Frame.BackgroundTexture:SetTexture(BackgroundTexture)
				end

				UpdateTheme()
				addon.API.Main:RegisterThemeUpdate(UpdateTheme, 5)
			end

			do -- MOVERS
				Frame.Mover = CreateFrame("Frame", "Frame.Mover", Frame)
				Frame.Mover:SetSize(Frame.Background:GetWidth(), 125)
				Frame.Mover:SetPoint("TOP", Frame.Background)
				Frame.Mover:EnableMouse(true)
				Frame.Mover:SetFrameLevel(3)

				--------------------------------

				Frame.Mover:SetScript("OnMouseDown", function()
					Frame.moving = true
					Frame:StartMoving(true)

					NS.Script:MoveActive()
				end)

				Frame.Mover:SetScript("OnMouseUp", function()
					Frame.moving = false
					Frame:StopMovingOrSizing()

					NS.Script:MoveDisabled()
				end)
			end

			do -- CONTENT
				Frame.Container = CreateFrame("Frame", "Frame.Container", Frame.Background)
				Frame.Container:SetSize(Frame:GetWidth(), Frame:GetHeight())
				Frame.Container:SetPoint("CENTER", Frame.Background)
				Frame.Container:SetFrameLevel(3)

				--------------------------------

				local function CreateScrollFrame(parent)
					local frame, scrollChildFrame = addon.API.FrameTemplates:CreateScrollFrame(parent, { direction = "vertical", smoothScrollingRatio = 5 }, "$parent.ScrollFrame", "$parent.ScrollChildFrame")
					frame.ScrollBar:Hide()

					return frame, scrollChildFrame
				end

				--------------------------------

				local PADDING = (NS.Variables:RATIO(9))

				local CONTENT_WIDTH = (NS.Variables.FRAME_SIZE.x - NS.Variables:RATIO(9))
				local CONTENT_HEIGHT = (NS.Variables.FRAME_SIZE.y - NS.Variables:RATIO(9))
				local SECONDARY_WIDTH = (addon.Variables:RATIO(CONTENT_WIDTH, 3))
				local PRIMARY_WIDTH = (CONTENT_WIDTH - addon.Variables:RATIO(CONTENT_WIDTH, 3) - NS.Variables:RATIO(8))
				local PRIMARY_CONTENT_WIDTH = (PRIMARY_WIDTH - NS.Variables:RATIO(6))
				local HEADER_HEIGHT = (addon.Variables:RATIO(CONTENT_HEIGHT, 5))

				local DIVIDER_WIDTH = NS.Variables:RATIO(11)
				local DIVIDER_HEIGHT = CONTENT_HEIGHT
				local DIVIDER_POS = {
					["x"] = (SECONDARY_WIDTH + (NS.Variables.FRAME_SIZE.x - (SECONDARY_WIDTH + PRIMARY_WIDTH)) / 2) - (DIVIDER_WIDTH),
					["y"] = 0
				}

				--------------------------------

				do -- DIVIDER
					Frame.Divider = CreateFrame("Frame", "$parent.Divider", Frame.Container)
					Frame.Divider:SetSize(DIVIDER_WIDTH, DIVIDER_HEIGHT)
					Frame.Divider:SetPoint("LEFT", Frame.Container, DIVIDER_POS.x, DIVIDER_POS.y)
					Frame.Divider:SetFrameLevel(3)

					--------------------------------

					do -- BACKGROUND
						Frame.Divider.Background, Frame.Divider.BackgroundTexture = addon.API.FrameTemplates:CreateTexture(Frame.Divider, "FULLSCREEN_DIALOG", nil, "$parent.Background")
						Frame.Divider.Background:SetAllPoints(Frame.Divider, true)
						Frame.Divider.Background:SetFrameLevel(3)

						--------------------------------

						addon.API.Main:RegisterThemeUpdate(function()
							local TEXTURE_Background

							if addon.Theme.IsDarkTheme then
								TEXTURE_Background = NS.Variables.SETTINGS_PATH .. "divider-vertical-dark.png"
							else
								TEXTURE_Background = NS.Variables.SETTINGS_PATH .. "divider-vertical-light.png"
							end

							Frame.Divider.BackgroundTexture:SetTexture(TEXTURE_Background)
						end, 5)
					end
				end

				do -- PRIMARY
					Frame.Content = CreateFrame("Frame", "$parent.Content", Frame.Container)
					Frame.Content:SetSize(PRIMARY_WIDTH - PADDING, CONTENT_HEIGHT)
					Frame.Content:SetPoint("RIGHT", Frame.Container, -PADDING / 2, 0)
					Frame.Content:SetFrameLevel(3)

					--------------------------------

					do -- HEADER
						Frame.Content.Header = CreateFrame("Frame", "$parent.Header", Frame.Content)
						Frame.Content.Header:SetSize(PRIMARY_WIDTH, HEADER_HEIGHT)
						Frame.Content.Header:SetPoint("TOP", Frame.Content, 0, 0)
						Frame.Content.Header:SetFrameLevel(4)

						--------------------------------

						do -- BACKGROUND
							Frame.Content.Header.Background, Frame.Content.Header.BackgroundTexture = addon.API.FrameTemplates:CreateNineSlice(Frame.Content.Header, "FULLSCREEN_DIALOG", addon.API.Presets.NINESLICE_INSCRIBED, 50, 3.75, "$parent.Background")
							Frame.Content.Header.Background:SetAllPoints(Frame.Content.Header, true)
							Frame.Content.Header.Background:SetFrameLevel(3)

							--------------------------------

							addon.API.Main:RegisterThemeUpdate(function()
								local COLOR_Background

								if addon.Theme.IsDarkTheme then
									COLOR_Background = addon.Theme.Settings.Header_Background_DarkTheme
								else
									COLOR_Background = addon.Theme.Settings.Header_Background_LightTheme
								end

								Frame.Content.Header.BackgroundTexture:SetVertexColor(COLOR_Background.r, COLOR_Background.g, COLOR_Background.b, COLOR_Background.a)
							end, 5)
						end

						do -- CONTENT
							Frame.Content.Header.Content = CreateFrame("Frame", "$parent.Content", Frame.Content.Header)
							Frame.Content.Header.Content:SetSize(Frame.Content.Header:GetWidth() - NS.Variables:RATIO(7), Frame.Content.Header:GetHeight() - NS.Variables:RATIO(7))
							Frame.Content.Header.Content:SetPoint("CENTER", Frame.Content.Header)
							Frame.Content.Header.Content:SetFrameLevel(5)

							--------------------------------

							do -- DIVIDER
								Frame.Content.Header.Content.Divider, Frame.Content.Header.Content.DividerTexture = addon.API.FrameTemplates:CreateNineSlice(Frame.Content.Header.Content, "FULLSCREEN_DIALOG", addon.API.Presets.NINESLICE_INSCRIBED, 50, 1, "$parent.Divider")
								Frame.Content.Header.Content.Divider:SetSize(NS.Variables:RATIO(10), Frame.Content.Header.Content:GetHeight())
								Frame.Content.Header.Content.Divider:SetPoint("LEFT", Frame.Content.Header.Content, 0, 0)
								Frame.Content.Header.Content.Divider:SetFrameLevel(5)

								--------------------------------

								addon.API.Main:RegisterThemeUpdate(function()
									local COLOR_Background

									if addon.Theme.IsDarkTheme then
										COLOR_Background = addon.Theme.Settings.Header_Divider_DarkTheme
									else
										COLOR_Background = addon.Theme.Settings.Header_Divider_LightTheme
									end

									Frame.Content.Header.Content.DividerTexture:SetVertexColor(COLOR_Background.r, COLOR_Background.g, COLOR_Background.b, COLOR_Background.a)
								end, 5)
							end

							do -- TITLE
								Frame.Content.Header.Content.Title = addon.API.FrameTemplates:CreateText(Frame.Content.Header, addon.Theme.RGB_RECOMMENDED, 17.5, "LEFT", "MIDDLE", addon.API.Fonts.CONTENT_LIGHT, "$parent.Title")
								Frame.Content.Header.Content.Title:SetSize(Frame.Content.Header.Content:GetWidth(), Frame.Content.Header.Content:GetHeight())
								Frame.Content.Header.Content.Title:SetPoint("LEFT", Frame.Content.Header.Content, NS.Variables:RATIO(8), 0)
							end

							do -- BUTTONS
								Frame.Content.Header.Content.ButtonContainer = CreateFrame("Frame", "$parent.ButtonContainer", Frame.Content.Header.Content)
								Frame.Content.Header.Content.ButtonContainer:SetSize(Frame.Content.Header.Content:GetWidth(), Frame.Content.Header.Content:GetHeight())
								Frame.Content.Header.Content.ButtonContainer:SetPoint("CENTER", Frame.Content.Header.Content)

								--------------------------------

								do -- CLOSE
									Frame.Content.Header.Content.ButtonContainer.CloseButton = addon.API.FrameTemplates:CreateCustomButton(Frame.Content.Header.Content.ButtonContainer, NS.Variables:RATIO(5), Frame.Content.Header.Content.ButtonContainer:GetHeight(), "FULLSCREEN_DIALOG", {
										defaultTexture = addon.API.Presets.NINESLICE_INSCRIBED,
										highlightTexture = addon.API.Presets.NINESLICE_INSCRIBED,
										edgeSize = 50,
										scale = 1,
										theme = nil,
										playAnimation = false,
										customColor = nil,
										customHighlightColor = nil,
										customActiveColor = nil,
									}, "$parent.CloseButton")
									Frame.Content.Header.Content.ButtonContainer.CloseButton:SetPoint("RIGHT", Frame.Content.Header.Content.ButtonContainer)
									Frame.Content.Header.Content.ButtonContainer.CloseButton:SetFrameStrata("FULLSCREEN_DIALOG")
									Frame.Content.Header.Content.ButtonContainer.CloseButton:SetFrameLevel(6)

									addon.API.Main:RegisterThemeUpdate(function()
										local COLOR_Default
										local COLOR_Highlight

										if addon.Theme.IsDarkTheme then
											COLOR_Default = addon.Theme.Settings.Header_CloseButton_DarkTheme
											COLOR_Highlight = addon.Theme.Settings.Header_CloseButton_Highlight_DarkTheme
										else
											COLOR_Default = addon.Theme.Settings.Header_CloseButton_LightTheme
											COLOR_Highlight = addon.Theme.Settings.Header_CloseButton_Highlight_LightTheme
										end

										addon.API.FrameTemplates.Styles:UpdateButton(Frame.Content.Header.Content.ButtonContainer.CloseButton, {
											customColor = COLOR_Default,
											customHighlightColor = COLOR_Highlight
										})
									end, 3)

									Frame.Content.Header.Content.ButtonContainer.CloseButton:SetScript("OnClick", function()
										NS.Script:HideSettingsUI()
									end)

									--------------------------------

									do -- IMAGE
										Frame.Content.Header.Content.ButtonContainer.CloseButton.Image, Frame.Content.Header.Content.ButtonContainer.CloseButton.ImageTexture = addon.API.FrameTemplates:CreateTexture(Frame.Content.Header.Content.ButtonContainer.CloseButton, "FULLSCREEN", addon.Variables.PATH_ART .. "Elements/Elements/close.png", "$parent.Image")
										Frame.Content.Header.Content.ButtonContainer.CloseButton.Image:SetSize(Frame.Content.Header.Content.ButtonContainer.CloseButton:GetHeight() - NS.Variables:RATIO(8), Frame.Content.Header.Content.ButtonContainer.CloseButton:GetHeight() - NS.Variables:RATIO(8))
										Frame.Content.Header.Content.ButtonContainer.CloseButton.Image:SetPoint("CENTER", Frame.Content.Header.Content.ButtonContainer.CloseButton)
										Frame.Content.Header.Content.ButtonContainer.CloseButton.Image:SetFrameStrata("FULLSCREEN_DIALOG")
										Frame.Content.Header.Content.ButtonContainer.CloseButton.Image:SetFrameLevel(7)

										addon.API.Main:RegisterThemeUpdate(function()
											local COLOR_Default

											if addon.Theme.IsDarkTheme then
												COLOR_Default = addon.Theme.Settings.Header_CloseButton_Image_DarkTheme
											else
												COLOR_Default = addon.Theme.Settings.Header_CloseButton_Image_LightTheme
											end

											Frame.Content.Header.Content.ButtonContainer.CloseButton.ImageTexture:SetVertexColor(COLOR_Default.r, COLOR_Default.g, COLOR_Default.b, COLOR_Default.a)
										end, 5)
									end
								end
							end
						end
					end

					do -- SCROLL FRAME
						local PADDING_SCROLLBAR = NS.Variables:RATIO(8)

						Frame.Content.ScrollFrame, Frame.Content.ScrollChildFrame = CreateScrollFrame(Frame.Content)
						Frame.Content.ScrollFrame:SetSize(PRIMARY_CONTENT_WIDTH - PADDING_SCROLLBAR, Frame.Content:GetHeight() - Frame.Content.Header:GetHeight() - NS.Variables:RATIO(9))
						Frame.Content.ScrollFrame:SetPoint("TOP", Frame.Content, -PADDING_SCROLLBAR, -Frame.Content.Header:GetHeight() - NS.Variables:RATIO(9))
						Frame.Content.ScrollFrame:SetFrameLevel(3)

						--------------------------------

						Frame.Content.ScrollFrame.tabPool = {}
						Frame.Content.ScrollFrame.CreateTab = function(index)
							local Tab = CreateFrame("Frame")
							Tab:SetParent(Frame.Content.ScrollChildFrame)
							Tab:SetSize(Frame.Content.ScrollFrame:GetWidth(), 1)
							Tab:SetPoint("TOP", Frame.Content.ScrollChildFrame)

							--------------------------------

							table.insert(Frame.Content.ScrollFrame.tabPool, index, Tab)

							--------------------------------

							return Tab
						end

						--------------------------------

						do -- SCROLL BAR
							Frame.Content.ScrollFrame.Scrollbar = addon.API.FrameTemplates:CreateScrollbar(Frame.Content.ScrollFrame, "FULLSCREEN_DIALOG", Frame.Content.ScrollFrame:GetFrameLevel() + 9, {
								scrollFrame = Frame.Content.ScrollFrame,
								scrollChildFrame = Frame.Content.ScrollChildFrame,
								sizeX = 5,
								sizeY = Frame.Content.ScrollFrame:GetHeight(),
								theme = nil,
								isHorizontal = false,
							}, "$parent.Scrollbar")
							Frame.Content.ScrollFrame.Scrollbar:SetPoint("RIGHT", Frame.Content.ScrollFrame, (Frame.Content.ScrollFrame.Scrollbar:GetWidth() / 2) + (NS.Variables:RATIO(6)), 0)

							--------------------------------

							addon.API.Main:RegisterThemeUpdate(function()
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
									COLOR_Default_Thumb = addon.Theme.Settings.Element_Default_LightTheme
									COLOR_Highlight_Thumb = addon.Theme.Settings.Element_Default_LightTheme
								end

								addon.API.FrameTemplates:UpdateScrollbarTheme(Frame.Content.ScrollFrame.Scrollbar, {
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
					Frame.Sidebar = CreateFrame("Frame", "$parent.Sidebar", Frame.Container)
					Frame.Sidebar:SetSize(SECONDARY_WIDTH - PADDING, CONTENT_HEIGHT)
					Frame.Sidebar:SetPoint("LEFT", Frame.Container)
					Frame.Sidebar:SetFrameLevel(3)

					--------------------------------

					do -- LEGEND
						Frame.Sidebar.Legend, Frame.Sidebar.LegendScrollChildFrame = CreateScrollFrame(Frame.Container)
						Frame.Sidebar.Legend:SetSize(Frame.Sidebar:GetWidth(), Frame.Sidebar:GetHeight())
						Frame.Sidebar.Legend:SetPoint("CENTER", Frame.Sidebar)
						Frame.Sidebar.Legend:SetFrameLevel(3)
						Frame.Sidebar.LegendScrollChildFrame:SetWidth(Frame.Sidebar.Legend:GetWidth())

						--------------------------------

						do -- GAMEPAD
							Frame.Sidebar.Legend.GamePad = CreateFrame("Frame", "$parent.GamePad", Frame.Sidebar.Legend)
							Frame.Sidebar.Legend.GamePad:SetAllPoints(Frame.Sidebar.Legend)
							Frame.Sidebar.Legend.GamePad:SetFrameLevel(4)

							--------------------------------

							do -- TOP
								Frame.Sidebar.Legend.GamePad.Top = CreateFrame("Frame", "$parent.Top", Frame.Sidebar.Legend.GamePad)
								Frame.Sidebar.Legend.GamePad.Top:SetSize(Frame.Sidebar.Legend.GamePad:GetWidth(), 50)
								Frame.Sidebar.Legend.GamePad.Top:SetPoint("TOP", Frame.Sidebar.Legend.GamePad, 0, Frame.Sidebar.Legend.GamePad.Top:GetHeight() + NS.Variables:RATIO(8))
								Frame.Sidebar.Legend.GamePad.Top:SetFrameLevel(5)

								--------------------------------

								do -- ICON
									Frame.Sidebar.Legend.GamePad.Top.Icon, Frame.Sidebar.Legend.GamePad.Top.IconTexture = addon.API.FrameTemplates:CreateTexture(Frame.Sidebar.Legend.GamePad.Top, "FULLSCREEN_DIALOG", nil, "$parent.Icon")
									Frame.Sidebar.Legend.GamePad.Top.Icon:SetSize(Frame.Sidebar.Legend.GamePad.Top:GetHeight(), Frame.Sidebar.Legend.GamePad.Top:GetHeight())
									Frame.Sidebar.Legend.GamePad.Top.Icon:SetPoint("CENTER", Frame.Sidebar.Legend.GamePad.Top)

									addon.API.Main:RegisterThemeUpdate(function()
										local TEXTURE

										if addon.Theme.IsDarkTheme then
											TEXTURE = addon.Variables.PATH_ART .. "Platform/Platform-LB-Up-Light.png"
										else
											TEXTURE = addon.Variables.PATH_ART .. "Platform/Platform-LB-Up.png"
										end

										Frame.Sidebar.Legend.GamePad.Top.IconTexture:SetTexture(TEXTURE)
									end, 5)
								end
							end

							do -- BOTTOM
								Frame.Sidebar.Legend.GamePad.Bottom = CreateFrame("Frame", "$parent.Bottom", Frame.Sidebar.Legend.GamePad)
								Frame.Sidebar.Legend.GamePad.Bottom:SetSize(Frame.Sidebar.Legend.GamePad:GetWidth(), 50)
								Frame.Sidebar.Legend.GamePad.Bottom:SetPoint("BOTTOM", Frame.Sidebar.Legend.GamePad, 0, -Frame.Sidebar.Legend.GamePad.Bottom:GetHeight() - NS.Variables:RATIO(8))
								Frame.Sidebar.Legend.GamePad.Bottom:SetFrameLevel(5)

								--------------------------------

								do -- ICON
									Frame.Sidebar.Legend.GamePad.Bottom.Icon, Frame.Sidebar.Legend.GamePad.Bottom.IconTexture = addon.API.FrameTemplates:CreateTexture(Frame.Sidebar.Legend.GamePad.Bottom, "FULLSCREEN_DIALOG", nil, "$parent.Icon")
									Frame.Sidebar.Legend.GamePad.Bottom.Icon:SetSize(Frame.Sidebar.Legend.GamePad.Bottom:GetHeight(), Frame.Sidebar.Legend.GamePad.Bottom:GetHeight())
									Frame.Sidebar.Legend.GamePad.Bottom.Icon:SetPoint("CENTER", Frame.Sidebar.Legend.GamePad.Bottom)

									addon.API.Main:RegisterThemeUpdate(function()
										local TEXTURE

										if addon.Theme.IsDarkTheme then
											TEXTURE = addon.Variables.PATH_ART .. "Platform/Platform-RB-Down-Light.png"
										else
											TEXTURE = addon.Variables.PATH_ART .. "Platform/Platform-RB-Down.png"
										end

										Frame.Sidebar.Legend.GamePad.Bottom.IconTexture:SetTexture(TEXTURE)
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

				Frame.Tooltip = CreateFrame("Frame", "$parent.Tooltip", Frame)
				Frame.Tooltip:SetSize(NS.Variables:RATIO(1.5), NS.Variables:RATIO(1.5))
				Frame.Tooltip:SetPoint("RIGHT", Frame, Frame.Tooltip:GetWidth() + NS.Variables:RATIO(5), 0)
				Frame.Tooltip:SetFrameStrata("FULLSCREEN_DIALOG")
				Frame.Tooltip:SetFrameLevel(99)

				Frame.Tooltip:SetScript("OnUpdate", function()
					Frame.Tooltip.Content.Text:ClearAllPoints()

					if Frame.Tooltip.Content.Image:IsVisible() then
						Frame.Tooltip:SetHeight(Padding + Frame.Tooltip.Content.Image:GetHeight() + Padding / 2 + Frame.Tooltip.Content.Text:GetStringHeight() + Padding)
						Frame.Tooltip.Content.Text:SetPoint("TOP", Frame.Tooltip.Content, 0, -Frame.Tooltip.Content.Image:GetHeight() - Padding / 2)
					else
						Frame.Tooltip:SetHeight(Padding + Frame.Tooltip.Content.Text:GetStringHeight() + Padding)
						Frame.Tooltip.Content.Text:SetPoint("TOP", Frame.Tooltip.Content, 0, 0)
					end

					Frame.Tooltip.Background:SetSize(Frame.Tooltip:GetWidth(), Frame.Tooltip:GetHeight())
					Frame.Tooltip.Content:SetSize(Frame.Tooltip:GetWidth() - Padding * 2, Frame.Tooltip:GetHeight() - Padding * 2)
				end)

				--------------------------------

				do -- BACKGROUND
					Frame.Tooltip.Background, Frame.Tooltip.BackgroundTexture = addon.API.FrameTemplates:CreateNineSlice(Frame.Tooltip, "FULLSCREEN_DIALOG", nil, 256, .175, "$parent.Background")
					Frame.Tooltip.Background:SetSize(Frame.Tooltip:GetWidth(), Frame.Tooltip:GetHeight())
					Frame.Tooltip.Background:SetPoint("CENTER", Frame.Tooltip)
					Frame.Tooltip.Background:SetFrameLevel(98)
				end

				do -- CONTENT
					Frame.Tooltip.Content = CreateFrame("Frame", "$parent.Content", Frame.Tooltip)
					Frame.Tooltip.Content:SetSize(Frame.Tooltip:GetWidth() - Padding * 2, Frame.Tooltip:GetHeight() - Padding * 2)
					Frame.Tooltip.Content:SetPoint("CENTER", Frame.Tooltip)
					Frame.Tooltip.Content:SetFrameLevel(100)
				end

				do -- IMAGE
					Frame.Tooltip.Content.Image, Frame.Tooltip.Content.ImageTexture = addon.API.FrameTemplates:CreateTexture(Frame.Tooltip.Content, "FULLSCREEN_DIALOG", nil, "$parent.Image")
					Frame.Tooltip.Content.Image:SetPoint("TOP", Frame.Tooltip.Content)
					Frame.Tooltip.Content.Image:SetFrameLevel(102)

					--------------------------------

					do -- BACKGROUND
						Frame.Tooltip.Content.Image.Background, Frame.Tooltip.Content.Image.BackgroundTexture = addon.API.FrameTemplates:CreateNineSlice(Frame.Tooltip.Content.Image, "FULLSCREEN_DIALOG", NS.Variables.SETTINGS_PATH .. "tooltip-image-background.png", 50, 1, "$parent.Background")
						Frame.Tooltip.Content.Image.Background:SetPoint("TOPLEFT", Frame.Tooltip.Content.Image, -2.5, 2.5)
						Frame.Tooltip.Content.Image.Background:SetPoint("BOTTOMRIGHT", Frame.Tooltip.Content.Image, 2.5, -2.5)
						Frame.Tooltip.Content.Image.Background:SetFrameLevel(101)
						Frame.Tooltip.Content.Image.Background:SetAlpha(.25)

						--------------------------------

						addon.API.Main:RegisterThemeUpdate(function()
							local TEXTURE_Background

							if addon.Theme.IsDarkTheme then
								TEXTURE_Background = NS.Variables.SETTINGS_PATH .. "tooltip-image-background-dark.png"
							else
								TEXTURE_Background = NS.Variables.SETTINGS_PATH .. "tooltip-image-background.png"
							end

							Frame.Tooltip.Content.Image.BackgroundTexture:SetTexture(TEXTURE_Background)
						end, 5)
					end
				end

				do -- TEXT
					Frame.Tooltip.Content.Text = addon.API.FrameTemplates:CreateText(Frame.Tooltip.Content, addon.Theme.RGB_RECOMMENDED, 15, "LEFT", "TOP", addon.API.Fonts.CONTENT_LIGHT, "$parent.Text")
					Frame.Tooltip.Content.Text:SetSize(Frame.Tooltip.Content:GetWidth(), 250)
				end

				--------------------------------

				local function UpdateTheme()
					local TEXTURE_Background

					if addon.Theme.IsDarkTheme then
						TEXTURE_Background = addon.API.Presets.NINESLICE_STYLISED_SCROLL_02
					else
						TEXTURE_Background = addon.API.Presets.NINESLICE_STYLISED_SCROLL
					end

					Frame.Tooltip.BackgroundTexture:SetTexture(TEXTURE_Background)
				end

				UpdateTheme()
				addon.API.Main:RegisterThemeUpdate(UpdateTheme, 5)

				--------------------------------

				Frame.Tooltip:Hide()
			end
		end
	end
end
