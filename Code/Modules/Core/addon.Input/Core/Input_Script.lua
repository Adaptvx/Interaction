-- [Input_Script.lua] contains logic and handling
-- for the Input system, such as performing
-- actions with keyboard shortcuts,
-- or GamePad navigation.

---@class addon
local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local PrefabRegistry = addon.PrefabRegistry
local L = addon.Locales
local NS = addon.Input; addon.Input = NS

--------------------------------

NS.Script = {}

--------------------------------

function NS.Script:Load()
	--------------------------------
	-- REFERENCES
	--------------------------------

	local Callback = NS.Script; NS.Script = Callback

	--------------------------------
	-- FUNCTIONS (INPUT)
	--------------------------------

	do
		Callback.Input = {}
		Callback.Input.FRAME_KEYBIND = nil

		Callback.Input.Checks = {}
		Callback.Input.Checks.IsDialog = nil
		Callback.Input.Checks.IsAlwaysShowGossip = nil
		Callback.Input.Checks.IsGossip = nil
		Callback.Input.Checks.IsGossipVisible = nil
		Callback.Input.Checks.IsQuest = nil
		Callback.Input.Checks.IsQuestRewardSelection = nil
		Callback.Input.Checks.IsPrompt = nil
		Callback.Input.Checks.IsPromptText = nil

		--------------------------------

		do -- LOGIC
			function Callback.Input:UpdateAll()
				NS.Variables:UpdatePlatform()
				NS.Variables:UpdateKeybinds()
				Callback.Input:UpdateChecks()
			end

			function Callback.Input:UpdateChecks()
				-- DIALOG
				Callback.Input.Checks.IsDialog = (InteractionFrame.DialogFrame:IsVisible())

				-- GOSSIP
				Callback.Input.Checks.IsAlwaysShowGossip = (addon.Database.DB_GLOBAL.profile.INT_ALWAYS_SHOW_GOSSIP)
				Callback.Input.Checks.IsGossip = (not Callback.Input.Checks.IsDialog and InteractionFrame.GossipFrame:IsVisible())
				Callback.Input.Checks.IsGossipVisible = (not InteractionFrame.GossipFrame.hidden)

				-- QUEST
				Callback.Input.Checks.IsQuest = (InteractionFrame.QuestFrame:IsVisible())
				Callback.Input.Checks.IsQuestRewardSelection = (Callback.Input.Checks.IsQuest and addon.Interaction.Quest.Variables.Num_Choice >= 1)

				-- PROMPT
				Callback.Input.Checks.IsPrompt = (InteractionFrame.PromptFrame:IsVisible())
				Callback.Input.Checks.IsPromptText = (InteractionTextPromptFrame:IsVisible())
			end

			function Callback.Input:PreventInput()
				addon.API.Main:PreventInput(Callback.Input.FRAME_KEYBIND)
			end

			function Callback.Input:Process_Global(_, key)
				local result = true
				local allowDialog = true

				--------------------------------

				Callback.Input:UpdateChecks()

				--------------------------------

				do -- Prompt
					if (Callback.Input.Checks.IsPrompt) and (result) then
						do -- Accept/Decline
							if NS.Variables:IsKey(key, NS.Variables.Key_Prompt_Accept) then
								Callback.Input:PreventInput()
								result = false

								--------------------------------

								addon.Prompt.Script:ClickButton(1)
							end

							if NS.Variables:IsKey(key, NS.Variables.Key_Prompt_Decline) then
								Callback.Input:PreventInput()
								result = false

								--------------------------------

								addon.Prompt.Script:ClickButton(2)
							end
						end

						do -- Close
							if NS.Variables:IsKey(key, NS.Variables.Key_Close) then
								Callback.Input:PreventInput()
								result = false

								--------------------------------

								addon.Prompt.Script:Clear()

								--------------------------------

								return
							end
						end
					end
				end

				do -- Text Prompt
					if (Callback.Input.Checks.IsPromptText) and (result) then
						do -- CLOSE
							if NS.Variables:IsKey(key, NS.Variables.Key_Close) then
								Callback.Input:PreventInput()
								result = false

								--------------------------------

								InteractionTextPromptFrame:HideWithAnimation()
							end
						end
					end
				end

				do -- Settings
					if result then
						if InteractionSettingsFrame then
							do -- Toggle
								local isSettings = InteractionSettingsFrame:IsVisible()

								--------------------------------

								if (isSettings and key == "ESCAPE") or (not isSettings and key == "ESCAPE" and IsShiftKeyDown()) then
									Callback.Input:PreventInput()
									result = false

									--------------------------------

									if isSettings then
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
					if (Callback.Input.Checks.IsQuest) and (result) then
						do -- Progress
							if NS.Variables:IsKey(key, NS.Variables.Key_Progress) then
								local isAutoAccept = addon.API.Main:IsAutoAccept()

								--------------------------------

								if isAutoAccept then
									if InteractionFrame.QuestFrame.REF_FOOTER_CONTENT.GoodbyeButton:IsVisible() and InteractionFrame.QuestFrame.REF_FOOTER_CONTENT.GoodbyeButton:IsEnabled() then
										Callback.Input:PreventInput()
										result = false

										--------------------------------

										InteractionFrame.QuestFrame.REF_FOOTER_CONTENT.GoodbyeButton:Click()
									end
								else
									if InteractionFrame.QuestFrame.REF_FOOTER_CONTENT.AcceptButton:IsVisible() and InteractionFrame.QuestFrame.REF_FOOTER_CONTENT.AcceptButton:IsEnabled() then
										Callback.Input:PreventInput()
										result = false

										--------------------------------

										InteractionFrame.QuestFrame.REF_FOOTER_CONTENT.AcceptButton:Click()
									end
								end

								if InteractionFrame.QuestFrame.REF_FOOTER_CONTENT.ContinueButton:IsVisible() and InteractionFrame.QuestFrame.REF_FOOTER_CONTENT.ContinueButton:IsEnabled() then
									Callback.Input:PreventInput()
									result = false

									--------------------------------

									InteractionFrame.QuestFrame.REF_FOOTER_CONTENT.ContinueButton:Click()
								end

								if InteractionFrame.QuestFrame.REF_FOOTER_CONTENT.CompleteButton:IsVisible() and InteractionFrame.QuestFrame.REF_FOOTER_CONTENT.CompleteButton:IsEnabled() then
									Callback.Input:PreventInput()
									result = false

									--------------------------------

									InteractionFrame.QuestFrame.REF_FOOTER_CONTENT.CompleteButton:Click()
								end
							end
						end

						do -- Select Reward
							if NS.Variables:IsKey(key, NS.Variables.Key_Quest_NextReward) then
								local isRewardSelection = (addon.Interaction.Quest.Variables.Num_Choice >= 1)
								local choiceNum = (addon.Interaction.Quest.Variables.Num_Choice)
								local Button_Choice_Selected = (QuestInfoFrame.itemChoice)
								local choiceButtons = (addon.Interaction.Quest.Variables.Buttons_Choice)

								--------------------------------

								if isRewardSelection then
									Callback.Input:PreventInput()
									result = false

									--------------------------------

									if Button_Choice_Selected < choiceNum then
										Button_Choice_Selected = Button_Choice_Selected + 1
									else
										Button_Choice_Selected = 1
									end

									--------------------------------

									InteractionFrame.QuestFrame:DeselectAllButtons()
									choiceButtons[Button_Choice_Selected]:OnEnter()
									choiceButtons[Button_Choice_Selected]:OnMouseUp()

									Callback:UpdateScrollFramePosition(InteractionFrame.QuestFrame.REF_MAIN_SCROLLFRAME, choiceButtons[Button_Choice_Selected], "y")
								end
							end
						end
					end
				end

				do -- Gossip
					if (Callback.Input.Checks.IsGossip) or (Callback.Input.Checks.IsAlwaysShowGossip and Callback.Input.Checks.IsGossipVisible) then
						local isController = (NS.Variables.IsController or NS.Variables.SimulateController)

						--------------------------------

						if isController then
							if NS.Variables:IsKey(key, NS.Variables.Key_Interact) then
								Callback.Input:PreventInput()
								allowDialog = false
							end
						end
					end
				end

				do -- Dialog
					if result and allowDialog then
						if addon.Interaction.Variables.Active then
							do -- Skip
								if NS.Variables:IsKey(key, NS.Variables.Key_Skip) then
									local IsController = ((NS.Variables.IsController or NS.Variables.SimulateController))
									local IsQuestFrameVisible = (InteractionFrame.QuestFrame:IsVisible() and InteractionFrame.QuestFrame:GetAlpha() > .1)
									local IsGossipFrameVisible = (InteractionFrame.GossipFrame:IsVisible() and InteractionFrame.GossipFrame:GetAlpha() > .1)
									local IsGossipButtonsAvailable = (#InteractionFrame.GossipFrame:GetButtons() > 0)

									local BlockOnQuestFrame = (IsQuestFrameVisible)
									local BlockOnGossipFrame = (IsController and IsGossipFrameVisible and IsGossipButtonsAvailable)

									--------------------------------

									if not BlockOnQuestFrame and not BlockOnGossipFrame then
										if InteractionFrame.DialogFrame:IsVisible() then
											Callback.Input:PreventInput()
											result = false

											--------------------------------

											addon.Interaction.Dialog.Script:Stop()

											--------------------------------

											return
										end
									end
								end
							end

							do -- Next/Previous
								if Callback.Input.Checks.IsDialog or Callback.Input.Checks.IsGossip or Callback.Input.Checks.IsQuest then
									if NS.Variables:IsKey(key, NS.Variables.Key_Next) and Callback.Input.Checks.IsDialog then
										Callback.Input:PreventInput()
										result = false

										--------------------------------

										addon.Interaction.Dialog.Variables.Playback_AutoProgress = false
										addon.Interaction.Dialog.Script:IncrementIndex(true)

										--------------------------------

										return
									end

									if NS.Variables:IsKey(key, NS.Variables.Key_Previous) then
										Callback.Input:PreventInput()
										result = false

										--------------------------------

										addon.Interaction.Dialog.Script:DecrementIndex(true)

										--------------------------------

										return
									end
								end
							end
						end
					end
				end

				do -- Interaction
					if result then
						if addon.Interaction.Variables.Active then
							do -- Close
								if NS.Variables:IsKey(key, NS.Variables.Key_Close) then
									Callback.Input:PreventInput()
									result = false

									--------------------------------

									local isGossip = (InteractionFrame.GossipFrame:IsVisible())
									local isQuest = (InteractionFrame.QuestFrame:IsVisible())

									if isGossip or isQuest then
										if isGossip then
											InteractionFrame.GossipFrame:HideWithAnimation()
										end

										if isQuest then
											InteractionFrame.QuestFrame:HideWithAnimation()
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

				do -- Readable
					if result then
						if InteractionReadableUIFrame then
							do -- Close
								if InteractionReadableUIFrame:IsVisible() then
									if NS.Variables:IsKey(key, NS.Variables.Key_Close) then
										Callback.Input:PreventInput()
										result = false

										--------------------------------

										InteractionReadableUIFrame:HideWithAnimation()
									end
								end
							end
						end
					end
				end

				--------------------------------

				return result
			end

			function Callback.Input:Process_Keyboard(_, key)
				Callback.Input:UpdateChecks()

				--------------------------------

				if NS.Variables.SimulateController then
					Callback.Input:Process_GamePad(_, key)
				end

				if NS.Variables.IsPC or not NS.Variables.IsControllerEnabled then
					do -- Gossip
						if (Callback.Input.Checks.IsGossip) or (Callback.Input.Checks.IsAlwaysShowGossip and Callback.Input.Checks.IsGossipVisible) then
							local Buttons = InteractionFrame.GossipFrame:GetButtons()

							--------------------------------

							if Buttons then
								for _ = 1, #Buttons do
									local function SelectButton(index)
										if not addon.Interaction.Gossip.Variables.RefreshInProgress then
											if Buttons[index].isMouseOver == false then
												Buttons[index]:OnEnter()
												Buttons[index]:OnMouseUp()
											end

											--------------------------------

											addon.Libraries.AceTimer:ScheduleTimer(function()
												if Buttons[index].isMouseOver == true then
													Buttons[index]:OnLeave()
												end
											end, .125)
										end
									end

									--------------------------------

									if not IsShiftKeyDown() and key == tostring(_) then
										Callback.Input:PreventInput()

										--------------------------------

										SelectButton(_)
									end

									if IsShiftKeyDown() and key == tostring(_ - 9) then
										Callback.Input:PreventInput()

										--------------------------------

										SelectButton(_)
									end
								end
							end
						end
					end

					do -- Quest
						if (Callback.Input.Checks.IsQuest) then
							-- <MORE TO ADD>
						end
					end
				end
			end

			function Callback.Input:Process_GamePad(_, key)
				local result = true

				--------------------------------

				Callback.Input:UpdateChecks()

				--------------------------------

				if (NS.Variables.IsController or NS.Variables.SimulateController) then
					do -- Navigation
						do -- Move
							if not NS.Variables.IsNavigating then
								return
							end

							--------------------------------

							if (NS.Variables:IsKey(key, NS.Variables.Key_ScrollUp)) and (result) then
								if Callback:Nav_ScrollUp() then
									Callback.Input:PreventInput()
									result = false
								end
							end

							if (NS.Variables:IsKey(key, NS.Variables.Key_ScrollDown)) and (result) then
								if Callback:Nav_ScrollDown() then
									Callback.Input:PreventInput()
									result = false
								end
							end

							if (NS.Variables:IsKey(key, NS.Variables.Key_MoveUp)) and (result) then
								Callback.Input:PreventInput()
								result = false

								--------------------------------

								Callback:Nav_MoveUp()
							end

							if (NS.Variables:IsKey(key, NS.Variables.Key_MoveLeft)) and (result) then
								Callback.Input:PreventInput()
								result = false

								--------------------------------

								Callback:Nav_MoveLeft()
							end

							if (NS.Variables:IsKey(key, NS.Variables.Key_MoveRight)) and (result) then
								Callback.Input:PreventInput()
								result = false

								--------------------------------

								Callback:Nav_MoveRight()
							end

							if (NS.Variables:IsKey(key, NS.Variables.Key_MoveDown)) and (result) then
								Callback.Input:PreventInput()
								result = false

								--------------------------------

								Callback:Nav_MoveDown()
							end
						end

						do -- Interact
							if not NS.Variables.IsNavigating then
								return
							end

							--------------------------------

							if (NS.Variables:IsKey(key, NS.Variables.Key_Interact)) then
								Callback.Input:PreventInput()
								result = false

								--------------------------------

								Callback:Nav_Interact()
							end

							if (NS.Variables:IsKey(key, NS.Variables.Key_Settings_SpecialInteract3)) then
								Callback.Input:PreventInput()
								result = false

								--------------------------------

								if NS.Variables.CurrentFrame.Input_UseSpecialInteract and NS.Variables.CurrentFrame.Input_UseSpecialInteract_Button then
									Callback:Nav_SpecialInteract1()
								end
							end

							if (NS.Variables:IsKey(key, NS.Variables.Key_Settings_SpecialInteract2)) then
								Callback.Input:PreventInput()
								result = false

								--------------------------------

								if NS.Variables.CurrentFrame.Input_UseSpecialInteract and not NS.Variables.CurrentFrame.Input_UseSpecialInteract_Button then
									Callback:Nav_SpecialInteract2()
								end
							end

							if (NS.Variables:IsKey(key, NS.Variables.Key_Settings_SpecialInteract1)) then
								Callback.Input:PreventInput()
								result = false

								--------------------------------

								if NS.Variables.CurrentFrame.Input_UseSpecialInteract and not NS.Variables.CurrentFrame.Input_UseSpecialInteract_Button then
									Callback:Nav_SpecialInteract1()
								end
							end
						end

						do -- Settings
							do -- Toggle
								local IsReadableUI = InteractionReadableUIFrame:IsVisible()
								local IsInteraction = addon.Interaction.Variables.Active
								local IsSettings = InteractionSettingsFrame:IsVisible()

								--------------------------------

								if (NS.Variables:IsKey(key, NS.Variables.Key_Settings_Toggle) and (IsInteraction or IsReadableUI or IsSettings)) and (result) then
									Callback.Input:PreventInput()
									result = false

									--------------------------------

									if IsSettings then
										addon.SettingsUI.Script:HideSettingsUI(false, true)
									elseif not IsSettings then
										addon.SettingsUI.Script:ShowSettingsUI(false, true)
									end

									if IsReadableUI then
										InteractionReadableUIFrame:HideWithAnimation(true)
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

								if (NS.Variables:IsKey(key, NS.Variables.Key_Settings_ChangeTabUp)) and (result) then
									if Callback.CurrentNavigationSession == "SETTING" then
										Callback.Input:PreventInput()
										result = false

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

								if (NS.Variables:IsKey(key, NS.Variables.Key_Settings_ChangeTabDown)) and (result) then
									if Callback.CurrentNavigationSession == "SETTING" then
										Callback.Input:PreventInput()
										result = false

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
		end

		do -- EVENTS
			local isRepeating = false
			local repeatDelay = .5
			local repeatInterval = .125

			local session = { ["key"] = nil, ["lastRepeat"] = nil, ["type"] = nil }

			--------------------------------

			local function ResetSession()
				isRepeating = false

				--------------------------------

				session = {
					key = nil,
					lastRepeat = nil,
					type = nil
				}
			end

			--------------------------------

			do -- SESSION
				local _ = CreateFrame("Frame")
				_:SetScript("OnUpdate", function(self, elapsed)
					if not addon.Initialize.Ready then
						return
					end

					if not session.key or not session.lastRepeat then
						return
					end

					--------------------------------

					local lastRepeat = session.lastRepeat
					local currentTime = GetTime()
					local key = session.key
					local type = session.type

					--------------------------------

					if not isRepeating then
						if currentTime - lastRepeat > repeatDelay then
							isRepeating = true
						end
					elseif currentTime - lastRepeat > repeatInterval then
						session.lastRepeat = currentTime

						--------------------------------

						if type == "Controller" then
							if Callback.Input:Process_Global(nil, key) then
								Callback.Input:Process_GamePad(nil, key)
							end
						end
					end
				end)
			end

			do -- KEYBIND
				local _ = CreateFrame("Frame")
				_:SetPropagateKeyboardInput(true)
				Callback.Input.FRAME_KEYBIND = _

				--------------------------------

				do -- PC
					_:SetScript("OnKeyDown", function(_, key)
						if not addon.Initialize.Ready then
							return
						end

						--------------------------------

						if Callback.Input:Process_Global(_, key) then
							Callback.Input:Process_Keyboard(_, key)
						end
					end)
				end

				do -- GAMEPAD
					_:SetScript("OnGamePadButtonDown", function(_, key)
						if not addon.Initialize.Ready then
							return
						end

						--------------------------------

						if Callback.Input:Process_Global(_, key) then
							Callback.Input:Process_GamePad(_, key)
						end

						--------------------------------

						ResetSession()
						if NS.Variables.IsNavigating then
							session = {
								key = key,
								lastRepeat = GetTime(),
								type = "Controller"
							}
						end
					end)

					_:SetScript("OnGamePadButtonUp", function(_, key)
						if not addon.Initialize.Ready then
							return
						end

						--------------------------------

						ResetSession()
					end)
				end
			end
		end

		do -- SETUP
			NS.Variables:UpdatePlatform()
			CallbackRegistry:Add("ADDON_READY", Callback.Input.UpdateAll, 0)
		end
	end

	--------------------------------
	-- FUNCTIONS (MAIN)
	--------------------------------

	do
		do -- SET
			-- Interact when not specified, is defaulted to the .Click/OnClick function if available. Variables: frame, relativeTop, relativeBottom, relativeLeft, relativeRight, scrollFrame, scrollChildFrame, axis, interact, specialInteract1, specialInteract2
			function Callback:SetFrameRelatives(tbl)
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

			function Callback:RegisterNewFrame(new)
				if not new then
					return
				end

				--------------------------------

				NS.Variables.PreviousFrame = NS.Variables.CurrentFrame
				NS.Variables.CurrentFrame = new

				--------------------------------

				local Frame = new

				--------------------------------

				do -- HIGHLIGHT
					do -- EXIT
						local function Trigger(frame)
							if frame then
								Callback:Frame_Leave(frame)
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
									Trigger(frame)
								end
							else
								Trigger(frame)
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

					do -- ENTER
						local function Trigger(frame, ignorePreviousFrame)
							if ignorePreviousFrame or frame ~= NS.Variables.PreviousFrame then
								Callback:Frame_Enter(frame)
							end
						end

						--------------------------------

						if NS.Variables.CurrentFrame then
							addon.Libraries.AceTimer:ScheduleTimer(function()
								if NS.Variables.CurrentFrame then
									Trigger(NS.Variables.CurrentFrame)

									if NS.Variables.CurrentFrame.Input_Parent then
										Trigger(NS.Variables.CurrentFrame.Input_Parent, true)
									end
								end
							end, 0)
						end
					end
				end

				do -- SCROLL FRAME POSITION
					if Frame.Input_ScrollFrame and Frame.Input_ScrollChildFrame and Frame.Input_Axis and Frame.Input_PreventManualScrolling then
						local ScrollFrame = Frame.Input_ScrollFrame
						local Axis = Frame.Input_Axis

						Callback:UpdateScrollFramePosition(ScrollFrame, Frame, Axis)
					end
				end

				--------------------------------

				CallbackRegistry:Trigger("INPUT_NAVIGATION_HIGHLIGHTED")
			end

			function Callback:ResetSelectedFrame(new)
				NS.Variables.PreviousFrame = nil
				NS.Variables.CurrentFrame = nil

				--------------------------------

				Callback:RegisterNewFrame(new)
			end
		end

		do -- INTERACT
			function Callback:Frame_Leave(frame)
				if frame.OnLeave then
					frame:OnLeave()
				else
					frame:SetAlpha(1)
				end

				--------------------------------

				if frame.API_HideTooltip then
					frame.API_HideTooltip()
				end
			end

			function Callback:Frame_Enter(frame)
				if frame.OnEnter then
					frame:OnEnter()

					--------------------------------

					if frame.API_ShowTooltip then
						frame.API_ShowTooltip()
					end
				else
					frame:SetAlpha(.5)
				end
			end
		end

		do -- NAVIGATION
			do -- STATE
				function Callback:StartNavigation(sessionName, defaultFrame, children)
					NS.Variables.PreviousFrame = nil
					NS.Variables.CurrentFrame = nil

					--------------------------------

					Callback:RegisterNewFrame(defaultFrame)

					--------------------------------

					for i = 1, #children do
						local frame = children[i]

						--------------------------------

						Callback:Frame_Leave(frame)
					end

					--------------------------------

					Callback.CurrentNavigationSession = sessionName
					NS.Variables.IsNavigating = true
				end

				function Callback:StopNavigation()
					NS.Variables.PreviousFrame = nil
					NS.Variables.CurrentFrame = nil

					--------------------------------

					Callback.CurrentNavigationSession = nil
					NS.Variables.IsNavigating = false
				end
			end

			do -- INTERACT
				do -- MOVE
					function Callback:Nav_MoveUp(customFrame)
						local Frame = customFrame or NS.Variables.CurrentFrame

						--------------------------------

						if Frame and Frame.Input_Relatives_Top then
							local isEnabled = (Frame.Input_Relatives_Top.IsEnabled ~= nil and Frame.Input_Relatives_Top:IsEnabled()) or (Frame.Input_Relatives_Top.IsEnabled == nil and true)
							local isEnabledFlag = (Frame.Input_Relatives_Top.enabled ~= nil and Frame.Input_Relatives_Top.enabled == true) or (Frame.Input_Relatives_Top.enabled == nil and true)

							--------------------------------

							if Frame.Input_Relatives_Top:IsVisible() and (isEnabled and isEnabledFlag) then
								Callback:RegisterNewFrame(Frame.Input_Relatives_Top)
							else
								Callback:Nav_MoveUp(Frame.Input_Relatives_Top)
							end
						end
					end

					function Callback:Nav_MoveDown(customFrame)
						local Frame = customFrame or NS.Variables.CurrentFrame

						--------------------------------

						if Frame and Frame.Input_Relatives_Bottom then
							local isEnabled = (Frame.Input_Relatives_Bottom.IsEnabled ~= nil and Frame.Input_Relatives_Bottom:IsEnabled()) or (Frame.Input_Relatives_Bottom.IsEnabled == nil and true)
							local isEnabledFlag = (Frame.Input_Relatives_Bottom.enabled ~= nil and Frame.Input_Relatives_Bottom.enabled == true) or (Frame.Input_Relatives_Bottom.enabled == nil and true)

							--------------------------------

							if Frame.Input_Relatives_Bottom:IsVisible() and (isEnabled and isEnabledFlag) then
								Callback:RegisterNewFrame(Frame.Input_Relatives_Bottom)
							else
								Callback:Nav_MoveDown(Frame.Input_Relatives_Bottom)
							end
						end
					end

					function Callback:Nav_MoveLeft(customFrame)
						local Frame = customFrame or NS.Variables.CurrentFrame

						--------------------------------

						if Frame and Frame.Input_Relatives_Left then
							local isEnabled = (Frame.Input_Relatives_Left.IsEnabled ~= nil and Frame.Input_Relatives_Left:IsEnabled()) or (Frame.Input_Relatives_Left.IsEnabled == nil and true)
							local isEnabledFlag = (Frame.Input_Relatives_Left.enabled ~= nil and Frame.Input_Relatives_Left.enabled == true) or (Frame.Input_Relatives_Left.enabled == nil and true)

							--------------------------------

							if Frame.Input_Relatives_Left:IsVisible() and (isEnabled and isEnabledFlag) then
								Callback:RegisterNewFrame(Frame.Input_Relatives_Left)
							else
								Callback:Nav_MoveLeft(Frame.Input_Relatives_Left)
							end
						end
					end

					function Callback:Nav_MoveRight(customFrame)
						local Frame = customFrame or NS.Variables.CurrentFrame

						--------------------------------

						if Frame and Frame.Input_Relatives_Right then
							local isEnabled = (Frame.Input_Relatives_Right.IsEnabled ~= nil and Frame.Input_Relatives_Right:IsEnabled()) or (Frame.Input_Relatives_Right.IsEnabled == nil and true)
							local isEnabledFlag = (Frame.Input_Relatives_Right.enabled ~= nil and Frame.Input_Relatives_Right.enabled == true) or (Frame.Input_Relatives_Right.enabled == nil and true)

							--------------------------------

							if Frame.Input_Relatives_Right:IsVisible() and (isEnabled and isEnabledFlag) then
								Callback:RegisterNewFrame(Frame.Input_Relatives_Right)
							else
								Callback:Nav_MoveRight(Frame.Input_Relatives_Right)
							end
						end
					end
				end

				do -- SCROLL
					function Callback:Nav_ScrollUp()
						local Result = false

						--------------------------------

						if NS.Variables.CurrentFrame and NS.Variables.CurrentFrame.Input_ScrollFrame and NS.Variables.CurrentFrame.Input_ScrollChildFrame and not NS.Variables.CurrentFrame.Input_PreventManualScrolling then
							local CurrentScrollY = NS.Variables.CurrentFrame.Input_ScrollFrame:GetVerticalScroll()
							local CurrentScrollX = NS.Variables.CurrentFrame.Input_ScrollFrame:GetHorizontalScroll()
							local ScrollRangeY = NS.Variables.CurrentFrame.Input_ScrollFrame:GetVerticalScrollRange()
							local ScrollRangeX = NS.Variables.CurrentFrame.Input_ScrollFrame:GetHorizontalScrollRange()

							if ((NS.Variables.CurrentFrame.Input_Axis == "y" and (CurrentScrollY <= 0) or (NS.Variables.CurrentFrame.Input_Axis == "x" and (CurrentScrollX < 0 or CurrentScrollX > ScrollRangeX)))) then
								Result = false
							else
								Result = true
							end

							--------------------------------

							if Result then
								if NS.Variables.CurrentFrame.Input_Axis == "y" then
									NS.Variables.CurrentFrame.Input_ScrollFrame:SetVerticalScroll(NS.Variables.CurrentFrame.Input_ScrollFrame:GetVerticalScroll() - NS.Variables.CurrentFrame.Input_ScrollFrame.stepSize, true)
								elseif NS.Variables.CurrentFrame.Input_Axis == "x" then
									NS.Variables.CurrentFrame.Input_ScrollFrame:SetHorizontalScroll(NS.Variables.CurrentFrame.Input_ScrollFrame:GetHorizontalScroll() - NS.Variables.CurrentFrame.Input_ScrollFrame.stepSize, true)
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

					function Callback:Nav_ScrollDown()
						local Result = false

						--------------------------------

						if NS.Variables.CurrentFrame and NS.Variables.CurrentFrame.Input_ScrollFrame and NS.Variables.CurrentFrame.Input_ScrollChildFrame and not NS.Variables.CurrentFrame.Input_PreventManualScrolling then
							local CurrentScrollY = NS.Variables.CurrentFrame.Input_ScrollFrame:GetVerticalScroll()
							local CurrentScrollX = NS.Variables.CurrentFrame.Input_ScrollFrame:GetHorizontalScroll()
							local ScrollRangeY = NS.Variables.CurrentFrame.Input_ScrollFrame:GetVerticalScrollRange()
							local ScrollRangeX = NS.Variables.CurrentFrame.Input_ScrollFrame:GetHorizontalScrollRange()

							if ((NS.Variables.CurrentFrame.Input_Axis == "y" and (CurrentScrollY >= ScrollRangeY)) or (NS.Variables.CurrentFrame.Input_Axis == "x" and (CurrentScrollX < 0 or CurrentScrollX > ScrollRangeX))) then
								Result = false
							else
								Result = true
							end

							--------------------------------

							if Result then
								if NS.Variables.CurrentFrame.Input_Axis == "y" then
									NS.Variables.CurrentFrame.Input_ScrollFrame:SetVerticalScroll(NS.Variables.CurrentFrame.Input_ScrollFrame:GetVerticalScroll() + NS.Variables.CurrentFrame.Input_ScrollFrame.stepSize, true)
								elseif NS.Variables.CurrentFrame.Input_Axis == "x" then
									NS.Variables.CurrentFrame.Input_ScrollFrame:SetHorizontalScroll(NS.Variables.CurrentFrame.Input_ScrollFrame:GetHorizontalScroll() + NS.Variables.CurrentFrame.Input_ScrollFrame.stepSize, true)
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

				do -- SPECIAL INTERACT
					function Callback:Nav_Interact()
						if NS.Variables.CurrentFrame then
							if NS.Variables.CurrentFrame.Input_Interact then
								NS.Variables.CurrentFrame.Input_Interact()
							elseif NS.Variables.CurrentFrame.OnMouseUp then
								NS.Variables.CurrentFrame:OnMouseUp()
							elseif NS.Variables.CurrentFrame.OnClick then
								NS.Variables.CurrentFrame:OnClick()
							else
								if NS.Variables.CurrentFrame.GetScript and pcall(function() NS.Variables.CurrentFrame:GetScript("OnClick") end) then
									NS.Variables.CurrentFrame:Click()
								end
							end
						end

						CallbackRegistry:Trigger("INPUT_NAVIGATION_INTERACT")
					end

					function Callback:Nav_SpecialInteract1()
						if NS.Variables.CurrentFrame and NS.Variables.CurrentFrame.Input_UseSpecialInteract then
							Callback:Settings_SpecialInteractFunc1(NS.Variables.CurrentFrame.Type, NS.Variables.CurrentFrame)
						end
					end

					function Callback:Nav_SpecialInteract2()
						if NS.Variables.CurrentFrame and NS.Variables.CurrentFrame.Input_UseSpecialInteract then
							Callback:Settings_SpecialInteractFunc2(NS.Variables.CurrentFrame.Type, NS.Variables.CurrentFrame)
						end
					end
				end
			end

			do -- UPDATE
				function Callback:UpdateScrollFramePosition(scrollFrame, selectedFrame, axis)
					local point, relativeTo, relativePoint, offsetX, offsetY = selectedFrame:GetPoint()

					--------------------------------

					if axis == "x" then
						scrollFrame:SetHorizontalScroll((math.min(scrollFrame:GetHorizontalScrollRange(), math.max(0, offsetX - scrollFrame:GetWidth() / 2))), true)
					elseif axis == "y" then
						scrollFrame:SetVerticalScroll((math.min(scrollFrame:GetVerticalScrollRange(), math.max(0, math.abs(offsetY) - scrollFrame:GetHeight() / 2))), true)
					end
				end
			end
		end
	end

	--------------------------------
	-- EVENTS
	--------------------------------
end
