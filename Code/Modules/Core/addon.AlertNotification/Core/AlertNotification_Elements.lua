local addonName, addon = ...
local CallbackRegistry = addon.CallbackRegistry
local PrefabRegistry = addon.PrefabRegistry
local L = addon.Locales
local NS = addon.AlertNotification

--------------------------------

NS.Elements = {}

--------------------------------

function NS.Elements:Load()
	--------------------------------
	-- CREATE ELEMENTS
	--------------------------------

	do
		do -- ELEMENTS
			local TextColorPreset = {}
			if addon.Theme.IsDarkTheme then
				TextColorPreset = { r = 1, g = 1, b = 1 }
			else
				TextColorPreset = { r = 1, g = 1, b = 1 }
			end

			--------------------------------

			InteractionAlertNotificationFrame = CreateFrame("Frame", "$parent.InteractionAlertNotificationFrame", InteractionFrame)
			InteractionAlertNotificationFrame:SetSize(250, 50)
			InteractionAlertNotificationFrame:SetFrameStrata("FULLSCREEN")
			InteractionAlertNotificationFrame:SetFrameLevel(50)

            local Frame = InteractionAlertNotificationFrame
			Frame:SetScript("OnUpdate", function()
				Frame:SetWidth(Frame.Image:GetWidth() + Frame.Text:GetStringWidth() + 17.5)
			end)
			Frame:Hide()

			--------------------------------

			do -- NOTIFICATION
				do -- BACKGROUND
					Frame.Background, Frame.BackgroundTexture = addon.API.FrameTemplates:CreateNineSlice(Frame, "FULLSCREEN", addon.Variables.PATH_ART .. "Gradient/backdrop-nineslice.png", 128, .5, "$parent.Background")
					Frame.Background:SetPoint("TOPLEFT", Frame, -12.5, 12.5)
					Frame.Background:SetPoint("BOTTOMRIGHT", Frame, 12.5, -12.5)
					Frame.Background:SetFrameStrata("FULLSCREEN")
					Frame.Background:SetFrameLevel(49)
					Frame.BackgroundTexture:SetVertexColor(.5, .5, .5)
				end

				do -- TEXT
					Frame.Text = addon.API.FrameTemplates:CreateText(Frame, TextColorPreset, 15, "LEFT", "MIDDLE", addon.API.Fonts.Content_Light, "$parent.Text")
					Frame.Text:SetSize(Frame:GetWidth() - Frame:GetHeight(), Frame:GetHeight())
					Frame.Text:SetPoint("LEFT", Frame, Frame:GetHeight(), 0)
				end

				do -- IMAGE
					Frame.Image, Frame.ImageTexture = addon.API.FrameTemplates:CreateTexture(Frame, "FULLSCREEN_DIALOG", NS.Variables.PATH .. "checked.png")
					Frame.Image:SetSize(Frame:GetHeight(), Frame:GetHeight())
					Frame.Image:SetPoint("LEFT", Frame)
					Frame.Image:SetFrameStrata("FULLSCREEN")
					Frame.Image:SetFrameLevel(50)
				end
			end

			do -- FLARE
				Frame.Flare = CreateFrame("Frame", "$parent.Flare", Frame)
				Frame.Flare:SetSize(1000, 150)
				Frame.Flare:SetPoint("CENTER", Frame)
				Frame.Flare:SetIgnoreParentScale(true)
				Frame.Flare:SetIgnoreParentAlpha(true)

				Frame.Flare:Hide()

				--------------------------------

				do -- BACKGROUND
					Frame.Flare.Background, Frame.Flare.BackgroundTexture = addon.API.FrameTemplates:CreateTexture(Frame.Flare, "FULLSCREEN_DIALOG", NS.Variables.PATH .. "flare.png")
					Frame.Flare.Background:SetSize(Frame.Flare:GetWidth(), Frame.Flare:GetHeight())
					Frame.Flare.Background:SetPoint("CENTER", Frame.Flare)
					Frame.Flare.Background:SetAlpha(1)
				end
			end
		end
	end

	--------------------------------
	-- REFERENCES
	--------------------------------

	local Frame = InteractionAlertNotificationFrame
	local Callback = NS.Script

	--------------------------------
	-- SETUP
	--------------------------------
end
