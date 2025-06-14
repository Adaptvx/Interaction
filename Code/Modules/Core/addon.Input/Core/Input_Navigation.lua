-- [Input_Navigation.lua] is used to link module elements
-- to use the [Input_Script.lua] system.

---@class addon
local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local PrefabRegistry = addon.PrefabRegistry
local L = addon.Locales
local NS = addon.Input; addon.Input = NS

--------------------------------

NS.Navigation = {}

--------------------------------

function NS.Navigation:Load()
	--------------------------------
	-- REFERENCES
	--------------------------------

	local Callback = NS.Script; NS.Script = Callback

	--------------------------------
	-- NAVIGATION
	--------------------------------

	do
		do -- QUEST
			if (NS.Variables.IsController or NS.Variables.SimulateController) then
				CallbackRegistry:Add("QUEST_DATA_LOADED", function()
					local Frame = InteractionFrame.QuestFrame
					local Buttons = Frame.REF_FOOTER_CONTENT
					local Storyline = Frame.REF_HEADER_STORYLINE.Storyline
					local ScrollFrame = Frame.REF_MAIN_SCROLLFRAME
					local ScrollChildFrame = Frame.REF_MAIN_SCROLLCHILDFRAME
					local Elements = addon.Interaction.Quest.Variables.Elements

					local DefaultFrame
					local ChildrenFrames

					--------------------------------

					ChildrenFrames = {
						Buttons.AcceptButton,
						Buttons.ContinueButton,
						Buttons.CompleteButton,
						Buttons.DeclineButton,
						Buttons.GoodbyeButton,
					}

					for i = 1, #Elements do
						table.insert(ChildrenFrames, Elements[i])
					end

					--------------------------------

					if #Elements > 0 then
						local FirstFrameVisible

						for element = 1, #Elements do
							if Elements[element]:IsVisible() then
								FirstFrameVisible = Elements[element]
								break
							end
						end

						DefaultFrame = FirstFrameVisible
					else
						if Buttons.AcceptButton:IsVisible() then
							DefaultFrame = Buttons.AcceptButton
						elseif Buttons.ContinueButton:IsVisible() then
							DefaultFrame = Buttons.ContinueButton
						elseif Buttons.CompleteButton:IsVisible() then
							DefaultFrame = Buttons.CompleteButton
						end
					end

					--------------------------------

					do -- STORYLINE
						Callback:SetFrameRelatives({
							["frame"] = Storyline,
							["relativeBottom"] = Elements[1],
						})
					end

					do -- CONTENT
						for element = 1, #Elements do
							-- FIRST ELEMENT
							if element == 1 then
								Callback:SetFrameRelatives({
									["frame"] = Elements[element],
									["relativeTop"] = Storyline,
									["relativeBottom"] = Elements[element + 1],
									["scrollFrame"] = ScrollFrame,
									["scrollChildFrame"] = ScrollChildFrame,
									["preventManualScrolling"] = true,
									["axis"] = "y",
								})
							end

							-- LAST ELEMENT
							if element == #Elements then
								Callback:SetFrameRelatives({
									["frame"] = Elements[element],
									["relativeTop"] = Elements[element - 1],
									["scrollFrame"] = ScrollFrame,
									["scrollChildFrame"] = ScrollChildFrame,
									["preventManualScrolling"] = true,
									["axis"] = "y",
								})
							end

							-- CONTENT ELEMENTS
							if element > 1 and element < #Elements then
								Callback:SetFrameRelatives({
									["frame"] = Elements[element],
									["relativeTop"] = Elements[element - 1],
									["relativeBottom"] = Elements[element + 1],
									["scrollFrame"] = ScrollFrame,
									["scrollChildFrame"] = ScrollChildFrame,
									["preventManualScrolling"] = true,
									["axis"] = "y",
								})
							end
						end
					end

					--------------------------------

					Callback:StartNavigation("QUESTFRAME", DefaultFrame, ChildrenFrames)
				end, 0)

				CallbackRegistry:Add("STOP_QUEST", function()
					if Callback.CurrentNavigationSession == "QUESTFRAME" then
						Callback:StopNavigation()
					end
				end, 0)
			end
		end

		do -- GOSSIP
			if (NS.Variables.IsController or NS.Variables.SimulateController) then
				CallbackRegistry:Add("UPDATE_GOSSIP_READY", function()
					local Frame = InteractionFrame.GossipFrame
					local Buttons = Frame:GetButtons()
					local GoodbyeButton = Frame.REF_FOOTER_CONTENT_GOODBYE

					local DefaultFrame
					local ChildrenFrames

					--------------------------------

					ChildrenFrames = {
						GoodbyeButton,
					}

					for i = 1, #Buttons do
						table.insert(ChildrenFrames, Buttons[i])
					end

					--------------------------------

					if #Buttons > 0 then
						DefaultFrame = Buttons[1]
					else
						DefaultFrame = GoodbyeButton
					end

					--------------------------------

					do -- CONTENT
						for button = 1, #Buttons do
							-- FIRST BUTTON
							if button == 1 then
								Callback:SetFrameRelatives({
									["frame"] = Buttons[button],
									["relativeBottom"] = Buttons[button + 1],
								})
							end

							-- LAST BUTTON
							if button == #Buttons then
								Callback:SetFrameRelatives({
									["frame"] = Buttons[button],
									["relativeTop"] = Buttons[button - 1],
								})
							end

							-- CONTENT BUTTONS
							if button > 1 and button < #Buttons then
								Callback:SetFrameRelatives({
									["frame"] = Buttons[button],
									["relativeTop"] = Buttons[button - 1],
									["relativeBottom"] = Buttons[button + 1],
								})
							end
						end
					end

					--------------------------------

					Callback:StartNavigation("GOSSIP", DefaultFrame, ChildrenFrames)
				end, 0)

				CallbackRegistry:Add("STOP_GOSSIP", function()
					if Callback.CurrentNavigationSession == "GOSSIP" then
						Callback:StopNavigation()
					end
				end, 0)
			end
		end

		do -- READABLE
			if (NS.Variables.IsController or NS.Variables.SimulateController) then
				CallbackRegistry:Add("START_READABLE", function()
					local Frame = InteractionReadableUIFrame
					local DefaultFrame = Frame.ReadableUIFrame.NavigationFrame.PreviousPage
					local ChildrenFrames = {
						Frame.CloseButton,
						Frame.TTSButton,
						Frame.ReadableUIFrame.NavigationFrame.PreviousPage,
						Frame.ReadableUIFrame.NavigationFrame.NextPage,
						Frame.ReadableUIFrame.BookFrame.Content.Left,
						Frame.ReadableUIFrame.BookFrame.Content.Right,
					}

					--------------------------------

					do -- MENU BUTTONS
						if addon.Database.DB_GLOBAL.profile.INT_UIDIRECTION == 1 then
							-- CLOSE BUTTON
							Callback:SetFrameRelatives({
								["frame"] = Frame.CloseButton,
								["relativeRight"] = Frame.TTSButton,
								["relativeBottom"] = Frame.ReadableUIFrame.NavigationFrame.PreviousPage,
							})

							-- TTS BUTTON
							Callback:SetFrameRelatives({
								["frame"] = Frame.TTSButton,
								["relativeLeft"] = Frame.CloseButton,
								["relativeBottom"] = Frame.ReadableUIFrame.NavigationFrame.PreviousPage,
							})
						else
							-- TTS BUTTON
							Callback:SetFrameRelatives({
								["frame"] = Frame.TTSButton,
								["relativeRight"] = Frame.CloseButton,
								["relativeBottom"] = Frame.ReadableUIFrame.NavigationFrame.PreviousPage,
							})

							-- CLOSE BUTTON
							Callback:SetFrameRelatives({
								["frame"] = Frame.CloseButton,
								["relativeLeft"] = Frame.TTSButton,
								["relativeBottom"] = Frame.ReadableUIFrame.NavigationFrame.PreviousPage,
							})
						end
					end

					do -- CONTENT
						-- PREVIOUS PAGE
						Callback:SetFrameRelatives({
							["frame"] = Frame.ReadableUIFrame.NavigationFrame.PreviousPage,
							["relativeRight"] = Frame.ReadableUIFrame.BookFrame.Content.Left,
							["relativeTop"] = Frame.CloseButton,
						})

						-- LEFT SCROLL FRAME
						Callback:SetFrameRelatives({
							["frame"] = Frame.ReadableUIFrame.BookFrame.Content.Left,
							["relativeLeft"] = Frame.ReadableUIFrame.NavigationFrame.PreviousPage,
							["relativeRight"] = Frame.ReadableUIFrame.BookFrame.Content.Right,
							["relativeTop"] = Frame.CloseButton,
							["scrollFrame"] = Frame.ReadableUIFrame.BookFrame.Content.Left,
							["scrollChildFrame"] = Frame.ReadableUIFrame.BookFrame.Content.LeftScrollChild,
							["axis"] = "y",
						})

						-- RIGHT SCROLL FRAME
						Callback:SetFrameRelatives({
							["frame"] = Frame.ReadableUIFrame.BookFrame.Content.Right,
							["relativeLeft"] = Frame.ReadableUIFrame.BookFrame.Content.Left,
							["relativeRight"] = Frame.ReadableUIFrame.NavigationFrame.NextPage,
							["relativeTop"] = Frame.CloseButton,
							["scrollFrame"] = Frame.ReadableUIFrame.BookFrame.Content.Right,
							["scrollChildFrame"] = Frame.ReadableUIFrame.BookFrame.Content.RightScrollChild,
							["axis"] = "y",
						})

						-- NEXT PAGE
						Callback:SetFrameRelatives({
							["frame"] = Frame.ReadableUIFrame.NavigationFrame.NextPage,
							["relativeLeft"] = Frame.ReadableUIFrame.BookFrame.Content.Right,
							["relativeTop"] = Frame.CloseButton,
						})
					end

					--------------------------------

					Callback:StartNavigation("READABLE", DefaultFrame, ChildrenFrames)
				end, 2)

				CallbackRegistry:Add("STOP_READABLE", function()
					if Callback.CurrentNavigationSession == "READABLE" then
						Callback:StopNavigation()
					end
				end, 0)

				CallbackRegistry:Add("START_LIBRARY", function()
					local Parent = InteractionReadableUIFrame
					local Frame = InteractionReadableUIFrame.LibraryUIFrame
					local DefaultFrame
					local ChildrenFrames

					local Buttons = addon.Readable.LibraryUI.Script:GetButtons()
					local Entries = addon.Readable.LibraryUI.Script:GetAllEntries()

					--------------------------------

					ChildrenFrames = {
						Parent.CloseButton,
						-- Parent.TTSButton,
						Frame.Content.Sidebar.Search,
						Frame.Content.Sidebar.Type_Letter,
						Frame.Content.Sidebar.Type_Book,
						Frame.Content.Sidebar.Type_Slate,
						Frame.Content.Sidebar.Type_InWorld,
						Frame.Content.Sidebar.Type_SlateInWorld,
					}

					for i = 1, #Buttons do
						table.insert(ChildrenFrames, Buttons[i])
						table.insert(ChildrenFrames, Buttons[i].Content.ButtonContainer.Button_Delete)
						table.insert(ChildrenFrames, Buttons[i].Content.ButtonContainer.Button_Open)
					end

					--------------------------------

					if #Entries > 0 then
						DefaultFrame = Buttons[1]
					else
						DefaultFrame = Frame.Content.Sidebar.Search
					end

					--------------------------------

					do -- MENU BUTTONS
						if addon.Database.DB_GLOBAL.profile.INT_UIDIRECTION == 1 then
							-- CLOSE BUTTON
							Callback:SetFrameRelatives({
								["frame"] = Parent.CloseButton,
								-- ["relativeRight"] = Parent.TTSButton,
								["relativeBottom"] = DefaultFrame,
							})

							-- TTS BUTTON
							-- InputCallback:SetFrameRelatives({
							-- 	["frame"] = Parent.TTSButton,
							-- 	["relativeLeft"] = Parent.CloseButton,
							-- 	["relativeBottom"] = DefaultFrame,
							-- })
						else
							-- TTS BUTTON
							-- InputCallback:SetFrameRelatives({
							-- 	["frame"] = Parent.TTSButton,
							-- 	["relativeRight"] = Parent.CloseButton,
							-- 	["relativeBottom"] = DefaultFrame,
							-- })

							-- CLOSE BUTTON
							Callback:SetFrameRelatives({
								["frame"] = Parent.CloseButton,
								-- ["relativeLeft"] = Parent.TTSButton,
								["relativeBottom"] = DefaultFrame,
							})
						end
					end

					do -- SIDEBAR
						-- TAB BUTTON (CHARACTER)
						Callback:SetFrameRelatives({
							["frame"] = Frame.Content.Sidebar.Tab.Buttons[1],
							["relativeRight"] = Frame.Content.Sidebar.Tab.Buttons[2],
							["relativeTop"] = Parent.CloseButton,
							["relativeBottom"] = Frame.Content.Sidebar.Search,
						})

						-- TAB BUTTON (WARBAND)
						Callback:SetFrameRelatives({
							["frame"] = Frame.Content.Sidebar.Tab.Buttons[2],
							["relativeLeft"] = Frame.Content.Sidebar.Tab.Buttons[1],
							["relativeRight"] = Buttons[1],
							["relativeTop"] = Parent.CloseButton,
							["relativeBottom"] = Frame.Content.Sidebar.Search,
						})

						-- SEARCH
						Callback:SetFrameRelatives({
							["frame"] = Frame.Content.Sidebar.Search,
							["relativeRight"] = Buttons[1],
							["relativeTop"] = Frame.Content.Sidebar.Tab.Buttons[1],
							["relativeBottom"] = Frame.Content.Sidebar.Type_Letter.Checkbox,
						})

						-- TYPE LETTER
						Callback:SetFrameRelatives({
							["frame"] = Frame.Content.Sidebar.Type_Letter.Checkbox,
							["relativeRight"] = Buttons[1],
							["relativeTop"] = Frame.Content.Sidebar.Search,
							["relativeBottom"] = Frame.Content.Sidebar.Type_Book.Checkbox,
						})

						-- TYPE BOOK
						Callback:SetFrameRelatives({
							["frame"] = Frame.Content.Sidebar.Type_Book.Checkbox,
							["relativeRight"] = Buttons[1],
							["relativeTop"] = Frame.Content.Sidebar.Type_Letter.Checkbox,
							["relativeBottom"] = Frame.Content.Sidebar.Type_Slate.Checkbox,
						})

						-- TYPE SLATE
						Callback:SetFrameRelatives({
							["frame"] = Frame.Content.Sidebar.Type_Slate.Checkbox,
							["relativeRight"] = Buttons[1],
							["relativeTop"] = Frame.Content.Sidebar.Type_Book.Checkbox,
							["relativeBottom"] = Frame.Content.Sidebar.Type_InWorld.Checkbox,
						})

						-- TYPE IN WORLD
						Callback:SetFrameRelatives({
							["frame"] = Frame.Content.Sidebar.Type_InWorld.Checkbox,
							["relativeRight"] = Buttons[1],
							["relativeTop"] = Frame.Content.Sidebar.Type_Slate.Checkbox,
							["relativeBottom"] = Frame.Content.Sidebar.Button_Export,
						})

						-- BUTTON EXPORT
						Callback:SetFrameRelatives({
							["frame"] = Frame.Content.Sidebar.Button_Export,
							["relativeRight"] = Buttons[1],
							["relativeTop"] = Frame.Content.Sidebar.Type_InWorld.Checkbox,
							["relativeBottom"] = Frame.Content.Sidebar.Button_Import,
						})

						-- BUTTON IMPORT
						Callback:SetFrameRelatives({
							["frame"] = Frame.Content.Sidebar.Button_Import,
							["relativeRight"] = Buttons[1],
							["relativeTop"] = Frame.Content.Sidebar.Button_Export,
						})
					end

					do -- CONTENT
						do -- BUTTONS
							for button = 1, #Buttons do
								-- FIRST BUTTON
								if button == 1 then
									-- BUTTON
									Callback:SetFrameRelatives({
										["frame"] = Buttons[button],
										["children"] = { Buttons[button].Content.ButtonContainer.Button_Delete, Buttons[button].Content.ButtonContainer.Button_Open },
										["relativeLeft"] = Frame.Content.Sidebar.Search,
										["relativeRight"] = Buttons[button].Content.ButtonContainer.Button_Delete,
										["relativeTop"] = Parent.CloseButton,
										["relativeBottom"] = Buttons[button + 1],
										["scrollFrame"] = Frame.Content.ContentFrame.ScrollFrame,
										["scrollChildFrame"] = Frame.Content.ContentFrame.ScrollChildFrame,
										["preventManualScrolling"] = true,
										["axis"] = "y",
									})

									-- BUTTON DELETE
									Callback:SetFrameRelatives({
										["frame"] = Buttons[button].Content.ButtonContainer.Button_Delete,
										["parent"] = Buttons[button],
										["relativeLeft"] = Buttons[button],
										["relativeRight"] = Buttons[button].Content.ButtonContainer.Button_Open,
										["relativeTop"] = Parent.CloseButton,
										["relativeBottom"] = Buttons[button + 1]
									})

									-- BUTTON OPEN
									Callback:SetFrameRelatives({
										["frame"] = Buttons[button].Content.ButtonContainer.Button_Open,
										["parent"] = Buttons[button],
										["relativeLeft"] = Buttons[button].Content.ButtonContainer.Button_Delete,
										["relativeTop"] = Parent.CloseButton,
										["relativeBottom"] = Buttons[button + 1]
									})
								end

								-- LAST BUTTON
								if button == #Buttons then
									-- BUTTON
									Callback:SetFrameRelatives({
										["frame"] = Buttons[button],
										["children"] = { Buttons[button].Content.ButtonContainer.Button_Delete, Buttons[button].Content.ButtonContainer.Button_Open },
										["relativeLeft"] = Frame.Content.Sidebar.Search,
										["relativeRight"] = Buttons[button].Content.ButtonContainer.Button_Delete,
										["relativeTop"] = Buttons[button - 1],
										["relativeBottom"] = Frame.Content.ContentFrame.Index.Content.Button_PreviousPage,
										["scrollFrame"] = Frame.Content.ContentFrame.ScrollFrame,
										["scrollChildFrame"] = Frame.Content.ContentFrame.ScrollChildFrame,
										["preventManualScrolling"] = true,
										["axis"] = "y",
									})

									-- BUTTON DELETE
									Callback:SetFrameRelatives({
										["frame"] = Buttons[button].Content.ButtonContainer.Button_Delete,
										["parent"] = Buttons[button],
										["relativeLeft"] = Buttons[button],
										["relativeRight"] = Buttons[button].Content.ButtonContainer.Button_Open,
										["relativeTop"] = Buttons[button - 1],
										["relativeBottom"] = Frame.Content.ContentFrame.Index.Content.Button_PreviousPage
									})

									-- BUTTON OPEN
									Callback:SetFrameRelatives({
										["frame"] = Buttons[button].Content.ButtonContainer.Button_Open,
										["parent"] = Buttons[button],
										["relativeLeft"] = Buttons[button].Content.ButtonContainer.Button_Delete,
										["relativeTop"] = Buttons[button - 1],
										["relativeBottom"] = Frame.Content.ContentFrame.Index.Content.Button_PreviousPage
									})
								end

								-- CONTENT BUTTONS
								if button > 1 and button < #Buttons then
									-- BUTTON
									Callback:SetFrameRelatives({
										["frame"] = Buttons[button],
										["children"] = { Buttons[button].Content.ButtonContainer.Button_Delete, Buttons[button].Content.ButtonContainer.Button_Open },
										["relativeLeft"] = Frame.Content.Sidebar.Search,
										["relativeRight"] = Buttons[button].Content.ButtonContainer.Button_Delete,
										["relativeTop"] = Buttons[button - 1],
										["relativeBottom"] = Buttons[button + 1],
										["scrollFrame"] = Frame.Content.ContentFrame.ScrollFrame,
										["scrollChildFrame"] = Frame.Content.ContentFrame.ScrollChildFrame,
										["preventManualScrolling"] = true,
										["axis"] = "y",
									})

									-- BUTTON DELETE
									Callback:SetFrameRelatives({
										["frame"] = Buttons[button].Content.ButtonContainer.Button_Delete,
										["parent"] = Buttons[button],
										["relativeLeft"] = Buttons[button],
										["relativeRight"] = Buttons[button].Content.ButtonContainer.Button_Open,
										["relativeTop"] = Buttons[button - 1],
										["relativeBottom"] = Buttons[button + 1],
									})

									-- BUTTON OPEN
									Callback:SetFrameRelatives({
										["frame"] = Buttons[button].Content.ButtonContainer.Button_Open,
										["parent"] = Buttons[button],
										["relativeLeft"] = Buttons[button].Content.ButtonContainer.Button_Delete,
										["relativeTop"] = Buttons[button - 1],
										["relativeBottom"] = Buttons[button + 1],
									})
								end
							end
						end

						do -- INDEX
							-- BUTTON PREVIOUS PAGE
							Callback:SetFrameRelatives({
								["frame"] = Frame.Content.ContentFrame.Index.Content.Button_PreviousPage,
								["relativeRight"] = Frame.Content.ContentFrame.Index.Content.Button_NextPage,
								["relativeTop"] = Buttons[#Buttons],
								["relativeBottom"] = Frame.Content.ContentFrame.Index.Content.Button_NextPage,
							})

							-- BUTTON NEXT PAGE
							Callback:SetFrameRelatives({
								["frame"] = Frame.Content.ContentFrame.Index.Content.Button_NextPage,
								["relativeLeft"] = Frame.Content.ContentFrame.Index.Content.Button_PreviousPage,
								["relativeTop"] = Frame.Content.ContentFrame.Index.Content.Button_PreviousPage,
							})
						end
					end

					--------------------------------

					Callback:StartNavigation("LIBRARY", DefaultFrame, ChildrenFrames)
				end, 2)

				CallbackRegistry:Add("STOP_LIBRARY", function()
					if Callback.CurrentNavigationSession == "LIBRARY" then
						Callback:StopNavigation()
					end
				end, 0)
			end
		end

		do -- SETTINGS
			function Callback:Settings_SpecialInteractFunc1(Type, Frame)
				if Type == "Checkbox" then
					Frame.Checkbox:Click()

					--------------------------------

					return false
				end

				if Type == "Button" then
					Frame.Button:Click()

					--------------------------------

					return false
				end

				if Type == "Range" then
					local Slider = Frame.SliderFrame.Slider

					local Min, Max = Slider:GetMinMaxValues()
					local Step = Slider:GetValueStep()
					local Value = Slider:GetValue()
					local New = Value + Step

					--------------------------------

					if New < Min then
						Slider:SetValue(Min)
					elseif New > Max then
						Slider:SetValue(Max)
					else
						Slider:SetValue(New)
					end

					--------------------------------

					Frame:OnMouseUp()

					--------------------------------

					return true
				end

				if Type == "Dropdown" then
					local Dropdown = Frame.Dropdown

					local Value = Dropdown.Value
					local Elements = Dropdown.Elements
					local New = Value + 1

					--------------------------------

					if New < 1 then
						New = 1
					elseif New > #Elements then
						New = #Elements
					else
						New = New
					end

					Dropdown:SetValue(Elements[New], New)

					--------------------------------

					return true
				end
			end

			function Callback:Settings_SpecialInteractFunc2(Type, Frame)
				if Type == "Checkbox" then
					return false
				end

				if Type == "Button" then
					return false
				end

				if Type == "Range" then
					local Slider = Frame.SliderFrame.Slider

					local Min, Max = Slider:GetMinMaxValues()
					local Step = Slider:GetValueStep()
					local Value = Slider:GetValue()
					local New = Value - Step

					--------------------------------

					if New < Min then
						Slider:SetValue(Min)
					elseif New > Max then
						Slider:SetValue(Max)
					else
						Slider:SetValue(New)
					end

					--------------------------------

					Frame:OnMouseUp()

					--------------------------------

					return true
				end

				if Type == "Dropdown" then
					local Dropdown = Frame.Dropdown

					local Value = Dropdown.Value
					local Elements = Dropdown.Elements
					local New = Value - 1

					--------------------------------

					if New < 1 then
						New = 1
					elseif New > #Elements then
						New = #Elements
					else
						New = New
					end

					Dropdown:SetValue(Elements[New], New)

					--------------------------------

					return true
				end
			end

			local function InitalizeSettings()
				local Frame = InteractionSettingsFrame
				local DefaultFrame
				local ChildrenFrames = {}

				local Tabs = {
					InteractionSettingsFrame.Tab_Appearance,
					InteractionSettingsFrame.Tab_Effects,
					InteractionSettingsFrame.Tab_Playback,
					InteractionSettingsFrame.Tab_Controls,
					InteractionSettingsFrame.Tab_Gameplay,
					InteractionSettingsFrame.Tab_More
				}

				--------------------------------

				for tab = 1, #Tabs do
					local widgetPool = Tabs[tab].widgetPool

					--------------------------------

					for widget = 1, #widgetPool do
						local type = widgetPool[widget].Type

						--------------------------------

						if type == "Checkbox" or type == "Range" or type == "Dropdown" or type == "Button" then
							table.insert(ChildrenFrames, widgetPool[widget])
						end
					end
				end

				--------------------------------

				local FirstFrameVisible

				for tab = 1, #Frame.Content.ScrollFrame.tabPool do
					local widgets = Tabs[tab].widgetPool

					--------------------------------

					for widget = 1, #widgets do
						if widgets[widget]:IsVisible() then
							local Type = widgets[widget].Type

							--------------------------------

							if Type == "Checkbox" or Type == "Range" or Type == "Dropdown" or Type == "Button" then
								FirstFrameVisible = widgets[widget]
								break
							end
						end
					end
				end

				if FirstFrameVisible then
					DefaultFrame = FirstFrameVisible
				end

				--------------------------------

				do -- CONTENT
					local index = 0
					for tab = 1, #Tabs do
						if #Tabs < tab then
							return
						end

						--------------------------------

						local widgetPool = Tabs[tab].widgetPool
						local widgets = {}

						for widget = 1, #widgetPool do
							local type = widgetPool[widget].Type
							local tooltipText = widgetPool[widget].TooltipText

							--------------------------------

							if type == "Checkbox" or type == "Range" or type == "Dropdown" or type == "Button" then
								table.insert(widgets, widgetPool[widget])
							elseif type == "Title" and tooltipText then
								table.insert(widgets, widgetPool[widget])
							end
						end

						--------------------------------

						for widget = 1, #widgets do
							local type = widgets[widget].Type
							local isTitle = (type == "Title")

							if type == "Checkbox" or type == "Range" or type == "Dropdown" or type == "Button" or type == "Title" then
								index = index + 1

								--------------------------------

								local Widget = widgets[widget]
								local IsSpecialInteract_Button = (Widget.Type == "Button" or Widget.Type == "Checkbox")

								--------------------------------

								-- FIRST ELEMENT
								if widget == 1 then
									Callback:SetFrameRelatives({
										["frame"] = Widget,
										["relativeBottom"] = widgets[widget + 1],
										["scrollFrame"] = InteractionSettingsFrame.Content.ScrollFrame,
										["scrollChildFrame"] = InteractionSettingsFrame.Content.ScrollChildFrame,
										["preventManualScrolling"] = true,
										["axis"] = "y",
										["useSpecialInteract"] = not isTitle and true or false,
										["useSpecialInteractButton"] = IsSpecialInteract_Button
									})
								end

								-- LAST ELEMENT
								if widget == #widgets then
									Callback:SetFrameRelatives({
										["frame"] = Widget,
										["relativeTop"] = widgets[widget - 1],
										["scrollFrame"] = InteractionSettingsFrame.Content.ScrollFrame,
										["scrollChildFrame"] = InteractionSettingsFrame.Content.ScrollChildFrame,
										["preventManualScrolling"] = true,
										["axis"] = "y",
										["useSpecialInteract"] = not isTitle and true or false,
										["useSpecialInteractButton"] = IsSpecialInteract_Button
									})
								end

								-- CONTENT ELEMENTS
								if widget > 1 and widget < #widgets then
									Callback:SetFrameRelatives({
										["frame"] = Widget,
										["relativeTop"] = widgets[widget - 1],
										["relativeBottom"] = widgets[widget + 1],
										["scrollFrame"] = InteractionSettingsFrame.Content.ScrollFrame,
										["scrollChildFrame"] = InteractionSettingsFrame.Content.ScrollChildFrame,
										["preventManualScrolling"] = true,
										["axis"] = "y",
										["useSpecialInteract"] = not isTitle and true or false,
										["useSpecialInteractButton"] = IsSpecialInteract_Button
									})
								end
							end
						end
					end
				end

				--------------------------------

				Callback:StartNavigation("SETTING", DefaultFrame, ChildrenFrames)
			end

			if (NS.Variables.IsController or NS.Variables.SimulateController) then
				CallbackRegistry:Add("START_SETTING", function()
					addon.Libraries.AceTimer:ScheduleTimer(function()
						if not NS.Variables.IsControllerEnabled and not NS.Variables.SimulateController then
							return
						end

						--------------------------------

						InitalizeSettings()
					end, .25)
				end, 2)

				CallbackRegistry:Add("STOP_SETTING", function()
					if Callback.CurrentNavigationSession == "SETTING" then
						Callback:StopNavigation()
					end
				end, 0)

				CallbackRegistry:Add("SETTING_TAB_CHANGED", function()
					if not NS.Variables.IsControllerEnabled and not NS.Variables.SimulateController then
						return
					end

					--------------------------------

					InitalizeSettings()
				end, 0)

				CallbackRegistry:Add("SETTING_CHANGED", function()
					if not NS.Variables.IsControllerEnabled and not NS.Variables.SimulateController then
						return
					end

					--------------------------------

					if Callback.CurrentNavigationSession == "SETTING" then
						addon.Libraries.AceTimer:ScheduleTimer(function()
							Callback:RegisterNewFrame()
						end, 0)

						addon.Libraries.AceTimer:ScheduleTimer(function()
							Callback:RegisterNewFrame()
						end, .1)
					end
				end, 0)

				CallbackRegistry:Add("START_READABLE", function()
					if not NS.Variables.IsControllerEnabled and not NS.Variables.SimulateController then
						return
					end

					--------------------------------

					if InteractionSettingsFrame:IsVisible() then
						addon.SettingsUI.Script:HideSettingsUI(true)
					end
				end, 0)

				CallbackRegistry:Add("START_INTERACTION", function()
					if not NS.Variables.IsControllerEnabled and not NS.Variables.SimulateController then
						return
					end

					--------------------------------

					if InteractionSettingsFrame:IsVisible() then
						addon.SettingsUI.Script:HideSettingsUI(true)
					end
				end, 0)
			end
		end

		do -- PROMPT
			if (NS.Variables.IsController or NS.Variables.SimulateController) then
				CallbackRegistry:Add("START_PROMPT", function()

				end)

				CallbackRegistry:Add("STOP_PROMPT", function()

				end)
			end
		end
	end

	--------------------------------
	-- EVENTS
	--------------------------------

	do
		function Callback:StartGamepadControl()
			if NS.Variables.IsControllerEnabled then
				InteractionFrame.PreventMouse:Show()
				SetGamePadCursorControl()
			end
		end

		function Callback:StopGamepadControl()
			InteractionFrame.PreventMouse:Hide()
		end

		CallbackRegistry:Add("START_INTERACTION", function()
			Callback:StartGamepadControl()
		end, 0)

		CallbackRegistry:Add("START_READABLE", function()
			Callback:StartGamepadControl()
		end, 0)

		CallbackRegistry:Add("START_SETTING", function()
			Callback:StartGamepadControl()
		end, 0)

		local Events = CreateFrame("Frame")
		Events:RegisterEvent("GAME_PAD_ACTIVE_CHANGED")
		Events:SetScript("OnEvent", function(self, event, ...)
			if event == "GAME_PAD_ACTIVE_CHANGED" then
				local IsInInteraction = (addon.Interaction.Variables.Active)
				local IsInSettings = (InteractionSettingsFrame and InteractionSettingsFrame:IsVisible())
				local IsEnabled = ...

				NS.Variables.IsControllerEnabled = IsEnabled

				--------------------------------

				if IsInInteraction and IsInSettings then
					if IsEnabled then
						Callback:StartGamepadControl()
					else
						Callback:StopGamepadControl()
					end
				else
					Callback:StopGamepadControl()
				end
			end
		end)
	end
end
