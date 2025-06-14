---@class addon
local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local PrefabRegistry = addon.PrefabRegistry
local L = addon.Locales
local NS = addon.AlertNotification; addon.AlertNotification = NS

--------------------------------

NS.Elements = {}

--------------------------------

function NS.Elements:Load()
	--------------------------------
	-- CREATE ELEMENTS
	--------------------------------

	do
		do -- ELEMENTS
			InteractionFrame.AlertNotification = CreateFrame("Frame", "$parent.AlertNotification", InteractionFrame)
			InteractionFrame.AlertNotification:SetHeight(50)
			InteractionFrame.AlertNotification:SetFrameStrata(NS.Variables.FRAME_STRATA)
			InteractionFrame.AlertNotification:SetFrameLevel(NS.Variables.FRAME_LEVEL)

			local Frame = InteractionFrame.AlertNotification

			--------------------------------

			local PADDING = NS.Variables.PADDING

			do -- NOTIFICATION
				Frame.Notification = CreateFrame("Frame", "$parent.Notification", Frame)
				Frame.Notification:SetPoint("CENTER", Frame)
				Frame.Notification:SetFrameStrata(NS.Variables.FRAME_STRATA)
				Frame.Notification:SetFrameLevel(NS.Variables.FRAME_LEVEL + 1)
				addon.API.FrameUtil:SetDynamicSize(Frame.Notification, Frame, 0, 0)

				local Notification = Frame.Notification

				--------------------------------

				do -- BACKGROUND
					Notification.Background, Notification.BackgroundTexture = addon.API.FrameTemplates:CreateNineSlice(Notification, NS.Variables.FRAME_STRATA, addon.Variables.PATH_ART .. "Gradient/backdrop-nineslice.png", 128, .5, "$parent.Background")
					Notification.Background:SetPoint("CENTER", Notification)
					Notification.Background:SetFrameStrata(NS.Variables.FRAME_STRATA)
					Notification.Background:SetFrameLevel(NS.Variables.FRAME_LEVEL - 1)
					addon.API.FrameUtil:SetDynamicSize(Notification.Background, Notification, -25, -25)
					Notification.BackgroundTexture:SetVertexColor(.5, .5, .5)
				end

				do -- LAYOUT GROUP
					Notification.LayoutGroup, Notification.LayoutGroup_Sort = addon.API.FrameTemplates:CreateLayoutGroup(Notification, { point = "LEFT", direction = "horizontal", resize = true, padding = PADDING, distribute = false, distributeResizeElements = false, excludeHidden = true, autoSort = true, customOffset = nil, customLayoutSort = nil }, "$parent.LayoutGroup")
					Notification.LayoutGroup:SetPoint("CENTER", Notification)
					Notification.LayoutGroup:SetFrameStrata(NS.Variables.FRAME_STRATA)
					Notification.LayoutGroup:SetFrameLevel(NS.Variables.FRAME_LEVEL + 2)
					addon.API.FrameUtil:SetDynamicSize(Notification.LayoutGroup, Notification, nil, 0)
					addon.API.FrameUtil:SetDynamicSize(Frame, Notification.LayoutGroup, -35, nil)
					CallbackRegistry:Add("LayoutGroupSort AlertNotification.Notification", Notification.LayoutGroup_Sort)

					local LayoutGroup = Notification.LayoutGroup

					--------------------------------

					do -- ELEMENTS
						local IMAGE_SIZE = 17.5

						--------------------------------

						do -- IMAGE
							LayoutGroup.Image, LayoutGroup.ImageTexture = addon.API.FrameTemplates:CreateTexture(LayoutGroup, NS.Variables.FRAME_STRATA, NS.Variables.PATH .. "check.png")
							LayoutGroup.Image:SetSize(IMAGE_SIZE, IMAGE_SIZE)
							LayoutGroup.Image:SetFrameStrata(NS.Variables.FRAME_STRATA)
							LayoutGroup.Image:SetFrameLevel(NS.Variables.FRAME_LEVEL + 3)
							LayoutGroup:AddElement(LayoutGroup.Image)
						end

						do -- TEXT
							LayoutGroup.Text = addon.API.FrameTemplates:CreateText(LayoutGroup, addon.Theme.RGB_WHITE, 15, "LEFT", "MIDDLE", addon.API.Fonts.CONTENT_LIGHT, "$parent.Text")
							addon.API.FrameUtil:SetDynamicTextSize(LayoutGroup.Text, LayoutGroup, 10000, nil)
							LayoutGroup:AddElement(LayoutGroup.Text)
						end
					end
				end
			end

			do -- FLARE
				Frame.Flare = CreateFrame("Frame", "$parent.Flare", Frame)
				Frame.Flare:SetSize(1000, 150)
				Frame.Flare:SetPoint("CENTER", Frame)
				Frame.Flare:SetFrameStrata(NS.Variables.FRAME_STRATA)
				Frame.Flare:SetFrameLevel(NS.Variables.FRAME_LEVEL_MAX)
				Frame.Flare:SetIgnoreParentScale(true)
				Frame.Flare:SetIgnoreParentAlpha(true)

				local Flare = Frame.Flare

				--------------------------------

				do -- BACKGROUND
					Flare.Background, Flare.BackgroundTexture = addon.API.FrameTemplates:CreateTexture(Flare, NS.Variables.FRAME_STRATA, NS.Variables.PATH .. "flare.png")
					Flare.Background:SetPoint("CENTER", Frame.Flare)
					Flare.Background:SetFrameStrata(NS.Variables.FRAME_STRATA)
					Flare.Background:SetFrameLevel(NS.Variables.FRAME_LEVEL_MAX - 1)
					addon.API.FrameUtil:SetDynamicSize(Flare.Background, Flare, 0, 0)
				end
			end
		end

		do -- REFERENCES
			local Frame = InteractionFrame.AlertNotification

			--------------------------------

			-- CORE
			Frame.REF_NOTIFICATION = Frame.Notification
			Frame.REF_FLARE = Frame.Flare

			-- NOTIFICATION
			Frame.REF_NOTIFICATION_TEXT = Frame.REF_NOTIFICATION.LayoutGroup.Text
			Frame.REF_NOTIFICATION_IMAGE = Frame.REF_NOTIFICATION.LayoutGroup.Image

			-- FLARE
			Frame.REF_FLARE_BACKGROUND = Frame.REF_FLARE.Background
		end
	end

	--------------------------------
	-- REFERENCES
	--------------------------------

	local Frame = InteractionFrame.AlertNotification
	local Callback = NS.Script; NS.Script = Callback

	--------------------------------
	-- SETUP
	--------------------------------

	do
		Frame:Hide()
		Frame.Flare:Hide()
		Frame.hidden = true
	end
end
