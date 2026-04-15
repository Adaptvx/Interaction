local addon = select(2, ...)

addon.API.Main = {}
addon.API.Main.UIScale = .75

do -- NPC
	local INTERACT_GOSSIP = Enum.PlayerInteractionType and Enum.PlayerInteractionType.Gossip or 3;
	local INTERACT_QUEST = Enum.PlayerInteractionType and Enum.PlayerInteractionType.QuestGiver or 4;

	function addon.API.Main:IsNPCGossip()
		return C_PlayerInteractionManager.IsInteractingWithNpcOfType(INTERACT_GOSSIP)
	end

	function addon.API.Main:IsNPCQuest()
		return C_PlayerInteractionManager.IsInteractingWithNpcOfType(INTERACT_QUEST)
	end

	function addon.API.Main:IsNPCQuestOrGossip()
		return addon.API.Main:IsNPCGossip() or addon.API.Main:IsNPCQuest()
	end

	function addon.API.Main:IsAutoAccept()
		if addon.Variables.IS_WOW_VERSION_CLASSIC_ALL then return false end
		return QuestGetAutoAccept() and QuestFrameAcceptButton:IsVisible()
	end
end

do -- Platform
	function addon.API.Main:SetButtonToPlatform(frame, textFrame, keybindVariable, height, padding, paddingWidth)
		local Text = textFrame or _G[frame:GetDebugName() .. "Text"]
		local Frame = frame.API_ButtonTextFrame

		frame.API_ButtonTextFrame_Variables = frame.API_ButtonTextFrame_Variables or {}
		frame.API_ButtonTextFrame_Variables.keybindVariable = addon.API.Util:FindString(keybindVariable or "", "-") and "" or keybindVariable or ""

		if not Frame then
			local contentHeight = height or 30
			local pad = padding or 7.5
			local padW = paddingWidth or 10

			local frameStrata = frame:GetFrameStrata()
			local frameLevel = frame:GetFrameLevel()

			Frame = CreateFrame("Frame", "$parent.API_ButtonTextFrame", frame)
			Frame:SetSize(frame:GetWidth(), contentHeight)
			frame.API_ButtonTextFrame = Frame

			Frame.KeybindFrame = CreateFrame("Frame", "$parent.API_ButtonTextFrame.KeybindFrame", Frame)
			Frame.KeybindFrame:SetSize(contentHeight, contentHeight)
			Frame.KeybindFrame:SetPoint("LEFT", Frame, 0, 0)
			Frame.KeybindFrame:SetFrameStrata(frameStrata)
			Frame.KeybindFrame:SetFrameLevel(frameLevel + 5)

			Frame.KeybindFrame.Background, Frame.KeybindFrame.BackgroundTexture = addon.API.FrameTemplates:CreateNineSlice(Frame.KeybindFrame, frameStrata, addon.Variables.PATH_ART .. "Platform\\Platform-Keybind-Background.png", 128, .125, "$parent.Background")
			Frame.KeybindFrame.Background:SetAllPoints(Frame.KeybindFrame)
			Frame.KeybindFrame.Background:SetFrameStrata(frameStrata)
			Frame.KeybindFrame.Background:SetFrameLevel(frameLevel + 4)

			Frame.KeybindFrame.Text = addon.API.FrameTemplates:CreateText(Frame.KeybindFrame, addon.Theme.RGB_WHITE, 12.5, "CENTER", "MIDDLE", GameFontNormal:GetFont(), "$parent.Text")
			Frame.KeybindFrame.Text:SetAllPoints(Frame.KeybindFrame, true)
			Frame.KeybindFrame.Text:SetAlpha(.75)

			Frame.KeybindFrame.Image, Frame.KeybindFrame.ImageTexture = addon.API.FrameTemplates:CreateTexture(Frame.KeybindFrame, frameStrata, nil, "$parent.Image")
			Frame.KeybindFrame.Image:SetSize(contentHeight - 5, contentHeight - 5)
			Frame.KeybindFrame.Image:SetPoint("CENTER", Frame.KeybindFrame)
			Frame.KeybindFrame.Image:SetAlpha(.75)
			Frame.KeybindFrame.Image:SetFrameStrata(frameStrata)
			Frame.KeybindFrame.Image:SetFrameLevel(frameLevel + 6)

			Text:ClearAllPoints()
			Text:SetPoint("LEFT", Frame, Frame.KeybindFrame:GetWidth() + pad, 0)

			local function UpdateFormatting()
				if #frame.API_ButtonTextFrame_Variables.keybindVariable >= 1 then
					Frame:Show()
					local IsPC = addon.Input.Variables.IsPC
					local IsPlaystation = addon.Input.Variables.IsPlaystation
					local IsXbox = addon.Input.Variables.IsXbox

					local replaceWithImageList = {
						SPACE = addon.Variables.PATH_ART .. "Platform\\Text-Platform-PC-Space.png",
						PAD1 = IsPlaystation and addon.Variables.PATH_ART .. "Platform\\Platform-PS-1.png" or IsXbox and addon.Variables.PATH_ART .. "Platform\\Platform-XBOX-1.png",
						PAD2 = IsPlaystation and addon.Variables.PATH_ART .. "Platform\\Platform-PS-2.png" or IsXbox and addon.Variables.PATH_ART .. "Platform\\Platform-XBOX-2.png",
						PAD3 = IsPlaystation and addon.Variables.PATH_ART .. "Platform\\Platform-PS-3.png" or IsXbox and addon.Variables.PATH_ART .. "Platform\\Platform-XBOX-3.png",
						PAD4 = IsPlaystation and addon.Variables.PATH_ART .. "Platform\\Platform-PS-4.png" or IsXbox and addon.Variables.PATH_ART .. "Platform\\Platform-XBOX-4.png",
						PADLSHOULDER = addon.Variables.PATH_ART .. "Platform\\Platform-LB.png",
						PADRSHOULDER = addon.Variables.PATH_ART .. "Platform\\Platform-RB.png",
						PADLTRIGGER = addon.Variables.PATH_ART .. "Platform\\Platform-LT.png",
						PADRTRIGGER = addon.Variables.PATH_ART .. "Platform\\Platform-RT.png",
					}
					local replaceWithTextList = { ESCAPE = "Esc" }

					local key = tostring(Frame.KeybindFrame.Text:GetText())
					local texture = replaceWithImageList[key]
					local text = replaceWithTextList[key] or key
					Frame.KeybindFrame.Text:SetText(text)

					local keybindTextWidth
					if texture then
						Frame.KeybindFrame.Text:Hide()
						Frame.KeybindFrame.Image:Show()
						Frame.KeybindFrame.ImageTexture:SetTexture(texture)
						keybindTextWidth = contentHeight - padW - padW
					else
						Frame.KeybindFrame.Text:Show()
						Frame.KeybindFrame.Image:Hide()
						Frame.KeybindFrame.ImageTexture:SetTexture(nil)
						local textWidth = addon.API.Util:GetStringSize(Frame.KeybindFrame.Text)
						keybindTextWidth = textWidth
					end

					Frame.KeybindFrame.Background:SetShown(IsPC)
					Frame.KeybindFrame:SetWidth(padW + keybindTextWidth + padW)

					local textWidth = addon.API.Util:GetStringSize(Text)
					Frame:SetWidth(Frame.KeybindFrame:GetWidth() + pad + textWidth)
					Text:ClearAllPoints()
					Text:SetPoint("LEFT", Frame, Frame.KeybindFrame:GetWidth() + pad, 0)
				else
					Frame:Hide()
					Text:ClearAllPoints()
					Text:SetPoint("CENTER", frame, 0, 0)
				end
			end

			local function UpdateJustify()
				local justifyH = Text:GetJustifyH()
				Frame:ClearAllPoints()
				if justifyH == "LEFT" then Frame:SetPoint("LEFT", frame, 0, 0) end
				if justifyH == "CENTER" then Frame:SetPoint("CENTER", frame, 0, 0) end
				if justifyH == "RIGHT" then Frame:SetPoint("RIGHT", frame, 0, 0) end
			end

			function Frame.KeybindFrame.Update() UpdateFormatting() end
			UpdateFormatting()
			UpdateJustify()
			if frame.SetText then hooksecurefunc(frame, "SetText", UpdateFormatting) end
			if Text.SetText then hooksecurefunc(Text, "SetText", UpdateFormatting) end
			if Text.SetJustifyH then hooksecurefunc(Text, "SetJustifyH", UpdateJustify) end
			if Text.SetJustifyV then hooksecurefunc(Text, "SetJustifyV", UpdateJustify) end
		end

		Frame.KeybindFrame.Text:SetText(frame.API_ButtonTextFrame_Variables.keybindVariable)
		Frame.KeybindFrame.Update()
	end
end

do -- Utilities
	function addon.API.Main:PreventInput(frame)
		if InCombatLockdown() or not frame or not frame.SetPropagateKeyboardInput then return end

		frame:SetPropagateKeyboardInput(false)
		C_Timer.After(0, function() if not InCombatLockdown() then frame:SetPropagateKeyboardInput(true) end end)
		if frame.Registered then return end
		frame.Registered = true
		frame:RegisterEvent("PLAYER_REGEN_DISABLED")
		frame:SetScript("OnEvent", function(_, event) if event == "PLAYER_REGEN_DISABLED" then frame:SetPropagateKeyboardInput(true) end end)
	end

	function addon.API.Main:GetDarkTheme() return addon.Theme.IsDarkTheme end

	function addon.API.Main:PreventRepeatCall(frame, delay, func)
		local id = GetTime()
		frame.id = id
		C_Timer.After(delay, function() if frame.id == id then func() end end)
	end

	function addon.API.Main:RegisterThemeUpdate(func, priority)
		addon.CallbackRegistry:Add("THEME_UPDATE", func, priority)
		func()
	end

	function addon.API.Main:IsElementInScrollFrame(scrollFrame, element)
		local scrollFrameLeft, scrollFrameRight = scrollFrame:GetLeft(), scrollFrame:GetRight()
		local scrollFrameTop, scrollFrameBottom = scrollFrame:GetTop(), scrollFrame:GetBottom()
		local elementLeft, elementRight = element:GetLeft(), element:GetRight()
		local elementTop, elementBottom = element:GetTop(), element:GetBottom()
		return elementLeft and elementRight and elementTop and elementBottom
			and elementRight > scrollFrameLeft - element:GetWidth()
			and elementLeft < scrollFrameRight + element:GetWidth()
			and elementBottom > scrollFrameBottom - element:GetHeight()
			and elementTop < scrollFrameTop + element:GetHeight()
	end

	function addon.API.Main:GetScreenWidth() return WorldFrame:GetWidth() / addon.API.Main.UIScale end
	function addon.API.Main:GetScreenHeight() return WorldFrame:GetHeight() / addon.API.Main.UIScale end
end

do -- UI Visibility
	function addon.API.Main:SetupUICheck()
		local IsInCutscene = false

		local uiFrame = CreateFrame("Frame")
		uiFrame:RegisterEvent("CINEMATIC_START")
		uiFrame:RegisterEvent("PLAY_MOVIE")
		uiFrame:RegisterEvent("STOP_MOVIE")
		uiFrame:RegisterEvent("CINEMATIC_STOP")
		uiFrame:SetScript("OnEvent", function(_, event)
			if event == "CINEMATIC_START" or event == "PLAY_MOVIE" then
				IsInCutscene = true
			elseif event == "STOP_MOVIE" or event == "CINEMATIC_STOP" then
				IsInCutscene = false
			end

			if addon.Database.DB_GLOBAL.profile.INT_HIDEUI and InteractionPriorityFrame then
				if IsInCutscene then addon.BlizzardFrames.Script:RemoveElements() else addon.BlizzardFrames.Script:SetElements() end
			end
		end)

		function addon.API.Main:CanShowUIAndHideElements()
			local result = not C_PlayerInteractionManager.IsInteractingWithNpcOfType(57) and not IsInCutscene

			if InteractionPriorityFrame then
				if result then addon.BlizzardFrames.Script:SetElements() else addon.BlizzardFrames.Script:RemoveElements() end
			end

			return result
		end
	end

	addon.API.Main:SetupUICheck()
end
