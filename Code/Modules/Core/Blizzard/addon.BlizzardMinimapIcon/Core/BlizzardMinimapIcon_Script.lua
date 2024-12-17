local addonName, addon = ...
local CallbackRegistry = addon.CallbackRegistry
local L = addon.Locales
local NS = addon.BlizzardMinimapIcon

--------------------------------

NS.Script = {}

--------------------------------

function NS.Script:Load()
	--------------------------------
	-- REFERENCES
	--------------------------------

	local Icon = NS.Variables.Icon
	local Callback = NS.Script

    --------------------------------
    -- FUNCTIONS (FRAME)
    --------------------------------

    do
        function NS.Script:Show()
            Icon:Show("Interaction")
        end

        function NS.Script:Hide()
            Icon:Hide("Interaction")
        end
    end

    --------------------------------
    -- FUNCTIONS (ANIMATION)
    --------------------------------

    --------------------------------
    -- SETTINGS
    --------------------------------

    do
        local function Settings_MinimapIcon()
			local Settings_Readable = INTDB.profile.INT_READABLE
            local Settings_MinimapIcon = INTDB.profile.INT_MINIMAP

            if Settings_Readable and Settings_MinimapIcon then
                NS.Script:Show()
            else
                NS.Script:Hide()
            end
        end
        Settings_MinimapIcon()

        --------------------------------

        CallbackRegistry:Add("SETTINGS_MINIMAP_CHANGED", Settings_MinimapIcon, 2)
		CallbackRegistry:Add("SETTING_CHANGED", Settings_MinimapIcon, 2)
    end

    --------------------------------
    -- EVENTS
    --------------------------------

    --------------------------------
    -- SETUP
    --------------------------------
end
