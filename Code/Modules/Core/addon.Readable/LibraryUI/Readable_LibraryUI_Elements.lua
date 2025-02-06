local addonName, addon = ...
local CallbackRegistry = addon.CallbackRegistry
local L = addon.Locales
local NS = addon.Readable

--------------------------------

NS.LibraryUI.Elements = {}

--------------------------------

function NS.LibraryUI.Elements:Load()
	--------------------------------
	-- CREATE ELEMENTS
	--------------------------------

	do
		do -- CREATE ELEMENTS
			InteractionReadableUIFrame.LibraryUIFrame = CreateFrame("Frame", "$parent.LibraryUIFrame", InteractionReadableUIFrame)
			InteractionReadableUIFrame.LibraryUIFrame:SetSize(InteractionReadableUIFrame:GetWidth(), InteractionReadableUIFrame:GetHeight())
			InteractionReadableUIFrame.LibraryUIFrame:SetPoint("CENTER", InteractionReadableUIFrame)
			InteractionReadableUIFrame.LibraryUIFrame:SetFrameStrata("FULLSCREEN")
			InteractionReadableUIFrame.LibraryUIFrame:SetFrameLevel(3)

			--------------------------------

			NS.Variables.LibraryUIFrame = InteractionReadableUIFrame.LibraryUIFrame
			local LibraryUIFrame = InteractionReadableUIFrame.LibraryUIFrame

			--------------------------------

			do -- BACKGROUND
				LibraryUIFrame.Background, LibraryUIFrame.BackgroundTexture = AdaptiveAPI.FrameTemplates:CreateTexture(LibraryUIFrame, "FULLSCREEN", NS.Variables.READABLE_UI_PATH .. "Library/background-library.png", "$parent.Background")
				LibraryUIFrame.Background:SetSize(LibraryUIFrame:GetHeight(), LibraryUIFrame:GetHeight())
				LibraryUIFrame.Background:SetScale(1.25)
				LibraryUIFrame.Background:SetPoint("CENTER", LibraryUIFrame)
				LibraryUIFrame.Background:SetFrameStrata("FULLSCREEN")
				LibraryUIFrame.Background:SetFrameLevel(2)
			end

			do -- CONTENT
				local PADDING = NS.Variables:RATIO(8)

				--------------------------------

				LibraryUIFrame.Content = CreateFrame("Frame", "$parent.Content", LibraryUIFrame)
				LibraryUIFrame.Content:SetSize(NS.Variables:RATIO(.875), LibraryUIFrame:GetHeight() / addon.Variables:RAW_RATIO(1))
				LibraryUIFrame.Content:SetPoint("CENTER", LibraryUIFrame, 0, LibraryUIFrame:GetHeight() * .0325)
				LibraryUIFrame.Content:SetFrameStrata("FULLSCREEN")
				LibraryUIFrame.Content:SetFrameLevel(3)

				--------------------------------

				do -- TITLE
					LibraryUIFrame.Content.Title = CreateFrame("Frame", "$parent.Title", LibraryUIFrame.Content)
					LibraryUIFrame.Content.Title:SetSize(LibraryUIFrame.Content:GetWidth(), NS.Variables:RATIO(5))
					LibraryUIFrame.Content.Title:SetPoint("TOP", LibraryUIFrame.Content, 0, 0)

					--------------------------------

					do -- MAIN
						LibraryUIFrame.Content.Title.Main = CreateFrame("Frame", "$parent.Main", LibraryUIFrame.Content.Title)
						LibraryUIFrame.Content.Title.Main:SetSize(LibraryUIFrame.Content.Title:GetWidth(), LibraryUIFrame.Content.Title:GetHeight() - NS.Variables:RATIO(10))
						LibraryUIFrame.Content.Title.Main:SetPoint("TOP", LibraryUIFrame.Content.Title)

						--------------------------------

						do -- TEXT
							local height = (LibraryUIFrame.Content.Title:GetHeight())
							local ratio = addon.Variables:RAW_RATIO(1)
							local new = height / ratio

							--------------------------------

							LibraryUIFrame.Content.Title.Main.Text = AdaptiveAPI.FrameTemplates:CreateText(LibraryUIFrame.Content.Title.Main, addon.Theme.RGB_WHITE, 30, "CENTER", "MIDDLE", AdaptiveAPI.Fonts.Title_Bold, "$parent.Text")
							LibraryUIFrame.Content.Title.Main.Text:SetSize(LibraryUIFrame.Content.Title:GetWidth(), new)
							LibraryUIFrame.Content.Title.Main.Text:SetPoint("TOP", LibraryUIFrame.Content.Title)
							LibraryUIFrame.Content.Title.Main.Text:SetAlpha(.75)
						end

						do -- SUBTEXT
							local height = (LibraryUIFrame.Content.Title:GetHeight())
							local ratio = addon.Variables:RAW_RATIO(1)
							local new = height - (height / ratio)

							--------------------------------

							LibraryUIFrame.Content.Title.Main.Subtext = AdaptiveAPI.FrameTemplates:CreateText(LibraryUIFrame.Content.Title.Main, addon.Theme.RGB_WHITE, 12.5, "CENTER", "MIDDLE", AdaptiveAPI.Fonts.Content_Light, "$parent.Subtext")
							LibraryUIFrame.Content.Title.Main.Subtext:SetSize(LibraryUIFrame.Content.Title:GetWidth(), new)
							LibraryUIFrame.Content.Title.Main.Subtext:SetPoint("BOTTOM", LibraryUIFrame.Content.Title.Main)
							LibraryUIFrame.Content.Title.Main.Subtext:SetAlpha(.5)
						end
					end

					do -- DIVIDER
						LibraryUIFrame.Content.Title.Divider, LibraryUIFrame.Content.Title.DividerTexture = AdaptiveAPI.FrameTemplates:CreateTexture(LibraryUIFrame.Content.Title, "FULLSCREEN", NS.Variables.READABLE_UI_PATH .. "Library/divider-title.png", "$parent.Divider")
						LibraryUIFrame.Content.Title.Divider:SetSize(LibraryUIFrame.Content.Title:GetWidth(), LibraryUIFrame.Content.Title:GetWidth() / 12.5)
						LibraryUIFrame.Content.Title.Divider:SetPoint("BOTTOM", LibraryUIFrame.Content.Title, 0, 0)
					end
				end

				do -- SIDEBAR
					local width = LibraryUIFrame.Content:GetWidth()
					local ratio = addon.Variables:RAW_RATIO(3)
					local new = width / ratio

					LibraryUIFrame.Content.Sidebar = CreateFrame("Frame", "$parent.Sidebar", LibraryUIFrame.Content)
					LibraryUIFrame.Content.Sidebar:SetSize(new, LibraryUIFrame.Content:GetHeight() - LibraryUIFrame.Content.Title:GetHeight())
					LibraryUIFrame.Content.Sidebar:SetPoint("TOPLEFT", LibraryUIFrame.Content, 0, -LibraryUIFrame.Content.Title:GetHeight() - PADDING)
					LibraryUIFrame.Content.Sidebar:SetAlpha(1)

					--------------------------------

					LibraryUIFrame.Content.Sidebar.Elements = {}

					LibraryUIFrame.Content.Sidebar.AddElement = function(element)
						table.insert(LibraryUIFrame.Content.Sidebar.Elements, element)
					end

					--------------------------------

					do -- SEARCH
						local function UpdateSearch(self)
							NS.LibraryUI.Script:SetPageButtons(false)
						end

						--------------------------------

						LibraryUIFrame.Content.Sidebar.Search = AdaptiveAPI.FrameTemplates:CreateInputBox(LibraryUIFrame.Content.Sidebar, "FULLSCREEN", {
							defaultTexture = NS.Variables.NINESLICE_RUSTIC_BORDER,
							highlightTexture = NS.Variables.NINESLICE_RUSTIC,
							edgeSize = 128,
							scale = .075,
							textColor = addon.Theme.RGB_WHITE,
							fontSize = 12.5,
							justifyH = "LEFT",
							justifyV = "MIDDLE",
							hint = L["Readable - Library - Search Input Placeholder"],
							valueUpdateCallback = UpdateSearch
						}, "$parent.Search")
						LibraryUIFrame.Content.Sidebar.Search:SetSize(LibraryUIFrame.Content.Sidebar:GetWidth() - 20, 35)
						LibraryUIFrame.Content.Sidebar.Search.BackgroundTexture:SetAlpha(.125)

						--------------------------------

						LibraryUIFrame.Content.Sidebar.AddElement(LibraryUIFrame.Content.Sidebar.Search)

						--------------------------------

						addon.SoundEffects:SetInputBox(LibraryUIFrame.Content.Sidebar.Search, addon.SoundEffects.Readable_LibraryUI_Input_Enter, addon.SoundEffects.Readable_LibraryUI_Input_Leave, addon.SoundEffects.Readable_LibraryUI_Input_MouseDown, addon.SoundEffects.Readable_LibraryUI_Input_MouseUp, addon.SoundEffects.Readable_LibraryUI_Input_ValueChanged)
					end

					do -- CATEGORIES
						local function CreateCheckbox(callback, text, name)
							local Checkbox = AdaptiveAPI.FrameTemplates:CreateAdvancedCheckbox(LibraryUIFrame.Content.Sidebar, "FULLSCREEN", {
								defaultTexture = NS.Variables.NINESLICE_RUSTIC_BORDER,
								highlightTexture = NS.Variables.NINESLICE_RUSTIC,
								checkTexture = NS.Variables.TEXTURE_CHECK,
								edgeSize = 128,
								scale = .075,
								labelText = text,
								textColor = addon.Theme.RGB_WHITE,
								callbackFunction = callback,
							}, name)
							Checkbox:SetSize(LibraryUIFrame.Content.Sidebar:GetWidth(), 35)
							Checkbox.Checkbox.BackgroundTexture:SetAlpha(.25)
							Checkbox.Checkbox.Icon:SetAlpha(.5)
							Checkbox.Label:SetAlpha(.5)

							Checkbox.Detail = AdaptiveAPI.FrameTemplates:CreateText(Checkbox, addon.Theme.RGB_WHITE, 12.5, "RIGHT", "MIDDLE", AdaptiveAPI.Fonts.Content_Light, "$parent.Detail")
							Checkbox.Detail:SetSize(Checkbox:GetWidth(), 35)
							Checkbox.Detail:SetPoint("RIGHT", Checkbox, -7.5, 0)
							Checkbox.Detail:SetAlpha(.25)

							--------------------------------

							LibraryUIFrame.Content.Sidebar.AddElement(Checkbox)

							--------------------------------

							addon.SoundEffects:SetCheckbox(Checkbox, addon.SoundEffects.Readable_LibraryUI_Checkbox_Enter, addon.SoundEffects.Readable_LibraryUI_Checkbox_Leave, addon.SoundEffects.Readable_LibraryUI_Checkbox_MouseDown, addon.SoundEffects.Readable_LibraryUI_Checkbox_MouseUp)

							--------------------------------

							return Checkbox
						end

						--------------------------------

						do -- LABEL (SHOW)
							LibraryUIFrame.Content.Sidebar.Label_Show = AdaptiveAPI.FrameTemplates:CreateText(LibraryUIFrame.Content.Sidebar, addon.Theme.RGB_WHITE, 12.5, "LEFT", "MIDDLE", AdaptiveAPI.Fonts.Content_Light, "$parent.Label_Show")
							LibraryUIFrame.Content.Sidebar.Label_Show:SetSize(LibraryUIFrame.Content.Sidebar:GetWidth(), 35)
							LibraryUIFrame.Content.Sidebar.Label_Show:SetAlpha(.5)
							LibraryUIFrame.Content.Sidebar.Label_Show:SetText(L["Readable - Library - Show"])

							--------------------------------

							LibraryUIFrame.Content.Sidebar.AddElement(LibraryUIFrame.Content.Sidebar.Label_Show)
						end

						do -- CHECKBOX (LETTERS)
							local function Click()
								NS.LibraryUI.Script:SetPageButtons()
							end

							--------------------------------

							LibraryUIFrame.Content.Sidebar.Type_Letter = CreateCheckbox(Click, L["Readable - Library - Letters"], "$parent.Letters")
						end

						do -- CHECKBOX (BOOKS)
							local function Click()
								NS.LibraryUI.Script:SetPageButtons()
							end

							--------------------------------

							LibraryUIFrame.Content.Sidebar.Type_Book = CreateCheckbox(Click, L["Readable - Library - Books"], "$parent.Type_Book")
						end

						do -- CHECKBOX (SLATES)
							local function Click()
								NS.LibraryUI.Script:SetPageButtons()
							end

							--------------------------------

							LibraryUIFrame.Content.Sidebar.Type_Slate = CreateCheckbox(Click, L["Readable - Library - Slates"], "$parent.Type_Slate")
						end

						do -- CHECKBOX (IN-WORLD)
							local function Click()
								NS.LibraryUI.Script:SetPageButtons()
							end

							--------------------------------

							LibraryUIFrame.Content.Sidebar.Type_InWorld = CreateCheckbox(Click, L["Readable - Library - Show only World"], "$parent.Type_InWorld")
						end
					end

					do -- BUTTONS
						local function CreateButton(callback, text, name)
							local Button = AdaptiveAPI.FrameTemplates:CreateCustomButton(LibraryUIFrame.Content.Sidebar, LibraryUIFrame.Content.Sidebar:GetWidth(), 35, "FULLSCREEN", {
								defaultTexture = NS.Variables.NINESLICE_RUSTIC_BORDER,
								highlightTexture = NS.Variables.NINESLICE_RUSTIC,
								edgeSize = 128,
								scale = .075,
								theme = 2,
								playAnimation = false,
								customColor = { r = 1, g = 1, b = 1, a = .125 },
								customHighlightColor = { r = 1, g = 1, b = 1, a = .25 },
								customActiveColor = nil,
								customTextColor = { r = 1, g = 1, b = 1, a = .5 },
								customTextHighlightColor = { r = 1, g = 1, b = 1, a = .5 },
								disableMouseDown = true,
								disableMouseUp = true,
							}, name)
							Button:SetText(text)

							--------------------------------

							Button:SetScript("OnClick", callback)

							--------------------------------

							return Button
						end

						--------------------------------

						LibraryUIFrame.Content.Sidebar.Button_Export = CreateButton(function() NS.LibraryUI.Script:Export() end, L["Readable - Library - Export Button"], "$parent.Button_Export")
						LibraryUIFrame.Content.Sidebar.Button_Export:SetPoint("BOTTOM", LibraryUIFrame.Content.Sidebar, 0, 35 + 15)
						addon.SoundEffects:SetButton(LibraryUIFrame.Content.Sidebar.Button_Export, addon.SoundEffects.Readable_Button_Enter, addon.SoundEffects.Readable_Button_Leave, addon.SoundEffects.Readable_Button_MouseDown, addon.SoundEffects.Readable_Button_MouseUp)

						LibraryUIFrame.Content.Sidebar.Button_Import = CreateButton(function() NS.LibraryUI.Script:ImportPrompt() end, L["Readable - Library - Import Button"], "$parent.Button_Import")
						LibraryUIFrame.Content.Sidebar.Button_Import:SetPoint("BOTTOM", LibraryUIFrame.Content.Sidebar, 0, 0)
						addon.SoundEffects:SetButton(LibraryUIFrame.Content.Sidebar.Button_Import, addon.SoundEffects.Readable_Button_Enter, addon.SoundEffects.Readable_Button_Leave, addon.SoundEffects.Readable_Button_MouseDown, addon.SoundEffects.Readable_Button_MouseUp)
					end
				end

				do -- DIVIDER
					LibraryUIFrame.Content.Divider, LibraryUIFrame.Content.DividerTexture = AdaptiveAPI.FrameTemplates:CreateTexture(LibraryUIFrame.Content, "FULLSCREEN", NS.Variables.READABLE_UI_PATH .. "Library/divider-sidebar.png", "$parent.Divider")
					LibraryUIFrame.Content.Divider:SetSize(1, LibraryUIFrame.Content:GetHeight() - LibraryUIFrame.Content.Title:GetHeight())
					LibraryUIFrame.Content.Divider:SetPoint("TOPLEFT", LibraryUIFrame.Content, LibraryUIFrame.Content.Sidebar:GetWidth() + PADDING - LibraryUIFrame.Content.Divider:GetWidth() / 2, -LibraryUIFrame.Content.Title:GetHeight() - PADDING)
				end

				do -- CONTENT
					local width = LibraryUIFrame.Content:GetWidth()
					local ratio = addon.Variables:RAW_RATIO(3)
					local new = width - (width / ratio)

					LibraryUIFrame.Content.ContentFrame = CreateFrame("Frame", "$parent.ContentFrame", LibraryUIFrame.Content)
					LibraryUIFrame.Content.ContentFrame:SetSize(new - PADDING * 2, LibraryUIFrame.Content:GetHeight() - LibraryUIFrame.Content.Title:GetHeight())
					LibraryUIFrame.Content.ContentFrame:SetPoint("TOPRIGHT", LibraryUIFrame.Content, 0, -LibraryUIFrame.Content.Title:GetHeight() - PADDING)

					--------------------------------

					do -- INDEX FRAME
						local PADDING = NS.Variables:RATIO(9)

						--------------------------------

						LibraryUIFrame.Content.ContentFrame.Index = CreateFrame("Frame", "$parent.Index", LibraryUIFrame.Content.ContentFrame)
						LibraryUIFrame.Content.ContentFrame.Index:SetSize(LibraryUIFrame.Content.ContentFrame:GetWidth(), NS.Variables:RATIO(6.5))
						LibraryUIFrame.Content.ContentFrame.Index:SetPoint("BOTTOM", LibraryUIFrame.Content.ContentFrame, 0, 0)
						LibraryUIFrame.Content.ContentFrame.Index:SetFrameStrata("FULLSCREEN")
						LibraryUIFrame.Content.ContentFrame.Index:SetFrameLevel(10)

						--------------------------------

						do -- BACKGROUND
							LibraryUIFrame.Content.ContentFrame.Index.Background, LibraryUIFrame.Content.ContentFrame.Index.BackgroundTexture = AdaptiveAPI.FrameTemplates:CreateNineSlice(LibraryUIFrame.Content.ContentFrame.Index, "FULLSCREEN", NS.Variables.READABLE_UI_PATH .. "Library/index-background-nineslice.png", 64, .25, "$parent.Background")
							LibraryUIFrame.Content.ContentFrame.Index.Background:SetPoint("TOPLEFT", LibraryUIFrame.Content.ContentFrame.Index, -5, 5)
							LibraryUIFrame.Content.ContentFrame.Index.Background:SetPoint("BOTTOMRIGHT", LibraryUIFrame.Content.ContentFrame.Index, 5, -5)
							LibraryUIFrame.Content.ContentFrame.Index.Background:SetPoint("CENTER", LibraryUIFrame.Content.ContentFrame.Index)
							LibraryUIFrame.Content.ContentFrame.Index.Background:SetFrameStrata("FULLSCREEN")
							LibraryUIFrame.Content.ContentFrame.Index.Background:SetFrameLevel(9)
							LibraryUIFrame.Content.ContentFrame.Index.Background:SetAlpha(.5)
						end

						do -- CONTENT
							LibraryUIFrame.Content.ContentFrame.Index.Content = CreateFrame("Frame", "$parent.Content", LibraryUIFrame.Content.ContentFrame.Index)
							LibraryUIFrame.Content.ContentFrame.Index.Content:SetSize(LibraryUIFrame.Content.ContentFrame.Index:GetWidth() - PADDING, LibraryUIFrame.Content.ContentFrame.Index:GetHeight() - PADDING)
							LibraryUIFrame.Content.ContentFrame.Index.Content:SetPoint("CENTER", LibraryUIFrame.Content.ContentFrame.Index)
							LibraryUIFrame.Content.ContentFrame.Index.Content:SetFrameStrata("FULLSCREEN")
							LibraryUIFrame.Content.ContentFrame.Index.Content:SetFrameLevel(11)

							--------------------------------

							do -- TEXT
								LibraryUIFrame.Content.ContentFrame.Index.Content.Text = AdaptiveAPI.FrameTemplates:CreateText(LibraryUIFrame.Content.ContentFrame.Index.Content, addon.Theme.RGB_WHITE, 15, "CENTER", "MIDDLE", AdaptiveAPI.Fonts.Content_Light, "$parent.Text")
								LibraryUIFrame.Content.ContentFrame.Index.Content.Text:SetPoint("CENTER", LibraryUIFrame.Content.ContentFrame.Index.Content)
								LibraryUIFrame.Content.ContentFrame.Index.Content.Text:SetText("1/2")
								LibraryUIFrame.Content.ContentFrame.Index.Content.Text:SetAlpha(.5)
							end

							do -- BUTTONS
								do -- PREVIOUS PAGE
									LibraryUIFrame.Content.ContentFrame.Index.Content.Button_PreviousPage = AdaptiveAPI.FrameTemplates:CreateCustomButton(LibraryUIFrame.Content.ContentFrame.Index.Content, LibraryUIFrame.Content.ContentFrame.Index.Content:GetHeight(), LibraryUIFrame.Content.ContentFrame.Index.Content:GetHeight(), "FULLSCREEN", {
										defaultTexture = NS.Variables.NINESLICE_RUSTIC_BORDER,
										highlightTexture = NS.Variables.NINESLICE_RUSTIC,
										edgeSize = 128,
										scale = .075,
										theme = 2,
										playAnimation = false,
										customColor = { r = 1, g = 1, b = 1, a = .125 },
										customHighlightColor = { r = 1, g = 1, b = 1, a = .25 },
										customActiveColor = nil,
										disableMouseDown = true,
										disableMouseUp = true,
									}, "$parent.Button_PreviousPage")
									LibraryUIFrame.Content.ContentFrame.Index.Content.Button_PreviousPage:SetPoint("LEFT", LibraryUIFrame.Content.ContentFrame.Index.Content, 0, 0)
									LibraryUIFrame.Content.ContentFrame.Index.Content.Button_PreviousPage:SetFrameStrata("FULLSCREEN")
									LibraryUIFrame.Content.ContentFrame.Index.Content.Button_PreviousPage:SetFrameLevel(12)

									hooksecurefunc(LibraryUIFrame.Content.ContentFrame.Index.Content.Button_PreviousPage, "SetEnabled", function()
										local IsEnabled = LibraryUIFrame.Content.ContentFrame.Index.Content.Button_PreviousPage:IsEnabled()

										--------------------------------

										if IsEnabled then
											LibraryUIFrame.Content.ContentFrame.Index.Content.Button_PreviousPage:SetAlpha(1)
										else
											LibraryUIFrame.Content.ContentFrame.Index.Content.Button_PreviousPage:SetAlpha(.5)
										end
									end)

									addon.SoundEffects:SetButton(LibraryUIFrame.Content.ContentFrame.Index.Content.Button_PreviousPage, addon.SoundEffects.Readable_LibraryUI_PreviousPageButton_Enter, addon.SoundEffects.Readable_LibraryUI_PreviousPageButton_Leave, addon.SoundEffects.Readable_LibraryUI_PreviousPageButton_MouseDown, addon.SoundEffects.Readable_LibraryUI_PreviousPageButton_MouseUp)

									--------------------------------

									do -- IMAGE
										LibraryUIFrame.Content.ContentFrame.Index.Content.Button_PreviousPage.Image, LibraryUIFrame.Content.ContentFrame.Index.Content.Button_PreviousPage.ImageTexture = AdaptiveAPI.FrameTemplates:CreateTexture(LibraryUIFrame.Content.ContentFrame.Index.Content.Button_PreviousPage, "FULLSCREEN", NS.Variables.READABLE_UI_PATH .. "Library/previous.png", "$parent.Image")
										LibraryUIFrame.Content.ContentFrame.Index.Content.Button_PreviousPage.Image:SetPoint("TOPLEFT", LibraryUIFrame.Content.ContentFrame.Index.Content.Button_PreviousPage, -2.5, 2.5)
										LibraryUIFrame.Content.ContentFrame.Index.Content.Button_PreviousPage.Image:SetPoint("BOTTOMRIGHT", LibraryUIFrame.Content.ContentFrame.Index.Content.Button_PreviousPage, 2.5, -2.5)
										LibraryUIFrame.Content.ContentFrame.Index.Content.Button_PreviousPage.Image:SetScale(.75)
										LibraryUIFrame.Content.ContentFrame.Index.Content.Button_PreviousPage.Image:SetFrameStrata("FULLSCREEN")
										LibraryUIFrame.Content.ContentFrame.Index.Content.Button_PreviousPage.Image:SetFrameLevel(13)
										LibraryUIFrame.Content.ContentFrame.Index.Content.Button_PreviousPage.Image:SetAlpha(.325)
									end
								end

								do -- NEXT PAGE
									LibraryUIFrame.Content.ContentFrame.Index.Content.Button_NextPage = AdaptiveAPI.FrameTemplates:CreateCustomButton(LibraryUIFrame.Content.ContentFrame.Index.Content, LibraryUIFrame.Content.ContentFrame.Index.Content:GetHeight(), LibraryUIFrame.Content.ContentFrame.Index.Content:GetHeight(), "FULLSCREEN", {
										defaultTexture = NS.Variables.NINESLICE_RUSTIC_BORDER,
										highlightTexture = NS.Variables.NINESLICE_RUSTIC,
										edgeSize = 128,
										scale = .075,
										theme = 2,
										playAnimation = false,
										customColor = { r = 1, g = 1, b = 1, a = .125 },
										customHighlightColor = { r = 1, g = 1, b = 1, a = .25 },
										customActiveColor = nil,
										disableMouseDown = true,
										disableMouseUp = true,
									}, "$parent.Button_NextPage")
									LibraryUIFrame.Content.ContentFrame.Index.Content.Button_NextPage:SetPoint("RIGHT", LibraryUIFrame.Content.ContentFrame.Index.Content, 0, 0)
									LibraryUIFrame.Content.ContentFrame.Index.Content.Button_NextPage:SetFrameStrata("FULLSCREEN")
									LibraryUIFrame.Content.ContentFrame.Index.Content.Button_NextPage:SetFrameLevel(12)
									LibraryUIFrame.Content.ContentFrame.Index.Content.Button_NextPage:SetAlpha(.5)

									hooksecurefunc(LibraryUIFrame.Content.ContentFrame.Index.Content.Button_NextPage, "SetEnabled", function()
										local IsEnabled = LibraryUIFrame.Content.ContentFrame.Index.Content.Button_NextPage:IsEnabled()

										--------------------------------

										if IsEnabled then
											LibraryUIFrame.Content.ContentFrame.Index.Content.Button_NextPage:SetAlpha(1)
										else
											LibraryUIFrame.Content.ContentFrame.Index.Content.Button_NextPage:SetAlpha(.5)
										end
									end)

									addon.SoundEffects:SetButton(LibraryUIFrame.Content.ContentFrame.Index.Content.Button_NextPage, addon.SoundEffects.Readable_LibraryUI_NextPageButton_Enter, addon.SoundEffects.Readable_LibraryUI_NextPageButton_Leave, addon.SoundEffects.Readable_LibraryUI_NextPageButton_MouseDown, addon.SoundEffects.Readable_LibraryUI_NextPageButton_MouseUp)

									--------------------------------

									do -- IMAGE
										LibraryUIFrame.Content.ContentFrame.Index.Content.Button_NextPage.Image, LibraryUIFrame.Content.ContentFrame.Index.Content.Button_NextPage.ImageTexture = AdaptiveAPI.FrameTemplates:CreateTexture(LibraryUIFrame.Content.ContentFrame.Index.Content.Button_NextPage, "FULLSCREEN", NS.Variables.READABLE_UI_PATH .. "Library/next.png", "$parent.Image")
										LibraryUIFrame.Content.ContentFrame.Index.Content.Button_NextPage.Image:SetPoint("TOPLEFT", LibraryUIFrame.Content.ContentFrame.Index.Content.Button_NextPage, -2.5, 2.5)
										LibraryUIFrame.Content.ContentFrame.Index.Content.Button_NextPage.Image:SetPoint("BOTTOMRIGHT", LibraryUIFrame.Content.ContentFrame.Index.Content.Button_NextPage, 2.5, -2.5)
										LibraryUIFrame.Content.ContentFrame.Index.Content.Button_NextPage.Image:SetScale(.75)
										LibraryUIFrame.Content.ContentFrame.Index.Content.Button_NextPage.Image:SetFrameStrata("FULLSCREEN")
										LibraryUIFrame.Content.ContentFrame.Index.Content.Button_NextPage.Image:SetFrameLevel(13)
										LibraryUIFrame.Content.ContentFrame.Index.Content.Button_NextPage.Image:SetAlpha(.325)
									end
								end
							end
						end
					end

					do -- CONTENT FRAME
						do -- SCROLL FRAME
							LibraryUIFrame.Content.ContentFrame.ScrollFrame, LibraryUIFrame.Content.ContentFrame.ScrollChildFrame = AdaptiveAPI.FrameTemplates:CreateScrollFrame(LibraryUIFrame.Content.ContentFrame, "vertical")
							LibraryUIFrame.Content.ContentFrame.ScrollFrame:SetWidth(LibraryUIFrame.Content.ContentFrame:GetWidth())
							LibraryUIFrame.Content.ContentFrame.ScrollFrame:SetPoint("TOP", LibraryUIFrame.Content.ContentFrame)

							--------------------------------

							do -- ELEMENTS
								do -- SCROLL INDICATOR
									do -- TOP
										LibraryUIFrame.Content.ContentFrame.ScrollFrame.ScrollIndicator_Top, LibraryUIFrame.Content.ContentFrame.ScrollFrame.ScrollIndicator_TopTexture = AdaptiveAPI.FrameTemplates:CreateTexture(LibraryUIFrame.Content.ContentFrame.ScrollFrame, "FULLSCREEN", NS.Variables.READABLE_UI_PATH .. "Library/content-scroll-indicator-top.png", "$parent.ScrollIndicator_Top")
										LibraryUIFrame.Content.ContentFrame.ScrollFrame.ScrollIndicator_Top:SetSize(LibraryUIFrame.Content.ContentFrame.ScrollFrame:GetWidth(), 50)
										LibraryUIFrame.Content.ContentFrame.ScrollFrame.ScrollIndicator_Top:SetPoint("TOP", LibraryUIFrame.Content.ContentFrame.ScrollFrame, 0, 0)
										LibraryUIFrame.Content.ContentFrame.ScrollFrame.ScrollIndicator_Top:SetFrameStrata("FULLSCREEN")
										LibraryUIFrame.Content.ContentFrame.ScrollFrame.ScrollIndicator_Top:SetFrameLevel(50)
										LibraryUIFrame.Content.ContentFrame.ScrollFrame.ScrollIndicator_Top:SetAlpha(.75)

										--------------------------------

										LibraryUIFrame.Content.ContentFrame.ScrollFrame.ScrollIndicator_Top:Hide()
										LibraryUIFrame.Content.ContentFrame.ScrollFrame.ScrollIndicator_Top.hidden = true
									end

									do -- BOTTOM
										LibraryUIFrame.Content.ContentFrame.ScrollFrame.ScrollIndicator_Bottom, LibraryUIFrame.Content.ContentFrame.ScrollFrame.ScrollIndicator_BottomTexture = AdaptiveAPI.FrameTemplates:CreateTexture(LibraryUIFrame.Content.ContentFrame.ScrollFrame, "FULLSCREEN", NS.Variables.READABLE_UI_PATH .. "Library/content-scroll-indicator-bottom.png", "$parent.ScrollIndicator_Bottom")
										LibraryUIFrame.Content.ContentFrame.ScrollFrame.ScrollIndicator_Bottom:SetSize(LibraryUIFrame.Content.ContentFrame.ScrollFrame:GetWidth(), 50)
										LibraryUIFrame.Content.ContentFrame.ScrollFrame.ScrollIndicator_Bottom:SetPoint("BOTTOM", LibraryUIFrame.Content.ContentFrame.ScrollFrame, 0, 0)
										LibraryUIFrame.Content.ContentFrame.ScrollFrame.ScrollIndicator_Bottom:SetFrameStrata("FULLSCREEN")
										LibraryUIFrame.Content.ContentFrame.ScrollFrame.ScrollIndicator_Bottom:SetFrameLevel(50)
										LibraryUIFrame.Content.ContentFrame.ScrollFrame.ScrollIndicator_Bottom:SetAlpha(.75)

										--------------------------------

										LibraryUIFrame.Content.ContentFrame.ScrollFrame.ScrollIndicator_Bottom:Hide()
										LibraryUIFrame.Content.ContentFrame.ScrollFrame.ScrollIndicator_Bottom.hidden = true
									end
								end

								do -- LABEL
									LibraryUIFrame.Content.ContentFrame.ScrollFrame.Label = AdaptiveAPI.FrameTemplates:CreateText(LibraryUIFrame.Content.ContentFrame.ScrollFrame, addon.Theme.RGB_WHITE, 20, "CENTER", "MIDDLE", AdaptiveAPI.Fonts.Content_Light, "$parent.Label")
									LibraryUIFrame.Content.ContentFrame.ScrollFrame.Label:SetAllPoints(LibraryUIFrame.Content.ContentFrame.ScrollFrame)
									LibraryUIFrame.Content.ContentFrame.ScrollFrame.Label:SetAlpha(.25)
								end

								do -- SCROLL BAR
									LibraryUIFrame.Content.ContentFrame.ScrollFrame.ScrollBar:Hide()

									--------------------------------

									LibraryUIFrame.Content.ContentFrame.Scrollbar = AdaptiveAPI.FrameTemplates:CreateScrollbar(LibraryUIFrame.Content.ContentFrame.ScrollFrame, "FULLSCREEN", {
										scrollFrame = LibraryUIFrame.Content.ContentFrame.ScrollFrame,
										scrollChildFrame = LibraryUIFrame.Content.ContentFrame.ScrollChildFrame,
										sizeX = 5,
										sizeY = LibraryUIFrame.Content.ContentFrame.ScrollFrame:GetHeight(),
										theme = 2,
										isHorizontal = false,
									}, "$parent.Scrollbar")
									LibraryUIFrame.Content.ContentFrame.Scrollbar:SetPoint("RIGHT", LibraryUIFrame.Content.ContentFrame.ScrollFrame, PADDING, 0)
									LibraryUIFrame.Content.ContentFrame.Scrollbar.Thumb:SetAlpha(.5)
									LibraryUIFrame.Content.ContentFrame.Scrollbar.Background:SetAlpha(.1)
								end
							end

							do -- EVENTS
								LibraryUIFrame.Content.ContentFrame.ScrollFrame.UpdateSize = function()
									if LibraryUIFrame.Content.ContentFrame.Index:IsVisible() then
										LibraryUIFrame.Content.ContentFrame.ScrollFrame:SetSize(LibraryUIFrame.Content.ContentFrame:GetWidth(), LibraryUIFrame.Content.ContentFrame:GetHeight() - LibraryUIFrame.Content.ContentFrame.Index:GetHeight() - PADDING / 2)
									else
										LibraryUIFrame.Content.ContentFrame.ScrollFrame:SetSize(LibraryUIFrame.Content.ContentFrame:GetWidth(), LibraryUIFrame.Content.ContentFrame:GetHeight())
									end

									LibraryUIFrame.Content.ContentFrame.Scrollbar:SetHeight(LibraryUIFrame.Content.ContentFrame.ScrollFrame:GetHeight())
								end
								LibraryUIFrame.Content.ContentFrame.ScrollFrame.UpdateSize()

								local function Update()
									if LibraryUIFrame.Content.ContentFrame.ScrollFrame:IsVisible() then
										LibraryUIFrame.Content.ContentFrame.ScrollFrame.RefreshLayout()
										LibraryUIFrame.Content.ContentFrame.ScrollFrame.UpdateScrollIndicator()
									end
								end
								Update()

								--------------------------------

								hooksecurefunc(LibraryUIFrame.Content.ContentFrame.ScrollFrame, "SetVerticalScroll", Update)
							end
						end

						do -- BUTTONS
							local function CreateButton(parent, index)
								local BUTTON_WIDTH   = (parent:GetWidth())
								local BUTTON_HEIGHT  = (NS.Variables:RATIO(5.25))
								local PADDING        = (NS.Variables:RATIO(10))
								local CONTENT_HEIGHT = (NS.Variables:RATIO(7))
								local TEXT_WIDTH     = (BUTTON_WIDTH / addon.Variables:RAW_RATIO(1))

								local offset         = PADDING

								--------------------------------

								local Button         = CreateFrame("Frame", nil, parent)
								Button:SetSize(BUTTON_WIDTH, BUTTON_HEIGHT)
								Button:SetPoint("CENTER", parent)
								Button:SetFrameStrata("FULLSCREEN")
								Button:SetFrameLevel(2)

								--------------------------------

								Button.ID = ""
								Button.Selected = false
								Button.MouseOver = false

								--------------------------------

								do -- CLICK EVENTS
									AdaptiveAPI.FrameTemplates:CreateMouseResponder(Button, function()
										Button.Enter()
									end, function()
										Button.Leave()
									end)

									Button.Enter = function()
										if NS.LibraryUI.Variables.SelectedIndex == index then
											return
										end

										--------------------------------

										Button.MouseOver = true

										--------------------------------

										Button.Enter_Animation()

										--------------------------------

										addon.SoundEffects:PlaySoundFile(addon.SoundEffects.Readable_LibraryUI_Button_Menu_Enter)
									end

									Button.Leave = function(bypass)
										if NS.LibraryUI.Variables.SelectedIndex == index then
											return
										end

										--------------------------------

										Button.MouseOver = false

										--------------------------------

										Button.Leave_Animation()

										--------------------------------

										addon.SoundEffects:PlaySoundFile(addon.SoundEffects.Readable_LibraryUI_Button_Menu_Leave)
									end

									Button.MouseDown = function()
										addon.SoundEffects:PlaySoundFile(addon.SoundEffects.Readable_LibraryUI_Button_Menu_MouseDown)
									end

									Button.MouseUp = function()
										addon.SoundEffects:PlaySoundFile(addon.SoundEffects.Readable_LibraryUI_Button_Menu_MouseUp)
									end

									Button.Click = function(_, button)
										if NS.LibraryUI.Variables.SelectedIndex == index then
											if addon.Database.DB_GLOBAL.profile.INT_FLIPMOUSE and button == "RightButton" or addon.Database.DB_GLOBAL.profile.INT_FLIPMOUSE or button == "LeftButton" then
												NS.LibraryUI.Script:OpenFromLibrary(Button.ID)
											else
												NS.LibraryUI.Variables.SelectedIndex = nil

												Button.Leave_Animation()
											end
										else
											NS.LibraryUI.Variables.SelectedIndex = index

											Button.Enter_Animation()
										end

										CallbackRegistry:Trigger("LIBRARY_MENU_SELECTION", Button)
									end

									Button:SetScript("OnMouseDown", function()
										Button.MouseDown()
									end)

									Button:SetScript("OnMouseUp", function(_, button)
										Button.MouseUp()
										Button.Click(_, button)
									end)
								end

								do -- FUNCTIONS
									Button.UpdateGradientAlpha = function()
										Button.Content.Text.Detail:SetAlphaGradient(0, 50)
										Button.Content.Text.Title:SetAlphaGradient(0, 50)
									end

									Button.Update = function()
										if NS.LibraryUI.Variables.SelectedIndex == index then
											Button.Enter_Animation()

											--------------------------------

											Button:SetAlpha(1)
										else
											Button.Leave_Animation()

											--------------------------------

											Button:SetAlpha(.75)
										end
									end
								end

								do -- ELEMENTS
									do -- CONTENT
										Button.Content = CreateFrame("Frame", "$parent.Content", Button)
										Button.Content:SetSize(Button:GetSize())
										Button.Content:SetPoint("CENTER", Button)

										hooksecurefunc(Button, "SetSize", function()
											Button.Content:SetSize(Button:GetSize())
										end)

										hooksecurefunc(Button, "SetWidth", function()
											Button.Content:SetSize(Button:GetSize())
										end)

										hooksecurefunc(Button, "SetHeight", function()
											Button.Content:SetSize(Button:GetSize())
										end)

										--------------------------------

										do -- BACKGROUND
											Button.Content.Background, Button.Content.BackgroundTexture = AdaptiveAPI.FrameTemplates:CreateNineSlice(Button.Content, "FULLSCREEN", NS.Variables.READABLE_UI_PATH .. "Library/element-background-nineslice.png", 64, .75, "$parent.Background", Enum.UITextureSliceMode.Stretched)
											Button.Content.Background:SetSize(Button.Content:GetWidth() + 45, Button.Content:GetHeight() + 45)
											Button.Content.Background:SetPoint("CENTER", Button.Content)
											Button.Content.Background:SetFrameStrata("FULLSCREEN")
											Button.Content.Background:SetFrameLevel(1)
											Button.Content.Background:SetAlpha(1)

											hooksecurefunc(Button.Content.Background, "SetSize", function()
												Button.Content.Background:SetSize(Button.Content:GetWidth() + 45, Button.Content:GetHeight() + 45)
											end)

											hooksecurefunc(Button.Content.Background, "SetWidth", function()
												Button.Content.Background:SetSize(Button.Content:GetWidth() + 45, Button.Content:GetHeight() + 45)
											end)

											hooksecurefunc(Button.Content.Background, "SetHeight", function()
												Button.Content.Background:SetSize(Button.Content:GetWidth() + 45, Button.Content:GetHeight() + 45)
											end)
										end

										do -- IMAGE
											Button.Content.Image, Button.Content.ImageTexture = AdaptiveAPI.FrameTemplates:CreateTexture(Button.Content, "FULLSCREEN", nil, "$parent.Image")
											Button.Content.Image:SetSize(Button.Content:GetHeight() * .75, Button.Content:GetHeight() * .75)
											Button.Content.Image:SetPoint("LEFT", Button.Content, offset, 0)
											Button.Content.Image:SetFrameStrata("FULLSCREEN")
											Button.Content.Image:SetFrameLevel(2)

											--------------------------------

											Button.Content.ImageTexture:SetTexture(NS.Variables.READABLE_UI_PATH .. "Parchment/parchment-light.png")

											--------------------------------

											offset = offset + Button.Content.Image:GetWidth() + (PADDING * 2)
										end

										do -- TEXT
											Button.Content.Text = CreateFrame("Frame", "$parent.Text", Button)
											Button.Content.Text:SetSize(TEXT_WIDTH, CONTENT_HEIGHT)
											Button.Content.Text:SetPoint("LEFT", Button.Content, offset, 0)
											Button.Content.Text:SetClipsChildren(true)

											--------------------------------

											do -- DETAIL
												Button.Content.Text.Detail = AdaptiveAPI.FrameTemplates:CreateText(Button.Content.Text, addon.Theme.RGB_WHITE, 10, "LEFT", "TOP", AdaptiveAPI.Fonts.Content_Light, "$parent.Detail")
												Button.Content.Text.Detail:SetSize(Button.Content.Text:GetSize())
												Button.Content.Text.Detail:SetPoint("LEFT", Button.Content.Text)
												Button.Content.Text.Detail:SetAlpha(.5)
												Button.Content.Text.Detail:SetWordWrap(false)
											end

											do -- TITLE
												Button.Content.Text.Title = AdaptiveAPI.FrameTemplates:CreateText(Button.Content.Text, addon.Theme.RGB_WHITE, 15, "LEFT", "BOTTOM", AdaptiveAPI.Fonts.Content_Light, "$parent.Title")
												Button.Content.Text.Title:SetSize(Button.Content.Text:GetSize())
												Button.Content.Text.Title:SetPoint("LEFT", Button.Content.Text)
												Button.Content.Text.Title:SetAlpha(.75)
												Button.Content.Text.Title:SetWordWrap(false)
											end
										end

										do -- BUTTONS
											Button.Content.ButtonContainer = CreateFrame("Frame", "$parent.ButtonContainer", Button.Content)
											Button.Content.ButtonContainer:SetSize(Button.Content:GetWidth() * .5, CONTENT_HEIGHT)
											Button.Content.ButtonContainer:SetPoint("RIGHT", Button.Content, -25, 0)

											--------------------------------

											local buttonSize = CONTENT_HEIGHT
											local buttonOffset = 0

											--------------------------------

											do -- OPEN
												Button.Content.ButtonContainer.Button_Open = AdaptiveAPI.FrameTemplates:CreateCustomButton(Button.Content.ButtonContainer, buttonSize, buttonSize, "FULLSCREEN", {
													defaultTexture = NS.Variables.READABLE_UI_PATH .. "Library/element-button-background-nineslice.png",
													highlightTexture = NS.Variables.READABLE_UI_PATH .. "Library/element-button-background-highlighted-nineslice.png",
													theme = 2,
													edgeSize = 64,
													scale = 5,
													texturePadding = 12.5,
													playAnimation = false,
													customColor = { r = 1, g = 1, b = 1, a = 1 },
													customHighlightColor = { r = 1, g = 1, b = 1, a = 1 },
													customActiveColor = { r = 1, g = 1, b = 1, a = 1 },
												}, "$parent.Button_Open")
												Button.Content.ButtonContainer.Button_Open:SetPoint("RIGHT", Button.Content.ButtonContainer, -buttonOffset, 0)
												Button.Content.ButtonContainer.Button_Open:SetFrameStrata("FULLSCREEN")
												Button.Content.ButtonContainer.Button_Open:SetFrameLevel(3)

												Button.Content.ButtonContainer.Button_Open:SetScript("OnClick", function()
													NS.LibraryUI.Script:OpenFromLibrary(Button.ID)
												end)

												--------------------------------

												do -- IMAGE
													Button.Content.ButtonContainer.Button_Open.Image, Button.Content.ButtonContainer.Button_Open.ImageTexture = AdaptiveAPI.FrameTemplates:CreateTexture(Button.Content.ButtonContainer.Button_Open, "FULLSCREEN", NS.Variables.READABLE_UI_PATH .. "Library/button-open.png", "$parent.Image")
													Button.Content.ButtonContainer.Button_Open.Image:SetAllPoints(Button.Content.ButtonContainer.Button_Open, true)
													Button.Content.ButtonContainer.Button_Open.Image:SetFrameStrata(Button.Content.ButtonContainer.Button_Open:GetFrameStrata())
													Button.Content.ButtonContainer.Button_Open.Image:SetFrameLevel(4)
													Button.Content.ButtonContainer.Button_Open.Image:SetScale(.5)
												end

												--------------------------------

												buttonOffset = buttonOffset + Button.Content.ButtonContainer.Button_Open:GetWidth() + NS.Variables:RATIO(10)
											end

											do -- DELETE
												Button.Content.ButtonContainer.Button_Delete = AdaptiveAPI.FrameTemplates:CreateCustomButton(Button.Content.ButtonContainer, buttonSize, buttonSize, "FULLSCREEN", {
													defaultTexture = NS.Variables.READABLE_UI_PATH .. "Library/element-button-background-nineslice.png",
													highlightTexture = NS.Variables.READABLE_UI_PATH .. "Library/element-button-background-highlighted-nineslice.png",
													theme = 2,
													edgeSize = 64,
													scale = 5,
													texturePadding = 12.5,
													playAnimation = false,
													customColor = { r = 1, g = 1, b = 1, a = 1 },
													customHighlightColor = { r = 1, g = 1, b = 1, a = 1 },
													customActiveColor = { r = 1, g = 1, b = 1, a = 1 },
												}, "$parent.Button_Delete")
												Button.Content.ButtonContainer.Button_Delete:SetPoint("RIGHT", Button.Content.ButtonContainer, -buttonOffset, 0)
												Button.Content.ButtonContainer.Button_Delete:SetFrameStrata("FULLSCREEN")
												Button.Content.ButtonContainer.Button_Delete:SetFrameLevel(3)

												Button.Content.ButtonContainer.Button_Delete:SetScript("OnClick", function()
													NS.LibraryUI.Script:DeleteFromLibrary(Button.ID)
												end)

												--------------------------------

												do -- IMAGE
													Button.Content.ButtonContainer.Button_Delete.Image, Button.Content.ButtonContainer.Button_Delete.ImageTexture = AdaptiveAPI.FrameTemplates:CreateTexture(Button.Content.ButtonContainer.Button_Delete, "FULLSCREEN", NS.Variables.READABLE_UI_PATH .. "Library/button-delete.png", "$parent.Image")
													Button.Content.ButtonContainer.Button_Delete.Image:SetAllPoints(Button.Content.ButtonContainer.Button_Delete, true)
													Button.Content.ButtonContainer.Button_Delete.Image:SetFrameStrata(Button.Content.ButtonContainer.Button_Delete:GetFrameStrata())
													Button.Content.ButtonContainer.Button_Delete.Image:SetFrameLevel(4)
													Button.Content.ButtonContainer.Button_Delete.Image:SetScale(.5)
												end

												--------------------------------

												buttonOffset = buttonOffset + Button.Content.ButtonContainer.Button_Delete:GetWidth() + NS.Variables:RATIO(10)
											end
										end
									end
								end

								do -- ANIMATION
									local function Enter_StopEvent()
										return not Button.Selected
									end

									local function Leave_StopEvent()
										return Button.Selected
									end

									Button.Enter_Animation = function()
										Button.Selected = true

										--------------------------------

										Button:SetAlpha(.925)
										Button.Content.Background:SetAlpha(1)
										Button.Content.BackgroundTexture:SetTexture(NS.Variables.READABLE_UI_PATH .. "Library/element-background-highlighted-nineslice.png")

										--------------------------------

										AdaptiveAPI.Animation:Scale(Button.Content.Text, .25, Button.Content.Text:GetWidth(), TEXT_WIDTH * .875, "x", AdaptiveAPI.Animation.EaseExpo, Enter_StopEvent)
										AdaptiveAPI.Animation:Fade(Button.Content.ButtonContainer, .25, Button.Content.ButtonContainer:GetAlpha(), 1, nil, Enter_StopEvent)
										AdaptiveAPI.Animation:Move(Button.Content.ButtonContainer, .375, "RIGHT", -25, 0, "y", nil, Enter_StopEvent)
									end

									Button.Leave_Animation = function()
										Button.Selected = false

										--------------------------------

										Button:SetAlpha(.75)
										Button.Content.Background:SetAlpha(1)
										Button.Content.BackgroundTexture:SetTexture(NS.Variables.READABLE_UI_PATH .. "Library/element-background-nineslice.png")

										--------------------------------

										AdaptiveAPI.Animation:Scale(Button.Content.Text, .125, Button.Content.Text:GetWidth(), TEXT_WIDTH, "x", nil, Leave_StopEvent)
										AdaptiveAPI.Animation:Fade(Button.Content.ButtonContainer, .125, Button.Content.ButtonContainer:GetAlpha(), 0, nil, Leave_StopEvent)
										AdaptiveAPI.Animation:Move(Button.Content.ButtonContainer, .125, "RIGHT", 0, -10, "y", nil, Leave_StopEvent)
									end

									--------------------------------

									Button:SetAlpha(.75)
									Button.Content.Background:SetAlpha(1)
									Button.Content.BackgroundTexture:SetTexture(NS.Variables.READABLE_UI_PATH .. "Library/element-background-nineslice.png")

									--------------------------------

									Button.Content.ButtonContainer:SetAlpha(0)
								end

								--------------------------------

								return Button
							end

							--------------------------------

							local Buttons = {}
							local NumButtons = 10

							for i = 1, NumButtons do
								local Button = CreateButton(LibraryUIFrame.Content.ContentFrame.ScrollChildFrame, i)

								--------------------------------

								table.insert(Buttons, Button)
							end

							--------------------------------

							LibraryUIFrame.Buttons = Buttons
							Buttons = nil
						end
					end
				end
			end
		end
	end

	--------------------------------
	-- SETUP
	--------------------------------

	do
		InteractionReadableUIFrame.LibraryUIFrame:Hide()
	end
end
