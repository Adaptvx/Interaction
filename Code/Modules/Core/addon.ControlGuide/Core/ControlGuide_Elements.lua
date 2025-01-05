local addonName, addon = ...
local CallbackRegistry = addon.CallbackRegistry
local L = addon.Locales
local NS = addon.ControlGuide

--------------------------------

NS.Elements = {}

--------------------------------

function NS.Elements:Load()
	--------------------------------
	-- CREATE ELEMENTS
	--------------------------------

	do
		do -- CREATE ELEMENTS
			InteractionControlGuideFrame = CreateFrame("Frame", "InteractionControlGuideFrame", InteractionFrame)
			InteractionControlGuideFrame:SetSize(500, 35)
			InteractionControlGuideFrame:SetPoint("BOTTOM", UIParent, 0, NS.Variables:RATIO(1.5))
			InteractionControlGuideFrame:SetFrameStrata("HIGH")
			InteractionControlGuideFrame:SetFrameLevel(0)

			--------------------------------

			local Frame = InteractionControlGuideFrame

			--------------------------------

			do -- CONTENT
				Frame.Content = CreateFrame("Frame", "$parent.Content", Frame)
				Frame.Content:SetAllPoints(Frame)
				Frame.Content:SetFrameStrata("HIGH")
				Frame.Content:SetFrameLevel(0)
				Frame.Content:SetAlpha(.5)

				--------------------------------

				do -- ELEMENTS
					local function CreateElement(parent)
						local Element = CreateFrame("Frame", nil, parent)
						Element:SetSize(100, 35)
						Element:SetFrameStrata("HIGH")
						Element:SetFrameLevel(1)

						--------------------------------

						do -- TEXT
							Element.Text = AdaptiveAPI.FrameTemplates:CreateText(Element, addon.Theme.RGB_WHITE, 12.5, "CENTER", "MIDDLE", AdaptiveAPI.Fonts.Content_Light, "$parent.Text")
							Element.Text:SetAllPoints(Element)
							Element.Text:SetAlpha(.75)

							--------------------------------

							addon.API:SetButtonToPlatform(Element, Element.Text, "")
						end

						do -- EVENTS
							Element.UpdateSize = function()
								Element:SetWidth(Element.API_ButtonTextFrame:GetWidth())
							end
							Element.UpdateSize()

							--------------------------------

							hooksecurefunc(Element.Text, "SetText", Element.UpdateSize)
						end

						--------------------------------

						return Element
					end

					--------------------------------

					Frame.Elements = {}

					local numElements = 10
					for i = 1, numElements do
						local Element = CreateElement(Frame.Content)
						table.insert(Frame.Elements, Element)
					end
				end
			end
		end
	end

	--------------------------------
	-- REFERENCES
	--------------------------------

	local Frame = InteractionControlGuideFrame
	local Callback = NS.Script

	--------------------------------
	-- SETUP
	--------------------------------

	do
		Frame:Hide()
		Frame.hidden = true
	end
end
