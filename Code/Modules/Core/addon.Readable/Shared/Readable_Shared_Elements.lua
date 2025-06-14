---@class addon
local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local PrefabRegistry = addon.PrefabRegistry
local L = addon.Locales
local NS = addon.Readable; addon.Readable = NS

--------------------------------

NS.Elements = {}

--------------------------------

function NS.Elements:Load()
	--------------------------------
	-- CREATE ELEMENTS
	--------------------------------

	do
		do -- ELEMENTS
			InteractionReadableUIFrame = CreateFrame("Frame", "$parent.InteractionReadableUIFrame", InteractionFrame)
			InteractionReadableUIFrame:SetSize(NS.Variables.SCREEN_HEIGHT, NS.Variables.SCREEN_HEIGHT)
			InteractionReadableUIFrame:SetFrameStrata("FULLSCREEN")
			InteractionReadableUIFrame:SetFrameLevel(3)

			--------------------------------

			NS.Variables.Frame = InteractionReadableUIFrame
			local Frame = InteractionReadableUIFrame

			--------------------------------

			do -- BACKGROUND
				Frame.Background, Frame.BackgroundTexture = addon.API.FrameTemplates:CreateTexture(Frame, "FULLSCREEN", NS.Variables.READABLE_UI_PATH .. "Elements/background.png", "$parent.Background")
				Frame.Background:SetSize(Frame:GetWidth() + NS.Variables.SCREEN_WIDTH * .25, Frame:GetHeight())
				Frame.Background:SetPoint("CENTER", Frame, 0, 0)
				Frame.Background:SetFrameStrata("FULLSCREEN")
				Frame.Background:SetFrameLevel(1)
			end

			do -- DISC
				Frame.Disc, Frame.DiscTexture = addon.API.FrameTemplates:CreateTexture(Frame, "FULLSCREEN", NS.Variables.READABLE_UI_PATH .. "Elements/ring.png", "$parent.Disc")
				Frame.Disc:SetSize(Frame:GetWidth() - 100, Frame:GetHeight() - 100)
				Frame.Disc:SetScale(1.125)
				Frame.Disc:SetPoint("CENTER", Frame)
				Frame.Disc:SetFrameStrata("FULLSCREEN")
				Frame.Disc:SetFrameLevel(2)
				Frame.Disc:SetAlpha(.5)
			end

			do -- BUTTONS
				do -- TTS
					InteractionReadableUIFrame.TTSButton = addon.API.FrameTemplates:CreateCustomButton(InteractionReadableUIFrame, 25, 25, "FULLSCREEN", {
						defaultTexture = NS.Variables.NINESLICE_HEAVY,
						highlightTexture = NS.Variables.NINESLICE_Highlight,
						edgeSize = 25,
						scale = 1,
						theme = 2,
						playAnimation = false,
						customColor = nil,
						customHighlightColor = nil,
						customActiveColor = nil,
					}, "$parent.TTSButton")
					InteractionReadableUIFrame.TTSButton:SetPoint("TOPRIGHT", InteractionReadableUIFrame, -50, -25)
					InteractionReadableUIFrame.TTSButton:SetScript("OnClick", function()
						NS.ItemUI.Script:StartTTS()
					end)

					--------------------------------

					do -- IMAGE
						InteractionReadableUIFrame.TTSButton.Image, InteractionReadableUIFrame.TTSButton.ImageTexture = addon.API.FrameTemplates:CreateTexture(InteractionReadableUIFrame.TTSButton, "FULLSCREEN", NS.Variables.READABLE_UI_PATH .. "Elements/tts.png", "$parent.Image")
						InteractionReadableUIFrame.TTSButton.Image:SetSize(InteractionReadableUIFrame.TTSButton:GetWidth() - 10, InteractionReadableUIFrame.TTSButton:GetHeight() - 10)
						InteractionReadableUIFrame.TTSButton.Image:SetPoint("CENTER", InteractionReadableUIFrame.TTSButton)
						InteractionReadableUIFrame.TTSButton.Image:SetAlpha(.75)
					end
				end

				do -- CLOSE
					InteractionReadableUIFrame.CloseButton = addon.API.FrameTemplates:CreateCustomButton(InteractionReadableUIFrame, 25, 25, "FULLSCREEN", {
						defaultTexture = NS.Variables.NINESLICE_DEFAULT,
						highlightTexture = NS.Variables.NINESLICE_Highlight,
						edgeSize = 25,
						scale = 1,
						theme = 2,
						playAnimation = false,
						customColor = nil,
						customHighlightColor = nil,
						customActiveColor = nil,
					}, "$parent.CloseButton")
					InteractionReadableUIFrame.CloseButton:SetPoint("TOPRIGHT", InteractionReadableUIFrame, -25, -25)

					--------------------------------

					do -- IMAGE
						InteractionReadableUIFrame.CloseButton.Image, InteractionReadableUIFrame.CloseButton.ImageTexture = addon.API.FrameTemplates:CreateTexture(InteractionReadableUIFrame.CloseButton, "FULLSCREEN", addon.Variables.PATH_ART .. "Elements/Elements/close.png", "$parent.Image")
						InteractionReadableUIFrame.CloseButton.Image:SetSize(InteractionReadableUIFrame.CloseButton:GetWidth() - 10, InteractionReadableUIFrame.CloseButton:GetHeight() - 10)
						InteractionReadableUIFrame.CloseButton.Image:SetPoint("CENTER", InteractionReadableUIFrame.CloseButton)
						InteractionReadableUIFrame.CloseButton.Image:SetAlpha(.5)
					end

					--------------------------------

					InteractionReadableUIFrame.CloseButton:SetScript("OnClick", function()
						InteractionReadableUIFrame:HideWithAnimation()
					end)
				end
			end
		end
	end

	--------------------------------
	-- EVENTS
	--------------------------------

	do
		CallbackRegistry:Add("START_READABLE", function()
			InteractionReadableUIFrame.TTSButton:Show()
		end, 0)

		CallbackRegistry:Add("START_LIBRARY", function()
			InteractionReadableUIFrame.TTSButton:Hide()
		end, 0)

		CallbackRegistry:Add("STOP_READABLE_UI", function()
			InteractionReadableUIFrame.TTSButton:Hide()
		end, 0)
	end

	--------------------------------
	-- REFERENCES
	--------------------------------

	local Frame = InteractionReadableUIFrame
	local Callback = NS.Script; NS.Script = Callback

	--------------------------------
	-- SETUP
	--------------------------------

	do
		Frame:Hide()
		Frame.hidden = true
	end
end
