---@class addon
local addon = select(2, ...)
local L = addon.Locales

--------------------------------
-- VARIABLES
--------------------------------

addon.PrefabRegistry = {}
local NS = addon.PrefabRegistry; addon.PrefabRegistry = NS

do -- MAIN
	NS.Prefabs = {}
	NS.PrefabVariables = {}
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
		-- Adds a prefab (function under the identifier name to create an element) to the registry. It can be created with [addon.PrefabRegistry:Create(id, ...)].
		---@param id string
		---@param prefabFunc function
		function NS:Add(id, prefabFunc)
			if NS.Prefabs[id] == nil then
				NS.Prefabs[id] = prefabFunc
			end
		end

		-- Creates an element using the prefab under the identifier name.
		---@param id string
		---@param ... any
		function NS:Create(id, ...)
			if NS.Prefabs[id] then
				return NS.Prefabs[id](...)
			end
		end

		-- Adds a variable table for the prefab under the identifier name.
		---@param id string
		---@param varTable table
		function NS:AddVariableTable(id, varTable)
			if NS.PrefabVariables[id] == nil then
				NS.PrefabVariables[id] = varTable
			end
		end

		-- Gets a variable table for the prefab under the identifier name.
		---@param id string
		---@return table
		function NS:GetVariableTable(id)
			return NS.PrefabVariables[id]
		end
	end
end
