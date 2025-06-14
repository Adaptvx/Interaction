---@class addon
local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local PrefabRegistry = addon.PrefabRegistry
local L = addon.Locales
local NS = addon.SettingsUI; addon.SettingsUI = NS

--------------------------------

NS.Utils = {}

--------------------------------

function NS.Utils:Load()
	--------------------------------
	-- PROMPTS
	--------------------------------

	function NS.Utils:Prompt_Reload()
		addon.Prompt.Script:Set(L["Prompt - Reload"], L["Prompt - Reload Button 1"], L["Prompt - Reload Button 2"],
			function()
				ReloadUI()
			end,
			function()
				addon.Prompt.Script:Clear()
			end, true, false
		)
	end

	function NS.Utils:Prompt_Confirm(text, button1Text, button2Text, confirmCallback)
		addon.Prompt.Script:Set(text, button1Text, button2Text,
			function()
				confirmCallback()
			end,
			function()
				addon.Prompt.Script:Clear()
			end, false, true
		)
	end

	function NS.Utils:Prompt_Clear()
		addon.Prompt.Script:Clear()
	end

	--------------------------------
	-- MOUSE
	--------------------------------

	function NS.Utils.SetPreventMouse(value)
		InteractionSettingsFrame.PreventMouse = value
	end
end
