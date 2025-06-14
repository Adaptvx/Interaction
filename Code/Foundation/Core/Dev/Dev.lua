---@class addon
local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local PrefabRegistry = addon.PrefabRegistry
local L = addon.Locales

--------------------------------
-- VARIABLES
--------------------------------

addon._DEV = {}
local NS = addon._DEV; addon._DEV = NS

do -- MAIN

end

do -- CONSTANTS
	NS.ENABLED = false
end

--------------------------------
-- FUNCTIONS (MAIN)
--------------------------------

function NS:Load()
	--------------------------------
	-- FUNCTIONS (MAIN)
	--------------------------------

	do
		function addon._DEV:Print(msg)
			if addon._DEV.ENABLED then
				print(msg)
			end
		end
	end

	--------------------------------
	-- EVENTS
	--------------------------------

	do

	end

	--------------------------------
	-- SETUP
	--------------------------------

	do

	end
end
