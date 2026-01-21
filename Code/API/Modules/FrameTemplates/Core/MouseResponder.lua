local addon = select(2, ...)
local NS = addon.API.FrameTemplates; addon.API.FrameTemplates = NS
local CallbackRegistry = addon.CallbackRegistry


-- Templates
----------------------------------------------------------------------------------------------------

do

	function NS:CreateMouseResponder(parent, data, padding)
		if not parent then
			return
		end

		local enterCallback, leaveCallback, mouseDownCallback, mouseUpCallback, enterCallbackValue, leaveCallbackValue, mouseDownCallbackValue, mouseUpCallbackValue = data.enterCallback, data.leaveCallback, data.mouseDownCallback, data.mouseUpCallback, data.enterCallbackValue, data.leaveCallbackValue, data.mouseDownCallbackValue, data.mouseUpCallbackValue

		local Frame = CreateFrame("Frame", "$parent.MouseResponder", parent)
		Frame:SetFrameStrata("FULLSCREEN_DIALOG")
		Frame:SetFrameLevel(999)

		if padding then
			local x = padding.x
			local y = padding.y

			Frame:SetPoint("TOPLEFT", parent, -x, y)
			Frame:SetPoint("BOTTOMRIGHT", parent, x, -y)
		else
			Frame:SetAllPoints(parent, true)
		end

		local function Initalize()
			if InCombatLockdown() then
				return
			end

			Frame:SetPropagateMouseClicks(true)
			Frame:SetPropagateMouseMotion(true)
		end

		if not InCombatLockdown() then
			Initalize()
		else
			Frame.isWaitingForInitalization = true

			Frame:RegisterEvent("PLAYER_REGEN_ENABLED")
			Frame:SetScript("OnEvent", function(_, event)
				if event == "PLAYER_REGEN_ENABLED" then
					if Frame.isWaitingForInitalization then
						Frame.isWaitingForInitalization = false
						Frame:UnregisterEvent("PLAYER_REGEN_ENABLED")

						Initalize()
					end
				end
			end)
		end

		Frame:SetScript("OnEnter", function()
			if enterCallback then
				if enterCallbackValue then
					enterCallback(enterCallbackValue)
				else
					enterCallback()
				end
			end
		end)

		Frame:SetScript("OnLeave", function()
			if leaveCallback then
				if leaveCallbackValue then
					leaveCallback(leaveCallbackValue)
				else
					leaveCallback()
				end
			end
		end)

		Frame:SetScript("OnMouseDown", function(_, button)
			if mouseDownCallback then
				if mouseDownCallbackValue then
					mouseDownCallback(mouseDownCallbackValue)
				else
					mouseDownCallback(button)
				end
			end
		end)

		Frame:SetScript("OnMouseUp", function(_, button)
			if mouseUpCallback then
				if mouseUpCallbackValue then
					mouseUpCallback(mouseUpCallbackValue)
				else
					mouseUpCallback(button)
				end
			end
		end)

		return Frame
	end

	function NS:CreateScrollResponder(parent, data, padding)
		if not parent then
			return
		end

		local mouseScrollCallback = data.mouseScrollCallback

		local Frame = CreateFrame("Frame", "ScrollResponder", parent)
		Frame:SetFrameStrata("FULLSCREEN_DIALOG")
		Frame:SetFrameLevel(999)

		if padding then
			local x = padding.x
			local y = padding.y

			Frame:SetPoint("TOPLEFT", parent, -x, y)
			Frame:SetPoint("BOTTOMRIGHT", parent, x, -y)
		else
			Frame:SetAllPoints(parent, true)
		end

		local function Initalize()
			if InCombatLockdown() then
				return
			end

			Frame:SetPropagateMouseClicks(true)
			Frame:SetPropagateMouseMotion(true)
		end

		if not InCombatLockdown() then
			Initalize()
		else
			Frame.isWaitingForInitalization = true

			Frame:RegisterEvent("PLAYER_REGEN_ENABLED")
			Frame:SetScript("OnEvent", function(_, event)
				if event == "PLAYER_REGEN_ENABLED" then
					if Frame.isWaitingForInitalization then
						Frame.isWaitingForInitalization = false
						Frame:UnregisterEvent("PLAYER_REGEN_ENABLED")

						Initalize()
					end
				end
			end)
		end

		Frame:SetScript("OnMouseWheel", function(self, delta)
			if mouseScrollCallback then
				mouseScrollCallback(self, delta)
			end
		end)

		return Frame
	end
end
