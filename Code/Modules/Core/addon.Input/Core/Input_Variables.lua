---@class addon
local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local PrefabRegistry = addon.PrefabRegistry
local L = addon.Locales
local NS = addon.Input; addon.Input = NS

--------------------------------

NS.Variables = {}

--------------------------------
-- VARIABLES
--------------------------------

do -- MAIN
	do -- INPUT DEVICE
		NS.Variables.SimulateController = false -- DEBUG // Simulate controller navigation with keyboard shortcuts.
		NS.Variables.IsControllerEnabled = false

		NS.Variables.IsController = nil
		NS.Variables.IsPlaystation = nil
		NS.Variables.IsXbox = nil
		NS.Variables.IsPC = nil

		--------------------------------

		do -- LOGIC
			do -- FUNCTIONS
				function NS.Variables:UpdatePlatform()
					NS.Variables.IsController = (addon.Variables.Platform == 2 or addon.Variables.Platform == 3)
					NS.Variables.IsPlaystation = (addon.Variables.Platform == 2)
					NS.Variables.IsXbox = (addon.Variables.Platform == 3)
					NS.Variables.IsPC = (addon.Variables.Platform == 1)
				end
			end
		end
	end

	do -- NAVIGATION
		NS.Variables.IsNavigating = false
		NS.Variables.PreviousFrame = nil
		NS.Variables.CurrentFrame = nil
	end

	do -- KEYBINDING
		NS.Variables.Key_Skip = nil
		NS.Variables.Key_Close = nil
		NS.Variables.Key_Next = nil
		NS.Variables.Key_Previous = nil
		NS.Variables.Key_Progress = nil
		NS.Variables.Key_Prompt_Accept = nil
		NS.Variables.Key_Prompt_Decline = nil
		NS.Variables.Key_Quest_NextReward = nil

		-- Navigation
		NS.Variables.Key_MoveUp = { [1] = "W", [2] = "PADDUP" }
		NS.Variables.Key_MoveLeft = { [1] = "A", [2] = "PADDLEFT" }
		NS.Variables.Key_MoveRight = { [1] = "D", [2] = "PADDRIGHT" }
		NS.Variables.Key_MoveDown = { [1] = "S", [2] = "PADDDOWN" }
		NS.Variables.Key_ScrollUp = { [1] = "UP", [2] = "PADDUP" }
		NS.Variables.Key_ScrollDown = { [1] = "DOWN", [2] = "PADDDOWN" }
		NS.Variables.Key_Interact = { [1] = "SPACE", [2] = "PAD1" }

		NS.Variables.Key_Settings_Toggle = { [1] = "", [2] = "PADFORWARD" }
		NS.Variables.Key_Settings_ChangeTabUp = { [1] = "", [2] = "PADRSHOULDER" }
		NS.Variables.Key_Settings_ChangeTabDown = { [1] = "", [2] = "PADLSHOULDER" }
		NS.Variables.Key_Settings_SpecialInteract1 = { [1] = "", [2] = "PADDRIGHT" }
		NS.Variables.Key_Settings_SpecialInteract2 = { [1] = "", [2] = "PADDLEFT" }
		NS.Variables.Key_Settings_SpecialInteract3 = { [1] = "", [2] = "PAD1" }

		--------------------------------

		do -- LOGIC
			function NS.Variables:UpdateKeybinds()
				do -- MAIN
					NS.Variables.Key_Close = { [1] = addon.Database.DB_GLOBAL.profile.INT_KEY_CLOSE, [2] = "PAD2" }
					NS.Variables.Key_Next = { [1] = addon.Database.DB_GLOBAL.profile.INT_KEY_NEXT, [2] = "PADRTRIGGER" }
					NS.Variables.Key_Previous = { [1] = addon.Database.DB_GLOBAL.profile.INT_KEY_PREVIOUS, [2] = "PADLTRIGGER" }
					NS.Variables.Key_Prompt_Accept = { [1] = addon.Database.DB_GLOBAL.profile.INT_KEY_PROMPT_ACCEPT, [2] = "PADLSHOULDER" }
					NS.Variables.Key_Prompt_Decline = { [1] = addon.Database.DB_GLOBAL.profile.INT_KEY_PROMPT_DECLINE, [2] = "PADRSHOULDER" }
					NS.Variables.Key_Quest_NextReward = { [1] = addon.Database.DB_GLOBAL.profile.INT_KEY_QUEST_NEXTREWARD, [2] = nil }
				end

				do -- INTERACT KEY
					if addon.Database.DB_GLOBAL.profile.INT_USEINTERACTKEY then
						NS.Variables.Key_Skip = { [1] = GetBindingKey("INTERACTTARGET"), [2] = GetBindingKey("INTERACTTARGET") }
						NS.Variables.Key_Progress = { [1] = GetBindingKey("INTERACTTARGET"), [2] = GetBindingKey("INTERACTTARGET") }
					else
						NS.Variables.Key_Skip = { [1] = addon.Database.DB_GLOBAL.profile.INT_KEY_PROGRESS, [2] = "PAD1" }
						NS.Variables.Key_Progress = { [1] = addon.Database.DB_GLOBAL.profile.INT_KEY_PROGRESS, [2] = "PAD1" }
					end
				end
			end

			function NS.Variables:GetKeybindForPlatform(variable)
				if NS.Variables.IsPC then
					return variable[1]
				else
					return variable[2]
				end
			end

			function NS.Variables:IsKey(key, keyTable)
				for i = 1, #keyTable do
					if key == keyTable[i] then
						return true
					end
				end

				--------------------------------

				return false
			end

			CallbackRegistry:Add("KEYBIND_CHANGED", NS.Variables.UpdateKeybinds, 0)
		end
	end
end

do -- CONSTANTS
	NS.Variables.PATH = addon.Variables.PATH_ART .. "Controller/"
end

--------------------------------
-- EVENTS
--------------------------------

--------------------------------
-- SETUP
--------------------------------

do
	CallbackRegistry:Add("ADDON_DATABASE_READY", function()
		NS.Variables:UpdatePlatform()
		NS.Variables:UpdateKeybinds()
	end, 0)
end
