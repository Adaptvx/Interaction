local addon = select(2, ...)
local L = addon.Locales

-- Variables
----------------------------------------------------------------------------------------------------

addon.CallbackRegistry = {}
local NS = addon.CallbackRegistry; addon.CallbackRegistry = NS

do -- Main
	NS.callbacks = {}
end


function NS:Load()

	-- Main
	----------------------------------------------------------------------------------------------------

	do

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

		function NS:Trigger(id, ...)
			if not NS.callbacks[id] then
				return
			end

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
