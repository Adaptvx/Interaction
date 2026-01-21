local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry

addon.Initialize = {}
local NS = addon.Initialize; addon.Initialize = NS

NS.QueuedForInitalization = false
NS.Initalized = false
NS.Ready = false

function NS:Load()
    function NS:LoadCode()
        C_Timer.After(.1, function()
            addon.InteractionFrame:Load()
            addon.Modules:Load()
            addon.Support:Load()
            CallbackRegistry:Trigger("THEME_UPDATE")
            C_Timer.After(2.5, function()
                CallbackRegistry:Trigger("THEME_UPDATE")
            end)
            C_Timer.After(2.5, function()
                NS.Ready = true
                CallbackRegistry:Trigger("ADDON_READY")
            end)
        end)
    end

    function NS:Initalize()
        if InCombatLockdown() then
            NS.QueuedForInitalization = true
            return
        end
        NS.QueuedForInitalization = false
        if NS.Initalized then return end
        NS.Initalized = true
        addon.Database.DB_GLOBAL.profile.LastLoadedSession = GetTime()
        NS:LoadCode()
    end

    local f = CreateFrame("Frame")
    f:RegisterEvent("PLAYER_REGEN_ENABLED")
    f:SetScript("OnEvent", function(_, event, ...)
        if NS.QueuedForInitalization then
            if event == "PLAYER_REGEN_ENABLED" then
                if not InCombatLockdown() then
                    NS:Initalize()
                    f:UnregisterEvent("PLAYER_REGEN_ENABLED")
                end
            end
        end
    end)

    NS:Initalize()
end
