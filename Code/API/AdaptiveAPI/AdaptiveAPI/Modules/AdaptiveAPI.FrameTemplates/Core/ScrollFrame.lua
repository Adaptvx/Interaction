local addonName, addon = ...
local NS = AdaptiveAPI.FrameTemplates
local CallbackRegistry = addon.CallbackRegistry

--------------------------------
-- VARIABLES
--------------------------------

do -- MAIN

end

do -- CONSTANTS

end

--------------------------------
-- TEMPLATES
--------------------------------

do
	-- Creates scroll frame that supports horizontal or vertical scrolling.
	---@param parent any
	---@param orientation string
	function NS:CreateScrollFrame(parent, orientation)
		local Frame = CreateFrame("ScrollFrame", nil, parent, "ScrollFrameTemplate")
		local ScrollBar = Frame.ScrollBar
		local ScrollChildFrame = CreateFrame("Frame", "$parent.ScrollChildFrame", Frame)

		--------------------------------

		do -- ELEMENTS
			do -- SCROLL CHILD
				ScrollChildFrame:SetPoint("TOP", Frame)
				Frame:SetScrollChild(ScrollChildFrame)
			end

			do -- SCROLL BAR
				if orientation == "horizontal" then
					ScrollBar:Hide()
				end
			end
		end

		do -- EVENTS
			local function UpdateSize()
				if orientation == "horizontal" then
					ScrollChildFrame:SetHeight(Frame:GetHeight())
				else
					ScrollChildFrame:SetWidth(Frame:GetWidth())
				end
			end
			UpdateSize()

			hooksecurefunc(Frame, "SetSize", UpdateSize)
			hooksecurefunc(Frame, "SetWidth", UpdateSize)
			hooksecurefunc(Frame, "SetHeight", UpdateSize)
		end

		--------------------------------

		return Frame, ScrollChildFrame
	end
end
