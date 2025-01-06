local addonName, addon = ...
local CallbackRegistry = addon.CallbackRegistry
local L = addon.Locales
local NS = addon.Input

--------------------------------

NS.Script = {}

--------------------------------

function NS.Script:Load()
	--------------------------------
	-- REFERENCES
	--------------------------------

	local Script = NS.Script

	--------------------------------
	-- INITALIZE
	--------------------------------

	do
		local Checks = {}

		function Script:Initalize()
			NS.Variables.IsController = (addon.Variables.Platform == 2 or addon.Variables.Platform == 3)
			NS.Variables.IsPC = (addon.Variables.Platform == 1)

			--------------------------------

			local function UpdateChecks()
				Checks.Settings_AlwaysShowGossipFrame = INTDB.profile.INT_ALWAYS_SHOW_GOSSIP

				Checks.IsDialog = (InteractionDialogFrame:IsVisible())
				Checks.IsGossip = (not Checks.IsDialog and InteractionGossipFrame:IsVisible())
				Checks.IsGossipVisible = (not InteractionGossipFrame.hidden)
				Checks.IsAlwaysShowGossip = (InteractionGossipFrame:IsVisible())
				Checks.IsQuest = (InteractionQuestFrame:IsVisible())
				Checks.IsQuestRewardSelection = (Checks.IsQuest and addon.Interaction.Quest.Variables.Num_Choice >= 1)
				Checks.IsPrompt = (InteractionPromptFrame:IsVisible())
			end

			local function PreventInput()
				addon.API:PreventInput(Script.KeybindFrame)
			end

			--------------------------------

			do -- KEYBIND
				local function GetMatchingKey(key, keyTable)
					for i = 1, #keyTable do
						if key == keyTable[i] then
							return true
						end
					end

					--------------------------------

					return false
				end

				--------------------------------

				NS.Variables:UpdateKeybinds()

				--------------------------------

				function Script:Input_Global(_, key)
					local Result = true

					--------------------------------

					UpdateChecks()

					--------------------------------

					do -- Prompt
						if (Checks.IsPrompt) and (Result) then
							do -- Accept/Decline
								if GetMatchingKey(key, NS.Variables.Key_Prompt_Accept) then
									PreventInput()
									Result = false

									--------------------------------

									InteractionPromptFrame.Content.ButtonArea.Button1:Click()
								end

								if GetMatchingKey(key, NS.Variables.Key_Prompt_Decline) then
									PreventInput()
									Result = false

									--------------------------------

									InteractionPromptFrame.Content.ButtonArea.Button2:Click()
								end
							end

							do -- Close
								if GetMatchingKey(key, NS.Variables.Key_Close) then
									PreventInput()
									Result = false

									--------------------------------

									InteractionPromptFrame.Clear()

									--------------------------------

									return
								end
							end
						end
					end

					do -- Settings
						if Result then
							if InteractionSettingsFrame then
								do -- Toggle
									local IsReadableUI = InteractionReadableUIFrame:IsVisible()
									local IsInteraction = addon.Interaction.Variables.Active
									local IsSettings = InteractionSettingsFrame:IsVisible()

									--------------------------------

									if (IsSettings and key == "ESCAPE") or (not IsSettings and key == "ESCAPE" and IsShiftKeyDown()) then
										PreventInput()
										Result = false

										--------------------------------

										if IsSettings then
											addon.SettingsUI.Script:HideSettingsUI()
										else
											addon.SettingsUI.Script:ShowSettingsUI()
										end
									end
								end
							end
						end
					end

					do -- Quest
						if (Checks.IsQuest) and (Result) then
							do -- Progress
								if GetMatchingKey(key, NS.Variables.Key_Progress) then
									local IsAutoAccept = addon.API:IsAutoAccept()

									--------------------------------

									if IsAutoAccept then
										if InteractionQuestFrame.ButtonContainer.GoodbyeButton:IsVisible() and InteractionQuestFrame.ButtonContainer.GoodbyeButton:IsEnabled() then
											PreventInput()
											Result = false

											--------------------------------

											InteractionQuestFrame.ButtonContainer.GoodbyeButton:Click()
										end
									else
										if InteractionQuestFrame.ButtonContainer.AcceptButton:IsVisible() and InteractionQuestFrame.ButtonContainer.AcceptButton:IsEnabled() then
											PreventInput()
											Result = false

											--------------------------------

											InteractionQuestFrame.ButtonContainer.AcceptButton:Click()
										end
									end

									if InteractionQuestFrame.ButtonContainer.ContinueButton:IsVisible() and InteractionQuestFrame.ButtonContainer.ContinueButton:IsEnabled() then
										PreventInput()
										Result = false

										--------------------------------

										InteractionQuestFrame.ButtonContainer.ContinueButton:Click()
									end

									if InteractionQuestFrame.ButtonContainer.CompleteButton:IsVisible() and InteractionQuestFrame.ButtonContainer.CompleteButton:IsEnabled() then
										PreventInput()
										Result = false

										--------------------------------

										InteractionQuestFrame.ButtonContainer.CompleteButton:Click()
									end
								end
							end
						end
					end

					do -- Dialog
						if Result then
							if addon.Interaction.Variables.Active then
								do -- Skip
									if GetMatchingKey(key, NS.Variables.Key_Skip) then
										local IsController = ((NS.Variables.IsController or NS.Variables.SimulateController))
										local IsQuestFrameVisible = (InteractionQuestFrame:IsVisible() and InteractionQuestFrame:GetAlpha() > .1)
										local IsGossipFrameVisible = (InteractionGossipFrame:IsVisible() and InteractionGossipFrame:GetAlpha() > .1)
										local IsGossipButtonsAvailable = (#InteractionGossipFrame.GetButtons() > 0)

										local BlockOnQuestFrame = (IsQuestFrameVisible)
										local BlockOnGossipFrame = (IsController and IsGossipFrameVisible and IsGossipButtonsAvailable)

										--------------------------------

										if not BlockOnQuestFrame and not BlockOnGossipFrame then
											if InteractionDialogFrame:IsVisible() then
												PreventInput()
												Result = false

												--------------------------------

												InteractionDialogFrame.StopDialog()

												--------------------------------

												return
											end
										end
									end
								end

								do -- Next/Previous
									if Checks.IsDialog or Checks.IsGossip or Checks.IsQuest then
										if GetMatchingKey(key, NS.Variables.Key_Next) and Checks.IsDialog then
											PreventInput()
											Result = false

											--------------------------------

											addon.Interaction.Dialog.Variables.AllowAutoProgress = false
											InteractionDialogFrame.IncrementIndex()

											--------------------------------

											return
										end

										if GetMatchingKey(key, NS.Variables.Key_Previous) then
											PreventInput()
											Result = false

											--------------------------------

											InteractionDialogFrame.DecrementIndex()

											--------------------------------

											return
										end
									end
								end
							end
						end
					end

					do -- Interaction
						if Result then
							if addon.Interaction.Variables.Active then
								do -- Close
									if GetMatchingKey(key, NS.Variables.Key_Close) then
										PreventInput()
										Result = false

										--------------------------------

										local isGossip = (InteractionGossipFrame:IsVisible())
										local isQuest = (InteractionQuestFrame:IsVisible())

										if isGossip or isQuest then
											if isGossip then
												InteractionGossipFrame.HideWithAnimation()
											end

											if isQuest then
												InteractionQuestFrame.HideWithAnimation()
											end

											--------------------------------

											addon.Interaction.Script:Stop(true)
										else
											addon.Interaction.Script:Stop(true)
										end

										--------------------------------

										return
									end
								end
							end
						end
					end

					do -- Library
						if Result then
							if InteractionReadableUIFrame then
								do -- Close
									if InteractionReadableUIFrame:IsVisible() then
										if GetMatchingKey(key, NS.Variables.Key_Close) then
											PreventInput()
											Result = false

											--------------------------------

											InteractionReadableUIFrame.HideWithAnimation()
										end
									end
								end
							end
						end
					end

					--------------------------------

					return Result
				end

				function Script:Input_Keyboard(_, key)
					UpdateChecks()

					--------------------------------

					if NS.Variables.SimulateController then
						Script:Input_Gamepad(_, key)
					end

					if NS.Variables.IsPC or not NS.Variables.IsControllerEnabled then
						do -- Gossip
							if (Checks.IsGossip) or (Checks.Settings_AlwaysShowGossipFrame and Checks.IsGossipVisible) then
								local Buttons = InteractionGossipFrame.GetButtons()

								--------------------------------

								if Buttons then
									for _ = 1, #Buttons do
										if not IsShiftKeyDown() and key == tostring(_) then
											PreventInput()
											Result = false

											--------------------------------

											if Buttons[_].selected == false then
												Buttons[_].Enter()
											end

											--------------------------------

											addon.Libraries.AceTimer:ScheduleTimer(function()
												if Buttons[_].selected == true then
													Buttons[_].Leave()
													Buttons[_].Click()
												end
											end, .125)
										end

										if IsShiftKeyDown() and key == tostring(_ - 9) then
											PreventInput()
											Result = false

											--------------------------------

											if Buttons[_].selected == false then
												Buttons[_].Enter()
											end

											--------------------------------

											addon.Libraries.AceTimer:ScheduleTimer(function()
												if Buttons[_].selected == true then
													Buttons[_].Leave()
													Buttons[_]:Click()
												end
											end, .125)
										end
									end
								end
							end
						end

						do -- Quest
							if (Checks.IsQuest) then
								-- <MORE TO ADD>
							end
						end
					end
				end

				function Script:Input_Gamepad(_, key)
					UpdateChecks()

					--------------------------------

					if (NS.Variables.IsController or NS.Variables.SimulateController) then
						do -- Navigation
							do -- Move
								if not NS.Variables.IsNavigating then
									return
								end

								--------------------------------

								if GetMatchingKey(key, NS.Variables.Key_ScrollUp) then
									if Script:Nav_ScrollUp() then
										PreventInput()
									end
								end

								if GetMatchingKey(key, NS.Variables.Key_ScrollDown) then
									if Script:Nav_ScrollDown() then
										PreventInput()
									end
								end

								if GetMatchingKey(key, NS.Variables.Key_MoveUp) then
									PreventInput()

									--------------------------------

									Script:Nav_MoveUp()
								end

								if GetMatchingKey(key, NS.Variables.Key_MoveLeft) then
									PreventInput()

									--------------------------------

									Script:Nav_MoveLeft()
								end

								if GetMatchingKey(key, NS.Variables.Key_MoveRight) then
									PreventInput()

									--------------------------------

									Script:Nav_MoveRight()
								end

								if GetMatchingKey(key, NS.Variables.Key_MoveDown) then
									PreventInput()

									--------------------------------

									Script:Nav_MoveDown()
								end
							end

							do -- Interact
								if not NS.Variables.IsNavigating then
									return
								end

								--------------------------------

								if GetMatchingKey(key, NS.Variables.Key_Interact) then
									PreventInput()

									--------------------------------

									Script:Nav_Interact()
								end

								if GetMatchingKey(key, NS.Variables.Key_Settings_SpecialInteract3) then
									PreventInput()

									--------------------------------

									if NS.Variables.CurrentFrame.Input_UseSpecialInteract and NS.Variables.CurrentFrame.Input_UseSpecialInteract_Button then
										Script:Nav_SpecialInteract1()
									end
								end

								if GetMatchingKey(key, NS.Variables.Key_Settings_SpecialInteract2) then
									PreventInput()

									--------------------------------

									if NS.Variables.CurrentFrame.Input_UseSpecialInteract and not NS.Variables.CurrentFrame.Input_UseSpecialInteract_Button then
										Script:Nav_SpecialInteract2()
									end
								end

								if GetMatchingKey(key, NS.Variables.Key_Settings_SpecialInteract1) then
									PreventInput()

									--------------------------------

									if NS.Variables.CurrentFrame.Input_UseSpecialInteract and not NS.Variables.CurrentFrame.Input_UseSpecialInteract_Button then
										Script:Nav_SpecialInteract1()
									end
								end
							end

							do -- Settings
								do -- Toggle
									local IsReadableUI = InteractionReadableUIFrame:IsVisible()
									local IsInteraction = addon.Interaction.Variables.Active
									local IsSettings = InteractionSettingsFrame:IsVisible()

									--------------------------------

									if GetMatchingKey(key, NS.Variables.Key_Settings_Toggle) and (IsInteraction or IsReadableUI or IsSettings) then
										PreventInput()

										--------------------------------

										if IsSettings then
											addon.SettingsUI.Script:HideSettingsUI(false, true)
										elseif not IsSettings then
											addon.SettingsUI.Script:ShowSettingsUI(false, true)
										end

										if IsReadableUI then
											InteractionReadableUIFrame.HideWithAnimation(true)
										end

										if IsInteraction then
											addon.Interaction.Script:Stop(true)
										end
									end
								end

								do -- Change Tab
									if not NS.Variables.IsNavigating then
										return
									end

									--------------------------------

									if GetMatchingKey(key, NS.Variables.Key_Settings_ChangeTabUp) then
										if Script.CurrentNavigationSession == "SETTING" then
											PreventInput()

											--------------------------------

											local CurrentTab = InteractionSettingsFrame.Content.ScrollFrame.tabIndex
											local Tabs = InteractionSettingsFrame.Content.ScrollFrame.tabPool
											local Buttons = InteractionSettingsFrame.Sidebar.Legend.widgetPool

											local New = CurrentTab + 1

											--------------------------------

											if New < 1 then
												New = 1
											elseif New > #Tabs then
												New = #Tabs
											end

											addon.SettingsUI.Script:SelectTab(Buttons[New].Button, New)
										end
									end

									if GetMatchingKey(key, NS.Variables.Key_Settings_ChangeTabDown) then
										if Script.CurrentNavigationSession == "SETTING" then
											PreventInput()

											--------------------------------

											local CurrentTab = InteractionSettingsFrame.Content.ScrollFrame.tabIndex
											local Tabs = InteractionSettingsFrame.Content.ScrollFrame.tabPool
											local Buttons = InteractionSettingsFrame.Sidebar.Legend.widgetPool

											local New = CurrentTab - 1

											--------------------------------

											if New < 1 then
												New = 1
											elseif New > #Tabs then
												New = #Tabs
											end

											addon.SettingsUI.Script:SelectTab(Buttons[New].Button, New)
										end
									end
								end
							end
						end
					end
				end

				--------------------------------

				-- INPUT
				do
					local IsRepeating = false
					local RepeatDelay = .5
					local RepeatInterval = .125

					local Session = {
						key = nil,
						lastRepeat = nil,
						type = nil
					}

					--------------------------------

					local function ResetSession()
						IsRepeating = false

						--------------------------------

						Session = {
							key = nil,
							lastRepeat = nil,
							type = nil
						}
					end

					--------------------------------

					local SessionUpdate = CreateFrame("Frame", "SessionUpdate")
					SessionUpdate:SetScript("OnUpdate", function(self, elapsed)
						if not addon.Initialize.Ready then
							return
						end

						if not Session.key or not Session.lastRepeat then
							return
						end

						--------------------------------

						local LastRepeat = Session.lastRepeat
						local CurrentTime = GetTime()
						local Key = Session.key
						local Type = Session.type

						--------------------------------

						if not IsRepeating then
							if CurrentTime - LastRepeat > RepeatDelay then
								IsRepeating = true
							end
						elseif CurrentTime - LastRepeat > RepeatInterval then
							Session.lastRepeat = CurrentTime

							--------------------------------

							if Type == "Controller" then
								if Script:Input_Global(nil, Key) then
									Script:Input_Gamepad(nil, Key)
								end
							end
						end
					end)

					Script.KeybindFrame = CreateFrame("Frame")
					Script.KeybindFrame:SetPropagateKeyboardInput(true)

					--------------------------------

					-- PC
					do
						Script.KeybindFrame:SetScript("OnKeyDown", function(_, key)
							if not addon.Initialize.Ready then
								return
							end

							--------------------------------

							NS.Variables:UpdateKeybinds()

							--------------------------------

							if Script:Input_Global(_, key) then
								Script:Input_Keyboard(_, key)
							end
						end)
						Script.KeybindFrame:SetScript("OnKeyUp", function(_, key)
							if not addon.Initialize.Ready then
								return
							end

							--------------------------------

							NS.Variables:UpdateKeybinds()
						end)
					end

					-- GAMEPAD
					do
						Script.KeybindFrame:SetScript("OnGamePadButtonDown", function(_, key)
							if not addon.Initialize.Ready then
								return
							end

							--------------------------------

							NS.Variables:UpdateKeybinds()

							--------------------------------

							if Script:Input_Global(_, key) then
								Script:Input_Gamepad(_, key)
							end

							--------------------------------

							ResetSession()
							if NS.Variables.IsNavigating then
								Session = {
									key = key,
									lastRepeat = GetTime(),
									type = "Controller"
								}
							end
						end)
						Script.KeybindFrame:SetScript("OnGamePadButtonUp", function(_, key)
							if not addon.Initialize.Ready then
								return
							end

							--------------------------------

							NS.Variables:UpdateKeybinds()

							--------------------------------

							ResetSession()
						end)
					end
				end
			end

			do -- HINT
				Script.Hint = CreateFrame("Frame", "$parent.Hint", InteractionFrame)
				Script.Hint:SetSize(25, 25)
				Script.Hint:SetFrameStrata("FULLSCREEN_DIALOG")
				Script.Hint:SetFrameLevel(99)

				Script.Hint:SetIgnoreParentAlpha(true)
				Script.Hint:SetIgnoreParentScale(true)

				Script.Hint.hidden = false

				local Frame = Script.Hint

				--------------------------------

				local function Background()
					Frame.Background, Frame.BackgroundTexture = AdaptiveAPI.FrameTemplates:CreateTexture(Frame, "FULLSCREEN_DIALOG", NS.Variables.PATH .. "hint-background.png", "$parent.Background")
					Frame.Background:SetSize(Frame:GetWidth(), Frame:GetHeight())
					Frame.Background:SetPoint("CENTER", Frame)
					Frame.Background:SetFrameLevel(99)
				end

				local function Image()
					Frame.Image, Frame.ImageTexture = AdaptiveAPI.FrameTemplates:CreateTexture(Frame, "FULLSCREEN_DIALOG", nil, "$parent.Image")
					Frame.Image:SetSize(Frame:GetWidth(), Frame:GetHeight())
					Frame.Image:SetPoint("CENTER", Frame)
					Frame.Image:SetFrameLevel(100)
				end

				--------------------------------

				Background()
				Image()
			end
		end

		Script:Initalize()
	end

	--------------------------------
	-- FUNCTIONS (HINT)
	--------------------------------

	do
		Script.Hint.Set = function(frame, type)
			Script.Hint:ClearAllPoints()
			Script.Hint:SetPoint("BOTTOM", frame, 0, -Script.Hint:GetHeight() - 12.5)

			local TEXTURE_Interact
			local TEXTURE_Scrollable
			if INTDB.profile.addon.Variables.Platform == 2 then
				TEXTURE_Interact = NS.Variables.PATH .. "hint-static.png"
				TEXTURE_Scrollable = NS.Variables.PATH .. "hint-scrollable.png"
			elseif INTDB.profile.addon.Variables.Platform == 3 then
				TEXTURE_Interact = NS.Variables.PATH .. "hint-static.png"
				TEXTURE_Scrollable = NS.Variables.PATH .. "hint-scrollable.png"
			elseif NS.Variables.SimulateController then
				TEXTURE_Interact = NS.Variables.PATH .. "hint-static.png"
				TEXTURE_Scrollable = NS.Variables.PATH .. "hint-scrollable.png"
			end

			if type == "Interact" then
				Script.Hint.ImageTexture:SetTexture(TEXTURE_Interact)
			elseif type == "ScrollFrame" then
				Script.Hint.ImageTexture:SetTexture(TEXTURE_Scrollable)
			elseif type == "Static" then
				Script.Hint.ImageTexture:SetTexture(NS.Variables.PATH .. "hint-static.png")
			end

			Script.Hint.ShowWithAnimation()
		end

		Script.Hint.Clear = function()
			Script.Hint:SetParent(nil)
			Script.Hint:ClearAllPoints()

			Script.Hint:Hide()
		end

		Script.Hint.ShowWithAnimation = function()
			Script.Hint:Show()
			Script.Hint.hidden = false

			AdaptiveAPI.Animation:Fade(Script.Hint, .5, 0, 1, nil, function() return Script.Hint.hidden end)
			AdaptiveAPI.Animation:Move(Script.Hint, .5, "BOTTOM", -75, -Script.Hint:GetHeight() - 12.5, "y", AdaptiveAPI.Animation.EaseExpo, function() return Script.Hint.hidden end)
		end

		Script.Hint.HideWithAnimation = function()
			addon.Libraries.AceTimer:ScheduleTimer(function()
				if Script.Hint.hidden then
					Script.Hint:Hide()
				end
			end, .5)
			Script.Hint.hidden = true

			AdaptiveAPI.Animation:Fade(Script.Hint, .5, Script.Hint:GetAlpha(), 0, nil, function() return not Script.Hint.hidden end)
			AdaptiveAPI.Animation:Move(Script.Hint, .5, "BOTTOM", -Script.Hint:GetHeight() - 12.5, -75, "y", AdaptiveAPI.Animation.EaseExpo, function() return not Script.Hint.hidden end)
		end
	end

	--------------------------------
	-- FUNCTIONS (CORE)
	--------------------------------

	do
		function Script:Frame_Leave(frame)
			if frame.MouseLeaveCallback then
				frame.MouseLeaveCallback()
			elseif frame.Leave then
				frame.Leave()
			else
				frame:SetAlpha(1)
			end
		end

		function Script:Frame_Enter(frame)
			if frame.Enter then
				frame.Enter()

				if frame.MouseEnterCallback then
					frame.MouseEnterCallback()
				end
			else
				frame:SetAlpha(.5)
			end
		end

		--------------------------------

		function Script:StartNavigation(sessionName, defaultFrame, children)
			NS.Variables.PreviousFrame = nil
			NS.Variables.CurrentFrame = nil

			--------------------------------

			Script:RegisterNewFrame(defaultFrame)

			--------------------------------

			for i = 1, #children do
				local frame = children[i]

				--------------------------------

				Script:Frame_Leave(frame)
			end

			--------------------------------

			Script.CurrentNavigationSession = sessionName
			NS.Variables.IsNavigating = true
		end

		function Script:StopNavigation()
			NS.Variables.PreviousFrame = nil
			NS.Variables.CurrentFrame = nil

			--------------------------------

			Script.CurrentNavigationSession = nil
			NS.Variables.IsNavigating = false

			--------------------------------

			Script.Hint.Clear()
		end

		--------------------------------

		-- Interact when not specified, is defaulted to the .Click/OnClick function if available. Variables: frame, relativeTop, relativeBottom, relativeLeft, relativeRight, scrollFrame, scrollChildFrame, axis, interact, specialInteract1, specialInteract2
		function Script:SetFrameRelatives(tbl)
			local frame = tbl.frame
			local parent = tbl.parent
			local children = tbl.children
			local relativeTop = tbl.relativeTop
			local relativeBottom = tbl.relativeBottom
			local relativeLeft = tbl.relativeLeft
			local relativeRight = tbl.relativeRight

			local scrollFrame = tbl.scrollFrame
			local scrollChildFrame = tbl.scrollChildFrame
			local preventManualScrolling = tbl.preventManualScrolling or false
			local axis = tbl.axis

			local interact = tbl.interact
			local useSpecialInteract = tbl.useSpecialInteract
			local useSpecialInteractButton = tbl.useSpecialInteractButton

			--------------------------------

			frame.Input_Parent = parent
			frame.Input_Children = children

			frame.Input_Relatives_Top = relativeTop
			frame.Input_Relatives_Bottom = relativeBottom
			frame.Input_Relatives_Left = relativeLeft
			frame.Input_Relatives_Right = relativeRight

			frame.Input_ScrollFrame = scrollFrame
			frame.Input_ScrollChildFrame = scrollChildFrame
			frame.Input_PreventManualScrolling = preventManualScrolling or false
			frame.Input_Axis = axis

			frame.Input_Interact = interact
			frame.Input_UseSpecialInteract = useSpecialInteract
			frame.Input_UseSpecialInteract_Button = useSpecialInteractButton
		end

		--------------------------------

		function Script:RegisterNewFrame(new)
			if not new then
				return
			end

			--------------------------------

			NS.Variables.PreviousFrame = NS.Variables.CurrentFrame
			NS.Variables.CurrentFrame = new

			--------------------------------

			local Frame = new

			--------------------------------

			local function Highlight()
				local function Exit()
					local function Callback(frame)
						if frame then
							Script:Frame_Leave(frame)
						end
					end

					local function ExitFrame(frame)
						if frame.Input_Children then
							local Children = frame.Input_Children

							--------------------------------

							local ShouldContinue = true

							--------------------------------

							for i = 1, #Children do
								if Children[i] == NS.Variables.CurrentFrame then
									ShouldContinue = false
								end
							end

							--------------------------------

							if ShouldContinue then
								Callback(frame)
							end
						else
							Callback(frame)
						end
					end

					--------------------------------

					if NS.Variables.PreviousFrame then
						ExitFrame(NS.Variables.PreviousFrame)

						if NS.Variables.PreviousFrame.Input_Parent then
							ExitFrame(NS.Variables.PreviousFrame.Input_Parent)
						end
					end
				end

				local function Enter()
					local function Callback(frame, ignorePreviousFrame)
						if ignorePreviousFrame or frame ~= NS.Variables.PreviousFrame then
							Script:Frame_Enter(frame)
						end
					end

					--------------------------------

					if NS.Variables.CurrentFrame then
						addon.Libraries.AceTimer:ScheduleTimer(function()
							if NS.Variables.CurrentFrame then
								Callback(NS.Variables.CurrentFrame)

								if NS.Variables.CurrentFrame.Input_Parent then
									Callback(NS.Variables.CurrentFrame.Input_Parent, true)
								end
							end
						end, 0)
					end
				end

				--------------------------------

				Exit()
				Enter()
			end

			local function ScrollFramePosition()
				if Frame.Input_ScrollFrame and Frame.Input_ScrollChildFrame and Frame.Input_Axis and Frame.Input_PreventManualScrolling then
					local ScrollFrame = new.Input_ScrollFrame
					local Axis = new.Input_Axis

					Script:UpdateScrollFramePosition(ScrollFrame, Frame, Axis)
				end
			end

			--------------------------------

			Highlight()
			ScrollFramePosition()

			--------------------------------

			CallbackRegistry:Trigger("INPUT_NAVIGATION_HIGHLIGHTED")
		end

		function Script:ResetSelectedFrame(new)
			NS.Variables.PreviousFrame = nil
			NS.Variables.CurrentFrame = nil

			--------------------------------

			Script:RegisterNewFrame(new)
		end

		--------------------------------

		function Script:Nav_Interact()
			if NS.Variables.CurrentFrame then
				if NS.Variables.CurrentFrame.Input_Interact then
					NS.Variables.CurrentFrame.Input_Interact()
				elseif NS.Variables.CurrentFrame.Click then
					NS.Variables.CurrentFrame.Click(NS.Variables.CurrentFrame, "")
				else
					if NS.Variables.CurrentFrame.GetScript and pcall(function() NS.Variables.CurrentFrame:GetScript("OnClick") end) then
						NS.Variables.CurrentFrame:Click()
					end
				end
			end

			CallbackRegistry:Trigger("INPUT_NAVIGATION_INTERACT")
		end

		function Script:Nav_SpecialInteract1()
			if NS.Variables.CurrentFrame and NS.Variables.CurrentFrame.Input_UseSpecialInteract then
				Script:Settings_SpecialInteractFunc1(NS.Variables.CurrentFrame.Type, NS.Variables.CurrentFrame)
			end
		end

		function Script:Nav_SpecialInteract2()
			if NS.Variables.CurrentFrame and NS.Variables.CurrentFrame.Input_UseSpecialInteract then
				Script:Settings_SpecialInteractFunc2(NS.Variables.CurrentFrame.Type, NS.Variables.CurrentFrame)
			end
		end

		--------------------------------

		function Script:Nav_MoveUp(customFrame)
			local Frame = customFrame or NS.Variables.CurrentFrame

			--------------------------------

			if Frame and Frame.Input_Relatives_Top then
				if Frame.Input_Relatives_Top:IsVisible() and (not Frame.Input_Relatives_Top.IsEnabled or (Frame.Input_Relatives_Top.IsEnabled and Frame.Input_Relatives_Top:IsEnabled())) then
					Script:RegisterNewFrame(Frame.Input_Relatives_Top)
				else
					Script:Nav_MoveUp(Frame.Input_Relatives_Top)
				end
			end
		end

		function Script:Nav_MoveDown(customFrame)
			local Frame = customFrame or NS.Variables.CurrentFrame

			--------------------------------

			if Frame and Frame.Input_Relatives_Bottom then
				if Frame.Input_Relatives_Bottom:IsVisible() and (not Frame.Input_Relatives_Bottom.IsEnabled or (Frame.Input_Relatives_Bottom.IsEnabled and Frame.Input_Relatives_Bottom:IsEnabled())) then
					Script:RegisterNewFrame(Frame.Input_Relatives_Bottom)
				else
					Script:Nav_MoveDown(Frame.Input_Relatives_Bottom)
				end
			end
		end

		function Script:Nav_MoveLeft(customFrame)
			local Frame = customFrame or NS.Variables.CurrentFrame

			--------------------------------

			if Frame and Frame.Input_Relatives_Left then
				if Frame.Input_Relatives_Left:IsVisible() and (not Frame.Input_Relatives_Left.IsEnabled or (Frame.Input_Relatives_Left.IsEnabled and Frame.Input_Relatives_Left:IsEnabled())) then
					Script:RegisterNewFrame(Frame.Input_Relatives_Left)
				else
					Script:Nav_MoveLeft(Frame.Input_Relatives_Left)
				end
			end
		end

		function Script:Nav_MoveRight(customFrame)
			local Frame = customFrame or NS.Variables.CurrentFrame

			--------------------------------

			if Frame and Frame.Input_Relatives_Right then
				if Frame.Input_Relatives_Right:IsVisible() and (not Frame.Input_Relatives_Right.IsEnabled or (Frame.Input_Relatives_Right.IsEnabled and Frame.Input_Relatives_Right:IsEnabled())) then
					Script:RegisterNewFrame(Frame.Input_Relatives_Right)
				else
					Script:Nav_MoveRight(Frame.Input_Relatives_Right)
				end
			end
		end

		--------------------------------

		function Script:Nav_ScrollUp()
			local Result = false

			--------------------------------

			if NS.Variables.CurrentFrame and NS.Variables.CurrentFrame.Input_ScrollFrame and NS.Variables.CurrentFrame.Input_ScrollChildFrame and not NS.Variables.CurrentFrame.Input_PreventManualScrolling then
				local CurrentScrollY = NS.Variables.CurrentFrame.Input_ScrollFrame:GetVerticalScroll()
				local CurrentScrollX = NS.Variables.CurrentFrame.Input_ScrollFrame:GetHorizontalScroll()
				local ScrollRangeY = NS.Variables.CurrentFrame.Input_ScrollFrame:GetVerticalScrollRange()
				local ScrollRangeX = NS.Variables.CurrentFrame.Input_ScrollFrame:GetHorizontalScrollRange()

				if ((NS.Variables.CurrentFrame.Input_Axis == "y" and (CurrentScrollY < 0 or CurrentScrollY > ScrollRangeY)) or (NS.Variables.CurrentFrame.Input_Axis == "x" and (CurrentScrollX < 0 or CurrentScrollX > ScrollRangeX))) then
					Result = false
				else
					Result = true
				end

				--------------------------------

				if Result then
					if NS.Variables.CurrentFrame.Input_Axis == "y" then
						NS.Variables.CurrentFrame.Input_ScrollFrame:SetVerticalScroll(NS.Variables.CurrentFrame.Input_ScrollFrame:GetVerticalScroll() - 50)
					elseif NS.Variables.CurrentFrame.Input_Axis == "x" then
						NS.Variables.CurrentFrame.Input_ScrollFrame:SetHorizontalScroll(NS.Variables.CurrentFrame.Input_ScrollFrame:GetHorizontalScroll() - 50)
					end

					--------------------------------

					if NS.Variables.CurrentFrame.MouseWheel then
						NS.Variables.CurrentFrame.MouseWheel()
					end
				end
			end

			--------------------------------

			return Result
		end

		function Script:Nav_ScrollDown()
			local Result = false

			--------------------------------

			if NS.Variables.CurrentFrame and NS.Variables.CurrentFrame.Input_ScrollFrame and NS.Variables.CurrentFrame.Input_ScrollChildFrame and not NS.Variables.CurrentFrame.Input_PreventManualScrolling then
				local CurrentScrollY = NS.Variables.CurrentFrame.Input_ScrollFrame:GetVerticalScroll()
				local CurrentScrollX = NS.Variables.CurrentFrame.Input_ScrollFrame:GetHorizontalScroll()
				local ScrollRangeY = NS.Variables.CurrentFrame.Input_ScrollFrame:GetVerticalScrollRange()
				local ScrollRangeX = NS.Variables.CurrentFrame.Input_ScrollFrame:GetHorizontalScrollRange()

				if ((NS.Variables.CurrentFrame.Input_Axis == "y" and (CurrentScrollY < 0 or CurrentScrollY > ScrollRangeY)) or (NS.Variables.CurrentFrame.Input_Axis == "x" and (CurrentScrollX < 0 or CurrentScrollX > ScrollRangeX))) then
					Result = false
				else
					Result = true
				end

				--------------------------------

				if Result then
					if NS.Variables.CurrentFrame.Input_Axis == "y" then
						NS.Variables.CurrentFrame.Input_ScrollFrame:SetVerticalScroll(NS.Variables.CurrentFrame.Input_ScrollFrame:GetVerticalScroll() + 50)
					elseif NS.Variables.CurrentFrame.Input_Axis == "x" then
						NS.Variables.CurrentFrame.Input_ScrollFrame:SetHorizontalScroll(NS.Variables.CurrentFrame.Input_ScrollFrame:GetHorizontalScroll() + 50)
					end

					--------------------------------

					if NS.Variables.CurrentFrame.MouseWheel then
						NS.Variables.CurrentFrame.MouseWheel()
					end
				end
			end

			--------------------------------

			return Result
		end
	end

	--------------------------------
	-- FUNCTIONS (UTILITIES)
	--------------------------------

	do
		function Script:UpdateScrollFramePosition(scrollFrame, selectedFrame, axis)
			local point, relativeTo, relativePoint, offsetX, offsetY = selectedFrame:GetPoint()

			if axis == "x" then
				AdaptiveAPI.Animation:SetHorizontalScrollTo(scrollFrame, scrollFrame:GetHorizontalScroll(), (math.min(scrollFrame:GetHorizontalScrollRange(), math.max(0, offsetX - scrollFrame:GetWidth() / 2))))
			elseif axis == "y" then
				AdaptiveAPI.Animation:SetVerticalScrollTo(scrollFrame, scrollFrame:GetVerticalScroll(), (math.min(scrollFrame:GetVerticalScrollRange(), math.max(0, math.abs(offsetY) - scrollFrame:GetHeight() / 2))))
			end
		end
	end

	--------------------------------
	-- CALLBACKS
	--------------------------------

	do
		function Script:StartInteraction()

		end

		function Script:StopInteraction()

		end

		CallbackRegistry:Add("START_INTERACTION", function()
			Script:StartInteraction()
		end, 0)

		CallbackRegistry:Add("STOP_INTERACTION", function()
			Script:StopInteraction()
		end, 0)
	end

	--------------------------------
	-- EVENTS
	--------------------------------
end
