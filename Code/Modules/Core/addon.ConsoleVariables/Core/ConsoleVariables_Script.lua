---@class addon
local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local PrefabRegistry = addon.PrefabRegistry
local L = addon.Locales
local NS = addon.ConsoleVariables; addon.ConsoleVariables = NS

--------------------------------

NS.Script = {}

--------------------------------

function NS.Script:Load()
	--------------------------------
	-- FUNCTIONS
	--------------------------------

	function NS.Script:GetCVars(list)
		local results = {}

		for cvar, value in pairs(list) do
			local savedCVar = cvar
			local savedValue = GetCVar(cvar)

			results[cvar] = savedValue
		end

		return results
	end

	function NS.Script:SetCVarsFromList(list)
		for cvar, value in pairs(list) do
			addon.API.Util:SetCVar(cvar, value)
		end
	end

	function NS.Script:IsCVarsMatching(list)
		local numValues = 0
		local matchingValues = 0

		for cvar, value in pairs(list) do
			numValues = numValues + 1

			if tostring(GetCVar(cvar)) == tostring(value) then
				matchingValues = matchingValues + 1
			end
		end

		if matchingValues == numValues then
			return true
		end

		return false
	end

	--------------------------------

	function NS.Script:GetCVars_General()
		addon._DEV:Print("Console Variables Saved - General")

		--------------------------------

		NS.Variables.CVars_General_Saved = {}
		NS.Variables.CVars_General_Saved = NS.Script:GetCVars(NS.Variables.CVARS_GENERAL)
		NS.Variables.Saved_cameraSmoothStyle = GetCVar("cameraSmoothStyle")
	end

	function NS.Script:GetCVars_CinematicMode()
		addon._DEV:Print("Console Variables Saved - Cinematic Mode")

		--------------------------------

		NS.Variables.CVars_Cinematic_Saved = {}
		NS.Variables.CVars_Cinematic_Saved = NS.Script:GetCVars(NS.Variables.CVARS_CINEMATIC)
		NS.Variables.Saved_cameraTargetFocusInteractEnable = GetCVar("test_cameraTargetFocusInteractEnable")
	end

	--------------------------------

	function NS.Script:SetCVars_General()
		if NS.Script:IsCVarsMatching(NS.Variables.CVARS_GENERAL) then
			addon._DEV:Print("Console Variables Set - General [BLOCKED] - Matching Variables")
			return
		end

		if not NS.Variables.Initalized then
			addon._DEV:Print("Console Variables Set - General [BLOCKED] - Not initalized")
			return
		end
		addon._DEV:Print("Console Variables Set - General")

		--------------------------------

		NS.Script:GetCVars_General()

		--------------------------------

		NS.Script:SetCVarsFromList(NS.Variables.CVARS_GENERAL)
		if not addon.LoadedAddons.DynamicCam then SetCVar("cameraSmoothStyle", 0) end
	end

	function NS.Script:SetCVars_CinematicMode()
		if NS.Script:IsCVarsMatching(NS.Variables.CVARS_CINEMATIC) then
			addon._DEV:Print("Console Variables Set - Cinematic Mode [BLOCKED] - Matching Variables")
			return
		end

		if not NS.Variables.Initalized then
			addon._DEV:Print("Console Variables Set - Cinematic Mode [BLOCKED] - Not initalized")
			return
		end
		addon._DEV:Print("Console Variables Set - Cinematic Mode")

		--------------------------------

		NS.Script:GetCVars_CinematicMode()

		--------------------------------

		NS.Script:SetCVarsFromList(NS.Variables.CVARS_CINEMATIC)
	end

	--------------------------------

	function NS.Script:ResetCVars_General(bypass)
		if not addon.Interaction.Variables.Active and not bypass then
			return
		end

		if NS.Script:IsCVarsMatching(NS.Variables.CVars_General_Saved) then
			addon._DEV:Print("Console Variables Reset - General [BLOCKED] - Matching Variables")
			return
		end

		if not NS.Variables.Initalized then
			addon._DEV:Print("Console Variables Reset - General [BLOCKED] - Not initalized")
			return
		end
		addon._DEV:Print("Console Variables Reset - General")

		--------------------------------

		NS.Script:SetCVarsFromList(NS.Variables.CVars_General_Saved)
		if not addon.LoadedAddons.DynamicCam then SetCVar("cameraSmoothStyle", NS.Variables.Saved_cameraSmoothStyle) end
	end

	function NS.Script:ResetCVars_CinematicMode(bypass)
		if not addon.Cinematic.Variables.Active and not bypass then
			return
		end

		if NS.Script:IsCVarsMatching(NS.Variables.CVars_Cinematic_Saved) then
			addon._DEV:Print("Console Variables Reset - Cinematic Mode [BLOCKED] - Matching Variables")
			return
		end

		if not NS.Variables.Initalized then
			addon._DEV:Print("Console Variables Reset - Cinematic Mode [BLOCKED] - Not initalized")
			return
		end
		addon._DEV:Print("Console Variables Reset - Cinematic Mode")

		--------------------------------

		NS.Script:SetCVarsFromList(NS.Variables.CVars_Cinematic_Saved)
	end

	--------------------------------

	function NS.Script:Initalize()
		NS.Variables.Initalized = true

		NS.Script:GetCVars_General()
		NS.Script:GetCVars_CinematicMode()

		--------------------------------
		-- CONTROLLER
		--------------------------------

		if addon.Input.Variables.IsController then
			SetCVar("GamePadEnable", 1)
		end

		--------------------------------
		-- SOUND
		--------------------------------

		NS.Variables.Saved_Sound_DialogVolume = GetCVar("Sound_DialogVolume")
	end

	addon.Libraries.AceTimer:ScheduleTimer(function()
		NS.Script:Initalize()
	end, addon.Variables.INIT_DELAY_LAST)

	--------------------------------
	-- CALLBACKS
	--------------------------------

	function NS.Script:StartInteraction()
		local InteractionActive = (addon.Interaction.Variables.Active)
		local InteractionLastActive = (addon.Interaction.Variables.LastActive)

		local IsCinematic = (addon.Database.DB_GLOBAL.profile.INT_CINEMATIC)
		local IsDynamicPitch = (tonumber(GetCVar("test_cameraDynamicPitch")) > 0)
		local IsOffset = (tonumber(GetCVar("test_cameraOverShoulder")) > 0)
		local IsFocusEnabled = (tostring(GetCVar("test_cameraTargetFocusInteractEnable")) == "1")

		--------------------------------

		if not InteractionLastActive then
			NS.Script:SetCVars_General()
			if IsCinematic or IsDynamicPitch or IsOffset or IsFocusEnabled then
				NS.Script:SetCVars_CinematicMode()
			end
		end
	end

	function NS.Script:StopInteraction()
		NS.Script:ResetCVars_General(true)
		NS.Script:ResetCVars_CinematicMode(true)
	end

	CallbackRegistry:Add("START_INTERACTION", function() NS.Script:StartInteraction() end, 0)
	CallbackRegistry:Add("STOP_INTERACTION", function() NS.Script:StopInteraction() end, 0)

	--------------------------------
	-- EVENTS
	--------------------------------

	local Events = CreateFrame("Frame")
	Events:RegisterEvent("CVAR_UPDATE")
	Events:SetScript("OnEvent", function(self, event, ...)
		--------------------------------
		-- CVAR
		--------------------------------

		if event == "CVAR_UPDATE" then
			local name, value = ...
			addon._DEV:Print("Console Variable Event - " .. name or "nil" .. " Value - " .. value or "nil") -- DEBUG

			--------------------------------
			-- SET CVAR
			--------------------------------

			local IsSettingsPanelVisible = (SettingsPanel:IsVisible())
			local IsPlaterOptionsPanelVisible = (PlaterOptionsPanelFrame and PlaterOptionsPanelFrame:IsVisible())

			if IsSettingsPanelVisible or IsPlaterOptionsPanelVisible then
				NS.Script:GetCVars_General()
				NS.Script:GetCVars_CinematicMode()

				--------------------------------
				-- SOUND
				--------------------------------

				NS.Variables.Saved_Sound_DialogVolume = GetCVar("Sound_DialogVolume")
			end
		end
	end)

	local ResponseFrame = CreateFrame("Frame")
	ResponseFrame:RegisterEvent("ADDONS_UNLOADING")
	ResponseFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
	ResponseFrame:SetScript("OnEvent", function(event, arg1, arg2)
		local InteractionActive = (addon.Interaction.Variables.Active)
		local CinematicModeActive = (addon.Cinematic.Variables.Active)

		--------------------------------

		if InteractionActive or CinematicModeActive then
			if arg1 == "ADDONS_UNLOADING" then
				NS.Script:ResetCVars_General(true)
				NS.Script:ResetCVars_CinematicMode(true)

				SetCVar("cameraFov", 90)
				SetCVar("Sound_DialogVolume", NS.Variables.Saved_Sound_DialogVolume)
			end

			if arg1 == "PLAYER_REGEN_DISABLED" then
				NS.Script:ResetCVars_General()
				NS.Script:ResetCVars_CinematicMode()
			end
		end
	end)
end
