-- [!] [addon.Interaction.Quest.Target] is a module for [addon.Interaction.Quest]
-- [QuestTarget_Elements.lua] is the front-end (UI)
-- for the module.

---@class addon
local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local PrefabRegistry = addon.PrefabRegistry
local L = addon.Locales
local NS = addon.Interaction.Quest.Target; addon.Interaction.Quest.Target = NS

--------------------------------

NS.Elements = {}

--------------------------------

function NS.Elements:Load()
	--------------------------------
	-- CREATE ELEMENTS
	--------------------------------

	do
		do -- ELEMENTS
			InteractionFrame.QuestFrame.Target = CreateFrame("Frame", "$parent.Target", InteractionFrame.QuestFrame)
			InteractionFrame.QuestFrame.Target:SetWidth(NS.Variables:RATIO(3))
			InteractionFrame.QuestFrame.Target:SetPoint("TOPLEFT", InteractionFrame.QuestFrame, -(InteractionFrame.QuestFrame.Target:GetWidth() / 2 + NS.Variables:RATIO(4)), -75)
			InteractionFrame.QuestFrame.Target:SetFrameStrata(NS.Variables.FRAME_STRATA)
			InteractionFrame.QuestFrame.Target:SetFrameLevel(NS.Variables.FRAME_LEVEL + 1)

            local Frame = InteractionFrame.QuestFrame.Target

			--------------------------------

			local PADDING = NS.Variables.PADDING
			local FRAME_CONTENT_INSET = PADDING * 3
			local FRAME_MODEL_INSET = PADDING

			do -- BACKGROUND
				Frame.Background, Frame.BackgroundTexture = addon.API.FrameTemplates:CreateNineSlice(Frame, NS.Variables.FRAME_STRATA, nil, 128, .75, "$parent.Background")
				Frame.Background:SetPoint("TOPLEFT", Frame, -37.5, 37.5)
				Frame.Background:SetPoint("BOTTOMRIGHT", Frame, 37.5, -37.5)
				Frame.Background:SetFrameStrata(NS.Variables.FRAME_STRATA)
				Frame.Background:SetFrameLevel(NS.Variables.FRAME_LEVEL)
				Frame.BackgroundTexture:SetAllPoints(Frame.Background, true)
				Frame.BackgroundTexture:SetVertexColor(1, 1, 1)

				--------------------------------

				do -- THEME
					addon.API.Main:RegisterThemeUpdate(function()
						local BackgroundTexture

						if addon.Theme.IsDarkTheme then
							BackgroundTexture = NS.Variables.PATH .. "background-dark.png"
						else
							BackgroundTexture = NS.Variables.PATH .. "background.png"
						end

						Frame.BackgroundTexture:SetTexture(BackgroundTexture)
					end, 5)
				end
			end

			do -- CONTENT
				Frame.Content = CreateFrame("Frame", "$parent.Content", Frame)
				Frame.Content:SetPoint("CENTER", Frame)
				Frame.Content:SetFrameStrata(NS.Variables.FRAME_STRATA)
				Frame.Content:SetFrameLevel(NS.Variables.FRAME_LEVEL + 2)
				addon.API.FrameUtil:SetDynamicSize(Frame.Content, Frame, FRAME_CONTENT_INSET, FRAME_CONTENT_INSET)

				local Content = Frame.Content

				----------------------------------

				do -- LAYOUT GROUP
					Content.LayoutGroup, Content.LayoutGroup_Sort = addon.API.FrameTemplates:CreateLayoutGroup(Content, { point = "TOP", direction = "vertical", resize = true, padding = PADDING, distribute = false, distributeResizeElements = false, excludeHidden = true, autoSort = true, customOffset = nil, customLayoutSort = nil }, "$parent.LayoutGroup")
					Content.LayoutGroup:SetPoint("CENTER", Content)
					Content.LayoutGroup:SetFrameStrata(NS.Variables.FRAME_STRATA)
					Content.LayoutGroup:SetFrameLevel(NS.Variables.FRAME_LEVEL + 3)
					addon.API.FrameUtil:SetDynamicSize(Content.LayoutGroup, Content, 0, nil)
					CallbackRegistry:Add("UpdateDynamicSize QuestTarget", addon.API.FrameUtil:SetDynamicSize(Frame, Content.LayoutGroup, nil, -FRAME_CONTENT_INSET))
					CallbackRegistry:Add("LayoutGroupSort QuestTarget.Content", Content.LayoutGroup_Sort)

					local LayoutGroup = Content.LayoutGroup

					----------------------------------

					do -- ELEMENTS
						do -- MODEL FRAME
							LayoutGroup.ModelFrame = CreateFrame("Frame", "$parent.ModelFrame", LayoutGroup)
							LayoutGroup.ModelFrame:SetFrameStrata(NS.Variables.FRAME_STRATA)
							LayoutGroup.ModelFrame:SetFrameLevel(NS.Variables.FRAME_LEVEL + 4)
							addon.API.FrameUtil:SetDynamicSize(LayoutGroup.ModelFrame, LayoutGroup, function(relativeWidth, relativeHeight) return relativeWidth end, function(relativeWidth, relativeHeight) return relativeWidth end)
							LayoutGroup:AddElement(LayoutGroup.ModelFrame)

							local ModelFrame = LayoutGroup.ModelFrame

							----------------------------------

							do -- BACKGROUND
								ModelFrame.Background, ModelFrame.BackgroundTexture = addon.API.FrameTemplates:CreateTexture(Frame, NS.Variables.FRAME_STRATA, nil, "$parent.Background")
								ModelFrame.Background:SetPoint("CENTER", ModelFrame)
								ModelFrame.Background:SetFrameStrata(NS.Variables.FRAME_STRATA)
								ModelFrame.Background:SetFrameLevel(NS.Variables.FRAME_LEVEL + 3)
								addon.API.FrameUtil:SetDynamicSize(ModelFrame.Background, ModelFrame, -7.5, -7.5)
								ModelFrame.BackgroundTexture:SetAlpha(1)

								--------------------------------

								do -- THEME
									addon.API.Main:RegisterThemeUpdate(function()
										local BackgroundTexture

										if addon.Theme.IsDarkTheme then
											BackgroundTexture = NS.Variables.PATH .. "model-border-dark.png"
										else
											BackgroundTexture = NS.Variables.PATH .. "model-border.png"
										end

										ModelFrame.BackgroundTexture:SetTexture(BackgroundTexture)
									end, 5)
								end
							end

							do -- MODEL
								ModelFrame.Model = CreateFrame("PlayerModel", "$parent.Model", ModelFrame)
								ModelFrame.Model:SetPoint("CENTER", ModelFrame)
								ModelFrame.Model:SetFrameStrata(NS.Variables.FRAME_STRATA)
								ModelFrame.Model:SetFrameLevel(NS.Variables.FRAME_LEVEL + 5)
								addon.API.FrameUtil:SetDynamicSize(ModelFrame.Model, ModelFrame, FRAME_MODEL_INSET, FRAME_MODEL_INSET)
							end
						end

						do -- TITLE FRAME
							LayoutGroup.TitleFrame = CreateFrame("Frame", "$parent.TitleFrame", LayoutGroup)
							LayoutGroup.TitleFrame:SetFrameStrata(NS.Variables.FRAME_STRATA)
							LayoutGroup.TitleFrame:SetFrameLevel(NS.Variables.FRAME_LEVEL + 4)
							addon.API.FrameUtil:SetDynamicSize(LayoutGroup.TitleFrame, LayoutGroup, 0, nil)
							LayoutGroup:AddElement(LayoutGroup.TitleFrame)

							local TitleFrame = LayoutGroup.TitleFrame

							----------------------------------

							do -- TEXT
								TitleFrame.Text = addon.API.FrameTemplates:CreateText(TitleFrame, addon.Theme.RGB_WHITE, 15, "LEFT", "TOP", addon.API.Fonts.CONTENT_LIGHT, "$parent.Text")
								TitleFrame.Text:SetPoint("CENTER", TitleFrame)
								addon.API.FrameUtil:SetDynamicTextSize(TitleFrame.Text, TitleFrame, function(relativeWidth, relativeHeight) return relativeWidth end, nil, true, nil)
								addon.API.FrameUtil:SetDynamicSize(TitleFrame, TitleFrame.Text, nil, 0)
							end
						end

						do -- DESCRIPTION FRAME
							LayoutGroup.DescriptionFrame = CreateFrame("Frame", "$parent.DescriptionFrame", LayoutGroup)
							LayoutGroup.DescriptionFrame:SetFrameStrata(NS.Variables.FRAME_STRATA)
							LayoutGroup.DescriptionFrame:SetFrameLevel(NS.Variables.FRAME_LEVEL + 4)
							addon.API.FrameUtil:SetDynamicSize(LayoutGroup.DescriptionFrame, LayoutGroup, 0, nil)
							LayoutGroup:AddElement(LayoutGroup.DescriptionFrame)

							local DescriptionFrame = LayoutGroup.DescriptionFrame

							----------------------------------

							do -- TEXT
								DescriptionFrame.Text = addon.API.FrameTemplates:CreateText(DescriptionFrame, addon.Theme.RGB_WHITE, 12, "LEFT", "TOP", addon.API.Fonts.CONTENT_LIGHT, "$parent.Text")
								DescriptionFrame.Text:SetPoint("CENTER", DescriptionFrame)
								DescriptionFrame.Text:SetAlpha(.75)
								addon.API.FrameUtil:SetDynamicTextSize(DescriptionFrame.Text, DescriptionFrame, function(relativeWidth, relativeHeight) return relativeWidth; end, nil, true, nil)
								addon.API.FrameUtil:SetDynamicSize(DescriptionFrame, DescriptionFrame.Text, nil, 0)
							end
						end
					end
				end
			end
		end

		do -- REFERENCES
			local Frame = InteractionFrame.QuestFrame.Target

			--------------------------------

			-- CORE
			Frame.REF_MODELFRAME = Frame.Content.LayoutGroup.ModelFrame
			Frame.REF_TITLEFRAME = Frame.Content.LayoutGroup.TitleFrame
			Frame.REF_DESCRIPTIONFRAME = Frame.Content.LayoutGroup.DescriptionFrame

			-- MODEL
			Frame.REF_MODELFRAME_MODEL = Frame.REF_MODELFRAME.Model

			-- TITLE
			Frame.REF_TITLEFRAME_TEXT = Frame.REF_TITLEFRAME.Text

			-- DESCRIPTION
			Frame.REF_DESCRIPTIONFRAME_TEXT = Frame.REF_DESCRIPTIONFRAME.Text
		end
	end

	--------------------------------
	-- REFERENCES
	--------------------------------

	local Frame = InteractionFrame.QuestFrame.Target
	local Callback = NS.Script; NS.Script = Callback

	--------------------------------
	-- SETUP
	--------------------------------

	do
		Frame.hidden = true
		Frame:Hide()
	end
end
