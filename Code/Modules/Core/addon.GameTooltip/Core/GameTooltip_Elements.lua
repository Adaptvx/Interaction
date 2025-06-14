---@class addon
local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local PrefabRegistry = addon.PrefabRegistry
local L = addon.Locales
local NS = addon.GameTooltip; addon.GameTooltip = NS

--------------------------------

NS.Elements = {}

--------------------------------

function NS.Elements:Load()
	--------------------------------
	-- CREATE ELEMENTS
	--------------------------------

	do
		do -- ELEMENTS
			InteractionFrame.GameTooltip = CreateFrame("GameTooltip", "$parent.GameTooltip", InteractionFrame, "GameTooltipTemplate")
			InteractionFrame.ShoppingTooltip1 = CreateFrame("GameTooltip", "$parent.ShoppingTooltip1", InteractionFrame, "GameTooltipTemplate")
			InteractionFrame.ShoppingTooltip2 = CreateFrame("GameTooltip", "$parent.ShoppingTooltip2", InteractionFrame, "GameTooltipTemplate")

			--------------------------------

			do -- STYLE
				local function StyleTooltip(tooltip, texture, color)
					local FRAME_STRATA = tooltip:GetFrameStrata()
					local FRAME_LEVEL = tooltip:GetFrameLevel()

					--------------------------------

					do -- BLIZZARD
						tooltip.NineSlice:SetAlpha(0)
					end

					do -- CUSTOM
						tooltip.Custom = CreateFrame("Frame", "$parent.Custom", tooltip)
						tooltip.Custom:SetAllPoints(tooltip)
						tooltip.Custom:SetFrameStrata(FRAME_STRATA)
						tooltip.Custom:SetFrameLevel(FRAME_LEVEL)

						--------------------------------

						do -- BACKGROUND
							tooltip.Custom.Background, tooltip.Custom.BackgroundTexture = addon.API.FrameTemplates:CreateNineSlice(tooltip.Custom, FRAME_STRATA, texture, 64, .25, "$parent.Background", Enum.UITextureSliceMode.Stretched)
							tooltip.Custom.Background:SetPoint("TOPLEFT", tooltip.Custom, -12.5, 12.5)
							tooltip.Custom.Background:SetPoint("BOTTOMRIGHT", tooltip.Custom, 12.5, -12.5)
							tooltip.Custom.Background:SetFrameStrata(FRAME_STRATA)
							tooltip.Custom.Background:SetFrameLevel(FRAME_LEVEL - 1)
							tooltip.Custom.BackgroundTexture:SetVertexColor(color, color, color)
						end
					end
				end

				StyleTooltip(InteractionFrame.GameTooltip, addon.API.Presets.NINESLICE_TOOLTIP_CUSTOM, 1)
				StyleTooltip(InteractionFrame.ShoppingTooltip1, addon.API.Presets.NINESLICE_TOOLTIP_CUSTOM, .75)
				StyleTooltip(InteractionFrame.ShoppingTooltip2, addon.API.Presets.NINESLICE_TOOLTIP_CUSTOM, .75)
			end
		end
	end

	--------------------------------
	-- REFERENCES
	--------------------------------

	local InteractionFrame_GameTooltip = InteractionFrame.GameTooltip
	local InteractionFrame_ShoppingTooltip1 = InteractionFrame.ShoppingTooltip1
	local InteractionFrame_ShoppingTooltip2 = InteractionFrame.ShoppingTooltip2
	local Callback = NS.Script; NS.Script = Callback

	--------------------------------
	-- SETUP
	--------------------------------

	do
		InteractionFrame_GameTooltip.shoppingTooltips = { InteractionFrame_ShoppingTooltip1, InteractionFrame_ShoppingTooltip2 }
	end
end
