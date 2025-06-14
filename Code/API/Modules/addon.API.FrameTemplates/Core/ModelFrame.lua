---@class addon
local addon = select(2, ...)
local NS = addon.API.FrameTemplates; addon.API.FrameTemplates = NS
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
	-- Creates a model frame (rotate & zooming). Variables: ~.mouseDownCallbacks (table -> function(button)), ~.mouseUpCallbacks (table -> function(button)), ~.onZoomCallbacks (table -> function(button, delta))
	--
	-- Data Table:
	-- enableRotate (boolean)
	-- enableZoom (boolean)
	-- minZoom (number)
	-- maxZoom (number)
	---@param parent any
	---@param data table
	---@param name string
	function NS:CreateModelFrame_Interactable(parent, data, name)
		local enableRotate, enableZoom, minZoom, maxZoom = data.enableRotate, data.enableZoom, data.minZoom, data.maxZoom

		--------------------------------

		local Frame = CreateFrame("PlayerModel", name, parent)

		--------------------------------

		do -- EVENTS
			local isDragging = false
			local lastCursorX

			Frame.mouseDownCallbacks = {}
			Frame.mouseUpCallbacks = {}
			Frame.onZoomCallbacks = {}

			Frame:SetScript("OnMouseDown", function(self, button)
				if button == "LeftButton" then
					isDragging = true
					lastCursorX = GetCursorPosition()

					--------------------------------

					do -- MOUSE DOWN
						local mouseDownCallbacks = Frame.mouseDownCallbacks

						if #mouseDownCallbacks >= 1 then
							for callback = 1, #mouseDownCallbacks do
								mouseDownCallbacks[callback](Frame)
							end
						end
					end
				end
			end)

			Frame:SetScript("OnMouseUp", function(self, button)
				if button == "LeftButton" then
					isDragging = false

					--------------------------------

					do -- MOUSE UP
						local mouseUpCallbacks = Frame.mouseUpCallbacks

						if #mouseUpCallbacks >= 1 then
							for callback = 1, #mouseUpCallbacks do
								mouseUpCallbacks[callback](Frame)
							end
						end
					end
				end
			end)

			Frame:SetScript("OnMouseWheel", function(self, delta)
				if enableZoom then
					local currentScale = self:GetCameraDistance() or 2.5
					local newScale = currentScale - delta * 0.1
					newScale = math.max(newScale, minZoom or 1)
					newScale = math.min(newScale, maxZoom or 2.5)

					--------------------------------

					self:SetCameraDistance(newScale)

					--------------------------------

					do -- ON ZOOM
						local onZoomCallbacks = Frame.onZoomCallbacks

						if #onZoomCallbacks >= 1 then
							for callback = 1, #onZoomCallbacks do
								onZoomCallbacks[callback](Frame, delta)
							end
						end
					end
				end
			end)

			Frame:SetScript("OnUpdate", function(self, elapsed)
				if enableRotate then
					if isDragging then
						local currentCursorX = GetCursorPosition()
						local deltaX = currentCursorX - lastCursorX
						lastCursorX = currentCursorX

						--------------------------------

						local currentFacing = self:GetFacing() or 0
						self:SetFacing(currentFacing + deltaX * 0.01)
					end
				end
			end)
		end

		--------------------------------

		return Frame
	end

	-- Creates a model frame for visual effects.
	--
	-- Data Table:
	-- spellID (number)
	-- position (table)
	-- rotation (number)
	---@param parent any
	---@param data table
	---@param name string
	function NS:CreateModelFrame_VisualEffect(parent, data, name)
		local spellID, position, rotation = data.spellID, data.position, data.rotation

		--------------------------------

		local Frame = CreateFrame("PlayerModel", name, parent)
		Frame:SetKeepModelOnHide(true)
		Frame:SetModel(spellID)
		Frame:MakeCurrentCameraCustom()
		Frame:SetPosition(position.x, position.y, position.z)
		Frame:SetFacing(math.rad(rotation))

		--------------------------------

		return Frame
	end
end
