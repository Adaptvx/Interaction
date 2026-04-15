local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local TemplateRegistry = addon.TemplateRegistry
local L = addon.Locales

addon.HideUI = {}
local NS = addon.HideUI; addon.HideUI = NS

function NS:Load()
	local function Modules()
		NS.Script:Load()
	end

	Modules()
end
