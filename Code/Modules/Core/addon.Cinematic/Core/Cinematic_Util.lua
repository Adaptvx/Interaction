---@class addon
local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local PrefabRegistry = addon.PrefabRegistry
local L = addon.Locales
local NS = addon.Cinematic; addon.Cinematic = NS

--------------------------------

NS.Util = {}

--------------------------------

local GetGlidingInfo = addon.Variables.IS_WOW_VERSION_CLASSIC_ALL and C_PlayerInfo.GetGlidingInfo or nil

--------------------------------

function NS.Util:Load()
	--------------------------------
	-- FUNCTIONS
	--------------------------------

	do -- ZOOM
		function NS.Util:SetCameraZoom(level, allowZoomOut)
			local Current = GetCameraZoom()
			local Delta = Current - level

			--------------------------------

			if (Delta > -.1 and Delta < .1) then
				return
			end

			--------------------------------

			if Delta > 0 then
				CameraZoomIn(Delta)
			elseif allowZoomOut then
				CameraZoomOut(-Delta)
			end
		end
	end

	do -- PITCH
		function NS.Util:SetCameraPitch(level, duration)
			if not InteractionFrame.INT_CameraPitch then
				InteractionFrame.INT_CameraPitch = CreateFrame("Frame")
			end

			--------------------------------

			local Start = GetTime()

			--------------------------------

			InteractionFrame.INT_CameraPitch:SetScript("OnUpdate", function()
				local Current = GetTime() - Start
				local Pitch = addon.API.Animation.EaseOutSine(Current, 88, level, duration)

				if Current >= duration then
					ConsoleExec("pitchlimit " .. level)
					Pitch = 88

					InteractionFrame.INT_CameraPitch:SetScript("OnUpdate", nil)
				end

				ConsoleExec("pitchlimit " .. Pitch)
			end)
		end

		function NS.Util:StopCameraPitch()
			if InteractionFrame.INT_CameraPitch then
				InteractionFrame.INT_CameraPitch:SetScript("OnUpdate", nil)

				ConsoleExec("pitchlimit 88")
			end
		end
	end

	do -- YAW
		function NS.Util:SetCameraYaw(duration, direction)
			if not InteractionFrame.INT_CameraYaw then
				InteractionFrame.INT_CameraYaw = CreateFrame("Frame")
			end

			--------------------------------

			local Start = GetTime()

			--------------------------------

			InteractionFrame.INT_CameraYaw:SetScript("OnUpdate", function()
				local Current = GetTime() - Start
				local Yaw = addon.API.Animation.EaseInOutSine(Current, 0, duration / 6, duration)

				--------------------------------

				if direction == "LEFT" then
					MoveViewLeftStart(Yaw)
				else
					MoveViewRightStart(Yaw)
				end

				--------------------------------

				if Current >= duration * 2 then
					MoveViewRightStop()
					MoveViewLeftStop()

					--------------------------------

					InteractionFrame.INT_CameraYaw:SetScript("OnUpdate", nil)
				end
			end)
		end

		function NS.Util:StopCameraYaw()
			if InteractionFrame.INT_CameraYaw then
				InteractionFrame.INT_CameraYaw:SetScript("OnUpdate", nil)

				MoveViewRightStop()
				MoveViewLeftStop()
			end
		end
	end

	do -- FOV
		function NS.Util:SetCameraFieldOfView(level, duration)
			local IsSkyriding = GetGlidingInfo and select(1, GetGlidingInfo()) or false

			--------------------------------

			if IsSkyriding then
				SetCVar("cameraFov", 90)
				return
			end

			--------------------------------

			if not InteractionFrame.INT_CameraFieldOfView then
				InteractionFrame.INT_CameraFieldOfView = CreateFrame("Frame")
			end

			--------------------------------

			local Start = GetTime()

			--------------------------------

			InteractionFrame.INT_CameraFieldOfView:SetScript("OnUpdate", function()
				local Current = GetTime() - Start
				local StartFov = tonumber(GetCVar("cameraFov"))
				local New = addon.API.Animation.EaseOutSine(Current, StartFov, level, duration)

				--------------------------------

				if Current >= duration then
					SetCVar("cameraFov", New)

					--------------------------------

					InteractionFrame.INT_CameraFieldOfView:SetScript("OnUpdate", nil)
				end

				--------------------------------

				SetCVar("cameraFov", New)
			end)
		end

		function NS.Util:StopCameraFieldOfView()
			if InteractionFrame.INT_CameraFieldOfView then
				InteractionFrame.INT_CameraFieldOfView:SetScript("OnUpdate", nil)

				NS.Util:SetCameraFieldOfView(90, 2)
			end
		end

		function NS.Util.ForceStopCameraFieldOfView()
			if InteractionFrame.INT_CameraFieldOfView then
				InteractionFrame.INT_CameraFieldOfView:SetScript("OnUpdate", nil)
			end

			SetCVar("cameraFov", 90)
		end
	end

	do -- OFFSET
		function NS.Util:SetShoulderOffset(level, duration, customStartOffset)
			if not InteractionFrame.INT_ShoulderOffset then
				InteractionFrame.INT_ShoulderOffset = CreateFrame("Frame")
			end

			--------------------------------

			local Start = GetTime()

			--------------------------------

			InteractionFrame.INT_ShoulderOffset:SetScript("OnUpdate", function()
				local Current = GetTime() - Start
				local StartOffset = customStartOffset or tonumber(NS.Variables.Saved_ShoulderOffset)
				local EndOffset = level - StartOffset

				local Offset
				if StartOffset < level then
					if addon.Database.DB_GLOBAL.profile.INT_UIDIRECTION == 1 then
						Offset = addon.API.Animation.EaseOutExpo(Current, 0, EndOffset, duration) + StartOffset
					else
						Offset = addon.API.Animation.EaseExpo(Current, 0, EndOffset, duration) + StartOffset
					end
				elseif StartOffset > level then
					Offset = addon.API.Animation.EaseOutExpo(Current, 0, EndOffset, duration) + StartOffset
				else
					Offset = addon.API.Animation.EaseExpo(Current, 0, EndOffset, duration) + StartOffset
				end

				--------------------------------

				if Current >= duration then
					SetCVar("test_cameraOverShoulder", level)

					--------------------------------

					InteractionFrame.INT_ShoulderOffset:SetScript("OnUpdate", nil)

					--------------------------------

					return
				end

				--------------------------------

				SetCVar("test_cameraOverShoulder", Offset)
			end)
		end

		function NS.Util:StopSetShoulderOffset()
			if InteractionFrame.INT_ShoulderOffset then
				InteractionFrame.INT_ShoulderOffset:SetScript("OnUpdate", nil)

				--------------------------------

				local duration = 2
				local currentOffset = GetCVar("test_cameraOverShoulder")
				local targetOffset = NS.Variables.Saved_ShoulderOffset

				NS.Util:SetShoulderOffset(targetOffset, duration, currentOffset) -- SetCVar("test_cameraOverShoulder", NS.Variables.Saved_ShoulderOffset)
			end
		end

		function NS.Util:ForceStopSetShoulderOffset()
			if InteractionFrame.INT_ShoulderOffset then
				InteractionFrame.INT_ShoulderOffset:SetScript("OnUpdate", nil)

				--------------------------------

				SetCVar("test_cameraOverShoulder", NS.Variables.Saved_ShoulderOffset)
			end
		end
	end

	do -- FOCUS
		function NS.Util:SetFocusInteractStrength(level, duration, limitX, limitY)
			if not InteractionFrame.INT_FocusInteract then
				InteractionFrame.INT_FocusInteract = CreateFrame("Frame")
			end

			--------------------------------

			local Start = GetTime()

			--------------------------------

			InteractionFrame.INT_FocusInteract:SetScript("OnUpdate", function()
				local Current = GetTime() - Start
				local Offset = addon.API.Animation.EaseOutSine(Current, 0, level, duration)

				--------------------------------

				if Current >= duration then
					-- SET LIMITED AXIS TO 0
					if limitX and not limitY then
						SetCVar("test_cameraTargetFocusInteractStrengthYaw", 0)
					end
					if not limitX and limitY then
						SetCVar("test_cameraTargetFocusInteractStrengthPitch", 0)
					end

					-- SET AXIS VALUES
					if limitX or limitX == nil then
						SetCVar("test_cameraTargetFocusInteractStrengthPitch", level)
					end
					if limitY or limitY == nil then
						SetCVar("test_cameraTargetFocusInteractStrengthYaw", level)
					end

					--------------------------------

					InteractionFrame.INT_FocusInteract:SetScript("OnUpdate", nil)
				end

				--------------------------------

				-- SET LIMITED AXIS TO 0
				if limitX and not limitY then
					SetCVar("test_cameraTargetFocusInteractStrengthYaw", 0)
				end
				if not limitX and limitY then
					SetCVar("test_cameraTargetFocusInteractStrengthPitch", 0)
				end

				-- SET AXIS VALUES
				if limitX or limitX == nil then
					SetCVar("test_cameraTargetFocusInteractStrengthPitch", Offset)
				end
				if limitY or limitY == nil then
					SetCVar("test_cameraTargetFocusInteractStrengthYaw", Offset)
				end
			end)
		end

		function NS.Util:StopFocusInteractStrength()
			if InteractionFrame.INT_FocusInteract then
				InteractionFrame.INT_FocusInteract:SetScript("OnUpdate", nil)
				SetCVar("test_cameraTargetFocusInteractStrengthPitch", addon.ConsoleVariables.Variables.Saved_CameraTargetFocusInteractStrengthPitch)
				SetCVar("test_cameraTargetFocusInteractStrengthYaw", addon.ConsoleVariables.Variables.Saved_CameraTargetFocusInteractStrengthYaw)
			end
		end
	end

	--------------------------------
	-- EVENTS
	--------------------------------

	local _ = CreateFrame("Frame", "UpdateFrame/View.lua -- SetCameraFieldOfView", nil)
	_:SetScript("OnUpdate", function()
		local isSkyriding = GetGlidingInfo and select(1, GetGlidingInfo()) or false
		local isFieldOfViewActive = (InteractionFrame.INT_CameraFieldOfView and InteractionFrame.INT_CameraFieldOfView:GetScript("OnUpdate") ~= nil)

		--------------------------------

		if isSkyriding and isFieldOfViewActive then
			NS.Util:ForceStopCameraFieldOfView()
		end
	end)
end
