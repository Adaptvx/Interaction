local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local TemplateRegistry = addon.TemplateRegistry
local L = addon.Locales
local NS = addon.Cinematic.Effects; addon.Cinematic.Effects = NS

NS.Elements = {}

function NS.Elements:Load()

	-- Create elements
	----------------------------------------------------------------------------------------------------

	do
		do -- Elements
			InteractionFrame.EffectsFrame = CreateFrame("Frame", "InteractionFrame.EffectsFrame", InteractionFrame)
			InteractionFrame.EffectsFrame:SetAllPoints(UIParent, true)
			InteractionFrame.EffectsFrame:SetFrameStrata(NS.Variables.FRAME_STRATA)
			InteractionFrame.EffectsFrame:SetFrameLevel(NS.Variables.FRAME_LEVEL)

            local Frame = InteractionFrame.EffectsFrame

			do -- Mouse responder
				Frame.MouseResponders = CreateFrame("Frame", "$parent.MouseResponders", Frame)
				Frame.MouseResponders:SetAllPoints(Frame, true)
				Frame.MouseResponders:SetFrameStrata(NS.Variables.FRAME_STRATA)
				Frame.MouseResponders:SetFrameLevel(NS.Variables.FRAME_LEVEL + 1)

				local MouseResponders = Frame.MouseResponders

				do -- Left
					MouseResponders.Left = CreateFrame("Frame", "$parent.Left", MouseResponders)
					MouseResponders.Left:SetPoint("TOPLEFT", UIParent, 0, 0)
					MouseResponders.Left:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMLEFT", 750, 0)
				end

				do -- Right
					MouseResponders.Right = CreateFrame("Frame", "$parent.Right", MouseResponders)
					MouseResponders.Right:SetPoint("TOPLEFT", UIParent, -750, 0)
					MouseResponders.Right:SetPoint("BOTTOMRIGHT", UIParent, 0, 0)
				end
			end

			do -- Gradient
				Frame.Gradient = CreateFrame("Frame", "$parent.Gradient", Frame)
				Frame.Gradient:SetAllPoints(UIParent, true)
				Frame.Gradient:SetFrameStrata(NS.Variables.FRAME_STRATA)
				Frame.Gradient:SetFrameLevel(NS.Variables.FRAME_LEVEL + 1)

				local Gradient = Frame.Gradient

				do -- Background
					Gradient.Background, Gradient.BackgroundTexture = addon.API.FrameTemplates:CreateTexture(Frame.Gradient, NS.Variables.FRAME_STRATA, nil, "$parent.Gradient")
					Gradient.Background:SetAllPoints(Frame.Gradient, true)
					Gradient.Background:SetFrameStrata(NS.Variables.FRAME_STRATA)
					Gradient.Background:SetFrameLevel(NS.Variables.FRAME_LEVEL + 2)
					Gradient.Background:SetAlpha(.75)
				end
			end
		end

		do -- References
			local Frame = InteractionFrame.EffectsFrame

			Frame.REF_MOUSE_RESPONDERS = Frame.MouseResponders
			Frame.REF_GRADIENT = Frame.Gradient

			Frame.REF_MOUSE_RESPONDERS_LEFT = Frame.REF_MOUSE_RESPONDERS.Left
			Frame.REF_MOUSE_RESPONDERS_RIGHT = Frame.REF_MOUSE_RESPONDERS.Right
		end
	end

	-- References
	----------------------------------------------------------------------------------------------------

	local Frame = InteractionFrame.EffectsFrame
	local Callback = NS.Script

	-- Setup
	----------------------------------------------------------------------------------------------------

	do
		Frame.Gradient:SetAlpha(0)
		Frame.Gradient:Hide()
		Frame.Gradient.hidden = true
	end
end
