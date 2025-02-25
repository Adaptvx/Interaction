local addonName, addon = ...
local PrefabRegistry = addon.PrefabRegistry
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

			do -- ELEMENTS
				do -- IMAGE
					Frame.Image, Frame.ImageTexture = addon.API.FrameTemplates:CreateTexture(Frame, "FULLSCREEN_DIALOG", nil, "$parent.Image")
					Frame.Image:SetPoint("CENTER", Frame)
					Frame.Image:SetFrameStrata("FULLSCREEN_DIALOG")
					Frame.Image:SetFrameLevel(49)
					addon.API.FrameUtil:SetDynamicSize(Frame.Image, Frame, function(relativeWidth, relativeHeight) return relativeHeight * 1.75 end, function(relativeWidth, relativeHeight) return relativeHeight * 1.75 end)
				end

				do -- BACKGROUND
					Frame.Background, Frame.BackgroundTexture = addon.API.FrameTemplates:CreateTexture(Frame, "FULLSCREEN_DIALOG", NS.Variables.PATH .. "background.png", "$parent.Background")
					Frame.Background:SetAllPoints(Frame)
					Frame.Background:SetFrameStrata("FULLSCREEN_DIALOG")
					Frame.Background:SetFrameLevel(50)
				end

				do -- TITLE
					Frame.Title = CreateFrame("Frame", "$parent.Title", Frame)
					Frame.Title:SetAllPoints(Frame)
					Frame.Title:SetFrameStrata("FULLSCREEN_DIALOG")
					Frame.Title:SetFrameLevel(51)

					--------------------------------

					do -- TEXT
						Frame.Title.Text = addon.API.FrameTemplates:CreateText(Frame.Title, addon.Theme.RGB_WHITE, 17.5, "CENTER", "MIDDLE", addon.API.Fonts.Title_Bold, "$parent.Text")
						Frame.Title.Text:SetAllPoints(Frame.Title, true)
					end
				end
			end
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
