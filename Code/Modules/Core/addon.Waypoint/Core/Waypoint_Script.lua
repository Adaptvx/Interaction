local addonName, addon = ...
local PrefabRegistry = addon.PrefabRegistry
local CallbackRegistry = addon.CallbackRegistry
local L = addon.Locales
local NS = addon.Waypoint

--------------------------------

NS.Script = {}

--------------------------------

function NS.Script:Load()
	--------------------------------
	-- REFERENCES
	--------------------------------

	local Callback = NS.Script

	--------------------------------
	-- FUNCTIONS (FRAME)
	--------------------------------

	do
		function Callback:ShowWaypoint(bypass, sfx)
			local isWaypointVisible = (InteractionWaypointFrame.Line:GetAlpha() >= .75)
			local isInPinRange = (C_Navigation.GetDistance() < 200)

			--------------------------------

			if not isWaypointVisible or bypass then
				if sfx or sfx == nil then
					addon.API.Animation:Scale(InteractionWaypointFrame.Line, 2, 50, 1000, "y")

					--------------------------------

					if not isInPinRange then
						InteractionWaypointFrame.GlowAnimation.Play()

						--------------------------------

						addon.API.Animation:Fade(InteractionWaypointFrame.GlowAnimation, .25, 1, 0)
					end

					--------------------------------

					addon.Libraries.AceTimer:ScheduleTimer(function()
						if NS.Variables.AudioEnable then
							if not isInPinRange and InteractionWaypointFrame:IsVisible() then
								addon.SoundEffects:PlaySound(SOUNDKIT.UI_MAP_WAYPOINT_SUPER_TRACK_ON)
							end
						end
					end, 0)

					addon.Libraries.AceTimer:ScheduleTimer(function()
						InteractionWaypointFrame.Line:SetHeight(1000)
					end, 2)
				else
					InteractionWaypointFrame.Line:SetHeight(1000)
					InteractionWaypointFrame.GlowAnimation:SetAlpha(0)
				end

				--------------------------------

				InteractionWaypointFrame.Line:SetAlpha(.75)
			end
		end

		function Callback:HideWaypoint(bypass)
			local isWaypointVisible = (InteractionWaypointFrame.Line:GetAlpha() > 0)

			--------------------------------

			if isWaypointVisible or bypass then
				InteractionWaypointFrame.Line:SetAlpha(0)
			end
		end

		function Callback:NewWaypoint(audio)
			Callback:ShowWaypoint(true, audio or true)
		end

		function Callback:SetState(state)
			local distance = C_Navigation.GetDistance()

			--------------------------------

			if distance < 50 then
				if not InteractionWaypointFrame:IsVisible() then
					NS.Variables.State = "Invalid"
				else
					NS.Variables.State = "PinInvalid"
				end

				return
			else
				NS.Variables.State = state
			end
		end

		function Callback:Update()
			local navDistance = C_Navigation.GetDistance()
			local superTrackedFrameIconTexture = tostring(SuperTrackedFrame.Icon:GetTexture())

			local isSuperTrackingAnything = (C_SuperTrack.IsSuperTrackingAnything())
			local isInInstance = (IsInInstance())
			local isDefaultIcon = (superTrackedFrameIconTexture == "3308452")
			local isPinIcon = (superTrackedFrameIconTexture == "3500068")
			local isInvalidDistance = (navDistance == 0)
			local isValidDistance = (navDistance >= 5)

			--------------------------------

			if (isSuperTrackingAnything) and (not isInInstance) and (isDefaultIcon or isPinIcon) and (isValidDistance) then -- AVAILABLE FOR WAYPOINT
				SuperTrackedFrame:Show()

				--------------------------------

				local superTrackType = C_SuperTrack.GetHighestPrioritySuperTrackingType()

				local selectedQuestID = C_SuperTrack.GetSuperTrackedQuestID()
				local selectedQuestObjectives = nil
				local selectedQuestCompletion = nil
				local selectedQuestIsMultiObjective = false
				local currentQuestObjectiveIndex = 1
				local selectedQuestCompleted = false

				local navState = C_Navigation.GetTargetState()

				--------------------------------

				do -- ANIMATION
					do -- WAYPOINT INTRO
						local id = C_SuperTrack.GetHighestPrioritySuperTrackingType()

						--------------------------------

						if (NS.Variables.ID ~= id or NS.Variables.QuestID ~= selectedQuestID) and (not C_Navigation.WasClampedToScreen()) then
							NS.Variables.ID = id
							NS.Variables.QuestID = selectedQuestID

							Callback:NewWaypoint()
						end
					end
				end

				do -- GET
					do -- QUEST
						-- QUEST (OBJECTIVES/COMPLETED)
						if superTrackType == Enum.SuperTrackingType.Quest and selectedQuestID then
							local isQuestComplete = (C_QuestLog.IsComplete(selectedQuestID))

							--------------------------------

							if isQuestComplete then
								selectedQuestCompletion = true
							else
								selectedQuestObjectives = C_QuestLog.GetQuestObjectives(selectedQuestID)

								--------------------------------

								if selectedQuestObjectives and #selectedQuestObjectives > 1 then
									selectedQuestIsMultiObjective = true
								else
									selectedQuestIsMultiObjective = false
								end

								if selectedQuestObjectives then
									for i, objective in ipairs(selectedQuestObjectives) do
										if objective.finished then
											if i < #selectedQuestObjectives then
												currentQuestObjectiveIndex = i + 1
											else
												selectedQuestCompletion = true
											end
										end
									end
								end
							end
						end
					end
				end

				do -- SET
					do -- STATE
						local invalidInRange = (navState == Enum.NavigationState.Invalid and navDistance < 200)
						local blocked = (navState == Enum.NavigationState.Occluded or (navState == Enum.NavigationState.Invalid and navDistance >= 200))
						local notBlocked = (navState == Enum.NavigationState.InRange)
						local invalid = (navState == Enum.NavigationState.Invalid)

						--------------------------------

						if (not invalid and navDistance >= 200) or (invalid and navDistance > 1000) then
							Callback:SetState("OutDistance")
						else
							if superTrackType == Enum.SuperTrackingType.Quest then
								local isMultiObjectiveQuest = selectedQuestObjectives and #selectedQuestObjectives > 1

								--------------------------------

								if isMultiObjectiveQuest then
									if invalid then
										Callback:SetState("PinInvalid")
									else
										Callback:SetState("Pin")
									end
								else
									if invalidInRange then
										Callback:SetState("Invalid")
									elseif blocked then
										Callback:SetState("Blocked")
									elseif notBlocked then
										Callback:SetState("NotBlocked")
									elseif invalid then
										Callback:SetState("Invalid")
									end
								end
							else
								local pinInvalid = (navState == Enum.NavigationState.Invalid or navDistance <= 50)

								--------------------------------

								if pinInvalid then
									Callback:SetState("PinInvalid")
								else
									Callback:SetState("Pin")
								end
							end
						end
					end

					do -- WAYPOINT
						local isSuperTrackedVisible = ((not C_Navigation.WasClampedToScreen()))
						local isQuest = (((superTrackType == Enum.SuperTrackingType.Quest) or (selectedQuestCompletion)) and (not selectedQuestIsMultiObjective))
						local isWaypoint = ((superTrackType ~= Enum.SuperTrackingType.Quest) or (selectedQuestIsMultiObjective))

						--------------------------------

						if isSuperTrackedVisible and (isQuest or isWaypoint) then -- IN VIEW
							local isInRange = (navState == Enum.NavigationState.Invalid and navDistance < 200)
							local isQuest = (superTrackType == Enum.SuperTrackingType.Quest and not selectedQuestIsMultiObjective)

							--------------------------------

							SuperTrackedFrame.Icon:SetAlpha(0)
							SuperTrackedFrame.DistanceText:SetAlpha(0)

							do -- INTRO ANIMATION
								if not isInRange then
									Callback:ShowWithAnimation()
								end
							end

							do -- TEXT
								if isQuest then
									local isCompleted = (selectedQuestCompleted)
									local isComplete = (selectedQuestCompletion)
									local currentWaypointObjective = (C_QuestLog.GetNextWaypointText(selectedQuestID))
									local currentQuestObjective = ((selectedQuestObjectives and #selectedQuestObjectives >= currentQuestObjectiveIndex and selectedQuestObjectives[currentQuestObjectiveIndex].text) or "")

									--------------------------------

									if isCompleted then
										if currentWaypointObjective then
											InteractionPinpointFrame.Label:SetText(currentWaypointObjective)
										else
											InteractionPinpointFrame.Label:SetText(L["Waypoint - Ready for Turn-in"])
										end
									else
										if selectedQuestObjectives then
											if currentWaypointObjective then
												InteractionPinpointFrame.Label:SetText(currentWaypointObjective)
											else
												InteractionPinpointFrame.Label:SetText(currentQuestObjective)
											end
										elseif isComplete then
											if currentWaypointObjective then
												InteractionPinpointFrame.Label:SetText(currentWaypointObjective)
											else
												InteractionPinpointFrame.Label:SetText(L["Waypoint - Ready for Turn-in"])
											end
										end
									end
								end
							end

							do -- FORMATTING
								if InteractionPinpointFrame.Label:GetStringWidth() >= 300 then
									InteractionPinpointFrame.Label:SetWidth(275)
									InteractionPinpointFrame.Background:SetSize(300, InteractionPinpointFrame.Label:GetStringHeight() + 25)
								else
									InteractionPinpointFrame.Label:SetWidth(InteractionPinpointFrame.Label:GetStringWidth() + 25)
									InteractionPinpointFrame.Background:SetSize(InteractionPinpointFrame.Label:GetStringWidth() + 25, InteractionPinpointFrame.Label:GetStringHeight() + 25)
								end

								InteractionWaypointFrame.Distance:SetText(addon.API.Util:FormatNumber(string.format("%.0f", navDistance)) .. " yds")
							end
						else -- OUT OF VIEW
							if
							-- QUEST
								(superTrackType == Enum.SuperTrackingType.Quest and (selectedQuestObjectives and selectedQuestObjectives[1]) or (selectedQuestCompletion))

								-- WAYPOINT
								or (superTrackType ~= Enum.SuperTrackingType.Quest)
							then
								SuperTrackedFrame.Icon:SetAlpha(0)
								SuperTrackedFrame.Arrow:SetAlpha(0)
							else
								SuperTrackedFrame.Icon:SetAlpha(1)
								SuperTrackedFrame.Arrow:SetAlpha(1)
								SuperTrackedFrame.DistanceText:SetAlpha(1)
							end

							InteractionPinpointFrame:Hide()
							InteractionWaypointFrame:Hide()
						end
					end
				end
			else -- SHOW BLIZZARD
				InteractionPinpointFrame:Hide()
				InteractionWaypointFrame:Hide()

				SuperTrackedFrame.Icon:SetAlpha(1)
				SuperTrackedFrame.Arrow:SetAlpha(1)
				SuperTrackedFrame.DistanceText:SetAlpha(1)

				if not isInInstance then
					if isSuperTrackingAnything and not isInvalidDistance then
						SuperTrackedFrame:Show()
					else
						SuperTrackedFrame:Hide()
					end
				else
					SuperTrackedFrame:Show()
				end
			end
		end
	end

	--------------------------------
	-- FUNCTIONS (ANIMATION)
	--------------------------------

	do
		InteractionPinpointFrame.SetIntroAnimation = function(state, stateIsDistance)
			Callback.Playback = true

			--------------------------------

			addon.Libraries.AceTimer:ScheduleTimer(function()
				if (not stateIsDistance and NS.Variables.State == state) or (stateIsDistance and NS.Variables.StateDistance == state) then
					Callback.Playback = false
				end
			end, 1)
		end

		InteractionPinpointFrame.UpdateAnimation = function()
			local lastState = Callback.LastState
			local state = NS.Variables.State

			--------------------------------

			do -- PINPOINT
				do -- BLOCKED
					if state == "Blocked" then
						if lastState ~= state then
							InteractionPinpointFrame.SetIntroAnimation(state, false)

							if NS.Variables.AudioEnable then
								addon.SoundEffects:PlaySound(SOUNDKIT.UI_MAP_WAYPOINT_BUTTON_CLICK_ON)
							end

							--------------------------------

							-- ALPHA -- SuperTrackedFrame
							-- addon.API.Animation:Fade(SuperTrackedFrame, .5, SuperTrackedFrame:GetAlpha(), 1)

							-- ALPHA -- InteractionPinpointFrame
							addon.API.Animation:Fade(InteractionPinpointFrame, .5, InteractionPinpointFrame:GetAlpha(), 1)

							-- SCALE -- InteractionPinpointFrame
							addon.API.Animation:Scale(InteractionPinpointFrame, 1, InteractionPinpointFrame:GetScale(), 1)

							-- POSITION -- InteractionPinpointFrame
							addon.API.Animation:Move(InteractionPinpointFrame, .5, "CENTER", select(5, InteractionPinpointFrame:GetPoint()), NS.Variables.BLOCKED_HEIGHT, "y")

							-- ALPHA -- InteractionPinpointFrame.Line
							addon.API.Animation:Fade(InteractionPinpointFrame.Line, .25, InteractionPinpointFrame.Line:GetAlpha(), 0)

							-- BACKGROUND TEXTURE -- InteractionPinpointFrame.backgroundTexture
							InteractionPinpointFrame.backgroundTexture:SetTexture(NS.Variables.PATH .. "border.png")

							--------------------------------

							-- VISIBILITY -- InteractionWaypointFrame.Distance
							InteractionWaypointFrame.Distance:Hide()

							-- ALPHA -- InteractionWaypointFrame.Distance
							InteractionWaypointFrame.Distance:SetAlpha(0)

							-- SCALE -- InteractionWaypointFrame.Distance
							InteractionWaypointFrame.Distance:SetScale(1)

							-- ALPHA -- InteractionWaypointFrame.Line
							InteractionWaypointFrame.Line:SetAlpha(1)

							-- SCALE -- InteractionWaypointFrame.Line
							InteractionWaypointFrame.Line:SetScale(1)
						end

						if (not C_Navigation.WasClampedToScreen()) then
							-- VISIBILITY -- InteractionWaypointFrame
							InteractionWaypointFrame:Hide()
						end

						-- ALPHA -- SuperTrackedFrame
						SuperTrackedFrame:SetAlpha(1)
					end
				end

				do -- NOT BLOCKED
					if state == "NotBlocked" then
						if lastState ~= state then
							InteractionPinpointFrame.SetIntroAnimation(state, false)

							if NS.Variables.AudioEnable then
								addon.SoundEffects:PlaySound(SOUNDKIT.UI_MAP_WAYPOINT_BUTTON_CLICK_OFF)
							end

							--------------------------------

							-- ALPHA -- SuperTrackedFrame
							-- addon.API.Animation:Fade(SuperTrackedFrame, .5, SuperTrackedFrame:GetAlpha(), 1)

							-- ALPHA -- InteractionPinpointFrame
							addon.API.Animation:Fade(InteractionPinpointFrame, .5, InteractionPinpointFrame:GetAlpha(), 1)

							-- SCALE -- InteractionPinpointFrame
							addon.API.Animation:Scale(InteractionPinpointFrame, 1, InteractionPinpointFrame:GetScale(), 1)

							-- POSITION -- InteractionPinpointFrame
							addon.API.Animation:Move(InteractionPinpointFrame, .5, "CENTER", select(5, InteractionPinpointFrame:GetPoint()), NS.Variables.DEFAULT_HEIGHT, "y")

							-- ALPHA -- InteractionPinpointFrame.Line
							addon.API.Animation:Fade(InteractionPinpointFrame.Line, .25, InteractionPinpointFrame.Line:GetAlpha(), 1)

							-- BACKGROUND TEXTURE -- InteractionPinpointFrame.backgroundTexture
							InteractionPinpointFrame.backgroundTexture:SetTexture(NS.Variables.PATH .. "content.png")

							--------------------------------

							-- VISIBILITY -- InteractionWaypointFrame.Distance
							InteractionWaypointFrame.Distance:Hide()

							-- ALPHA -- InteractionWaypointFrame.Distance
							InteractionWaypointFrame.Distance:SetAlpha(0)

							-- SCALE -- InteractionWaypointFrame.Distance
							InteractionWaypointFrame.Distance:SetScale(1)

							-- ALPHA -- InteractionWaypointFrame.Line
							InteractionWaypointFrame.Line:SetAlpha(1)

							-- SCALE -- InteractionWaypointFrame.Line
							InteractionWaypointFrame.Line:SetScale(1)
						end

						if (not C_Navigation.WasClampedToScreen()) then
							-- VISIBILITY -- InteractionWaypointFrame
							InteractionWaypointFrame:Hide()
						end

						-- ALPHA -- SuperTrackedFrame
						SuperTrackedFrame:SetAlpha(1)
					end
				end

				do -- INVALID
					if state == "Invalid" then
						if lastState ~= state then
							InteractionPinpointFrame.SetIntroAnimation(state, false)

							--------------------------------

							-- ALPHA -- SuperTrackedFrame
							addon.API.Animation:Fade(SuperTrackedFrame, .5, SuperTrackedFrame:GetAlpha(), 0)

							-- ALPHA -- InteractionPinpointFrame
							-- addon.API.Animation:Fade(InteractionPinpointFrame, .5, InteractionPinpointFrame:GetAlpha(), 1)

							-- SCALE -- InteractionPinpointFrame
							-- addon.API.Animation:Scale(InteractionPinpointFrame, 1, InteractionPinpointFrame:GetScale(), 1)

							-- POSITION -- InteractionPinpointFrame
							-- addon.API.Animation:Move(InteractionPinpointFrame, .5, "CENTER", select(5, InteractionPinpointFrame:GetPoint()), NS.Variables.DEFAULT_HEIGHT, "y")

							-- ALPHA -- InteractionPinpointFrame.Line
							-- addon.API.Animation:Fade(InteractionPinpointFrame.Line, .25, InteractionPinpointFrame.Line:GetAlpha(), 0)

							-- BACKGROUND TEXTURE -- InteractionPinpointFrame.backgroundTexture
							-- InteractionPinpointFrame.backgroundTexture:SetTexture(NS.Variables.PATH .. "border.png")

							--------------------------------

							-- VISIBILITY -- InteractionWaypointFrame.Distance
							-- InteractionWaypointFrame.Distance:Hide()

							-- ALPHA -- InteractionWaypointFrame.Distance
							-- InteractionWaypointFrame.Distance:SetAlpha(0)

							-- SCALE -- InteractionWaypointFrame.Distance
							-- InteractionWaypointFrame.Distance:SetScale(1)

							-- ALPHA -- InteractionWaypointFrame.Line
							-- InteractionWaypointFrame.Line:SetAlpha(1)

							-- SCALE -- InteractionWaypointFrame.Line
							-- InteractionWaypointFrame.Line:SetScale(1)
						end

						-- if (not C_Navigation.WasClampedToScreen()) then
						-- VISIBILITY -- InteractionWaypointFrame
						-- InteractionWaypointFrame:Hide()
						-- end
					end
				end
			end

			do -- WAYPOINT
				do -- IN RANGE (PIN)
					if state == "Pin" then
						if lastState ~= state then
							InteractionPinpointFrame.SetIntroAnimation(state, false)

							if NS.Variables.AudioEnable then
								addon.SoundEffects:PlaySound(SOUNDKIT.UI_MAP_WAYPOINT_CHAT_SHARE)
							end

							--------------------------------

							-- ALPHA -- SuperTrackedFrame
							-- SuperTrackedFrame:SetAlpha(0)

							-- ALPHA -- InteractionPinpointFrame
							-- InteractionPinpointFrame:SetAlpha(0)

							-- SCALE -- InteractionPinpointFrame
							-- InteractionPinpointFrame:SetScale(1)

							-- POSITION -- InteractionPinpointFrame
							-- InteractionPinpointFrame:SetPoint("CENTER", SuperTrackedFrame, 0, blockedHeight)

							-- ALPHA -- InteractionPinpointFrame.Line
							-- InteractionPinpointFrame.Line:SetAlpha(0)

							-- BACKGROUND TEXTURE -- InteractionPinpointFrame.backgroundTexture
							-- InteractionPinpointFrame.backgroundTexture:SetTexture(NS.Variables.PATH .. "border.png")

							--------------------------------

							-- VISIBILITY -- InteractionWaypointFrame.Distance
							InteractionWaypointFrame.Distance:Show()

							-- ALPHA -- InteractionWaypointFrame.Distance
							addon.API.Animation:Fade(InteractionWaypointFrame.Distance, .5, InteractionWaypointFrame.Distance:GetAlpha(), 1)

							-- SCALE -- InteractionWaypointFrame.Distance
							addon.API.Animation:Scale(InteractionWaypointFrame.Distance, 1, InteractionWaypointFrame.Distance:GetScale(), 1.5)

							-- ALPHA -- InteractionWaypointFrame.Line
							addon.API.Animation:Fade(InteractionWaypointFrame.Line, .5, InteractionWaypointFrame.Line:GetAlpha(), .75)

							-- SCALE -- InteractionWaypointFrame.Line
							addon.API.Animation:Scale(InteractionWaypointFrame.Line, 1, InteractionWaypointFrame.Line:GetScale(), 1)
						end

						if (not C_Navigation.WasClampedToScreen()) then
							-- VISIBILITY -- InteractionWaypointFrame
							InteractionWaypointFrame:Show()

							-- ALPHA -- SuperTrackedFrame
							SuperTrackedFrame:SetAlpha(0)

							-- ALPHA -- InteractionPinpointFrame
							InteractionPinpointFrame:SetAlpha(0)
						end
					end
				end

				do -- INVALID (PIN)
					if state == "PinInvalid" then
						if lastState ~= state then
							InteractionPinpointFrame.SetIntroAnimation(state, false)

							--------------------------------

							-- ALPHA -- SuperTrackedFrame
							-- SuperTrackedFrame:SetAlpha(0)

							-- ALPHA -- InteractionPinpointFrame
							InteractionPinpointFrame:SetAlpha(0)

							-- SCALE -- InteractionPinpointFrame
							-- InteractionPinpointFrame:SetScale(1)

							-- POSITION -- InteractionPinpointFrame
							-- InteractionPinpointFrame:SetPoint("CENTER", SuperTrackedFrame, 0, blockedHeight)

							-- ALPHA -- InteractionPinpointFrame.Line
							-- InteractionPinpointFrame.Line:SetAlpha(0)

							-- BACKGROUND TEXTURE -- InteractionPinpointFrame.backgroundTexture
							-- InteractionPinpointFrame.backgroundTexture:SetTexture(NS.Variables.PATH .. "border.png")

							--------------------------------

							-- VISIBILITY -- InteractionWaypointFrame.Distance
							InteractionWaypointFrame.Distance:Show()

							-- ALPHA -- InteractionWaypointFrame.Distance
							addon.API.Animation:Fade(InteractionWaypointFrame.Distance, .5, InteractionWaypointFrame.Distance:GetAlpha(), 0)

							-- SCALE -- InteractionWaypointFrame.Distance
							addon.API.Animation:Scale(InteractionWaypointFrame.Distance, 1, InteractionWaypointFrame.Distance:GetScale(), 1.5)

							-- ALPHA -- InteractionWaypointFrame.Line
							addon.API.Animation:Fade(InteractionWaypointFrame.Line, .5, InteractionWaypointFrame.Line:GetAlpha(), 0)

							-- SCALE -- InteractionWaypointFrame.Line
							addon.API.Animation:Scale(InteractionWaypointFrame.Line, 1, InteractionWaypointFrame.Line:GetScale(), 1)
						end

						if (not C_Navigation.WasClampedToScreen()) then
							-- VISIBILITY -- InteractionWaypointFrame
							if InteractionWaypointFrame.Line:GetAlpha() <= .1 then
								InteractionWaypointFrame:Hide()
							else
								InteractionWaypointFrame:Show()
							end

							-- ALPHA -- SuperTrackedFrame
							SuperTrackedFrame:SetAlpha(0)

							-- ALPHA -- InteractionPinpointFrame
							InteractionPinpointFrame:SetAlpha(0)
						end

						-- ALPHA -- SuperTrackedFrame
						SuperTrackedFrame:SetAlpha(0)
					end
				end

				do -- OUT RANGE
					if state == "OutDistance" then
						if lastState ~= state then
							InteractionPinpointFrame.SetIntroAnimation(state, false)

							if NS.Variables.AudioEnable then
								addon.SoundEffects:PlaySound(SOUNDKIT.UI_MAP_WAYPOINT_SUPER_TRACK_OFF)
							end

							--------------------------------

							-- ALPHA -- SuperTrackedFrame
							-- SuperTrackedFrame:SetAlpha(0)

							-- ALPHA -- InteractionPinpointFrame
							-- InteractionPinpointFrame:SetAlpha(0)

							-- SCALE -- InteractionPinpointFrame
							-- InteractionPinpointFrame:SetScale(1)

							-- POSITION -- InteractionPinpointFrame
							-- InteractionPinpointFrame:SetPoint("CENTER", SuperTrackedFrame, 0, blockedHeight)

							-- ALPHA -- InteractionPinpointFrame.Line
							-- InteractionPinpointFrame.Line:SetAlpha(0)

							-- BACKGROUND TEXTURE -- InteractionPinpointFrame.backgroundTexture
							-- InteractionPinpointFrame.backgroundTexture:SetTexture(NS.Variables.PATH .. "border.png")

							--------------------------------

							-- VISIBILITY -- InteractionWaypointFrame.Distance
							InteractionWaypointFrame.Distance:Show()

							-- ALPHA -- InteractionWaypointFrame.Distance
							addon.API.Animation:Fade(InteractionWaypointFrame.Distance, .5, InteractionWaypointFrame.Distance:GetAlpha(), .75)

							-- SCALE -- InteractionWaypointFrame.Distance
							addon.API.Animation:Scale(InteractionWaypointFrame.Distance, 1, InteractionWaypointFrame.Distance:GetScale(), 1)

							-- ALPHA -- InteractionWaypointFrame.Line
							addon.API.Animation:Fade(InteractionWaypointFrame.Line, .5, InteractionWaypointFrame.Line:GetAlpha(), 1)

							-- SCALE -- InteractionWaypointFrame.Line
							addon.API.Animation:Scale(InteractionWaypointFrame.Line, 1, InteractionWaypointFrame.Line:GetScale(), 1)

							-- [ADDON]
							-- Show Waypoint Animation
							-- If last State was not "Pin"

							if lastState ~= "Pin" then
								Callback:NewWaypoint(false)
							end
						end

						if (not C_Navigation.WasClampedToScreen()) then
							-- VISIBILITY -- InteractionWaypointFrame
							InteractionWaypointFrame:Show()

							-- ALPHA -- SuperTrackedFrame
							SuperTrackedFrame:SetAlpha(0)

							-- ALPHA -- InteractionPinpointFrame
							InteractionPinpointFrame:SetAlpha(0)
						end
					end
				end
			end

			--------------------------------

			Callback.LastState = state
		end

		--------------------------------

		Callback.ShowWithAnimation = function()
			if not InteractionPinpointFrame:IsVisible() then
				InteractionPinpointFrame:Show()

				--------------------------------

				InteractionPinpointFrame.Shine.Play()
				addon.API.Animation:Fade(SuperTrackedFrame, .25, 0, 1)
			end
		end

		Callback.HideWithAnimation = function()
			if SuperTrackedFrame:GetAlpha() == 1 then
				addon.Libraries.AceTimer:ScheduleTimer(function()
					SuperTrackedFrame:SetAlpha(0)
				end, .5)

				--------------------------------

				addon.API.Animation:Fade(SuperTrackedFrame, .25, 1, 0)
				addon.API.Animation:Move(InteractionPinpointFrame, .5, "CENTER", NS.Variables.DEFAULT_HEIGHT, NS.Variables.ANIMATION_HEIGHT, "y")
			end
		end

		InteractionPinpointFrame.Shine.Play = function()
			addon.API.Animation:Fade(InteractionPinpointFrame.Shine, .25, 0, 1, addon.API.Animation.EaseExpo)

			--------------------------------

			addon.Libraries.AceTimer:ScheduleTimer(function()
				addon.API.Animation:Fade(InteractionPinpointFrame.Shine, .25, 1, 0, addon.API.Animation.EaseSine)
			end, .125)
		end
	end

	--------------------------------
	-- SETTINGS
	--------------------------------

	do

	end

	--------------------------------
	-- EVENTS
	--------------------------------

	do
		InteractionPinpointFrame:SetScript("OnUpdate", function()
			if NS.Variables.State == "Invalid" then
				if InteractionPinpointFrame:GetAlpha() > .05 then
					InteractionPinpointFrame:SetAlpha(InteractionPinpointFrame:GetAlpha() - .05)
				else
					InteractionPinpointFrame:SetAlpha(0)
				end
			end
		end)

		--------------------------------

		local Events = CreateFrame("Frame")
		Events:RegisterEvent("SUPER_TRACKING_CHANGED")
		Events:SetScript("OnEvent", function(self, event, ...)
			if event == "SUPER_TRACKING_CHANGED" then
				InteractionPinpointFrame:Hide()
				InteractionWaypointFrame:Hide()

				--------------------------------

				NS.Variables.SUPER_TRACKING_CHANGED_COOLDOWN = true
				addon.Libraries.AceTimer:ScheduleTimer(function()
					NS.Variables.SUPER_TRACKING_CHANGED_COOLDOWN = false
				end, .25)
			end
		end)

		local _ = CreateFrame("Frame", "UpdateFrame/Waypoint.lua", nil)
		_:SetScript("OnUpdate", function()
			local isInInstance = IsInInstance()
			local isSuperTrackingAnything = C_SuperTrack.IsSuperTrackingAnything()
			local isSuperTrackingChangedDelay = NS.Variables.SUPER_TRACKING_CHANGED_COOLDOWN
			if not isSuperTrackingAnything or isSuperTrackingChangedDelay then
				return
			end

			--------------------------------

			Callback:Update()

			if not isInInstance then
				InteractionPinpointFrame.UpdateAnimation()
			end

			--------------------------------

			if NS.Variables.LastInInstance ~= isInInstance then
				C_SuperTrack.ClearAllSuperTracked()
			end
			NS.Variables.LastInInstance = isInInstance
		end)
	end
end
