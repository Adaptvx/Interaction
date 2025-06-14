---@class addon
local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local PrefabRegistry = addon.PrefabRegistry
local L = addon.Locales

--------------------------------

addon.Modules = {}
local NS = addon.Modules; addon.Modules = NS

--------------------------------

function NS:Load()
	local function Modules()
		addon.Locales:Load()

		addon.BlizzardFrames:Load()
		addon.BlizzardSettings:Load()
		addon.BlizzardSound:Load()
		addon.BlizzardMinimapIcon:Load()

		addon.Alert:Load()
		addon.AlertNotification:Load()
		addon.Audiobook:Load()
		addon.Cinematic:Load()
		addon.ConsoleVariables:Load()
		addon.ContextIcon:Load()
		addon.ControlGuide:Load()
		addon.GameTooltip:Load()
		addon.HideUI:Load()
		addon.PlayerStatusBar:Load()
		addon.Input:Load()
		addon.Interaction:Load()
		addon.Prompt:Load()
		addon.PromptText:Load()
		addon.Readable:Load()
		addon.SettingsUI:Load()
		addon.TextToSpeech:Load()
		addon.Waypoint:Load()
	end

	--------------------------------

	Modules()
end
