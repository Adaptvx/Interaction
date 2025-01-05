local addonName, addon = ...
local CallbackRegistry = addon.CallbackRegistry
local L = addon.Locales
local NS = addon.Cinematic

--------------------------------

NS.Script = {}

--------------------------------

local GetGlidingInfo = not addon.Variables.IS_CLASSIC and C_PlayerInfo.GetGlidingInfo or nil

--------------------------------

function NS.Script:Load()
	--------------------------------
	-- FUNCTIONS
	--------------------------------

	do -- EFFECTS
		do -- INIT
			function NS.Script:StartTransition()
				local SavedTime = GetTime()
				NS.Variables.ActiveID = SavedTime

				--------------------------------

				NS.Variables.IsTransition = true
				addon.Libraries.AceTimer:ScheduleTimer(function()
					if SavedTime == NS.Variables.ActiveID then
						NS.Variables.IsTransition = false
					end
				end, 2.5)
			end

			function NS.Script:CancelTransition()
				NS.Variables.IsTransition = false
			end

			function NS.Script:SaveView()
				local IsCinematicMode = not NS.Variables.IsHorizontalMode
				local IsHorizontalMode = NS.Variables.IsHorizontalMode

				local IsPan = (addon.Database.VAR_CINEMATIC_PAN)
				local IsZoom = (addon.Database.VAR_CINEMATIC_ZOOM)
				local IsPitch = (addon.Database.VAR_CINEMATIC_ZOOM_PITCH)
				local IsFOV = (addon.Database.VAR_CINEMATIC_ZOOM_FOV)
				local IsActionCam = (addon.Database.VAR_CINEMATIC_ACTIONCAM)
				local IsActionCamSide = (addon.Database.VAR_CINEMATIC_ACTIONCAM_SIDE)
				local IsActionCamOffset = (addon.Database.VAR_CINEMATIC_ACTIONCAM_OFFSET)
				local IsActionCamFocus = (addon.Database.VAR_CINEMATIC_ACTIONCAM_FOCUS)
				local IsActionCamFocusX = (addon.Database.VAR_CINEMATIC_ACTIONCAM_FOCUS_X)
				local IsActionCamFocusY = (addon.Database.VAR_CINEMATIC_ACTIONCAM_FOCUS_Y)
				local IsVignette = (addon.Database.VAR_CINEMATIC_VIGNETTE)

				--------------------------------

				if (addon.Variables.Platform == 1) and (IsPan or IsActionCamSide) then
					SaveView(3)
				end

				--------------------------------

				NS.Variables.Saved_Zoom = GetCameraZoom()
			end

			function NS.Script:ResetView()
				local IsCinematicMode = not NS.Variables.IsHorizontalMode
				local IsHorizontalMode = NS.Variables.IsHorizontalMode

				local IsPan = (addon.Database.VAR_CINEMATIC_PAN)
				local IsZoom = (addon.Database.VAR_CINEMATIC_ZOOM)
				local IsPitch = (addon.Database.VAR_CINEMATIC_ZOOM_PITCH)
				local IsFOV = (addon.Database.VAR_CINEMATIC_ZOOM_FOV)
				local IsActionCam = (addon.Database.VAR_CINEMATIC_ACTIONCAM)
				local IsActionCamSide = (addon.Database.VAR_CINEMATIC_ACTIONCAM_SIDE)
				local IsActionCamOffset = (addon.Database.VAR_CINEMATIC_ACTIONCAM_OFFSET)
				local IsActionCamFocus = (addon.Database.VAR_CINEMATIC_ACTIONCAM_FOCUS)
				local IsActionCamFocusX = (addon.Database.VAR_CINEMATIC_ACTIONCAM_FOCUS_X)
				local IsActionCamFocusY = (addon.Database.VAR_CINEMATIC_ACTIONCAM_FOCUS_Y)
				local IsVignette = (addon.Database.VAR_CINEMATIC_VIGNETTE)

				--------------------------------

				if (addon.Variables.Platform == 1) and (IsPan or IsActionCamSide) then
					SetView(3)
				else
					NS.Util:SetCameraZoom(NS.Variables.Saved_Zoom, true)
				end
			end
		end

		do -- ZOOM
			function NS.Script:StartZoom()
				NS.Variables.IsZooming = true
				addon.Libraries.AceTimer:ScheduleTimer(function()
					NS.Variables.IsZooming = false
				end, 2)

				--------------------------------

				SetCVar("cameraViewBlendStyle", 1)

				--------------------------------

				local current = GetCameraZoom()
				local target
				if current < addon.Database.VAR_CINEMATIC_ZOOM_DISTANCE_MIN then
					target = addon.Database.VAR_CINEMATIC_ZOOM_DISTANCE_MIN
				elseif current > addon.Database.VAR_CINEMATIC_ZOOM_DISTANCE_MAX then
					target = addon.Database.VAR_CINEMATIC_ZOOM_DISTANCE_MAX
				else
					target = current
				end

				NS.Util:SetCameraZoom(target, true)
			end

			function NS.Script:CancelZoom()
				NS.Variables.IsZooming = false
			end
		end

		do -- PITCH
			function NS.Script:StartPitch()
				NS.Util:SetCameraPitch(addon.Database.VAR_CINEMATIC_ZOOM_PITCH_LEVEL, 1.75)
			end

			function NS.Script:CancelPitch()
				NS.Util:StopCameraPitch()
			end
		end

		do -- FOV
			function NS.Script:StartFOV()
				NS.Util:SetCameraFieldOfView(75, 5)
			end

			function NS.Script:CancelFOV()
				NS.Util:StopCameraFieldOfView()
			end
		end

		do -- PAN
			function NS.Script:StartPan()
				NS.Variables.IsPanning = true

				--------------------------------

				InteractionFrame.CinematicMode.PanHandler:Show()

				--------------------------------

				if INTDB.profile.INT_UIDIRECTION == 1 then
					NS.Variables.IsPanning_Direction = "Left"
				else
					NS.Variables.IsPanning_Direction = "Right"
				end
			end

			function NS.Script:CancelPan()
				NS.Variables.IsPanning = false
				NS.Variables.IsPanning_Direction = ""

				--------------------------------

				InteractionFrame.CinematicMode.PanHandler:Hide()

				--------------------------------

				MoveViewLeftStop()
				MoveViewRightStop()
			end
		end

		do -- SIDE VIEW
			function NS.Script:StartSideView()
				if INTDB.profile.INT_UIDIRECTION == 1 then
					NS.Util:SetCameraYaw(addon.Database.VAR_CINEMATIC_ACTIONCAM_SIDE_STRENGTH, "LEFT")
				else
					NS.Util:SetCameraYaw(addon.Database.VAR_CINEMATIC_ACTIONCAM_SIDE_STRENGTH, "RIGHT")
				end
			end

			function NS.Script:CancelSideView()
				NS.Util:StopCameraYaw()
			end
		end

		do -- FOCUS
			function NS.Script:StartFocus(strength, limitX, limitY)
				SetCVar("test_cameraTargetFocusInteractEnable", 1)

				--------------------------------

				NS.Variables.Saved_FocusInteractStrengthPitch = GetCVar("test_cameraTargetFocusInteractStrengthPitch")
				NS.Variables.Saved_FocusInteractionStrengthYaw = GetCVar("test_cameraTargetFocusEnemyStrengthYaw")

				--------------------------------

				NS.Util:SetFocusInteractStrength(strength, 1, limitX, limitY)
			end

			function NS.Script:CancelFocus()
				SetCVar("test_cameraTargetFocusInteractEnable", addon.ConsoleVariables.Variables.Saved_cameraTargetFocusInteractEnable)
				NS.Util:StopFocusInteractStrength()
			end
		end

		do -- OFFSET
			function NS.Script:StartOffset(IsAutoZoom, OffsetStrength)
				local Strength
				local Modifier = 1

				if IsMounted() then
					if INTDB.profile.INT_UIDIRECTION == 1 then
						Modifier = .25
					else
						Modifier = 3.75
					end
				end

				if AdaptiveAPI:IsPlayerInShapeshiftForm() and not IsMounted() then
					Modifier = .5
				end

				if IsIndoors() then
					Modifier = 1
				end

				--------------------------------

				local Current = GetCameraZoom()
				local Target
				local Valid
				if addon.Database.VAR_CINEMATIC_ZOOM_DISTANCE_MIN and Current < addon.Database.VAR_CINEMATIC_ZOOM_DISTANCE_MIN then
					Valid = true
					Target = (addon.Database.VAR_CINEMATIC_ZOOM_DISTANCE_MIN / 39)
				elseif addon.Database.VAR_CINEMATIC_ZOOM_DISTANCE_MAX and Current > addon.Database.VAR_CINEMATIC_ZOOM_DISTANCE_MAX then
					Valid = true
					Target = (addon.Database.VAR_CINEMATIC_ZOOM_DISTANCE_MAX / 39)
				else
					Valid = false
					Target = (Current / 39)
				end

				if (IsAutoZoom) and (Valid) then
					Strength = (OffsetStrength * (Target) * Modifier)
				else
					Strength = (OffsetStrength * (Current / 39) * Modifier)
				end

				--------------------------------

				-- Force stop shoulder offset reset animation,
				if InteractionFrame.INT_ShoulderOffset and InteractionFrame.INT_ShoulderOffset:GetScript("OnUpdate") then
					NS.Util:ForceStopSetShoulderOffset()
				end

				-- Start new shoulder offset animation,
				addon.Libraries.AceTimer:ScheduleTimer(function()
					NS.Variables.Saved_ShoulderOffset = GetCVar("test_cameraOverShoulder")

					if INTDB.profile.INT_UIDIRECTION == 1 then
						NS.Util:SetShoulderOffset(-Strength, 2.5)
					else
						NS.Util:SetShoulderOffset(Strength, 2.5)
					end
				end, 0)
			end

			function NS.Script:CancelOffset()
				NS.Util:StopSetShoulderOffset()
			end
		end

		do -- VIGNETTE
			function NS.Script:StartCinematicVignette()
				InteractionFrame.CinematicMode.Vignette.ShowWithAnimation()
			end

			function NS.Script:StopCinematicVignette()
				InteractionFrame.CinematicMode.Vignette.HideWithAnimation()
			end
		end
	end

	do -- MAIN
		function NS.Script:StartCinematicMode(bypass, horizontalMode)
			if InCombatLockdown() then
				return
			end

			--------------------------------

			local InteractionActive = addon.Interaction.Variables.Active
			local InteractionLastActive = addon.Interaction.Variables.LastActive
			local CinematicModeActive = NS.Variables.Active

			--------------------------------

			if (not CinematicModeActive and bypass) or (not CinematicModeActive and InteractionActive and not InteractionLastActive) then
				NS.Variables.Active = true
				NS.Variables.IsHorizontalMode = horizontalMode

				local IsCinematicMode = not NS.Variables.IsHorizontalMode
				local IsHorizontalMode = NS.Variables.IsHorizontalMode

				local IsPan = (addon.Database.VAR_CINEMATIC_PAN)
				local IsZoom = (addon.Database.VAR_CINEMATIC_ZOOM)
				local IsPitch = (addon.Database.VAR_CINEMATIC_ZOOM_PITCH)
				local IsFOV = (addon.Database.VAR_CINEMATIC_ZOOM_FOV)
				local IsActionCam = (addon.Database.VAR_CINEMATIC_ACTIONCAM)
				local IsActionCamSide = (addon.Database.VAR_CINEMATIC_ACTIONCAM_SIDE)
				local IsActionCamOffset = (addon.Database.VAR_CINEMATIC_ACTIONCAM_OFFSET)
				local IsActionCamFocus = (addon.Database.VAR_CINEMATIC_ACTIONCAM_FOCUS)
				local IsActionCamFocusX = (addon.Database.VAR_CINEMATIC_ACTIONCAM_FOCUS_X)
				local IsActionCamFocusY = (addon.Database.VAR_CINEMATIC_ACTIONCAM_FOCUS_Y)
				local IsVignette = (addon.Database.VAR_CINEMATIC_VIGNETTE)

				--------------------------------
				-- SAVE STATE
				--------------------------------

				NS.Script:SaveView()

				--------------------------------
				-- TRANSITION STATE
				--------------------------------

				NS.Script:StartTransition()

				--------------------------------
				-- ZOOM
				--------------------------------

				if IsCinematicMode then
					if IsZoom then
						NS.Script:StartZoom()

						--------------------------------

						if IsPitch then
							NS.Script:StartPitch()
						end

						--------------------------------

						if IsFOV then
							NS.Script:StartFOV()
						end
					end
				end

				--------------------------------
				-- PAN
				--------------------------------

				if IsCinematicMode then
					if IsActionCam and IsActionCamSide then
						local SideViewDuration = (addon.Database.VAR_CINEMATIC_ACTIONCAM_SIDE_STRENGTH * 2)

						--------------------------------

						NS.Script:StartSideView()

						--------------------------------

						addon.Libraries.AceTimer:ScheduleTimer(function()
							if NS.Variables.Active then
								NS.Script:CancelSideView()

								--------------------------------

								if IsPan then
									NS.Script:StartPan()
								end
							end
						end, SideViewDuration - .25)
					else
						if IsPan then
							NS.Script:StartPan()
						end
					end
				end

				--------------------------------
				-- ACTIONCAM
				--------------------------------

				if IsHorizontalMode or IsActionCam then
					if IsHorizontalMode then
						NS.Script:StartOffset(false, 15)
					end

					if IsCinematicMode then
						if IsActionCamFocus then
							NS.Script:StartFocus(addon.Database.VAR_CINEMATIC_ACTIONCAM_FOCUS_STRENGTH, IsActionCamFocusX, IsActionCamFocusY)
						end

						if IsActionCamOffset then
							NS.Script:StartOffset(IsZoom, addon.Database.VAR_CINEMATIC_ACTIONCAM_OFFSET_STRENGTH)
						end

						if IsActionCamSide then
							NS.Script:StartSideView()
						end
					end
				end

				--------------------------------
				-- VIGNETTE
				--------------------------------

				if IsCinematicMode then
					if IsVignette then
						NS.Script:StartCinematicVignette()
					end
				end
			end

			--------------------------------

			CallbackRegistry:Trigger("START_CINEMATIC_MODE")
		end

		function NS.Script:CancelCinematicMode(bypass)
			local InteractionActive = addon.Interaction.Variables.Active
			local InteractionLastActive = addon.Interaction.Variables.LastActive
			local CinematicModeActive = NS.Variables.Active

			--------------------------------

			if (CinematicModeActive and bypass) or (not InteractionActive and InteractionLastActive and CinematicModeActive) then
				NS.Variables.Active = false

				local IsCinematicMode = not NS.Variables.IsHorizontalMode
				local IsHorizontalMode = NS.Variables.IsHorizontalMode

				local IsPan = (addon.Database.VAR_CINEMATIC_PAN)
				local IsZoom = (addon.Database.VAR_CINEMATIC_ZOOM)
				local IsPitch = (addon.Database.VAR_CINEMATIC_ZOOM_PITCH)
				local IsFOV = (addon.Database.VAR_CINEMATIC_ZOOM_FOV)
				local IsActionCam = (addon.Database.VAR_CINEMATIC_ACTIONCAM)
				local IsActionCamSide = (addon.Database.VAR_CINEMATIC_ACTIONCAM_SIDE)
				local IsActionCamOffset = (addon.Database.VAR_CINEMATIC_ACTIONCAM_OFFSET)
				local IsActionCamFocus = (addon.Database.VAR_CINEMATIC_ACTIONCAM_FOCUS)
				local IsVignette = (addon.Database.VAR_CINEMATIC_VIGNETTE)

				--------------------------------
				-- RESET STATE
				--------------------------------

				if IsCinematicMode then
					local InCombat = (InCombatLockdown())

					if not InCombat and (IsPan or IsZoom or (IsActionCam and IsActionCamSide)) then
						NS.Script:ResetView()
					end
				end

				--------------------------------
				-- TRANSITION STATE
				--------------------------------

				NS.Script:CancelTransition()

				--------------------------------
				-- ZOOM
				--------------------------------

				if IsCinematicMode then
					if IsZoom then
						NS.Script:CancelZoom()

						--------------------------------

						if IsPitch then
							NS.Script:CancelPitch()
						end

						--------------------------------

						if IsFOV then
							NS.Script:CancelFOV()
						end
					end
				end

				--------------------------------
				-- PAN
				--------------------------------

				if IsCinematicMode then
					NS.Script:CancelPan()
				end

				--------------------------------
				-- ACTIONCAM
				--------------------------------

				if IsHorizontalMode or IsActionCam then
					if IsCinematicMode then
						if IsActionCamFocus then
							NS.Script:CancelFocus()
						end

						if IsActionCamOffset then
							NS.Script:CancelOffset()
						end

						if IsActionCamSide then
							NS.Script:CancelSideView()
						end
					else
						NS.Script:CancelOffset()
					end
				end

				--------------------------------
				-- VIGNETTE
				--------------------------------

				if IsCinematicMode then
					if IsVignette then
						NS.Script:StopCinematicVignette()
					end
				end
			end

			--------------------------------

			CallbackRegistry:Trigger("STOP_CINEMATIC_MODE")
		end
	end

	do -- ANIMATION
		InteractionFrame.CinematicMode.Vignette.ShowWithAnimation = function()
			AdaptiveAPI.Animation:Fade(InteractionFrame.CinematicMode.Vignette, 1, InteractionFrame.CinematicMode.Vignette:GetAlpha(), 1)
		end

		InteractionFrame.CinematicMode.Vignette.HideWithAnimation = function()
			AdaptiveAPI.Animation:Fade(InteractionFrame.CinematicMode.Vignette, .5, InteractionFrame.CinematicMode.Vignette:GetAlpha(), 0)
		end
	end

	--------------------------------
	-- CALLBACKS
	--------------------------------

	do -- INTERACTION
		function NS.Script:StartInteraction()
			if not INTDB.profile.INT_CINEMATIC then
				return
			end

			--------------------------------

			local InteractTargetIsSelf = ((UnitName("npc") == UnitName("player")) or UnitName("questnpc") == UnitName("player"))
			local IsStaticNPC = ((UnitName("npc") and not UnitExists("npc")) or (UnitName("questnpc") and not UnitExists("questnpc")))
			local InInstance = (IsInInstance())
			local IsSkyriding = not addon.Variables.IS_CLASSIC and select(1, GetGlidingInfo()) or false

			if InteractTargetIsSelf or IsStaticNPC or InInstance or IsSkyriding then
				return
			end

			--------------------------------

			NS.Script:StartCinematicMode()
		end

		function NS.Script:StopInteraction(bypass)
			if not INTDB.profile.INT_CINEMATIC then
				return
			end

			--------------------------------

			local InteractTargetIsSelf = ((UnitName("npc") == UnitName("player")) or UnitName("questnpc") == UnitName("player"))
			local IsStaticNPC = ((UnitName("npc") and not UnitExists("npc")) or (UnitName("questnpc") and not UnitExists("questnpc")))
			local InInstance = (IsInInstance())

			if (InteractTargetIsSelf or IsStaticNPC or InInstance) and not NS.Variables.Active then
				return
			end

			--------------------------------

			if NS.Variables.Active then
				NS.Script:CancelCinematicMode()
			end
		end

		--------------------------------

		CallbackRegistry:Add("START_INTERACTION", function() NS.Script:StartInteraction() end, 0)
		CallbackRegistry:Add("STOP_INTERACTION", function() NS.Script:StopInteraction() end, 0)
	end

	--------------------------------
	-- EVENTS
	--------------------------------

	do
		CallbackRegistry:Add("SETTINGS_UIDIRECTION_CHANGED", function()
			if InteractionFrame.INT_ShoulderOffset and InteractionFrame.INT_ShoulderOffset:GetScript("OnUpdate") and not NS.Variables.Active then
				NS.Util:ForceStopSetShoulderOffset()
			end
		end)

		addon.Libraries.AceTimer:ScheduleTimer(function()
			local function Events()
				local Events = CreateFrame("Frame")
				Events:RegisterEvent("STOP_MOVIE")
				Events:RegisterEvent("CINEMATIC_STOP")
				if not addon.Variables.IS_CLASSIC then Events:RegisterEvent("PERKS_PROGRAM_CLOSE") end

				Events:SetScript("OnEvent", function()
					InteractionFrame.CinematicMode.Vignette:SetAlpha(0)
				end)
			end

			--------------------------------

			Events()
		end, addon.Variables.INIT_DELAY_LAST)
	end

	--------------------------------
	-- SETUP
	--------------------------------

	do
		addon.Libraries.AceTimer:ScheduleTimer(function()
			do -- PAN
				InteractionFrame.CinematicMode.PanHandler = CreateFrame("Frame")
				local Frame = InteractionFrame.CinematicMode.PanHandler

				--------------------------------

				Frame.ElapsedTime = 0
				Frame.PanSpeed = 0
				Frame.EasingDuration = 2

				--------------------------------

				Frame:SetScript("OnUpdate", function(self, elapsed)
					if NS.Variables.IsPanning then
						do -- EASING
							Frame.ElapsedTime = Frame.ElapsedTime + elapsed

							--------------------------------

							local easeFactor = 2 - math.min(Frame.ElapsedTime / Frame.EasingDuration, 1)
							local startValue = .015
							local targetValue = addon.Database.VAR_CINEMATIC_PAN_SPEED * easeFactor * 0.01
							local easeDuration = 2
							local easedValue = startValue + (targetValue - startValue) * (Frame.ElapsedTime / easeDuration)

							Frame.PanSpeed = easedValue

							if Frame.ElapsedTime >= easeDuration then
								Frame.PanSpeed = targetValue
							end
						end

						-- do -- FIXED
						-- 	Frame.PanSpeed = addon.Database.VAR_CINEMATIC_PAN_SPEED * .01
						-- end

						--------------------------------

						if not IsPlayerMoving() then
							if NS.Variables.IsPanning_Direction == "Left" then
								MoveViewLeftStart(Frame.PanSpeed)
							elseif NS.Variables.IsPanning_Direction == "Right" then
								MoveViewRightStart(Frame.PanSpeed)
							end
						else
							if NS.Variables.IsPanning_Direction ~= "" then
								NS.Variables.IsPanning_Direction = ""

								--------------------------------

								MoveViewLeftStop()
								MoveViewRightStop()
							end
						end
					end
				end)

				hooksecurefunc(Frame, "Show", function()

				end)

				hooksecurefunc(Frame, "Hide", function()
					-- Reset when panning view is false
					Frame.ElapsedTime = 0
					Frame.PanSpeed = 0

					--------------------------------

					if NS.Variables.IsPanning_Direction ~= "" then
						NS.Variables.IsPanning_Direction = ""

						--------------------------------

						MoveViewLeftStop()
						MoveViewRightStop()
					end
				end)
			end
		end, addon.Variables.INIT_DELAY_LAST)

		--------------------------------

		local _ = CreateFrame("Frame", "UpdateFrame/CinematicMode.lua", nil)
		_:SetScript("OnUpdate", function()
			if NS.Variables.Active then
				do -- OFFSET
					local Speed = .025
					local Target
					local Current = tonumber(GetCVar("test_cameraOverShoulder"))
					local Modifier = 1

					--------------------------------

					if IsMounted() then
						Modifier = INTDB.profile.INT_UIDIRECTION == 1 and .25 or 3.75
					elseif AdaptiveAPI:IsPlayerInShapeshiftForm() and not IsMounted() then
						Modifier = .5
					elseif IsIndoors() then
						Modifier = 1
					end

					--------------------------------

					if NS.Variables.IsHorizontalMode then
						Target = ((15 * GetCameraZoom() / 39) * Modifier)
					else
						Target = (addon.Database.VAR_CINEMATIC_ACTIONCAM_OFFSET_STRENGTH * GetCameraZoom() / 39 * Modifier)
					end

					if INTDB.profile.INT_UIDIRECTION == 1 then
						Target = -Target
					end

					--------------------------------

					if NS.Variables.IsHorizontalMode or addon.Database.VAR_CINEMATIC_ACTIONCAM_OFFSET then
						if not NS.Variables.IsTransition then
							local newStrength = Current + (Target - Current) * Speed
							SetCVar("test_cameraOverShoulder", newStrength)
						end
					end
				end
			end
		end)
	end
end
