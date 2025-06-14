---@class addon
local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local PrefabRegistry = addon.PrefabRegistry
local L = addon.Locales
local NS = addon.Readable; addon.Readable = NS

--------------------------------

NS.LibraryUI.Elements = {}

--------------------------------

function NS.LibraryUI.Elements:Load()
	--------------------------------
	-- CREATE ELEMENTS
	--------------------------------

	do
		do -- ELEMENTS
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
				LibraryUIFrame.Background, LibraryUIFrame.BackgroundTexture = addon.API.FrameTemplates:CreateTexture(LibraryUIFrame, "FULLSCREEN", NS.Variables.READABLE_UI_PATH .. "Library/background-library.png", "$parent.Background")
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

							LibraryUIFrame.Content.Title.Main.Text = addon.API.FrameTemplates:CreateText(LibraryUIFrame.Content.Title.Main, addon.Theme.RGB_WHITE, 30, "CENTER", "MIDDLE", addon.API.Fonts.TITLE_BOLD, "$parent.Text")
							LibraryUIFrame.Content.Title.Main.Text:SetSize(LibraryUIFrame.Content.Title:GetWidth(), new)
							LibraryUIFrame.Content.Title.Main.Text:SetPoint("TOP", LibraryUIFrame.Content.Title)
							LibraryUIFrame.Content.Title.Main.Text:SetAlpha(.75)
						end

						do -- SUBTEXT
							local height = (LibraryUIFrame.Content.Title:GetHeight())
							local ratio = addon.Variables:RAW_RATIO(1)
							local new = height - (height / ratio)

							--------------------------------

							LibraryUIFrame.Content.Title.Main.Subtext = addon.API.FrameTemplates:CreateText(LibraryUIFrame.Content.Title.Main, addon.Theme.RGB_WHITE, 12.5, "CENTER", "MIDDLE", addon.API.Fonts.CONTENT_LIGHT, "$parent.Subtext")
							LibraryUIFrame.Content.Title.Main.Subtext:SetSize(LibraryUIFrame.Content.Title:GetWidth(), new)
							LibraryUIFrame.Content.Title.Main.Subtext:SetPoint("BOTTOM", LibraryUIFrame.Content.Title.Main)
							LibraryUIFrame.Content.Title.Main.Subtext:SetAlpha(.5)
						end
					end

					do -- DIVIDER
						LibraryUIFrame.Content.Title.Divider, LibraryUIFrame.Content.Title.DividerTexture = addon.API.FrameTemplates:CreateTexture(LibraryUIFrame.Content.Title, "FULLSCREEN", NS.Variables.READABLE_UI_PATH .. "Library/divider-title.png", "$parent.Divider")
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

					function LibraryUIFrame.Content.Sidebar:AddElement(element)
						table.insert(LibraryUIFrame.Content.Sidebar.Elements, element)
					end

					--------------------------------

					do -- TAB
						LibraryUIFrame.Content.Sidebar.Tab = PrefabRegistry:Create("Readable.LibraryUI.SideBar.Tab.Frame", LibraryUIFrame.Content.Sidebar, "FULLSCREEN", 3, "$parent.Tab")
						LibraryUIFrame.Content.Sidebar.Tab:SetHeight(50)
						addon.API.FrameUtil:SetDynamicSize(LibraryUIFrame.Content.Sidebar.Tab, LibraryUIFrame.Content.Sidebar, 0, nil)
						LibraryUIFrame.Content.Sidebar:AddElement(LibraryUIFrame.Content.Sidebar.Tab)

						local Tab = LibraryUIFrame.Content.Sidebar.Tab

						--------------------------------

						do -- LAYOUT GROUP
							local LayoutGroup = Tab.Content.Content.LayoutGroup

							--------------------------------

							do -- ELEMENTS
								do -- BUTTON (CHARACTER)
									local function Click()
										NS.LibraryUI.Script:SetToLocal()
									end

									--------------------------------

									LayoutGroup.Button_Local = PrefabRegistry:Create("Readable.LibraryUI.SideBar.Tab.Button.Image", LayoutGroup, Tab, 1, "FULLSCREEN", 4, "$parent.Button_Local")
									LayoutGroup.Button_Local:SetFrameStrata("FULLSCREEN")
									LayoutGroup.Button_Local:SetFrameLevel(4)
									LayoutGroup.Button_Local:Set(addon.Variables.PATH_ART .. "Icons/personal.png", Click)
									addon.API.FrameUtil:SetDynamicSize(LayoutGroup.Button_Local, LayoutGroup, nil, 0)

									LayoutGroup:AddElement(LayoutGroup.Button_Local)
								end

								do -- BUTTON (WARBAND)
									local function Click()
										NS.LibraryUI.Script:SetToGlobal()
									end

									--------------------------------

									LayoutGroup.Button_Global = PrefabRegistry:Create("Readable.LibraryUI.SideBar.Tab.Button.Image", LayoutGroup, Tab, 2, "FULLSCREEN", 4, "$parent.Button_Global")
									LayoutGroup.Button_Global:SetFrameStrata("FULLSCREEN")
									LayoutGroup.Button_Global:SetFrameLevel(4)
									LayoutGroup.Button_Global:Set(addon.Variables.PATH_ART .. "Icons/warband.png", Click)
									addon.API.FrameUtil:SetDynamicSize(LayoutGroup.Button_Global, LayoutGroup, nil, 0)

									LayoutGroup:AddElement(LayoutGroup.Button_Global)
								end
							end
						end

						do -- SETUP
							Tab:SelectButton(1)
						end
					end

					do -- SEARCH
						local function UpdateSearch(self)
							NS.LibraryUI.Script:SetPageButtons(false, true)
						end

						--------------------------------

						LibraryUIFrame.Content.Sidebar.Search = addon.API.FrameTemplates:CreateInputBox(LibraryUIFrame.Content.Sidebar, "FULLSCREEN", LibraryUIFrame.Content.Sidebar:GetFrameLevel() + 1, {
							defaultTexture = NS.Variables.NINESLICE_RUSTIC_BORDER,
							highlightTexture = NS.Variables.NINESLICE_RUSTIC,
							edgeSize = 128,
							scale = .075,
							textColor = addon.Theme.RGB_WHITE,
							fontSize = 12.5,
							justifyH = "LEFT",
							justifyV = "MIDDLE",
							hint = L["Readable - Library - Search Input Placeholder"],
							valueChangedCallback = UpdateSearch
						}, "$parent.Search")
						LibraryUIFrame.Content.Sidebar.Search:SetSize(LibraryUIFrame.Content.Sidebar:GetWidth() - 20, 35)
						LibraryUIFrame.Content.Sidebar.Search.BackgroundTexture:SetAlpha(.125)
						LibraryUIFrame.Content.Sidebar:AddElement(LibraryUIFrame.Content.Sidebar.Search)

						--------------------------------

						addon.SoundEffects:SetInputBox(LibraryUIFrame.Content.Sidebar.Search, addon.SoundEffects.Readable_LibraryUI_Input_Enter, addon.SoundEffects.Readable_LibraryUI_Input_Leave, addon.SoundEffects.Readable_LibraryUI_Input_MouseDown, addon.SoundEffects.Readable_LibraryUI_Input_MouseUp, addon.SoundEffects.Readable_LibraryUI_Input_ValueChanged)
					end

					do -- CATEGORIES
						local function CreateCheckbox(callback, text, name)
							local Frame = PrefabRegistry:Create("Readable.LibraryUI.SideBar.Categories.Checkbox", LibraryUIFrame.Content.Sidebar, callback, text, "FULLSCREEN", 3, name)
							LibraryUIFrame.Content.Sidebar:AddElement(Frame)

							--------------------------------

							return Frame
						end

						--------------------------------

						do -- LABEL (SHOW)
							LibraryUIFrame.Content.Sidebar.Label_Show = addon.API.FrameTemplates:CreateText(LibraryUIFrame.Content.Sidebar, addon.Theme.RGB_WHITE, 12.5, "LEFT", "MIDDLE", addon.API.Fonts.CONTENT_LIGHT, "$parent.Label_Show")
							LibraryUIFrame.Content.Sidebar.Label_Show:SetSize(LibraryUIFrame.Content.Sidebar:GetWidth(), 35)
							LibraryUIFrame.Content.Sidebar.Label_Show:SetAlpha(.5)
							LibraryUIFrame.Content.Sidebar.Label_Show:SetText(L["Readable - Library - Show"])

							--------------------------------

							LibraryUIFrame.Content.Sidebar:AddElement(LibraryUIFrame.Content.Sidebar.Label_Show)
						end

						do -- CHECKBOX (LETTERS)
							local function Click()
								NS.LibraryUI.Script:SetPageButtons(false, true)
							end

							--------------------------------

							LibraryUIFrame.Content.Sidebar.Type_Letter = CreateCheckbox(Click, L["Readable - Library - Letters"], "$parent.Letters")
						end

						do -- CHECKBOX (BOOKS)
							local function Click()
								NS.LibraryUI.Script:SetPageButtons(false, true)
							end

							--------------------------------

							LibraryUIFrame.Content.Sidebar.Type_Book = CreateCheckbox(Click, L["Readable - Library - Books"], "$parent.Type_Book")
						end

						do -- CHECKBOX (SLATES)
							local function Click()
								NS.LibraryUI.Script:SetPageButtons(false, true)
							end

							--------------------------------

							LibraryUIFrame.Content.Sidebar.Type_Slate = CreateCheckbox(Click, L["Readable - Library - Slates"], "$parent.Type_Slate")
						end

						do -- CHECKBOX (IN-WORLD)
							local function Click()
								NS.LibraryUI.Script:SetPageButtons(false, true)
							end

							--------------------------------

							LibraryUIFrame.Content.Sidebar.Type_InWorld = CreateCheckbox(Click, L["Readable - Library - Show only World"], "$parent.Type_InWorld")
						end
					end

					do -- BUTTONS
						local function CreateButton(callback, text, name)
							local Button = addon.API.FrameTemplates:CreateCustomButton(LibraryUIFrame.Content.Sidebar, LibraryUIFrame.Content.Sidebar:GetWidth(), 35, "FULLSCREEN", {
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
					LibraryUIFrame.Content.Divider, LibraryUIFrame.Content.DividerTexture = addon.API.FrameTemplates:CreateTexture(LibraryUIFrame.Content, "FULLSCREEN", NS.Variables.READABLE_UI_PATH .. "Library/divider-sidebar.png", "$parent.Divider")
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
							LibraryUIFrame.Content.ContentFrame.Index.Background, LibraryUIFrame.Content.ContentFrame.Index.BackgroundTexture = addon.API.FrameTemplates:CreateNineSlice(LibraryUIFrame.Content.ContentFrame.Index, "FULLSCREEN", NS.Variables.READABLE_UI_PATH .. "Library/index-background-nineslice.png", 64, .25, "$parent.Background")
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
								LibraryUIFrame.Content.ContentFrame.Index.Content.Text = addon.API.FrameTemplates:CreateText(LibraryUIFrame.Content.ContentFrame.Index.Content, addon.Theme.RGB_WHITE, 15, "CENTER", "MIDDLE", addon.API.Fonts.CONTENT_LIGHT, "$parent.Text")
								LibraryUIFrame.Content.ContentFrame.Index.Content.Text:SetPoint("CENTER", LibraryUIFrame.Content.ContentFrame.Index.Content)
								LibraryUIFrame.Content.ContentFrame.Index.Content.Text:SetText("1/2")
								LibraryUIFrame.Content.ContentFrame.Index.Content.Text:SetAlpha(.5)
							end

							do -- BUTTONS
								do -- PREVIOUS PAGE
									LibraryUIFrame.Content.ContentFrame.Index.Content.Button_PreviousPage = addon.API.FrameTemplates:CreateCustomButton(LibraryUIFrame.Content.ContentFrame.Index.Content, LibraryUIFrame.Content.ContentFrame.Index.Content:GetHeight(), LibraryUIFrame.Content.ContentFrame.Index.Content:GetHeight(), "FULLSCREEN", {
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
										LibraryUIFrame.Content.ContentFrame.Index.Content.Button_PreviousPage.Image, LibraryUIFrame.Content.ContentFrame.Index.Content.Button_PreviousPage.ImageTexture = addon.API.FrameTemplates:CreateTexture(LibraryUIFrame.Content.ContentFrame.Index.Content.Button_PreviousPage, "FULLSCREEN", NS.Variables.READABLE_UI_PATH .. "Library/previous.png", "$parent.Image")
										LibraryUIFrame.Content.ContentFrame.Index.Content.Button_PreviousPage.Image:SetPoint("CENTER", LibraryUIFrame.Content.ContentFrame.Index.Content.Button_PreviousPage)
										LibraryUIFrame.Content.ContentFrame.Index.Content.Button_PreviousPage.Image:SetScale(.5)
										LibraryUIFrame.Content.ContentFrame.Index.Content.Button_PreviousPage.Image:SetFrameStrata("FULLSCREEN")
										LibraryUIFrame.Content.ContentFrame.Index.Content.Button_PreviousPage.Image:SetFrameLevel(13)
										addon.API.FrameUtil:SetDynamicSize(LibraryUIFrame.Content.ContentFrame.Index.Content.Button_PreviousPage.Image, LibraryUIFrame.Content.ContentFrame.Index.Content.Button_PreviousPage, 0, 0)
										LibraryUIFrame.Content.ContentFrame.Index.Content.Button_PreviousPage.Image:SetAlpha(.325)
									end
								end

								do -- NEXT PAGE
									LibraryUIFrame.Content.ContentFrame.Index.Content.Button_NextPage = addon.API.FrameTemplates:CreateCustomButton(LibraryUIFrame.Content.ContentFrame.Index.Content, LibraryUIFrame.Content.ContentFrame.Index.Content:GetHeight(), LibraryUIFrame.Content.ContentFrame.Index.Content:GetHeight(), "FULLSCREEN", {
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
										LibraryUIFrame.Content.ContentFrame.Index.Content.Button_NextPage.Image, LibraryUIFrame.Content.ContentFrame.Index.Content.Button_NextPage.ImageTexture = addon.API.FrameTemplates:CreateTexture(LibraryUIFrame.Content.ContentFrame.Index.Content.Button_NextPage, "FULLSCREEN", NS.Variables.READABLE_UI_PATH .. "Library/next.png", "$parent.Image")
										LibraryUIFrame.Content.ContentFrame.Index.Content.Button_NextPage.Image:SetPoint("CENTER", LibraryUIFrame.Content.ContentFrame.Index.Content.Button_NextPage)
										LibraryUIFrame.Content.ContentFrame.Index.Content.Button_NextPage.Image:SetScale(.5)
										LibraryUIFrame.Content.ContentFrame.Index.Content.Button_NextPage.Image:SetFrameStrata("FULLSCREEN")
										LibraryUIFrame.Content.ContentFrame.Index.Content.Button_NextPage.Image:SetFrameLevel(13)
										addon.API.FrameUtil:SetDynamicSize(LibraryUIFrame.Content.ContentFrame.Index.Content.Button_NextPage.Image, LibraryUIFrame.Content.ContentFrame.Index.Content.Button_NextPage, 0, 0)
										LibraryUIFrame.Content.ContentFrame.Index.Content.Button_NextPage.Image:SetAlpha(.325)
									end
								end
							end
						end
					end

					do -- CONTENT FRAME
						do -- SCROLL FRAME
							LibraryUIFrame.Content.ContentFrame.ScrollFrame, LibraryUIFrame.Content.ContentFrame.ScrollChildFrame = addon.API.FrameTemplates:CreateScrollFrame(LibraryUIFrame.Content.ContentFrame, { direction = "vertical", smoothScrollingRatio = 5 }, "$parent.ScrollFrame", "$parent.ScrollChildFrame")
							LibraryUIFrame.Content.ContentFrame.ScrollFrame:SetWidth(LibraryUIFrame.Content.ContentFrame:GetWidth())
							LibraryUIFrame.Content.ContentFrame.ScrollFrame:SetPoint("TOP", LibraryUIFrame.Content.ContentFrame)

							--------------------------------

							do -- ELEMENTS
								do -- SCROLL INDICATOR
									do -- TOP
										LibraryUIFrame.Content.ContentFrame.ScrollFrame.ScrollIndicator_Top, LibraryUIFrame.Content.ContentFrame.ScrollFrame.ScrollIndicator_TopTexture = addon.API.FrameTemplates:CreateTexture(LibraryUIFrame.Content.ContentFrame.ScrollFrame, "FULLSCREEN", NS.Variables.READABLE_UI_PATH .. "Library/content-scroll-indicator-top.png", "$parent.ScrollIndicator_Top")
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
										LibraryUIFrame.Content.ContentFrame.ScrollFrame.ScrollIndicator_Bottom, LibraryUIFrame.Content.ContentFrame.ScrollFrame.ScrollIndicator_BottomTexture = addon.API.FrameTemplates:CreateTexture(LibraryUIFrame.Content.ContentFrame.ScrollFrame, "FULLSCREEN", NS.Variables.READABLE_UI_PATH .. "Library/content-scroll-indicator-bottom.png", "$parent.ScrollIndicator_Bottom")
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
									LibraryUIFrame.Content.ContentFrame.ScrollFrame.Label = addon.API.FrameTemplates:CreateText(LibraryUIFrame.Content.ContentFrame.ScrollFrame, addon.Theme.RGB_WHITE, 20, "CENTER", "MIDDLE", addon.API.Fonts.CONTENT_LIGHT, "$parent.Label")
									LibraryUIFrame.Content.ContentFrame.ScrollFrame.Label:SetAllPoints(LibraryUIFrame.Content.ContentFrame.ScrollFrame)
									LibraryUIFrame.Content.ContentFrame.ScrollFrame.Label:SetAlpha(.25)
								end

								do -- SCROLL BAR
									LibraryUIFrame.Content.ContentFrame.ScrollFrame.ScrollBar:Hide()

									--------------------------------

									LibraryUIFrame.Content.ContentFrame.Scrollbar = addon.API.FrameTemplates:CreateScrollbar(LibraryUIFrame.Content.ContentFrame.ScrollFrame, "FULLSCREEN", LibraryUIFrame.Content.ContentFrame.ScrollFrame:GetFrameLevel() + 9, {
										scrollFrame = LibraryUIFrame.Content.ContentFrame.ScrollFrame,
										scrollChildFrame = LibraryUIFrame.Content.ContentFrame.ScrollChildFrame,
										sizeX = 5,
										sizeY = LibraryUIFrame.Content.ContentFrame.ScrollFrame:GetHeight(),
										theme = 2,
										isHorizontal = false,
									}, "$parent.Scrollbar")
									LibraryUIFrame.Content.ContentFrame.Scrollbar:SetPoint("LEFT", LibraryUIFrame.Content.ContentFrame.ScrollFrame, "RIGHT", PADDING / 2, 0)
									LibraryUIFrame.Content.ContentFrame.Scrollbar.Thumb:SetAlpha(.5)
									LibraryUIFrame.Content.ContentFrame.Scrollbar.Background:SetAlpha(.1)
								end
							end

							do -- EVENTS
								function LibraryUIFrame.Content.ContentFrame.ScrollFrame:UpdateSize()
									if LibraryUIFrame.Content.ContentFrame.Index:IsVisible() then
										LibraryUIFrame.Content.ContentFrame.ScrollFrame:SetSize(LibraryUIFrame.Content.ContentFrame:GetWidth(), LibraryUIFrame.Content.ContentFrame:GetHeight() - LibraryUIFrame.Content.ContentFrame.Index:GetHeight() - PADDING / 2)
									else
										LibraryUIFrame.Content.ContentFrame.ScrollFrame:SetSize(LibraryUIFrame.Content.ContentFrame:GetWidth(), LibraryUIFrame.Content.ContentFrame:GetHeight())
									end

									LibraryUIFrame.Content.ContentFrame.Scrollbar:SetHeight(LibraryUIFrame.Content.ContentFrame.ScrollFrame:GetHeight())
								end

								LibraryUIFrame.Content.ContentFrame.ScrollFrame:UpdateSize()

								local function Update()
									if LibraryUIFrame.Content.ContentFrame.ScrollFrame:IsVisible() then
										LibraryUIFrame.Content.ContentFrame.ScrollFrame:RefreshLayout()
										LibraryUIFrame.Content.ContentFrame.ScrollFrame:UpdateScrollIndicator()
									end
								end
								Update()

								--------------------------------

								table.insert(LibraryUIFrame.Content.ContentFrame.ScrollFrame.onSmoothScrollStartCallbacks, Update)
								table.insert(LibraryUIFrame.Content.ContentFrame.ScrollFrame.onSmoothScrollDestinationCallbacks, Update)
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

								local Frame         = CreateFrame("Frame", nil, parent)
								Frame:SetSize(BUTTON_WIDTH, BUTTON_HEIGHT)
								Frame:SetPoint("CENTER", parent)
								Frame:SetFrameStrata("FULLSCREEN")
								Frame:SetFrameLevel(2)

								--------------------------------

								do -- ELEMENTS
									do -- CONTENT
										Frame.Content = CreateFrame("Frame", "$parent.Content", Frame)
										Frame.Content:SetPoint("CENTER", Frame)
										addon.API.FrameUtil:SetDynamicSize(Frame.Content, Frame, 0, 0)

										--------------------------------

										do -- BACKGROUND
											Frame.Content.Background, Frame.Content.BackgroundTexture = addon.API.FrameTemplates:CreateNineSlice(Frame.Content, "FULLSCREEN", NS.Variables.READABLE_UI_PATH .. "Library/element-background-nineslice.png", 64, .75, "$parent.Background", Enum.UITextureSliceMode.Stretched)
											Frame.Content.Background:SetPoint("CENTER", Frame.Content)
											Frame.Content.Background:SetFrameStrata("FULLSCREEN")
											Frame.Content.Background:SetFrameLevel(1)
											Frame.Content.Background:SetAlpha(1)
											addon.API.FrameUtil:SetDynamicSize(Frame.Content.Background, Frame.Content, -45, -45)
										end

										do -- IMAGE
											Frame.Content.Image, Frame.Content.ImageTexture = addon.API.FrameTemplates:CreateTexture(Frame.Content, "FULLSCREEN", nil, "$parent.Image")
											Frame.Content.Image:SetSize(Frame.Content:GetHeight() * .75, Frame.Content:GetHeight() * .75)
											Frame.Content.Image:SetPoint("LEFT", Frame.Content, offset, 0)
											Frame.Content.Image:SetFrameStrata("FULLSCREEN")
											Frame.Content.Image:SetFrameLevel(2)

											--------------------------------

											Frame.Content.ImageTexture:SetTexture(NS.Variables.READABLE_UI_PATH .. "Parchment/parchment-light.png")

											--------------------------------

											offset = offset + Frame.Content.Image:GetWidth() + (PADDING * 2)
										end

										do -- TEXT
											Frame.Content.Text = CreateFrame("Frame", "$parent.Text", Frame)
											Frame.Content.Text:SetSize(TEXT_WIDTH, CONTENT_HEIGHT)
											Frame.Content.Text:SetPoint("LEFT", Frame.Content, offset, 0)
											Frame.Content.Text:SetClipsChildren(true)

											--------------------------------

											do -- DETAIL
												Frame.Content.Text.Detail = addon.API.FrameTemplates:CreateText(Frame.Content.Text, addon.Theme.RGB_WHITE, 10, "LEFT", "TOP", addon.API.Fonts.CONTENT_LIGHT, "$parent.Detail")
												Frame.Content.Text.Detail:SetSize(Frame.Content.Text:GetSize())
												Frame.Content.Text.Detail:SetPoint("LEFT", Frame.Content.Text)
												Frame.Content.Text.Detail:SetAlpha(.5)
												Frame.Content.Text.Detail:SetWordWrap(false)
											end

											do -- TITLE
												Frame.Content.Text.Title = addon.API.FrameTemplates:CreateText(Frame.Content.Text, addon.Theme.RGB_WHITE, 15, "LEFT", "BOTTOM", addon.API.Fonts.CONTENT_LIGHT, "$parent.Title")
												Frame.Content.Text.Title:SetSize(Frame.Content.Text:GetSize())
												Frame.Content.Text.Title:SetPoint("LEFT", Frame.Content.Text)
												Frame.Content.Text.Title:SetAlpha(.75)
												Frame.Content.Text.Title:SetWordWrap(false)
											end
										end

										do -- BUTTONS
											Frame.Content.ButtonContainer = CreateFrame("Frame", "$parent.ButtonContainer", Frame.Content)
											Frame.Content.ButtonContainer:SetSize(Frame.Content:GetWidth() * .5, CONTENT_HEIGHT)
											Frame.Content.ButtonContainer:SetPoint("RIGHT", Frame.Content, -25, 0)

											--------------------------------

											local buttonSize = CONTENT_HEIGHT
											local buttonOffset = 0

											--------------------------------

											do -- OPEN
												Frame.Content.ButtonContainer.Button_Open = addon.API.FrameTemplates:CreateCustomButton(Frame.Content.ButtonContainer, buttonSize, buttonSize, "FULLSCREEN", {
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
												Frame.Content.ButtonContainer.Button_Open:SetPoint("RIGHT", Frame.Content.ButtonContainer, -buttonOffset, 0)
												Frame.Content.ButtonContainer.Button_Open:SetFrameStrata("FULLSCREEN")
												Frame.Content.ButtonContainer.Button_Open:SetFrameLevel(3)

												Frame.Content.ButtonContainer.Button_Open:SetScript("OnClick", function()
													NS.LibraryUI.Script:OpenFromLibrary(Frame.id)
												end)

												--------------------------------

												do -- IMAGE
													Frame.Content.ButtonContainer.Button_Open.Image, Frame.Content.ButtonContainer.Button_Open.ImageTexture = addon.API.FrameTemplates:CreateTexture(Frame.Content.ButtonContainer.Button_Open, "FULLSCREEN", NS.Variables.READABLE_UI_PATH .. "Library/button-open.png", "$parent.Image")
													Frame.Content.ButtonContainer.Button_Open.Image:SetAllPoints(Frame.Content.ButtonContainer.Button_Open, true)
													Frame.Content.ButtonContainer.Button_Open.Image:SetFrameStrata(Frame.Content.ButtonContainer.Button_Open:GetFrameStrata())
													Frame.Content.ButtonContainer.Button_Open.Image:SetFrameLevel(4)
													Frame.Content.ButtonContainer.Button_Open.Image:SetScale(.5)
												end

												--------------------------------

												buttonOffset = buttonOffset + Frame.Content.ButtonContainer.Button_Open:GetWidth() + NS.Variables:RATIO(10)
											end

											do -- DELETE
												Frame.Content.ButtonContainer.Button_Delete = addon.API.FrameTemplates:CreateCustomButton(Frame.Content.ButtonContainer, buttonSize, buttonSize, "FULLSCREEN", {
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
												Frame.Content.ButtonContainer.Button_Delete:SetPoint("RIGHT", Frame.Content.ButtonContainer, -buttonOffset, 0)
												Frame.Content.ButtonContainer.Button_Delete:SetFrameStrata("FULLSCREEN")
												Frame.Content.ButtonContainer.Button_Delete:SetFrameLevel(3)

												Frame.Content.ButtonContainer.Button_Delete:SetScript("OnClick", function()
													NS.LibraryUI.Script:DeleteFromLibrary(Frame.id)
												end)

												--------------------------------

												do -- IMAGE
													Frame.Content.ButtonContainer.Button_Delete.Image, Frame.Content.ButtonContainer.Button_Delete.ImageTexture = addon.API.FrameTemplates:CreateTexture(Frame.Content.ButtonContainer.Button_Delete, "FULLSCREEN", NS.Variables.READABLE_UI_PATH .. "Library/button-delete.png", "$parent.Image")
													Frame.Content.ButtonContainer.Button_Delete.Image:SetAllPoints(Frame.Content.ButtonContainer.Button_Delete, true)
													Frame.Content.ButtonContainer.Button_Delete.Image:SetFrameStrata(Frame.Content.ButtonContainer.Button_Delete:GetFrameStrata())
													Frame.Content.ButtonContainer.Button_Delete.Image:SetFrameLevel(4)
													Frame.Content.ButtonContainer.Button_Delete.Image:SetScale(.5)
												end

												--------------------------------

												buttonOffset = buttonOffset + Frame.Content.ButtonContainer.Button_Delete:GetWidth() + NS.Variables:RATIO(10)
											end
										end
									end
								end

								do -- ANIMATIONS
									do -- ON ENTER
										function Frame:Animation_OnEnter_StopEvent()
											return not Frame.isMouseOver
										end

										function Frame:Animation_OnEnter(skipAnimation)
											Frame:SetAlpha(.925)
											Frame.Content.Background:SetAlpha(1)
											Frame.Content.BackgroundTexture:SetTexture(NS.Variables.READABLE_UI_PATH .. "Library/element-background-highlighted-nineslice.png")

											--------------------------------

											addon.API.Animation:Scale(Frame.Content.Text, .25, Frame.Content.Text:GetWidth(), TEXT_WIDTH * .875, "x", addon.API.Animation.EaseExpo, Frame.Animation_OnEnter_StopEvent)
											addon.API.Animation:Fade(Frame.Content.ButtonContainer, .25, Frame.Content.ButtonContainer:GetAlpha(), 1, nil, Frame.Animation_OnEnter_StopEvent)
											addon.API.Animation:Move(Frame.Content.ButtonContainer, .375, "RIGHT", -25, 0, "y", nil, Frame.Animation_OnEnter_StopEvent)
										end
									end

									-- ON LEAVE
									function Frame:Animation_OnLeave_StopEvent()
										return Frame.isMouseOver
									end

									function Frame:Animation_OnLeave(skipAnimation)
										Frame:SetAlpha(.75)
										Frame.Content.Background:SetAlpha(1)
										Frame.Content.BackgroundTexture:SetTexture(NS.Variables.READABLE_UI_PATH .. "Library/element-background-nineslice.png")

										--------------------------------

										addon.API.Animation:Scale(Frame.Content.Text, .125, Frame.Content.Text:GetWidth(), TEXT_WIDTH, "x", nil, Frame.Animation_OnLeave_StopEvent)
										addon.API.Animation:Fade(Frame.Content.ButtonContainer, .125, Frame.Content.ButtonContainer:GetAlpha(), 0, nil, Frame.Animation_OnLeave_StopEvent)
										addon.API.Animation:Move(Frame.Content.ButtonContainer, .125, "RIGHT", 0, -10, "y", nil, Frame.Animation_OnLeave_StopEvent)
									end

									do -- ON MOUSE DOWN
										function Frame:Animation_OnMouseDown_StopEvent()
											return Frame.isMouseDown
										end

										function Frame:Animation_OnMouseDown(skipAnimation)

										end
									end

									do -- ON MOUSE UP
										function Frame:Animation_OnMouseUp_StopEvent()
											return not Frame.isMouseDown
										end

										function Frame:Animation_OnMouseUp(skipAnimation)

										end
									end
								end

								do -- LOGIC
									Frame.id = ""
									Frame.isMouseOver = false
									Frame.isMouseDown = false

									Frame.enterCallbacks = {}
									Frame.leaveCallbacks = {}
									Frame.mouseDownCallbacks = {}
									Frame.mouseUpCallbacks = {}
									Frame.clickCallbacks = {}

									--------------------------------

									do -- FUNCTIONS
										do -- LOGIC
											function Frame:UpdateGradientAlpha()
												Frame.Content.Text.Detail:SetAlphaGradient(0, 50)
												Frame.Content.Text.Title:SetAlphaGradient(0, 50)
											end

											function Frame:Update()
												if NS.LibraryUI.Variables.SelectedIndex == index then
													Frame:OnEnter()

													--------------------------------

													Frame:SetAlpha(1)
												else
													Frame:OnLeave()

													--------------------------------

													Frame:SetAlpha(.75)
												end
											end
										end
									end

									do -- EVENTS
										local function Logic_OnEnter()
											addon.SoundEffects:PlaySoundFile(addon.SoundEffects.Readable_LibraryUI_Button_Menu_Enter)
										end

										local function Logic_OnLeave()
											addon.SoundEffects:PlaySoundFile(addon.SoundEffects.Readable_LibraryUI_Button_Menu_Leave)
										end

										local function Logic_OnMouseDown()
											addon.SoundEffects:PlaySoundFile(addon.SoundEffects.Readable_LibraryUI_Button_Menu_MouseDown)
										end

										local function Logic_OnMouseUp()
											addon.SoundEffects:PlaySoundFile(addon.SoundEffects.Readable_LibraryUI_Button_Menu_MouseUp)
										end

										local function Logic_OnClick(button)
											if NS.LibraryUI.Variables.SelectedIndex == index then
												if addon.Database.DB_GLOBAL.profile.INT_FLIPMOUSE and button == "RightButton" or addon.Database.DB_GLOBAL.profile.INT_FLIPMOUSE or button == "LeftButton" then
													NS.LibraryUI.Script:OpenFromLibrary(Frame.id)
												else
													NS.LibraryUI.Variables.SelectedIndex = nil

													Frame:Animation_OnLeave()
												end
											else
												NS.LibraryUI.Variables.SelectedIndex = index

												Frame:Animation_OnEnter()
											end

											--------------------------------

											CallbackRegistry:Trigger("LIBRARY_MENU_SELECTION", Frame)
										end

										function Frame:OnEnter(skipAnimation)
											if NS.LibraryUI.Variables.SelectedIndex ~= index then
												Frame.isMouseOver = true

												--------------------------------

												Frame:Animation_OnEnter(skipAnimation)
												Logic_OnEnter()

												--------------------------------

												do -- ON ENTER
													if #Frame.enterCallbacks >= 1 then
														local enterCallbacks = Frame.enterCallbacks

														for callback = 1, #enterCallbacks do
															enterCallbacks[callback](Frame, skipAnimation)
														end
													end
												end
											end
										end

										function Frame:OnLeave(skipAnimation)
											if NS.LibraryUI.Variables.SelectedIndex ~= index then
												Frame.isMouseOver = false

												--------------------------------

												Frame:Animation_OnLeave(skipAnimation)
												Logic_OnLeave()

												--------------------------------

												do -- ON LEAVE
													if #Frame.leaveCallbacks >= 1 then
														local leaveCallbacks = Frame.leaveCallbacks

														for callback = 1, #leaveCallbacks do
															leaveCallbacks[callback](Frame, skipAnimation)
														end
													end
												end
											end
										end

										function Frame:OnMouseDown(button, skipAnimation)
											Frame.isMouseDown = true

											--------------------------------

											Frame:Animation_OnMouseDown(skipAnimation)
											Logic_OnMouseDown()

											--------------------------------

											do -- ON MOUSE DOWN
												if #Frame.mouseDownCallbacks >= 1 then
													local mouseDownCallbacks = Frame.mouseDownCallbacks

													for callback = 1, #mouseDownCallbacks do
														mouseDownCallbacks[callback](Frame, skipAnimation)
													end
												end
											end
										end

										function Frame:OnMouseUp(button, skipAnimation)
											Frame.isMouseDown = false

											--------------------------------

											Frame:Animation_OnMouseUp(skipAnimation)
											Logic_OnMouseUp()
											Logic_OnClick(button)

											--------------------------------

											do -- ON MOUSE UP
												if #Frame.mouseUpCallbacks >= 1 then
													local mouseUpCallbacks = Frame.mouseUpCallbacks

													for callback = 1, #mouseUpCallbacks do
														mouseUpCallbacks[callback](Frame, skipAnimation)
													end
												end
											end

											do -- ON CLICK
												if #Frame.clickCallbacks >= 1 then
													local clickCallbacks = Frame.clickCallbacks

													for callback = 1, #clickCallbacks do
														clickCallbacks[callback](Frame, skipAnimation, button)
													end
												end
											end
										end

										function Frame:OnClick(skipAnimation)
											Frame:OnMouseUp("LeftButton", skipAnimation)
										end

										addon.API.FrameTemplates:CreateMouseResponder(Frame, { enterCallback = Frame.OnEnter, leaveCallback = Frame.OnLeave, mouseDownCallback = function(button) Frame:OnMouseDown(button) end, mouseUpCallback = function(button) Frame:OnMouseUp(button) end })
									end
								end

								do -- SETUP
									Frame:OnLeave(true)
								end

								--------------------------------

								return Frame
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
