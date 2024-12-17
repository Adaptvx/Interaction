local addonName, addon = ...
local CallbackRegistry = addon.CallbackRegistry
local L = addon.Locales
local NS = addon.Interaction.Quest.Target

--------------------------------

NS.Script = {}

--------------------------------

function NS.Script:Load()
	--------------------------------
	-- REFERENCES
	--------------------------------

	local Frame = InteractionQuestFrame.Target
	local Callback = NS.Script

    --------------------------------
    -- FUNCTIONS (FRAME)
    --------------------------------

    do
        Frame.UpdateLayout = function()
            local TotalHeight = 0

            if not Frame.Model.hidden then TotalHeight = TotalHeight + Frame.Art:GetHeight() end
            TotalHeight = TotalHeight + NS.Variables.PADDING + Frame.Label:GetHeight()
            TotalHeight = TotalHeight + NS.Variables.PADDING + Frame.Description:GetHeight()
            TotalHeight = TotalHeight + NS.Variables.CONTENT_PADDING * 2

            Frame:SetHeight(TotalHeight)

            --------------------------------

            if not Frame.Model.hidden then
                Frame.Art:Show()

                --------------------------------

                Frame.Label:ClearAllPoints()
                Frame.Label:SetPoint("BOTTOM", Frame.Art, 0, -NS.Variables.PADDING - Frame.Label:GetHeight())

                Frame.Description:ClearAllPoints()
                Frame.Description:SetPoint("BOTTOM", Frame.Label, 0, -NS.Variables.PADDING - Frame.Description:GetHeight())
            else
                Frame.Art:Hide()

                --------------------------------

                Frame.Label:ClearAllPoints()
                Frame.Label:SetPoint("TOP", Frame, 0, -NS.Variables.CONTENT_PADDING)

                Frame.Description:ClearAllPoints()
                Frame.Description:SetPoint("BOTTOM", Frame.Label, 0, -NS.Variables.PADDING - Frame.Description:GetHeight())
            end
        end
    end

    --------------------------------
    -- FUNCTIONS (ANIMATION)
    --------------------------------

    do
        local HideTimer = nil

        Frame.ShowWithAnimation = function()
            local modelID, description, name, mountModelID, sceneModelID = GetQuestPortraitGiver()

            if (Frame.hidden) and (QuestModelScene:IsVisible()) and (#name > 1 or #description > 1) then
                if HideTimer then
                    HideTimer:Cancel()
                    HideTimer = nil
                end

                --------------------------------

                Frame.hidden = false

                --------------------------------

                Frame:Show()

                --------------------------------

                Frame.Model:Show()

                --------------------------------

                AdaptiveAPI.Animation:Fade(Frame, .25, 0, 1)
                AdaptiveAPI.Animation:Move(Frame, 1, "LEFT", 125, 100, "y")

                --------------------------------

                -- addon.SoundEffects:PlaySoundFile(addon.SoundEffects.PATH .. "QuestTargetFrame/flyer-animate-in.mp3")
            end
        end

        Frame.HideWithAnimation = function(bypass, skipAnimation)
            if bypass or not Frame.hidden then
                if HideTimer then
                    HideTimer:Cancel()
                end

                if skipAnimation then
                    Frame.hidden = true
                    Frame:Hide()
                else
                    HideTimer = C_Timer.NewTimer(.5, function()
                        if Frame.hidden then
                            Frame.hidden = true
                            Frame:Hide()
                        end
                        HideTimer = nil
                    end)
                end
                --------------------------------

                Frame.hidden = true

                --------------------------------

                Frame.Model:Hide()

                --------------------------------

                if skipAnimation then
                    local point, relativeTo, relativePoint, offsetX, offsetY = Frame:GetPoint()

                    Frame:SetAlpha(0)
                    Frame:SetPoint("LEFT", relativeTo, 125, offsetY)
                else
                    AdaptiveAPI.Animation:Fade(Frame, .25, 1, 0)
                    AdaptiveAPI.Animation:Move(Frame, 1, "LEFT", 100, 125, "y")
                end

                --------------------------------

                -- addon.SoundEffects:PlaySoundFile(addon.SoundEffects.PATH .. "QuestTargetFrame/flyer-animate-out.mp3")
            end
        end
    end

    --------------------------------
    -- FUNCTIONS (EVENT)
    --------------------------------

    do
        if QuestModelScene then -- Fix for Classic Era
            hooksecurefunc(QuestModelScene, "Show", function()
                if QuestModelScene:IsVisible() then
                    local modelID, description, name, mountModelID, sceneModelID = GetQuestPortraitGiver()

                    if #name > 1 or #description > 1 then
                        --------------------------------

                        Frame.Label:SetText(name)
                        Frame.Description:SetText(description)

                        --------------------------------

                        Frame.Model.hidden = true

                        --------------------------------

                        Frame.Model:SetDisplayInfo(modelID, mountModelID)

                        --------------------------------

                        -- "OnModelLoaded" is called when the model is valid, so can do some formatting here.
                        Frame.Model:Hide()
                        Frame.Model:Show()
                        Frame.Model:SetScript("OnModelLoaded", function()
                            Frame.Model.hidden = false

                            --------------------------------

                            Frame.Model:SetCamera(0)
                            Frame.Model:SetPortraitZoom(1)
                            Frame.Model:SetPortraitZoom(.975)
                            Frame.Model:FreezeAnimation(0, 0, 0)
                            Frame.Model:SetModelAlpha(0)
                        end)
                    end
                end
            end)

            local _ = CreateFrame("Frame", "UpdateFrame/QuestTarget_Script.lua -- UpdateSize", Frame)
            _:SetScript("OnUpdate", function()
                Frame.UpdateLayout()
            end)

            CallbackRegistry:Add("START_QUEST", function()
                Frame.ShowWithAnimation()
            end, 0)

            CallbackRegistry:Add("STOP_QUEST", function()
                Frame.HideWithAnimation()
            end, 0)
        end
    end

    --------------------------------
    -- SETUP
    --------------------------------
end
