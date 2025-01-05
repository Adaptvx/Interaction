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
	-- Creates a frame that responds to mouse enter and leave events, it will trigger even if hovering over another frame.
	-- Cannot be initalized in combat, it will re-initalize when out of combat due to SetPropagateMouseMotion and SetPropagateMouseClicks
	---@param parent any
	---@param enterCallback? function
	---@param leaveCallback? function
	---@param enterCallbackValue? any
	---@param leaveCallbackValue? any
	---@param padding? table
	function NS:CreateMouseResponder(parent, enterCallback, leaveCallback, enterCallbackValue, leaveCallbackValue, padding)
		if not parent then
			return
		end

		--------------------------------

		local Frame = CreateFrame("Frame", "MouseResponder", parent)
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

		--------------------------------

		local function Initalize()
			if InCombatLockdown() then
				return
			end

			--------------------------------

			Frame:SetPropagateMouseClicks(true)
			Frame:SetPropagateMouseMotion(true)
		end

		--------------------------------

		if not InCombatLockdown() then
			Initalize()
		else
			Frame.WaitingForInitalization = true

			--------------------------------

			Frame:RegisterEvent("PLAYER_REGEN_ENABLED")
			Frame:SetScript("OnEvent", function(_, event)
				if event == "PLAYER_REGEN_ENABLED" then
					if Frame.WaitingForInitalization then
						Frame.WaitingForInitalization = false

						--------------------------------

						Initalize()
					end
				end
			end)
		end

		--------------------------------

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

		--------------------------------

		return Frame
	end

	-- Creates a frame that responds to scrolling, it will trigger even if hovering over another frame.
	-- Cannot be initalized in combat, it will re-initalize when out of combat due to SetPropagateMouseMotion and SetPropagateMouseClicks
	---@param parent any
	---@param mouseScrollCallback function
	---@param padding? table
	function NS:CreateScrollResponder(parent, mouseScrollCallback, padding)
		if not parent then
			return
		end

		--------------------------------

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

		--------------------------------

		local function Initalize()
			if InCombatLockdown() then
				return
			end

			--------------------------------

			Frame:SetPropagateMouseClicks(true)
			Frame:SetPropagateMouseMotion(true)
		end

		--------------------------------

		if not InCombatLockdown() then
			Initalize()
		else
			Frame.WaitingForInitalization = true

			--------------------------------

			Frame:RegisterEvent("PLAYER_REGEN_ENABLED")
			Frame:SetScript("OnEvent", function(_, event)
				if event == "PLAYER_REGEN_ENABLED" then
					if Frame.WaitingForInitalization then
						Frame.WaitingForInitalization = false

						--------------------------------

						Initalize()
					end
				end
			end)
		end

		--------------------------------

		Frame:SetScript("OnMouseWheel", function(self, delta)
			if mouseScrollCallback then
				mouseScrollCallback(self, delta)
			end
		end)

		--------------------------------

		return Frame
	end
end
