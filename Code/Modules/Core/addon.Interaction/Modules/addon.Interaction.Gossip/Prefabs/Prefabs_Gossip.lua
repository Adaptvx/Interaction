---@class addon
local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local PrefabRegistry = addon.PrefabRegistry
local L = addon.Locales
local NS = addon.Interaction.Gossip; addon.Interaction.Gossip = NS

--------------------------------

NS.Prefabs = {}

--------------------------------
-- PREFABS
--------------------------------

function NS.Prefabs:Load()
	do -- CONTENT
		do -- OPTION BUTTON
			local PADDING = NS.Variables:RATIO(2)
			local PADDING_FRAME_HEIGHT = NS.Variables:RATIO(.75)

			local FRAME_KEYBIND_SIZE = 30
			local FRAME_IMAGE_SIZE = 17.5
			local FRAME_CONTENT_INSET_WIDTH = 35
			local FRAME_CONTENT_INSET_WIDTH_KEYBIND = 45

			--------------------------------

			PrefabRegistry:Add("Gossip.OptionButton", function(parent, frameStrata, frameLevel, name)
				local Frame = CreateFrame("Frame", name, parent)
				Frame:SetFrameStrata(frameStrata)
				Frame:SetFrameLevel(frameLevel)

				--------------------------------

				do -- ELEMENTS
					do -- CONTENT
						Frame.Content = CreateFrame("Frame", "$parent.Content", Frame)
						Frame.Content:SetPoint("CENTER", Frame)
						Frame.Content:SetFrameStrata(frameStrata)
						Frame.Content:SetFrameLevel(frameLevel + 1)
						addon.API.FrameUtil:SetDynamicSize(Frame.Content, Frame, 0, 0)

						Frame.Content.API_Animation_Parallax_Weight = 2.5
						addon.API.Animation:AddParallax(Frame.Content, Frame, function() return true end, function() return Frame.selected end, addon.Input.Variables.IsController)

						local Content = Frame.Content

						----------------------------------

						do -- BACKGROUND
							Frame.Content.Background, Frame.Content.BackgroundTexture = addon.API.FrameTemplates:CreateNineSlice(Frame.Content, frameStrata, nil, 128, .0875, "$parent.Background", Enum.UITextureSliceMode.Stretched)
							Frame.Content.Background:SetPoint("CENTER", Frame.Content)
							Frame.Content.Background:SetFrameStrata(frameStrata)
							Frame.Content.Background:SetFrameLevel(frameLevel)
							addon.API.FrameUtil:SetDynamicSize(Frame.Content.Background, Frame.Content, -5, -5)
						end

						do -- CONTENT
							Content.Content = CreateFrame("Frame", "$parent.Content", Content)
							Content.Content:SetPoint("CENTER", Content)
							Content.Content:SetFrameStrata(frameStrata)
							Content.Content:SetFrameLevel(frameLevel + 1)
							addon.API.FrameUtil:SetDynamicSize(Content.Content, Content, 0, 0)

							local Subcontent = Content.Content

							--------------------------------

							do -- KEYBIND
								Subcontent.Keybind = CreateFrame("Frame", "$parent.Keybind", Subcontent)
								Subcontent.Keybind:SetParent(Frame)
								Subcontent.Keybind:SetSize(FRAME_KEYBIND_SIZE, FRAME_KEYBIND_SIZE)
								Subcontent.Keybind:SetPoint("LEFT", Frame.Content.Background, -(FRAME_KEYBIND_SIZE / 2), 0)
								Subcontent.Keybind:SetFrameStrata(frameStrata)
								Subcontent.Keybind:SetFrameLevel(frameLevel + 2)

								local Keybind = Subcontent.Keybind

								--------------------------------

								do -- BACKGROUND
									Keybind.Background, Keybind.BackgroundTexture = addon.API.FrameTemplates:CreateNineSlice(Subcontent.Keybind, frameStrata, NS.Variables.PATH .. "key-background.png", 50, 1, "$parent.Background")
									Keybind.Background:SetAllPoints(Subcontent.Keybind)
									Keybind.Background:SetFrameStrata(frameStrata)
									Keybind.Background:SetFrameLevel(frameLevel + 3)

									--------------------------------

									do -- THEME
										addon.API.Main:RegisterThemeUpdate(function()
											local TEXTURE_Background

											--------------------------------

											if addon.Theme.IsDarkTheme_Dialog or addon.Theme.IsRusticTheme_Dialog then
												TEXTURE_Background = NS.Variables.PATH .. "key-background-dark.png"
											else
												TEXTURE_Background = NS.Variables.PATH .. "key-background-light.png"
											end

											--------------------------------

											Keybind.BackgroundTexture:SetTexture(TEXTURE_Background)
										end, 5)
									end
								end

								do -- LABEL
									Keybind.Text = addon.API.FrameTemplates:CreateText(Keybind, addon.Theme.RGB_WHITE, 15, "CENTER", "MIDDLE", addon.API.Fonts.CONTENT_LIGHT, "$parent.Text")
									Keybind.Text:SetPoint("CENTER", Keybind)
									addon.API.FrameUtil:SetDynamicSize(Keybind.Text, Keybind, 0, 0)
								end
							end

							do -- LAYOUT GROUP
								Subcontent.LayoutGroup, Subcontent.LayoutGroup_Sort = addon.API.FrameTemplates:CreateLayoutGroup(Subcontent, { point = "LEFT", direction = "horizontal", resize = false, padding = PADDING, distribute = false, distributeResizeElements = false, excludeHidden = true, autoSort = true, customOffset = nil, customLayoutSort = nil }, "$parent.LayoutGroup")
								Subcontent.LayoutGroup:SetPoint("CENTER", Subcontent)
								Subcontent.LayoutGroup:SetFrameStrata(frameStrata)
								Subcontent.LayoutGroup:SetFrameLevel(frameLevel + 2)
								Frame.UDS_Content = addon.API.FrameUtil:SetDynamicSize(Subcontent.LayoutGroup, Subcontent, function(relativeWidth, relativeHeight) return Subcontent.Keybind:IsShown() and relativeWidth - FRAME_CONTENT_INSET_WIDTH_KEYBIND or relativeWidth - FRAME_CONTENT_INSET_WIDTH end, 0)
								Frame.LGS_Content = Subcontent.LayoutGroup_Sort

								local LayoutGroup = Subcontent.LayoutGroup

								--------------------------------

								do -- IMAGE FRAME
									LayoutGroup.ImageFrame = CreateFrame("Frame", "$parent.ImageFrame", LayoutGroup)
									LayoutGroup.ImageFrame:SetSize(FRAME_IMAGE_SIZE, FRAME_IMAGE_SIZE)
									LayoutGroup.ImageFrame:SetFrameStrata(frameStrata)
									LayoutGroup.ImageFrame:SetFrameLevel(frameLevel + 3)
									LayoutGroup:AddElement(LayoutGroup.ImageFrame)

									local ImageFrame = LayoutGroup.ImageFrame

									--------------------------------

									do -- BACKGROUND
										ImageFrame.Background, ImageFrame.BackgroundTexture = addon.API.FrameTemplates:CreateTexture(ImageFrame, frameStrata, nil, "$parent.Icon")
										ImageFrame.Background:SetPoint("CENTER", ImageFrame)
										ImageFrame.Background:SetFrameStrata(frameStrata)
										ImageFrame.Background:SetFrameLevel(frameLevel + 4)
										addon.API.FrameUtil:SetDynamicSize(ImageFrame.Background, ImageFrame, 0, 0)
									end
								end

								do -- TEXT FRAME
									LayoutGroup.TextFrame = CreateFrame("Frame", "$parent.TextFrame", LayoutGroup)
									LayoutGroup.TextFrame:SetFrameStrata(frameStrata)
									LayoutGroup.TextFrame:SetFrameLevel(frameLevel + 3)
									addon.API.FrameUtil:SetDynamicSize(LayoutGroup.TextFrame, Subcontent.LayoutGroup, function(relativeWidth, relativeHeight) return relativeWidth - PADDING - FRAME_IMAGE_SIZE end, nil)
									addon.API.FrameUtil:SetDynamicSize(Frame, LayoutGroup.TextFrame, nil, -PADDING_FRAME_HEIGHT)
									LayoutGroup:AddElement(LayoutGroup.TextFrame)

									local TextFrame = LayoutGroup.TextFrame

									--------------------------------

									do -- TEXT
										TextFrame.Text = addon.API.FrameTemplates:CreateText(TextFrame, addon.Theme.RGB_WHITE, 14, "LEFT", "MIDDLE", addon.API.Fonts.CONTENT_LIGHT, "$parent.Text")
										TextFrame.Text:SetPoint("CENTER", TextFrame)
										addon.API.FrameUtil:SetDynamicTextSize(TextFrame.Text, TextFrame, nil, nil, true, false)
										addon.API.FrameUtil:SetDynamicSize(TextFrame, TextFrame.Text, nil, 0)
									end
								end
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
							local TEXTURE_BACKGROUND
							local TEXTURE_KEYBIND

							if addon.Theme.IsDarkTheme_Dialog or addon.Theme.IsRusticTheme_Dialog then
								TEXTURE_BACKGROUND = NS.Variables.PATH .. "background-highlighted-nineslice-dark.png"
								TEXTURE_KEYBIND = NS.Variables.PATH .. "key-background-highlighted.png"
							else
								TEXTURE_BACKGROUND = NS.Variables.PATH .. "background-highlighted-nineslice-light.png"
								TEXTURE_KEYBIND = NS.Variables.PATH .. "key-background-highlighted.png"
							end

							Frame.Content.BackgroundTexture:SetTexture(TEXTURE_BACKGROUND)
							Frame:GetKeybindObject().BackgroundTexture:SetTexture(TEXTURE_KEYBIND)
						end
					end

					do -- ON LEAVE
						function Frame:Animation_OnLeave_StopEvent()
							return Frame.isMouseOver
						end

						function Frame:Animation_OnLeave(skipAnimation)
							local TEXTURE_BACKGROUND
							local TEXTURE_KEYBIND

							if addon.Theme.IsDarkTheme_Dialog or addon.Theme.IsRusticTheme_Dialog then
								TEXTURE_BACKGROUND = NS.Variables.PATH .. "background-nineslice-dark.png"
								TEXTURE_KEYBIND = NS.Variables.PATH .. "key-background-dark.png"
							else
								TEXTURE_BACKGROUND = NS.Variables.PATH .. "background-nineslice-light.png"
								TEXTURE_KEYBIND = NS.Variables.PATH .. "key-background-light.png"
							end

							Frame.Content.BackgroundTexture:SetTexture(TEXTURE_BACKGROUND)
							Frame:GetKeybindObject().BackgroundTexture:SetTexture(TEXTURE_KEYBIND)
						end
					end

					do -- ON MOUSE DOWN
						function Frame:Animation_OnMouseDown_StopEvent()
							return not Frame.isMouseDown
						end

						function Frame:Animation_OnMouseDown(skipAnimation)
							if skipAnimation then
								Frame.Content:SetAlpha(.75)
							else
								addon.API.Animation:Fade(Frame.Content, .125, Frame.Content:GetAlpha(), .75, nil, Frame.Animation_OnMouseDown_StopEvent)
							end
						end
					end

					do -- ON MOUSE UP
						function Frame:Animation_OnMouseUp_StopEvent()
							return Frame.isMouseDown
						end

						function Frame:Animation_OnMouseUp(skipAnimation)
							if skipAnimation then
								Frame.Content:SetAlpha(1)
							else
								addon.API.Animation:Fade(Frame.Content, .125, Frame.Content:GetAlpha(), 1, nil, Frame.Animation_OnMouseUp_StopEvent)
							end
						end
					end

					do -- SHOW
						function Frame:ShowWithAnimation_StopEvent()

						end

						function Frame:ShowWithAnimation()
							Frame:Show()

							--------------------------------

							addon.API.Animation:Fade(Frame, .25, 0, 1, nil, Frame.ShowWithAnimation_StopEvent)
							addon.API.Animation:Fade(Frame:GetTextObject(), .25, 0, 1, nil, Frame.ShowWithAnimation_StopEvent)
							addon.API.Animation:Move(Frame.Content, .5, "CENTER", 5, 0, "y", addon.API.Animation.EaseSine, Frame.ShowWithAnimation_StopEvent)
						end

						function Frame:ShowWithAnimation_Pre()
							Frame:Show()
							Frame:SetAlpha(0)
						end
					end

					do -- HIDE
						function Frame:HideWithAnimation_StopEvent()

						end

						function Frame:HideWithAnimation()
							Frame:Hide()
						end
					end
				end

				do -- LOGIC
					Frame.optionFrame = nil
					Frame.optionType = nil
					Frame.optionID = nil
					Frame.orderIndex = nil
					Frame.optionIndex = nil
					Frame.contextIconTexture = nil

					Frame.isMouseOver = false
					Frame.isMouseDown = false

					Frame.enterCallbacks = {}
					Frame.leaveCallbacks = {}
					Frame.mouseDownCallbacks = {}
					Frame.mouseUpCallbacks = {}
					Frame.clickCallbacks = {}

					--------------------------------

					do -- FUNCTIONS
						do -- SET
							function Frame:SetText(text)
								Frame:GetTextObject().Text:SetText(text)
							end

							function Frame:SetContextIcon(texture)
								Frame:GetImageObject().BackgroundTexture:SetTexture(texture)

								--------------------------------

								Frame.contextIconTexture = texture
							end

							function Frame:SetKeybindText(text)
								if text then
									Frame:GetKeybindObject():Show()
									Frame:GetKeybindObject().Text:SetText(text)
									Frame:GetKeybindObject().Text:SetScale(#tostring(text) > 1 and .75 or 1)
								else
									Frame:GetKeybindObject():Hide()
								end
							end

							function Frame:SetKeybindTextFromIndex(index)
								if not Frame:UpdateGamePad() then
									if index <= 18 then
										if index <= 9 then
											Frame:SetKeybindText(index)
										else
											Frame:SetKeybindText("S" .. index - 9)
										end
									end
								end
							end
						end

						do -- GET
							function Frame:GetKeybindObject()
								return Frame.Content.Content.Keybind
							end

							function Frame:GetImageObject()
								return Frame.Content.Content.LayoutGroup.ImageFrame
							end

							function Frame:GetTextObject()
								return Frame.Content.Content.LayoutGroup.TextFrame
							end

							function Frame:GetText()
								return Frame:GetTextObject().Text:GetText()
							end
						end

						do -- LOGIC
							function Frame:SelectOption()
								if Frame.optionFrame == "gossip" then
									if Frame.optionType == "available" then
										C_GossipInfo.SelectAvailableQuest(Frame.optionID)
									elseif Frame.optionType == "active" then
										C_GossipInfo.SelectActiveQuest(Frame.optionID)
									elseif Frame.optionType == "option" then
										if not Frame.optionType then
											C_GossipInfo.SelectOptionByIndex(Frame.orderIndex)
										else
											C_GossipInfo.SelectOption(Frame.optionID)
										end
									end
								elseif Frame.optionFrame == "quest-greeting" then
									if Frame.optionType == "available" then
										SelectAvailableQuest(Frame.optionIndex)
									elseif Frame.optionType == "active" then
										SelectActiveQuest(Frame.optionIndex)
									end
								end
							end

							function Frame:UpdateLayout()
								Frame.UDS_Content()
								Frame.LGS_Content()
							end

							function Frame:UpdateGamePad()
								local isGamePad = (addon.Input.Variables.IsController)

								----------------------------------

								if isGamePad then
									Frame:SetKeybindText(nil)
									return true
								else
									return false
								end
							end
						end
					end

					do -- EVENTS
						local function Logic_OnEnter()
							addon.SoundEffects:PlaySoundFile(addon.SoundEffects.Gossip_Button_Enter)
						end

						local function Logic_OnLeave()
							addon.SoundEffects:PlaySoundFile(addon.SoundEffects.Gossip_Button_Leave)
						end

						local function Logic_OnMouseDown()
							addon.SoundEffects:PlaySoundFile(addon.SoundEffects.Gossip_Button_MouseDown)
						end

						local function Logic_OnMouseUp()
							CallbackRegistry:Trigger("GOSSIP_BUTTON_CLICKED", Frame)

							--------------------------------

							addon.SoundEffects:PlaySoundFile(addon.SoundEffects.Gossip_Button_MouseUp)
						end

						function Frame:OnEnter(skipAnimation)
							Frame.isMouseOver = true

							--------------------------------

							Frame:Animation_OnEnter(skipAnimation)
							Logic_OnEnter()

							--------------------------------

							do -- ON ENTER
								if #Frame.enterCallbacks >= 1 then
									local enterCallbacks = Frame.enterCallbacks

									for callback = 1, #enterCallbacks do
										enterCallbacks[callback](skipAnimation)
									end
								end
							end
						end

						function Frame:OnLeave(skipAnimation)
							Frame.isMouseOver = false

							--------------------------------

							Frame:Animation_OnLeave(skipAnimation)
							Logic_OnLeave()

							--------------------------------

							do -- ON LEAVE
								if #Frame.leaveCallbacks >= 1 then
									local leaveCallbacks = Frame.leaveCallbacks

									for callback = 1, #leaveCallbacks do
										leaveCallbacks[callback](skipAnimation)
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
										mouseDownCallbacks[callback](skipAnimation)
									end
								end
							end
						end

						function Frame:OnMouseUp(button, skipAnimation)
							Frame.isMouseDown = false

							--------------------------------

							Frame:Animation_OnMouseUp(skipAnimation)
							Logic_OnMouseUp()

							--------------------------------

							do -- ON MOUSE UP
								if #Frame.mouseUpCallbacks >= 1 then
									local mouseUpCallbacks = Frame.mouseUpCallbacks

									for callback = 1, #mouseUpCallbacks do
										mouseUpCallbacks[callback](skipAnimation)
									end
								end
							end

							do -- ON CLICK
								if #Frame.clickCallbacks >= 1 then
									local clickCallbacks = Frame.clickCallbacks

									for callback = 1, #clickCallbacks do
										clickCallbacks[callback](skipAnimation)
									end
								end
							end
						end

						addon.API.FrameTemplates:CreateMouseResponder(Frame, { enterCallback = Frame.OnEnter, leaveCallback = Frame.OnLeave, mouseDownCallback = Frame.OnMouseDown, mouseUpCallback = Frame.OnMouseUp })
					end
				end

				do -- SETUP
					Frame:OnLeave(true)
					Frame:Hide()
				end

				--------------------------------

				return Frame
			end)
		end
	end

	do -- FOOTER
		do -- BUTTON
			do -- GOODBYE
				PrefabRegistry:Add("Gossip.Footer.Button.Goodbye", function(parent, frameStrata, frameLevel, name)
					local Frame = addon.API.FrameTemplates:CreateCustomButton(parent, parent:GetWidth() - 125, 27.5, frameStrata, {
						defaultTexture = "",
						highlightTexture = "",
						edgeSize = 25,
						scale = .5,
						theme = 2,
						playAnimation = false,
						customColor = nil,
						customHighlightColor = nil,
						customActiveColor = nil,
					}, "$parent.GoodbyeButton")
					Frame:SetPoint("CENTER", parent) -- Modified later in Gossip_Script.lua
					Frame:SetFrameStrata(frameStrata)
					Frame:SetFrameLevel(frameLevel + 1)
					Frame:SetText(L["InteractionFrame.GossipFrame - Close"])
					addon.API.FrameUtil:SetDynamicSize(Frame, parent, -125)

					Frame:SetAlpha(.5)
					addon.API.Main:SetButtonToPlatform(Frame, Frame.Text, addon.Input.Variables:GetKeybindForPlatform(addon.Input.Variables.Key_Close))

					--------------------------------

					do -- ELEMENTS
						do -- BACKGROUND
							Frame.Background, Frame.BackgroundTexture = addon.API.FrameTemplates:CreateNineSlice(Frame, frameStrata, addon.Variables.PATH_ART .. "Gradient/backdrop-nineslice.png", 128, .5, "$parent.Background")
							Frame.Background:SetPoint("TOPLEFT", Frame, 62.5, 25)
							Frame.Background:SetPoint("BOTTOMRIGHT", Frame, -62.5, -25)
							Frame.Background:SetFrameStrata(frameStrata)
							Frame.Background:SetFrameLevel(frameLevel)
							Frame.BackgroundTexture:SetAlpha(.5)
						end
					end

					do -- ANIMATIONS
						do -- ON ENTER
							function Frame:Animation_OnEnter_StopEvent()
								return not Frame.isMouseOver
							end

							function Frame:Animation_OnEnter()
								addon.API.Animation:Fade(Frame, .25, Frame:GetAlpha(), .75, nil, Frame.Animation_OnEnter_StopEvent)
							end
						end

						do -- ON LEAVE
							function Frame:Animation_OnLeave_StopEvent()
								return Frame.isMouseOver
							end

							function Frame:Animation_OnLeave()
								addon.API.Animation:Fade(Frame, .25, Frame:GetAlpha(), .5, nil, Frame.Animation_OnLeave_StopEvent)
							end
						end

						do -- ON MOUSE DOWN
							function Frame:Animation_OnMouseDown_StopEvent()
								return not Frame.isMouseDown
							end

							function Frame:Animation_OnMouseDown()

							end
						end

						do -- ON MOUSE UP
							function Frame:Animation_OnMouseUp_StopEvent()
								return Frame.isMouseDown
							end

							function Frame:Animation_OnMouseUp()

							end
						end

						do -- PARALLAX
							Frame.API_ButtonTextFrame.API_Animation_Parallax_Weight = 2.5

							addon.API.FrameUtil:AnchorToCenter(Frame)
							addon.API.Animation:AddParallax(Frame.API_ButtonTextFrame, Frame, function() return true end, function() return false end, addon.Input.Variables.IsController)
						end
					end

					do -- LOGIC
						Frame.isMouseOver = false
						Frame.isMouseDown = false

						--------------------------------

						do -- FUNCTIONS
							do -- LOGIC
								local function Update()
									do -- BACKGROUND
										if NS.Variables.NumCurrentButtons < 1 then
											Frame.Background:Show()
										else
											Frame.Background:Hide()
										end
									end

									do -- KEYBIND
										addon.API.Main:SetButtonToPlatform(Frame, Frame.Text, addon.Input.Variables:GetKeybindForPlatform(addon.Input.Variables.Key_Close))
									end
								end

								CallbackRegistry:Add("GOSSIP_DATA_LOADED", Update, 0)
							end
						end

						do -- EVENTS
							function Frame:OnEnter()
								Frame.isMouseOver = true

								--------------------------------

								Frame:Animation_OnEnter()
							end

							function Frame:OnLeave()
								Frame.isMouseOver = false

								--------------------------------

								Frame:Animation_OnLeave()
							end

							function Frame:OnMouseDown()
								Frame.isMouseDown = true

								--------------------------------

								Frame:Animation_OnMouseDown()
							end

							function Frame:OnMouseUp()
								Frame.isMouseDown = false

								--------------------------------

								Frame:Animation_OnMouseUp()
							end

							addon.API.FrameTemplates:CreateMouseResponder(Frame, { enterCallback = Frame.OnEnter, leaveCallback = Frame.OnLeave, mouseDownCallback = Frame.OnMouseDown, mouseUpCallback = Frame.OnMouseUp })
						end
					end

					do -- SETUP
						Frame:OnMouseUp()
					end

					--------------------------------

					return Frame
				end)
			end
		end
	end
end
