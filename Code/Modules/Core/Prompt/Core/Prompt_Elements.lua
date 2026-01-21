local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local TemplateRegistry = addon.TemplateRegistry
local L = addon.Locales
local NS = addon.Prompt; addon.Prompt = NS

NS.Elements = {}

function NS.Elements:Load()
	-- Create elements
	----------------------------------------------------------------------------------------------------

	do
		do -- Elements
			InteractionFrame.PromptFrame = CreateFrame("Frame", "$parent.PromptFrame", InteractionFrame)
			InteractionFrame.PromptFrame:SetWidth(350)
			InteractionFrame.PromptFrame:SetPoint("TOP", InteractionFrame, 0, -35)
			InteractionFrame.PromptFrame:SetFrameStrata(NS.Variables.FRAME_STRATA)
			InteractionFrame.PromptFrame:SetFrameLevel(NS.Variables.FRAME_LEVEL_MAX)

			local Frame = InteractionFrame.PromptFrame

			local PADDING = NS.Variables.PADDING
			local PADDING_BACKGROUND = NS.Variables:RATIO(4)
			local FRAME_BUTTON_HEIGHT = NS.Variables:RATIO(5)

			do -- Backdrop
				Frame.Backdrop, Frame.BackdropTexture = addon.API.FrameTemplates:CreateTexture(Frame, NS.Variables.FRAME_STRATA, addon.Variables.PATH_ART .. "Settings\\background-backdrop.png", "$parent.Backdrop.png")
				Frame.Backdrop:SetSize(500, 500)
				Frame.Backdrop:SetPoint("CENTER", Frame)
				Frame.Backdrop:SetFrameStrata(NS.Variables.FRAME_STRATA)
				Frame.Backdrop:SetFrameLevel(NS.Variables.FRAME_LEVEL_MAX - 2)
				Frame.Backdrop:SetAlpha(.5)
			end

			do -- Background
				Frame.Background, Frame.BackgroundTexture = addon.API.FrameTemplates:CreateNineSlice(Frame, NS.Variables.FRAME_STRATA, nil, 128, .575, "$parent.Background")
				Frame.Background:SetPoint("CENTER", Frame)
				Frame.Background:SetFrameStrata(NS.Variables.FRAME_STRATA)
				Frame.Background:SetFrameLevel(NS.Variables.FRAME_LEVEL_MAX - 1)
				addon.API.FrameUtil:SetDynamicSize(Frame.Background, Frame, -PADDING_BACKGROUND, -PADDING_BACKGROUND)

				do -- Theme
					addon.API.Main:RegisterThemeUpdate(function()
						local TEXTURE_Background

						if addon.Theme.IsDarkTheme then
							TEXTURE_Background = addon.API.Presets.NINESLICE_STYLIZED_SCROLL_02
						else
							TEXTURE_Background = addon.API.Presets.NINESLICE_STYLIZED_SCROLL
						end

						Frame.BackgroundTexture:SetTexture(TEXTURE_Background)
					end, 5)
				end
			end

			do -- Content
				Frame.Content = CreateFrame("Frame", "$parent.Content", Frame)
				Frame.Content:SetPoint("CENTER", Frame)
				Frame.Content:SetFrameStrata(NS.Variables.FRAME_STRATA)
				Frame.Content:SetFrameLevel(NS.Variables.FRAME_LEVEL_MAX + 1)
				addon.API.FrameUtil:SetDynamicSize(Frame.Content, Frame, 0, 0)

				local Content = Frame.Content

				do -- Layout group
					Content.LayoutGroup, Content.LayoutGroup_Sort = addon.API.FrameTemplates:CreateLayoutGroup(Content, { point = "TOP", direction = "vertical", resize = true, padding = PADDING, distribute = false, distributeResizeElements = false, excludeHidden = true, autoSort = true, customOffset = nil, customLayoutSort = nil }, "$parent.LayoutGroup")
					Content.LayoutGroup:SetPoint("CENTER", Content)
					Content.LayoutGroup:SetFrameStrata(NS.Variables.FRAME_STRATA)
					Content.LayoutGroup:SetFrameLevel(NS.Variables.FRAME_LEVEL_MAX + 2)
					addon.API.FrameUtil:SetDynamicSize(Content.LayoutGroup, Content, 0, nil)
					addon.API.FrameUtil:SetDynamicSize(Frame, Content.LayoutGroup, nil, 0)
					CallbackRegistry:Add("LayoutGroupSort Prompt.Content", Content.LayoutGroup_Sort)

					local LayoutGroup = Content.LayoutGroup

					do -- Elements
						do -- Text frame
							LayoutGroup.TextFrame = CreateFrame("Frame", "$parent.TextFrame", LayoutGroup)
							LayoutGroup.TextFrame:SetPoint("TOP", LayoutGroup)
							LayoutGroup.TextFrame:SetFrameStrata(NS.Variables.FRAME_STRATA)
							LayoutGroup.TextFrame:SetFrameLevel(NS.Variables.FRAME_LEVEL_MAX + 3)
							addon.API.FrameUtil:SetDynamicSize(LayoutGroup.TextFrame, LayoutGroup, 0, nil)
							LayoutGroup:AddElement(LayoutGroup.TextFrame)

							local TextFrame = LayoutGroup.TextFrame

							do -- Text
								TextFrame.Text = addon.API.FrameTemplates:CreateText(TextFrame, addon.Theme.RGB_RECOMMENDED, 15, "CENTER", "MIDDLE", GameFontNormal:GetFont(), "$parent.Text")
								TextFrame.Text:SetPoint("CENTER", TextFrame)
								addon.API.FrameUtil:SetDynamicTextSize(TextFrame.Text, TextFrame, nil, nil)
								addon.API.FrameUtil:SetDynamicSize(TextFrame, TextFrame.Text, nil, 0)
							end
						end

						do -- Button frame
							LayoutGroup.ButtonFrame = CreateFrame("Frame", "$parent.ButtonFrame", LayoutGroup)
							LayoutGroup.ButtonFrame:SetHeight(FRAME_BUTTON_HEIGHT)
							LayoutGroup.ButtonFrame:SetPoint("BOTTOM", LayoutGroup)
							LayoutGroup.ButtonFrame:SetFrameStrata(NS.Variables.FRAME_STRATA)
							LayoutGroup.ButtonFrame:SetFrameLevel(NS.Variables.FRAME_LEVEL_MAX + 3)
							addon.API.FrameUtil:SetDynamicSize(LayoutGroup.ButtonFrame, LayoutGroup, 0, nil)
							LayoutGroup:AddElement(LayoutGroup.ButtonFrame)

							local ButtonFrame = LayoutGroup.ButtonFrame

							do -- Layout group
								ButtonFrame.LayoutGroup, ButtonFrame.LayoutGroup_Sort = addon.API.FrameTemplates:CreateLayoutGroup(Content, { point = "LEFT", direction = "horizontal", resize = true, padding = PADDING, distribute = true, distributeResizeElements = true, excludeHidden = true, autoSort = true, customOffset = nil, customLayoutSort = nil }, "$parent.LayoutGroup")
								ButtonFrame.LayoutGroup:SetPoint("CENTER", ButtonFrame)
								ButtonFrame.LayoutGroup:SetFrameStrata(NS.Variables.FRAME_STRATA)
								ButtonFrame.LayoutGroup:SetFrameLevel(NS.Variables.FRAME_LEVEL_MAX + 4)
								addon.API.FrameUtil:SetDynamicSize(ButtonFrame.LayoutGroup, ButtonFrame, 0, 0)
								CallbackRegistry:Add("LayoutGroupSort Prompt.Content.ButtonFrame", ButtonFrame.LayoutGroup_Sort)

								local ButtonFrame_LayoutGroup = ButtonFrame.LayoutGroup

								do -- Elements
									local function CreateButton(name)
										local Button = addon.API.FrameTemplates:CreateCustomButton(ButtonFrame_LayoutGroup, ButtonFrame_LayoutGroup:GetWidth() / 2 - PADDING, FRAME_BUTTON_HEIGHT, NS.Variables.FRAME_STRATA, {
											defaultTexture = nil,
											highlightTexture = nil,
											edgeSize = nil,
											scale = .25,
											theme = nil,
											playAnimation = false,
											customColor = nil,
											customHighlightColor = nil,
											customActiveColor = nil,
										}, name)
										Button:SetFrameStrata(NS.Variables.FRAME_STRATA)
										Button:SetFrameLevel(NS.Variables.FRAME_LEVEL_MAX + 5)

										addon.SoundEffects:SetButton(Button)

										return Button
									end

									do -- Button 1
										ButtonFrame_LayoutGroup.Button1 = CreateButton("$parent.Button1")
										ButtonFrame_LayoutGroup:AddElement(ButtonFrame_LayoutGroup.Button1)
									end

									do -- Button 2
										ButtonFrame_LayoutGroup.Button2 = CreateButton("$parent.Button2")
										ButtonFrame_LayoutGroup:AddElement(ButtonFrame_LayoutGroup.Button2)
									end
								end
							end
						end
					end
				end
			end
		end

		do -- References
			local Frame = InteractionFrame.PromptFrame

			Frame.REF_TEXTFRAME = Frame.Content.LayoutGroup.TextFrame
			Frame.REF_BUTTONFRAME = Frame.Content.LayoutGroup.ButtonFrame

			Frame.REF_BUTTONFRAME_CONTENT = Frame.REF_BUTTONFRAME.LayoutGroup
		end
	end

	-- References
	----------------------------------------------------------------------------------------------------

	local Frame = InteractionFrame.PromptFrame
	local Callback = NS.Script

	-- Setup
	----------------------------------------------------------------------------------------------------

	do
		Frame:Hide()
		Frame.hidden = true
	end
end
