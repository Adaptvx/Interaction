local addonName, addon = ...
local PrefabRegistry = addon.PrefabRegistry
local CallbackRegistry = addon.CallbackRegistry
local L = addon.Locales
local NS = addon.Cinematic.Effects

--------------------------------

NS.Elements = {}

--------------------------------

function NS.Elements:Load()
	--------------------------------
	-- CREATE ELEMENTS
	--------------------------------

	do
		do -- CREATE ELEMENTS
			InteractionCinematicEffectsFrame = CreateFrame("Frame", "InteractionCinematicEffectsFrame", InteractionFrame)
			InteractionCinematicEffectsFrame:SetAllPoints(UIParent, true)
			InteractionCinematicEffectsFrame:SetFrameStrata("HIGH")
			InteractionCinematicEffectsFrame:SetFrameLevel(0)

			--------------------------------

			local Frame = InteractionCinematicEffectsFrame

			--------------------------------

			do -- MOUSE RESPONDER
				Frame.MouseResponders = CreateFrame("Frame", "$parent.MouseResponders", Frame)
				Frame.MouseResponders:SetAllPoints(Frame, true)
				Frame.MouseResponders:SetFrameStrata("HIGH")
				Frame.MouseResponders:SetFrameLevel(0)

				--------------------------------

				do -- LEFT HALF
					Frame.MouseResponders.Left = CreateFrame("Frame", "$parent.MouseResponders.Left_Half", Frame.MouseResponders)
					Frame.MouseResponders.Left:SetPoint("TOPLEFT", UIParent, 0, 0)
					Frame.MouseResponders.Left:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMLEFT", 750, 0)
				end

				do -- RIGHT HALF
					Frame.MouseResponders.Right = CreateFrame("Frame", "$parent.MouseResponders.Right_Half", Frame.MouseResponders)
					Frame.MouseResponders.Right:SetPoint("TOPLEFT", UIParent, -750, 0)
					Frame.MouseResponders.Right:SetPoint("BOTTOMRIGHT", UIParent, 0, 0)
				end
			end

			do -- GRADIENT
				Frame.Gradient = CreateFrame("Frame", "$parent.Gradient", Frame)
				Frame.Gradient:SetAllPoints(UIParent, true)
				Frame.Gradient:SetFrameStrata("HIGH")
				Frame.Gradient:SetFrameLevel(1)

				--------------------------------

				do -- BACKGROUND
					Frame.Gradient.Background, Frame.Gradient.BackgroundTexture = addon.API.FrameTemplates:CreateTexture(Frame.Gradient, "HIGH", nil, "$parent.Gradient")
					Frame.Gradient.Background:SetAllPoints(Frame.Gradient, true)
					Frame.Gradient.Background:SetFrameStrata("HIGH")
					Frame.Gradient.Background:SetFrameLevel(2)
					Frame.Gradient.Background:SetAlpha(.75)
				end
			end
		end
	end

	--------------------------------
	-- REFERENCES
	--------------------------------

	local Frame = InteractionCinematicEffectsFrame
	local Callback = NS.Script

	--------------------------------
	-- SETUP
	--------------------------------

	do
		Frame.Gradient:SetAlpha(0)
		Frame.Gradient:Hide()
		Frame.Gradient.hidden = true
	end
end
