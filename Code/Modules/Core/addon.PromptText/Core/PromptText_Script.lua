local addonName, addon = ...
local CallbackRegistry = addon.CallbackRegistry
local L = addon.Locales
local NS = addon.PromptText

--------------------------------

NS.Script = {}

--------------------------------

function NS.Script:Load()
    --------------------------------
    -- FUNCTIONS (BUTTONS)
    --------------------------------

    do
        InteractionTextPromptFrame.ButtonArea.Button1:SetScript("OnClick", function(self)
            local success = self.Callback(self, InteractionTextPromptFrame.InputArea.InputBox:GetText())

            if success then
                addon.PromptTextHideTextFrame()
            end
        end)
    end

    --------------------------------
    -- FUNCTIONS (FRAME)
    --------------------------------

    do
        function addon.PromptTextShowTextFrame(title, multiline, hint, text, buttonText, buttonCallback, autoSelect)
            InteractionTextPromptFrame.TitleArea.Title:SetText(title)
            InteractionTextPromptFrame.InputArea.InputBox:SetText(text)
            InteractionTextPromptFrame.InputArea.InputBox:SetMultiLine(multiline)
            InteractionTextPromptFrame.InputArea.InputBox.Hint:SetText(hint)

			--------------------------------

            if autoSelect then
                InteractionTextPromptFrame.InputArea.InputBox:HighlightText(0, #InteractionTextPromptFrame.InputArea.InputBox:GetText())

				--------------------------------

				addon.Libraries.AceTimer:ScheduleTimer(function()
					InteractionTextPromptFrame.InputArea.InputBox:SetFocus()
				end, .1)
            end

			--------------------------------


            AdaptiveAPI:SetVisibility(InteractionTextPromptFrame.ButtonArea.Button1, (buttonText and buttonCallback))
            if buttonText and buttonCallback then
                InteractionTextPromptFrame.ButtonArea.Button1:SetText(buttonText)
                InteractionTextPromptFrame.ButtonArea.Button1.Callback = buttonCallback
            end

			--------------------------------

            InteractionTextPromptFrame.ShowWithAnimation()
        end

        function addon.PromptTextHideTextFrame()
            InteractionTextPromptFrame.TitleArea.Title:SetText("")
            InteractionTextPromptFrame.InputArea.InputBox:SetText("")

			--------------------------------

            InteractionTextPromptFrame.ButtonArea.Button1:Hide()
            InteractionTextPromptFrame.ButtonArea.Button1:SetText("")
            InteractionTextPromptFrame.ButtonArea.Button1.Callback = nil

			--------------------------------

            InteractionTextPromptFrame.HideWithAnimation()
        end
    end

    --------------------------------
    -- FUNCTIONS (ANIMATION)
    --------------------------------

    do
        InteractionTextPromptFrame.ShowWithAnimation = function()
            InteractionTextPromptFrame:Show()
            InteractionTextPromptFrame.hidden = false

            AdaptiveAPI.Animation:Fade(InteractionTextPromptFrame, .25, 0, 1, nil, function() return InteractionTextPromptFrame.hidden end)
            if DB_GLOBAL.profile.INT_UIDIRECTION == 1 then
                AdaptiveAPI.Animation:Move(InteractionTextPromptFrame, .5, "CENTER", -25, 0, "y", AdaptiveAPI.Animation.EaseExpo, function() return InteractionTextPromptFrame.hidden end)
            else
                AdaptiveAPI.Animation:Move(InteractionTextPromptFrame, .5, "CENTER", -25, 0, "y", AdaptiveAPI.Animation.EaseExpo, function() return InteractionTextPromptFrame.hidden end)
            end
        end

        InteractionTextPromptFrame.HideWithAnimation = function()
            addon.Libraries.AceTimer:ScheduleTimer(function()
                InteractionTextPromptFrame:Hide()
            end, .5)
            InteractionTextPromptFrame.hidden = true

            AdaptiveAPI.Animation:Fade(InteractionTextPromptFrame, .25, InteractionTextPromptFrame:GetAlpha(), 0, nil, function() return not InteractionTextPromptFrame.hidden end)
            if DB_GLOBAL.profile.INT_UIDIRECTION == 1 then
                AdaptiveAPI.Animation:Move(InteractionTextPromptFrame, .5, "CENTER", 0, -25, "y", AdaptiveAPI.Animation.EaseExpo, function() return not InteractionTextPromptFrame.hidden end)
            else
                AdaptiveAPI.Animation:Move(InteractionTextPromptFrame, .5, "CENTER", 0, -25, "y", AdaptiveAPI.Animation.EaseExpo, function() return not InteractionTextPromptFrame.hidden end)
            end
        end
    end

    --------------------------------
    -- SETTINGS
    --------------------------------

    do
        local function Settings_UIDirection()
            InteractionTextPromptFrame:ClearAllPoints()
            if DB_GLOBAL.profile.INT_UIDIRECTION == 1 then
                InteractionTextPromptFrame:SetPoint("CENTER", UIParent, 0, 0)
            else
                InteractionTextPromptFrame:SetPoint("CENTER", UIParent, 0, 0)
            end
        end
        Settings_UIDirection()

        --------------------------------

        CallbackRegistry:Add("SETTINGS_UIDIRECTION_CHANGED", Settings_UIDirection)
    end

    --------------------------------
    -- EVENTS
    --------------------------------

    do
        InteractionTextPromptFrame:SetPropagateKeyboardInput(true)
        InteractionTextPromptFrame:SetScript("OnKeyDown", function(_, key)
            local function PreventInput()
                addon.API:PreventInput(InteractionTextPromptFrame)
            end

            if key == "ESCAPE" then
                PreventInput()

                InteractionTextPromptFrame.HideWithAnimation()
            end
        end)
    end
end
