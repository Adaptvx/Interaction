-- [!] [addon.Interaction.Quest.Target] is a module for [addon.Interaction.Quest]
-- [QuestTarget_Script.lua] is the back-end (logic & behavior)
-- for [QuestTarget_Elements.lua].

---@class addon
local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local PrefabRegistry = addon.PrefabRegistry
local L = addon.Locales
local NS = addon.Interaction.Quest.Target; addon.Interaction.Quest.Target = NS

--------------------------------

NS.Script = {}

--------------------------------

function NS.Script:Load()
	--------------------------------
	-- REFERENCES
	--------------------------------

	local Frame = InteractionFrame.QuestFrame.Target
	local Callback = NS.Script; NS.Script = Callback

	--------------------------------
	-- FUNCTIONS (FRAME)
	--------------------------------

	do
		do -- UPDATE
			function Frame:UpdateLayout()
				CallbackRegistry:Trigger("LayoutGroupSort QuestTarget.Content")
				CallbackRegistry:Trigger("UpdateDynamicSize QuestTarget")
			end
		end

		do -- SET
			local function OnModelLoaded()
				Frame.REF_MODELFRAME:Show()
				Frame.REF_MODELFRAME_MODEL:SetCamera(0)
				Frame.REF_MODELFRAME_MODEL:SetPortraitZoom(1)
				Frame.REF_MODELFRAME_MODEL:FreezeAnimation(0, 0, 0)
				Frame.REF_MODELFRAME_MODEL:SetModelAlpha(0)

				--------------------------------

				Frame.REF_MODELFRAME_MODEL:SetScript("OnModelLoaded", nil)

				--------------------------------

				Frame:UpdateLayout()
			end

			function Frame:SetModel(modelID)
				if modelID then
					Frame.REF_MODELFRAME_MODEL:SetDisplayInfo(modelID)
					Frame.REF_MODELFRAME_MODEL:SetScript("OnModelLoaded", OnModelLoaded)
				else
					Frame.REF_MODELFRAME:Hide()
				end
			end

			function Frame:SetInfo(title, description, model)
				Frame.REF_TITLEFRAME_TEXT:SetText(title)
				Frame.REF_DESCRIPTIONFRAME_TEXT:SetText(description)

				if model then
					local modelID = model.modelID

					--------------------------------

					Frame:SetModel(modelID)
				else
					Frame:SetModel(nil)
				end

				--------------------------------

				Frame:UpdateLayout()
			end
		end
	end

	--------------------------------
	-- FUNCTIONS (ANIMATION)
	--------------------------------

	do
		local HideTimer = nil

		--------------------------------

		do -- SHOW
			function Frame:ShowWithAnimation_StopEvent()
				return Frame.hidden
			end

			function Frame:ShowWithAnimation()
				local modelID, description, name, mountModelID, sceneModelID = GetQuestPortraitGiver()

				--------------------------------

				if not Frame.hidden or (#name < 1 or #description < 1) then
					return
				end

				Frame.hidden = false
				Frame:Show()
				Frame.REF_MODELFRAME:Show()

				if HideTimer then
					HideTimer:Cancel()
					HideTimer = nil
				end

				--------------------------------

				addon.API.Animation:Fade(Frame, .25, 0, 1, nil, Frame.ShowWithAnimation_StopEvent)
				addon.API.Animation:Move(Frame, 1, "TOPLEFT", -100, -75, "y", nil, Frame.ShowWithAnimation_StopEvent)
			end
		end

		do -- HIDE
			function Frame:HideWithAnimation_StopEvent()
				return not Frame.hidden
			end

			function Frame:HideWithAnimation(bypass, skipAnimation)
				if Frame.hidden and not bypass then
					return
				end
				Frame.hidden = true

				if skipAnimation then
					Frame:Hide()
				else
					HideTimer = C_Timer.NewTimer(.5, function()
						if Frame.hidden then
							Frame.hidden = true
							Frame:Hide()
						end
						HideTimer = nil
					end)
				end
				Frame.REF_MODELFRAME:Hide()

				if HideTimer then
					HideTimer:Cancel()
				end

				--------------------------------

				if skipAnimation then
					local point, relativeTo, relativePoint, offsetX, offsetY = Frame:GetPoint()

					Frame:SetAlpha(0)
					Frame:SetPoint(point, relativeTo, offsetX, offsetY)
				else
					addon.API.Animation:Fade(Frame, .125, 1, 0, nil, Frame.HideWithAnimation_StopEvent)
					addon.API.Animation:Move(Frame, 1, "TOPLEFT", -75, -100, "y", nil, Frame.HideWithAnimation_StopEvent)
				end
			end
		end
	end

	--------------------------------
	-- FUNCTIONS (EVENT)
	--------------------------------

	do
		if QuestModelScene then -- Fix for Classic Era
			hooksecurefunc(QuestModelScene, "Show", function()
				if QuestModelScene:IsVisible() then
					local modelID, description, name, mountModelID, sceneModelID = GetQuestPortraitGiver()

					--------------------------------

					if #name > 1 and #description > 1 then
						Frame:SetInfo(name, description, { modelID = modelID, mountModelID = mountModelID })
					end
				end
			end)

			CallbackRegistry:Add("START_QUEST", function()
				if QuestModelScene and QuestModelScene:IsVisible() then
					Frame:ShowWithAnimation()
				else
					Frame:HideWithAnimation(true, true)
				end
			end, 0)

			CallbackRegistry:Add("STOP_QUEST", function()
				Frame:HideWithAnimation()
			end, 0)
		end
	end

	--------------------------------
	-- SETUP
	--------------------------------
end
