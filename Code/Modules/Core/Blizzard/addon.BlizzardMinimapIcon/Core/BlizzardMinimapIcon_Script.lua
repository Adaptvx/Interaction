---@class addon
local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local PrefabRegistry = addon.PrefabRegistry
local L = addon.Locales
local NS = addon.BlizzardMinimapIcon; addon.BlizzardMinimapIcon = NS

--------------------------------

NS.Script = {}

--------------------------------

function NS.Script:Load()
	--------------------------------
	-- REFERENCES
	--------------------------------

	local Icon = NS.Variables.Icon
	local Callback = NS.Script; NS.Script = Callback

	--------------------------------
	-- FUNCTIONS (FRAME)
	--------------------------------

	do
		function NS.Script:OnTooltipShow(tooltip)
			local numEntries_local = addon.API.Util:tnum(addon.Readable.Variables.LIBRARY_LOCAL)
			local numEntries_global = addon.API.Util:tnum(addon.Readable.Variables.LIBRARY_GLOBAL)

			local text_title = L["MinimapIcon - Tooltip - Title"]
			local text_entries_local
			local text_entries_global

			--------------------------------

			do -- LOCAL
				local playerName = UnitName("player")

				--------------------------------

				if numEntries_local == 1 then
					local name = L["Readable - Library - Name Text - Local - Subtext 1"] .. playerName .. L["Readable - Library - Name Text - Local - Subtext 2"]
					local info = L["MinimapIcon - Tooltip - Entries - Singular - Subtext 1"] .. numEntries_local .. L["MinimapIcon - Tooltip - Entries - Singular - Subtext 2"]

					text_entries_local = name .. ": " .. "|cffFFFFFF" .. info .. "|r"
				elseif numEntries_local > 1 then
					local name = L["Readable - Library - Name Text - Local - Subtext 1"] .. playerName .. L["Readable - Library - Name Text - Local - Subtext 2"]
					local info = L["MinimapIcon - Tooltip - Entries - Subtext 1"] .. numEntries_local .. L["MinimapIcon - Tooltip - Entries - Subtext 2"]

					text_entries_local = name .. ": " .. "|cffFFFFFF" .. info .. "|r"
				else
					local name = L["Readable - Library - Name Text - Local - Subtext 1"] .. playerName .. L["Readable - Library - Name Text - Local - Subtext 2"]
					local info = L["MinimapIcon - Tooltip - Entries - Empty"]

					text_entries_local = name .. ": " .. "|cffFFFFFF" .. info .. "|r"
				end
			end

			do -- GLOBAL
				if numEntries_global == 1 then
					local name = L["Readable - Library - Name Text - Global"]
					local info = L["MinimapIcon - Tooltip - Entries - Singular - Subtext 1"] .. numEntries_global .. L["MinimapIcon - Tooltip - Entries - Singular - Subtext 2"]

					text_entries_global = name .. ": " .. "|cffFFFFFF" .. info .. "|r"
				elseif numEntries_global > 1 then
					local name = L["Readable - Library - Name Text - Global"]
					local info = L["MinimapIcon - Tooltip - Entries - Subtext 1"] .. numEntries_global .. L["MinimapIcon - Tooltip - Entries - Subtext 2"]

					text_entries_global = name .. ": " .. "|cffFFFFFF" .. info .. "|r"
				else
					local name = L["Readable - Library - Name Text - Global"]
					local info = L["MinimapIcon - Tooltip - Entries - Empty"]

					text_entries_global = name .. ": " .. "|cffFFFFFF" .. info .. "|r"
				end
			end

			--------------------------------

			tooltip:AddLine(text_title)
			tooltip:AddLine(text_entries_local)
			tooltip:AddLine(text_entries_global)
		end

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
			local Settings_Readable = addon.Database.DB_GLOBAL.profile.INT_READABLE
			local Settings_MinimapIcon = addon.Database.DB_GLOBAL.profile.INT_MINIMAP

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
