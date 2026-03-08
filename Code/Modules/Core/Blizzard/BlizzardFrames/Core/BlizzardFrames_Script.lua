local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local NS = addon.BlizzardFrames; addon.BlizzardFrames = NS

NS.Script = {}

function NS.Script:Load()
    local Callback = NS.Script

    local CachedQuestFramePosition = {}
    local CachedGossipFramePosition = {}

    function Callback:Clear_QuestFrame()
        local point, relativeTo, relativePoint, xOfs, yOfs = QuestFrame:GetPoint()
        CachedQuestFramePosition = {
            point = point,
            relativeTo = relativeTo,
            relativePoint = relativePoint,
            xOfs = xOfs,
            yOfs = yOfs,
        }

        QuestFrame:ClearAllPoints()
        QuestFrame:SetParent(InteractionFrame)
        QuestFrame:SetAlpha(0)
    end

    function Callback:Clear_GossipFrame()
        local point, relativeTo, relativePoint, xOfs, yOfs = GossipFrame:GetPoint()
        CachedGossipFramePosition = {
            point = point,
            relativeTo = relativeTo,
            relativePoint = relativePoint,
            xOfs = xOfs,
            yOfs = yOfs,
        }

        GossipFrame:ClearAllPoints()
        GossipFrame:SetParent(InteractionFrame)
        GossipFrame:SetAlpha(0)
    end

    function Callback:Restore_QuestFrame()
        QuestFrame:SetParent(UIParent)
        QuestFrame:SetAlpha(1)
        if CachedQuestFramePosition.point then
            QuestFrame:SetPoint(CachedQuestFramePosition.point, CachedQuestFramePosition.relativeTo, CachedQuestFramePosition.relativePoint, CachedQuestFramePosition.xOfs, CachedQuestFramePosition.yOfs)
        end
    end

    function Callback:Restore_GossipFrame()
        GossipFrame:SetParent(UIParent)
        GossipFrame:SetAlpha(1)
        if CachedGossipFramePosition.point then
            GossipFrame:SetPoint(CachedGossipFramePosition.point, CachedGossipFramePosition.relativeTo, CachedGossipFramePosition.relativePoint, CachedGossipFramePosition.xOfs, CachedGossipFramePosition.yOfs)
        end
    end

    function Callback:Clear()
        Callback:Clear_QuestFrame()
        Callback:Clear_GossipFrame()
    end

    function Callback:SetElements()
        NS.Variables.SetElementsActive = true

        Callback:SetElements_InteractionPriorityFrame(UIErrorsFrame)
    end

    function Callback:SetElements_UIParent(frame, strata)
        frame:SetParent(UIParent)

        frame:SetFrameStrata(strata or frame.SavedFrameStrata or "FULLSCREEN_DIALOG")
    end

    function Callback:SetElements_InteractionPriorityFrame(frame, strata)
        frame:SetParent(InteractionPriorityFrame)

        if strata then
            frame.SavedFrameStrata = frame:GetFrameStrata()
            frame:SetFrameStrata(strata)
        end
    end

    function Callback:RemoveElements()
        NS.Variables.SetElementsActive = false

        Callback:SetElements_UIParent(UIErrorsFrame)
    end

    if not addon.Variables.IS_WOW_VERSION_CLASSIC_ALL then
        local function Callback(queueType)
            CallbackRegistry:Trigger("QUEUE_POP", queueType)
        end

        hooksecurefunc(LFGDungeonReadyPopup, "Show", function() Callback("Dungeon") end)
        hooksecurefunc(PVPReadyDialog, "Show", function() Callback("PVP") end)
        hooksecurefunc(PVPReadyPopup, "Show", function() Callback("PVP") end)
        if PlunderstormFramePopup then hooksecurefunc(PlunderstormFramePopup, "Show", function() Callback("Plunderstorm") end) end
    end

    CallbackRegistry:Add("START_INTERACTION", function() Callback:Clear() end, 0)

    StaticPopup1:SetIgnoreParentAlpha(true)
    if not addon.Variables.IS_WOW_VERSION_CLASSIC_ERA then LFGDungeonReadyPopup:SetIgnoreParentAlpha(true) end
    if not addon.Variables.IS_WOW_VERSION_CLASSIC_ALL then PVPReadyDialog:SetIgnoreParentAlpha(true) end
    if not addon.Variables.IS_WOW_VERSION_CLASSIC_ALL then PVPReadyPopup:SetIgnoreParentAlpha(true) end
    if not addon.Variables.IS_WOW_VERSION_CLASSIC_ALL and PlunderstormFramePopup then PlunderstormFramePopup:SetIgnoreParentAlpha(true) end

    local function Update()
        if addon.Database.DB_GLOBAL.profile.INT_HIDEUI and not UIParent:IsVisible() and addon.API.Main:CanShowUIAndHideElements() then
            if not NS.Variables.SetElementsActive then
                Callback:SetElements()
            end
        else
            if NS.Variables.SetElementsActive then
                Callback:RemoveElements()
            end
        end
    end

    CallbackRegistry:Add("START_HIDEUI", Update, 0)
    CallbackRegistry:Add("STOP_HIDEUI", Update, 0)
    CallbackRegistry:Add("START_INTERACTION", Update, 0)
    CallbackRegistry:Add("STOP_INTERACTION", Update, 0)

    local f = CreateFrame("Frame")
    f:RegisterEvent("CINEMATIC_START")
    f:RegisterEvent("PLAY_MOVIE")
    f:RegisterEvent("STOP_MOVIE")
    f:RegisterEvent("CINEMATIC_STOP")
    f:SetScript("OnEvent", Update)
end
