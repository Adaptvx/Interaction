local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local AceDB = LibStub("AceDB-3.0")

addon.Database = {}
local NS = addon.Database; addon.Database = NS

NS.DB_GLOBAL = nil
NS.DB_GLOBAL_PERSISTENT = nil
NS.DB_LOCAL_PERSISTENT = nil

NS.DEFAULTS_GLOBAL = {
    profile = {
        LastLoadedSession                       = nil,
        LastLoadedVersion                       = nil,
        TutorialSettingsShown                   = false,
        LibDBIcon                               = {
            hide = false
        },
        INT_MINIMAP                             = true,
        INT_TIME_DAY                            = 7,
        INT_TIME_NIGHT                          = 22,
        INT_PLAYBACK_SPEED                      = 1,
        INT_PLAYBACK_AUTOPROGRESS               = true,
        INT_PLAYBACK_AUTOPROGRESS_DELAY         = 1,
        INT_PLAYBACK_PUNCTUATION_PAUSING        = true,
        INT_ALWAYS_SHOW_QUEST                   = true,
        INT_ALWAYS_SHOW_GOSSIP                  = true,
        INT_TTS                                 = false,
        INT_TTS_QUEST                           = true,
        INT_TTS_GOSSIP                          = true,
        INT_TTS_SPEED                           = 0,
        INT_TTS_VOLUME                          = 100,
        INT_TTS_VOICE                           = 1,
        INT_TTS_VOICE_01                        = 1,
        INT_TTS_VOICE_02                        = 1,
        INT_TTS_EMOTE_VOICE                     = 1,
        INT_TTS_PLAYER                          = false,
        INT_TTS_PLAYER_VOICE                    = 1,
        INT_TTS_DUCK_AUDIO                      = false,
        INT_TTS_DUCK_AUDIO_LEVEL                = 50,
        INT_PLAYBACK_AUTOCLOSE                  = true,
        INT_MUTE_DIALOG                         = false,
        INT_MAIN_THEME                          = 1,
        INT_DIALOG_THEME                        = 1,
        INT_UIDIRECTION                         = 1,
        INT_UIDIRECTION_DIALOG                  = 1,
        INT_UIDIRECTION_DIALOG_MIRROR           = false,
        INT_PROGRESS_SHOW                       = true,
        INT_DIALOG_SPLIT_PARAGRAPHS             = false,
        INT_TITLE_ALPHA                         = 1,
        INT_CONTENT_PREVIEW_ALPHA               = .5,
        INT_QUESTFRAME_SIZE                     = 2,
        INT_CONTENT_SIZE                        = 17.5,
        INT_CONTROLGUIDE                        = true,
        INT_USEINTERACTKEY                      = false,
        INT_FLIPMOUSE                           = false,
        INT_KEY_NEXT                            = "E",
        INT_KEY_PREVIOUS                        = "Q",
        INT_KEY_PROGRESS                        = "SPACE",
        INT_KEY_CLOSE                           = "ESCAPE",
        INT_KEY_PROMPT_ACCEPT                   = "",
        INT_KEY_PROMPT_DECLINE                  = "",
        INT_KEY_QUEST_NEXTREWARD                = "TAB",
        INT_CINEMATIC                           = true,
        INT_CINEMATIC_PRESET                    = 2,
        INT_HIDEUI                              = true,
        INT_CINEMATIC_ZOOM                      = false,
        INT_CINEMATIC_ZOOM_DISTANCE_MIN         = 0,
        INT_CINEMATIC_ZOOM_DISTANCE_MAX         = 10,
        INT_CINEMATIC_ZOOM_PITCH                = false,
        INT_CINEMATIC_ZOOM_PITCH_LEVEL          = 10,
        INT_CINEMATIC_ZOOM_FOV                  = false,
        INT_CINEMATIC_PAN                       = false,
        INT_CINEMATIC_PAN_SPEED                 = .25,
        INT_CINEMATIC_ACTIONCAM                 = false,
        INT_CINEMATIC_ACTIONCAM_SIDE            = false,
        INT_CINEMATIC_ACTIONCAM_SIDE_STRENGTH   = .75,
        INT_CINEMATIC_ACTIONCAM_OFFSET          = false,
        INT_CINEMATIC_ACTIONCAM_OFFSET_STRENGTH = 10,
        INT_CINEMATIC_ACTIONCAM_FOCUS           = false,
        INT_CINEMATIC_ACTIONCAM_FOCUS_STRENGTH  = 1,
        INT_CINEMATIC_ACTIONCAM_FOCUS_X         = true,
        INT_CINEMATIC_ACTIONCAM_FOCUS_Y         = false,
        INT_CINEMATIC_VIGNETTE                  = false,
        INT_CINEMATIC_VIGNETTE_GRADIENT         = false,
        INT_AUTO_SELECT_OPTION                  = false,
        INT_READABLE                            = true,
        INT_READABLE_CINEMATIC                  = true,
        INT_READABLE_ALWAYS_SHOW                = false,
        INT_READABLE_AUDIOBOOK_RATE             = 0,
        INT_READABLE_AUDIOBOOK_VOLUME           = 100,
        INT_READABLE_AUDIOBOOK_VOICE            = 1,
        INT_READABLE_AUDIOBOOK_VOICE_SPECIAL    = 1,
        INT_PLATFORM                            = 1,
        INT_AUDIO                               = true,
        INT_BLIZZARD_TOOLTIP                    = false,
        INT_DISABLE_IN_INSTANCES                = false
    }
}

NS.DEFAULTS_GLOBAL_PERSISTENT = {
    profile = {
        READABLE = {}
    }
}

NS.DEFAULTS_LOCAL_PERSISTENT = {
    profile = {
        READABLE = {}
    }
}

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
NS.VAR_CINEMATIC_VIGNETTE_GRADIENT = nil

NS.CINEMATIC_PROFILE_FULL =
{
    true, -- Zoom
    0, -- Zoom / min distance
    10, -- Zoom / max distance
    false, -- Zoom / pitch
    10, -- Zoom / pitch / level
    true, -- Zoom / fov
    false, -- Pan
    .25, -- Pan / speed
    true, -- Actioncam
    false, -- Actioncam / side view
    .75, -- Actioncam / side view / strength
    true, -- Actioncam / offset
    10, -- Actioncam / offset / strength
    true, -- Actioncam / focus
    1, -- Actioncam / focus / strength
    true, -- Actioncam / focus / x
    false, -- Actioncam / focus / y
    true, -- Vignette
    true -- Vignette / gradient
}

NS.CINEMATIC_PROFILE_BALANCED =
{
    false, -- Zoom
    0, -- Zoom / min distance
    10, -- Zoom / max distance
    false, -- Zoom / pitch
    10, -- Zoom / pitch / level
    false, -- Zoom / fov
    false, -- Pan
    .25, -- Pan / speed
    true, -- Actioncam
    false, -- Actioncam / side view
    .75, -- Actioncam / side view / strength
    true, -- Actioncam / offset
    10, -- Actioncam / offset / strength
    false, -- Actioncam / focus
    1, -- Actioncam / focus / strength
    false, -- Actioncam / focus / x
    false, -- Actioncam / focus / y
    true, -- Vignette
    true -- Vignette / gradient
}

NS.CINEMATIC_PROFILES = {
    nil, -- None
    NS.CINEMATIC_PROFILE_FULL, -- Full
    NS.CINEMATIC_PROFILE_BALANCED, -- Balanced
    nil -- Custom
}

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
        "VAR_CINEMATIC_VIGNETTE",
        "VAR_CINEMATIC_VIGNETTE_GRADIENT"
    }

    local profile = {
        NS.DB_GLOBAL.profile.INT_CINEMATIC_ZOOM,
        NS.DB_GLOBAL.profile.INT_CINEMATIC_ZOOM_DISTANCE_MIN,
        NS.DB_GLOBAL.profile.INT_CINEMATIC_ZOOM_DISTANCE_MAX,
        NS.DB_GLOBAL.profile.INT_CINEMATIC_ZOOM_PITCH,
        NS.DB_GLOBAL.profile.INT_CINEMATIC_ZOOM_PITCH_LEVEL,
        NS.DB_GLOBAL.profile.INT_CINEMATIC_ZOOM_FOV,
        NS.DB_GLOBAL.profile.INT_CINEMATIC_PAN,
        NS.DB_GLOBAL.profile.INT_CINEMATIC_PAN_SPEED,
        NS.DB_GLOBAL.profile.INT_CINEMATIC_ACTIONCAM,
        NS.DB_GLOBAL.profile.INT_CINEMATIC_ACTIONCAM_SIDE,
        NS.DB_GLOBAL.profile.INT_CINEMATIC_ACTIONCAM_SIDE_STRENGTH,
        NS.DB_GLOBAL.profile.INT_CINEMATIC_ACTIONCAM_OFFSET,
        NS.DB_GLOBAL.profile.INT_CINEMATIC_ACTIONCAM_OFFSET_STRENGTH,
        NS.DB_GLOBAL.profile.INT_CINEMATIC_ACTIONCAM_FOCUS,
        NS.DB_GLOBAL.profile.INT_CINEMATIC_ACTIONCAM_FOCUS_STRENGTH,
        NS.DB_GLOBAL.profile.INT_CINEMATIC_ACTIONCAM_FOCUS_X,
        NS.DB_GLOBAL.profile.INT_CINEMATIC_ACTIONCAM_FOCUS_Y,
        NS.DB_GLOBAL.profile.INT_CINEMATIC_VIGNETTE,
        NS.DB_GLOBAL.profile.INT_CINEMATIC_VIGNETTE_GRADIENT
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
        "VAR_CINEMATIC_VIGNETTE",
        "VAR_CINEMATIC_VIGNETTE_GRADIENT"
    }

    for i = 1, #variables do
        NS[variables[i]] = preset[i + offset]
    end
end

function NS:SetDynamicCinematicVariables()
    if addon.Cinematic and addon.Cinematic.Variables.Active then
        return
    end

    if NS.DB_GLOBAL.profile.INT_CINEMATIC_PRESET == 4 then
        NS.DB_GLOBAL.profile.INT_CINEMATIC = true

        NS:SetToProfileCinematicVariables()
    elseif NS.DB_GLOBAL.profile.INT_CINEMATIC_PRESET > 1 then
        NS.DB_GLOBAL.profile.INT_CINEMATIC = true

        NS:SetToPresetCinematicVariables(NS.CINEMATIC_PROFILES[NS.DB_GLOBAL.profile.INT_CINEMATIC_PRESET])
    else
        NS.DB_GLOBAL.profile.INT_CINEMATIC = false
    end
end

function NS:PreventSetVariableDuringCinematicMode(name, value)
    if addon.Interaction.Variables.Active or addon.Cinematic.Variables.Active then
        return
    end

    NS.DB_GLOBAL.profile[name] = value
end

function NS:OnInitialize()
    C_Timer.After(0, function()
        NS.DB_GLOBAL = AceDB:New("InteractionDB", NS.DEFAULTS_GLOBAL, true)
        NS.DB_GLOBAL_PERSISTENT = AceDB:New("InteractionLibraryDB_Global", NS.DEFAULTS_GLOBAL_PERSISTENT, true)
        NS.DB_LOCAL_PERSISTENT = AceDB:New("InteractionLibraryDB", NS.DEFAULTS_LOCAL_PERSISTENT, true)

        NS:SetDynamicCinematicVariables()

        C_Timer.After(0, function()
            CallbackRegistry:Trigger("ADDON_DATABASE_READY")
        end)
    end)
end
NS = LibStub("AceAddon-3.0"):NewAddon(NS, "Interaction")

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
    NS.DB_GLOBAL = NS.CopyTable(NS.DEFAULTS_GLOBAL)
    InteractionDB = NS.CopyTable(NS.DEFAULTS_GLOBAL)
end


C_Timer.After(addon.Variables.INIT_DELAY_LAST, function()
    CallbackRegistry:Add("SETTING_CHANGED", function()
        NS:SetDynamicCinematicVariables()
    end)
end)


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

SlashCmdList_AddSlashCommand("INTERACTION_CONFIG", function(msg) InteractionAPI_OpenSettingUI() end, "interaction", "int")
