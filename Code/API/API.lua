local addonName, addon = ...
local CallbackRegistry = addon.CallbackRegistry
local L = addon.Locales

--------------------------------
-- VARIABLES
--------------------------------

addon.API = {}
local NS = addon.API

do -- MAIN
	NS.UIScale = .75
end

do -- CONSTANTS

end

--------------------------------
-- AUDIO
--------------------------------

do

end

--------------------------------
-- NPC INTERACTION
--------------------------------

do
	local INTERACT_GOSSIP = Enum.PlayerInteractionType and Enum.PlayerInteractionType.Gossip or 3;
	local INTERACT_QUEST = Enum.PlayerInteractionType and Enum.PlayerInteractionType.QuestGiver or 4;

	function NS:IsNPCGossip()
		return C_PlayerInteractionManager.IsInteractingWithNpcOfType(INTERACT_GOSSIP)
	end

	function NS:IsNPCQuest()
		return C_PlayerInteractionManager.IsInteractingWithNpcOfType(INTERACT_QUEST)
	end

	function NS:IsNPCQuestOrGossip()
		return (NS:IsNPCGossip() or NS:IsNPCQuest())
	end
end

--------------------------------
-- PLATFORM
--------------------------------

do
	function NS:SetButtonToPlatform(frame, buttonType, preventExpand, text, textOnly)
		if not preventExpand then
			frame:SetWidth(frame:GetWidth() + 20)
			frame:SetHeight(frame:GetHeight() + 5)
		end

		if buttonType == "Decline" then
			frame:HookScript("OnClick", function()
				addon.Interaction.Script:Stop(true)
			end)
		end

		local PlatformIcon
		if addon.Variables.Platform == 1 then
			if buttonType == "Accept" then
				if INTDB.profile.INT_USEINTERACTKEY then
					if textOnly then
						PlatformIcon = addon.Variables.PATH .. "Art/Platform/Text-Platform-PC-Interact.png"
					else
						PlatformIcon = addon.Variables.PATH .. "Art/Platform/Platform-PC-Interact.png"
					end
				else
					if textOnly then
						PlatformIcon = addon.Variables.PATH .. "Art/Platform/Text-Platform-PC-Space.png"
					else
						PlatformIcon = addon.Variables.PATH .. "Art/Platform/Platform-PC-Space.png"
					end
				end
			end

			if buttonType == "Decline" then
				if textOnly then
					PlatformIcon = addon.Variables.PATH .. "Art/Platform/Text-Platform-PC-Esc.png"
				else
					PlatformIcon = addon.Variables.PATH .. "Art/Platform/Platform-PC-Esc.png"
				end
			end
		end

		if addon.Variables.Platform == 2 then
			if buttonType == "Accept" then
				if textOnly then
					PlatformIcon = addon.Variables.PATH .. "Art/Platform/Text-Platform-PS-3.png"
				else
					PlatformIcon = addon.Variables.PATH .. "Art/Platform/Platform-PS-3.png"
				end
			end

			if buttonType == "Decline" then
				if textOnly then
					PlatformIcon = addon.Variables.PATH .. "Art/Platform/Text-Platform-PS-1.png"
				else
					PlatformIcon = addon.Variables.PATH .. "Art/Platform/Platform-PS-1.png"
				end
			end
		end

		if addon.Variables.Platform == 3 then
			if buttonType == "Accept" then
				if textOnly then
					PlatformIcon = addon.Variables.PATH .. "Art/Platform/Text-Platform-XBOX-2.png"
				else
					PlatformIcon = addon.Variables.PATH .. "Art/Platform/Platform-XBOX-2.png"
				end
			end

			if buttonType == "Decline" then
				if textOnly then
					PlatformIcon = addon.Variables.PATH .. "Art/Platform/Text-Platform-XBOX-1.png"
				else
					PlatformIcon = addon.Variables.PATH .. "Art/Platform/Platform-XBOX-1.png"
				end
			end
		end

		if addon.Variables.Platform == 2 or addon.Variables.Platform == 3 then
			if buttonType == "PromptAccept" then
				PlatformIcon = addon.Variables.PATH .. "Art/Platform/Platform-LB.png"
			end

			if buttonType == "PromptDecline" then
				PlatformIcon = addon.Variables.PATH .. "Art/Platform/Platform-RB.png"
			end
		end

		local Text
		if text then
			Text = text
		else
			Text = _G[frame:GetDebugName() .. "Text"]
		end

		Text:SetTextColor(1, 1, 1)
		Text:SetText(((PlatformIcon and AdaptiveAPI:InlineIcon(PlatformIcon, 30, 30, 0, 0) .. "  ") or "") .. Text:GetText())
	end
end

--------------------------------
-- ANIMATION
--------------------------------

do
	function NS:StopTextPlayback(textFrame)
		if textFrame.TextAnimationFrame then
			textFrame.TextAnimationFrame:SetScript("OnUpdate", nil)

			--------------------------------

			if textFrame.TextAnimationCallbackTimer then
				addon.Libraries.AceTimer:CancelTimer(textFrame.TextAnimationCallbackTimer)
			end
		end
	end

	function NS:StartTextPlayback(frame, interval, callback, callbackDelay, skipAnimation, usePausing)
		local text = frame:GetText() or ""
		local textLength = strlenutf8(text)
		local pauseDuration = .125
		local timer = 0
		local paused = false
		local pauseTimer = 0

		local pauseCharsDB = {
			"!",
			"?",
			".",
			",",
			"--"
		}

		--------------------------------

		frame.TextAnimationFrame = frame.TextAnimationFrame or CreateFrame("Frame", "$parent.TextAnimationFrame", nil)

		--------------------------------

		local function GetTextColor()
			local color

			--------------------------------

			if addon.Theme.IsDarkTheme_Dialog or (addon.Theme.IsDarkTheme and addon.Interaction.Dialog.Variables.IsScrollDialog) then
				color = { r = 1, g = 1, b = 1 }
			elseif not addon.Theme.IsDarkTheme_Dialog and not addon.Interaction.Dialog.Variables.IsScrollDialog then
				color = { r = 1, g = .87, b = .67 }
			elseif addon.Theme.IsStylisedTheme_Dialog then
				color = { r = 1, g = .87, b = .67 }
			elseif not addon.Theme.IsDarkTheme and addon.Interaction.Dialog.Variables.IsScrollDialog then
				color = { r = .1, g = .1, b = .1 }
			end

			--------------------------------

			return color
		end

		local function GetColor(textColor, isMouseOver)
			local color

			--------------------------------

			if INTDB.profile.INT_CONTENT_PREVIEW_ALPHA <= .1 then
				if addon.Theme.IsDarkTheme_Dialog or not addon.Theme.IsDarkTheme_Dialog and not addon.Interaction.Dialog.Variables.IsScrollDialog then
					color = isMouseOver and "181818" or "171717"
				elseif addon.Theme.IsStylisedTheme_Dialog then
					color = "000000"
				elseif not addon.Theme.IsDarkTheme and addon.Interaction.Dialog.Variables.IsScrollDialog then
					color = "AA906C"
				elseif addon.Theme.IsDarkTheme and addon.Interaction.Dialog.Variables.IsScrollDialog then
					color = isMouseOver and "303030" or "303030"
				end
			else
				local modifier = .2 + (INTDB.profile.INT_CONTENT_PREVIEW_ALPHA / 1.25)
				if not addon.Theme.IsDarkTheme and addon.Interaction.Dialog.Variables.IsScrollDialog then
					return AdaptiveAPI:SetHexColorFromModifierWithBase(AdaptiveAPI:GetHexColor(textColor.r, textColor.g, textColor.b), modifier, "AA906C")
				else
					return AdaptiveAPI:SetHexColorFromModifier(AdaptiveAPI:GetHexColor(textColor.r, textColor.g, textColor.b), modifier)
				end
			end

			--------------------------------

			return color
		end

		--------------------------------

		local function Update(self, elapsed)
			if paused then
				pauseTimer = pauseTimer + elapsed

				--------------------------------

				if pauseTimer >= pauseDuration then
					paused = false
					pauseTimer = 0
				else
					return
				end
			end

			--------------------------------

			timer = timer + elapsed

			--------------------------------

			local numCharsToShow = math.min(math.floor(timer / interval) + 1, textLength)
			local current = AdaptiveAPI:GetSubstring(text, 1, numCharsToShow)
			local remaining = AdaptiveAPI:GetSubstring(text, numCharsToShow + 1, textLength)
			local new

			local textColor = GetTextColor()
			local color = GetColor(textColor, frame.mouseOver)

			--------------------------------

			local function ShouldPause()
				if usePausing then
					local lastChar = AdaptiveAPI:GetSubstring(text, numCharsToShow, numCharsToShow)

					--------------------------------

					for char = 1, #pauseCharsDB do
						if AdaptiveAPI:FindString(pauseCharsDB[char], lastChar) then
							paused = true
							break
						else
							paused = false
						end
					end
				end
			end

			local function SetNewText()
				if strlenutf8(remaining) > 0 and not frame.freezePlayback then
					new = current .. "|cff" .. color .. remaining .. "|r"
				else
					new = current .. remaining
				end
			end

			--------------------------------

			ShouldPause()
			SetNewText()

			--------------------------------

			if not skipAnimation then
				frame:SetText(new)
				frame.currentText = new
			end

			--------------------------------

			if numCharsToShow >= textLength then
				frame.TextAnimationFrame:SetScript("OnUpdate", nil)

				--------------------------------

				if callback then
					if callbackDelay then
						frame.TextAnimationCallbackTimer = addon.Libraries.AceTimer:ScheduleTimer(function()
							callback()
						end, callbackDelay)
					else
						callback()
					end
				end
			end
		end

		frame.TextAnimationFrame:SetScript("OnUpdate", Update)
	end
end

--------------------------------
-- UTILITIES
--------------------------------

do
	function NS:PreventInput(frame)
		if not InCombatLockdown() then
			frame:SetPropagateKeyboardInput(false)

			addon.Libraries.AceTimer:ScheduleTimer(function()
				if not InCombatLockdown() then
					frame:SetPropagateKeyboardInput(true)
				end
			end, 0)

			if not frame.Registered then
				frame.Registered = true

				frame:RegisterEvent("PLAYER_REGEN_DISABLED")
				frame:SetScript("OnEvent", function(self, event, ...)
					if event == "PLAYER_REGEN_DISABLED" then
						frame:SetPropagateKeyboardInput(true)
					end
				end)
			end
		end
	end

	function NS:GetDarkTheme()
		return addon.Theme.IsDarkTheme
	end

	function NS:PreventRepeatCall(frame, delay, func)
		local id = GetTime()
		frame.id = id

		addon.Libraries.AceTimer:ScheduleTimer(function()
			if frame.id == id then
				func()
			end
		end, delay)
	end

	function NS:RegisterThemeUpdate(func, priority)
		CallbackRegistry:Add("THEME_UPDATE", func, priority)

		func()
	end

	function NS:IsElementInScrollFrame(scrollFrame, element)
		local scrollFrameLeft = scrollFrame:GetLeft()
		local scrollFrameRight = scrollFrame:GetRight()
		local scrollFrameTop = scrollFrame:GetTop()
		local scrollFrameBottom = scrollFrame:GetBottom()

		local elementLeft = element:GetLeft()
		local elementRight = element:GetRight()
		local elementTop = element:GetTop()
		local elementBottom = element:GetBottom()

		return (
			elementLeft and elementRight and elementTop and elementBottom and

			elementRight > scrollFrameLeft - element:GetWidth() and
			elementLeft < scrollFrameRight + element:GetWidth() and
			elementBottom > scrollFrameBottom - element:GetHeight() and
			elementTop < scrollFrameTop + element:GetHeight()
		)
	end

	-- Return Screen Width based on Interaction's UI Scale
	function NS:GetScreenWidth()
		return WorldFrame:GetWidth() / NS.UIScale
	end

	-- Return Screen Height based on Interaction's UI Scale
	function NS:GetScreenHeight()
		return WorldFrame:GetHeight() / NS.UIScale
	end
end

--------------------------------
-- HANDLE UI
--------------------------------

do
	function NS:SetupUICheck()
		local IsInCutscene = false

		local _ = CreateFrame("Frame", "UpdateFrame/API.lua -- SetupUICheck", nil)
		_:RegisterEvent("CINEMATIC_START")
		_:RegisterEvent("PLAY_MOVIE")
		_:RegisterEvent("STOP_MOVIE")
		_:RegisterEvent("CINEMATIC_STOP")
		_:SetScript("OnEvent", function(_, event)
			if event == "CINEMATIC_START" or event == "PLAY_MOVIE" then
				IsInCutscene = true

				if INTDB.profile.INT_HIDEUI then
					if InteractionPriorityFrame then
						addon.BlizzardFrames.Script:RemoveElements()
					end
				end
			end

			if event == "STOP_MOVIE" or event == "CINEMATIC_STOP" then
				IsInCutscene = false

				if INTDB.profile.INT_HIDEUI then
					if InteractionPriorityFrame then
						addon.BlizzardFrames.Script:SetElements()
					end
				end
			end
		end)

		function NS:CanShowUIAndHideElements()
			local result = not C_PlayerInteractionManager.IsInteractingWithNpcOfType(57) and not IsInCutscene

			if InteractionPriorityFrame then
				if result == true then
					addon.BlizzardFrames.Script:SetElements()
				else
					addon.BlizzardFrames.Script:RemoveElements()
				end
			end

			return result
		end
	end

	NS:SetupUICheck()
end
