---@class addon
local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local PrefabRegistry = addon.PrefabRegistry
local L = addon.Locales
local NS = addon.PlayerStatusBar; addon.PlayerStatusBar = NS

--------------------------------

NS.Elements = {}

--------------------------------

function NS.Elements:Load()
	--------------------------------
	-- CREATE ELEMENTS
	--------------------------------

	do
		do -- ELEMENTS
			InteractionPlayerStatusBarFrame = CreateFrame("Frame", "$parent.InteractionPlayerStatusBarFrame", InteractionFrame)
			InteractionPlayerStatusBarFrame:SetSize(addon.API.Main:GetScreenWidth(), 10)
			InteractionPlayerStatusBarFrame:SetPoint("BOTTOM", UIParent)
			InteractionPlayerStatusBarFrame:SetFrameStrata("FULLSCREEN")
			InteractionPlayerStatusBarFrame:SetFrameLevel(2)

			local Frame = InteractionPlayerStatusBarFrame

			--------------------------------

			local Padding = 5

			--------------------------------

			do -- BACKGROUND
				Frame.Background, Frame.BackgroundTexture = addon.API.FrameTemplates:CreateNineSlice(Frame, "FULLSCREEN", NS.Variables.TEXTURE_Background, 256, 1, "$parent.Background")
				Frame.Background:SetSize(Frame:GetWidth(), Frame:GetHeight())
				Frame.Background:SetPoint("CENTER", Frame)
				Frame.Background:SetFrameStrata("FULLSCREEN")
				Frame.Background:SetFrameLevel(1)
			end

			do -- NOTCH
				Frame.Notch, Frame.NotchTexture = addon.API.FrameTemplates:CreateTexture(Frame, "FULLSCREEN", NS.Variables.TEXTURE_Notch, "$parent.Notch")
				Frame.Notch:SetSize(Frame:GetHeight() - Padding, Frame:GetHeight() - Padding)
				Frame.Notch:SetPoint("LEFT", Frame, Padding, 0)
				Frame.Notch:SetFrameStrata("FULLSCREEN")
				Frame.Notch:SetFrameLevel(2)
				Frame.Notch:SetAlpha(.5)
			end

			do -- PROGRESS BAR
				Frame.Progress = addon.API.FrameTemplates:CreateAdvancedProgressBar(Frame, "FULLSCREEN", NS.Variables.TEXTURE_Progress, NS.Variables.TEXTURE_Flare, 0, 0, "$parent.Progress")
				Frame.Progress:SetSize(Frame:GetWidth() - (Padding / 2) - (Frame.Notch:GetWidth()), Frame:GetHeight() - Padding)
				Frame.Progress:SetPoint("LEFT", Frame, (Padding / 2) + (Frame.Notch:GetWidth()), 0)
				Frame.Progress:SetFrameStrata("FULLSCREEN")
				Frame.Progress:SetFrameLevel(2)
				Frame.Progress:SetMinMaxValues(0, 1)
				Frame.Progress:SetValue(.5)
				Frame.Progress:SetAlpha(.5)

				Frame.Progress.Flare:SetSize(75, Frame.Progress:GetHeight())
				Frame.Progress.Flare:SetFrameStrata("FULLSCREEN")
				Frame.Progress.Flare:SetFrameLevel(3)
			end
		end
	end

	--------------------------------
	-- REFERENCES
	--------------------------------

	local Frame = InteractionPlayerStatusBarFrame
	local Callback = addon.PlayerStatusBar.Script

	--------------------------------
	-- SETUP
	--------------------------------

	do
		Frame.hidden = true
		Frame:Hide()
	end
end
