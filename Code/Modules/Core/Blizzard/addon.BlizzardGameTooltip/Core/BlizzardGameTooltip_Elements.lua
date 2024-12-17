local addonName, addon = ...
local CallbackRegistry = addon.CallbackRegistry
local L = addon.Locales
local NS = addon.BlizzardGameTooltip

--------------------------------

NS.Elements = {}

--------------------------------

function NS.Elements:Load()
	--------------------------------
	-- CREATE ELEMENTS
	--------------------------------

	do
		do -- CREATE ELEMENTS
			local function StyleTooltip(frame)
				frame.Background = CreateFrame("Frame", "$parent.Background", frame)
				frame.Background:SetPoint("TOPLEFT", frame.NineSlice, -6.25, 6.25)
				frame.Background:SetPoint("BOTTOMRIGHT", frame.NineSlice, 6.25, -6.25)
				frame.Background:SetFrameStrata(frame.NineSlice:GetFrameStrata())
				frame.Background:SetFrameLevel(frame.NineSlice:GetFrameLevel())

				--------------------------------

				if not (frame == GameTooltip) then
					hooksecurefunc(frame.NineSlice, "Show", function()
						if frame.Background:IsVisible() then
							frame.NineSlice:Hide()
						end
					end)
				end

				--------------------------------

				do -- BACKGROUND
					frame.Background.NineSlice, frame.Background.NineSliceTexture = AdaptiveAPI.FrameTemplates:CreateNineSlice(frame.Background, "FULLSCREEN_DIALOG", AdaptiveAPI.Presets.NINESLICE_INSCRIBED_FILLED_HIGHLIGHT, 25, 1, "$parent.NineSlice")
					frame.Background.NineSlice:SetAllPoints(frame.Background, true)
					frame.Background.NineSlice:SetFrameStrata(frame.NineSlice:GetFrameStrata())
					frame.Background.NineSlice:SetFrameLevel(frame.NineSlice:GetFrameLevel() - 1)
					frame.Background.NineSliceTexture:SetVertexColor(.1, .1, .1)
				end
			end

			--------------------------------

			StyleTooltip(GameTooltip)
			StyleTooltip(ShoppingTooltip1)
			StyleTooltip(ShoppingTooltip2)

			if not addon.Variables.IS_CLASSIC then
				StyleTooltip(GarrisonFollowerTooltip)
			end
		end
	end

	--------------------------------
	-- REFERENCES
	--------------------------------

	local Tooltip
	local NineSlice
	local Background

	if addon.Variables.IS_CLASSIC then
		Tooltip = { GameTooltip, ShoppingTooltip1, ShoppingTooltip2 }
		NineSlice = { GameTooltip.NineSlice, ShoppingTooltip1.NineSlice, ShoppingTooltip2.NineSlice }
		Background = { GameTooltip.Background, ShoppingTooltip1.Background, ShoppingTooltip2.Background }
	else
		Tooltip = { GameTooltip, ShoppingTooltip1, ShoppingTooltip2, GarrisonFollowerTooltip }
		NineSlice = { GameTooltip.NineSlice, ShoppingTooltip1.NineSlice, ShoppingTooltip2.NineSlice, GarrisonFollowerTooltip.NineSlice }
		Background = { GameTooltip.Background, ShoppingTooltip1.Background, ShoppingTooltip2.Background, GarrisonFollowerTooltip.Background }
	end

	--------------------------------
	-- SETUP
	--------------------------------
end
