local addonName, addon = ...
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
					InteractionDialogFrame.DialogBackground, InteractionDialogFrame.DialogBackgroundTexture = AdaptiveAPI.FrameTemplates:CreateNineSlice(InteractionDialogFrame, "LOW", nil, 50, .575)
					InteractionDialogFrame.DialogBackground:SetSize(InteractionDialogFrame:GetWidth(), InteractionDialogFrame:GetHeight())
					InteractionDialogFrame.DialogBackground:SetPoint("CENTER", InteractionDialogFrame, 0, 0)
					InteractionDialogFrame.DialogBackground:SetFrameStrata("LOW")
					InteractionDialogFrame.DialogBackground:SetFrameLevel(0)

					addon.API:RegisterThemeUpdate(function()
						local TooltipTexture

						if addon.Theme.IsDarkTheme_Dialog then
							TooltipTexture = AdaptiveAPI.Presets.NINESLICE_TOOLTIP_02
						else
							TooltipTexture = AdaptiveAPI.Presets.NINESLICE_TOOLTIP
						end

						InteractionDialogFrame.DialogBackgroundTexture:SetTexture(TooltipTexture)
					end, 5)
				end

				do -- TAIL
					InteractionDialogFrame.DialogBackground.Tail, InteractionDialogFrame.DialogBackground.TailTexture = AdaptiveAPI.FrameTemplates:CreateTexture(InteractionDialogFrame, "LOW", nil)
					InteractionDialogFrame.DialogBackground.Tail:SetParent(InteractionDialogFrame.DialogBackground)
					InteractionDialogFrame.DialogBackground.Tail:SetSize(22, 22)
					InteractionDialogFrame.DialogBackground.Tail:SetPoint("BOTTOM", InteractionDialogFrame.DialogBackground, -10, -16.5)
					InteractionDialogFrame.DialogBackground.Tail:SetFrameStrata("LOW")
					InteractionDialogFrame.DialogBackground.Tail:SetFrameLevel(1)
					InteractionDialogFrame.DialogBackground.TailTexture:SetVertexColor(.75, .75, .75)

					addon.API:RegisterThemeUpdate(function()
						local TEXTURE_Background

						if addon.Theme.IsDarkTheme_Dialog then
							TEXTURE_Background = addon.Variables.PATH .. "Art/Dialog/tooltip-tail-dark-mode.png"
						else
							TEXTURE_Background = addon.Variables.PATH .. "Art/Dialog/tooltip-tail.png"
						end

						InteractionDialogFrame.DialogBackground.TailTexture:SetTexture(TEXTURE_Background)
					end, 5)
				end
			end

			do -- STYLE SCROLL
				InteractionDialogFrame.ScrollBackground, InteractionDialogFrame.ScrollBackgroundTexture = AdaptiveAPI.FrameTemplates:CreateNineSlice(InteractionDialogFrame, "LOW", nil, 128, .25, "$parent.Background")
				InteractionDialogFrame.ScrollBackground:SetSize(InteractionDialogFrame.DialogBackground:GetWidth() + 7.5, InteractionDialogFrame.DialogBackground:GetHeight() + 7.5)
				InteractionDialogFrame.ScrollBackground:SetPoint("CENTER", InteractionDialogFrame.DialogBackground)
				InteractionDialogFrame.ScrollBackground:SetFrameStrata("LOW")
				InteractionDialogFrame.ScrollBackground:SetFrameLevel(0)

				addon.API:RegisterThemeUpdate(function()
					local ScrollTexture

					if addon.Theme.IsDarkTheme then
						ScrollTexture = AdaptiveAPI.Presets.NINESLICE_STYLISED_SCROLL_02
					else
						ScrollTexture = AdaptiveAPI.Presets.NINESLICE_STYLISED_SCROLL
					end

					InteractionDialogFrame.ScrollBackgroundTexture:SetTexture(ScrollTexture)
				end, 5)

				hooksecurefunc(InteractionDialogFrame.DialogBackground, "SetWidth", function()
					InteractionDialogFrame.ScrollBackground:SetWidth(InteractionDialogFrame.DialogBackground:GetWidth() + 7.5)
				end)

				hooksecurefunc(InteractionDialogFrame.DialogBackground, "SetHeight", function()
					InteractionDialogFrame.ScrollBackground:SetHeight(InteractionDialogFrame.DialogBackground:GetHeight() + 7.5)
				end)

				InteractionDialogFrame.ScrollBackground:Hide()
			end

			do -- STYLE SHADOW
				InteractionDialogFrame.ShadowBackground, InteractionDialogFrame.ShadowBackgroundTexture = AdaptiveAPI.FrameTemplates:CreateNineSlice(InteractionDialogFrame, "LOW", addon.Variables.PATH .. "Art/Gradient/backdrop-nineslice.png", 128, .5, "$parent.ShadowBackground")
				InteractionDialogFrame.ShadowBackground:SetSize(InteractionDialogFrame.DialogBackground:GetWidth() + 55, InteractionDialogFrame.DialogBackground:GetHeight() + 55)
				InteractionDialogFrame.ShadowBackground:SetPoint("CENTER", InteractionDialogFrame)
				InteractionDialogFrame.ShadowBackground:SetFrameStrata("LOW")
				InteractionDialogFrame.ShadowBackground:SetFrameLevel(0)

				InteractionDialogFrame.ShadowBackgroundTexture:SetSize(InteractionDialogFrame.ShadowBackground:GetWidth(), InteractionDialogFrame.ShadowBackground:GetHeight())
				InteractionDialogFrame.ShadowBackgroundTexture:SetPoint("CENTER", InteractionDialogFrame.ShadowBackground)
				InteractionDialogFrame.ShadowBackgroundTexture:SetAlpha(.875)

				--------------------------------

				hooksecurefunc(InteractionDialogFrame.DialogBackground, "SetWidth", function()
					InteractionDialogFrame.ShadowBackground:SetWidth(InteractionDialogFrame.DialogBackground:GetWidth() + 55)
				end)

				hooksecurefunc(InteractionDialogFrame.DialogBackground, "SetHeight", function()
					InteractionDialogFrame.ShadowBackground:SetHeight(InteractionDialogFrame.DialogBackground:GetHeight() + 55)
				end)
			end

			do -- TITLE
				InteractionDialogFrame.Title = CreateFrame("Frame", "$parent.Title", InteractionDialogFrame)
				InteractionDialogFrame.Title:SetFrameStrata("BACKGROUND")

				--------------------------------

				do -- TEXT
					InteractionDialogFrame.Title.Label = AdaptiveAPI.FrameTemplates:CreateText(
						InteractionDialogFrame.Title,
						{ r = 1, g = 1, b = 1 },
						15,
						"CENTER",
						"MIDDLE",
						AdaptiveAPI.Fonts.Content_Light,
						"$parent.Label"
					)
					InteractionDialogFrame.Title.Label:SetPoint("TOP", InteractionDialogFrame.DialogBackground, 0, NS.Variables:RATIO(.5) + NS.Variables:RATIO(1.5))
					InteractionDialogFrame.Title.Label:SetSize(500, 50)
					InteractionDialogFrame.Title.Label:SetSpacing(0)
				end

				do -- PROGRESS BAR
					InteractionDialogFrame.Title.Progress, InteractionDialogFrame.Title.ProgressTexture = AdaptiveAPI.FrameTemplates:CreateNineSlice(InteractionDialogFrame, "BACKGROUND", AdaptiveAPI.Presets.BASIC_SQUARE, 25, 1, "$parent.Progress")
					InteractionDialogFrame.Title.Progress:SetParent(InteractionDialogFrame.Title)
					InteractionDialogFrame.Title.Progress:SetSize(150, 8)
					InteractionDialogFrame.Title.Progress:SetPoint("TOP", InteractionDialogFrame.DialogBackground, 0, NS.Variables:RATIO(2.5))
					InteractionDialogFrame.Title.Progress:SetFrameStrata("BACKGROUND")
					InteractionDialogFrame.Title.Progress:SetFrameLevel(1)
					InteractionDialogFrame.Title.ProgressTexture:SetVertexColor(.1, .1, .1, .75)

					AdaptiveAPI:AnchorToCenter(InteractionDialogFrame.Title.Progress)

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
						InteractionDialogFrame.Title.Progress.Bar:SetStatusBarTexture(AdaptiveAPI.Presets.BASIC_SQUARE)
						InteractionDialogFrame.Title.Progress.Bar:SetStatusBarColor(.5, .5, .5, 1)
						InteractionDialogFrame.Title.Progress.Bar:SetFrameStrata("BACKGROUND")
						InteractionDialogFrame.Title.Progress.Bar:SetFrameLevel(2)

						InteractionDialogFrame.Title.Progress.Bar:SetMinMaxValues(0, 1)
						InteractionDialogFrame.Title.Progress.Bar:SetValue(1)
					end
				end

				do -- KEYBIND HINT
					InteractionDialogFrame.Title.KeybindHint = CreateFrame("Frame", "$parent.KeybindHint", InteractionDialogFrame)
					InteractionDialogFrame.Title.KeybindHint:SetSize(150, 30)
					InteractionDialogFrame.Title.KeybindHint:SetPoint("CENTER", InteractionDialogFrame.Title.Progress)
					InteractionDialogFrame.Title.KeybindHint:SetFrameStrata("BACKGROUND")
					InteractionDialogFrame.Title.KeybindHint:SetPropagateKeyboardInput(true)

					--------------------------------

					do -- LABEL
						InteractionDialogFrame.Title.KeybindHint.Label = AdaptiveAPI.FrameTemplates:CreateText(InteractionDialogFrame.Title.KeybindHint, { r = 1, g = 1, b = 1 }, 12.5, "LEFT", "MIDDLE", AdaptiveAPI.Fonts.Content_Bold, "$parent.Label")
						InteractionDialogFrame.Title.KeybindHint.Label:SetSize(50, InteractionDialogFrame.Title.KeybindHint:GetHeight() - 10)
						InteractionDialogFrame.Title.KeybindHint.Label:SetPoint("CENTER", InteractionDialogFrame.Title.KeybindHint, InteractionDialogFrame.Title.KeybindHint.Label:GetWidth() / 2 - 2.5, 0)
						InteractionDialogFrame.Title.KeybindHint.Label:SetText(L["InteractionDialogFrame - Skip"])
					end

					do -- FRAME
						InteractionDialogFrame.Title.KeybindHint.KeybindFrame = CreateFrame("Frame", "$parent.KeybindFrame", InteractionDialogFrame.Title.KeybindHint)
						InteractionDialogFrame.Title.KeybindHint.KeybindFrame:SetSize(35, InteractionDialogFrame.Title.KeybindHint:GetHeight() - 10)
						InteractionDialogFrame.Title.KeybindHint.KeybindFrame:SetPoint("CENTER", InteractionDialogFrame.Title.KeybindHint, -InteractionDialogFrame.Title.KeybindHint.KeybindFrame:GetWidth() / 2 - 5, 0)
						InteractionDialogFrame.Title.KeybindHint.KeybindFrame:SetFrameStrata("BACKGROUND")

						--------------------------------

						do -- LABEL
							InteractionDialogFrame.Title.KeybindHint.KeybindFrame.Label = AdaptiveAPI.FrameTemplates:CreateText(InteractionDialogFrame.Title.KeybindHint.KeybindFrame, { r = 1, g = 1, b = 1 }, 20, "CENTER", "MIDDLE", AdaptiveAPI.Fonts.Content_Light, "$parent.Label")
							InteractionDialogFrame.Title.KeybindHint.KeybindFrame.Label:SetPoint("CENTER", InteractionDialogFrame.Title.KeybindHint.KeybindFrame)
							InteractionDialogFrame.Title.KeybindHint.KeybindFrame.Label:SetSize(InteractionDialogFrame.Title.KeybindHint.KeybindFrame:GetWidth(), InteractionDialogFrame.Title.KeybindHint.KeybindFrame:GetHeight())
						end
					end

					--------------------------------
					-- FUNCTIONS
					--------------------------------

					InteractionDialogFrame.Title.KeybindHint.UpdateHint = function()
						if addon.Variables.Platform == 1 then
							if INTDB.profile.INT_USEINTERACTKEY then
								InteractionDialogFrame.Title.KeybindHint.KeybindFrame.Label:SetText(AdaptiveAPI:InlineIcon(addon.Variables.PATH .. "Art/Platform/Platform-PC-Interact.png", 16, 16, 0, 0))
							else
								InteractionDialogFrame.Title.KeybindHint.KeybindFrame.Label:SetText(AdaptiveAPI:InlineIcon(addon.Variables.PATH .. "Art/Platform/Platform-PC-Space.png", 16, 16, 0, 0))
							end
						elseif addon.Variables.Platform == 2 then
							InteractionDialogFrame.Title.KeybindHint.KeybindFrame.Label:SetText(AdaptiveAPI:InlineIcon(addon.Variables.PATH .. "Art/Platform/Platform-PS-3.png", 16, 16, 0, 0))
						elseif addon.Variables.Platform == 3 then
							InteractionDialogFrame.Title.KeybindHint.KeybindFrame.Label:SetText(AdaptiveAPI:InlineIcon(addon.Variables.PATH .. "Art/Platform/Platform-XBOX-2.png", 16, 16, 0, 0))
						end
					end

					--------------------------------
					-- SETUP
					--------------------------------

					InteractionDialogFrame.Title.KeybindHint.UpdateHint()

					CallbackRegistry:Add("SETTINGS_CONTROLS_CHANGED", function()
						InteractionDialogFrame.Title.KeybindHint.UpdateHint()
					end)
				end
			end

			do -- CONTENT
				InteractionDialogFrame.Content = CreateFrame("Frame", "$parent.Content", InteractionDialogFrame)

				--------------------------------

				do -- TEXT
					local TextSize = INTDB.profile.INT_CONTENT_SIZE

					--------------------------------

					do -- MEASUREMENT
						InteractionDialogFrame.Content.Measurement = AdaptiveAPI.FrameTemplates:CreateText(InteractionDialogFrame, { r = 1, g = 1, b = 1 }, TextSize, "LEFT", "MIDDLE", AdaptiveAPI.Fonts.Content_Light)
						InteractionDialogFrame.Content.Measurement:SetPoint("CENTER", InteractionDialogFrame.DialogBackground, 0, 0)
						InteractionDialogFrame.Content.Measurement:SetSize(InteractionDialogFrame:GetWidth(), 500)
						InteractionDialogFrame.Content.Measurement:SetAlpha(0)
					end

					do -- LABEL
						InteractionDialogFrame.Content.Label = AdaptiveAPI.FrameTemplates:CreateText(InteractionDialogFrame, { r = 1, g = 1, b = 1 }, TextSize, "LEFT", "TOP", AdaptiveAPI.Fonts.Content_Light)
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
