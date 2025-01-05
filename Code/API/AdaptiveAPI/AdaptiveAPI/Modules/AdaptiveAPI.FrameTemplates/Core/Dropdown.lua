local addonName, addon = ...
local NS = AdaptiveAPI.FrameTemplates
local CallbackRegistry = addon.CallbackRegistry

--------------------------------
-- VARIABLES
--------------------------------

do -- MAIN

end

do -- CONSTANTS

end

--------------------------------
-- TEMPLATES
--------------------------------

do
	-- Creates a fully customizable dropdown.
	--
	-- Data Table
	----
	-- valuesFunc, openListFunc, closeListFunc, autoCloseList,
	-- getFunc, setFunc, theme, defaultTexture, highlightTexture, arrowTexture,
	-- arrowHighlightTexture, arrowEnableTexture, defaultColor, highlightColor,
	-- textSize, textSizeTitle, defaultTextColor, highlightTextColor, listTexture,
	-- listButtonTexture, listButtonCheckBackgroundTexture, listButtonCheckTexture,
	-- listIndexBackgroundTexture, listIndexNextButtonTexture, listIndexPreviousButtonTexture,
	-- listColor, listElementColor, listPrimaryColor, listElementTextColor, listElementHighlightTextColor
	---@param mainParent any
	---@param parent any
	---@param frameStrata string
	---@param data table
	---@param name? string
	function NS:CreateDropdown(mainParent, parent, frameStrata, data, name)
		local FrameLevel = parent:GetFrameLevel()
		local Padding = 10

		--------------------------------

		local valuesFunc, openListFunc, closeListFunc, autoCloseList, getFunc, setFunc, theme, defaultTexture, highlightTexture, arrowTexture, arrowHighlightTexture, arrowEnableTexture, defaultColor, highlightColor, textSize, textSizeTitle, defaultTextColor, highlightTextColor, listTexture, listButtonTexture, listButtonCheckBackgroundTexture, listButtonCheckTexture, listIndexBackgroundTexture, listIndexNextButtonTexture, listIndexPreviousButtonTexture, listColor, listElementColor, listPrimaryColor, listElementTextColor, listElementHighlightTextColor =
			data.valuesFunc, data.openListFunc, data.closeListFunc, data.autoCloseList, data.getFunc, data.setFunc, data.theme, data.defaultTexture, data.highlightTexture, data.arrowTexture, data.arrowHighlightTexture, data.arrowEnableTexture, data.defaultColor, data.highlightColor, data.textSize, data.textSizeTitle, data.defaultTextColor, data.highlightTextColor, data.listTexture, data.listButtonTexture, data.listButtonCheckBackgroundTexture, data.listButtonCheckTexture, data.listIndexBackgroundTexture, data.listIndexNextButtonTexture, data.listIndexPreviousButtonTexture, data.listColor, data.listElementColor, data.listPrimaryColor, data.listElementTextColor, data.listElementHighlightTextColor

		--------------------------------

		local ValueTable = valuesFunc()

		--------------------------------

		local Frame = CreateFrame("Frame", name or nil, parent)
		Frame:SetFrameStrata(frameStrata)
		Frame:SetFrameLevel(FrameLevel + 1)

		Frame.Value = 1

		Frame:SetAlpha(1)

		--------------------------------

		Frame._DefaultTexture = nil
		Frame._HighlightTexture = nil
		Frame._ArrowTexture = nil
		Frame._ArrowHighlightTexture = nil
		Frame._ArrowEnableTexture = nil
		Frame._DefaultColor = nil
		Frame._HighlightColor = nil
		Frame._TextSize = nil
		Frame._DefaultTextColor = nil
		Frame._HighlightTextColor = nil
		Frame._ListTexture = nil
		Frame._ListButtonTexture = nil
		Frame._ListButtonCheckBackgroundTexture = nil
		Frame._ListButtonCheckTexture = nil
		Frame._ListIndexBackgroundTexture = nil
		Frame._ListIndexNextButtonTexture = nil
		Frame._ListIndexPreviousButtonTexture = nil
		Frame._ListColor = nil
		Frame._ListElementColor = nil
		Frame._ListPrimaryColor = nil
		Frame._ListElementTextColor = nil
		Frame._ListElementHighlightTextColor = nil

		Frame._CustomDefaultTexture = defaultTexture
		Frame._CustomHighlightTexture = highlightTexture
		Frame._CustomArrowTexture = arrowTexture
		Frame._CustomArrowHighlightTexture = arrowHighlightTexture
		Frame._CustomArrowEnableTexture = arrowEnableTexture
		Frame._CustomDefaultColor = defaultColor
		Frame._CustomHighlightColor = highlightColor
		Frame._CustomTextSize = textSize
		Frame._CustomTextSizeTitle = textSizeTitle
		Frame._CustomDefaultTextColor = defaultTextColor
		Frame._CustomHighlightTextColor = highlightTextColor
		Frame._CustomListTexture = listTexture
		Frame._CustomListButtonTexture = listButtonTexture
		Frame._CustomListButtonCheckBackgroundTexture = listButtonCheckBackgroundTexture
		Frame._CustomListButtonCheckTexture = listButtonCheckTexture
		Frame._CustomListIndexBackgroundTexture = listIndexBackgroundTexture
		Frame._CustomListIndexNextButtonTexture = listIndexNextButtonTexture
		Frame._CustomListIndexPreviousButtonTexture = listIndexPreviousButtonTexture
		Frame._CustomListColor = listColor
		Frame._CustomListElementColor = listElementColor
		Frame._CustomListPrimaryColor = listPrimaryColor
		Frame._CustomListElementTextColor = listElementTextColor
		Frame._CustomListElementHighlightTextColor = listElementHighlightTextColor

		--------------------------------

		Frame.EnterCallbacks = {}
		Frame.LeaveCallbacks = {}
		Frame.MouseDownCallbacks = {}
		Frame.MouseUpCallbacks = {}

		Frame.ListElementEnterCallbacks = {}
		Frame.ListElementLeaveCallbacks = {}
		Frame.ListElementMouseDownCallbacks = {}
		Frame.ListElementMouseUpCallbacks = {}

		Frame.ValueChangedCallbacks = {}

		--------------------------------

		local function UpdateTheme()
			if (theme and theme == 2) or (theme == nil and AdaptiveAPI.NativeAPI:GetDarkTheme()) then -- DARK MODE
				-- DROPDOWN
				Frame._DefaultTexture = Frame._CustomDefaultTexture or AdaptiveAPI.PATH .. "Elements/dropdown-background.png"
				Frame._HighlightTexture = Frame._CustomHighlightTexture or AdaptiveAPI.PATH .. "Elements/dropdown-background-highlighted.png"
				Frame._ArrowTexture = Frame._CustomArrowTexture or AdaptiveAPI.PATH .. "Elements/arrow-down-light.png"
				Frame._ArrowHighlightTexture = Frame._CustomArrowHighlightTexture or AdaptiveAPI.PATH .. "Elements/arrow-down-light.png"
				Frame._ArrowEnableTexture = Frame._CustomArrowEnableTexture or AdaptiveAPI.PATH .. "Elements/arrow-up-light.png"
				Frame._DefaultColor = Frame._CustomDefaultColor or { r = 1, g = 1, b = 1, a = .75 }
				Frame._HighlightColor = Frame._CustomHighlightColor or { r = 1, g = 1, b = 1, a = .5 }
				Frame._TextSize = Frame._CustomTextSize or 15
				Frame._TextSizeTitle = Frame._CustomTextSizeTitle or 15
				Frame._DefaultTextColor = Frame._CustomDefaultTextColor or { r = 1, g = 1, b = 1, a = 1 }
				Frame._HighlightTextColor = Frame._CustomHighlightTextColor or { r = 1, g = 1, b = 1, a = 1 }

				-- LIST
				Frame._ListTexture = Frame._CustomListTexture or AdaptiveAPI.PATH .. "Elements/dropdown-list-background-dark.png"
				Frame._ListButtonTexture = Frame._CustomListButtonTexture or AdaptiveAPI.PATH .. "Elements/dropdown-list-button-background.png"
				Frame._ListButtonCheckBackgroundTexture = Frame._CustomListButtonCheckBackgroundTexture or AdaptiveAPI.PATH .. "Elements/dropdown-list-check-background-dark.png"
				Frame._ListButtonCheckTexture = Frame._CustomListButtonCheckTexture or AdaptiveAPI.PATH .. "Elements/dropdown-list-check-light.png"
				Frame._ListIndexBackgroundTexture = Frame._CustomListIndexBackgroundTexture or AdaptiveAPI.PATH .. "Elements/dropdown-list-index-background-dark.png"
				Frame._ListIndexNextButtonTexture = Frame._CustomListIndexNextButtonTexture or AdaptiveAPI.PATH .. "Elements/arrow-right-light.png"
				Frame._ListIndexPreviousButtonTexture = Frame._CustomListIndexPreviousButtonTexture or AdaptiveAPI.PATH .. "Elements/arrow-left-light.png"
				Frame._ListColor = Frame._CustomListColor or { r = 1, g = 1, b = 1, a = 1 }
				Frame._ListElementColor = Frame._CustomListElementColor or { r = 1, g = 1, b = 1, a = .125 }
				Frame._ListPrimaryColor = Frame._CustomListPrimaryColor or { r = 1, g = 1, b = 1, a = 1 }
				Frame._ListElementTextColor = Frame._CustomListElementTextColor or { r = 1, g = 1, b = 1, a = 1 }
				Frame._ListElementHighlightTextColor = Frame._CustomListElementHighlightTextColor or { r = 1, g = 1, b = 1, a = 1 }
			elseif (theme and theme == 1) or (theme == nil and not AdaptiveAPI.NativeAPI:GetDarkTheme()) then -- LIGHT MODE
				-- DROPDOWN
				Frame._DefaultTexture = Frame._CustomDefaultTexture or AdaptiveAPI.PATH .. "Elements/dropdown-background.png"
				Frame._HighlightTexture = Frame._CustomHighlightTexture or AdaptiveAPI.PATH .. "Elements/dropdown-background-highlighted.png"
				Frame._ArrowTexture = Frame._CustomArrowTexture or AdaptiveAPI.PATH .. "Elements/arrow-down-dark.png"
				Frame._ArrowHighlightTexture = Frame._CustomArrowHighlightTexture or AdaptiveAPI.PATH .. "Elements/arrow-down-light.png"
				Frame._ArrowEnableTexture = Frame._CustomArrowEnableTexture or AdaptiveAPI.PATH .. "Elements/arrow-up-light.png"
				Frame._DefaultColor = Frame._CustomDefaultColor or { r = .1, g = .1, b = .1, a = 1 }
				Frame._HighlightColor = Frame._CustomHighlightColor or { r = .1, g = .1, b = .1, a = .75 }
				Frame._TextSize = Frame._CustomTextSize or 15
				Frame._TextSizeTitle = Frame._CustomTextSizeTitle or 15
				Frame._DefaultTextColor = Frame._CustomDefaultTextColor or { r = .1, g = .1, b = .1, a = 1 }
				Frame._HighlightTextColor = Frame._CustomHighlightTextColor or { r = 1, g = 1, b = 1, a = 1 }

				-- LIST
				Frame._ListTexture = Frame._CustomListTexture or AdaptiveAPI.PATH .. "Elements/dropdown-list-background-light.png"
				Frame._ListButtonTexture = Frame._CustomListButtonTexture or AdaptiveAPI.PATH .. "Elements/dropdown-list-button-background.png"
				Frame._ListButtonCheckBackgroundTexture = Frame._CustomListButtonCheckBackgroundTexture or AdaptiveAPI.PATH .. "Elements/dropdown-list-check-background-light.png"
				Frame._ListButtonCheckTexture = Frame._CustomListButtonCheckTexture or AdaptiveAPI.PATH .. "Elements/dropdown-list-check-light.png"
				Frame._ListIndexBackgroundTexture = Frame._CustomListIndexBackgroundTexture or AdaptiveAPI.PATH .. "Elements/dropdown-list-index-background-light.png"
				Frame._ListIndexNextButtonTexture = Frame._CustomListIndexNextButtonTexture or AdaptiveAPI.PATH .. "Elements/arrow-right-light.png"
				Frame._ListIndexPreviousButtonTexture = Frame._CustomListIndexPreviousButtonTexture or AdaptiveAPI.PATH .. "Elements/arrow-left-light.png"
				Frame._ListColor = Frame._CustomListColor or { r = 1, g = 1, b = 1, a = 1 }
				Frame._ListElementColor = Frame._CustomListElementColor or { r = .1, g = .1, b = .1, a = .125 }
				Frame._ListPrimaryColor = Frame._CustomListPrimaryColor or { r = .1, g = .1, b = .1, a = 1 }
				Frame._ListElementTextColor = Frame._CustomListElementTextColor or { r = .1, g = .1, b = .1, a = 1 }
				Frame._ListElementHighlightTextColor = Frame._CustomListElementHighlightTextColor or { r = .1, g = .1, b = .1, a = 1 }
			end
		end

		AdaptiveAPI:RegisterThemeUpdateWithNativeAPI(UpdateTheme, 4)

		--------------------------------

		do -- FUNCTIONS
			Frame.SetValue = function(element, value)
				setFunc(element, value)
				Frame.UpdateDropdown()
			end

			Frame.ShowListCallback = function()
				openListFunc()

				--------------------------------

				Frame:SetAlpha(1)

				--------------------------------

				Frame.Text:SetTextColor(Frame._HighlightTextColor.r, Frame._HighlightTextColor.g, Frame._HighlightTextColor.b, Frame._HighlightTextColor.a or 1)

				--------------------------------

				Frame.BackgroundTexture:SetTexture(Frame._HighlightTexture)
				Frame.BackgroundTexture:SetVertexColor(Frame._HighlightColor.r, Frame._HighlightColor.g, Frame._HighlightColor.b, Frame._HighlightColor.a)

				--------------------------------

				Frame.ArrowTexture:SetTexture(Frame._ArrowEnableTexture)
			end

			Frame.HideListCallback = function()
				closeListFunc()

				--------------------------------

				Frame:SetAlpha(1)

				--------------------------------

				Frame.Text:SetTextColor(Frame._HighlightTextColor.r, Frame._HighlightTextColor.g, Frame._HighlightTextColor.b, Frame._HighlightTextColor.a or 1)

				--------------------------------

				Frame.BackgroundTexture:SetTexture(Frame._HighlightTexture)
				Frame.BackgroundTexture:SetVertexColor(Frame._HighlightColor.r, Frame._HighlightColor.g, Frame._HighlightColor.b, Frame._HighlightColor.a)

				--------------------------------

				Frame.ArrowTexture:SetTexture(Frame._ArrowHighlightTexture)
			end

			Frame.Enter = function()
				if not Frame.List:IsVisible() then
					Frame:SetAlpha(1)

					--------------------------------

					Frame.Text:SetTextColor(Frame._HighlightTextColor.r, Frame._HighlightTextColor.g, Frame._HighlightTextColor.b, Frame._HighlightTextColor.a or 1)

					--------------------------------

					Frame.BackgroundTexture:SetTexture(Frame._HighlightTexture)
					Frame.BackgroundTexture:SetVertexColor(Frame._HighlightColor.r, Frame._HighlightColor.g, Frame._HighlightColor.b, Frame._HighlightColor.a)

					--------------------------------

					Frame.ArrowTexture:SetTexture(Frame._ArrowHighlightTexture)

					--------------------------------

					local EnterCallbacks = Frame.EnterCallbacks

					for callback = 1, #EnterCallbacks do
						EnterCallbacks[callback]()
					end
				end
			end

			Frame.Leave = function()
				if not Frame.List:IsVisible() then
					Frame:SetAlpha(1)

					--------------------------------

					Frame.Text:SetTextColor(Frame._DefaultTextColor.r, Frame._DefaultTextColor.g, Frame._DefaultTextColor.b, Frame._DefaultTextColor.a or 1)

					--------------------------------

					Frame.BackgroundTexture:SetTexture(Frame._DefaultTexture)
					Frame.BackgroundTexture:SetVertexColor(Frame._DefaultColor.r, Frame._DefaultColor.g, Frame._DefaultColor.b, Frame._DefaultColor.a)

					--------------------------------

					Frame.ArrowTexture:SetTexture(Frame._ArrowTexture)

					--------------------------------

					local LeaveCallbacks = Frame.LeaveCallbacks

					for callback = 1, #LeaveCallbacks do
						LeaveCallbacks[callback]()
					end
				end
			end

			Frame.MouseDown = function()
				local MouseDownCallbacks = Frame.MouseDownCallbacks

				for callback = 1, #MouseDownCallbacks do
					MouseDownCallbacks[callback]()
				end
			end

			Frame.MouseUp = function()
				Frame.List.ToggleVisibility()

				--------------------------------

				local MouseUpCallbacks = Frame.MouseDownCallbacks

				for callback = 1, #MouseUpCallbacks do
					MouseUpCallbacks[callback]()
				end
			end

			Frame:SetScript("OnEnter", Frame.Enter)
			Frame:SetScript("OnLeave", Frame.Leave)
			Frame:SetScript("OnMouseDown", Frame.MouseDown)
			Frame:SetScript("OnMouseUp", Frame.MouseUp)
		end

		do -- ELEMENTS
			do -- DROPDOWN
				do -- BACKGROUND
					Frame.Background, Frame.BackgroundTexture = AdaptiveAPI.FrameTemplates:CreateNineSlice(Frame, frameStrata, Frame._DefaultTexture, 25, 1, "$parent.Background")
					Frame.Background:SetSize(Frame:GetSize())
					Frame.Background:SetPoint("CENTER", Frame)
					Frame.Background:SetFrameLevel(FrameLevel)

					--------------------------------

					AdaptiveAPI:RegisterThemeUpdateWithNativeAPI(function()
						Frame.BackgroundTexture:SetVertexColor(Frame._DefaultColor.r, Frame._DefaultColor.g, Frame._DefaultColor.b, Frame._DefaultColor.a or 1)
						Frame.BackgroundTexture:SetTexture(Frame._DefaultTexture)
					end, 5)
				end

				do -- ARROW
					Frame.Arrow, Frame.ArrowTexture = AdaptiveAPI.FrameTemplates:CreateTexture(Frame, frameStrata, Frame._ArrowTexture, "$parent.Arrow")
					Frame.Arrow:SetSize(Frame:GetHeight(), Frame:GetHeight())
					Frame.Arrow:SetPoint("RIGHT", Frame)
					Frame.Arrow:SetFrameLevel(FrameLevel + 1)

					--------------------------------

					AdaptiveAPI:RegisterThemeUpdateWithNativeAPI(function()
						Frame.ArrowTexture:SetTexture(Frame._ArrowTexture)
					end, 5)
				end

				do -- TEXT
					Frame.Text = AdaptiveAPI.FrameTemplates:CreateText(Frame, Frame._DefaultTextColor, Frame._TextSize, "LEFT", "MIDDLE", AdaptiveAPI.Fonts.Content_Light, "$parent.Label", false)
					Frame.Text:SetSize(Frame:GetWidth() - Frame.Arrow:GetWidth() - Padding, Frame:GetHeight() - Padding)
					Frame.Text:SetPoint("LEFT", Frame, Padding, 0)

					--------------------------------

					AdaptiveAPI:RegisterThemeUpdateWithNativeAPI(function()
						Frame.Text:SetTextColor(Frame._DefaultTextColor.r, Frame._DefaultTextColor.g, Frame._DefaultTextColor.b, Frame._DefaultTextColor.a)
					end, 5)
				end
			end

			do -- LIST
				local ElementHeight = 35
				local IndexHeight = 35

				--------------------------------

				Frame.List = CreateFrame("Frame", "$parent.List", InteractionFrame)
				Frame.List:SetWidth(Frame:GetWidth())
				Frame.List:SetPoint("TOP", Frame, 0, -Frame:GetHeight() - (Padding / 2))
				Frame.List:SetFrameStrata("FULLSCREEN_DIALOG")
				Frame.List:SetFrameLevel(50)
				Frame.List:Hide()

				--------------------------------

				do -- VARIABLES
					Frame.List.Elements = {}
				end

				do -- LOGIC
					function Frame.List.ShowList()
						Frame.ShowListCallback()

						--------------------------------

						Frame.List:Show()
						Frame.List.ResetPage()
					end

					function Frame.List.HideList()
						Frame.HideListCallback()

						--------------------------------

						Frame.List:Hide()
						Frame.List.ResetPage()
					end

					function Frame.List.ForceHideList()
						Frame.List:Hide()
						Frame.List.ResetPage()
						Frame.Leave()
					end

					function Frame.List.ToggleVisibility()
						if Frame.List:IsVisible() then
							Frame.List.HideList()
						else
							Frame.List.ShowList()
						end

						--------------------------------

						Frame.List.ResetPage()
					end
				end

				do -- PAGE LOGIC
					Frame.List.CurrentPage = 1

					--------------------------------

					function Frame.List.ResetPage()
						local minPage, maxPage = Frame.List.GetPageData()
						local pageLength = #Frame.List.Elements
						local currentValue = Frame.Value
						local targetPage

						if currentValue then
							targetPage = math.ceil(currentValue / 5)
						else
							targetPage = 1
						end

						--------------------------------

						Frame.List.CurrentPage = targetPage

						--------------------------------

						Frame.List.UpdatePageData()
					end

					function Frame.List.GetPageData()
						local numEntries = #ValueTable
						local pageLength = #Frame.List.Elements
						local minPage = 1
						local maxPage = math.ceil(numEntries / pageLength)

						--------------------------------

						return minPage, maxPage
					end

					function Frame.List.NextPage()
						local minPage, maxPage = Frame.List.GetPageData()

						--------------------------------

						if Frame.List.CurrentPage < maxPage then
							Frame.List.CurrentPage = Frame.List.CurrentPage + 1
						end

						--------------------------------

						Frame.List.UpdatePageData()
					end

					function Frame.List.PreviousPage()
						local minPage, maxPage = Frame.List.GetPageData()

						--------------------------------

						if Frame.List.CurrentPage > minPage then
							Frame.List.CurrentPage = Frame.List.CurrentPage - 1
						end

						--------------------------------

						Frame.List.UpdatePageData()
					end

					function Frame.List.UpdatePageData()
						local minPage, maxPage = Frame.List.GetPageData()
						local currentPage = Frame.List.CurrentPage

						--------------------------------

						Frame.List.Content.Index.Label:SetText(currentPage .. "/" .. maxPage)

						if currentPage <= minPage then
							Frame.List.Content.Index.ButtonContainer.PreviousPageButton:SetEnabled(false)
						else
							Frame.List.Content.Index.ButtonContainer.PreviousPageButton:SetEnabled(true)
						end

						if currentPage >= maxPage then
							Frame.List.Content.Index.ButtonContainer.NextPageButton:SetEnabled(false)
						else
							Frame.List.Content.Index.ButtonContainer.NextPageButton:SetEnabled(true)
						end

						--------------------------------

						local elements = Frame.List.Elements
						local offset = ((currentPage - 1) * 5)

						for i = 1, #elements do
							if offset + i <= #ValueTable then
								elements[i]:Show()
								elements[i].Index = offset + i
							else
								elements[i]:Hide()
							end
						end
					end
				end

				--------------------------------

				do -- ELEMENTS
					do -- MOUSE
						Frame.List.Mouse = CreateFrame("Frame", "$parent.Mouse", Frame.List)
						Frame.List.Mouse:SetSize(UIParent:GetSize())
						Frame.List.Mouse:SetPoint("CENTER", UIParent)
						Frame.List.Mouse:SetFrameLevel(49)

						--------------------------------

						Frame.List.Mouse:SetScript("OnMouseDown", function()
							Frame.MouseUp()
							Frame.Leave()
						end)
					end

					do -- BACKGROUND
						Frame.List.Background, Frame.List.BackgroundTexture = AdaptiveAPI.FrameTemplates:CreateNineSlice(Frame.List, frameStrata, Frame._ListTexture, 150, .25, "$parent.Background", Enum.UITextureSliceMode.Stretched)
						Frame.List.Background:SetSize(Frame.List:GetWidth() + 25, Frame.List:GetHeight() + 25)
						Frame.List.Background:SetPoint("CENTER", Frame.List)
						Frame.List.Background:SetFrameLevel(49)

						--------------------------------

						AdaptiveAPI:RegisterThemeUpdateWithNativeAPI(function()
							Frame.List.BackgroundTexture:SetVertexColor(Frame._ListColor.r, Frame._ListColor.g, Frame._ListColor.b, Frame._ListColor.a or 1)
							Frame.List.BackgroundTexture:SetTexture(Frame._ListTexture)
						end, 5)
					end

					do -- CONTENT
						Frame.List.Content = CreateFrame("Frame", "$parent.Content", Frame.List)
						Frame.List.Content:SetSize(Frame.List:GetWidth() - 25, Frame.List:GetHeight() - 25)
						Frame.List.Content:SetPoint("CENTER", Frame.List)
						Frame.List.Content:SetFrameLevel(50)

						--------------------------------

						do -- ELEMENTS
							local function CreateElement(parent, index)
								local Element = CreateFrame("Frame", nil, parent)
								Element:SetSize(parent:GetWidth(), ElementHeight)
								Element:SetPoint("CENTER", parent)
								Element:SetFrameLevel(51)

								--------------------------------

								Element.Index = index

								--------------------------------

								do -- LOGIC
									local function UpdateSelectionButton()
										if Frame.Value == Element.Index then
											Element.Checkbox:Show()
											Element.Text:SetTextColor(Frame._ListElementHighlightTextColor.r, Frame._ListElementHighlightTextColor.g, Frame._ListElementHighlightTextColor.b, Frame._ListElementHighlightTextColor.a or 1)
										else
											Element.Checkbox:Hide()
											Element.Text:SetTextColor(Frame._ListElementTextColor.r, Frame._ListElementTextColor.g, Frame._ListElementTextColor.b, Frame._ListElementTextColor.a or 1)
										end

										--------------------------------

										Element.Text:SetText(ValueTable[Element.Index])
									end

									Element.UpdateSize = function()
										Element:SetSize(parent:GetWidth(), ElementHeight)
										Element.Background:SetSize(Element:GetSize())
										Element.Checkbox:SetSize(Element:GetHeight() - Padding, Element:GetHeight() - Padding)
										Element.Checkbox.Icon:SetSize(Element.Checkbox:GetHeight() - (Padding / 2), Element.Checkbox:GetHeight() - (Padding / 2))
										Element.Text:SetSize(Element:GetWidth() - Padding - Element.Checkbox.Icon:GetWidth() - Padding, Element:GetHeight())
										Element.Text:SetPoint("LEFT", Element, Padding, 0)
									end

									Element:SetScript("OnUpdate", function()
										UpdateSelectionButton()
									end)

									Element:SetScript("OnEnter", function()
										Element.Background:SetAlpha(1)

										--------------------------------

										local ListElementEnterCallbacks = Frame.ListElementEnterCallbacks

										for callback = 1, #ListElementEnterCallbacks do
											ListElementEnterCallbacks[callback]()
										end

										--------------------------------

										UpdateSelectionButton()
									end)

									Element:SetScript("OnLeave", function()
										Element.Background:SetAlpha(0)

										--------------------------------

										local ListElementLeaveCallbacks = Frame.ListElementLeaveCallbacks

										for callback = 1, #ListElementLeaveCallbacks do
											ListElementLeaveCallbacks[callback]()
										end

										--------------------------------

										UpdateSelectionButton()
									end)

									Element:SetScript("OnMouseDown", function()
										Element.Background:SetAlpha(.5)

										--------------------------------

										local ListElementMouseDownCallbacks = Frame.ListElementMouseDownCallbacks

										for callback = 1, #ListElementMouseDownCallbacks do
											ListElementMouseDownCallbacks[callback]()
										end

										--------------------------------

										UpdateSelectionButton()
									end)

									Element:SetScript("OnMouseUp", function()
										Element.Background:SetAlpha(0)

										--------------------------------

										Frame.SetValue(Element, Element.Index)

										--------------------------------

										if autoCloseList then
											Frame.MouseUp()
											Frame.Leave()
										end

										--------------------------------

										local ListElementMouseUpCallbacks = Frame.ListElementMouseUpCallbacks

										for callback = 1, #ListElementMouseUpCallbacks do
											ListElementMouseUpCallbacks[callback]()
										end

										--------------------------------

										if Element.Index ~= Frame.Value then
											local ValueChangedCallbacks = Frame.ValueChangedCallbacks

											for callback = 1, #ValueChangedCallbacks do
												ValueChangedCallbacks[callback]()
											end
										end

										--------------------------------

										CallbackRegistry:Trigger("DROPDOWN_LIST_ELEMENT_MOUSEUP")
									end)

									--------------------------------

									CallbackRegistry:Add("DROPDOWN_LIST_ELEMENT_MOUSEUP", UpdateSelectionButton, 0)
								end

								--------------------------------

								do -- BACKGROUND
									Element.Background, Element.BackgroundTexture = AdaptiveAPI.FrameTemplates:CreateNineSlice(Element, Element:GetFrameStrata(), Frame._ListButtonTexture, 25, 1, "$parent.Background")
									Element.Background:SetSize(Element:GetSize())
									Element.Background:SetPoint("CENTER", Element)
									Element.Background:SetFrameLevel(50)
									Element.Background:SetAlpha(0)

									--------------------------------

									AdaptiveAPI:RegisterThemeUpdateWithNativeAPI(function()
										Element.BackgroundTexture:SetVertexColor(Frame._ListElementColor.r, Frame._ListElementColor.g, Frame._ListElementColor.b, Frame._ListElementColor.a)
									end, 5)
								end

								do -- CHECKBOX
									Element.Checkbox = CreateFrame("Frame", "$parent.Checkbox", Element)
									Element.Checkbox:SetSize(Element:GetHeight() - Padding, Element:GetHeight() - Padding)
									Element.Checkbox:SetPoint("RIGHT", Element, -Padding, 0)
									Element.Checkbox:SetFrameLevel(51)

									--------------------------------

									do -- ICON
										Element.Checkbox.Icon, Element.Checkbox.IconTexture = AdaptiveAPI.FrameTemplates:CreateTexture(Element.Checkbox, Element.Checkbox:GetFrameStrata(), Frame._ListButtonCheckTexture, "$parent.Icon")
										Element.Checkbox.Icon:SetSize(Element.Checkbox:GetHeight() - (Padding / 2), Element.Checkbox:GetHeight() - (Padding / 2))
										Element.Checkbox.Icon:SetPoint("CENTER", Element.Checkbox)
										Element.Checkbox.Icon:SetFrameLevel(53)
										Element.Checkbox.IconTexture:SetVertexColor(Frame._ListPrimaryColor.r, Frame._ListPrimaryColor.g, Frame._ListPrimaryColor.b, Frame._ListPrimaryColor.a)

										--------------------------------

										AdaptiveAPI:RegisterThemeUpdateWithNativeAPI(function()
											Element.Checkbox.IconTexture:SetVertexColor(Frame._ListPrimaryColor.r, Frame._ListPrimaryColor.g, Frame._ListPrimaryColor.b, Frame._ListPrimaryColor.a)
										end, 5)
									end

									do -- BACKGROUND
										Element.Checkbox.Background, Element.Checkbox.BackgroundTexture = AdaptiveAPI.FrameTemplates:CreateNineSlice(Element.Checkbox, Element.Checkbox:GetFrameStrata(), Frame._ListButtonCheckBackgroundTexture, 25, 1, "$parent.Background")
										Element.Checkbox.Background:SetAllPoints(Element.Checkbox, true)
										Element.Checkbox.Background:SetFrameLevel(52)
									end

									--------------------------------

									AdaptiveAPI:RegisterThemeUpdateWithNativeAPI(function()
										Element.Checkbox.IconTexture:SetTexture(Frame._ListButtonCheckTexture)
										Element.Checkbox.BackgroundTexture:SetTexture(Frame._ListButtonCheckBackgroundTexture)
									end, 5)
								end

								do -- TEXT
									Element.Text = AdaptiveAPI.FrameTemplates:CreateText(Element, Frame._ListElementTextColor, Frame._TextSize, "LEFT", "MIDDLE", AdaptiveAPI.Fonts.Content_Light, "$parent.Text", false)
									Element.Text:SetSize(Element:GetWidth() - Padding - Element.Checkbox:GetWidth() - Padding, Element:GetHeight())
									Element.Text:SetPoint("LEFT", Element, Padding, 0)

									--------------------------------

									AdaptiveAPI:RegisterThemeUpdateWithNativeAPI(function()
										Element.Text:SetTextColor(Frame._ListElementTextColor.r, Frame._ListElementTextColor.g, Frame._ListElementTextColor.b, Frame._ListElementTextColor.a)
									end, 5)
								end

								--------------------------------

								Element.UpdateSize()

								--------------------------------

								return Element
							end

							--------------------------------

							local Elements = {}
							for i = 1, 5 do
								local Element = CreateElement(Frame.List.Content, i)

								--------------------------------

								Element:SetPoint("TOP", Frame.List.Content, 0, -(Element:GetHeight()) * (i - 1))

								--------------------------------

								table.insert(Elements, Element)
							end
							Frame.List.Elements = Elements
						end

						do -- INDEX
							Frame.List.Content.Index = CreateFrame("Frame", "$parent.Index", Frame.List.Content)
							Frame.List.Content.Index:SetSize(125, IndexHeight)
							Frame.List.Content.Index:SetPoint("BOTTOM", Frame.List.Content)
							Frame.List.Content.Index:SetFrameLevel(51)

							--------------------------------

							do -- BACKGROUND
								Frame.List.Content.Index.Background, Frame.List.Content.Index.BackgroundTexture = AdaptiveAPI.FrameTemplates:CreateTexture(Frame.List.Content.Index, Frame.List.Content.Index:GetFrameStrata(), Frame._ListIndexBackgroundTexture, "$parent.Background")
								Frame.List.Content.Index.Background:SetAllPoints(Frame.List.Content.Index, true)
								Frame.List.Content.Index.Background:SetFrameLevel(50)

								--------------------------------

								AdaptiveAPI:RegisterThemeUpdateWithNativeAPI(function()
									Frame.List.Content.Index.BackgroundTexture:SetTexture(Frame._ListIndexBackgroundTexture)
								end, 5)
							end

							do -- LABEL
								Frame.List.Content.Index.Label = AdaptiveAPI.FrameTemplates:CreateText(Frame.List.Content.Index, Frame._ListPrimaryColor, Frame._TextSizeTitle, "CENTER", "MIDDLE", AdaptiveAPI.Fonts.Content_Light, "$parent.Label")
								Frame.List.Content.Index.Label:SetAllPoints(Frame.List.Content.Index, true)
								Frame.List.Content.Index.Label:SetText("1/5")

								--------------------------------

								AdaptiveAPI:RegisterThemeUpdateWithNativeAPI(function()
									Frame.List.Content.Index.Label:SetTextColor(Frame._ListPrimaryColor.r, Frame._ListPrimaryColor.g, Frame._ListPrimaryColor.b)
								end, 5)
							end

							do -- BUTTON CONTAINER
								Frame.List.Content.Index.ButtonContainer = CreateFrame("Frame", "$parent.ButtonContainer", Frame.List.Content.Index)
								Frame.List.Content.Index.ButtonContainer:SetSize(100, Frame.List.Content.Index:GetHeight())
								Frame.List.Content.Index.ButtonContainer:SetPoint("CENTER", Frame.List.Content.Index)
								Frame.List.Content.Index.ButtonContainer:SetFrameLevel(51)

								--------------------------------

								do -- PREVIOUS PAGE
									local Size = IndexHeight - Padding

									--------------------------------

									Frame.List.Content.Index.ButtonContainer.PreviousPageButton = AdaptiveAPI.FrameTemplates:CreateCustomButton(Frame.List.Content.Index.ButtonContainer, Size, Size, Frame.List.Content.Index:GetFrameStrata(), {
										defaultTexture = "",
										highlightTexture = "",
										edgeSize = 25,
										scale = 1,
										theme = 2,
										playAnimation = false,
										customColor = nil,
										customHighlightColor = nil,
										customActiveColor = nil,
									}, "$parent.PreviousPageButton")
									Frame.List.Content.Index.ButtonContainer.PreviousPageButton:SetPoint("LEFT", Frame.List.Content.Index.ButtonContainer)
									Frame.List.Content.Index.ButtonContainer.PreviousPageButton:SetFrameLevel(52)

									--------------------------------

									do -- IMAGE
										Frame.List.Content.Index.ButtonContainer.PreviousPageButton.Image, Frame.List.Content.Index.ButtonContainer.PreviousPageButton.ImageTexture = AdaptiveAPI.FrameTemplates:CreateTexture(Frame.List.Content.Index.ButtonContainer.PreviousPageButton, Frame.List.Content.Index:GetFrameStrata(), Frame._ListIndexPreviousButtonTexture, "$parent.Image")
										Frame.List.Content.Index.ButtonContainer.PreviousPageButton.Image:SetSize(Frame.List.Content.Index.ButtonContainer.PreviousPageButton:GetWidth(), Frame.List.Content.Index.ButtonContainer.PreviousPageButton:GetHeight())
										Frame.List.Content.Index.ButtonContainer.PreviousPageButton.Image:SetPoint("CENTER", Frame.List.Content.Index.ButtonContainer.PreviousPageButton)
										Frame.List.Content.Index.ButtonContainer.PreviousPageButton.Image:SetFrameLevel(53)

										--------------------------------

										AdaptiveAPI:RegisterThemeUpdateWithNativeAPI(function()
											Frame.List.Content.Index.ButtonContainer.PreviousPageButton.ImageTexture:SetVertexColor(Frame._ListPrimaryColor.r, Frame._ListPrimaryColor.g, Frame._ListPrimaryColor.b, Frame._ListPrimaryColor.a)
										end, 5)
									end

									--------------------------------

									Frame.List.Content.Index.ButtonContainer.PreviousPageButton:SetScript("OnClick", function()
										Frame.List.PreviousPage()
									end)
								end

								do -- NEXT PAGE
									local Size = IndexHeight - Padding

									--------------------------------

									Frame.List.Content.Index.ButtonContainer.NextPageButton = AdaptiveAPI.FrameTemplates:CreateCustomButton(Frame.List.Content.Index.ButtonContainer, Size, Size, Frame.List.Content.Index:GetFrameStrata(), {
										defaultTexture = "",
										highlightTexture = "",
										edgeSize = 25,
										scale = 1,
										theme = 2,
										playAnimation = false,
										customColor = nil,
										customHighlightColor = nil,
										customActiveColor = nil,
									}, "$parent.PreviousPageButton")
									Frame.List.Content.Index.ButtonContainer.NextPageButton:SetPoint("RIGHT", Frame.List.Content.Index.ButtonContainer)
									Frame.List.Content.Index.ButtonContainer.NextPageButton:SetFrameLevel(52)

									--------------------------------

									do -- IMAGE
										Frame.List.Content.Index.ButtonContainer.NextPageButton.Image, Frame.List.Content.Index.ButtonContainer.NextPageButton.ImageTexture = AdaptiveAPI.FrameTemplates:CreateTexture(Frame.List.Content.Index.ButtonContainer.NextPageButton, Frame.List.Content.Index:GetFrameStrata(), Frame._ListIndexNextButtonTexture, "$parent.Image")
										Frame.List.Content.Index.ButtonContainer.NextPageButton.Image:SetSize(Frame.List.Content.Index.ButtonContainer.NextPageButton:GetWidth(), Frame.List.Content.Index.ButtonContainer.NextPageButton:GetHeight())
										Frame.List.Content.Index.ButtonContainer.NextPageButton.Image:SetPoint("CENTER", Frame.List.Content.Index.ButtonContainer.NextPageButton)
										Frame.List.Content.Index.ButtonContainer.NextPageButton.Image:SetFrameLevel(53)

										--------------------------------

										AdaptiveAPI:RegisterThemeUpdateWithNativeAPI(function()
											Frame.List.Content.Index.ButtonContainer.NextPageButton.ImageTexture:SetVertexColor(Frame._ListPrimaryColor.r, Frame._ListPrimaryColor.g, Frame._ListPrimaryColor.b, Frame._ListPrimaryColor.a)
										end, 5)
									end

									--------------------------------

									Frame.List.Content.Index.ButtonContainer.NextPageButton:SetScript("OnClick", function()
										Frame.List.NextPage()
									end)
								end
							end
						end
					end
				end

				--------------------------------

				do -- EVENTS
					local function UpdateSize()
						Frame.List:SetWidth(Frame:GetWidth())
						Frame.List:SetHeight(math.min(250, Padding + ElementHeight * #Frame.List.Elements) + Padding + IndexHeight + Padding)
						Frame.List:SetPoint("TOP", Frame, 0, -Frame:GetHeight())

						--------------------------------

						Frame.List.Content:SetSize(Frame.List:GetWidth() - 25, Frame.List:GetHeight() - 25)
						Frame.List.Background:SetSize(Frame.List:GetWidth() + 25, Frame.List:GetHeight() + 25)

						--------------------------------

						for i = 1, #Frame.List.Elements do
							Frame.List.Elements[i]:UpdateSize()
						end
					end

					--------------------------------

					AdaptiveAPI.FrameTemplates:CreateScrollResponder(Frame.List, function(self, delta)
						if delta >= 1 then
							Frame.List.PreviousPage()
						end

						if delta <= -1 then
							Frame.List.NextPage()
						end
					end)

					hooksecurefunc(mainParent, "Hide", function()
						Frame.List.ForceHideList()
					end)
					hooksecurefunc(Frame, "Show", function()
						Frame.List.ToggleVisibility(); UpdateSize()
					end)
					hooksecurefunc(Frame, "Hide", function()
						Frame.List.ToggleVisibility(); UpdateSize()
					end)
					hooksecurefunc(Frame.List, "Show", UpdateSize)
				end
			end
		end

		do -- EVENTS
			local function UpdateSize()
				Frame.Background:SetSize(Frame:GetSize())
				Frame.Arrow:SetSize(Frame:GetHeight(), Frame:GetHeight())
				Frame.Text:SetSize(Frame:GetWidth() - Padding, Frame:GetHeight() - Padding)
			end

			Frame.UpdateDropdown = function()
				Frame.Value = getFunc()
				Frame.Text:SetText(ValueTable[Frame.Value])
			end

			hooksecurefunc(Frame, "SetWidth", UpdateSize)
			hooksecurefunc(Frame, "SetHeight", UpdateSize)
			hooksecurefunc(Frame, "SetSize", UpdateSize)
			hooksecurefunc(Frame, "Show", Frame.UpdateDropdown)

			Frame.UpdateDropdown()
		end

		--------------------------------

		return Frame
	end

	-- Updates the theme of a dropdown.
	--
	-- Data Table
	----
	-- defaultTexture, highlightTexture, arrowTexture,
	-- arrowHighlightTexture, arrowEnableTexture, defaultColor, highlightColor,
	-- textSize, textSizeTitle, defaultTextColor, highlightTextColor, listTexture,
	-- listButtonTexture, listButtonCheckBackgroundTexture, listButtonCheckTexture,
	-- listIndexBackgroundTexture, listIndexNextButtonTexture, listIndexPreviousButtonTexture,
	-- listColor, listElementColor, listPrimaryColor, listElementTextColor, listElementHighlightTextColor
	---@param dropdown any
	---@param data table
	function NS:UpdateDropdownTheme(dropdown, data)
		local defaultTexture, highlightTexture, arrowTexture, arrowHighlightTexture, arrowEnableTexture, defaultColor, highlightColor, textSize, textSizeTitle, defaultTextColor, highlightTextColor, listTexture, listButtonTexture, listButtonCheckBackgroundTexture, listButtonCheckTexture, listIndexBackgroundTexture, listIndexNextButtonTexture, listIndexPreviousButtonTexture, listColor, listElementColor, listPrimaryColor, listElementTextColor, listElementHighlightTextColor =
			data.defaultTexture, data.highlightTexture, data.arrowTexture, data.arrowHighlightTexture, data.arrowEnableTexture, data.defaultColor, data.highlightColor, data.textSize, data.textSizeTitle, data.defaultTextColor, data.highlightTextColor, data.listTexture, data.listButtonTexture, data.listButtonCheckBackgroundTexture, data.listButtonCheckTexture, data.listIndexBackgroundTexture, data.listIndexNextButtonTexture, data.listIndexPreviousButtonTexture, data.listColor, data.listElementColor, data.listPrimaryColor, data.listElementTextColor, data.listElementHighlightTextColor

		--------------------------------

		if defaultTexture then dropdown._CustomDefaultTexture = defaultTexture end
		if highlightTexture then dropdown._CustomHighlightTexture = highlightTexture end
		if arrowTexture then dropdown._CustomArrowTexture = arrowTexture end
		if arrowHighlightTexture then dropdown._CustomArrowHighlightTexture = arrowHighlightTexture end
		if arrowEnableTexture then dropdown._CustomArrowEnableTexture = arrowEnableTexture end
		if defaultColor then dropdown._CustomDefaultColor = defaultColor end
		if highlightColor then dropdown._CustomHighlightColor = highlightColor end
		if textSize then dropdown._CustomTextSize = textSize end
		if textSizeTitle then dropdown._CustomTextSizeTitle = textSizeTitle end
		if defaultTextColor then dropdown._CustomDefaultTextColor = defaultTextColor end
		if highlightTextColor then dropdown._CustomHighlightTextColor = highlightTextColor end
		if listTexture then dropdown._CustomListTexture = listTexture end
		if listButtonTexture then dropdown._CustomListButtonTexture = listButtonTexture end
		if listButtonCheckBackgroundTexture then dropdown._CustomListButtonCheckBackgroundTexture = listButtonCheckBackgroundTexture end
		if listButtonCheckTexture then dropdown._CustomListButtonCheckTexture = listButtonCheckTexture end
		if listIndexBackgroundTexture then dropdown._CustomListIndexBackgroundTexture = listIndexBackgroundTexture end
		if listIndexNextButtonTexture then dropdown._CustomListIndexNextButtonTexture = listIndexNextButtonTexture end
		if listIndexPreviousButtonTexture then dropdown._CustomListIndexPreviousButtonTexture = listIndexPreviousButtonTexture end
		if listColor then dropdown._CustomListColor = listColor end
		if listElementColor then dropdown._CustomListElementColor = listElementColor end
		if listPrimaryColor then dropdown._CustomListPrimaryColor = listPrimaryColor end
		if listElementTextColor then dropdown._CustomListElementTextColor = listElementTextColor end
		if listElementHighlightTextColor then dropdown._CustomListElementHighlightTextColor = listElementHighlightTextColor end
	end
end
