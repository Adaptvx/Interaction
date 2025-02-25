local addonName, addon = ...
local NS = addon.PrefabRegistry
local L = addon.Locales

--------------------------------
-- VARIABLES
--------------------------------

addon.PrefabRegistry = {}
local NS = addon.PrefabRegistry

do -- MAIN
	NS.Prefabs = {}
end

do -- CONSTANTS

end

--------------------------------
-- FUNCTIONS (MAIN)
--------------------------------

function NS:Load()
	--------------------------------
	-- FUNCTIONS (MAIN)
	--------------------------------

	do
		-- Adds a prefab (function under the identifier name to create an element) to the registry. It can be created with [addon.PrefabRegistry:Create(...)].
		---@param id string
		---@param prefabFunc function
		function NS:Add(id, prefabFunc)
			if NS.Prefabs[id] == nil then
				NS.Prefabs[id] = prefabFunc
			end
		end

		function NS:Create(id, ...)
			if NS.Prefabs[id] then
				return NS.Prefabs[id](...)
			end
		end
	end
end
