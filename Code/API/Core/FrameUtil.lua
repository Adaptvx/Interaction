local addon = select(2, ...)
addon.API.FrameUtil = {}

do
	function addon.API.FrameUtil:AnchorToCenter(frame, avoidButton)
		if not frame or not frame:GetParent() then return end

		local parent = frame:GetParent()
		if avoidButton then
			while parent and addon.API.Util:FindString(parent:GetDebugName(), "Button") do
				parent = parent:GetParent()
			end
		end

		local anchor = CreateFrame("Frame", nil, parent)
		anchor:SetPoint(frame:GetPoint())
		anchor:SetSize(frame:GetSize())
		frame:ClearAllPoints()
		frame:SetPoint("CENTER", anchor, "CENTER")
	end

	function addon.API.FrameUtil:SetVisibility(frame, visibility)
		frame:SetShown(visibility)
	end

	function addon.API.FrameUtil:GetMouseDelta(originX, originY)
		if not originX or not originY then return nil, nil end
		local mouseX, mouseY = GetCursorPosition()
		return mouseX - originX, originY - mouseY
	end

	function addon.API.FrameUtil:SetAllVariablesToChildren(frame, variable, value)
		for index = 1, frame:GetNumChildren() do
			local child = select(index, frame:GetChildren())
			if child.GetNumChildren and child:GetNumChildren() > 0 then addon.API.FrameUtil:SetAllVariablesToChildren(child, variable, value) end
			child[variable] = value
		end
	end

	function addon.API.FrameUtil:CallFunctionToAllChildren(frame, func)
		for index = 1, frame:GetNumChildren() do
			local child = select(index, frame:GetChildren())
			if child.GetNumChildren and child:GetNumChildren() > 0 then addon.API.FrameUtil:CallFunctionToAllChildren(child, func) end
			func(child)
		end
	end
end

do
	function addon.API.FrameUtil:SetDynamicSize(frame, relativeTo, paddingX, paddingY, updateAll, updateFrame)
		local function updateSize()
			if paddingX then frame:SetWidth(type(paddingX) == "function" and paddingX(relativeTo:GetWidth(), relativeTo:GetHeight()) or (relativeTo:GetWidth() - paddingX)) end
			if paddingY then frame:SetHeight(type(paddingY) == "function" and paddingY(relativeTo:GetWidth(), relativeTo:GetHeight()) or (relativeTo:GetHeight() - paddingY)) end
		end

		updateSize()
		local hookTarget = updateFrame or relativeTo
		if updateAll or (paddingX and paddingY) then hooksecurefunc(hookTarget, "SetSize", updateSize) end
		if updateAll or paddingX then hooksecurefunc(hookTarget, "SetWidth", updateSize) end
		if updateAll or paddingY then hooksecurefunc(hookTarget, "SetHeight", updateSize) end
		return updateSize
	end

	function addon.API.FrameUtil:SetDynamicTextSize(frame, relativeTo, maxWidth, maxHeight, setMaxWidth, setMaxHeight)
		local function updateSize()
			local width = maxWidth and (type(maxWidth) == "function" and maxWidth(relativeTo:GetWidth(), relativeTo:GetHeight()) or maxWidth) or relativeTo:GetWidth()
			local height = maxHeight and (type(maxHeight) == "function" and maxHeight(relativeTo:GetWidth(), relativeTo:GetHeight()) or maxHeight) or 10000
			local stringWidth, stringHeight = addon.API.Util:GetStringSize(frame, width, height)
			frame:SetWidth(setMaxWidth and width or stringWidth)
			frame:SetHeight(setMaxHeight and height or stringHeight)
		end

		updateSize()
		hooksecurefunc(frame, "SetText", updateSize)
		return updateSize
	end
end

do
	function addon.API.FrameUtil:HookSetTextColor(frame)
		if not frame.HookedTextColor then
			frame.HookedTextColor = true
			local function setWhiteText()
				frame:SetText("|cffFFFFFF" .. addon.API.Util:GetUnformattedText(frame:GetText()) .. "|r")
			end
			hooksecurefunc(frame, "SetTextColor", setWhiteText)
			hooksecurefunc(frame, "SetFormattedText", setWhiteText)
		end
		frame:SetText("|cffFFFFFF" .. addon.API.Util:GetUnformattedText(frame:GetText()) .. "|r")
	end

	function addon.API.FrameUtil:HookHideElement(frame)
		if frame.HookedHideElement then return end
		frame.HookedHideElement = true
		frame:HookScript("OnShow", function() frame:Hide() end)
		frame:Hide()
	end
end
