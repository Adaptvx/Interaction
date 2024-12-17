local addonName, addon = ...
local CallbackRegistry = addon.CallbackRegistry
local L = addon.Locales
local NS = addon.Cinematic

--------------------------------

NS.Variables = {}

--------------------------------
-- VARIABLES
--------------------------------

do
	NS.Variables.Active = false
	NS.Variables.ActiveID = nil
	NS.Variables.IsHorizontalMode = false

	NS.Variables.IsTransition = false
	NS.Variables.IsPanning = nil
	NS.Variables.IsPanning_Direction = "Left"
	NS.Variables.IsZooming = false
	NS.Variables.Saved_Zoom = GetCameraZoom()

	NS.Variables.Saved_ShoulderOffset = GetCVar("test_cameraOverShoulder")
	NS.Variables.Saved_FocusInteractStrengthPitch = GetCVar("test_cameraTargetFocusInteractStrengthPitch")
	NS.Variables.Saved_FocusInteractionStrengthYaw = GetCVar("test_cameraTargetFocusEnemyStrengthYaw")
end

--------------------------------
-- EVENTS
--------------------------------
