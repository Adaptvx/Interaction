local addonName, addon = ...
local CallbackRegistry = addon.CallbackRegistry
local L = addon.Locales
local NS = addon.HideUI

--------------------------------

NS.Script = {}

--------------------------------

function NS.Script:Load()
	--------------------------------
	-- FUNCTIONS
	--------------------------------

	function NS.Script:HideUI(bypass)
		NS.Script:HideWorldUI(bypass)

		--------------------------------

		if InCombatLockdown() then
			return
		end

		--------------------------------

		local IsHideUIActive = (NS.Variables.Active)
		local IsInteractionActive = (addon.Interaction.Variables.Active)
		local IsLastInteractionActive = (addon.Interaction.Variables.LastActive)

		if (bypass and not IsHideUIActive) or (IsInteractionActive and not IsLastInteractionActive and not IsHideUIActive) then
			NS.Variables.Active = true

			AdaptiveAPI.Animation:Fade(UIParent, .25, 1, 0, nil, function() return not NS.Variables.Active end)

			addon.Libraries.AceTimer:ScheduleTimer(function()
				local IsHiddenUI = (UIParent:GetAlpha() <= .1)

				--------------------------------

				if not InCombatLockdown() and IsHiddenUI then
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

		local IsVisibleUI = (UIParent:GetAlpha() >= .99)
		local IsLock = (NS.Variables.Lock)

		if IsVisibleUI or IsLock then
			return
		end

		--------------------------------

		local IsHideUIActive = (NS.Variables.Active)
		local IsInteractionActive = (addon.Interaction.Variables.Active)
		local IsLastInteractionActive = (addon.Interaction.Variables.LastActive)

		local CanShowUIAndHideElements = (addon.API:CanShowUIAndHideElements())

		if (bypass and IsHideUIActive) or (not IsInteractionActive and IsLastInteractionActive and IsHideUIActive) then
			NS.Variables.Active = false

			--------------------------------

			UIParent:SetAlpha(1)

			--------------------------------

			if not InCombatLockdown() and CanShowUIAndHideElements then
				UIParent:Show()
			end
		end

		--------------------------------

		CallbackRegistry:Trigger("STOP_HIDEUI")
	end

	function NS.Script:HideWorldUI(bypass)
		local IsWorldActive = (NS.Variables.WorldActive)
		local IsInteractionActive = (addon.Interaction.Variables.Active)
		local IsLastInteractionActive = (addon.Interaction.Variables.LastActive)

		if (bypass and not IsWorldActive) or (IsInteractionActive and not IsLastInteractionActive and not IsWorldActive) then
			NS.Variables.WorldActive = true

			-- AdaptiveAPI.Animation:Fade(WorldFrame, .25, WorldFrame:GetAlpha(), 0, nil, function() return not NS.Variables.WorldActive end)
			WorldFrame:SetAlpha(0)
		end

		--------------------------------

		CallbackRegistry:Trigger("START_HIDEWORLDUI")
	end

	function NS.Script:ShowWorldUI(bypass)
		local IsVisibleUI = (WorldFrame:GetAlpha() >= .99)
		local IsLock = (NS.Variables.Lock)

		if IsVisibleUI or IsLock then
			return
		end

		--------------------------------

		local IsWorldActive = (NS.Variables.WorldActive)
		local IsInteractionActive = (addon.Interaction.Variables.Active)
		local IsLastInteractionActive = (addon.Interaction.Variables.LastActive)

		if (bypass and IsWorldActive) or (not IsInteractionActive and IsLastInteractionActive and IsWorldActive) then
			NS.Variables.WorldActive = false

			--------------------------------

			-- AdaptiveAPI.Animation:Fade(WorldFrame, .25, WorldFrame:GetAlpha(), 1, nil, function() return NS.Variables.WorldActive end)
			WorldFrame:SetAlpha(1)
		end

		--------------------------------

		CallbackRegistry:Trigger("STOP_HIDEWORLDUI")
	end

	--------------------------------
	-- CALLBACKS
	--------------------------------

	function NS.Script:StartInteraction()
		if INTDB.profile.INT_HIDEUI then
			local InteractTargetIsSelf = ((UnitName("npc") == UnitName("player")) or UnitName("questnpc") == UnitName("player"))
			local IsStaticNPC = ((UnitName("npc") and not UnitExists("npc")) or (UnitName("questnpc") and not UnitExists("questnpc")))
			local InInstance = (IsInInstance())

			if not InInstance then
				NS.Script:HideUI()
			else
				NS.Script:HideWorldUI()
			end
		else
			NS.Script:HideWorldUI()
		end
	end

	function NS.Script:StopInteraction()
		if INTDB.profile.INT_HIDEUI then
			local InteractTargetIsSelf = ((UnitName("npc") == UnitName("player")) or UnitName("questnpc") == UnitName("player"))
			local IsStaticNPC = ((UnitName("npc") and not UnitExists("npc")) or (UnitName("questnpc") and not UnitExists("questnpc")))
			local InInstance = (IsInInstance())

			if not InInstance and NS.Variables.Active then
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

	--------------------------------
	-- EVENTS
	--------------------------------

	local CinematicFrame = CreateFrame("Frame")
	CinematicFrame:RegisterEvent("PLAY_MOVIE")
	CinematicFrame:RegisterEvent("CINEMATIC_START")
	CinematicFrame:RegisterEvent("STOP_MOVIE")
	CinematicFrame:RegisterEvent("CINEMATIC_STOP")
	if not addon.Variables.IS_CLASSIC then
		CinematicFrame:RegisterEvent("PERKS_PROGRAM_CLOSE")
	end
	CinematicFrame:SetScript("OnEvent", function(self, event, ...)
		local CanShowUIAndHideElements = (addon.API:CanShowUIAndHideElements())

		local IsInInstance = (IsInInstance())
		local IsInCinematicScene = (IsInCinematicScene())
		local IsHideUIActive = (NS.Variables.Active)
		local IsVisibleUI = (UIParent:GetAlpha() >= .99)

		if event == "PLAY_MOVIE" or event == "CINEMATIC_START" then
			if not InCombatLockdown() then
				UIParent:Hide()
			end
		elseif event == "STOP_MOVIE" or event == "CINEMATIC_STOP" or event == "PERKS_PROGRAM_CLOSE" and IsHideUIActive then
			if not InCombatLockdown() then
				UIParent:Show()
			end
		end
	end)

	local ResponseFrame = CreateFrame("Frame")
	ResponseFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
	ResponseFrame:RegisterEvent("PARTY_INVITE_REQUEST")
	ResponseFrame:RegisterEvent("LFG_ROLE_CHECK_SHOW")
	ResponseFrame:RegisterEvent("LFG_PROPOSAL_SHOW")
	ResponseFrame:RegisterEvent("LFG_PROPOSAL_UPDATE")
	ResponseFrame:SetScript("OnEvent", function(self, event, ...)
		local InCombatLockdown = (InCombatLockdown())
		local CanShowUIAndHideElements = (addon.API:CanShowUIAndHideElements())

		local IsInInstance = (IsInInstance())
		local IsInCinematicScene = (IsInCinematicScene())
		local IsHideUIActive = (NS.Variables.Active)
		local IsVisibleUI = (UIParent:GetAlpha() >= .99)

		if event == "PLAYER_REGEN_DISABLED" or event == "PARTY_INVITE_REQUEST" or event == "LFG_ROLE_CHECK_SHOW" or event == "LFG_PROPOSAL_SHOW" or event == "LFG_PROPOSAL_UPDATE" then
			if not InCombatLockdown and CanShowUIAndHideElements and IsHideUIActive then
				UIParent:Show()
			end
		end
	end)

	local UpdateFrame = CreateFrame("Frame")
	UpdateFrame:SetScript("OnUpdate", function()
		local InCombatLockdown = (InCombatLockdown())
		local CanShowUIAndHideElements = (addon.API:CanShowUIAndHideElements())

		local IsInInstance = (IsInInstance())
		local IsInCinematicScene = (IsInCinematicScene())
		local IsHideUIActive = (NS.Variables.Active)
		local IsVisibleUI = (UIParent:GetAlpha() >= .99)

		if IsInInstance then
			if IsHideUIActive and not IsVisibleUI then
				if not InCombatLockdown and CanShowUIAndHideElements then
					UIParent:Show()
				end

				if not Minimap:IsVisible() then
					Minimap:Show()
				end

				UIParent:SetAlpha(1)
				NS.Variables.Active = false
			end
		end

		if IsHideUIActive and IsInCinematicScene and not InCombatLockdown then
			UIParent:Hide()
		end
	end)
end
