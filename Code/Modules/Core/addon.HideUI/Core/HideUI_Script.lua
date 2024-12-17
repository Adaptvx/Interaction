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

    function NS.Script:ShowUI(bypass)
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

            AdaptiveAPI.Animation:Fade(UIParent, .25, 0, 1)

            --------------------------------

            if not InCombatLockdown() and CanShowUIAndHideElements then
                UIParent:Show()
            end
        end

        --------------------------------

        CallbackRegistry:Trigger("STOP_HIDEUI")
    end

    function NS.Script:HideUI(bypass)
        if InCombatLockdown() then
            return
        end

        --------------------------------

        local IsHideUIActive = (NS.Variables.Active)
        local IsInteractionActive = (addon.Interaction.Variables.Active)
        local IsLastInteractionActive = (addon.Interaction.Variables.LastActive)

        if (bypass and not IsHideUIActive) or (IsInteractionActive and not IsLastInteractionActive and not IsHideUIActive) then
            NS.Variables.Active = true

			AdaptiveAPI.Animation:Fade(UIParent, .25, 1, 0)

            addon.Libraries.AceTimer:ScheduleTimer(function()
                local IsHiddenUI = (UIParent:GetAlpha() <= .1)

                --------------------------------

                if not InCombatLockdown() and IsHiddenUI then
                    UIParent:Hide()
                end
            end, .275)
        end

        --------------------------------

        addon.BlizzardFrames.Script:SetElements()

        --------------------------------

        CallbackRegistry:Trigger("START_HIDEUI")
    end

    --------------------------------
    -- CALLBACKS
    --------------------------------

    function NS.Script:StartInteraction()
        if not INTDB.profile.INT_HIDEUI then
            return
        end

        local InteractTargetIsSelf = ((UnitName("npc") == UnitName("player")) or UnitName("questnpc") == UnitName("player"))
        local IsStaticNPC = ((UnitName("npc") and not UnitExists("npc")) or (UnitName("questnpc") and not UnitExists("questnpc")))
        local InInstance = (IsInInstance())

        if InInstance then
            return
        end

        NS.Script:HideUI()
    end

    function NS.Script:StopInteraction()
        if not INTDB.profile.INT_HIDEUI then
            return
        end

        local InteractTargetIsSelf = ((UnitName("npc") == UnitName("player")) or UnitName("questnpc") == UnitName("player"))
        local IsStaticNPC = ((UnitName("npc") and not UnitExists("npc")) or (UnitName("questnpc") and not UnitExists("questnpc")))
        local InInstance = (IsInInstance())

        if (InInstance) and not NS.Variables.Active then
            return
        end

        if UIParent:GetAlpha() < 1 and NS.Variables.Active then
            NS.Script:ShowUI()
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
            UIParent:Hide()
        elseif event == "STOP_MOVIE" or event == "CINEMATIC_STOP" or event == "PERKS_PROGRAM_CLOSE" and IsHideUIActive then
            if not InCombatLockdown() then
                UIParent:Show()
            end
        end
    end)

    local ResponseFrame = CreateFrame("Frame")
    ResponseFrame:RegisterEvent("UNIT_COMBAT")
    ResponseFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
    ResponseFrame:SetScript("OnEvent", function(event, arg1, arg2)
        local InCombatLockdown = (InCombatLockdown())
        local CanShowUIAndHideElements = (addon.API:CanShowUIAndHideElements())

        local IsInInstance = (IsInInstance())
        local IsInCinematicScene = (IsInCinematicScene())
        local IsHideUIActive = (NS.Variables.Active)
        local IsVisibleUI = (UIParent:GetAlpha() >= .99)

        if arg1 == "UNIT_COMBAT" and arg2 == "player" then
            if not InCombatLockdown and CanShowUIAndHideElements and IsHideUIActive then
                UIParent:Show()
            end
        end

        if arg1 == "PLAYER_REGEN_DISABLED" then
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
            end
        end

        if IsHideUIActive and IsInCinematicScene then
            UIParent:Hide()
        end
    end)
end
