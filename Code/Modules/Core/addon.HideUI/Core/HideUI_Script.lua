---@class addon
local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local PrefabRegistry = addon.PrefabRegistry
local L = addon.Locales
local NS = addon.HideUI; addon.HideUI = NS

--------------------------------

NS.Script = {}

--------------------------------

function NS.Script:Load()
	--------------------------------
	-- FUNCTIONS
	--------------------------------

	do
		function NS.Script:HideUI(bypass)
			NS.Script:HideWorldUI(bypass)

			--------------------------------

			if InCombatLockdown() then
				return
			end

			--------------------------------

			local isHideUIActive = (NS.Variables.Active)
			local isInteractionActive = (addon.Interaction.Variables.Active)
			local isLastInteractionActive = (addon.Interaction.Variables.LastActive)

			if (bypass and not isHideUIActive) or (isInteractionActive and not isLastInteractionActive and not isHideUIActive) then
				NS.Variables.Active = true

				addon.API.Animation:Fade(UIParent, .25, 1, 0, nil, function() return not NS.Variables.Active end)

				addon.Libraries.AceTimer:ScheduleTimer(function()
					local isHiddenUI = (UIParent:GetAlpha() <= .1)

					--------------------------------

					if not InCombatLockdown() and isHiddenUI then
						UIParent:Hide()
					end
				end, .255)
			end

			--------------------------------

			addon.BlizzardFrames.Script:SetElements()

			--------------------------------

			CallbackRegistry:Trigger("START_HIDEUI")
		end

		function NS.Script:ShowUI(bypass)
			NS.Script:ShowWorldUI(bypass)

			--------------------------------

			local isVisibleUI = (UIParent:GetAlpha() >= .99)
			local isLock = (NS.Variables.Lock)

			if isVisibleUI or isLock then
				return
			end

			--------------------------------

			local isHideUIActive = (NS.Variables.Active)
			local isInteractionActive = (addon.Interaction.Variables.Active)
			local isLastInteractionActive = (addon.Interaction.Variables.LastActive)

			local canShowUIAndHideElements = (addon.API.Main:CanShowUIAndHideElements())

			if (bypass and isHideUIActive) or (not isInteractionActive and isLastInteractionActive and isHideUIActive) then
				NS.Variables.Active = false

				--------------------------------

				UIParent:SetAlpha(1)

				--------------------------------

				if not InCombatLockdown() and canShowUIAndHideElements then
					UIParent:Show()
				end
			end

			--------------------------------

			CallbackRegistry:Trigger("STOP_HIDEUI")
		end

		function NS.Script:HideWorldUI(bypass)
			local isWorldActive = (NS.Variables.WorldActive)
			local isInteractionActive = (addon.Interaction.Variables.Active)
			local isLastInteractionActive = (addon.Interaction.Variables.LastActive)

			if (bypass and not isWorldActive) or (isInteractionActive and not isLastInteractionActive and not isWorldActive) then
				NS.Variables.WorldActive = true

				-- addon.API.Animation:Fade(WorldFrame, .25, WorldFrame:GetAlpha(), 0, nil, function() return not NS.Variables.WorldActive end)
				WorldFrame:SetAlpha(0)
			end

			--------------------------------

			CallbackRegistry:Trigger("START_HIDEWORLDUI")
		end

		function NS.Script:ShowWorldUI(bypass)
			local isVisibleUI = (WorldFrame:GetAlpha() >= .99)
			local isLock = (NS.Variables.Lock)

			if isVisibleUI or isLock then
				return
			end

			--------------------------------

			local isWorldActive = (NS.Variables.WorldActive)
			local isInteractionActive = (addon.Interaction.Variables.Active)
			local isLastInteractionActive = (addon.Interaction.Variables.LastActive)

			if (bypass and isWorldActive) or (not isInteractionActive and isLastInteractionActive and isWorldActive) then
				NS.Variables.WorldActive = false

				--------------------------------

				-- addon.API.Animation:Fade(WorldFrame, .25, WorldFrame:GetAlpha(), 1, nil, function() return NS.Variables.WorldActive end)
				WorldFrame:SetAlpha(1)
			end

			--------------------------------

			CallbackRegistry:Trigger("STOP_HIDEWORLDUI")
		end
	end

	--------------------------------
	-- CALLBACKS
	--------------------------------

	do
		function NS.Script:StartInteraction()
			if addon.Database.DB_GLOBAL.profile.INT_HIDEUI then
				local interactTargetIsSelf = ((UnitName("npc") == UnitName("player")) or UnitName("questnpc") == UnitName("player"))
				local isStaticNPC = ((UnitName("npc") and not UnitExists("npc")) or (UnitName("questnpc") and not UnitExists("questnpc")))
				local inInstance = (IsInInstance())

				if not inInstance then
					NS.Script:HideUI()
				else
					NS.Script:HideWorldUI()
				end
			else
				NS.Script:HideWorldUI()
			end
		end

		function NS.Script:StopInteraction()
			if addon.Database.DB_GLOBAL.profile.INT_HIDEUI then
				local interactTargetIsSelf = ((UnitName("npc") == UnitName("player")) or UnitName("questnpc") == UnitName("player"))
				local isStaticNPC = ((UnitName("npc") and not UnitExists("npc")) or (UnitName("questnpc") and not UnitExists("questnpc")))
				local inInstance = (IsInInstance())

				if not inInstance and NS.Variables.Active then
					if UIParent:GetAlpha() < 1 and NS.Variables.Active then
						NS.Script:ShowUI()
					elseif WorldFrame:GetAlpha() < 1 and NS.Variables.WorldActive then
						NS.Script:ShowWorldUI()
					end
				elseif NS.Variables.WorldActive then
					NS.Script:ShowWorldUI()
				end
			else
				if WorldFrame:GetAlpha() < 1 and NS.Variables.WorldActive then
					NS.Script:ShowWorldUI()
				end
			end
		end

		CallbackRegistry:Add("START_INTERACTION", function() NS.Script:StartInteraction() end, 0)
		CallbackRegistry:Add("STOP_INTERACTION", function() NS.Script:StopInteraction() end, 0)
	end

	--------------------------------
	-- EVENTS
	--------------------------------

	do
		do -- CINEMATIC
			local CinematicFrame = CreateFrame("Frame")
			CinematicFrame:RegisterEvent("PLAY_MOVIE")
			CinematicFrame:RegisterEvent("CINEMATIC_START")
			CinematicFrame:RegisterEvent("STOP_MOVIE")
			CinematicFrame:RegisterEvent("CINEMATIC_STOP")
			if not addon.Variables.IS_WOW_VERSION_CLASSIC_ALL then
				CinematicFrame:RegisterEvent("PERKS_PROGRAM_CLOSE")
			end
			CinematicFrame:SetScript("OnEvent", function(self, event, ...)
				local isHideUIActive = (NS.Variables.Active)

				--------------------------------

				if event == "PLAY_MOVIE" or event == "CINEMATIC_START" then
					if not InCombatLockdown() then
						UIParent:Hide()
					end
				elseif event == "STOP_MOVIE" or event == "CINEMATIC_STOP" or event == "PERKS_PROGRAM_CLOSE" and isHideUIActive then
					if not InCombatLockdown() then
						UIParent:Show()
					end
				end
			end)
		end

		do -- RESPONSE
			local function Response()
				local inCombatLockdown = (InCombatLockdown())
				local canShowUIAndHideElements = (addon.API.Main:CanShowUIAndHideElements())

				local isHideUIActive = (NS.Variables.Active)

				--------------------------------

				if not inCombatLockdown and canShowUIAndHideElements and isHideUIActive then
					UIParent:Show()
				end
			end

			--------------------------------

			local ResponseFrame = CreateFrame("Frame")
			ResponseFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
			ResponseFrame:RegisterEvent("PARTY_INVITE_REQUEST")
			ResponseFrame:RegisterEvent("LFG_ROLE_CHECK_SHOW")
			ResponseFrame:RegisterEvent("LFG_PROPOSAL_SHOW")
			ResponseFrame:RegisterEvent("LFG_PROPOSAL_UPDATE")

			--------------------------------

			ResponseFrame:SetScript("OnEvent", Response)
			CallbackRegistry:Add("QUEUE_POP", Response)
		end

		do -- PRIORITY RESPONSE
			local PriorityResponseFrame = CreateFrame("Frame")
			PriorityResponseFrame:RegisterEvent("LOADING_SCREEN_DISABLED")
			PriorityResponseFrame:RegisterEvent("ZONE_CHANGED")
			PriorityResponseFrame:RegisterEvent("CINEMATIC_START")
			PriorityResponseFrame:RegisterEvent("CINEMATIC_STOP")
			PriorityResponseFrame:RegisterEvent("PLAY_MOVIE")
			PriorityResponseFrame:RegisterEvent("STOP_MOVIE")
			PriorityResponseFrame:SetScript("OnEvent", function(self, event, ...)
				local inCombatLockdown = (InCombatLockdown())
				local canShowUIAndHideElements = (addon.API.Main:CanShowUIAndHideElements())

				local isInInstance = (IsInInstance())
				local isInCinematicScene = (IsInCinematicScene())
				local isHideUIActive = (NS.Variables.Active)
				local isVisibleUI = (UIParent:GetAlpha() >= .99)

				--------------------------------

				if isInInstance then
					if isHideUIActive and not isVisibleUI then
						if not inCombatLockdown and canShowUIAndHideElements then
							UIParent:Show()
						end

						if not Minimap:IsVisible() then
							Minimap:Show()
						end

						UIParent:SetAlpha(1)
						NS.Variables.Active = false
					end
				end

				if isHideUIActive and isInCinematicScene and not inCombatLockdown then
					UIParent:Hide()
				end
			end)
		end
	end
end
