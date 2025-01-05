local addonName, addon = ...
local CallbackRegistry = addon.CallbackRegistry
local L = addon.Locales

local AceDB = LibStub("AceDB-3.0")
local AceConfig = LibStub("AceConfig-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")
local AceConfigRegistry = LibStub("AceConfigRegistry-3.0")

--------------------------------
-- VARIABLES
--------------------------------

addon.Database = {}
local NS = addon.Database

do -- MAIN
	INTDB = nil
	INTLIB = nil
end

do -- CONSTANTS

end

--------------------------------
-- CINEMATIC
--------------------------------

do
	--------------------------------
	-- VARIABLES
	--------------------------------

	do -- CONSTANTS
		NS.VAR_CINEMATIC_ZOOM = nil
		NS.VAR_CINEMATIC_ZOOM_DISTANCE_MIN = nil
		NS.VAR_CINEMATIC_ZOOM_DISTANCE_MAX = nil
		NS.VAR_CINEMATIC_ZOOM_PITCH = nil
		NS.VAR_CINEMATIC_ZOOM_PITCH_LEVEL = nil
		NS.VAR_CINEMATIC_ZOOM_FOV = nil
		NS.VAR_CINEMATIC_PAN = nil
		NS.VAR_CINEMATIC_PAN_SPEED = nil
		NS.VAR_CINEMATIC_ACTIONCAM = nil
		NS.VAR_CINEMATIC_ACTIONCAM_SIDE = nil
		NS.VAR_CINEMATIC_ACTIONCAM_SIDE_STRENGTH = nil
		NS.VAR_CINEMATIC_ACTIONCAM_OFFSET = nil
		NS.VAR_CINEMATIC_ACTIONCAM_OFFSET_STRENGTH = nil
		NS.VAR_CINEMATIC_ACTIONCAM_FOCUS = nil
		NS.VAR_CINEMATIC_ACTIONCAM_FOCUS_STRENGTH = nil
		NS.VAR_CINEMATIC_ACTIONCAM_FOCUS_X = nil
		NS.VAR_CINEMATIC_ACTIONCAM_FOCUS_Y = nil
		NS.VAR_CINEMATIC_VIGNETTE = nil

		NS.CINEMATIC_PROFILE_FULL =
		{
			true, -- ZOOM
			0, -- ZOOM / MIN DISTANCE
			10, -- ZOOM / MAX DISTANCE
			false, -- ZOOM / PITCH
			10, -- ZOOM / PITCH / LEVEL
			true, -- ZOOM / FOV
			false, -- PAN
			.25, -- PAN / SPEED
			true, -- ACTIONCAM
			false, -- ACTIONCAM / SIDE VIEW
			.75, -- ACTIONCAM / SIDE VIEW / STRENGTH
			true, -- ACTIONCAM / OFFSET
			10, -- ACTIONCAM / OFFSET / STRENGTH
			true, -- ACTIONCAM / FOCUS
			1, -- ACTIONCAM / FOCUS / STRENGTH
			true, -- ACTIONCAM / FOCUS / X
			false, -- ACTIONCAM / FOCUS / Y
			true, -- VIGNETTE
		}

		NS.CINEMATIC_PROFILE_BALANCED =
		{
			false, -- ZOOM
			0, -- ZOOM / MIN DISTANCE
			10, -- ZOOM / MAX DISTANCE
			false, -- ZOOM / PITCH
			10, -- ZOOM / PITCH / LEVEL
			false, -- ZOOM / FOV
			false, -- PAN
			.25, -- PAN / SPEED
			true, -- ACTIONCAM
			false, -- ACTIONCAM / SIDE VIEW
			.75, -- ACTIONCAM / SIDE VIEW / STRENGTH
			true, -- ACTIONCAM / OFFSET
			10, -- ACTIONCAM / OFFSET / STRENGTH
			false, -- ACTIONCAM / FOCUS
			1, -- ACTIONCAM / FOCUS / STRENGTH
			false, -- ACTIONCAM / FOCUS / X
			false, -- ACTIONCAM / FOCUS / Y
			true, -- VIGNETTE
		}

		NS.CINEMATIC_PROFILES = {
			nil,                  -- NONE
			NS.CINEMATIC_PROFILE_FULL, -- FULL
			NS.CINEMATIC_PROFILE_BALANCED, -- BALANCED
			nil                   -- CUSTOM
		}
	end

	--------------------------------
	-- FUNCTIONS
	--------------------------------

	do
		function NS:SetToProfileCinematicVariables()
			local offset = 0

			local variables = {
				"VAR_CINEMATIC_ZOOM",
				"VAR_CINEMATIC_ZOOM_DISTANCE_MIN",
				"VAR_CINEMATIC_ZOOM_DISTANCE_MAX",
				"VAR_CINEMATIC_ZOOM_PITCH",
				"VAR_CINEMATIC_ZOOM_PITCH_LEVEL",
				"VAR_CINEMATIC_ZOOM_FOV",
				"VAR_CINEMATIC_PAN",
				"VAR_CINEMATIC_PAN_SPEED",
				"VAR_CINEMATIC_ACTIONCAM",
				"VAR_CINEMATIC_ACTIONCAM_SIDE",
				"VAR_CINEMATIC_ACTIONCAM_SIDE_STRENGTH",
				"VAR_CINEMATIC_ACTIONCAM_OFFSET",
				"VAR_CINEMATIC_ACTIONCAM_OFFSET_STRENGTH",
				"VAR_CINEMATIC_ACTIONCAM_FOCUS",
				"VAR_CINEMATIC_ACTIONCAM_FOCUS_STRENGTH",
				"VAR_CINEMATIC_ACTIONCAM_FOCUS_X",
				"VAR_CINEMATIC_ACTIONCAM_FOCUS_Y",
				"VAR_CINEMATIC_VIGNETTE"
			}

			local profile = {
				INTDB.profile.INT_CINEMATIC_ZOOM,
				INTDB.profile.INT_CINEMATIC_ZOOM_DISTANCE_MIN,
				INTDB.profile.INT_CINEMATIC_ZOOM_DISTANCE_MAX,
				INTDB.profile.INT_CINEMATIC_ZOOM_PITCH,
				INTDB.profile.INT_CINEMATIC_ZOOM_PITCH_LEVEL,
				INTDB.profile.INT_CINEMATIC_ZOOM_FOV,
				INTDB.profile.INT_CINEMATIC_PAN,
				INTDB.profile.INT_CINEMATIC_PAN_SPEED,
				INTDB.profile.INT_CINEMATIC_ACTIONCAM,
				INTDB.profile.INT_CINEMATIC_ACTIONCAM_SIDE,
				INTDB.profile.INT_CINEMATIC_ACTIONCAM_SIDE_STRENGTH,
				INTDB.profile.INT_CINEMATIC_ACTIONCAM_OFFSET,
				INTDB.profile.INT_CINEMATIC_ACTIONCAM_OFFSET_STRENGTH,
				INTDB.profile.INT_CINEMATIC_ACTIONCAM_FOCUS,
				INTDB.profile.INT_CINEMATIC_ACTIONCAM_FOCUS_STRENGTH,
				INTDB.profile.INT_CINEMATIC_ACTIONCAM_FOCUS_X,
				INTDB.profile.INT_CINEMATIC_ACTIONCAM_FOCUS_Y,
				INTDB.profile.INT_CINEMATIC_VIGNETTE
			}

			for i = 1, #variables do
				NS[variables[i]] = profile[i + offset]
			end
		end

		function NS:SetToPresetCinematicVariables(preset)
			local offset = 0

			local variables = {
				"VAR_CINEMATIC_ZOOM",
				"VAR_CINEMATIC_ZOOM_DISTANCE_MIN",
				"VAR_CINEMATIC_ZOOM_DISTANCE_MAX",
				"VAR_CINEMATIC_ZOOM_PITCH",
				"VAR_CINEMATIC_ZOOM_PITCH_LEVEL",
				"VAR_CINEMATIC_ZOOM_FOV",
				"VAR_CINEMATIC_PAN",
				"VAR_CINEMATIC_PAN_SPEED",
				"VAR_CINEMATIC_ACTIONCAM",
				"VAR_CINEMATIC_ACTIONCAM_SIDE",
				"VAR_CINEMATIC_ACTIONCAM_SIDE_STRENGTH",
				"VAR_CINEMATIC_ACTIONCAM_OFFSET",
				"VAR_CINEMATIC_ACTIONCAM_OFFSET_STRENGTH",
				"VAR_CINEMATIC_ACTIONCAM_FOCUS",
				"VAR_CINEMATIC_ACTIONCAM_FOCUS_STRENGTH",
				"VAR_CINEMATIC_ACTIONCAM_FOCUS_X",
				"VAR_CINEMATIC_ACTIONCAM_FOCUS_Y",
				"VAR_CINEMATIC_VIGNETTE"
			}

			for i = 1, #variables do
				NS[variables[i]] = preset[i + offset]
			end
		end

		function NS:SetDynamicCinematicVariables()
			-- 1 = NONE
			-- 2 = FULL
			-- 3 = BALANCED
			-- 4 = CUSTOM

			if addon.Cinematic and addon.Cinematic.Variables.Active then
				return
			end

			if INTDB.profile.INT_CINEMATIC_PRESET == 4 then
				INTDB.profile.INT_CINEMATIC = true

				NS:SetToProfileCinematicVariables()
			elseif INTDB.profile.INT_CINEMATIC_PRESET > 1 then
				INTDB.profile.INT_CINEMATIC = true

				NS:SetToPresetCinematicVariables(NS.CINEMATIC_PROFILES[INTDB.profile.INT_CINEMATIC_PRESET])
			else
				INTDB.profile.INT_CINEMATIC = false
			end
		end

		function NS:PreventSetVariableDuringCinematicMode(name, value)
			if addon.Interaction.Variables.Active or addon.Cinematic.Variables.Active then
				return
			end

			INTDB.profile[name] = value
		end
	end
end

--------------------------------
-- MAIN
--------------------------------

do
	--------------------------------
	-- VARIABLES
	--------------------------------

	local defaults = {
		profile = {
			-- SESSION
			LastLoadedSession = nil,

			-- VERSION
			LastLoadedVersion = nil,

			-- TUTORIAL
			TutorialSettingsShown = false,

			-- MINIMAP ICON
			LibDBIcon = {
				hide = false,
			},
			INT_MINIMAP = true,

			-- PLAYBACK
			INT_PLAYBACK_SPEED = 1,
			INT_PLAYBACK_AUTOPROGRESS = true,
			INT_PLAYBACK_AUTOPROGRESS_DELAY = 1,
			INT_PLAYBACK_AUTOPROGRESS_AUTOCLOSE = true,
			INT_PLAYBACK_PUNCTUATION_PAUSING = true,
			INT_ALWAYS_SHOW_QUEST = true,
			INT_ALWAYS_SHOW_GOSSIP = true,
			INT_TTS = false,
			INT_TTS_QUEST = true,
			INT_TTS_GOSSIP = true,
			INT_TTS_SPEED = 0,
			INT_TTS_VOLUME = 100,
			INT_TTS_VOICE = 1,
			INT_TTS_VOICE_01 = 1,
			INT_TTS_VOICE_02 = 1,
			INT_TTS_EMOTE_VOICE = 1,
			INT_TTS_PLAYER = false,
			INT_TTS_PLAYER_VOICE = 1,

			-- APPEARANCE
			INT_MAIN_THEME = 1,
			INT_DIALOG_THEME = 1,
			INT_UIDIRECTION = 2,
			INT_UIDIRECTION_DIALOG = 1,
			INT_UIDIRECTION_DIALOG_MIRROR = false,
			INT_PROGRESS_SHOW = true,
			INT_TITLE_ALPHA = 1,
			INT_CONTENT_PREVIEW_ALPHA = .5,
			INT_CONTENT_COLOR_CUSTOM = false,
			INT_CONTENT_COLOR = { r = 1, g = .87, b = .67 },

			INT_QUESTFRAME_SIZE = 3,
			INT_CONTENT_SIZE = 17.5,

			-- CONTROLS
			INT_CONTROLGUIDE = true,

			INT_USEINTERACTKEY = false,
			INT_FLIPMOUSE = false,

			INT_KEY_NEXT = "E",
			INT_KEY_PREVIOUS = "Q",
			INT_KEY_PROGRESS = "SPACE",
			INT_KEY_CLOSE = "ESCAPE",
			INT_KEY_PROMPT_ACCEPT = "",
			INT_KEY_PROMPT_DECLINE = "",

			-- EFFECTS
			INT_CINEMATIC = true,
			INT_CINEMATIC_PRESET = 2,
			INT_HIDEUI = true,

			INT_CINEMATIC_ZOOM = false,
			INT_CINEMATIC_ZOOM_DISTANCE_MIN = 0,
			INT_CINEMATIC_ZOOM_DISTANCE_MAX = 10,
			INT_CINEMATIC_ZOOM_PITCH = false,
			INT_CINEMATIC_ZOOM_PITCH_LEVEL = 10,
			INT_CINEMATIC_ZOOM_FOV = false,
			INT_CINEMATIC_PAN = false,
			INT_CINEMATIC_PAN_SPEED = .25,
			INT_CINEMATIC_ACTIONCAM = false,
			INT_CINEMATIC_ACTIONCAM_SIDE = false,
			INT_CINEMATIC_ACTIONCAM_SIDE_STRENGTH = .75,
			INT_CINEMATIC_ACTIONCAM_OFFSET = false,
			INT_CINEMATIC_ACTIONCAM_OFFSET_STRENGTH = 10,
			INT_CINEMATIC_ACTIONCAM_FOCUS = false,
			INT_CINEMATIC_ACTIONCAM_FOCUS_STRENGTH = 1,
			INT_CINEMATIC_ACTIONCAM_FOCUS_X = true,
			INT_CINEMATIC_ACTIONCAM_FOCUS_Y = false,
			INT_CINEMATIC_VIGNETTE = false,

			-- GAMEPLAY
			INT_AUTO_SELECT_OPTION = false,
			INT_MUTE_DIALOG = false,

			-- WAYPOINT
			INT_WAYPOINT = false,
			INT_WAYPOINT_AUDIO = true,

			-- READABLE
			INT_READABLE = true,
			INT_READABLE_CINEMATIC = true,
			INT_READABLE_ALWAYS_SHOW = false,

			INT_READABLE_AUDIOBOOK_RATE = 0,
			INT_READABLE_AUDIOBOOK_VOLUME = 100,
			INT_READABLE_AUDIOBOOK_VOICE = 1,

			-- PLATFORM
			INT_PLATFORM = 1,

			-- AUDIO
			INT_AUDIO = true,
		},
	}

	local defaults_library = {
		profile = {
			READABLE = {}
		}
	}

	--------------------------------
	-- INITIALIZE
	--------------------------------

	function NS:OnInitialize()
		INTDB = AceDB:New("InteractionDB", defaults, true)
		INTLIB = AceDB:New("InteractionLibraryDB", defaults_library, true)

		NS:SetDynamicCinematicVariables()
	end

	NS = LibStub("AceAddon-3.0"):NewAddon(NS, "Interaction")
end

--------------------------------
-- FUNCTIONS (MAIN)
--------------------------------

do
	function NS:CopyTable(original)
		if type(original) ~= "table" then
			return original
		end

		local copy = {}
		for k, v in pairs(original) do
			copy[copy(k)] = copy(v)
		end

		return copy
	end

	function NS:ResetSettings()
		INTDB = NS.CopyTable(defaults)
		InteractionDB = NS.CopyTable(defaults)
	end
end

--------------------------------
-- EVENTS
--------------------------------

do
	C_Timer.After(addon.Variables.INIT_DELAY_LAST, function()
		CallbackRegistry:Add("SETTING_CHANGED", function()
			NS:SetDynamicCinematicVariables()
		end)
	end)
end

--------------------------------
-- SLASH COMMANDS
--------------------------------

do
	SLASH_Interaction1, SLASH_Interaction2 = "/int", "/interaction"

	function SlashCmdList_AddSlashCommand(name, func, ...)
		SlashCmdList[name] = func

		local command = ""
		for i = 1, select("#", ...) do
			command = select(i, ...)

			if strsub(command, 1, 1) ~= "/" then
				command = "/" .. command
			end

			_G["SLASH_" .. name .. i] = command
		end
	end

	SlashCmdList_AddSlashCommand("INTERACTION_CONFIG", function(msg)
		Interaction_ShowSettingsUI()
	end, "interaction", "int")
end
