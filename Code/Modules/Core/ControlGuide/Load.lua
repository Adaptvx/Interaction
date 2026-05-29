local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local TemplateRegistry = addon.TemplateRegistry
local L = addon.Locales

addon.ControlGuide = {}
local NS = addon.ControlGuide; addon.ControlGuide = NS

function NS:Load()
	local function Modules()
		NS.Elements:Load()
		NS.Script:Load()
	end

	local function Templates()
		NS.Templates:Load()
	end

	Templates()
	Modules()
end
