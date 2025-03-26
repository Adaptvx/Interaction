local addonName, addon = ...
local PrefabRegistry = addon.PrefabRegistry
local CallbackRegistry = addon.CallbackRegistry
local L = addon.Locales
local NS = addon.Interaction.Dialog

--------------------------------

NS.Elements = {}

--------------------------------

function NS.Elements:Load()
	--------------------------------
	-- CREATE ELEMENTS
	--------------------------------

	do
		do -- CREATE ELEMENTS
			InteractionDialogFrame = CreateFrame("Frame", "InteractionDialogFrame", InteractionFrame)
			InteractionDialogFrame:SetSize(400, 125)
			InteractionDialogFrame:SetFrameStrata("LOW")
			InteractionDialogFrame:SetFrameLevel(1)

			--------------------------------

			do -- STYLE DIALOG
				do -- BACKGROUND
					InteractionDialogFrame.DialogBackground, InteractionDialogFrame.DialogBackgroundTexture = addon.API.FrameTemplates:CreateNineSlice(InteractionDialogFrame, "LOW", nil, 50, .575)
					InteractionDialogFrame.DialogBackground:SetSize(InteractionDialogFrame:GetWidth(), InteractionDialogFrame:GetHeight())
					InteractionDialogFrame.DialogBackground:SetPoint("CENTER", InteractionDialogFrame, 0, 0)
					InteractionDialogFrame.DialogBackground:SetFrameStrata("LOW")
					InteractionDialogFrame.DialogBackground:SetFrameLevel(0)

					addon.API.Main:RegisterThemeUpdate(function()
						local TooltipTexture

						if addon.Theme.IsDarkTheme_Dialog then
							TooltipTexture = addon.API.Presets.NINESLICE_TOOLTIP_02
						else
							TooltipTexture = addon.API.Presets.NINESLICE_TOOLTIP
						end

						InteractionDialogFrame.DialogBackgroundTexture:SetTexture(TooltipTexture)
					end, 5)
				end

				do -- TAIL
					InteractionDialogFrame.DialogBackground.Tail, InteractionDialogFrame.DialogBackground.TailTexture = addon.API.FrameTemplates:CreateTexture(InteractionDialogFrame, "LOW", nil)
					InteractionDialogFrame.DialogBackground.Tail:SetParent(InteractionDialogFrame.DialogBackground)
					InteractionDialogFrame.DialogBackground.Tail:SetSize(22, 22 * 1.07)
					InteractionDialogFrame.DialogBackground.Tail:SetPoint("BOTTOM", InteractionDialogFrame.DialogBackground, -10, -17)
					InteractionDialogFrame.DialogBackground.Tail:SetFrameStrata("LOW")
					InteractionDialogFrame.DialogBackground.Tail:SetFrameLevel(1)

					addon.API.Main:RegisterThemeUpdate(function()
						local TEXTURE_Background

						if addon.Theme.IsDarkTheme_Dialog then
							TEXTURE_Background = addon.Variables.PATH_ART .. "Dialog/tooltip-tail-dark.png"
						else
							TEXTURE_Background = addon.Variables.PATH_ART .. "Dialog/tooltip-tail-light.png"
						end

						InteractionDialogFrame.DialogBackground.TailTexture:SetTexture(TEXTURE_Background)
					end, 5)
				end
			end

			do -- STYLE SCROLL
				InteractionDialogFrame.ScrollBackground, InteractionDialogFrame.ScrollBackgroundTexture = addon.API.FrameTemplates:CreateNineSlice(InteractionDialogFrame, "LOW", nil, 128, .25, "$parent.Background")
				InteractionDialogFrame.ScrollBackground:SetPoint("TOPLEFT", InteractionDialogFrame.DialogBackground, -3.25, 3.25)
				InteractionDialogFrame.ScrollBackground:SetPoint("BOTTOMRIGHT", InteractionDialogFrame.DialogBackground, 3.25, -3.25)
				InteractionDialogFrame.ScrollBackground:SetFrameStrata("LOW")
				InteractionDialogFrame.ScrollBackground:SetFrameLevel(0)

				addon.API.Main:RegisterThemeUpdate(function()
					local ScrollTexture

					if addon.Theme.IsDarkTheme_Dialog or addon.Theme.IsRusticTheme_Dialog then
						ScrollTexture = addon.API.Presets.NINESLICE_STYLISED_SCROLL_02
					else
						ScrollTexture = addon.API.Presets.NINESLICE_STYLISED_SCROLL
					end

					InteractionDialogFrame.ScrollBackgroundTexture:SetTexture(ScrollTexture)
				end, 5)

				InteractionDialogFrame.ScrollBackground:Hide()
			end

			do -- STYLE RUSTIC
				InteractionDialogFrame.RusticBackground, InteractionDialogFrame.RusticBackgroundTexture = addon.API.FrameTemplates:CreateNineSlice(InteractionDialogFrame, "LOW", addon.Variables.PATH_ART .. "Gradient/backdrop-nineslice.png", 128, .5, "$parent.RusticBackground")
				InteractionDialogFrame.RusticBackground:SetSize(InteractionDialogFrame.DialogBackground:GetWidth() + 55, InteractionDialogFrame.DialogBackground:GetHeight() + 55)
				InteractionDialogFrame.RusticBackground:SetPoint("CENTER", InteractionDialogFrame)
				InteractionDialogFrame.RusticBackground:SetFrameStrata("LOW")
				InteractionDialogFrame.RusticBackground:SetFrameLevel(0)

				InteractionDialogFrame.RusticBackgroundTexture:SetSize(InteractionDialogFrame.RusticBackground:GetWidth(), InteractionDialogFrame.RusticBackground:GetHeight())
				InteractionDialogFrame.RusticBackgroundTexture:SetPoint("CENTER", InteractionDialogFrame.RusticBackground)
				InteractionDialogFrame.RusticBackgroundTexture:SetAlpha(.875)

				--------------------------------

				hooksecurefunc(InteractionDialogFrame.DialogBackground, "SetWidth", function()
					InteractionDialogFrame.RusticBackground:SetWidth(InteractionDialogFrame.DialogBackground:GetWidth() + 55)
				end)

				hooksecurefunc(InteractionDialogFrame.DialogBackground, "SetHeight", function()
					InteractionDialogFrame.RusticBackground:SetHeight(InteractionDialogFrame.DialogBackground:GetHeight() + 55)
				end)
			end

			do -- TITLE
				InteractionDialogFrame.Title = CreateFrame("Frame", "$parent.Title", InteractionDialogFrame)
				InteractionDialogFrame.Title:SetFrameStrata("BACKGROUND")

				--------------------------------

				do -- TEXT
					InteractionDialogFrame.Title.Label = addon.API.FrameTemplates:CreateText(
						InteractionDialogFrame.Title,
						{ r = 1, g = 1, b = 1 },
						15,
						"CENTER",
						"MIDDLE",
						addon.API.Fonts.Content_Light,
						"$parent.Label"
					)
					InteractionDialogFrame.Title.Label:SetPoint("TOP", InteractionDialogFrame.DialogBackground, 0, NS.Variables:RATIO(.5) + NS.Variables:RATIO(1.5))
					InteractionDialogFrame.Title.Label:SetSize(500, 50)
					InteractionDialogFrame.Title.Label:SetSpacing(0)
				end

				do -- PROGRESS BAR
					InteractionDialogFrame.Title.Progress, InteractionDialogFrame.Title.ProgressTexture = addon.API.FrameTemplates:CreateNineSlice(InteractionDialogFrame, "BACKGROUND", addon.API.Presets.BASIC_SQUARE, 25, 1, "$parent.Progress")
					InteractionDialogFrame.Title.Progress:SetParent(InteractionDialogFrame.Title)
					InteractionDialogFrame.Title.Progress:SetSize(150, 8)
					InteractionDialogFrame.Title.Progress:SetPoint("TOP", InteractionDialogFrame.DialogBackground, 0, NS.Variables:RATIO(2.5))
					InteractionDialogFrame.Title.Progress:SetFrameStrata("BACKGROUND")
					InteractionDialogFrame.Title.Progress:SetFrameLevel(1)
					InteractionDialogFrame.Title.ProgressTexture:SetVertexColor(.1, .1, .1, .75)

					addon.API.FrameUtil:AnchorToCenter(InteractionDialogFrame.Title.Progress)

					InteractionDialogFrame.Title.Progress:SetScript("OnEnter", function()
						InteractionDialogFrame.Title.ProgressTexture:SetVertexColor(.25, .25, .25, .75)
					end)

					InteractionDialogFrame.Title.Progress:SetScript("OnLeave", function()
						InteractionDialogFrame.Title.ProgressTexture:SetVertexColor(.1, .1, .1, .75)
					end)

					--------------------------------

					do -- STATUS BAR
						InteractionDialogFrame.Title.Progress.Bar = CreateFrame("StatusBar", "$parent.Bar", InteractionDialogFrame.Title.Progress)
						InteractionDialogFrame.Title.Progress.Bar:SetParent(InteractionDialogFrame.Title.Progress)
						InteractionDialogFrame.Title.Progress.Bar:SetSize(InteractionDialogFrame.Title.Progress:GetWidth(), InteractionDialogFrame.Title.Progress:GetHeight() - 4)
						InteractionDialogFrame.Title.Progress.Bar:SetPoint("CENTER", InteractionDialogFrame.Title.Progress, 0, 0)
						InteractionDialogFrame.Title.Progress.Bar:SetStatusBarTexture(addon.API.Presets.BASIC_SQUARE)
						InteractionDialogFrame.Title.Progress.Bar:SetStatusBarColor(.5, .5, .5, 1)
						InteractionDialogFrame.Title.Progress.Bar:SetFrameStrata("BACKGROUND")
						InteractionDialogFrame.Title.Progress.Bar:SetFrameLevel(2)

						InteractionDialogFrame.Title.Progress.Bar:SetMinMaxValues(0, 1)
						InteractionDialogFrame.Title.Progress.Bar:SetValue(1)
					end
				end
			end

			do -- CONTENT
                InteractionDialogFrame.Content = CreateFrame("Frame", "$parent.Content", InteractionDialogFrame)
                InteractionDialogFrame.Content:SetPoint("TOPLEFT", InteractionDialogFrame.DialogBackground, 5, -5)
				InteractionDialogFrame.Content:SetPoint("BOTTOMRIGHT", InteractionDialogFrame.DialogBackground, -5, 5)
				InteractionDialogFrame.Content:SetClipsChildren(true)

				--------------------------------

				do -- TEXT
					local TEXT_SIZE = addon.Database.DB_GLOBAL.profile.INT_CONTENT_SIZE

					--------------------------------

					do -- MEASUREMENT
						InteractionDialogFrame.Content.Measurement = addon.API.FrameTemplates:CreateText(InteractionDialogFrame.Content, { r = 1, g = 1, b = 1 }, TEXT_SIZE, "LEFT", "MIDDLE", addon.API.Fonts.Content_Light)
						InteractionDialogFrame.Content.Measurement:SetPoint("CENTER", InteractionDialogFrame.DialogBackground, 0, 0)
						InteractionDialogFrame.Content.Measurement:SetSize(InteractionDialogFrame:GetWidth(), 500)
						InteractionDialogFrame.Content.Measurement:SetAlpha(0)
					end

					do -- LABEL
						InteractionDialogFrame.Content.Label = addon.API.FrameTemplates:CreateText(InteractionDialogFrame.Content, { r = 1, g = 1, b = 1 }, TEXT_SIZE, "LEFT", "TOP", addon.API.Fonts.Content_Light)
						InteractionDialogFrame.Content.Label:SetPoint("CENTER", InteractionDialogFrame.DialogBackground, 0, 0)
						InteractionDialogFrame.Content.Label:SetSize(InteractionDialogFrame:GetWidth(), 75)
						InteractionDialogFrame.Content.Label:SetShadowOffset(0, 0)
					end
				end
			end
		end
	end

	--------------------------------
	-- REFERENCES
	--------------------------------

	local Frame = InteractionDialogFrame
	local Callback = NS.Script

	--------------------------------
	-- SETUP
	--------------------------------

	do
		Frame:Hide()
		Frame.hidden = true
	end
end
