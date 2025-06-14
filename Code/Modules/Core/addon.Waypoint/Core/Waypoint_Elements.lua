---@class addon
local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local PrefabRegistry = addon.PrefabRegistry
local L = addon.Locales
local NS = addon.Waypoint; addon.Waypoint = NS

--------------------------------

NS.Elements = {}

--------------------------------

function NS.Elements:Load()
	--------------------------------
	-- CREATE ELEMENTS
	--------------------------------

	do
		do -- ELEMENTS
			InteractionPinpointFrame = CreateFrame("Frame")
			InteractionPinpointFrame:SetParent(SuperTrackedFrame)
			InteractionPinpointFrame:SetSize(250, 50)
			InteractionPinpointFrame:SetPoint("CENTER", SuperTrackedFrame, 0, NS.Variables.DEFAULT_HEIGHT)

			InteractionWaypointFrame = CreateFrame("Frame", "InteractionWaypointFrame", SuperTrackedFrame)
			InteractionWaypointFrame:SetSize(5, 1000)
			InteractionWaypointFrame:SetPoint("BOTTOM", SuperTrackedFrame, 0, 100)
			InteractionWaypointFrame:SetScale(.5)
			InteractionWaypointFrame:SetIgnoreParentAlpha(true)

			--------------------------------

			do -- PINPOINT
				do -- BACKGROUND
					InteractionPinpointFrame.Background, InteractionPinpointFrame.BackgroundTexture = addon.API.FrameTemplates:CreateNineSlice(InteractionPinpointFrame, "BACKGROUND", NS.Variables.PATH .. "content.png", 25, .5, "$parent.Background")
					InteractionPinpointFrame.Background:SetSize(InteractionPinpointFrame:GetWidth(), InteractionPinpointFrame:GetHeight())
					InteractionPinpointFrame.Background:SetPoint("CENTER", InteractionPinpointFrame)
				end

				do -- LINE
					InteractionPinpointFrame.Line, InteractionPinpointFrame.LineTexture = addon.API.FrameTemplates:CreateTexture(InteractionPinpointFrame, "BACKGROUND", NS.Variables.PATH .. "line-up.png", "$parent.Line")
					InteractionPinpointFrame.Line:SetSize(NS.Variables.LINE_WIDTH, NS.Variables.LINE_HEIGHT)

					--------------------------------

					local function UpdateLinePosition()
						InteractionPinpointFrame.Line:SetPoint("TOP", InteractionPinpointFrame.Background, 0, -InteractionPinpointFrame.Background:GetHeight())
					end

					--------------------------------

					InteractionPinpointFrame.Background:HookScript("OnSizeChanged", UpdateLinePosition)
				end

				do -- SHINE
					InteractionPinpointFrame.Shine, InteractionPinpointFrame.ShineTexture = addon.API.FrameTemplates:CreateNineSlice(InteractionPinpointFrame.Background, "HIGH", NS.Variables.PATH .. "content-add.png", 25, .5, "$parent.Shine")
					InteractionPinpointFrame.Shine:SetAllPoints(InteractionPinpointFrame.Background, true)
					InteractionPinpointFrame.ShineTexture:SetBlendMode("ADD")
				end

				do -- LABEL
					InteractionPinpointFrame.Label = addon.API.FrameTemplates:CreateText(InteractionPinpointFrame.Background, { r = 1, g = 1, b = 1 }, 15, "CENTER", "MIDDLE", addon.API.Fonts.CONTENT_LIGHT, "$parent.Label")
					InteractionPinpointFrame.Label:SetSize(InteractionPinpointFrame:GetWidth() - 15, InteractionPinpointFrame:GetHeight() - 15)
					InteractionPinpointFrame.Label:SetPoint("CENTER", InteractionPinpointFrame)
				end
			end

			do -- WAYPOINT
				do -- LINE
					InteractionWaypointFrame.Line, InteractionWaypointFrame.LineTexture = addon.API.FrameTemplates:CreateTexture(InteractionWaypointFrame, "BACKGROUND", NS.Variables.PATH .. "waypoint.png", "$parent.Line")
					InteractionWaypointFrame.Line:SetParent(InteractionWaypointFrame)
					InteractionWaypointFrame.Line:SetSize(75, 1000)
					InteractionWaypointFrame.Line:SetPoint("BOTTOM", InteractionWaypointFrame)
				end

				do -- GLOW
					InteractionWaypointFrame.Glow, InteractionWaypointFrame.GlowTexture = addon.API.FrameTemplates:CreateTexture(InteractionWaypointFrame, "BACKGROUND", NS.Variables.PATH .. "glow.png", "$parent.Glow")
					InteractionWaypointFrame.Glow:SetParent(InteractionWaypointFrame)
					InteractionWaypointFrame.Glow:SetSize(350, 350)
					InteractionWaypointFrame.Glow:SetPoint("BOTTOM", InteractionWaypointFrame, 0, -175)
					InteractionWaypointFrame.Glow:SetAlpha(.5)

					--------------------------------

					InteractionWaypointFrame.Glow:SetScript("OnUpdate", function(self, elapsed)
						if InteractionWaypointFrame:IsVisible() then
							InteractionWaypointFrame.Glow:Show()
						else
							InteractionWaypointFrame.Glow:Hide()
						end

						--------------------------------

						local Duration = 3.75
						local MinAlpha = .25
						local MaxAlpha = .5

						InteractionWaypointFrame.Glow.TimeSinceLastUpdate = (InteractionWaypointFrame.Glow.TimeSinceLastUpdate or 0) + elapsed
						if InteractionWaypointFrame.Glow.TimeSinceLastUpdate > Duration then
							InteractionWaypointFrame.Glow.TimeSinceLastUpdate = InteractionWaypointFrame.Glow.TimeSinceLastUpdate % Duration
						end

						local Progress = InteractionWaypointFrame.Glow.TimeSinceLastUpdate / Duration
						local AlphaRange = MaxAlpha - MinAlpha
						local New = MinAlpha + AlphaRange * (.5 + .5 * math.sin(Progress * math.pi * 2))

						InteractionWaypointFrame.Glow:SetAlpha(New)
					end)
				end

				do -- GLOW ANIMATION
					InteractionWaypointFrame.GlowAnimation = addon.API.Animation:CreateSpriteSheet(InteractionWaypointFrame, NS.Variables.PATH .. "glow-flipbook.png", 4, 4, .00725, false)
					InteractionWaypointFrame.GlowAnimation:SetParent(InteractionWaypointFrame)
					InteractionWaypointFrame.GlowAnimation:SetSize(50, 50)
					InteractionWaypointFrame.GlowAnimation:SetPoint("BOTTOM", InteractionWaypointFrame, 0, -25)

					--------------------------------

					InteractionWaypointFrame.GlowAnimation:SetAlpha(0)
				end

				do -- DISTANCE
					InteractionWaypointFrame.Distance = addon.API.FrameTemplates:CreateText(InteractionWaypointFrame, { r = 1, g = .8, b = .1 }, 27.5, "CENTER", "MIDDLE", addon.API.Fonts.CONTENT_LIGHT, "$parent.Distance")
					InteractionWaypointFrame.Distance:SetParent(InteractionWaypointFrame)
					InteractionWaypointFrame.Distance:SetSize(200, 200)
					InteractionWaypointFrame.Distance:SetPoint("BOTTOM", InteractionWaypointFrame, 0, -125)
					InteractionWaypointFrame.Distance:SetAlpha(.75)
				end

				--------------------------------

				InteractionWaypointFrame:SetScript("OnUpdate", function()
					local IsSuperTrackedFrameVisible = SuperTrackedFrame:IsVisible()
					local IsNavigationStateValid = C_Navigation.GetTargetState() ~= Enum.NavigationState.Invalid

					--------------------------------

					if not IsSuperTrackedFrameVisible or not IsNavigationStateValid then
						InteractionWaypointFrame:Hide()
					end
				end)
			end
		end
	end

	--------------------------------
	-- SETUP
	--------------------------------

	InteractionPinpointFrame:Hide()
	InteractionPinpointFrame.Shine:SetAlpha(0)
	InteractionWaypointFrame:Hide()
end
