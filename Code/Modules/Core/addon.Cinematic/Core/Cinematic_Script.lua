---@class addon
local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local PrefabRegistry = addon.PrefabRegistry
local L = addon.Locales
local NS = addon.Cinematic; addon.Cinematic = NS

--------------------------------

NS.Script = {}

--------------------------------

local GetGlidingInfo = not addon.Variables.IS_WOW_VERSION_CLASSIC_ALL and C_PlayerInfo.GetGlidingInfo or nil

--------------------------------

function NS.Script:Load()
	--------------------------------
	-- FUNCTIONS
	--------------------------------

	do
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
					local isPan = (addon.Database.VAR_CINEMATIC_PAN)
					local isActionCamSide = (addon.Database.VAR_CINEMATIC_ACTIONCAM_SIDE)

					--------------------------------

					if (addon.Input.Variables.IsPC) and (isPan or isActionCamSide) then
						SaveView(3)
					end

					--------------------------------

					NS.Variables.Saved_Zoom = GetCameraZoom()
				end

				function NS.Script:ResetView()
					local isPan = (addon.Database.VAR_CINEMATIC_PAN)
					local isActionCamSide = (addon.Database.VAR_CINEMATIC_ACTIONCAM_SIDE)

					--------------------------------

					if (addon.Input.Variables.IsPC) and (isPan or isActionCamSide) then
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

					if addon.Database.DB_GLOBAL.profile.INT_UIDIRECTION == 1 then
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
					if addon.Database.DB_GLOBAL.profile.INT_UIDIRECTION == 1 then
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
					local strength
					local modifier = 1

					--------------------------------

					local isIndoors = IsIndoors()
					local isMounted = IsMounted()
					local isShapeshiftForm = addon.API.Util:IsPlayerInShapeshiftForm()

					if isMounted then
						modifier = addon.Database.DB_GLOBAL.profile.INT_UIDIRECTION == 1 and .25 or 3.75
					elseif isShapeshiftForm and not isMounted then
						modifier = .5
					elseif isIndoors then
						modifier = 1
					end

					--------------------------------

					local current = GetCameraZoom()
					local target
					local valid
					if addon.Database.VAR_CINEMATIC_ZOOM_DISTANCE_MIN and current < addon.Database.VAR_CINEMATIC_ZOOM_DISTANCE_MIN then
						valid = true
						target = (addon.Database.VAR_CINEMATIC_ZOOM_DISTANCE_MIN / 39)
					elseif addon.Database.VAR_CINEMATIC_ZOOM_DISTANCE_MAX and current > addon.Database.VAR_CINEMATIC_ZOOM_DISTANCE_MAX then
						valid = true
						target = (addon.Database.VAR_CINEMATIC_ZOOM_DISTANCE_MAX / 39)
					else
						valid = false
						target = (current / 39)
					end

					if (IsAutoZoom) and (valid) then
						strength = (OffsetStrength * (target) * modifier)
					else
						strength = (OffsetStrength * (current / 39) * modifier)
					end

					--------------------------------

					-- Force stop shoulder offset reset animation,
					if InteractionFrame.INT_ShoulderOffset and InteractionFrame.INT_ShoulderOffset:GetScript("OnUpdate") then
						NS.Util:ForceStopSetShoulderOffset()
					end

					-- Start new shoulder offset animation,
					addon.Libraries.AceTimer:ScheduleTimer(function()
						NS.Variables.Saved_ShoulderOffset = GetCVar("test_cameraOverShoulder")

						--------------------------------

						if addon.Database.DB_GLOBAL.profile.INT_UIDIRECTION == 1 then
							NS.Util:SetShoulderOffset(-strength, 2.5)
						else
							NS.Util:SetShoulderOffset(strength, 2.5)
						end
					end, 0)
				end

				function NS.Script:CancelOffset()
					NS.Util:StopSetShoulderOffset()
				end
			end

			do -- VIGNETTE
				function NS.Script:StartCinematicVignette()
					InteractionFrame.CinematicMode.Vignette:ShowWithAnimation()
				end

				function NS.Script:StopCinematicVignette()
					InteractionFrame.CinematicMode.Vignette:HideWithAnimation()
				end
			end
		end

		do -- MAIN
			function NS.Script:StartCinematicMode(bypass, horizontalMode)
				if InCombatLockdown() then
					return
				end

				--------------------------------

				local interactionActive = addon.Interaction.Variables.Active
				local interactionLastActive = addon.Interaction.Variables.LastActive
				local cinematicModeActive = NS.Variables.Active

				--------------------------------

				if (not cinematicModeActive and bypass) or (not cinematicModeActive and interactionActive and not interactionLastActive) then
					NS.Variables.Active = true
					NS.Variables.IsHorizontalMode = horizontalMode

					local isCinematicMode = not NS.Variables.IsHorizontalMode
					local isHorizontalMode = NS.Variables.IsHorizontalMode

					local isPan = (addon.Database.VAR_CINEMATIC_PAN)
					local isZoom = (addon.Database.VAR_CINEMATIC_ZOOM)
					local isPitch = (addon.Database.VAR_CINEMATIC_ZOOM_PITCH)
					local isFOV = (addon.Database.VAR_CINEMATIC_ZOOM_FOV)
					local isActionCam = (addon.Database.VAR_CINEMATIC_ACTIONCAM)
					local isActionCamSide = (addon.Database.VAR_CINEMATIC_ACTIONCAM_SIDE)
					local isActionCamOffset = (addon.Database.VAR_CINEMATIC_ACTIONCAM_OFFSET)
					local isActionCamFocus = (addon.Database.VAR_CINEMATIC_ACTIONCAM_FOCUS)
					local isActionCamFocusX = (addon.Database.VAR_CINEMATIC_ACTIONCAM_FOCUS_X)
					local isActionCamFocusY = (addon.Database.VAR_CINEMATIC_ACTIONCAM_FOCUS_Y)
					local isVignette = (addon.Database.VAR_CINEMATIC_VIGNETTE)

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

					if isCinematicMode then
						if isZoom then
							NS.Script:StartZoom()

							--------------------------------

							if isPitch then
								NS.Script:StartPitch()
							end

							--------------------------------

							if isFOV then
								NS.Script:StartFOV()
							end
						end
					end

					--------------------------------
					-- PAN
					--------------------------------

					if isCinematicMode then
						if isActionCam and isActionCamSide then
							local SideViewDuration = (addon.Database.VAR_CINEMATIC_ACTIONCAM_SIDE_STRENGTH * 2)

							--------------------------------

							NS.Script:StartSideView()

							--------------------------------

							addon.Libraries.AceTimer:ScheduleTimer(function()
								if NS.Variables.Active then
									NS.Script:CancelSideView()

									--------------------------------

									if isPan then
										NS.Script:StartPan()
									end
								end
							end, SideViewDuration - .25)
						else
							if isPan then
								NS.Script:StartPan()
							end
						end
					end

					--------------------------------
					-- ACTIONCAM
					--------------------------------

					if isHorizontalMode or isActionCam then
						if isHorizontalMode then
							NS.Script:StartOffset(false, 15)
						end

						if isCinematicMode then
							if isActionCamFocus then
								NS.Script:StartFocus(addon.Database.VAR_CINEMATIC_ACTIONCAM_FOCUS_STRENGTH, isActionCamFocusX, isActionCamFocusY)
							end

							if isActionCamOffset then
								NS.Script:StartOffset(isZoom, addon.Database.VAR_CINEMATIC_ACTIONCAM_OFFSET_STRENGTH)
							end

							if isActionCamSide then
								NS.Script:StartSideView()
							end
						end
					end

					--------------------------------
					-- VIGNETTE
					--------------------------------

					if isCinematicMode then
						if isVignette then
							NS.Script:StartCinematicVignette()
						end
					end
				end

				--------------------------------

				CallbackRegistry:Trigger("START_CINEMATIC_MODE")
			end

			function NS.Script:CancelCinematicMode(bypass)
				local interactionActive = addon.Interaction.Variables.Active
				local interactionLastActive = addon.Interaction.Variables.LastActive
				local cinematicModeActive = NS.Variables.Active

				--------------------------------

				if (cinematicModeActive and bypass) or (not interactionActive and interactionLastActive and cinematicModeActive) then
					NS.Variables.Active = false

					local isCinematicMode = not NS.Variables.IsHorizontalMode
					local isHorizontalMode = NS.Variables.IsHorizontalMode

					local isPan = (addon.Database.VAR_CINEMATIC_PAN)
					local isZoom = (addon.Database.VAR_CINEMATIC_ZOOM)
					local isPitch = (addon.Database.VAR_CINEMATIC_ZOOM_PITCH)
					local isFOV = (addon.Database.VAR_CINEMATIC_ZOOM_FOV)
					local isActionCam = (addon.Database.VAR_CINEMATIC_ACTIONCAM)
					local isActionCamSide = (addon.Database.VAR_CINEMATIC_ACTIONCAM_SIDE)
					local isActionCamOffset = (addon.Database.VAR_CINEMATIC_ACTIONCAM_OFFSET)
					local isActionCamFocus = (addon.Database.VAR_CINEMATIC_ACTIONCAM_FOCUS)
					local isVignette = (addon.Database.VAR_CINEMATIC_VIGNETTE)

					--------------------------------
					-- RESET STATE
					--------------------------------

					if isCinematicMode then
						local InCombat = (InCombatLockdown())

						if not InCombat and (isPan or isZoom or (isActionCam and isActionCamSide)) then
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

					if isCinematicMode then
						if isZoom then
							NS.Script:CancelZoom()

							--------------------------------

							if isPitch then
								NS.Script:CancelPitch()
							end

							--------------------------------

							if isFOV then
								NS.Script:CancelFOV()
							end
						end
					end

					--------------------------------
					-- PAN
					--------------------------------

					if isCinematicMode then
						NS.Script:CancelPan()
					end

					--------------------------------
					-- ACTIONCAM
					--------------------------------

					if isHorizontalMode or isActionCam then
						if isCinematicMode then
							if isActionCamFocus then
								NS.Script:CancelFocus()
							end

							if isActionCamOffset then
								NS.Script:CancelOffset()
							end

							if isActionCamSide then
								NS.Script:CancelSideView()
							end
						else
							NS.Script:CancelOffset()
						end
					end

					--------------------------------
					-- VIGNETTE
					--------------------------------

					if isCinematicMode then
						if isVignette then
							NS.Script:StopCinematicVignette()
						end
					end
				end

				--------------------------------

				CallbackRegistry:Trigger("STOP_CINEMATIC_MODE")
			end
		end

		do -- ANIMATION
			do -- SHOW
				function InteractionFrame.CinematicMode.Vignette:ShowWithAnimation_StopEvent()

				end

				function InteractionFrame.CinematicMode.Vignette:ShowWithAnimation()
					addon.API.Animation:Fade(InteractionFrame.CinematicMode.Vignette, .5, InteractionFrame.CinematicMode.Vignette:GetAlpha(), 1)
				end
			end

			do -- HIDE
				function InteractionFrame.CinematicMode.Vignette:HideWithAnimation_StopEvent()

				end

				function InteractionFrame.CinematicMode.Vignette:HideWithAnimation()
					addon.API.Animation:Fade(InteractionFrame.CinematicMode.Vignette, .25, InteractionFrame.CinematicMode.Vignette:GetAlpha(), 0)
				end
			end
		end
	end

	--------------------------------
	-- CALLBACKS
	--------------------------------

	do
		do -- INTERACTION
			function NS.Script:StartInteraction()
				if not addon.Database.DB_GLOBAL.profile.INT_CINEMATIC then
					return
				end

				--------------------------------

				local interactTargetIsSelf = ((UnitName("npc") == UnitName("player")) or UnitName("questnpc") == UnitName("player"))
				local isStaticNPC = ((UnitName("npc") and not UnitExists("npc")) or (UnitName("questnpc") and not UnitExists("questnpc")))
				local inInstance = (IsInInstance())
				local isSkyriding = GetGlidingInfo and select(1, GetGlidingInfo()) or false

				if interactTargetIsSelf or isStaticNPC or inInstance or isSkyriding then
					return
				end

				--------------------------------

				NS.Script:StartCinematicMode()
			end

			function NS.Script:StopInteraction(bypass)
				if not addon.Database.DB_GLOBAL.profile.INT_CINEMATIC then
					return
				end

				--------------------------------

				local interactTargetIsSelf = ((UnitName("npc") == UnitName("player")) or UnitName("questnpc") == UnitName("player"))
				local isStaticNPC = ((UnitName("npc") and not UnitExists("npc")) or (UnitName("questnpc") and not UnitExists("questnpc")))
				local inInstance = (IsInInstance())

				if (interactTargetIsSelf or isStaticNPC or inInstance) and not NS.Variables.Active then
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
			do -- EVENTS
				local Events = CreateFrame("Frame")
				Events:RegisterEvent("STOP_MOVIE")
				Events:RegisterEvent("CINEMATIC_STOP")
				if not addon.Variables.IS_WOW_VERSION_CLASSIC_ALL then Events:RegisterEvent("PERKS_PROGRAM_CLOSE") end

				Events:SetScript("OnEvent", function()
					InteractionFrame.CinematicMode.Vignette:SetAlpha(0)
				end)
			end
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
					local speed = .025
					local target
					local current = tonumber(GetCVar("test_cameraOverShoulder"))
					local modifier = 1

					--------------------------------

					local isIndoors = IsIndoors()
					local isMounted = IsMounted()
					local isShapeshiftForm = addon.API.Util:IsPlayerInShapeshiftForm()

					if isMounted then
						modifier = addon.Database.DB_GLOBAL.profile.INT_UIDIRECTION == 1 and .25 or 3.75
					elseif isShapeshiftForm and not isMounted then
						modifier = .5
					elseif isIndoors then
						modifier = 1
					end

					--------------------------------

					if NS.Variables.IsHorizontalMode then
						target = ((15 * GetCameraZoom() / 39) * modifier)
					else
						target = (addon.Database.VAR_CINEMATIC_ACTIONCAM_OFFSET_STRENGTH * GetCameraZoom() / 39 * modifier)
					end

					if addon.Database.DB_GLOBAL.profile.INT_UIDIRECTION == 1 then
						target = -target
					end

					--------------------------------

					if NS.Variables.IsHorizontalMode or addon.Database.VAR_CINEMATIC_ACTIONCAM_OFFSET then
						if not NS.Variables.IsTransition then
							local newStrength = current + (target - current) * speed
							SetCVar("test_cameraOverShoulder", newStrength)
						end
					end
				end
			end
		end)
	end
end
