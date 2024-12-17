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
	-- Creates a frame that responds to mouse enter and leave events, it will trigger even if hovering over another frame.
	-- Cannot be initalized in combat, it will re-initalize when out of combat due to SetPropagateMouseMotion and SetPropagateMouseClicks
	---@param parent any
	---@param enterCallback? function
	---@param leaveCallback? function
	---@param enterCallbackValue? any
	---@param leaveCallbackValue? any
	function NS:CreateMouseResponder(parent, enterCallback, leaveCallback, enterCallbackValue, leaveCallbackValue)
		if not parent then
			return
		end

		--------------------------------

		local Frame = CreateFrame("Frame", "HoverFrame", parent)
		Frame:SetAllPoints(parent)
		Frame:SetFrameStrata("FULLSCREEN_DIALOG")
		Frame:SetFrameLevel(999)

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
end
