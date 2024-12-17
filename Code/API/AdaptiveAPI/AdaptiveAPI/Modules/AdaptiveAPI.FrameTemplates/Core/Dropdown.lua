local addonName, addon = ...
local NS = AdaptiveAPI.FrameTemplates

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
	-- textSize, defaultTextColor, highlightTextColor, listTexture,
	-- listButtonTexture, listButtonCheckTexture,
	-- listButtonTextColor, listButtonHighlightTextColor, defaultListColor,
	-- defaultListButtonColor
	---@param mainParent any
	---@param parent any
	---@param frameStrata string
	---@param data table
	---@param name? string
	function NS:CreateDropdown(mainParent, parent, frameStrata, data, name)
		local FrameLevel = parent:GetFrameLevel()
		local Padding = 10

		--------------------------------

		local valuesFunc, openListFunc, closeListFunc, autoCloseList,
		getFunc, setFunc, theme, defaultTexture, highlightTexture, arrowTexture,
		arrowHighlightTexture, arrowEnableTexture, defaultColor, highlightColor,
		textSize, defaultTextColor, highlightTextColor, listTexture,
		listButtonTexture, listButtonCheckTexture,
		listButtonTextColor, listButtonHighlightTextColor, defaultListColor,
		defaultListButtonColor = data.valuesFunc, data.openListFunc, data.closeListFunc, data.autoCloseList,
			data.getFunc, data.setFunc, data.theme, data.defaultTexture, data.highlightTexture, data.arrowTexture,
			data.arrowHighlightTexture, data.arrowEnableTexture, data.defaultColor, data.highlightColor,
			data.textSize, data.defaultTextColor, data.highlightTextColor, data.listTexture,
			data.listButtonTexture, data.listButtonCheckTexture,
			data.listButtonTextColor, data.listButtonHighlightTextColor, data.defaultListColor,
			data.defaultListButtonColor

		--------------------------------

		local ValueTable = valuesFunc()

		--------------------------------

		local Frame = CreateFrame("Frame", name or nil, parent)
		Frame:SetFrameStrata(frameStrata)
		Frame:SetFrameLevel(FrameLevel + 1)

		Frame.Elements = {}
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
		Frame._ListButtonCheckTexture = nil
		Frame._ListButtonTextColor = nil
		Frame._ListButtonHighlightTextColor = nil
		Frame._DefaultListColor = nil
		Frame._DefaultListButtonColor = nil

		Frame._CustomDefaultTexture = defaultTexture
		Frame._CustomHighlightTexture = highlightTexture
		Frame._CustomArrowTexture = arrowTexture
		Frame._CustomArrowHighlightTexture = arrowHighlightTexture
		Frame._CustomArrowEnableTexture = arrowEnableTexture
		Frame._CustomDefaultColor = defaultColor
		Frame._CustomHighlightColor = highlightColor
		Frame._CustomTextSize = textSize
		Frame._CustomDefaultTextColor = defaultTextColor
		Frame._CustomHighlightTextColor = highlightTextColor
		Frame._CustomListTexture = listTexture
		Frame._CustomListButtonTexture = listButtonTexture
		Frame._CustomListButtonCheckTexture = listButtonCheckTexture
		Frame._CustomListButtonTextColor = listButtonTextColor
		Frame._CustomListButtonHighlightTextColor = listButtonHighlightTextColor
		Frame._CustomDefaultListColor = defaultListColor
		Frame._CustomDefaultListButtonColor = defaultListButtonColor

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
			if (theme and theme == 2) or (theme == nil and AdaptiveAPI.NativeAPI:GetDarkTheme()) then
				Frame._DefaultTexture = Frame._CustomDefaultTexture or AdaptiveAPI.PATH .. "Elements/dropdown-background.png"
				Frame._HighlightTexture = Frame._CustomHighlightTexture or AdaptiveAPI.PATH .. "Elements/dropdown-background-highlighted.png"
				Frame._ArrowTexture = Frame._CustomArrowTexture or AdaptiveAPI.PATH .. "Elements/dropdown-arrow-dark-mode.png"
				Frame._ArrowHighlightTexture = Frame._CustomArrowHighlightTexture or AdaptiveAPI.PATH .. "Elements/dropdown-arrow-dark-mode.png"
				Frame._ArrowEnableTexture = Frame._CustomArrowEnableTexture or AdaptiveAPI.PATH .. "Elements/dropdown-arrow-highlighted-dark-mode.png"
				Frame._DefaultColor = Frame._CustomDefaultColor or { r = 1, g = 1, b = 1, a = .75 }
				Frame._HighlightColor = Frame._CustomHighlightColor or { r = 1, g = 1, b = 1, a = .5 }
				Frame._TextSize = Frame._CustomTextSize or 15
				Frame._DefaultTextColor = Frame._CustomDefaultTextColor or { r = 1, g = 1, b = 1, a = 1 }
				Frame._HighlightTextColor = Frame._CustomHighlightTextColor or { r = 1, g = 1, b = 1, a = 1 }
				Frame._ListTexture = Frame._CustomListTexture or AdaptiveAPI.PATH .. "Elements/dropdown-list-background-dark-mode.png"
				Frame._ListButtonTexture = Frame._CustomListButtonTexture or AdaptiveAPI.PATH .. "Elements/dropdown-list-button-background.png"
				Frame._ListButtonCheckTexture = Frame._CustomListButtonCheckTexture or AdaptiveAPI.PATH .. "Elements/dropdown-list-button-check-dark-mode.png"
				Frame._ListButtonTextColor = Frame._CustomListButtonTextColor or { r = 1, g = 1, b = 1, a = 1 }
				Frame._ListButtonHighlightTextColor = Frame._CustomListButtonHighlightTextColor or { r = 1, g = 1, b = 1, a = 1 }
				Frame._DefaultListColor = Frame._CustomDefaultListColor or { r = 1, g = 1, b = 1, a = 1 }
				Frame._DefaultListButtonColor = Frame._CustomDefaultListButtonColor or { r = 1, g = 1, b = 1, a = .125 }
			elseif (theme and theme == 1) or (theme == nil and not AdaptiveAPI.NativeAPI:GetDarkTheme()) then
				Frame._DefaultTexture = Frame._CustomDefaultTexture or AdaptiveAPI.PATH .. "Elements/dropdown-background.png"
				Frame._HighlightTexture = Frame._CustomHighlightTexture or AdaptiveAPI.PATH .. "Elements/dropdown-background-highlighted.png"
				Frame._ArrowTexture = Frame._CustomArrowTexture or AdaptiveAPI.PATH .. "Elements/dropdown-arrow-light-mode.png"
				Frame._ArrowHighlightTexture = Frame._CustomArrowHighlightTexture or AdaptiveAPI.PATH .. "Elements/dropdown-arrow-dark-mode.png"
				Frame._ArrowEnableTexture = Frame._CustomArrowEnableTexture or AdaptiveAPI.PATH .. "Elements/dropdown-arrow-highlighted-dark-mode.png"
				Frame._DefaultColor = Frame._CustomDefaultColor or { r = .1, g = .1, b = .1, a = 1 }
				Frame._HighlightColor = Frame._CustomHighlightColor or { r = .1, g = .1, b = .1, a = .75 }
				Frame._TextSize = Frame._CustomTextSize or 15
				Frame._DefaultTextColor = Frame._CustomDefaultTextColor or { r = .1, g = .1, b = .1, a = 1 }
				Frame._HighlightTextColor = Frame._CustomHighlightTextColor or { r = 1, g = 1, b = 1, a = 1 }
				Frame._ListTexture = Frame._CustomListTexture or AdaptiveAPI.PATH .. "Elements/dropdown-list-background-light-mode.png"
				Frame._ListButtonTexture = Frame._CustomListButtonTexture or AdaptiveAPI.PATH .. "Elements/dropdown-list-button-background.png"
				Frame._ListButtonCheckTexture = Frame._CustomListButtonCheckTexture or AdaptiveAPI.PATH .. "Elements/dropdown-list-button-check-light-mode.png"
				Frame._ListButtonTextColor = Frame._CustomListButtonTextColor or { r = .1, g = .1, b = .1, a = 1 }
				Frame._ListButtonHighlightTextColor = Frame._CustomListButtonHighlightTextColor or { r = .1, g = .1, b = .1, a = 1 }
				Frame._DefaultListColor = Frame._CustomDefaultListColor or { r = 1, g = 1, b = 1, a = 1 }
				Frame._DefaultListButtonColor = Frame._CustomDefaultListButtonColor or { r = .1, g = .1, b = .1, a = .125 }
			end
		end

		AdaptiveAPI:RegisterThemeUpdateWithNativeAPI(UpdateTheme, 4)

		--------------------------------

		do -- FUNCTIONS
			Frame.SetValue = function(element, value)
				setFunc(element, value)
				Frame.UpdateDropdown()
			end

			Frame.ShowList = function()
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

			Frame.HideList = function()
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

			Frame.ForceHideList = function()
				Frame.List:Hide()
				Frame.Leave()
			end

			Frame.ToggleListVisibility = function()
				AdaptiveAPI:SetVisibility(Frame.List, not Frame.List:IsVisible())
				Frame.List.ScrollFrame:SetVerticalScroll(0)

				--------------------------------

				if Frame.List:IsVisible() then
					Frame.ShowList()
				else
					Frame.HideList()
				end
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
				Frame.ToggleListVisibility()

				--------------------------------

				local MouseUpCallbacks = Frame.MouseDownCallbacks

				for callback = 1, #MouseUpCallbacks do
					MouseUpCallbacks[callback]()
				end
			end

			Frame:SetScript("OnEnter", function()
				Frame.Enter()
			end)

			Frame:SetScript("OnLeave", function()
				Frame.Leave()
			end)

			Frame:SetScript("OnMouseDown", function()
				Frame.MouseDown()
			end)

			Frame:SetScript("OnMouseUp", function()
				Frame.MouseUp()
			end)
		end

		do -- ELEMENTS
			local function Dropdown()
				local function Background()
					Frame.Background, Frame.BackgroundTexture = AdaptiveAPI.FrameTemplates:CreateNineSlice(Frame, frameStrata, Frame._DefaultTexture, 25, 1, "$parent.Background")
					Frame.Background:SetSize(Frame:GetSize())
					Frame.Background:SetPoint("CENTER", Frame)
					Frame.Background:SetFrameLevel(FrameLevel)

					AdaptiveAPI:RegisterThemeUpdateWithNativeAPI(function()
						Frame.BackgroundTexture:SetVertexColor(Frame._DefaultColor.r, Frame._DefaultColor.g, Frame._DefaultColor.b, Frame._DefaultColor.a or 1)

						Frame.BackgroundTexture:SetTexture(Frame._DefaultTexture)
					end, 5)
				end

				local function Arrow()
					Frame.Arrow, Frame.ArrowTexture = AdaptiveAPI.FrameTemplates:CreateTexture(Frame, frameStrata, Frame._ArrowTexture, "$parent.Arrow")
					Frame.Arrow:SetSize(Frame:GetHeight(), Frame:GetHeight())
					Frame.Arrow:SetPoint("RIGHT", Frame)
					Frame.Arrow:SetFrameLevel(FrameLevel + 1)

					AdaptiveAPI:RegisterThemeUpdateWithNativeAPI(function()
						Frame.ArrowTexture:SetTexture(Frame._ArrowTexture)
					end, 5)
				end

				local function Text()
					Frame.Text = AdaptiveAPI.FrameTemplates:CreateText(Frame, Frame._DefaultTextColor, Frame._TextSize, "LEFT", "MIDDLE", AdaptiveAPI.Fonts.Content_Light, "$parent.Label", false)
					Frame.Text:SetSize(Frame:GetWidth() - Padding, Frame:GetHeight() - Padding)
					Frame.Text:SetPoint("LEFT", Frame, Padding, 0)

					AdaptiveAPI:RegisterThemeUpdateWithNativeAPI(function()
						Frame.Text:SetTextColor(Frame._DefaultTextColor.r, Frame._DefaultTextColor.g, Frame._DefaultTextColor.b, Frame._DefaultTextColor.a)
					end, 5)
				end

				--------------------------------

				Background()
				Arrow()
				Text()
			end

			local function List()
				local ElementHeight = 35

				--------------------------------

				Frame.List = CreateFrame("Frame", "$parent.List", InteractionFrame)
				Frame.List:SetWidth(Frame:GetWidth())
				Frame.List:SetPoint("TOP", Frame, 0, -Frame:GetHeight() - Padding)
				Frame.List:SetFrameStrata("FULLSCREEN_DIALOG")
				Frame.List:SetFrameLevel(50)
				Frame.List:Hide()

				--------------------------------

				local function Mouse()
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

				local function ScrollFrame()
					Frame.List.ScrollFrame, Frame.List.ScrollChildFrame = AdaptiveAPI.FrameTemplates:CreateScrollFrame(Frame.List)
					Frame.List.ScrollFrame:SetSize(Frame.List:GetWidth() - 10, Frame.List:GetHeight())
					Frame.List.ScrollFrame:SetPoint("LEFT", Frame.List)
					Frame.List.ScrollFrame:SetFrameLevel(51)

					--------------------------------

					local function Scrollbar()
						Frame.List.ScrollFrame.ScrollBar:Hide()
						Frame.List.ScrollFrame.Scrollbar = AdaptiveAPI.FrameTemplates:CreateScrollbar(Frame.List.ScrollFrame, "FULLSCREEN_DIALOG", {
							scrollFrame = Frame.List.ScrollFrame,
							scrollChildFrame = Frame.List.ScrollChildFrame,
							sizeX = 5,
							sizeY = 250,
							theme = nil,
							isHorizontal = false,
						}, "$parent.Scrollbar")
						Frame.List.ScrollFrame.Scrollbar:SetPoint("RIGHT", Frame.List, -2.5, 0)
						Frame.List.ScrollFrame.Scrollbar:SetFrameLevel(52)
					end

					--------------------------------

					Scrollbar()
				end

				local function Background()
					Frame.List.Background, Frame.List.BackgroundTexture = AdaptiveAPI.FrameTemplates:CreateNineSlice(Frame.List, frameStrata, Frame._ListTexture, 25, 1, "$parent.Background")
					Frame.List.Background:SetSize(Frame.List:GetWidth() + 25, Frame.List:GetHeight() + 25)
					Frame.List.Background:SetPoint("CENTER", Frame.List)
					Frame.List.Background:SetFrameLevel(49)

					AdaptiveAPI:RegisterThemeUpdateWithNativeAPI(function()
						Frame.List.BackgroundTexture:SetVertexColor(Frame._DefaultListColor.r, Frame._DefaultListColor.g, Frame._DefaultListColor.b, Frame._DefaultListColor.a or 1)

						Frame.List.BackgroundTexture:SetTexture(Frame._ListTexture)
					end, 5)
				end

				local function Elements()
					local function CreateElement(parent, index)
						local CurrentValue = ValueTable[index]

						--------------------------------

						local Element = CreateFrame("Frame", nil, parent)
						Element:SetSize(parent:GetWidth(), ElementHeight)
						Element:SetPoint("CENTER", parent)
						Element:SetFrameLevel(51)

						--------------------------------

						Element.Index = index

						--------------------------------

						local function UpdateSelectionButton()
							if Frame.Value == Element.Index then
								Element.Icon:Show()
								Element.Text:SetTextColor(Frame._ListButtonHighlightTextColor.r, Frame._ListButtonHighlightTextColor.g, Frame._ListButtonHighlightTextColor.b, Frame._ListButtonHighlightTextColor.a or 1)
							else
								Element.Icon:Hide()
								Element.Text:SetTextColor(Frame._ListButtonTextColor.r, Frame._ListButtonTextColor.g, Frame._ListButtonTextColor.b, Frame._ListButtonTextColor.a or 1)
							end

							--------------------------------

							Element.Text:SetText(CurrentValue)
						end

						Element.UpdateSize = function()
							Element:SetSize(parent:GetWidth(), ElementHeight)
							Element.Background:SetSize(Element:GetSize())
							Element.Icon:SetSize(Element:GetHeight(), Element:GetHeight())
							Element.Text:SetSize(Element:GetWidth() - Element.Icon:GetWidth() - Padding, Element:GetHeight())
							Element.Text:SetPoint("LEFT", Element.Icon:GetWidth() + Padding, 0)
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

							UpdateSelectionButton()
						end)

						--------------------------------

						local function Background()
							Element.Background, Element.BackgroundTexture = AdaptiveAPI.FrameTemplates:CreateNineSlice(Element, Element:GetFrameStrata(), Frame._ListButtonTexture, 25, 1, "$parent.Background")
							Element.Background:SetSize(Element:GetSize())
							Element.Background:SetPoint("CENTER", Element)
							Element.Background:SetFrameLevel(50)
							Element.Background:SetAlpha(0)

							--------------------------------

							AdaptiveAPI:RegisterThemeUpdateWithNativeAPI(function()
								Element.BackgroundTexture:SetVertexColor(Frame._DefaultListButtonColor.r, Frame._DefaultListButtonColor.g, Frame._DefaultListButtonColor.b, Frame._DefaultListButtonColor.a)
							end, 5)
						end

						local function Icon()
							Element.Icon, Element.IconTexture = AdaptiveAPI.FrameTemplates:CreateTexture(Element, Element:GetFrameStrata(), Frame._ListButtonCheckTexture, "$parent.Icon")
							Element.Icon:SetSize(Element:GetHeight(), Element:GetHeight())
							Element.Icon:SetPoint("LEFT", Element)
							Element.Icon:SetFrameLevel(51)

							--------------------------------

							AdaptiveAPI:RegisterThemeUpdateWithNativeAPI(function()
								Element.IconTexture:SetTexture(Frame._ListButtonCheckTexture)
							end, 5)
						end

						local function Text()
							Element.Text = AdaptiveAPI.FrameTemplates:CreateText(Element, Frame._ListButtonTextColor, Frame._TextSize, "LEFT", "MIDDLE", AdaptiveAPI.Fonts.Content_Light, "$parent.Text", false)
							Element.Text:SetSize(Element:GetWidth() - Element.Icon:GetWidth() - Padding, Element:GetHeight())
							Element.Text:SetPoint("LEFT", Element.Icon:GetWidth() + Padding, 0)

							--------------------------------

							AdaptiveAPI:RegisterThemeUpdateWithNativeAPI(function()
								Element.Text:SetTextColor(Frame._ListButtonTextColor.r, Frame._ListButtonTextColor.g, Frame._ListButtonTextColor.b, Frame._ListButtonTextColor.a)
							end, 5)
						end

						--------------------------------

						Background()
						Icon()
						Text()

						--------------------------------

						Element.UpdateSize()

						--------------------------------

						return Element
					end

					--------------------------------

					local Elements = {}
					for i = 1, #ValueTable do
						local Element = CreateElement(Frame.List.ScrollChildFrame, i)

						--------------------------------

						Element:SetPoint("TOP", Frame.List.ScrollChildFrame, 0, -(Element:GetHeight()) * (i - 1))

						--------------------------------

						table.insert(Elements, Element)
					end
					Frame.Elements = Elements
				end

				--------------------------------

				local function UpdateVisibility()
					Frame.List:SetShown(Frame:IsVisible())
				end

				local function UpdateSize()
					Frame.List:SetWidth(Frame:GetWidth())
					Frame.List:SetHeight(math.min(250, ElementHeight * #Frame.Elements))
					Frame.List:SetPoint("TOP", Frame, 0, -Frame:GetHeight() - Padding)

					--------------------------------

					Frame.List.Background:SetSize(Frame.List:GetWidth() + 25, Frame.List:GetHeight() + 25)
					Frame.List.ScrollFrame:SetSize(Frame.List:GetWidth() - 10, Frame.List:GetHeight())
					Frame.List.ScrollChildFrame:SetHeight(ElementHeight * #Frame.Elements)

					--------------------------------

					for i = 1, #Frame.Elements do
						Frame.Elements[i]:UpdateSize()
					end
				end

				hooksecurefunc(mainParent, "Hide", function()
					Frame.ForceHideList()
				end)
				hooksecurefunc(Frame, "Show", function()
					UpdateVisibility(); UpdateSize()
				end)
				hooksecurefunc(Frame, "Hide", function()
					UpdateVisibility(); UpdateSize()
				end)
				hooksecurefunc(Frame.List, "Show", UpdateSize)

				--------------------------------

				Mouse()
				ScrollFrame()
				Background()
				Elements()
			end

			--------------------------------

			Dropdown()
			List()
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
	-- textSize, defaultTextColor, highlightTextColor, listTexture,
	-- listButtonTexture, listButtonCheckTexture,
	-- listButtonTextColor, listButtonHighlightTextColor, defaultListColor,
	-- defaultListButtonColor
	---@param dropdown any
	---@param data table
	function NS:UpdateDropdownTheme(dropdown, data)
		local defaultTexture, highlightTexture, arrowTexture,
		arrowHighlightTexture, arrowEnableTexture, defaultColor, highlightColor,
		textSize, defaultTextColor, highlightTextColor, listTexture,
		listButtonTexture, listButtonCheckTexture,
		listButtonTextColor, listButtonHighlightTextColor, defaultListColor,
		defaultListButtonColor =
			data.defaultTexture, data.highlightTexture, data.arrowTexture,
			data.arrowHighlightTexture, data.arrowEnableTexture, data.defaultColor, data.highlightColor,
			data.textSize, data.defaultTextColor, data.highlightTextColor, data.listTexture,
			data.listButtonTexture, data.listButtonCheckTexture,
			data.listButtonTextColor, data.listButtonHighlightTextColor, data.defaultListColor,
			data.defaultListButtonColor

		--------------------------------

		if defaultTexture then dropdown._CustomDefaultTexture = defaultTexture end
		if highlightTexture then dropdown._CustomHighlightTexture = highlightTexture end
		if arrowTexture then dropdown._CustomArrowTexture = arrowTexture end
		if arrowHighlightTexture then dropdown._CustomArrowHighlightTexture = arrowHighlightTexture end
		if arrowEnableTexture then dropdown._CustomArrowEnableTexture = arrowEnableTexture end
		if defaultColor then dropdown._CustomDefaultColor = defaultColor end
		if highlightColor then dropdown._CustomHighlightColor = highlightColor end
		if textSize then dropdown._CustomTextSize = textSize end
		if defaultTextColor then dropdown._CustomDefaultTextColor = defaultTextColor end
		if highlightTextColor then dropdown._CustomHighlightTextColor = highlightTextColor end
		if listTexture then dropdown._CustomListTexture = listTexture end
		if listButtonTexture then dropdown._CustomListButtonTexture = listButtonTexture end
		if listButtonCheckTexture then dropdown._CustomListButtonCheckTexture = listButtonCheckTexture end
		if listButtonTextColor then dropdown._CustomListButtonTextColor = listButtonTextColor end
		if listButtonHighlightTextColor then dropdown._CustomListButtonHighlightTextColor = listButtonHighlightTextColor end
		if defaultListColor then dropdown._CustomDefaultListColor = defaultListColor end
		if defaultListButtonColor then dropdown._CustomDefaultListButtonColor = defaultListButtonColor end
	end
end
