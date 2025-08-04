-- [!] [addon.Interaction.Dialog] is a custom frame to display quest/gossip text in a chat-bubble format.
-- [Dialog_Elements.lua] creates the front-end (UI)
-- for the addon.Interaction.Dialog module.

---@class addon
local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local PrefabRegistry = addon.PrefabRegistry
local L = addon.Locales
local NS = addon.Interaction.Dialog; addon.Interaction.Dialog = NS

--------------------------------

NS.Elements = {}

--------------------------------

function NS.Elements:Load()
	--------------------------------
	-- CREATE ELEMENTS
	--------------------------------

	do
		do -- ELEMENTS
			InteractionFrame.DialogFrame = CreateFrame("Frame", "$parent.DialogFrame", InteractionFrame)
			InteractionFrame.DialogFrame:SetFrameStrata(NS.Variables.FRAME_STRATA)
			InteractionFrame.DialogFrame:SetFrameLevel(NS.Variables.FRAME_LEVEL + 2)

			local Frame = InteractionFrame.DialogFrame

			--------------------------------

			local PADDING = NS.Variables.PADDING
			local PADDING_MOUSERESPONDER = 37.5
			local PADDING_BACKGROUND_DIALOG = 42.5
			local PADDING_BACKGROUND_SCROLL = 42.5
			local PADDING_BACKGROUND_RUSTIC = 30
			local PADDING_BACKGROUND_EMOTE = 30

			do -- MOUSE RESPONDER
				Frame.MouseResponder = CreateFrame("Frame", "$parent.MouseResponder", Frame)
				Frame.MouseResponder:SetPoint("CENTER", Frame)
				Frame.MouseResponder:SetFrameStrata(NS.Variables.FRAME_STRATA)
				Frame.MouseResponder:SetFrameLevel(NS.Variables.FRAME_LEVEL_MAX)
				addon.API.FrameUtil:SetDynamicSize(Frame.MouseResponder, Frame, -PADDING_MOUSERESPONDER, -PADDING_MOUSERESPONDER)
			end

			do -- BACKGROUND
				Frame.Background = CreateFrame("Frame", "$parent.Background", Frame)
				Frame.Background:SetPoint("CENTER", Frame)
				Frame.Background:SetFrameStrata(NS.Variables.FRAME_STRATA)
				Frame.Background:SetFrameLevel(NS.Variables.FRAME_LEVEL)
				addon.API.FrameUtil:SetDynamicSize(Frame.Background, Frame, 0, 0)

				local Background = Frame.Background

				--------------------------------

				do -- STYLE (DIALOG)
					Background.Style_Dialog = CreateFrame("Frame", "$parent.Style_Dialog", Background)
					Background.Style_Dialog:SetPoint("CENTER", Background)
					Background.Style_Dialog:SetFrameStrata(NS.Variables.FRAME_STRATA)
					Background.Style_Dialog:SetFrameLevel(NS.Variables.FRAME_LEVEL + 1)
					addon.API.FrameUtil:SetDynamicSize(Background.Style_Dialog, Background, -PADDING_BACKGROUND_DIALOG, -PADDING_BACKGROUND_DIALOG)

					local Style_Dialog = Background.Style_Dialog

					--------------------------------

					do -- BACKGROUND
						Style_Dialog.Background, Style_Dialog.BackgroundTexture = addon.API.FrameTemplates:CreateNineSlice(Style_Dialog, NS.Variables.FRAME_STRATA, nil, 50, .575, "$parent.Background")
						Style_Dialog.Background:SetPoint("CENTER", Style_Dialog, 0, 0)
						Style_Dialog.Background:SetFrameStrata(NS.Variables.FRAME_STRATA)
						Style_Dialog.Background:SetFrameLevel(NS.Variables.FRAME_LEVEL + 2)
						addon.API.FrameUtil:SetDynamicSize(Style_Dialog.Background, Style_Dialog, 0, 0)

						--------------------------------

						do -- THEME
							addon.API.Main:RegisterThemeUpdate(function()
								local TooltipTexture
								local Color

								if addon.LoadedAddons.ElvUI then
									TooltipTexture = addon.Support.ElvUI.Variables.DIALOG_BACKGROUND
									Color = addon.Theme.RGB_CHAT_MSG_SAY
								else
									if addon.Theme.IsDarkTheme_Dialog then
										TooltipTexture = addon.API.Presets.NINESLICE_TOOLTIP_02
									else
										TooltipTexture = addon.API.Presets.NINESLICE_TOOLTIP
									end

									Color = addon.Theme.RGB_WHITE
								end

								Style_Dialog.BackgroundTexture:SetTexture(TooltipTexture)
								Style_Dialog.BackgroundTexture:SetVertexColor(Color.r, Color.g, Color.b, Color.a or 1)
							end, 5)
						end
					end

					do -- TAIL
						Style_Dialog.Tail, Style_Dialog.TailTexture = addon.API.FrameTemplates:CreateTexture(Style_Dialog, NS.Variables.FRAME_STRATA, nil, "$parent.Tail")
						Style_Dialog.Tail:SetSize(22, 22 * 1.07)
						Style_Dialog.Tail:SetPoint("BOTTOM", Style_Dialog.Background, -10, -17)
						Style_Dialog.Tail:SetFrameStrata(NS.Variables.FRAME_STRATA)
						Style_Dialog.Tail:SetFrameLevel(NS.Variables.FRAME_LEVEL + 3)

						--------------------------------

						do -- THEME
							addon.API.Main:RegisterThemeUpdate(function()
								local TEXTURE_Background

								if addon.LoadedAddons.ElvUI then
									TEXTURE_Background = nil
								else
									if addon.Theme.IsDarkTheme_Dialog then
										TEXTURE_Background = addon.Variables.PATH_ART .. "Dialog/tooltip-tail-dark.png"
									else
										TEXTURE_Background = addon.Variables.PATH_ART .. "Dialog/tooltip-tail-light.png"
									end
								end

								Style_Dialog.TailTexture:SetTexture(TEXTURE_Background)
							end, 5)
						end
					end
				end

				do -- STYLE (SCROLL)
					Background.Style_Scroll = CreateFrame("Frame", "$parent.Style_Scroll", Background)
					Background.Style_Scroll:SetPoint("CENTER", Background)
					Background.Style_Scroll:SetFrameStrata(NS.Variables.FRAME_STRATA)
					Background.Style_Scroll:SetFrameLevel(NS.Variables.FRAME_LEVEL + 1)
					addon.API.FrameUtil:SetDynamicSize(Background.Style_Scroll, Background, -PADDING_BACKGROUND_SCROLL, -PADDING_BACKGROUND_SCROLL)

					local Style_Scroll = Background.Style_Scroll

					--------------------------------

					do -- BACKGROUND
						Style_Scroll.Background, Style_Scroll.BackgroundTexture = addon.API.FrameTemplates:CreateNineSlice(Style_Scroll, NS.Variables.FRAME_STRATA, nil, 128, .25, "$parent.Background")
						Style_Scroll.Background:SetPoint("CENTER", Style_Scroll)
						Style_Scroll.Background:SetFrameStrata(NS.Variables.FRAME_STRATA)
						Style_Scroll.Background:SetFrameLevel(NS.Variables.FRAME_LEVEL + 2)
						addon.API.FrameUtil:SetDynamicSize(Style_Scroll.Background, Style_Scroll, -6.5, -6.5)

						--------------------------------

						do -- THEME
							addon.API.Main:RegisterThemeUpdate(function()
								local ScrollTexture

								if addon.Theme.IsDarkTheme_Dialog or addon.Theme.IsRusticTheme_Dialog then
									ScrollTexture = addon.API.Presets.NINESLICE_STYLISED_SCROLL_02
								else
									ScrollTexture = addon.API.Presets.NINESLICE_STYLISED_SCROLL
								end

								Style_Scroll.BackgroundTexture:SetTexture(ScrollTexture)
							end, 5)
						end
					end
				end

				do -- STYLE (RUSTIC)
					Background.Style_Rustic = CreateFrame("Frame", "$parent.Style_Rustic", Background)
					Background.Style_Rustic:SetPoint("CENTER", Background)
					Background.Style_Rustic:SetFrameStrata(NS.Variables.FRAME_STRATA)
					Background.Style_Rustic:SetFrameLevel(NS.Variables.FRAME_LEVEL + 1)
					addon.API.FrameUtil:SetDynamicSize(Background.Style_Rustic, Background, -PADDING_BACKGROUND_RUSTIC, -PADDING_BACKGROUND_RUSTIC)

					local Style_Rustic = Background.Style_Rustic

					--------------------------------

					do -- BACKGROUND
						Style_Rustic.Background, Style_Rustic.BackgroundTexture = addon.API.FrameTemplates:CreateNineSlice(Style_Rustic, NS.Variables.FRAME_STRATA, addon.Variables.PATH_ART .. "Gradient/backdrop-nineslice.png", 128, .5, "$parent.Background")
						Style_Rustic.Background:SetPoint("CENTER", Frame)
						Style_Rustic.Background:SetFrameStrata(NS.Variables.FRAME_STRATA)
						Style_Rustic.Background:SetFrameLevel(NS.Variables.FRAME_LEVEL + 2)
						Style_Rustic.BackgroundTexture:SetAlpha(.875)
						addon.API.FrameUtil:SetDynamicSize(Style_Rustic.Background, Style_Rustic, -55, -55)
					end
				end

				do -- STYLE (EMOTE)
					Background.Style_Emote = CreateFrame("Frame", "$parent.Style_Emote", Background)
					Background.Style_Emote:SetPoint("CENTER", Background)
					Background.Style_Emote:SetFrameStrata(NS.Variables.FRAME_STRATA)
					Background.Style_Emote:SetFrameLevel(NS.Variables.FRAME_LEVEL + 1)
					addon.API.FrameUtil:SetDynamicSize(Background.Style_Emote, Background, -PADDING_BACKGROUND_EMOTE, -PADDING_BACKGROUND_EMOTE)

					local Style_Emote = Background.Style_Emote

					--------------------------------

					do -- BACKGROUND
						Style_Emote.Background, Style_Emote.BackgroundTexture = addon.API.FrameTemplates:CreateNineSlice(Style_Emote, NS.Variables.FRAME_STRATA, addon.Variables.PATH_ART .. "Gradient/backdrop-nineslice.png", 128, .5, "$parent.Background")
						Style_Emote.Background:SetPoint("CENTER", Frame)
						Style_Emote.Background:SetFrameStrata(NS.Variables.FRAME_STRATA)
						Style_Emote.Background:SetFrameLevel(NS.Variables.FRAME_LEVEL + 2)
						Style_Emote.BackgroundTexture:SetAlpha(.875)
						addon.API.FrameUtil:SetDynamicSize(Style_Emote.Background, Style_Emote, -55, -55)
					end
				end
			end

			do -- TITLE
				Frame.Title = CreateFrame("Frame", "$parent.Title", Frame)
				Frame.Title:SetPoint("BOTTOM", Frame, "TOP", 0, 30)
				Frame.Title:SetFrameStrata(NS.Variables.FRAME_STRATA)
				Frame.Title:SetFrameLevel(NS.Variables.FRAME_LEVEL)

				local Title = Frame.Title

				--------------------------------

				do -- LAYOUT GROUP
					Title.LayoutGroup, Title.LayoutGroup_Sort = addon.API.FrameTemplates:CreateLayoutGroup(Title, { point = "TOP", direction = "vertical", resize = true, padding = 7.5, distribute = false, distributeResizeElements = false, excludeHidden = true, autoSort = true, customOffset = nil, customLayoutSort = nil }, "$parent.LayoutGroup")
					Title.LayoutGroup:SetPoint("CENTER", Title, 0, 0)
					Title.LayoutGroup:SetFrameStrata(NS.Variables.FRAME_STRATA)
					Title.LayoutGroup:SetFrameLevel(NS.Variables.FRAME_LEVEL + 1)
					addon.API.FrameUtil:SetDynamicSize(Title.LayoutGroup, Title, 0, nil)
					addon.API.FrameUtil:SetDynamicSize(Title, Title.LayoutGroup, nil, 0)
					CallbackRegistry:Add("LayoutGroupSort Dialog.Title", Title.LayoutGroup_Sort)

					local LayoutGroup = Title.LayoutGroup

					--------------------------------

					do -- ELEMENTS
						local FRAME_PROGRESSBAR_HEIGHT = NS.Variables:RATIO(5.25)

						--------------------------------

						do -- PREFIX FRAME
							LayoutGroup.PrefixFrame = CreateFrame("Frame", "$parent.PrefixFrame", LayoutGroup)
							LayoutGroup.PrefixFrame:SetFrameStrata(NS.Variables.FRAME_STRATA)
							LayoutGroup.PrefixFrame:SetFrameLevel(NS.Variables.FRAME_LEVEL + 2)
							addon.API.FrameUtil:SetDynamicSize(LayoutGroup.PrefixFrame, LayoutGroup, 0, nil)
							LayoutGroup:AddElement(LayoutGroup.PrefixFrame)

							local PrefixFrame = LayoutGroup.PrefixFrame

							--------------------------------

							do -- TEXT
								PrefixFrame.Text = addon.API.FrameTemplates:CreateText(PrefixFrame, addon.Theme.RGB_WHITE, 12.5, "CENTER", "MIDDLE", addon.API.Fonts.CONTENT_LIGHT, "$parent.Text")
								PrefixFrame.Text:SetPoint("CENTER", PrefixFrame)
								PrefixFrame.Text.targetAlpha = .5 -- Animation reference parameter in ShowWithAnimation.
								addon.API.FrameUtil:SetDynamicTextSize(PrefixFrame.Text, PrefixFrame, 10000, nil)
								addon.API.FrameUtil:SetDynamicSize(PrefixFrame, PrefixFrame.Text, nil, 0)
							end
						end

						do -- TITLE FRAME
							LayoutGroup.TitleFrame = CreateFrame("Frame", "$parent.TitleFrame", LayoutGroup)
							LayoutGroup.TitleFrame:SetFrameStrata(NS.Variables.FRAME_STRATA)
							LayoutGroup.TitleFrame:SetFrameLevel(NS.Variables.FRAME_LEVEL + 2)
							addon.API.FrameUtil:SetDynamicSize(LayoutGroup.TitleFrame, LayoutGroup, 0, nil)
							LayoutGroup:AddElement(LayoutGroup.TitleFrame)

							local TitleFrame = LayoutGroup.TitleFrame

							--------------------------------

							do -- TEXT
								TitleFrame.Text = addon.API.FrameTemplates:CreateText(TitleFrame, addon.Theme.RGB_WHITE, 15, "CENTER", "MIDDLE", addon.API.Fonts.CONTENT_LIGHT, "$parent.Text")
								TitleFrame.Text:SetPoint("CENTER", TitleFrame)
								addon.API.FrameUtil:SetDynamicTextSize(TitleFrame.Text, TitleFrame, 10000, nil)
								addon.API.FrameUtil:SetDynamicSize(TitleFrame, TitleFrame.Text, nil, 0)
								addon.API.FrameUtil:SetDynamicSize(Title, TitleFrame.Text, 0, nil)
							end
						end

						do -- PROGRESS
							LayoutGroup.Progress = CreateFrame("Frame", "$parent.Progress", LayoutGroup)
							LayoutGroup.Progress:SetHeight(FRAME_PROGRESSBAR_HEIGHT)
							LayoutGroup.Progress:SetFrameStrata(NS.Variables.FRAME_STRATA)
							LayoutGroup.Progress:SetFrameLevel(NS.Variables.FRAME_LEVEL + 3)
							addon.API.FrameUtil:SetDynamicSize(LayoutGroup.Progress, LayoutGroup, 0, nil)
							LayoutGroup:AddElement(LayoutGroup.Progress)

							local Progress = LayoutGroup.Progress

							--------------------------------

							do -- ELEMENTS
								do -- BACKGROUND
									Progress.Background, Progress.BackgroundTexture = addon.API.FrameTemplates:CreateNineSlice(Progress, NS.Variables.FRAME_STRATA, addon.API.Presets.BASIC_SQUARE, 25, 1, "$parent.Progress")
									Progress.Background:SetPoint("CENTER", Progress)
									Progress.Background:SetFrameStrata(NS.Variables.FRAME_STRATA)
									Progress.Background:SetFrameLevel(NS.Variables.FRAME_LEVEL + 4)
									Progress.BackgroundTexture:SetVertexColor(.1, .1, .1, .25)
									addon.API.FrameUtil:SetDynamicSize(Progress.Background, Progress, -5, -5)
								end

								do -- BAR
									Progress.Bar = CreateFrame("StatusBar", "$parent.Bar", Progress)
									Progress.Bar:SetPoint("CENTER", Progress, 0, 0)
									Progress.Bar:SetStatusBarTexture(addon.API.Presets.BASIC_SQUARE)
									Progress.Bar:SetStatusBarColor(.5, .5, .5, 1)
									Progress.Bar:SetFrameStrata(NS.Variables.FRAME_STRATA)
									Progress.Bar:SetFrameLevel(NS.Variables.FRAME_LEVEL + 5)
									addon.API.FrameUtil:SetDynamicSize(Progress.Bar, Progress, 0, 0)
								end
							end

							do -- ANIMATIONS
								do -- ON ENTER
									function Progress:Animation_OnEnter_StopEvent()
										return not Progress.isMouseOver
									end

									function Progress:Animation_OnEnter(skipAnimation)
										Progress.Background:SetVertexColor(.25, .25, .25, .75)
									end
								end

								do -- ON LEAVE
									function Progress:Animation_OnLeave_StopEvent()
										return Progress.isMouseOver
									end

									function Progress:Animation_OnLeave(skipAnimation)
										Progress.BackgroundTexture:SetVertexColor(.1, .1, .1, .75)
									end
								end

								do -- ON MOUSE DOWN
									function Progress:Animation_OnMouseDown_StopEvent()
										return not Progress.isMouseDown
									end

									function Progress:Animation_OnMouseDown(skipAnimation)

									end
								end

								do -- ON MOUSE UP
									function Progress:Animation_OnMouseUp_StopEvent()
										return Progress.isMouseDown
									end

									function Progress:Animation_OnMouseUp(skipAnimation)

									end
								end
							end

							do -- LOGIC
								Progress.isMouseOver = false
								Progress.isMouseDown = false

								Progress.enterCallbacks = {}
								Progress.leaveCallbacks = {}
								Progress.mouseDownCallbacks = {}
								Progress.mouseUpCallbacks = {}

								--------------------------------

								do -- FUNCTIONS

								end

								do -- EVENTS
									function Progress:OnEnter(skipAnimation)
										Progress.isMouseOver = true

										--------------------------------

										Progress:Animation_OnEnter(skipAnimation)

										--------------------------------

										do -- ON ENTER
											if #Progress.enterCallbacks >= 1 then
												local enterCallbacks = Progress.enterCallbacks

												for callback = 1, #enterCallbacks do
													enterCallbacks[callback](skipAnimation)
												end
											end
										end
									end

									function Progress:OnLeave(skipAnimation)
										Progress.isMouseOver = false

										--------------------------------

										Progress:Animation_OnLeave(skipAnimation)

										--------------------------------

										do -- ON LEAVE
											if #Progress.leaveCallbacks >= 1 then
												local leaveCallbacks = Progress.leaveCallbacks

												for callback = 1, #leaveCallbacks do
													leaveCallbacks[callback](skipAnimation)
												end
											end
										end
									end

									function Progress:OnMouseDown(skipAnimation)
										Progress.isMouseDown = true

										--------------------------------

										Progress:Animation_OnMouseDown(skipAnimation)

										--------------------------------

										do -- ON MOUSE DOWN
											if #Progress.mouseDownCallbacks >= 1 then
												local mouseDownCallbacks = Progress.mouseDownCallbacks

												for callback = 1, #mouseDownCallbacks do
													mouseDownCallbacks[callback](skipAnimation)
												end
											end
										end
									end

									function Progress:OnMouseUp(skipAnimation)
										Progress.isMouseDown = false

										--------------------------------

										Progress:Animation_OnMouseUp(skipAnimation)

										--------------------------------

										do -- ON MOUSE UP
											if #Progress.mouseUpCallbacks >= 1 then
												local mouseUpCallbacks = Progress.mouseUpCallbacks

												for callback = 1, #mouseUpCallbacks do
													mouseUpCallbacks[callback](skipAnimation)
												end
											end
										end
									end

									addon.API.FrameTemplates:CreateMouseResponder(Progress, { enterCallback = Frame.OnEnter, leaveCallback = Frame.OnLeave, mouseDownCallback = Frame.OnMouseDown, mouseUpCallback = Frame.OnMouseUp })
								end
							end

							do -- SETUP
								Progress:OnLeave(true)
							end
						end
					end
				end
			end

			do -- CLIP
				Frame.Clip = CreateFrame("Frame", "$parent.Clip", Frame)
				Frame.Clip:SetPoint("CENTER", Frame)
				Frame.Clip:SetFrameStrata(NS.Variables.FRAME_STRATA)
				Frame.Clip:SetFrameLevel(NS.Variables.FRAME_LEVEL + 5)
				addon.API.FrameUtil:SetDynamicSize(Frame.Clip, Frame, 0, 0)
			end

			do -- CONTENT
				Frame.Content = CreateFrame("Frame", "$parent.Content", Frame)
				Frame.Content:SetPoint("TOPLEFT", Frame.Clip, 0, 0)
				Frame.Content:SetPoint("BOTTOMRIGHT", Frame.Clip, 0, 0)
				Frame.Content:SetFrameStrata(NS.Variables.FRAME_STRATA)
				Frame.Content:SetFrameLevel(NS.Variables.FRAME_LEVEL + 5)
				Frame.Content:SetClipsChildren(true)

				local Content = Frame.Content

				--------------------------------

				do -- TEXT
					local FRAME_TEXT_WIDTH = NS.Variables.FRAME_MAX_WIDTH
					local TEXT_SIZE = addon.Database.DB_GLOBAL.profile.INT_CONTENT_SIZE

					--------------------------------

					Content.Text = addon.API.FrameTemplates:CreateText(Frame.Content, addon.Theme.RGB_WHITE, TEXT_SIZE, "LEFT", "TOP", addon.API.Fonts.CONTENT_LIGHT)
					Content.Text:SetPoint("CENTER", Content, 0, 0)
					Content.Text:SetShadowOffset(0, 0)
					CallbackRegistry:Add("UpdateDynamicTextSize Dialog.Content.Text", addon.API.FrameUtil:SetDynamicTextSize(Content.Text, Content, FRAME_TEXT_WIDTH, nil))
					addon.API.FrameUtil:SetDynamicSize(Frame, Content.Text, -PADDING, -PADDING)
				end
			end
		end

		do -- REFERENCES
			local Frame = InteractionFrame.DialogFrame

			--------------------------------

			-- CORE
			Frame.REF_MOUSE_RESPONDER = Frame.MouseResponder
			Frame.REF_BACKGROUND = Frame.Background
			Frame.REF_TITLE = Frame.Title
			Frame.REF_CLIP = Frame.Clip
			Frame.REF_CONTENT = Frame.Content

			-- BACKGROUND
			Frame.REF_BACKGROUND_DIALOG = Frame.REF_BACKGROUND.Style_Dialog
			Frame.REF_BACKGROUND_DIALOG_TAIL = Frame.REF_BACKGROUND.Style_Dialog.Tail
			Frame.REF_BACKGROUND_SCROLL = Frame.REF_BACKGROUND.Style_Scroll
			Frame.REF_BACKGROUND_RUSTIC = Frame.REF_BACKGROUND.Style_Rustic
			Frame.REF_BACKGROUND_EMOTE = Frame.REF_BACKGROUND.Style_Emote

			-- TITLE
			Frame.REF_TITLE_PREFIXFRAME = Frame.REF_TITLE.LayoutGroup.PrefixFrame
			Frame.REF_TITLE_PREFIXFRAME_TEXT = Frame.REF_TITLE_PREFIXFRAME.Text
			Frame.REF_TITLE_TITLEFRAME = Frame.REF_TITLE.LayoutGroup.TitleFrame
			Frame.REF_TITLE_TITLEFRAME_TEXT = Frame.REF_TITLE_TITLEFRAME.Text
			Frame.REF_TITLE_PROGRESS = Frame.REF_TITLE.LayoutGroup.Progress
			Frame.REF_TITLE_PROGRESS_BAR = Frame.REF_TITLE_PROGRESS.Bar

			-- CONTENT
			Frame.REF_CONTENT_TEXT = Frame.REF_CONTENT.Text
		end
	end

	--------------------------------
	-- REFERENCES
	--------------------------------

	local Frame = InteractionFrame.DialogFrame
	local Callback = NS.Script; NS.Script = Callback

	--------------------------------
	-- SETUP
	--------------------------------

	do
		Frame:Hide()
		Frame.hidden = true
	end
end
