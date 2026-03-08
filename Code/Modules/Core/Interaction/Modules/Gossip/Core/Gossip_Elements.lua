local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local TemplateRegistry = addon.TemplateRegistry
local L = addon.Locales
local NS = addon.Interaction.Gossip; addon.Interaction.Gossip = NS

NS.Elements = {}

function NS.Elements:Load()

	do
		do -- Elements
			InteractionFrame.GossipParent = CreateFrame("Frame", "$parent.GossipParent", InteractionFrame)
			InteractionFrame.GossipParent:SetAllPoints(InteractionFrame)
			InteractionFrame.GossipParent:SetFrameStrata(NS.Variables.FRAME_STRATA)
			InteractionFrame.GossipParent:SetFrameLevel(NS.Variables.FRAME_LEVEL)

			InteractionFrame.GossipFrame = CreateFrame("Frame", "$parent.GossipFrame", InteractionFrame.GossipParent)
			InteractionFrame.GossipFrame:SetWidth(325)
			InteractionFrame.GossipFrame:SetPoint("CENTER", InteractionFrame.GossipParent)
			InteractionFrame.GossipFrame:SetFrameStrata(NS.Variables.FRAME_STRATA)
			InteractionFrame.GossipFrame:SetFrameLevel(NS.Variables.FRAME_LEVEL)

			local Frame = InteractionFrame.GossipFrame

			local PADDING = NS.Variables:RATIO(7.5)
			local FRAME_MAIN_BUTTON_SPACING = NS.Variables:RATIO(11)
			local FRAME_FOOTER_HEIGHT = 50

			do -- Mouse responder
				Frame.MouseResponder = CreateFrame("Frame", "$parent.MouseResponder", Frame)
				Frame.MouseResponder:SetAllPoints(Frame)
				Frame.MouseResponder:SetFrameStrata(NS.Variables.FRAME_STRATA)
				Frame.MouseResponder:SetFrameLevel(NS.Variables.FRAME_LEVEL)
			end

			do -- Content
				Frame.Content = CreateFrame("Frame", "$parent.Content", Frame)
				Frame.Content:SetPoint("CENTER", Frame)
				Frame.Content:SetFrameStrata(NS.Variables.FRAME_STRATA)
				Frame.Content:SetFrameLevel(NS.Variables.FRAME_LEVEL + 1)
				addon.API.FrameUtil:SetDynamicSize(Frame.Content, Frame, 0, 0)

				local Content = Frame.Content

				do -- Elements
					do -- Layout group
						Content.LayoutGroup, Content.LayoutGroup_Sort = addon.API.FrameTemplates:CreateLayoutGroup(Content, { point = "TOP", direction = "vertical", resize = true, padding = 0, distribute = false, distributeResizeElements = false, excludeHidden = true, autoSort = true, customOffset = nil, customLayoutSort = nil }, "$parent.LayoutGroup")
						Content.LayoutGroup:SetPoint("CENTER", Content)
						Content.LayoutGroup:SetFrameStrata(NS.Variables.FRAME_STRATA)
						Content.LayoutGroup:SetFrameLevel(NS.Variables.FRAME_LEVEL + 2)
						addon.API.FrameUtil:SetDynamicSize(Content.LayoutGroup, Content, 0, nil)
						addon.API.FrameUtil:SetDynamicSize(Frame, Content.LayoutGroup, nil, 0)
						CallbackRegistry:Add("LayoutGroupSort Gossip.Content", Content.LayoutGroup_Sort)

						local LayoutGroup = Content.LayoutGroup

						do -- Main
							LayoutGroup.Main = CreateFrame("Frame", "$parent.Main", LayoutGroup)
							LayoutGroup.Main:SetFrameStrata(NS.Variables.FRAME_STRATA)
							LayoutGroup.Main:SetFrameLevel(NS.Variables.FRAME_LEVEL + 3)
							addon.API.FrameUtil:SetDynamicSize(LayoutGroup.Main, LayoutGroup, 0, nil)
							LayoutGroup:AddElement(LayoutGroup.Main)

							local Main = LayoutGroup.Main

							do -- Layout group
								Main.LayoutGroup, Main.LayoutGroup_Sort = addon.API.FrameTemplates:CreateLayoutGroup(Main, { point = "TOP", direction = "vertical", resize = true, padding = FRAME_MAIN_BUTTON_SPACING, distribute = false, distributeResizeElements = false, excludeHidden = true, autoSort = true, customOffset = nil, customLayoutSort = nil }, "$parent.LayoutGroup")
								Main.LayoutGroup:SetPoint("CENTER", Main)
								Main.LayoutGroup:SetFrameStrata(NS.Variables.FRAME_STRATA)
								Main.LayoutGroup:SetFrameLevel(NS.Variables.FRAME_LEVEL + 5)
								addon.API.FrameUtil:SetDynamicSize(Main.LayoutGroup, Main, 0, nil)
								addon.API.FrameUtil:SetDynamicSize(Main, Main.LayoutGroup, nil, 0)
								CallbackRegistry:Add("LayoutGroupSort Gossip.Content.Main", Main.LayoutGroup_Sort)

								local Main_LayoutGroup = Main.LayoutGroup

								do -- Elements
									do -- Buttons
										local buttons = {}

										for i = 1, 18 do
											local Button = TemplateRegistry:Create("Gossip.OptionButton", Main_LayoutGroup, NS.Variables.FRAME_STRATA, NS.Variables.FRAME_LEVEL + 4, "$parent.Button" .. i)
											addon.API.FrameUtil:SetDynamicSize(Button, Main_LayoutGroup, 0, nil)
											Main_LayoutGroup:AddElement(Button)

											table.insert(buttons, Button)
										end

										NS.Variables.Buttons = buttons
									end
								end
							end
						end

						do -- Footer
							LayoutGroup.Footer = CreateFrame("Frame", "$parent.Footer", LayoutGroup)
							LayoutGroup.Footer:SetHeight(FRAME_FOOTER_HEIGHT)
							LayoutGroup.Footer:SetFrameStrata(NS.Variables.FRAME_STRATA)
							LayoutGroup.Footer:SetFrameLevel(NS.Variables.FRAME_LEVEL + 3)
							addon.API.FrameUtil:SetDynamicSize(LayoutGroup.Footer, LayoutGroup, 0, nil)
							LayoutGroup:AddElement(LayoutGroup.Footer)

							local Footer = LayoutGroup.Footer

							do -- Content
								Footer.Content = CreateFrame("Frame", "$parent.Content", Footer)
								Footer.Content:SetPoint("CENTER", Footer)
								Footer.Content:SetFrameStrata(NS.Variables.FRAME_STRATA)
								Footer.Content:SetFrameLevel(NS.Variables.FRAME_LEVEL + 4)
								addon.API.FrameUtil:SetDynamicSize(Footer.Content, Footer, PADDING, PADDING)

								local Footer_Content = Footer.Content

								do -- Buttons
									do -- Goodbye button
										Footer_Content.GoodbyeButton = TemplateRegistry:Create("Gossip.Footer.Button.Goodbye", Footer_Content, NS.Variables.FRAME_STRATA, NS.Variables.FRAME_LEVEL + 5, "$parent.GoodbyeButton")
										Footer_Content.GoodbyeButton:SetPoint("CENTER", Footer_Content)
										Footer_Content.GoodbyeButton:SetFrameStrata(NS.Variables.FRAME_STRATA)
										Footer_Content.GoodbyeButton:SetFrameLevel(NS.Variables.FRAME_LEVEL + 5)
										addon.API.FrameUtil:SetDynamicSize(Footer_Content.GoodbyeButton, Footer_Content, 0, 0)
									end
								end
							end
						end
					end
				end

				do -- Logic
					do -- Functions
						do -- Set

							function Content:UpdatePosition()
								local numButtons = NS.Variables.NumCurrentButtons

								if numButtons > 0 then
									Content:SetPoint("CENTER", Frame, 0, -FRAME_FOOTER_HEIGHT / 2)
								else
									Content:SetPoint("CENTER", Frame, 0, 0)
								end
							end
						end
					end
				end
			end
		end

		do -- References
			local Frame = InteractionFrame.GossipFrame

			Frame.REF_MAIN = Frame.Content.LayoutGroup.Main
			Frame.REF_FOOTER = Frame.Content.LayoutGroup.Footer
			Frame.REF_MOUSE_RESPONDER = Frame.MouseResponder

			Frame.REF_MAIN_CONTENT = Frame.REF_MAIN.LayoutGroup

			Frame.REF_FOOTER_CONTENT = Frame.REF_FOOTER.Content
			Frame.REF_FOOTER_CONTENT_GOODBYE = Frame.REF_FOOTER_CONTENT.GoodbyeButton
		end
	end

	local Frame = InteractionFrame.GossipFrame
	local Callback = NS.Script

	do
		Frame:SetAlpha(0)
		Frame:Hide()
		Frame.hidden = true
	end
end
