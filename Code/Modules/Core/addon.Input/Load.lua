---@class addon
local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local L = addon.Input

--------------------------------

addon.Input = {}
local NS = addon.Input; addon.Input = NS

--------------------------------

function NS:Load()
	local function Modules()
		NS.Script:Load()
		NS.Navigation:Load()
	end

	--------------------------------

	Modules()
end
