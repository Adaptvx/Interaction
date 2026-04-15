local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local TemplateRegistry = addon.TemplateRegistry
local L = addon.Locales
local NS = addon.Alert; addon.Alert = NS

NS.Elements = {}

function NS.Elements:Load()

	do
		do -- Elements
			InteractionFrame.AlertFrame = CreateFrame("Frame", "$parent.AlertFrame", InteractionFrame)
			InteractionFrame.AlertFrame:SetSize(325, 50)
			InteractionFrame.AlertFrame:SetScale(1.125)
			InteractionFrame.AlertFrame:SetPoint("TOP", UIParent, 0, -25)
			InteractionFrame.AlertFrame:SetFrameStrata(NS.Variables.FRAME_STRATA)
			InteractionFrame.AlertFrame:SetFrameLevel(NS.Variables.FRAME_LEVEL)

			local Frame = InteractionFrame.AlertFrame

			do -- Elements
				do -- Image
					Frame.Image, Frame.ImageTexture = addon.API.FrameTemplates:CreateTexture(Frame, NS.Variables.FRAME_STRATA, nil, "$parent.Image")
					Frame.Image:SetPoint("CENTER", Frame)
					Frame.Image:SetFrameStrata(NS.Variables.FRAME_STRATA)
					Frame.Image:SetFrameLevel(NS.Variables.FRAME_LEVEL - 2)
					addon.API.FrameUtil:SetDynamicSize(Frame.Image, Frame, function(relativeWidth, relativeHeight) return relativeHeight * 1.75 end, function(relativeWidth, relativeHeight) return relativeHeight * 1.75 end)
				end

				do -- Background
					Frame.Background, Frame.BackgroundTexture = addon.API.FrameTemplates:CreateTexture(Frame, NS.Variables.FRAME_STRATA, NS.Variables.PATH .. "background.png", "$parent.Background")
					Frame.Background:SetAllPoints(Frame)
					Frame.Background:SetFrameStrata(NS.Variables.FRAME_STRATA)
					Frame.Background:SetFrameLevel(NS.Variables.FRAME_LEVEL - 1)
				end

				do -- Title
					Frame.Title = CreateFrame("Frame", "$parent.Title", Frame)
					Frame.Title:SetAllPoints(Frame)
					Frame.Title:SetFrameStrata(NS.Variables.FRAME_STRATA)
					Frame.Title:SetFrameLevel(NS.Variables.FRAME_LEVEL + 1)

					local Title = Frame.Title

					do -- Text
						Title.Text = addon.API.FrameTemplates:CreateText(Title, addon.Theme.RGB_WHITE, 17.5, "CENTER", "MIDDLE", GameFontNormal:GetFont(), "$parent.Text")
						Title.Text:SetAllPoints(Frame.Title, true)
					end
				end
			end
		end

		do -- References
			local Frame = InteractionFrame.AlertFrame

			Frame.REF_IMAGE = Frame.Image
			Frame.REF_BACKGROUND = Frame.Background
			Frame.REF_TITLE = Frame.Title

			Frame.REF_IMAGE_TEXTURE = Frame.ImageTexture

			Frame.REF_BACKGROUND_TEXTURE = Frame.BackgroundTexture

			Frame.REF_TITLE_TEXT = Frame.REF_TITLE.Text
		end
	end

	local Frame = InteractionFrame.AlertFrame
	local Callback = NS.Script

	do
		Frame.hidden = true
		Frame:Hide()
	end
end
