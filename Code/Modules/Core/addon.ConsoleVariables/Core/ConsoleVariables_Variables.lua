---@class addon
local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local PrefabRegistry = addon.PrefabRegistry
local L = addon.Locales
local NS = addon.ConsoleVariables; addon.ConsoleVariables = NS

--------------------------------

NS.Variables = {}

--------------------------------
-- VARIABLES
--------------------------------

do -- MAIN
	NS.Variables.Initalized = false

	NS.Variables.Saved_cameraSmoothStyle = nil
	NS.Variables.Saved_cameraTargetFocusInteractEnable = nil
	NS.Variables.Saved_Sound_DialogVolume = nil

	NS.Variables.CVars_General_Saved = {}
	NS.Variables.CVars_Cinematic_Saved = {}
end

do -- CONSTANTS
	NS.Variables.CVARS_GENERAL = {
		NameplateShowFriendlyNPCs = 1,
		NameplateShowFriends = 1,
		NameplateShowAll = 1,
		UnitNameNPC = 0,
		UnitNameFriendlyPlayerName = 0,
		UnitNameEnemyPlayerName = 0,
		ClampTargetNameplateToScreen = 0,
		NameplateOtherTopInset = -1,
		NameplateOtherBottomInset = -1,
		NameplateMotion = 0,
		InstantQuestText = 1,
	}

	NS.Variables.CVARS_CINEMATIC = {
		CameraKeepCharacterCentered = 0,
		CameraReduceUnexpectedMovement = 0,
	}
end

--------------------------------
-- EVENTS
--------------------------------
