local addonName, addon = ...
local NS = addon.CallbackRegistry
local L = addon.Locales

--------------------------------
-- VARIABLES
--------------------------------

addon.CallbackRegistry = {}
local NS = addon.CallbackRegistry

do -- MAIN
	NS.callbacks = {}
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
		-- Adds a function to a callback category.
		---@param name string
		---@param func function
		---@param priority? number: Higher priority runs later. Priority with -1 is ALWAYS run first. Default is run after .5s.
		function NS:Add(name, func, priority)
			if NS.callbacks[name] == nil then
				NS.callbacks[name] = {}
			end

			local callback = {
				func = func,
				priority = priority
			}

			table.insert(NS.callbacks[name], callback)
		end

		-- Triggers all functions in a callback category.
		---@param name string
		---@param arg1? any
		---@param arg2? any
		---@param arg3? any
		---@param arg4? any
		---@param arg5? any
		function NS:Trigger(name, arg1, arg2, arg3, arg4, arg5)
			if not NS.callbacks[name] then
				return
			end

			--------------------------------

			table.sort(NS.callbacks[name], function(a, b)
				return (a.priority or 0) < (b.priority or 0)
			end)

			for _, callback in ipairs(NS.callbacks[name]) do
				local func = callback.func
				func(arg1, arg2, arg3, arg4, arg5)
			end
		end
	end
end
