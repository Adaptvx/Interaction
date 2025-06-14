---@class addon
local addon = select(2, ...)
local NS = addon.API.FrameTemplates; addon.API.FrameTemplates = NS
local CallbackRegistry = addon.CallbackRegistry

--------------------------------
-- VARIABLES
--------------------------------

do -- MAIN

end

do -- CONSTANTS

end

--------------------------------
-- TEMPLATES
--------------------------------

do
	-- Creates a Blizzard progress bar.
	---@param parent any
	---@param texture string
	---@param name? string
	function NS:CreateProgressBar(parent, texture, name)
		local ProgressBar = CreateFrame("StatusBar", name or nil, parent)
		ProgressBar:SetStatusBarTexture(texture)

		--------------------------------

		return ProgressBar
	end

	-- Creates a customizable progress bar with flare.
	---@param parent any
	---@param frameStrata string
	---@param texture string
	---@param flareTexture string
	---@param flareOffsetX number
	---@param flareOffsetY number
	---@param name? string
	function NS:CreateAdvancedProgressBar(parent, frameStrata, texture, flareTexture, flareOffsetX, flareOffsetY, name)
		local ProgressBar = addon.API.FrameTemplates:CreateProgressBar(parent, texture, name or nil)

		--------------------------------

		ProgressBar.Flare, ProgressBar.FlareTexture = addon.API.FrameTemplates:CreateTexture(ProgressBar, frameStrata, flareTexture, "$parent.Flare")

		--------------------------------

		local function Update()
			local Min, Max = ProgressBar:GetMinMaxValues()
			local ProgressPercentage = ((ProgressBar:GetValue() - Min) / (Max - Min))

			--------------------------------

			ProgressBar.Flare:SetPoint("LEFT", ProgressBar, (ProgressBar:GetWidth() * ProgressPercentage) - ProgressBar.Flare:GetWidth() + flareOffsetX, flareOffsetY)

			--------------------------------

			if ProgressPercentage > .1 then
				if ProgressBar.Flare:GetAlpha() == 0 then
					addon.API.Animation:Fade(ProgressBar.Flare, .5, 0, 1)
				end
			else
				ProgressBar.Flare:SetAlpha(0)
			end
		end

		hooksecurefunc(ProgressBar, "SetValue", Update)
		hooksecurefunc(ProgressBar, "SetMinMaxValues", Update)
		hooksecurefunc(ProgressBar, "Show", Update)

		--------------------------------

		return ProgressBar
	end
end
