---@class addon
local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local PrefabRegistry = addon.PrefabRegistry
local L = addon.Locales

--------------------------------
-- VARIABLES
--------------------------------

addon.API.Main = {}
local NS = addon.API.Main; addon.API.Main = NS

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

	function NS:IsAutoAccept()
		if not addon.Variables.IS_WOW_VERSION_CLASSIC_ALL then
			return QuestGetAutoAccept() and QuestFrameAcceptButton:IsVisible()
		else
			return false
		end
	end
end

--------------------------------
-- PLATFORM
--------------------------------

do
	function NS:SetButtonToPlatform(frame, textFrame, keybindVariable, height, padding, paddingWidth)
		local Text = textFrame or _G[frame:GetDebugName() .. "Text"]
		local Frame = frame.API_ButtonTextFrame

		frame.API_ButtonTextFrame_Variables = frame.API_ButtonTextFrame_Variables or {}
		frame.API_ButtonTextFrame_Variables.keybindVariable = keybindVariable or ""
		if addon.API.Util:FindString(frame.API_ButtonTextFrame_Variables.keybindVariable, "-") then frame.API_ButtonTextFrame_Variables.keybindVariable = "" end

		--------------------------------

		if not Frame then
			local padding = padding or 7.5
			local paddingWidth = paddingWidth or 10
			local contentHeight = height or 30

			local frameStrata = frame:GetFrameStrata()
			local frameLevel = frame:GetFrameLevel()

			--------------------------------

			do -- FRAME
				Frame = CreateFrame("Frame", "$parent.API_ButtonTextFrame", frame)
				Frame:SetSize(frame:GetWidth(), contentHeight)

				--------------------------------

				frame.API_ButtonTextFrame = Frame

				--------------------------------

				do -- ELEMENTS
					do -- KEYBIND FRAME
						Frame.KeybindFrame = CreateFrame("Frame", "$parent.API_ButtonTextFrame.KeybindFrame", Frame)
						Frame.KeybindFrame:SetSize(contentHeight, contentHeight)
						Frame.KeybindFrame:SetPoint("LEFT", Frame, 0, 0)
						Frame.KeybindFrame:SetFrameStrata(frameStrata)
						Frame.KeybindFrame:SetFrameLevel(frameLevel + 5)

						--------------------------------

						do -- BACKGROUND
							Frame.KeybindFrame.Background, Frame.KeybindFrame.BackgroundTexture = addon.API.FrameTemplates:CreateNineSlice(Frame.KeybindFrame, frameStrata, addon.Variables.PATH_ART .. "Platform/Platform-Keybind-Background.png", 128, .125, "$parent.Background")
							Frame.KeybindFrame.Background:SetAllPoints(Frame.KeybindFrame)
							Frame.KeybindFrame.Background:SetFrameStrata(frameStrata)
							Frame.KeybindFrame.Background:SetFrameLevel(frameLevel + 4)
						end

						do -- TEXT
							Frame.KeybindFrame.Text = addon.API.FrameTemplates:CreateText(Frame.KeybindFrame, addon.Theme.RGB_WHITE, 12.5, "CENTER", "MIDDLE", addon.API.Fonts.CONTENT_LIGHT, "$parent.Text")
							Frame.KeybindFrame.Text:SetAllPoints(Frame.KeybindFrame, true)
							Frame.KeybindFrame.Text:SetAlpha(.75)
						end

						do -- IMAGE
							Frame.KeybindFrame.Image, Frame.KeybindFrame.ImageTexture = addon.API.FrameTemplates:CreateTexture(Frame.KeybindFrame, frameStrata, nil, "$parent.Image")
							Frame.KeybindFrame.Image:SetSize(contentHeight - 5, contentHeight - 5)
							Frame.KeybindFrame.Image:SetPoint("CENTER", Frame.KeybindFrame)
							Frame.KeybindFrame.Image:SetAlpha(.75)
							Frame.KeybindFrame.Image:SetFrameStrata(frameStrata)
							Frame.KeybindFrame.Image:SetFrameLevel(frameLevel + 6)
						end
					end

					do -- TEXT
						Text:ClearAllPoints()
						Text:SetPoint("LEFT", Frame, Frame.KeybindFrame:GetWidth() + padding, 0)
					end
				end

				do -- EVENTS
					local function UpdateFormatting()
						if #frame.API_ButtonTextFrame_Variables.keybindVariable >= 1 then
							Frame:Show()

							--------------------------------

							local IsPC = addon.Input.Variables.IsPC
							local IsPlaystation = addon.Input.Variables.IsPlaystation
							local IsXbox = addon.Input.Variables.IsXbox

							local replaceWithImageList = {
								["SPACE"] = addon.Variables.PATH_ART .. "Platform/Text-Platform-PC-Space.png",
								["PAD1"] = IsPlaystation and addon.Variables.PATH_ART .. "Platform/Platform-PS-1.png" or IsXbox and addon.Variables.PATH_ART .. "Platform/Platform-XBOX-1.png",
								["PAD2"] = IsPlaystation and addon.Variables.PATH_ART .. "Platform/Platform-PS-2.png" or IsXbox and addon.Variables.PATH_ART .. "Platform/Platform-XBOX-2.png",
								["PAD3"] = IsPlaystation and addon.Variables.PATH_ART .. "Platform/Platform-PS-3.png" or IsXbox and addon.Variables.PATH_ART .. "Platform/Platform-XBOX-3.png",
								["PAD4"] = IsPlaystation and addon.Variables.PATH_ART .. "Platform/Platform-PS-4.png" or IsXbox and addon.Variables.PATH_ART .. "Platform/Platform-XBOX-4.png",
								["PADLSHOULDER"] = addon.Variables.PATH_ART .. "Platform/Platform-LB.png",
								["PADRSHOULDER"] = addon.Variables.PATH_ART .. "Platform/Platform-RB.png",
								["PADLTRIGGER"] = addon.Variables.PATH_ART .. "Platform/Platform-LT.png",
								["PADRTRIGGER"] = addon.Variables.PATH_ART .. "Platform/Platform-RT.png",
							}
							local replaceWithTextList = {
								["ESCAPE"] = "Esc",
							}

							--------------------------------

							local keybindTextWidth
							local valid = false
							local texture = nil
							local text = nil

							for k, v in pairs(replaceWithImageList) do
								if tostring(Frame.KeybindFrame.Text:GetText()) == tostring(k) then
									valid = true
									texture = v
									break
								else
									valid = false
									texture = v
								end
							end
							for k, v in pairs(replaceWithTextList) do
								if tostring(Frame.KeybindFrame.Text:GetText()) == tostring(k) then
									text = v
									break
								else
									text = Frame.KeybindFrame.Text:GetText()
								end
							end

							--------------------------------

							Frame.KeybindFrame.Text:SetText(text)

							if valid then
								Frame.KeybindFrame.Text:Hide()

								--------------------------------

								Frame.KeybindFrame.Image:Show()
								Frame.KeybindFrame.ImageTexture:SetTexture(texture)

								--------------------------------

								keybindTextWidth = contentHeight - paddingWidth - paddingWidth
							else
								Frame.KeybindFrame.Text:Show()

								--------------------------------

								Frame.KeybindFrame.Image:Hide()
								Frame.KeybindFrame.ImageTexture:SetTexture(nil)

								--------------------------------

								local textWidth, _ = addon.API.Util:GetStringSize(Frame.KeybindFrame.Text)
								keybindTextWidth = textWidth
							end

							if IsPC then
								Frame.KeybindFrame.Background:Show()
							elseif IsPlaystation or IsXbox then
								Frame.KeybindFrame.Background:Hide()
							end

							--------------------------------

							Frame.KeybindFrame:SetWidth(paddingWidth + keybindTextWidth + paddingWidth)

							--------------------------------

							local textWidth, _ = addon.API.Util:GetStringSize(Text)
							Frame:SetWidth(Frame.KeybindFrame:GetWidth() + padding + textWidth)

							--------------------------------

							Text:ClearAllPoints()
							Text:SetPoint("LEFT", Frame, Frame.KeybindFrame:GetWidth() + padding, 0)
						else
							Frame:Hide()

							--------------------------------

							Text:ClearAllPoints()
							Text:SetPoint("CENTER", frame, 0, 0)
						end
					end

					local function UpdateJustify()
						local justifyH = Text:GetJustifyH()
						local justifyV = Text:GetJustifyV()

						--------------------------------

						Frame:ClearAllPoints()
						if justifyH == "LEFT" then
							Frame:SetPoint("LEFT", frame, 0, 0)
						elseif justifyH == "CENTER" then
							Frame:SetPoint("CENTER", frame, 0, 0)
						elseif justifyH == "RIGHT" then
							Frame:SetPoint("RIGHT", frame, 0, 0)
						end
					end

					Frame.KeybindFrame.Update = function()
						UpdateFormatting()
					end

					--------------------------------

					UpdateFormatting()
					UpdateJustify()

					--------------------------------

					if frame.SetText then hooksecurefunc(frame, "SetText", UpdateFormatting) end
					if Text.SetText then hooksecurefunc(Text, "SetText", UpdateFormatting) end
					if Text.SetJustifyH then hooksecurefunc(Text, "SetJustifyH", UpdateJustify) end
					if Text.SetJustifyV then hooksecurefunc(Text, "SetJustifyV", UpdateJustify) end
				end
			end
		end

		--------------------------------

		do -- TEXT
			Frame.KeybindFrame.Text:SetText(frame.API_ButtonTextFrame_Variables.keybindVariable)

			--------------------------------

			Frame.KeybindFrame.Update()
		end
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

				if addon.Database.DB_GLOBAL.profile.INT_HIDEUI then
					if InteractionPriorityFrame then
						addon.BlizzardFrames.Script:RemoveElements()
					end
				end
			end

			if event == "STOP_MOVIE" or event == "CINEMATIC_STOP" then
				IsInCutscene = false

				if addon.Database.DB_GLOBAL.profile.INT_HIDEUI then
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
