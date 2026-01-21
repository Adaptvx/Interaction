local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local TemplateRegistry = addon.TemplateRegistry
local L = addon.Locales
local NS = addon.ConsoleVariables; addon.ConsoleVariables = NS

NS.Script = {}

function NS.Script:Load()

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

	function NS.Script:GetCVars_General()
		NS.Variables.CVars_General_Saved = {}
		NS.Variables.CVars_General_Saved = NS.Script:GetCVars(NS.Variables.CVARS_GENERAL)
		NS.Variables.Saved_cameraSmoothStyle = GetCVar("cameraSmoothStyle")
	end

	function NS.Script:GetCVars_CinematicMode()
		NS.Variables.CVars_Cinematic_Saved = {}
		NS.Variables.CVars_Cinematic_Saved = NS.Script:GetCVars(NS.Variables.CVARS_CINEMATIC)
		NS.Variables.Saved_cameraTargetFocusInteractEnable = GetCVar("test_cameraTargetFocusInteractEnable")
	end

	function NS.Script:SetCVars_General()
		if NS.Script:IsCVarsMatching(NS.Variables.CVARS_GENERAL) then
			return
		end

		if not NS.Variables.Initalized then
			return
		end

		NS.Script:GetCVars_General()

		NS.Script:SetCVarsFromList(NS.Variables.CVARS_GENERAL)
		if not addon.LoadedAddons.DynamicCam then SetCVar("cameraSmoothStyle", 0) end
	end

	function NS.Script:SetCVars_CinematicMode()
		if NS.Script:IsCVarsMatching(NS.Variables.CVARS_CINEMATIC) then
			return
		end

		if not NS.Variables.Initalized then
			return
		end

		NS.Script:GetCVars_CinematicMode()

		NS.Script:SetCVarsFromList(NS.Variables.CVARS_CINEMATIC)
	end

	function NS.Script:ResetCVars_General(bypass)
		if not addon.Interaction.Variables.Active and not bypass then
			return
		end

		if NS.Script:IsCVarsMatching(NS.Variables.CVars_General_Saved) then
			return
		end

		if not NS.Variables.Initalized then
			return
		end

		NS.Script:SetCVarsFromList(NS.Variables.CVars_General_Saved)
		if not addon.LoadedAddons.DynamicCam then SetCVar("cameraSmoothStyle", NS.Variables.Saved_cameraSmoothStyle) end
	end

	function NS.Script:ResetCVars_CinematicMode(bypass)
		if not addon.Cinematic.Variables.Active and not bypass then
			return
		end

		if NS.Script:IsCVarsMatching(NS.Variables.CVars_Cinematic_Saved) then
			return
		end

		if not NS.Variables.Initalized then
			return
		end

		NS.Script:SetCVarsFromList(NS.Variables.CVars_Cinematic_Saved)
	end

	function NS.Script:Initalize()
		NS.Variables.Initalized = true

		NS.Script:GetCVars_General()
		NS.Script:GetCVars_CinematicMode()

		-- Controller
		----------------------------------------------------------------------------------------------------

		if addon.Input.Variables.IsController then
			SetCVar("GamePadEnable", 1)
		end

		-- Sound
		----------------------------------------------------------------------------------------------------

		NS.Variables.Saved_Sound_DialogVolume = GetCVar("Sound_DialogVolume")
	end

	C_Timer.After(addon.Variables.INIT_DELAY_LAST, function()
		NS.Script:Initalize()
	end)

	function NS.Script:StartInteraction()
		local InteractionActive = (addon.Interaction.Variables.Active)
		local InteractionLastActive = (addon.Interaction.Variables.LastActive)

		local IsCinematic = (addon.Database.DB_GLOBAL.profile.INT_CINEMATIC)
		local IsDynamicPitch = (tonumber(GetCVar("test_cameraDynamicPitch")) > 0)
		local IsOffset = (tonumber(GetCVar("test_cameraOverShoulder")) > 0)
		local IsFocusEnabled = (tostring(GetCVar("test_cameraTargetFocusInteractEnable")) == "1")

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

	-- Events
	----------------------------------------------------------------------------------------------------

	local f = CreateFrame("Frame")
	f:RegisterEvent("CVAR_UPDATE")
	f:SetScript("OnEvent", function(self, event, ...)

		-- Cvar
		----------------------------------------------------------------------------------------------------

		if event == "CVAR_UPDATE" then
			local name, value = ...
            
			-- Set cvar
			----------------------------------------------------------------------------------------------------

			local IsSettingsPanelVisible = (SettingsPanel:IsVisible())
			local IsPlaterOptionsPanelVisible = (PlaterOptionsPanelFrame and PlaterOptionsPanelFrame:IsVisible())

			if IsSettingsPanelVisible or IsPlaterOptionsPanelVisible then
				NS.Script:GetCVars_General()
				NS.Script:GetCVars_CinematicMode()

				-- Sound
				----------------------------------------------------------------------------------------------------

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
