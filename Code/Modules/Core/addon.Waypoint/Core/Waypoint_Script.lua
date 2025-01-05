local addonName, addon = ...
local CallbackRegistry = addon.CallbackRegistry
local L = addon.Locales
local NS = addon.Waypoint

--------------------------------

NS.Script = {}

--------------------------------

function NS.Script:Load()
	--------------------------------
	-- FUNCTIONS (FRAME)
	--------------------------------

	do
		-- FRAME
		do
			addon.Waypoint.ShowWaypoint = function(bypass, sfx)
				local IsWaypointVisible = (InteractionWaypointFrame.Line:GetAlpha() >= .75)
				local IsInPinRange = (C_Navigation.GetDistance() < 200)

				--------------------------------

				if not IsWaypointVisible or bypass then
					if sfx or sfx == nil then
						AdaptiveAPI.Animation:Scale(InteractionWaypointFrame.Line, 2, 50, 1000, "y")

						--------------------------------

						if not IsInPinRange then
							InteractionWaypointFrame.GlowAnimation.Play()

							--------------------------------

							AdaptiveAPI.Animation:Fade(InteractionWaypointFrame.GlowAnimation, .25, 1, 0)
						end

						--------------------------------

						addon.Libraries.AceTimer:ScheduleTimer(function()
							if NS.Variables.AudioEnable then
								if not IsInPinRange and InteractionWaypointFrame:IsVisible() then
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

			addon.Waypoint.HideWaypoint = function(bypass)
				local IsWaypointVisible = (InteractionWaypointFrame.Line:GetAlpha() > 0)

				--------------------------------

				if IsWaypointVisible or bypass then
					InteractionWaypointFrame.Line:SetAlpha(0)
				end
			end

			addon.Waypoint.NewWaypoint = function(audio)
				addon.Waypoint.ShowWaypoint(true, audio or true)
			end

			addon.Waypoint.SetState = function(state)
				local Distance = C_Navigation.GetDistance()

				--------------------------------

				if Distance < 50 then
					if not InteractionWaypointFrame:IsVisible() then
						addon.Waypoint.Variables.State = "Invalid"
					else
						addon.Waypoint.Variables.State = "PinInvalid"
					end

					return
				else
					addon.Waypoint.Variables.State = state
				end
			end
		end

		-- PINPOINT
		do

		end

		-- WAYPOINT
		do

		end
	end

	--------------------------------
	-- FUNCTIONS (ANIMATION)
	--------------------------------

	do
		InteractionPinpointFrame.SetIntroAnimation = function(state, stateIsDistance)
			addon.Waypoint.Playback = true

			--------------------------------

			addon.Libraries.AceTimer:ScheduleTimer(function()
				if (not stateIsDistance and addon.Waypoint.Variables.State == state) or (stateIsDistance and addon.Waypoint.Variables.StateDistance == state) then
					addon.Waypoint.Playback = false
				end
			end, 1)
		end

		InteractionPinpointFrame.UpdateAnimation = function()
			local LastState = addon.Waypoint.LastState
			local State = addon.Waypoint.Variables.State

			--------------------------------

			do -- PINPOINT
				--------------------------------
				-- BLOCKED
				--------------------------------

				if State == "Blocked" then
					if LastState ~= State then
						InteractionPinpointFrame.SetIntroAnimation(State, false)

						if NS.Variables.AudioEnable then
							addon.SoundEffects:PlaySound(SOUNDKIT.UI_MAP_WAYPOINT_BUTTON_CLICK_ON)
						end

						--------------------------------

						-- ALPHA -- SuperTrackedFrame
						-- AdaptiveAPI.Animation:Fade(SuperTrackedFrame, .5, SuperTrackedFrame:GetAlpha(), 1)

						-- ALPHA -- InteractionPinpointFrame
						AdaptiveAPI.Animation:Fade(InteractionPinpointFrame, .5, InteractionPinpointFrame:GetAlpha(), 1)

						-- SCALE -- InteractionPinpointFrame
						AdaptiveAPI.Animation:Scale(InteractionPinpointFrame, 1, InteractionPinpointFrame:GetScale(), 1)

						-- POSITION -- InteractionPinpointFrame
						AdaptiveAPI.Animation:Move(InteractionPinpointFrame, .5, "CENTER", select(5, InteractionPinpointFrame:GetPoint()), NS.Variables.BLOCKED_HEIGHT, "y")

						-- ALPHA -- InteractionPinpointFrame.Line
						AdaptiveAPI.Animation:Fade(InteractionPinpointFrame.Line, .25, InteractionPinpointFrame.Line:GetAlpha(), 0)

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

				--------------------------------
				-- NOT BLOCKED
				--------------------------------

				if State == "NotBlocked" then
					if LastState ~= State then
						InteractionPinpointFrame.SetIntroAnimation(State, false)

						if NS.Variables.AudioEnable then
							addon.SoundEffects:PlaySound(SOUNDKIT.UI_MAP_WAYPOINT_BUTTON_CLICK_OFF)
						end

						--------------------------------

						-- ALPHA -- SuperTrackedFrame
						-- AdaptiveAPI.Animation:Fade(SuperTrackedFrame, .5, SuperTrackedFrame:GetAlpha(), 1)

						-- ALPHA -- InteractionPinpointFrame
						AdaptiveAPI.Animation:Fade(InteractionPinpointFrame, .5, InteractionPinpointFrame:GetAlpha(), 1)

						-- SCALE -- InteractionPinpointFrame
						AdaptiveAPI.Animation:Scale(InteractionPinpointFrame, 1, InteractionPinpointFrame:GetScale(), 1)

						-- POSITION -- InteractionPinpointFrame
						AdaptiveAPI.Animation:Move(InteractionPinpointFrame, .5, "CENTER", select(5, InteractionPinpointFrame:GetPoint()), NS.Variables.DEFAULT_HEIGHT, "y")

						-- ALPHA -- InteractionPinpointFrame.Line
						AdaptiveAPI.Animation:Fade(InteractionPinpointFrame.Line, .25, InteractionPinpointFrame.Line:GetAlpha(), 1)

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

				--------------------------------
				-- INVALID
				--------------------------------

				if State == "Invalid" then
					if LastState ~= State then
						InteractionPinpointFrame.SetIntroAnimation(State, false)

						--------------------------------

						-- ALPHA -- SuperTrackedFrame
						AdaptiveAPI.Animation:Fade(SuperTrackedFrame, .5, SuperTrackedFrame:GetAlpha(), 0)

						-- ALPHA -- InteractionPinpointFrame
						-- AdaptiveAPI.Animation:Fade(InteractionPinpointFrame, .5, InteractionPinpointFrame:GetAlpha(), 1)

						-- SCALE -- InteractionPinpointFrame
						-- AdaptiveAPI.Animation:Scale(InteractionPinpointFrame, 1, InteractionPinpointFrame:GetScale(), 1)

						-- POSITION -- InteractionPinpointFrame
						-- AdaptiveAPI.Animation:Move(InteractionPinpointFrame, .5, "CENTER", select(5, InteractionPinpointFrame:GetPoint()), NS.Variables.DEFAULT_HEIGHT, "y")

						-- ALPHA -- InteractionPinpointFrame.Line
						-- AdaptiveAPI.Animation:Fade(InteractionPinpointFrame.Line, .25, InteractionPinpointFrame.Line:GetAlpha(), 0)

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

			do -- WAYPOINT
				--------------------------------
				-- IN DISTANCE (PIN)
				--------------------------------

				if State == "Pin" then
					if LastState ~= State then
						InteractionPinpointFrame.SetIntroAnimation(State, false)

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
						AdaptiveAPI.Animation:Fade(InteractionWaypointFrame.Distance, .5, InteractionWaypointFrame.Distance:GetAlpha(), 1)

						-- SCALE -- InteractionWaypointFrame.Distance
						AdaptiveAPI.Animation:Scale(InteractionWaypointFrame.Distance, 1, InteractionWaypointFrame.Distance:GetScale(), 1.5)

						-- ALPHA -- InteractionWaypointFrame.Line
						AdaptiveAPI.Animation:Fade(InteractionWaypointFrame.Line, .5, InteractionWaypointFrame.Line:GetAlpha(), .75)

						-- SCALE -- InteractionWaypointFrame.Line
						AdaptiveAPI.Animation:Scale(InteractionWaypointFrame.Line, 1, InteractionWaypointFrame.Line:GetScale(), 1)
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

				--------------------------------
				-- INVALID (PIN)
				--------------------------------

				if State == "PinInvalid" then
					if LastState ~= State then
						InteractionPinpointFrame.SetIntroAnimation(State, false)

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
						AdaptiveAPI.Animation:Fade(InteractionWaypointFrame.Distance, .5, InteractionWaypointFrame.Distance:GetAlpha(), 0)

						-- SCALE -- InteractionWaypointFrame.Distance
						AdaptiveAPI.Animation:Scale(InteractionWaypointFrame.Distance, 1, InteractionWaypointFrame.Distance:GetScale(), 1.5)

						-- ALPHA -- InteractionWaypointFrame.Line
						AdaptiveAPI.Animation:Fade(InteractionWaypointFrame.Line, .5, InteractionWaypointFrame.Line:GetAlpha(), 0)

						-- SCALE -- InteractionWaypointFrame.Line
						AdaptiveAPI.Animation:Scale(InteractionWaypointFrame.Line, 1, InteractionWaypointFrame.Line:GetScale(), 1)
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

				--------------------------------
				-- OUTSIDE DISTANCE
				--------------------------------

				if State == "OutDistance" then
					if LastState ~= State then
						InteractionPinpointFrame.SetIntroAnimation(State, false)

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
						AdaptiveAPI.Animation:Fade(InteractionWaypointFrame.Distance, .5, InteractionWaypointFrame.Distance:GetAlpha(), .75)

						-- SCALE -- InteractionWaypointFrame.Distance
						AdaptiveAPI.Animation:Scale(InteractionWaypointFrame.Distance, 1, InteractionWaypointFrame.Distance:GetScale(), 1)

						-- ALPHA -- InteractionWaypointFrame.Line
						AdaptiveAPI.Animation:Fade(InteractionWaypointFrame.Line, .5, InteractionWaypointFrame.Line:GetAlpha(), 1)

						-- SCALE -- InteractionWaypointFrame.Line
						AdaptiveAPI.Animation:Scale(InteractionWaypointFrame.Line, 1, InteractionWaypointFrame.Line:GetScale(), 1)

						-- [ADDON]
						-- Show Waypoint Animation
						-- If last State was not "Pin"

						if LastState ~= "Pin" then
							addon.Waypoint.NewWaypoint(false)
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

			--------------------------------

			addon.Waypoint.LastState = State
		end

		--------------------------------

		addon.Waypoint.ShowWithAnimation = function()
			if not InteractionPinpointFrame:IsVisible() then
				InteractionPinpointFrame:Show()
				InteractionPinpointFrame.Shine.Play()

				AdaptiveAPI.Animation:Fade(SuperTrackedFrame, .25, 0, 1)
				-- if InteractionPinpointFrame.Line:GetAlpha() >= 1 then
				--     AdaptiveAPI.Animation:Move(InteractionPinpointFrame, .5, "CENTER", NS.Variables.ANIMATION_HEIGHT, NS.Variables.DEFAULT_HEIGHT, "y")
				-- else
				--     AdaptiveAPI.Animation:Move(InteractionPinpointFrame, .5, "CENTER", NS.Variables.ANIMATION_HEIGHT, blockedHeight, "y")
				-- end
			end
		end

		addon.Waypoint.HideWithAnimation = function()
			if SuperTrackedFrame:GetAlpha() == 1 then
				AdaptiveAPI.Animation:Fade(SuperTrackedFrame, .25, 1, 0)
				AdaptiveAPI.Animation:Move(InteractionPinpointFrame, .5, "CENTER", NS.Variables.DEFAULT_HEIGHT, NS.Variables.ANIMATION_HEIGHT, "y")

				addon.Libraries.AceTimer:ScheduleTimer(function()
					SuperTrackedFrame:SetAlpha(0)
				end, .5)
			end
		end

		InteractionPinpointFrame.Shine.Play = function()
			AdaptiveAPI.Animation:Fade(InteractionPinpointFrame.Shine, .25, 0, 1, AdaptiveAPI.Animation.EaseExpo)

			--------------------------------

			addon.Libraries.AceTimer:ScheduleTimer(function()
				AdaptiveAPI.Animation:Fade(InteractionPinpointFrame.Shine, .25, 1, 0, AdaptiveAPI.Animation.EaseSine)
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
			if addon.Waypoint.Variables.State == "Invalid" then
				if InteractionPinpointFrame:GetAlpha() > .05 then
					InteractionPinpointFrame:SetAlpha(InteractionPinpointFrame:GetAlpha() - .05)
				else
					InteractionPinpointFrame:SetAlpha(0)
				end
			end
		end)

		--------------------------------

		local function UpdateSuperTrackedFrame()
			--------------------------------
			-- CURRENT TARGET IS QUEST & IN WORLD
			--------------------------------

			local SuperTrackedFrameIconTexture = tostring(SuperTrackedFrame.Icon:GetTexture())

			local IsSuperTrackingAnything = (C_SuperTrack.IsSuperTrackingAnything())
			local IsInInstance = (IsInInstance())
			local IsDefaultIcon = (SuperTrackedFrameIconTexture == "3308452")
			local IsPinIcon = (SuperTrackedFrameIconTexture == "3500068")
			local IsInvalidDistance = (C_Navigation.GetDistance() == 0)
			local IsValidDistance = (C_Navigation.GetDistance() >= 5)

			--------------------------------

			if (IsSuperTrackingAnything) and (not IsInInstance) and (IsDefaultIcon or IsPinIcon) and (IsValidDistance) then
				--------------------------------
				-- SETUP
				--------------------------------

				SuperTrackedFrame:Show()

				--------------------------------
				-- VARIABLES
				--------------------------------

				-- SHORTCUTS
				local SuperTrackType = C_SuperTrack.GetHighestPrioritySuperTrackingType()

				-- QUEST
				local SelectedQuestID = C_SuperTrack.GetSuperTrackedQuestID()
				local SelectedQuestObjectives = nil
				local SelectedQuestCompletion = nil
				local SelectedQuestIsMultiObjective = false
				local CurrentQuestObjectiveIndex = 1
				local SelectedQuestCompleted = false

				-- MAIN
				local NavState = C_Navigation.GetTargetState()

				--------------------------------
				-- NEW WAYPOINT
				--------------------------------

				local ID = C_SuperTrack.GetHighestPrioritySuperTrackingType()

				if (addon.Waypoint.ID ~= ID or addon.Waypoint.QuestID ~= SelectedQuestID) and (not C_Navigation.WasClampedToScreen()) then
					addon.Waypoint.ID = ID
					addon.Waypoint.QuestID = SelectedQuestID

					addon.Waypoint.NewWaypoint()
				end

				--------------------------------
				-- TYPE DETAILS
				--------------------------------

				-- QUEST (OBJECTIVES/COMPLETED)
				if SuperTrackType == Enum.SuperTrackingType.Quest and SelectedQuestID then
					local IsQuestComplete = (C_QuestLog.IsComplete(SelectedQuestID))

					--------------------------------

					if IsQuestComplete then
						SelectedQuestCompletion = true
					else
						SelectedQuestObjectives = C_QuestLog.GetQuestObjectives(SelectedQuestID)

						--------------------------------

						if SelectedQuestObjectives and #SelectedQuestObjectives > 1 then
							SelectedQuestIsMultiObjective = true
						else
							SelectedQuestIsMultiObjective = false
						end

						if SelectedQuestObjectives then
							for i, objective in ipairs(SelectedQuestObjectives) do
								if objective.finished then
									if i < #SelectedQuestObjectives then
										CurrentQuestObjectiveIndex = i + 1
									else
										SelectedQuestCompletion = true
									end
								end
							end
						end
					end
				end


				--------------------------------
				-- NAVIGATION STATE
				--------------------------------

				local InvalidInRange = (NavState == Enum.NavigationState.Invalid and C_Navigation.GetDistance() < 200)
				local Blocked = (NavState == Enum.NavigationState.Occluded or (NavState == Enum.NavigationState.Invalid and C_Navigation.GetDistance() >= 200))
				local NotBlocked = (NavState == Enum.NavigationState.InRange)
				local Invalid = (NavState == Enum.NavigationState.Invalid)

				if (not Invalid and C_Navigation.GetDistance() >= 200) or (Invalid and C_Navigation.GetDistance() > 1000) then
					addon.Waypoint.SetState("OutDistance")
				else
					if SuperTrackType == Enum.SuperTrackingType.Quest then
						--------------------------------

						local IsMultiObjectiveQuest = SelectedQuestObjectives and #SelectedQuestObjectives > 1

						--------------------------------

						if IsMultiObjectiveQuest then
							if Invalid then
								addon.Waypoint.SetState("PinInvalid")
							else
								addon.Waypoint.SetState("Pin")
							end
						else
							if InvalidInRange then
								addon.Waypoint.SetState("Invalid")
							elseif Blocked then
								addon.Waypoint.SetState("Blocked")
							elseif NotBlocked then
								addon.Waypoint.SetState("NotBlocked")
							elseif Invalid then
								addon.Waypoint.SetState("Invalid")
							end
						end
					else
						local PinInvalid = (NavState == Enum.NavigationState.Invalid or C_Navigation.GetDistance() <= 50)

						--------------------------------

						if PinInvalid then
							addon.Waypoint.SetState("PinInvalid")
						else
							addon.Waypoint.SetState("Pin")
						end
					end
				end

				--------------------------------
				-- NAVIGATION POINT VISIBLE IN WORLD
				--------------------------------

				local IsSuperTrackedVisible = ((not C_Navigation.WasClampedToScreen()))
				local IsQuest = (((SuperTrackType == Enum.SuperTrackingType.Quest) or (SelectedQuestCompletion)) and (not SelectedQuestIsMultiObjective))
				local IsWaypoint = ((SuperTrackType ~= Enum.SuperTrackingType.Quest) or (SelectedQuestIsMultiObjective))

				--------------------------------

				if IsSuperTrackedVisible and (IsQuest or IsWaypoint) then
					local IsInRange = (NavState == Enum.NavigationState.Invalid and C_Navigation.GetDistance() < 200)
					local IsQuest = (SuperTrackType == Enum.SuperTrackingType.Quest and not SelectedQuestIsMultiObjective)

					--------------------------------

					SuperTrackedFrame.Icon:SetAlpha(0)
					SuperTrackedFrame.DistanceText:SetAlpha(0)

					--------------------------------
					-- WITHIN RANGE
					--------------------------------

					if not IsInRange then
						addon.Waypoint.ShowWithAnimation()
					end

					--------------------------------
					-- TEXT
					--------------------------------

					if IsQuest then
						local IsCompleted = (SelectedQuestCompleted)
						local IsComplete = (SelectedQuestCompletion)
						local CurrentWaypointObjective = (C_QuestLog.GetNextWaypointText(SelectedQuestID))
						local CurrentQuestObjective = ((SelectedQuestObjectives and #SelectedQuestObjectives >= CurrentQuestObjectiveIndex and SelectedQuestObjectives[CurrentQuestObjectiveIndex].text) or "")

						--------------------------------

						if IsCompleted then
							if CurrentWaypointObjective then
								InteractionPinpointFrame.Label:SetText(CurrentWaypointObjective)
							else
								InteractionPinpointFrame.Label:SetText(L["Waypoint - Ready for Turn-in"])
							end
						else
							if SelectedQuestObjectives then
								if CurrentWaypointObjective then
									InteractionPinpointFrame.Label:SetText(CurrentWaypointObjective)
								else
									InteractionPinpointFrame.Label:SetText(CurrentQuestObjective)
								end
							elseif IsComplete then
								if CurrentWaypointObjective then
									InteractionPinpointFrame.Label:SetText(CurrentWaypointObjective)
								else
									InteractionPinpointFrame.Label:SetText(L["Waypoint - Ready for Turn-in"])
								end
							end
						end
					else
						local function GetTrackingType()
							local Text = ""

							--------------------------------

							local UserWaypoint = (SuperTrackType == Enum.SuperTrackingType.UserWaypoint)
							local MapPin = (SuperTrackType == Enum.SuperTrackingType.MapPin)
							local PartyMember = (SuperTrackType == Enum.SuperTrackingType.PartyMember)
							local Content = (SuperTrackType == Enum.SuperTrackingType.Content)
							local QuestOffer = (MapPin and SuperTrackType == Enum.SuperTrackingMapPinType.QuestOffer)
							local TaxiNode = (MapPin and SuperTrackType == Enum.SuperTrackingMapPinType.TaxiNode)

							--------------------------------

							if UserWaypoint then
								Text = L["Waypoint - Waypoint"]
							elseif MapPin then
								if QuestOffer then
									Text = L["Waypoint - Quest"]
								elseif TaxiNode then
									Text = L["Waypoint - Flight Point"]
								else
									Text = L["Waypoint - Pin"]
								end
							elseif PartyMember then
								Text = L["Waypoint - Party Member"]
							elseif Content then
								Text = L["Waypoint - Content"]
							else
								Text = L["Waypoint - Waypoint"]
							end
						end

						--------------------------------

						InteractionPinpointFrame.Label:SetText(GetTrackingType())
					end

					--------------------------------
					-- FRAME FORMATTING
					--------------------------------

					if InteractionPinpointFrame.Label:GetStringWidth() >= 300 then
						InteractionPinpointFrame.Label:SetWidth(275)
						InteractionPinpointFrame.Background:SetSize(300, InteractionPinpointFrame.Label:GetStringHeight() + 25)
					else
						InteractionPinpointFrame.Label:SetWidth(InteractionPinpointFrame.Label:GetStringWidth() + 25)
						InteractionPinpointFrame.Background:SetSize(InteractionPinpointFrame.Label:GetStringWidth() + 25, InteractionPinpointFrame.Label:GetStringHeight() + 25)
					end

					InteractionWaypointFrame.Distance:SetText(AdaptiveAPI:FormatNumber(C_Navigation.GetDistance()) .. " yds")

					--------------------------------
					-- DIRECTION TO NAVIGATION POINT VISIBLE
					--------------------------------
				else
					if
					-- QUEST
						(SuperTrackType == Enum.SuperTrackingType.Quest and (SelectedQuestObjectives and SelectedQuestObjectives[1]) or (SelectedQuestCompletion))

						-- WAYPOINT
						or (SuperTrackType ~= Enum.SuperTrackingType.Quest)
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
				--------------------------------
				-- SET TO DEFAULT NAVIGATION POINT
				--------------------------------
			else
				InteractionPinpointFrame:Hide()
				InteractionWaypointFrame:Hide()

				SuperTrackedFrame.Icon:SetAlpha(1)
				SuperTrackedFrame.Arrow:SetAlpha(1)
				SuperTrackedFrame.DistanceText:SetAlpha(1)

				if not IsInInstance then
					if IsSuperTrackingAnything and not IsInvalidDistance then
						SuperTrackedFrame:Show()
					else
						SuperTrackedFrame:Hide()
					end
				else
					SuperTrackedFrame:Show()
				end
			end
		end

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
			local IsSuperTrackingAnything = C_SuperTrack.IsSuperTrackingAnything()
			local IsSuperTrackingChangedDelay = NS.Variables.SUPER_TRACKING_CHANGED_COOLDOWN

			--------------------------------

			if not IsSuperTrackingAnything or IsSuperTrackingChangedDelay then
				return
			end

			--------------------------------

			UpdateSuperTrackedFrame()

			if not IsInInstance() then
				InteractionPinpointFrame.UpdateAnimation()
			end

			--------------------------------

			if addon.Waypoint.Variables.LastInInstance ~= IsInInstance() then
				C_SuperTrack.ClearAllSuperTracked()
			end
			addon.Waypoint.Variables.LastInInstance = IsInInstance()
		end)
	end
end
