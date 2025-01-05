local addonName, addon = ...
local CallbackRegistry = addon.CallbackRegistry
local L = addon.Locales
local NS = addon.Interaction.Gossip

--------------------------------

NS.Elements = {}

--------------------------------

function NS.Elements:Load()
	--------------------------------
	-- CREATE ELEMENTS
	--------------------------------

	do
		do -- CREATE ELEMENTS
			InteractionGossipParent = CreateFrame("Frame", "InteractionGossipParent", InteractionFrame)
			InteractionGossipParent:SetSize(addon.API:GetScreenWidth(), addon.API:GetScreenHeight())
			InteractionGossipParent:SetPoint("CENTER", nil)
			InteractionGossipParent:SetFrameStrata("FULLSCREEN")

			InteractionGossipFrame = CreateFrame("Frame", "InteractionGossipFrame", InteractionGossipParent)
			InteractionGossipFrame:SetWidth(325)
			InteractionGossipFrame:SetPoint("CENTER", InteractionGossipParent)
			InteractionGossipFrame:SetFrameStrata("FULLSCREEN")

			--------------------------------

			local Frame = InteractionGossipFrame

			--------------------------------

			do -- MOUSE RESPONDER
				InteractionGossipFrame.MouseResponder = CreateFrame("Frame", "$parent.MouseResponder", InteractionGossipFrame)
				InteractionGossipFrame.MouseResponder:SetAllPoints(InteractionGossipFrame, true)
				InteractionGossipFrame.MouseResponder:SetFrameStrata("FULLSCREEN")
				InteractionGossipFrame.MouseResponder:SetFrameLevel(0)
			end

			do -- BUTTONS
				do -- GOODBYE BUTTON
					Frame.GoodbyeButton = AdaptiveAPI.FrameTemplates:CreateCustomButton(Frame, Frame:GetWidth() - 20, 27.5, "FULLSCREEN", {
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
					Frame.GoodbyeButton:SetPoint("CENTER", Frame) -- Modified later in Gossip_Script.lua
					Frame.GoodbyeButton:SetText(L["InteractionGossipFrame - Close"])
					addon.API:SetButtonToPlatform(Frame.GoodbyeButton, Frame.GoodbyeButton.Text, addon.Input.Variables:GetKeybindForPlatform(addon.Input.Variables.Key_Close))

					Frame.GoodbyeButton:SetAlpha(.5)

					--------------------------------

					do -- BACKGROUND
						Frame.GoodbyeButton.Background, Frame.GoodbyeButton.BackgroundTexture = AdaptiveAPI.FrameTemplates:CreateNineSlice(Frame.GoodbyeButton, "HIGH", addon.Variables.PATH .. "Art/Gradient/backdrop-nineslice.png", 128, .5, "$parent.Background")
						Frame.GoodbyeButton.Background:SetSize(Frame.GoodbyeButton:GetWidth() + 125, Frame.GoodbyeButton:GetHeight() + 50)
						Frame.GoodbyeButton.Background:SetPoint("CENTER", Frame.GoodbyeButton)
						Frame.GoodbyeButton.Background:SetAlpha(.5)
						Frame.GoodbyeButton.BackgroundTexture:SetAlpha(1)
					end

					--------------------------------

					do -- PARALLAX
						AdaptiveAPI:AnchorToCenter(Frame.GoodbyeButton)

						Frame.GoodbyeButton.API_ButtonTextFrame.AdaptiveAPI_Animation_Parallax_Weight = 2.5
						AdaptiveAPI.Animation:AddParallax(Frame.GoodbyeButton.API_ButtonTextFrame, Frame.GoodbyeButton, function() return true end, function() return false end, addon.Input.Variables.IsController)
					end

					do -- EVENTS
						local function UpdateSize()
							Frame.GoodbyeButton:SetSize(Frame:GetWidth() - 125, 27.5)
							Frame.GoodbyeButton.Background:SetSize(Frame.GoodbyeButton:GetWidth() + 125, Frame.GoodbyeButton:GetHeight() + 50)
						end

						local function UpdateBackground()
							if NS.Variables.NumCurrentButtons < 1 then
								Frame.GoodbyeButton.Background:Show()
							else
								Frame.GoodbyeButton.Background:Hide()
							end
						end

						UpdateSize()
						UpdateBackground()

						hooksecurefunc(Frame, "SetWidth", UpdateSize)
						hooksecurefunc(Frame, "SetHeight", UpdateSize)
						hooksecurefunc(Frame, "SetSize", UpdateSize)

						CallbackRegistry:Add("GOSSIP_DATA_LOADED", UpdateBackground, 0)

						--------------------------------

						Frame.GoodbyeButton:HookScript("OnEnter", function()
							AdaptiveAPI.Animation:Fade(Frame.GoodbyeButton.Background, .25, Frame.GoodbyeButton.Background:GetAlpha(), .75)
						end)

						Frame.GoodbyeButton:HookScript("OnLeave", function()
							AdaptiveAPI.Animation:Fade(Frame.GoodbyeButton.Background, .25, Frame.GoodbyeButton.Background:GetAlpha(), .5)
						end)
					end
				end
			end

			do -- CONTENT
				Frame.Content = CreateFrame("Frame", "$parent.Content", Frame)
				Frame.Content:SetSize(Frame:GetWidth() - 20, 500)
				Frame.Content:SetPoint("TOP", Frame, 0, -NS.Variables.PADDING)
			end

			do -- OPTIONS
				local function CreateButton(parent, offsetCalculation, relativeTo)
					local button = CreateFrame("Frame", nil, parent)
					button:SetWidth(parent:GetWidth() - 20)
					button:SetFrameStrata("FULLSCREEN")
					button:SetFrameLevel(2)

					--------------------------------

					button.OptionFrame = nil
					button.OptionType = nil
					button.OptionID = nil
					button.OptionIndex = nil

					--------------------------------

					button.UpdatePosition = function()
						button:SetPoint("TOP", relativeTo, 0, offsetCalculation())
					end

					--------------------------------

					button.Click = function()
						CallbackRegistry:Trigger("GOSSIP_BUTTON_CLICKED", button)

						--------------------------------

						addon.SoundEffects:PlaySoundFile(addon.SoundEffects.Gossip_Button_MouseUp)
					end

					button.SelectOption = function()
						if button.OptionFrame == "gossip" then
							if button.OptionType == "available" then
								C_GossipInfo.SelectAvailableQuest(button.OptionID)
							elseif button.OptionType == "active" then
								C_GossipInfo.SelectActiveQuest(button.OptionID)
							elseif button.OptionType == "option" then
								C_GossipInfo.SelectOption(button.OptionID)
							end
						elseif button.OptionFrame == "quest-greeting" then
							if button.OptionType == "available" then
								SelectAvailableQuest(button.OptionIndex)
							elseif button.OptionType == "active" then
								SelectActiveQuest(button.OptionIndex)
							end
						end
					end

					button.MouseDownCallback = function()
						button.MouseDown()

						--------------------------------

						addon.SoundEffects:PlaySoundFile(addon.SoundEffects.Gossip_Button_MouseDown)
					end

					button.MouseEnterCallback = function()
						button.Enter()

						--------------------------------

						addon.SoundEffects:PlaySoundFile(addon.SoundEffects.Gossip_Button_Enter)
					end

					button.MouseLeaveCallback = function()
						button.Leave()

						--------------------------------

						addon.SoundEffects:PlaySoundFile(addon.SoundEffects.Gossip_Button_Leave)
					end

					--------------------------------

					button:SetScript("OnEnter", function()
						button.MouseEnterCallback()
					end)

					button:SetScript("OnLeave", function()
						button.MouseLeaveCallback()
					end)

					button:SetScript("OnMouseDown", function()
						button.MouseDownCallback()
					end)

					button:SetScript("OnMouseUp", function()
						button.Click()
					end)

					--------------------------------

					do -- ICON
						button.Icon, button.IconTexture = AdaptiveAPI.FrameTemplates:CreateTexture(button, "FULLSCREEN", addon.Variables.PATH .. "Art/Icons/logo.png", "$parent.Icon")
						button.Icon:SetSize(17.5, 17.5)
						button.Icon:SetFrameStrata("FULLSCREEN")
						button.Icon:SetFrameLevel(2)
					end

					do -- LABEL
						button.Label = AdaptiveAPI.FrameTemplates:CreateText(button, { r = 1, g = 1, b = 1 }, 14, "LEFT", "MIDDLE", AdaptiveAPI.Fonts.Content_Light)
						button.Label:SetHeight(button:GetHeight())

						--------------------------------

						button.Label.Offset = 0
					end

					do -- STANDALONE
						button.Standalone = CreateFrame("Frame", "$parent.Standalone", button)
						button.Standalone:SetWidth(button:GetWidth() + 35)
						button.Standalone:SetPoint("CENTER", button)
						button.Standalone:SetFrameStrata("FULLSCREEN")
						button.Standalone:SetFrameLevel(0)

						--------------------------------

						hooksecurefunc(button, "SetHeight", function()
							button.Standalone:SetHeight(button:GetHeight())
							button.Standalone.Background:SetHeight(button.Standalone:GetHeight() + 2.5)
						end)

						--------------------------------

						do -- BACKGROUND
							button.Standalone.Background, button.Standalone.BackgroundTexture = AdaptiveAPI.FrameTemplates:CreateNineSlice(button.Standalone, "FULLSCREEN", nil, { left = 128, top = 128, right = 128, bottom = 128 }, .0875, "$parent.Background", Enum.UITextureSliceMode.Stretched)
							button.Standalone.Background:SetWidth(button.Standalone:GetWidth())
							button.Standalone.Background:SetPoint("CENTER", button.Standalone)
							button.Standalone.Background:SetFrameStrata("FULLSCREEN")
							button.Standalone.Background:SetFrameLevel(1)

							--------------------------------

							button.UpdateState = function()
								local TEXTURE_Background
								local TEXTURE_Highlighted

								local TEXTURE_KeybindBackground
								local TEXTURE_KeybindHighlighted

								--------------------------------

								if addon.Theme.IsDarkTheme_Dialog or addon.Theme.IsRusticTheme_Dialog then
									TEXTURE_Background = NS.Variables.PATH .. "background-nineslice-dark.png"
									TEXTURE_Highlighted = NS.Variables.PATH .. "background-nineslice-highlighted-dark.png"

									TEXTURE_KeybindBackground = NS.Variables.PATH .. "key-background-dark.png"
									TEXTURE_KeybindHighlighted = NS.Variables.PATH .. "key-background-highlighted.png"
								else
									TEXTURE_Background = NS.Variables.PATH .. "background-nineslice-light.png"
									TEXTURE_Highlighted = NS.Variables.PATH .. "background-nineslice-highlighted-light.png"

									TEXTURE_KeybindBackground = NS.Variables.PATH .. "key-background-light.png"
									TEXTURE_KeybindHighlighted = NS.Variables.PATH .. "key-background-highlighted.png"
								end

								--------------------------------

								if button.selected then
									button.Standalone.BackgroundTexture:SetTexture(TEXTURE_Highlighted)
									button.Keybind.BackgroundTexture:SetTexture(TEXTURE_KeybindHighlighted)
								else
									button.Standalone.BackgroundTexture:SetTexture(TEXTURE_Background)
									button.Keybind.BackgroundTexture:SetTexture(TEXTURE_KeybindBackground)
								end
							end
						end

						-- do -- GRADIENT
						-- 	button.Standalone.Gradient, button.Standalone.GradientTexture = AdaptiveAPI.FrameTemplates:CreateTexture(button.Standalone, "FULLSCREEN", addon.Variables.PATH .. "Art/Gradient/gradient-horizontal.png")
						-- 	button.Standalone.Gradient:SetWidth(button.Standalone:GetWidth() + 100)
						-- 	button.Standalone.Gradient:SetPoint("CENTER", button.Standalone)
						-- 	button.Standalone.Gradient:SetFrameStrata("FULLSCREEN")
						-- 	button.Standalone.Gradient:SetFrameLevel(0)
						-- 	button.Standalone.Gradient:SetAlpha(1)
						-- end
					end

					do -- KEYBIND
						button.Keybind = CreateFrame("Frame")
						button.Keybind:SetParent(button)
						button.Keybind:SetSize(30, 30)
						button.Keybind:SetPoint("LEFT", button.Standalone.Background, 15, 0)
						button.Keybind:SetFrameStrata("FULLSCREEN")
						button.Keybind:SetFrameLevel(3)

						--------------------------------

						do -- BACKGROUND
							button.Keybind.Background, button.Keybind.BackgroundTexture = AdaptiveAPI.FrameTemplates:CreateNineSlice(button.Keybind, "MEDIUM", NS.Variables.PATH .. "key-background.png", 50, 1, "$parent.Background")
							button.Keybind.Background:SetAllPoints(button.Keybind)
							button.Keybind.Background:SetFrameStrata("FULLSCREEN")
							button.Keybind.Background:SetFrameLevel(2)

							--------------------------------

							addon.API:RegisterThemeUpdate(function()
								local TEXTURE_Background

								if addon.Theme.IsDarkTheme_Dialog or addon.Theme.IsRusticTheme_Dialog then
									TEXTURE_Background = NS.Variables.PATH .. "key-background-dark.png"
								else
									TEXTURE_Background = NS.Variables.PATH .. "key-background-light.png"
								end

								button.Keybind.BackgroundTexture:SetTexture(TEXTURE_Background)
							end, 5)
						end

						do -- LABEL
							button.Keybind.Label = AdaptiveAPI.FrameTemplates:CreateText(button.Keybind, { r = 1, g = 1, b = 1 }, 15, "CENTER", "MIDDLE", AdaptiveAPI.Fonts.Content_Light)
							button.Keybind.Label:SetSize(30, 30)
							button.Keybind.Label:SetPoint("CENTER", button.Keybind)
						end
					end

					do -- KEYBIND (CONTROLLER)
						button.Keybind_Controller = CreateFrame("Frame")
						button.Keybind_Controller:SetSize(30, 30)
						button.Keybind_Controller:SetPoint("LEFT", button, -19.5, 0)
						button.Keybind_Controller:SetFrameStrata("FULLSCREEN")
						button.Keybind_Controller:SetFrameLevel(3)

						--------------------------------

						do -- LABEL
							button.Keybind_Controller.Label = AdaptiveAPI.FrameTemplates:CreateText(button.Keybind_Controller, { r = 1, g = 1, b = 1 }, 16, "CENTER", "MIDDLE", AdaptiveAPI.Fonts.Content_Light)
							button.Keybind_Controller.Label:SetSize(button.Keybind_Controller:GetWidth(), button.Keybind_Controller:GetHeight())
							button.Keybind_Controller.Label:SetPoint("CENTER", button.Keybind_Controller)

							--------------------------------

							if addon.Variables.Platform == 1 then
								button.Keybind_Controller:Hide()
							elseif addon.Variables.Platform == 2 then
								button.Keybind_Controller.Label:SetText(AdaptiveAPI:InlineIcon(addon.Variables.PATH .. "Art/Platform/Platform-PS-3", 16, 16, 0, 0))
							elseif addon.Variables.Platform == 3 then
								button.Keybind_Controller.Label:SetText(AdaptiveAPI:InlineIcon(addon.Variables.PATH .. "Art/Platform/Platform-XBOX-2", 16, 16, 0, 0))
							end
						end
					end

					do -- LAYOUT
						if addon.Input.Variables.IsController or addon.Input.Variables.SimulateController then
							if button:GetHeight() <= 45 then
								button.Icon:ClearAllPoints()
								button.Icon:SetPoint("LEFT", button.Standalone.Background, NS.Variables:RATIO(1.75), 0)

								--------------------------------

								button.Label:SetWidth(200)

								if not button.Label.transition then
									button.Label.Offset = NS.Variables:RATIO(1.5) + NS.Variables:RATIO(1)

									--------------------------------

									button.Label:ClearAllPoints()
									button.Label:SetPoint("LEFT", button.Standalone.Background, button.Label.Offset, 0)
								end

								--------------------------------

								button.Keybind:ClearAllPoints()
								button.Keybind:Hide()
							else
								button.Icon:ClearAllPoints()
								button.Icon:SetPoint("TOPLEFT", button.Standalone.Background, NS.Variables:RATIO(2.25) + NS.Variables:RATIO(.5), -NS.Variables:RATIO(1))

								--------------------------------

								button.Label:SetWidth(200)

								if not button.Label.transition then
									button.Label.Offset = NS.Variables:RATIO(2) + NS.Variables:RATIO(.5) + NS.Variables:RATIO(1.25)

									--------------------------------

									button.Label:ClearAllPoints()
									button.Label:SetPoint("LEFT", button.Standalone.Background, button.Label.Offset, 0)
								end

								--------------------------------

								button.Keybind:ClearAllPoints()
								button.Keybind:Hide()
							end
						else
							if button:GetHeight() <= 45 then
								button.Icon:ClearAllPoints()
								button.Icon:SetPoint("LEFT", button.Standalone.Background, NS.Variables:RATIO(1), 0)

								--------------------------------

								button.Label:SetWidth(200)

								if not button.Label.transition then
									button.Label.Offset = NS.Variables:RATIO(1) + NS.Variables:RATIO(1)

									--------------------------------

									button.Label:ClearAllPoints()
									button.Label:SetPoint("LEFT", button.Standalone.Background, button.Label.Offset, 0)
								end

								--------------------------------

								button.Keybind:ClearAllPoints()
								button.Keybind:SetPoint("LEFT", button.Standalone.Background, -(button.Keybind:GetWidth() / 3), 0)
							else
								button.Icon:ClearAllPoints()
								button.Icon:SetPoint("TOPLEFT", button.Standalone.Background, NS.Variables:RATIO(1.5) + NS.Variables:RATIO(.5), -NS.Variables:RATIO(1))

								--------------------------------

								button.Label:SetWidth(200)

								if not button.Label.transition then
									button.Label.Offset = NS.Variables:RATIO(1.5) + NS.Variables:RATIO(.5) + NS.Variables:RATIO(1.25)

									--------------------------------

									button.Label:ClearAllPoints()
									button.Label:SetPoint("LEFT", button.Standalone.Background, button.Label.Offset, 0)
								end

								--------------------------------

								button.Keybind:ClearAllPoints()
								button.Keybind:SetPoint("TOPLEFT", button.Standalone.Background, NS.Variables:RATIO(1.5), -NS.Variables:RATIO(1.5))
							end
						end
					end

					do -- ANIMATION
						button.Enter = function(skipAnimation)
							if button.selected then
								return
							end

							--------------------------------

							if not button.transition then
								button.HideButtons()
							end

							--------------------------------

							button.selected = true

							--------------------------------

							Frame.UpdateAllButtonStates()

							--------------------------------

							if not skipAnimation then
								button.AnimationState = "Enter"
								addon.Libraries.AceTimer:ScheduleTimer(function()
									if button.AnimationState == "Enter" then
										button.AnimationState = nil
									end
								end, 1)

								--------------------------------

								-- do -- TEXT
								-- 	AdaptiveAPI.Animation:PreciseMove(button.Label, 1, button, "LEFT", button.Label.Offset, 0, button.Label.Offset + 7.5, 0, AdaptiveAPI.Animation.EaseExpo, function() return not button.selected end)
								-- end

								do -- BUTTON
									AdaptiveAPI.Animation:Fade(button, .05, .75, 1, nil, function() return not button.selected end)
								end

								do -- STATE
									local transitionID = GetTime()
									button.Label.transition = true
									button.Label.transitionID = transitionID

									addon.Libraries.AceTimer:ScheduleTimer(function()
										if button.Label.transitionID == transitionID then
											button.Label.transition = false
										end
									end, 1)
								end
							else
								-- do -- TEXT
								-- 	button.Label:SetPoint("LEFT", button, button.Label.Offset + 7.5, 0)
								-- end

								do -- BUTTON
									button:SetAlpha(1)
								end

								do -- STATE
									button.Label.transition = false
								end
							end

							--------------------------------

							CallbackRegistry:Trigger("GOSSIP_BUTTON_ENTER")
						end

						button.Leave = function(skipAnimation)
							local State = NS.Variables.State

							--------------------------------

							button.selected = false

							--------------------------------

							Frame.UpdateAllButtonStates()

							--------------------------------

							if not skipAnimation then
								button.AnimationState = "Leave"
								addon.Libraries.AceTimer:ScheduleTimer(function()
									if button.AnimationState == "Leave" then
										button.AnimationState = nil
									end
								end, 1)

								--------------------------------

								-- do -- TEXT
								-- 	AdaptiveAPI.Animation:PreciseMove(button.Label, 1, button, "LEFT", button.Label.Offset + 7.5, 0, button.Label.Offset, 0, AdaptiveAPI.Animation.EaseExpo, function() return button.selected end)
								-- end

								do -- BUTTON
									AdaptiveAPI.Animation:Fade(button, .05, 1, 1, nil, function() return button.selected end)
								end

								do -- STATE
									local transitionID = GetTime()
									button.Label.transition = true
									button.Label.transitionID = transitionID

									addon.Libraries.AceTimer:ScheduleTimer(function()
										if button.Label.transitionID == transitionID then
											button.Label.transition = false
										end
									end, 1)
								end
							else
								-- do -- TEXT
								-- 	button.Label:SetPoint("LEFT", button, button.Label.Offset, 0)
								-- end

								do -- BUTTON
									button:SetAlpha(1)
								end

								do -- STATE
									button.Label.transition = false
								end
							end

							--------------------------------

							CallbackRegistry:Trigger("GOSSIP_BUTTON_LEAVE")
						end

						button.MouseDown = function(skipAnimation)
							if not skipAnimation then
								AdaptiveAPI.Animation:Fade(button, .125, 1, .75)
							else
								button:SetAlpha(.75)
							end
						end

						button.HideButtons = function()
							local Buttons = Frame.GetButtons()

							--------------------------------

							if Buttons then
								for i = 1, #Buttons do
									Buttons[i].Leave(true)
								end
							end
						end

						--------------------------------

						button.Standalone.Background.AdaptiveAPI_Animation_Parallax_Weight = 2.5
						AdaptiveAPI.Animation:AddParallax(button.Standalone.Background, button, function() return true end, function() return button.selected end, addon.Input.Variables.IsController)

						--------------------------------

						button.selected = false
						button:SetAlpha(1)
					end

					do -- EVENTS
						local function UpdateControllerKeybind()
							if button.selected and button:IsVisible() then
								if addon.Input.Variables.IsController then
									if button.Keybind_Controller:GetAlpha() == 0 then
										AdaptiveAPI.Animation:Fade(button.Keybind_Controller, .25, 0, 1)
										AdaptiveAPI.Animation:Scale(button.Keybind_Controller, .5, .5, 1)
									end
								else
									button.Keybind_Controller:SetAlpha(0)
								end
							else
								button.Keybind_Controller:SetAlpha(0)
							end
						end

						UpdateControllerKeybind()

						--------------------------------

						CallbackRegistry:Add("GOSSIP_BUTTON_ENTER", UpdateControllerKeybind)
						CallbackRegistry:Add("GOSSIP_BUTTON_LEAVE", UpdateControllerKeybind)
					end

					--------------------------------

					return button
				end

				--------------------------------

				local spacing = NS.Variables.BUTTON_SPACING
				local buttons = {}

				for i = 1, 18 do
					local button

					if i > 1 then
						local LastButton = buttons[i - 1]

						button = CreateButton(Frame.Content,
							function()
								return -(LastButton:GetHeight() + spacing)
							end,
							LastButton)
					else
						button = CreateButton(Frame.Content,
							function()
								return 0
							end,
							Frame.Content)
					end

					button.Label:SetText("Text")
					button.Keybind.Label:SetText(i .. ".")

					--------------------------------

					table.insert(buttons, button)
				end

				Frame.Buttons = buttons
			end
		end
	end

	--------------------------------
	-- REFERENCES
	--------------------------------

	local Frame = InteractionGossipFrame
	local Callback = NS.Script

	--------------------------------
	-- SETUP
	--------------------------------

	do
		Frame:SetAlpha(0)
		Frame:Hide()
		Frame.hidden = true
	end
end
