---@class addon
local addon = select(2, ...)
local L = addon.Locales

--------------------------------
-- VARIABLES
--------------------------------

addon.CallbackRegistry = {}
local NS = addon.CallbackRegistry; addon.CallbackRegistry = NS

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
		---@param id string
		---@param func function
		---@param priority? number: Higher priority runs later. Priority with -1 is ALWAYS run first. Default is run after .5s.
		function NS:Add(id, func, priority)
			if NS.callbacks[id] == nil then
				NS.callbacks[id] = {}
			end

			local callback = {
				func = func,
				priority = priority
			}

			table.insert(NS.callbacks[id], callback)
		end

		-- Triggers all functions in a callback category.
		---@param id string
		function NS:Trigger(id, ...)
			if not NS.callbacks[id] then
				return
			end

			--------------------------------

			table.sort(NS.callbacks[id], function(a, b)
				return (a.priority or 0) < (b.priority or 0)
			end)

			for _, callback in ipairs(NS.callbacks[id]) do
				local func = callback.func
				func(...)
			end
		end
	end
end
