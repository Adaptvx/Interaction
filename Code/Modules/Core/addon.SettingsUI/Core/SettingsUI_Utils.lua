local addonName, addon = ...
local CallbackRegistry = addon.CallbackRegistry
local L = addon.Locales
local NS = addon.SettingsUI

--------------------------------

NS.Utils = {}

--------------------------------

function NS.Utils:Load()
	--------------------------------
	-- PROMPTS
	--------------------------------

	function NS.Utils.ReloadPrompt()
		InteractionPromptFrame.Set(L["Prompt - Reload"], L["Prompt - Reload Button 1"], L["Prompt - Reload Button 2"],
			function()
				ReloadUI()
			end,
			function()
				InteractionPromptFrame.Clear()
			end, true, false
		)
	end

	function NS.Utils.ConfirmationPrompt(text, button1Text, button2Text, confirmCallback)
		InteractionPromptFrame.Set(text, button1Text, button2Text,
			function()
				confirmCallback()
			end,
			function()
				InteractionPromptFrame.Clear()
			end, false, true
		)
	end

	function NS.Utils.ClearPrompt()
		InteractionPromptFrame.Clear()
	end

	--------------------------------
	-- MOUSE
	--------------------------------

	function NS.Utils.SetPreventMouse(value)
		InteractionSettingsFrame.PreventMouse = value
	end
end
