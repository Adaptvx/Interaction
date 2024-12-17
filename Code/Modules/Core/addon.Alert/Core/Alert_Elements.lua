local addonName, addon = ...
local CallbackRegistry = addon.CallbackRegistry
local L = addon.Locales
local NS = addon.Alert

--------------------------------

NS.Elements = {}

--------------------------------

function NS.Elements:Load()
	--------------------------------
	-- CREATE ELEMENTS
	--------------------------------

	do
		do -- CREATE ELEMENTS
			InteractionFrame.AlertFrame = CreateFrame("Frame", "$parent.AlertFrame", InteractionFrame)
			InteractionFrame.AlertFrame:SetSize(325, 50)
			InteractionFrame.AlertFrame:SetScale(1.125)
			InteractionFrame.AlertFrame:SetPoint("TOP", UIParent, 0, -25)
			InteractionFrame.AlertFrame:SetFrameStrata("FULLSCREEN_DIALOG")
			InteractionFrame.AlertFrame:SetFrameLevel(50)

			--------------------------------

			local Frame = InteractionFrame.AlertFrame

			--------------------------------

			local function UpdateSize()
				Frame.Image:SetSize(Frame:GetHeight() * 1.75, Frame:GetHeight() * 1.75)
				Frame.Background:SetSize(Frame:GetWidth(), Frame:GetHeight())
				Frame.Title:SetSize(Frame:GetWidth(), Frame:GetHeight())
			end

			hooksecurefunc(Frame, "SetWidth", function()
				UpdateSize()
			end)

			hooksecurefunc(Frame, "SetHeight", function()
				UpdateSize()
			end)

			hooksecurefunc(Frame, "SetSize", function()
				UpdateSize()
			end)

			--------------------------------

			do -- IMAGE
				Frame.Image, Frame.ImageTexture = AdaptiveAPI.FrameTemplates:CreateTexture(Frame, "FULLSCREEN_DIALOG", nil, "$parent.Image")
				Frame.Image:SetPoint("CENTER", Frame)
				Frame.Image:SetFrameStrata("FULLSCREEN_DIALOG")
				Frame.Image:SetFrameLevel(49)
			end

			do -- BACKGROUND
				Frame.Background, Frame.BackgroundTexture = AdaptiveAPI.FrameTemplates:CreateTexture(Frame, "FULLSCREEN_DIALOG", NS.Variables.PATH .. "background.png", "$parent.Background")
				Frame.Background:SetPoint("CENTER", Frame)
				Frame.Background:SetFrameStrata("FULLSCREEN_DIALOG")
				Frame.Background:SetFrameLevel(50)
			end

			do -- TITLE
				Frame.Title = CreateFrame("Frame", "$parent.Title", Frame)
				Frame.Title:SetPoint("CENTER", Frame)
				Frame.Title:SetFrameStrata("FULLSCREEN_DIALOG")
				Frame.Title:SetFrameLevel(51)

				--------------------------------

				do -- TEXT
					Frame.Title.Text = AdaptiveAPI.FrameTemplates:CreateText(Frame.Title, addon.Theme.RGB_WHITE, 17.5, "CENTER", "MIDDLE", AdaptiveAPI.Fonts.Title_Bold, "$parent.Text")
					Frame.Title.Text:SetAllPoints(Frame.Title, true)
				end
			end

			--------------------------------

			UpdateSize()
		end
	end

	--------------------------------
	-- REFERENCES
	--------------------------------

	local Frame = InteractionFrame.AlertFrame

	--------------------------------
	-- SETUP
	--------------------------------

	Frame.hidden = true
	Frame:Hide()
end
