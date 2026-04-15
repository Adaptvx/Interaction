local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry

addon.EventListener = {}
local NS = addon.EventListener; addon.EventListener = NS

function NS:Load()
    local f = CreateFrame("Frame")
    f:RegisterEvent("UI_SCALE_CHANGED")
    f:SetScript("OnEvent", function(self, event, ...)
        if event == "UI_SCALE_CHANGED" then
            CallbackRegistry:Trigger("BLIZZARD_SETTINGS_RESOLUTION_CHANGED")
        end
    end)
end
