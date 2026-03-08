local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local TemplateRegistry = addon.TemplateRegistry
local L = addon.Locales
local NS = addon.BlizzardSettings; addon.BlizzardSettings = NS

NS.Elements = {}

function NS.Elements:Load()

	do
		do -- Elements
			local Frame = CreateFrame("Frame", "$parent.BlizzardSettings")
			Frame:SetFrameStrata("HIGH")
			Frame:SetFrameLevel(2)

			NS.Variables.Frame = Frame
			local Frame = Frame

			do -- Background
				Frame.Background, Frame.BackgroundTexture = addon.API.FrameTemplates:CreateTexture(Frame, "HIGH", NS.Variables.PATH .. "background.png")
				Frame.Background:SetAllPoints(Frame, true)
				Frame.Background:SetFrameStrata("HIGH")
				Frame.Background:SetFrameLevel(1)
				Frame.BackgroundTexture:SetAlpha(.25)
			end

			do -- Border
				Frame.Border, Frame.BorderTexture = addon.API.FrameTemplates:CreateTexture(Frame, "HIGH", NS.Variables.PATH .. "border.png")
				Frame.Border:SetPoint("TOPLEFT", Frame, 0, 0)
				Frame.Border:SetPoint("BOTTOMLEFT", Frame, 1, 0)
				Frame.Border:SetFrameStrata("HIGH")
				Frame.Border:SetFrameLevel(2)
			end

			do -- Content
				Frame.Content = CreateFrame("Frame", "$parent.Content", Frame)
				Frame.Content:SetSize(500, 125)
				Frame.Content:SetPoint("CENTER", Frame)
				Frame.Content:SetFrameStrata("HIGH")
				Frame.Content:SetFrameLevel(2)

				do -- Title
					Frame.Content.Title = CreateFrame("Frame", "$parent.Title", Frame.Content)
					Frame.Content.Title:SetSize(Frame.Content:GetWidth(), Frame.Content:GetHeight() * .625)
					Frame.Content.Title:SetPoint("TOP", Frame.Content, 0, 0)
					Frame.Content.Title:SetFrameStrata("HIGH")
					Frame.Content.Title:SetFrameLevel(3)

					do -- Background
						Frame.Content.Title.Background, Frame.Content.Title.BackgroundTexture = addon.API.FrameTemplates:CreateTexture(Frame.Content.Title, "HIGH", NS.Variables.PATH .. "content-background.png")
						Frame.Content.Title.Background:SetSize(Frame.Content.Title:GetWidth(), Frame.Content.Title:GetHeight())
						Frame.Content.Title.Background:SetPoint("CENTER", Frame.Content.Title)
						Frame.Content.Title.Background:SetFrameStrata("HIGH")
						Frame.Content.Title.Background:SetFrameLevel(2)
					end

					do -- Text
						Frame.Content.Title.Text = addon.API.FrameTemplates:CreateText(Frame.Content.Title, addon.Theme.RGB_WHITE, 25, "CENTER", "MIDDLE", GameFontNormal:GetFont(), "$parent.Text")
						Frame.Content.Title.Text:SetSize(Frame.Content.Title:GetWidth(), Frame.Content.Title:GetHeight())
						Frame.Content.Title.Text:SetPoint("CENTER", Frame.Content.Title)
					end
				end

				do -- Shortcut
					Frame.Content.Shortcut = CreateFrame("Frame", "$parent.Shortcut", Frame.Content)
					Frame.Content.Shortcut:SetSize(Frame.Content:GetWidth(), Frame.Content:GetHeight() * .375)
					Frame.Content.Shortcut:SetPoint("TOP", Frame.Content, 0, -Frame.Content.Title:GetHeight())
					Frame.Content.Shortcut:SetFrameStrata("HIGH")
					Frame.Content.Shortcut:SetFrameLevel(3)

					do -- Text
						Frame.Content.Shortcut.Text = addon.API.FrameTemplates:CreateText(Frame.Content.Shortcut, addon.Theme.RGB_WHITE, 12.5, "CENTER", "MIDDLE", GameFontNormal:GetFont(), "$parent.Text")
						Frame.Content.Shortcut.Text:SetSize(Frame.Content.Shortcut:GetWidth(), Frame.Content.Shortcut:GetHeight())
						Frame.Content.Shortcut.Text:SetPoint("CENTER", Frame.Content.Shortcut)
					end
				end
			end
		end
	end

	local Frame = NS.Variables.Frame
	local Callback = NS.Script

end
