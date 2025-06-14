---@class addon
local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local PrefabRegistry = addon.PrefabRegistry
local L = addon.Locales
local NS = addon.Readable; addon.Readable = NS

--------------------------------

NS.Prefabs = {}

--------------------------------
-- PREFABS
--------------------------------

function NS.Prefabs:Load()
	do -- ITEM UI

	end

	do -- LIBRARY UI
		local PADDING = NS.Variables:RATIO(8)

		do -- SIDEBAR
			do -- TAB
				do -- FRAME
					PrefabRegistry:Add("Readable.LibraryUI.SideBar.Tab.Frame", function(parent, frameStrata, frameLevel, name)
						local Frame = CreateFrame("Frame", name, parent)
						Frame:SetFrameStrata(frameStrata)
						Frame:SetFrameLevel(frameLevel + 1)

						--------------------------------

						do -- ELEMENTS
							do -- CONTENT
								Frame.Content = CreateFrame("Frame", "$parent.Content", Frame)
								Frame.Content:SetPoint("CENTER", Frame)
								Frame.Content:SetFrameStrata(frameStrata)
								Frame.Content:SetFrameLevel(frameLevel + 2)
								addon.API.FrameUtil:SetDynamicSize(Frame.Content, Frame, 0, 0)

								local Content = Frame.Content

								--------------------------------

								do -- BACKGROUND
									Content.Background, Content.BackgroundTexture = addon.API.FrameTemplates:CreateNineSlice(Content, frameStrata, NS.Variables.READABLE_UI_PATH .. "Library/element-tab-background-nineslice.png", 79, .075, "$parent.Background")
									Content.Background:SetPoint("TOPLEFT", Content, 0, 0)
									Content.Background:SetPoint("BOTTOMRIGHT", Content, 0, 0)
									Content.Background:SetFrameStrata(frameStrata)
									Content.Background:SetFrameLevel(frameLevel + 1)
									Content.BackgroundTexture:SetAlpha(.075)
								end

								do -- CONTENT
									Content.Content = CreateFrame("Frame", "$parent.Content", Frame)
									Content.Content:SetPoint("CENTER", Content)
									Content.Content:SetFrameStrata(frameStrata)
									Content.Content:SetFrameLevel(frameLevel + 2)
									addon.API.FrameUtil:SetDynamicSize(Content.Content, Content, PADDING, PADDING)

									local Subcontent = Content.Content

									--------------------------------

									do -- LAYOUT GROUP
										Subcontent.LayoutGroup = addon.API.FrameTemplates:CreateLayoutGroup(Subcontent, { point = "LEFT", direction = "horizontal", resize = false, padding = (PADDING / 2), distribute = true, distributeResizeElements = true, excludeHidden = true, autoSort = true, customOffset = nil, customLayoutSort = nil }, "$parent.LayoutGroup")
										Subcontent.LayoutGroup:SetPoint("CENTER", Subcontent)
										Subcontent.LayoutGroup:SetFrameStrata(frameStrata)
										Subcontent.LayoutGroup:SetFrameLevel(frameLevel + 3)
										addon.API.FrameUtil:SetDynamicSize(Subcontent.LayoutGroup, Subcontent, 0, 0)

										local LayoutGroup = Subcontent.LayoutGroup

										--------------------------------

										do -- ELEMENTS

										end
									end
								end
							end
						end

						do -- LOGIC
							Frame.Buttons = {}

							--------------------------------

							do -- FUNCTIONS
								do -- SET
									function Frame:SelectButton(index)
										for i = 1, #Frame.Buttons do
											if i ~= index then
												Frame.Buttons[i]:SetActive(false)
											end
										end

										Frame.Buttons[index]:SetActive(true)
									end
								end

								do -- LOGIC

								end
							end
						end

						do -- SETUP

						end

						--------------------------------

						return Frame
					end)
				end

				do -- BUTTON
					do -- TEMPLATE
						PrefabRegistry:Add("Readable.LibraryUI.SideBar.Tab.Template.Button", function(parent, tab, buttonIndex, frameStrata, frameLevel, name)
							local Frame = CreateFrame("Frame", name, parent)
							Frame:SetFrameStrata(frameStrata)
							Frame:SetFrameLevel(frameLevel + 1)
							table.insert(tab.Buttons, Frame)

							--------------------------------

							do -- ELEMENTS
								do -- CONTENT
									Frame.Content = CreateFrame("Frame", "$parent.Content", Frame)
									Frame.Content:SetPoint("CENTER", Frame)
									Frame.Content:SetFrameStrata(frameStrata)
									Frame.Content:SetFrameLevel(frameLevel + 2)
									addon.API.FrameUtil:SetDynamicSize(Frame.Content, Frame, 0, 0)

									local Content = Frame.Content

									--------------------------------

									do -- BACKGROUND
										Content.Background, Content.BackgroundTexture = addon.API.FrameTemplates:CreateNineSlice(Content, frameStrata, NS.Variables.READABLE_UI_PATH .. "Library/element-tab-background-highlighted-nineslice.png", 79, .0375, "$parent.Background")
										Content.Background:SetPoint("TOPLEFT", Content, 0, 0)
										Content.Background:SetPoint("BOTTOMRIGHT", Content, 0, 0)
										Content.Background:SetFrameStrata(frameStrata)
										Content.Background:SetFrameLevel(frameLevel + 1)
										Content.BackgroundTexture:SetAlpha(.25)
									end

									do -- CONTENT
										Content.Content = CreateFrame("Frame", "$parent.Content", Frame)
										Content.Content:SetPoint("CENTER", Content)
										Content.Content:SetFrameStrata(frameStrata)
										Content.Content:SetFrameLevel(frameLevel + 2)
										addon.API.FrameUtil:SetDynamicSize(Content.Content, Content, PADDING, PADDING)
									end
								end
							end

							do -- ANIMATIONS
								do -- ON ENTER
									function Frame:Animation_OnEnter_StopEvent()
										return not Frame.isMouseOver
									end

									function Frame:Animation_OnEnter()
										Frame.Content:SetAlpha(1)
									end
								end

								do -- ON LEAVE
									function Frame:Animation_OnLeave_StopEvent()
										return Frame.isMouseOver
									end

									function Frame:Animation_OnLeave()
										Frame.Content:SetAlpha(.75)
									end
								end

								do -- ON MOUSE DOWN
									function Frame:Animation_OnMouseDown_StopEvent()
										return not Frame.isMouseDown
									end

									function Frame:Animation_OnMouseDown()
										Frame.Content:SetAlpha(.875)
									end
								end

								do -- ON MOUSE UP
									function Frame:Animation_OnMouseUp_StopEvent()
										return not Frame.isMouseUp
									end

									function Frame:Animation_OnMouseUp()
										if Frame.isMouseOver then
											Frame.Content:SetAlpha(1)
										else
											Frame.Content:SetAlpha(.75)
										end
									end
								end
							end

							do -- LOGIC
								Frame.enabled = true
								Frame.active = true
								Frame.isMouseOver = false
								Frame.isMouseDown = false

								Frame.buttonIndex = buttonIndex

								Frame.onEnableCallbacks = {}
								Frame.onActiveCallbacks = {}
								Frame.enterCallbacks = {}
								Frame.leaveCallbacks = {}
								Frame.mouseDownCallbacks = {}
								Frame.mouseUpCallbacks = {}
								Frame.clickCallbacks = {}

								--------------------------------

								do -- FUNCTIONS
									do -- SET
										function Frame:SetEnabled(value)
											Frame.enabled = value

											--------------------------------

											if value then
												Frame:SetAlpha(1)
											else
												Frame:SetAlpha(.25)
											end

											--------------------------------

											do -- ON ENABLE
												if #Frame.onEnableCallbacks >= 1 then
													local onEnableCallbacks = Frame.onEnableCallbacks

													for i = 1, #onEnableCallbacks do
														onEnableCallbacks[i](Frame, value)
													end
												end
											end
										end

										function Frame:SetActive(value)
											if Frame.enabled then
												Frame.active = value

												--------------------------------

												if value then
													Frame:SetAlpha(1)
												else
													Frame:SetAlpha(.25)
												end

												--------------------------------

												do -- ON ACTIVE
													if #Frame.onActiveCallbacks >= 1 then
														local onActiveCallbacks = Frame.onActiveCallbacks

														for i = 1, #onActiveCallbacks do
															onActiveCallbacks[i](Frame, value)
														end
													end
												end
											end
										end
									end

									do -- LOGIC

									end
								end

								do -- EVENTS
									local function Logic_OnEnter()

									end

									local function Logic_OnLeave()

									end

									local function Logic_OnMouseDown()

									end

									local function Logic_OnMouseUp()

									end

									local function Logic_OnClick()
										tab:SelectButton(buttonIndex)
									end

									function Frame:OnEnter(skipAnimation)
										Frame.isMouseOver = true

										--------------------------------

										Frame:Animation_OnEnter()
										Logic_OnEnter()

										--------------------------------

										do -- ON ENTER
											if #Frame.enterCallbacks >= 1 then
												local enterCallbacks = Frame.enterCallbacks

												for i = 1, #enterCallbacks do
													enterCallbacks[i](Frame, skipAnimation)
												end
											end
										end
									end

									function Frame:OnLeave(skipAnimation)
										Frame.isMouseOver = false

										--------------------------------

										Frame:Animation_OnLeave()
										Logic_OnLeave()

										--------------------------------

										do -- ON LEAVE
											if #Frame.leaveCallbacks >= 1 then
												local leaveCallbacks = Frame.leaveCallbacks

												for i = 1, #leaveCallbacks do
													leaveCallbacks[i](Frame, skipAnimation)
												end
											end
										end
									end

									function Frame:OnMouseDown(button, skipAnimation)
										Frame.isMouseDown = true

										--------------------------------

										Frame:Animation_OnMouseDown()
										Logic_OnMouseDown()

										--------------------------------

										do -- ON MOUSE DOWN
											if #Frame.mouseDownCallbacks >= 1 then
												local mouseDownCallbacks = Frame.mouseDownCallbacks

												for i = 1, #mouseDownCallbacks do
													mouseDownCallbacks[i](Frame, skipAnimation)
												end
											end
										end
									end

									function Frame:OnMouseUp(button, skipAnimation)
										Frame.isMouseDown = false

										--------------------------------

										Frame:Animation_OnMouseUp()
										Logic_OnMouseUp()
										Logic_OnClick()

										--------------------------------

										do -- ON MOUSE UP
											if #Frame.mouseUpCallbacks >= 1 then
												local mouseUpCallbacks = Frame.mouseUpCallbacks

												for i = 1, #mouseUpCallbacks do
													mouseUpCallbacks[i](Frame, skipAnimation)
												end
											end
										end

										do -- ON CLICK
											if #Frame.clickCallbacks >= 1 then
												local clickCallbacks = Frame.clickCallbacks

												for i = 1, #clickCallbacks do
													clickCallbacks[i](Frame)
												end
											end
										end
									end

									addon.API.FrameTemplates:CreateMouseResponder(Frame, { enterCallback = Frame.OnEnter, leaveCallback = Frame.OnLeave, mouseDownCallback = Frame.OnMouseDown, mouseUpCallback = Frame.OnMouseUp })
								end
							end

							do -- SETUP
								Frame:OnLeave(true)
							end

							--------------------------------

							return Frame
						end)
					end

					do -- IMAGE
						PrefabRegistry:Add("Readable.LibraryUI.SideBar.Tab.Button.Image", function(parent, tab, buttonIndex, frameStrata, frameLevel, name)
							local Frame = PrefabRegistry:Create("Readable.LibraryUI.SideBar.Tab.Template.Button", parent, tab, buttonIndex, frameStrata, frameLevel, name)
							Frame:SetFrameStrata(frameStrata)
							Frame:SetFrameLevel(frameLevel + 1)

							--------------------------------

							do -- ELEMENTS
								do -- CONTENT
									local Content = Frame.Content

									--------------------------------

									do -- CONTENT
										local Subcontent = Content.Content

										--------------------------------

										do -- IMAGE FRAME
											Subcontent.ImageFrame = CreateFrame("Frame", "$parent.ImageFrame", Subcontent)
											Subcontent.ImageFrame:SetPoint("CENTER", Subcontent)
											Subcontent.ImageFrame:SetSize(17.5, 17.5)
											Subcontent.ImageFrame:SetFrameStrata(frameStrata)
											Subcontent.ImageFrame:SetFrameLevel(frameLevel + 3)

											--------------------------------

											do -- BACKGROUND
												Subcontent.ImageFrame.Background, Subcontent.ImageFrame.BackgroundTexture = addon.API.FrameTemplates:CreateTexture(Subcontent.ImageFrame, frameStrata, nil, "$parent.Background")
												Subcontent.ImageFrame.Background:SetAllPoints(Subcontent.ImageFrame)
											end
										end
									end
								end
							end

							do -- ANIMATIONS
								do -- ON ENTER
									function Frame:Event_Animation_OnEnter_StopEvent()
										return not Frame.isMouseOver
									end

									function Frame:Event_Animation_OnEnter(skipAnimation)

									end
								end

								do -- ON LEAVE
									function Frame:Event_Animation_OnLeave_StopEvent()
										return Frame.isMouseOver
									end

									function Frame:Event_Animation_OnLeave(skipAnimation)

									end
								end

								do -- ON MOUSE DOWN
									function Frame:Event_Animation_OnMouseDown_StopEvent()
										return not Frame.isMouseDown
									end

									function Frame:Event_Animation_OnMouseDown(skipAnimation)

									end
								end

								do -- ON MOUSE UP
									function Frame:Event_Animation_OnMouseUp_StopEvent()
										return not Frame.isMouseUp
									end

									function Frame:Event_Animation_OnMouseUp(skipAnimation)

									end
								end
							end

							do -- LOGIC
								do -- FUNCTIONS
									do -- SET
										function Frame:SetImage(texture)
											Frame.Content.Content.ImageFrame.BackgroundTexture:SetTexture(texture)
										end

										function Frame:Set(texture, callback)
											Frame:SetImage(texture)

											--------------------------------

											Frame.clickCallbacks = {}
											table.insert(Frame.clickCallbacks, callback)
										end
									end

									do -- LOGIC

									end
								end

								do -- EVENTS
									function Frame:Event_OnEnter(self, skipAnimation)
										Frame:Event_Animation_OnEnter(skipAnimation)
									end

									function Frame:Event_OnLeave(self, skipAnimation)
										Frame:Event_Animation_OnLeave(skipAnimation)
									end

									function Frame:Event_OnMouseDown(self, skipAnimation)
										Frame:Event_Animation_OnMouseDown(skipAnimation)
									end

									function Frame:Event_OnMouseUp(self, skipAnimation)
										Frame:Event_Animation_OnMouseUp(skipAnimation)
									end

									table.insert(Frame.enterCallbacks, Frame.Event_OnEnter)
									table.insert(Frame.leaveCallbacks, Frame.Event_OnLeave)
									table.insert(Frame.mouseDownCallbacks, Frame.Event_OnMouseDown)
									table.insert(Frame.mouseUpCallbacks, Frame.Event_OnMouseUp)
								end
							end

							do -- SETUP

							end

							--------------------------------

							return Frame
						end)
					end
				end
			end

			do -- CATEGORIES
				do -- CHECKBOX
					PrefabRegistry:Add("Readable.LibraryUI.SideBar.Categories.Checkbox", function(parent, callback, text, frameStrata, frameLevel, name)
						local Frame = addon.API.FrameTemplates:CreateLayoutGroup(parent, { point = "LEFT", direction = "horizontal", resize = false, padding = PADDING / 2, distribute = false, distributeResizeElements = false, excludeHidden = true, autoSort = true, customOffset = nil, customLayoutSort = nil }, "$parent.LayoutGroup")
						Frame:SetHeight(25)
						Frame:SetFrameStrata(frameStrata)
						Frame:SetFrameLevel(frameLevel)
						addon.API.FrameUtil:SetDynamicSize(Frame, parent, 0, nil)

						--------------------------------

						do -- ELEMENTS
							do -- CHECKBOX
								Frame.Checkbox = addon.API.FrameTemplates:CreateCheckbox(Frame, frameStrata, frameLevel + 1, {
									defaultTexture = NS.Variables.NINESLICE_RUSTIC_BORDER,
									highlightTexture = NS.Variables.NINESLICE_RUSTIC,
									checkTexture = NS.Variables.TEXTURE_CHECK,
									edgeSize = 128,
									scale = .075,
									callbackFunction = callback,
									theme = 1,
								}, name)
								Frame.Checkbox:SetFrameStrata(frameStrata)
								Frame.Checkbox:SetFrameLevel(frameLevel + 1)
								addon.API.FrameUtil:SetDynamicSize(Frame.Checkbox, Frame, function(relativeWidth, relativeHeight) return relativeHeight end, function(relativeWidth, relativeHeight) return relativeHeight end)
								Frame:AddElement(Frame.Checkbox)

								Frame.Checkbox.Checkbox.BackgroundTexture:SetAlpha(.5)
								Frame.Checkbox.Checkbox.Icon:SetAlpha(.75)
							end

							do -- DETAIL
								Frame.Detail = addon.API.FrameTemplates:CreateText(Frame, addon.Theme.RGB_WHITE, 12.5, "LEFT", "MIDDLE", addon.API.Fonts.CONTENT_LIGHT, "$parent.Detail")
								Frame.Detail:SetWidth(22.5)
								addon.API.FrameUtil:SetDynamicSize(Frame.Detail, Frame, nil, function(relativeWidth, relativeHeight) return relativeHeight end)
								Frame:AddElement(Frame.Detail)

								Frame.Detail:SetAlpha(.5)
							end

							do -- LABEL
								Frame.Label = addon.API.FrameTemplates:CreateText(Frame, addon.Theme.RGB_WHITE, 12.5, "LEFT", "MIDDLE", addon.API.Fonts.CONTENT_LIGHT, "$parent.Label")
								addon.API.FrameUtil:SetDynamicSize(Frame.Label, Frame, function(relativeWidth, relativeHeight) return relativeWidth - relativeHeight - PADDING - relativeHeight end, function(relativeWidth, relativeHeight) return relativeHeight end)
								Frame:AddElement(Frame.Label)

								Frame.Label:SetAlpha(.375)
							end
						end

						do -- SETUP
							Frame.Label:SetText(text)
							addon.SoundEffects:SetCheckbox(Frame.Checkbox, addon.SoundEffects.Readable_LibraryUI_Checkbox_Enter, addon.SoundEffects.Readable_LibraryUI_Checkbox_Leave, addon.SoundEffects.Readable_LibraryUI_Checkbox_MouseDown, addon.SoundEffects.Readable_LibraryUI_Checkbox_MouseUp)
						end

						--------------------------------

						return Frame
					end)
				end
			end
		end
	end

	do -- SHARED

	end
end
