local addonName, addon = ...
local CallbackRegistry = addon.CallbackRegistry
local L = addon.Locales
local NS = addon.Interaction.Quest.Target

--------------------------------

NS.Elements = {}

--------------------------------

function NS.Elements:Load()
	--------------------------------
	-- CREATE ELEMENTS
	--------------------------------

	do
		local function CreateElements()
			InteractionQuestFrame.Target = CreateFrame("Frame", "$parent.Target", InteractionQuestFrame)
			InteractionQuestFrame.Target:SetParent(InteractionQuestFrame)
			InteractionQuestFrame.Target:SetSize(NS.Variables:RATIO(3), NS.Variables:RATIO(3))
			InteractionQuestFrame.Target:SetPoint("LEFT", InteractionQuestFrame, -(InteractionQuestFrame.Target:GetWidth() / 2 + NS.Variables:RATIO(4)), 100)
			InteractionQuestFrame.Target:SetFrameStrata("FULLSCREEN")
			InteractionQuestFrame.Target:SetFrameLevel(999)

			--------------------------------

			local Frame = InteractionQuestFrame.Target

			--------------------------------

			local function Background()
				Frame.Background, Frame.BackgroundTexture = AdaptiveAPI.FrameTemplates:CreateNineSlice(Frame, "FULLSCREEN", nil, 128, .75)
				Frame.Background:SetPoint("CENTER", Frame)
				Frame.Background:SetFrameStrata("FULLSCREEN")
				Frame.Background:SetFrameLevel(48)
				Frame.BackgroundTexture:SetAllPoints(Frame.Background, true)
				Frame.BackgroundTexture:SetVertexColor(1, 1, 1)

				--------------------------------

				addon.API:RegisterThemeUpdate(function()
					local BackgroundTexture

					if addon.Theme.IsDarkTheme then
						BackgroundTexture = NS.Variables.PATH .. "background-dark-mode.png"
					else
						BackgroundTexture = NS.Variables.PATH .. "background.png"
					end

					Frame.BackgroundTexture:SetTexture(BackgroundTexture)
				end, 5)

				--------------------------------

				local function UpdateSize()
					Frame.Background:SetSize(Frame:GetWidth() + 75, Frame:GetHeight() + 75)
				end

				hooksecurefunc(Frame, "SetWidth", UpdateSize)
				hooksecurefunc(Frame, "SetHeight", UpdateSize)
				hooksecurefunc(Frame, "SetSize", UpdateSize)
			end

			local function Art()
				Frame.Art, Frame.ArtTexture = AdaptiveAPI.FrameTemplates:CreateTexture(Frame, "FULLSCREEN", nil)
				Frame.Art:SetSize(Frame:GetWidth() - NS.Variables.CONTENT_PADDING, Frame:GetWidth() - NS.Variables.CONTENT_PADDING)
				Frame.Art:SetPoint("TOP", Frame, 0, -NS.Variables.CONTENT_PADDING / 2)
				Frame.Art:SetFrameStrata("FULLSCREEN")
				Frame.Art:SetFrameLevel(49)
				Frame.ArtTexture:SetAllPoints(Frame.Art, true)
				Frame.ArtTexture:SetAlpha(1)

				--------------------------------

				addon.API:RegisterThemeUpdate(function()
					local BackgroundTexture

					if addon.Theme.IsDarkTheme then
						BackgroundTexture = NS.Variables.PATH .. "model-border-dark-mode.png"
					else
						BackgroundTexture = NS.Variables.PATH .. "model-border.png"
					end

					Frame.ArtTexture:SetTexture(BackgroundTexture)
				end, 5)
			end

			local function Text()
				local function SetAutoTextHeight(frame, positionCalculation)
					local function Update()
						frame:SetHeight(1000)

						--------------------------------

						local textHeight = frame:GetStringHeight()

						--------------------------------

						frame:SetHeight(textHeight)
						if positionCalculation then
							positionCalculation(frame, textHeight)
						end
					end

					--------------------------------

					hooksecurefunc(frame, "SetText", Update)
				end

				local function Label()
					Frame.Label = AdaptiveAPI.FrameTemplates:CreateText(Frame, addon.Theme.RGB_WHITE, 15, "LEFT", "TOP", AdaptiveAPI.Fonts.Content_Bold)
					Frame.Label:SetSize(Frame.Art:GetWidth() - NS.Variables.CONTENT_PADDING, 25)

					--------------------------------

					SetAutoTextHeight(Frame.Label)
				end

				local function Description()
					Frame.Description = AdaptiveAPI.FrameTemplates:CreateText(Frame, addon.Theme.RGB_WHITE, 12, "LEFT", "MIDDLE", AdaptiveAPI.Fonts.Content_Light)
					Frame.Description:SetSize(Frame.Art:GetWidth() - NS.Variables.CONTENT_PADDING, 135)
					Frame.Description:SetAlpha(.5)

					--------------------------------

					SetAutoTextHeight(Frame.Description)
				end

				--------------------------------

				Label()
				Description()
			end

			local function Model()
				Frame.Model = CreateFrame("PlayerModel", "$parent.Model", Frame.Art)
				Frame.Model:SetParent(Frame.Art)
				Frame.Model:SetSize(Frame.Art:GetWidth() - (NS.Variables.PADDING * 3), Frame.Art:GetWidth() - (NS.Variables.PADDING * 3))
				Frame.Model:SetPoint("CENTER", Frame.Art, 0, 0)
				Frame.Model:SetFrameStrata("FULLSCREEN")
				Frame.Model:SetFrameLevel(50)
			end

			--------------------------------

			Background()
			Art()
			Text()
			Model()
		end

		CreateElements()
	end

	--------------------------------
	-- REFERENCES
	--------------------------------

	local Frame = InteractionQuestFrame.Target
	local Callback = NS.Script

	--------------------------------
	-- SETUP
	--------------------------------

	do
		Frame.hidden = true
		Frame:Hide()
	end
end
