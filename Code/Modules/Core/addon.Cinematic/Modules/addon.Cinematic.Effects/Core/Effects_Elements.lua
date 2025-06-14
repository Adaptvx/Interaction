-- [!] [addon.Cinematic.Effects] is used to display screen gradients/effects.
-- [Effects_Elements.lua] is the front-end (UI)
-- for the module.

---@class addon
local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local PrefabRegistry = addon.PrefabRegistry
local L = addon.Locales
local NS = addon.Cinematic.Effects; addon.Cinematic.Effects = NS

--------------------------------

NS.Elements = {}

--------------------------------

function NS.Elements:Load()
	--------------------------------
	-- CREATE ELEMENTS
	--------------------------------

	do
		do -- ELEMENTS
			InteractionFrame.EffectsFrame = CreateFrame("Frame", "InteractionFrame.EffectsFrame", InteractionFrame)
			InteractionFrame.EffectsFrame:SetAllPoints(UIParent, true)
			InteractionFrame.EffectsFrame:SetFrameStrata(NS.Variables.FRAME_STRATA)
			InteractionFrame.EffectsFrame:SetFrameLevel(NS.Variables.FRAME_LEVEL)

            local Frame = InteractionFrame.EffectsFrame

			--------------------------------

			do -- MOUSE RESPONDER
				Frame.MouseResponders = CreateFrame("Frame", "$parent.MouseResponders", Frame)
				Frame.MouseResponders:SetAllPoints(Frame, true)
				Frame.MouseResponders:SetFrameStrata(NS.Variables.FRAME_STRATA)
				Frame.MouseResponders:SetFrameLevel(NS.Variables.FRAME_LEVEL + 1)

				local MouseResponders = Frame.MouseResponders

				--------------------------------

				do -- LEFT
					MouseResponders.Left = CreateFrame("Frame", "$parent.Left", MouseResponders)
					MouseResponders.Left:SetPoint("TOPLEFT", UIParent, 0, 0)
					MouseResponders.Left:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMLEFT", 750, 0)
				end

				do -- RIGHT
					MouseResponders.Right = CreateFrame("Frame", "$parent.Right", MouseResponders)
					MouseResponders.Right:SetPoint("TOPLEFT", UIParent, -750, 0)
					MouseResponders.Right:SetPoint("BOTTOMRIGHT", UIParent, 0, 0)
				end
			end

			do -- GRADIENT
				Frame.Gradient = CreateFrame("Frame", "$parent.Gradient", Frame)
				Frame.Gradient:SetAllPoints(UIParent, true)
				Frame.Gradient:SetFrameStrata(NS.Variables.FRAME_STRATA)
				Frame.Gradient:SetFrameLevel(NS.Variables.FRAME_LEVEL + 1)

				local Gradient = Frame.Gradient

				--------------------------------

				do -- BACKGROUND
					Gradient.Background, Gradient.BackgroundTexture = addon.API.FrameTemplates:CreateTexture(Frame.Gradient, NS.Variables.FRAME_STRATA, nil, "$parent.Gradient")
					Gradient.Background:SetAllPoints(Frame.Gradient, true)
					Gradient.Background:SetFrameStrata(NS.Variables.FRAME_STRATA)
					Gradient.Background:SetFrameLevel(NS.Variables.FRAME_LEVEL + 2)
					Gradient.Background:SetAlpha(.75)
				end
			end
		end

		do -- REFERENCES
			local Frame = InteractionFrame.EffectsFrame

			--------------------------------

			-- CORE
			Frame.REF_MOUSE_RESPONDERS = Frame.MouseResponders
			Frame.REF_GRADIENT = Frame.Gradient

			-- MOUSE RESPONDERS
			Frame.REF_MOUSE_RESPONDERS_LEFT = Frame.REF_MOUSE_RESPONDERS.Left
			Frame.REF_MOUSE_RESPONDERS_RIGHT = Frame.REF_MOUSE_RESPONDERS.Right
		end
	end

	--------------------------------
	-- REFERENCES
	--------------------------------

	local Frame = InteractionFrame.EffectsFrame
	local Callback = NS.Script; NS.Script = Callback

	--------------------------------
	-- SETUP
	--------------------------------

	do
		Frame.Gradient:SetAlpha(0)
		Frame.Gradient:Hide()
		Frame.Gradient.hidden = true
	end
end
