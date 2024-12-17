local addonName, addon = ...
local NS = AdaptiveAPI.FrameTemplates

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

		ScrollChildFrame:SetPoint("TOP", Frame)

		--------------------------------

		if orientation == "horizontal" then
			ScrollBar:Hide()
		end

		--------------------------------

		if orientation == "horizontal" then
			ScrollChildFrame:SetHeight(Frame:GetHeight())
		else
			ScrollChildFrame:SetWidth(Frame:GetWidth())
		end

		--------------------------------

		local function UpdateSize()
			if orientation == "horizontal" then
				ScrollChildFrame:SetHeight(Frame:GetHeight())
			else
				ScrollChildFrame:SetWidth(Frame:GetWidth())
			end
		end

		hooksecurefunc(Frame, "SetSize", UpdateSize)
		hooksecurefunc(Frame, "SetWidth", UpdateSize)
		hooksecurefunc(Frame, "SetHeight", UpdateSize)

		--------------------------------

		Frame:SetScrollChild(ScrollChildFrame)

		--------------------------------

		return Frame, ScrollChildFrame
	end
end
