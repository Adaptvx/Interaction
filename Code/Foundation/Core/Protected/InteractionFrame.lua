local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry

addon.InteractionFrame = {}
local NS = addon.InteractionFrame; addon.InteractionFrame = NS

NS.FRAME_STRATA = "FULLSCREEN_DIALOG"
NS.FRAME_LEVEL = 1
NS.FRAME_LEVEL_MAX = 999

function NS:Load()

    do
        do -- Elements
            do -- Frame
                InteractionFrame = CreateFrame("Frame", "InteractionFrame", nil)
                InteractionFrame:SetPoint("CENTER", nil)

                do -- Prevent mouse
                    InteractionFrame.PreventMouse = CreateFrame("Frame")
                    InteractionFrame.PreventMouse:SetAllPoints(UIParent)
                    InteractionFrame.PreventMouse:SetPoint("CENTER", UIParent)
                    InteractionFrame.PreventMouse:SetFrameStrata(NS.FRAME_STRATA)
                    InteractionFrame.PreventMouse:SetFrameLevel(NS.FRAME_LEVEL_MAX)
                    InteractionFrame.PreventMouse:EnableMouse(true)
                    InteractionFrame.PreventMouse:Hide()
                end

                do -- Keybind frame
                    InteractionFrame.KeybindFrame = CreateFrame("Frame", "$parent.KeybindFrame", InteractionFrame)
                    InteractionFrame.KeybindFrame:SetPropagateKeyboardInput(true)
                end
            end

            do -- Priority frame
                InteractionPriorityFrame = CreateFrame("Frame", "InteractionPriorityFrame", nil)
                InteractionPriorityFrame:SetPoint("CENTER", nil)
                InteractionPriorityFrame:SetFrameStrata(NS.FRAME_STRATA)
                InteractionPriorityFrame:SetFrameLevel(NS.FRAME_LEVEL_MAX)
            end
        end
    end

    local Frame = InteractionFrame
    local PriorityFrame = InteractionPriorityFrame
    local Callback = NS

    do

        function Callback:UpdateSize()
            local screenWidth = addon.API.Main:GetScreenWidth()
            local screenHeight = addon.API.Main:GetScreenHeight()
            local aspectRatio = screenWidth / screenHeight
            local clampThreshold = 2.37 -- 2560/1080

            local clampAspectRatio = aspectRatio > clampThreshold
            local newWidth = clampAspectRatio and screenHeight * clampThreshold or screenWidth
            local newHeight = screenHeight

            InteractionFrame:SetSize(newWidth, newHeight)
            InteractionFrame:SetScale(addon.API.Main.UIScale)

            InteractionPriorityFrame:SetSize(UIParent:GetSize())
            InteractionPriorityFrame:SetScale(UIParent:GetScale())
        end
    end

    do
        do -- References

            function NS.SetReferences(frame)
                frame.Label = select(3, frame:GetRegions())
                frame.Background = select(2, frame:GetRegions())

                if frame.Icon == nil then
                    frame.Icon = _G[frame:GetDebugName() .. "QuestIcon"]
                end
            end

            hooksecurefunc(GossipFrame.GreetingPanel.ScrollBox, "Update", function(frame)
                GossipFrame.GreetingPanel.ScrollBox:ForEachFrame(function(self)
                    local elementData = self:GetElementData()

                    if elementData.buttonType ~= GOSSIP_BUTTON_TYPE_DIVIDER and elementData.buttonType ~= GOSSIP_BUTTON_TYPE_TITLE then
                        NS.SetReferences(self)
                    end
                end)
            end)

            if not addon.Variables.IS_WOW_VERSION_CLASSIC_ALL then -- Retail
                hooksecurefunc(QuestFrameGreetingPanel, "Show", function(frame)
                    local function UpdateQuestFrameGreetingPanel()
                        local numButtons = 0

                        for button in frame.titleButtonPool:EnumerateActive() do
                            numButtons = numButtons + 1
                        end

                        if QuestFrameGreetingPanel:IsVisible() and numButtons > 0 then
                            for button in frame.titleButtonPool:EnumerateActive() do
                                NS.SetReferences(button)
                            end

                            C_Timer.After(.1, UpdateQuestFrameGreetingPanel)
                        end
                    end

                    C_Timer.After(0, UpdateQuestFrameGreetingPanel)
                end)
            elseif addon.Variables.IS_WOW_VERSION_CLASSIC_ALL then -- Classic
                local IsQuestTitleButtons = (QuestTitleButton1)

                if IsQuestTitleButtons then
                    for i = 1, 40 do
                        if _G["QuestTitleButton" .. i] then
                            local CurrentFrame = _G["QuestTitleButton" .. i]
                            NS.SetReferences(CurrentFrame)
                        end
                    end
                end
            end
        end
    end

    function Frame.ChangeThemeAnimation()
        if Frame.ThemeTransition then
            return
        end
        Frame.ThemeTransition = true

        addon.API.Animation:Fade(Frame, .125, .99, 0, nil, function() return not Frame.ThemeTransition end)

        C_Timer.After(.5, function()
            if Frame.ThemeTransition then
                addon.API.Animation:Fade(Frame, .25, 0, 1, nil, function() return not Frame.ThemeTransition end)

                C_Timer.After(.35, function()
                    if Frame.ThemeTransition and Frame:GetAlpha() >= .99 then
                        Frame.ThemeTransition = false
                    end
                end)
            end
        end)
    end

    local f = CreateFrame("Frame")
    f:RegisterEvent("CINEMATIC_START")
    f:RegisterEvent("PLAY_MOVIE")
    f:RegisterEvent("CINEMATIC_STOP")
    f:RegisterEvent("STOP_MOVIE")
    f:SetScript("OnEvent", function(self, event, ...)
        if event == "CINEMATIC_START" or event == "PLAY_MOVIE" then
            InteractionFrame:Hide()
            InteractionPriorityFrame:Hide()
        end

        if event == "CINEMATIC_STOP" or event == "STOP_MOVIE" then
            InteractionFrame:Show()
            InteractionPriorityFrame:Show()
        end
    end)

    CallbackRegistry:Add("BLIZZARD_SETTINGS_RESOLUTION_CHANGED", function()
        Callback:UpdateSize()
    end)

    Callback:UpdateSize()
end
