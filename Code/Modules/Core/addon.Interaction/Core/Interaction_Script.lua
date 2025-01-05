local addonName, addon = ...
local CallbackRegistry = addon.CallbackRegistry
local L = addon.Locales
local NS = addon.Interaction

--------------------------------

NS.Script = {}

--------------------------------

function NS.Script:Load()
	--------------------------------
	-- FUNCTIONS
	--------------------------------

	do
		local LastNPC
		local LastFrameType
		local LastQuestID
		local LastDialog

		function NS.Script:SetActiveState(value)
			NS.Variables.LastActive = NS.Variables.Active
			NS.Variables.Active = value
		end

		function NS.Script:IsNewQuestNPC(hideSameNPC)
			local IsSameQuestNPC = (not hideSameNPC or hideSameNPC == nil) and (UnitName("questnpc") == NS.Variables.LastQuestNPC)
			local IsStaticNPC = (AdaptiveAPI:FindItemInInventory(UnitName("questnpc")))
			NS.Variables.LastQuestNPC = UnitName("questnpc")

			if (IsStaticNPC) and not (IsSameQuestNPC) and (NS.Variables.Active) then
				return true
			else
				return false
			end
		end

		function NS.Script:Stop(skip, deselectTarget)
			if InteractionDialogFrame and InteractionDialogFrame:IsVisible() then
				InteractionDialogFrame:Hide()
			end

			--------------------------------

			LastNPC = nil
			LastFrameType = nil
			LastQuestID = nil

			NS.Variables.GossipLastNPC = nil
			NS.Variables.GossipFirstInteractMessage = nil
			NS.Variables.LastActiveTime = GetTime()

			NS.Variables.Type = nil

			--------------------------------

			local function CloseInteraction()
				if not NS.Variables.Active then
					return
				end

				--------------------------------

				do -- DESELECT TARGET
					if deselectTarget then
						C_PlayerInteractionManager.ClearInteraction()
					end
				end

				do -- BLIZZARD
					QuestFrame:Hide()
					GossipFrame:Hide()
				end

				do -- STATE
					NS.Script:SetActiveState(false)
				end

				do -- CALLBACK
					CallbackRegistry:Trigger("STOP_INTERACTION")
				end
			end

			--------------------------------

			if skip then
				CloseInteraction()
			else
				addon.Libraries.AceTimer:ScheduleTimer(function()
					if not GossipFrame:IsVisible() and not QuestFrame:IsVisible() then
						CloseInteraction()
					end
				end, .575)
			end
		end

		function NS.Script:Start(frameType)
			local NPC = UnitName("npc") or UnitName("questnpc")
			local FrameType = frameType
			local QuestID = GetQuestID() or 0

			local RewardQuestText = GetRewardText()
			local ProgressQuestText = GetProgressText()
			local GreetingQuestText = GetGreetingText()
			local InfoQuestText = GetQuestText()
			local GossipText = C_GossipInfo.GetText()

			local Dialog
			if frameType == "quest-reward" then
				Dialog = RewardQuestText
			elseif frameType == "quest-progress" then
				Dialog = ProgressQuestText
			elseif frameType == "gossip" then
				Dialog = GossipText
			elseif frameType == "quest-greeting" then
				Dialog = GreetingQuestText
			elseif frameType == "quest-detail" then
				Dialog = InfoQuestText
			end

			--------------------------------

			if (LastNPC == NPC) and (LastFrameType == FrameType) and (LastQuestID == QuestID) and (LastDialog == Dialog) then
				return
			end

			if (not GossipFrame:IsVisible() and not QuestFrame:IsVisible()) or (InCombatLockdown() and SettingsPanel:IsVisible()) then
				if (InCombatLockdown() and SettingsPanel:IsVisible()) then
					C_PlayerInteractionManager.ClearInteraction()
				end

				--------------------------------

				return
			end

			--------------------------------

			CallbackRegistry:Trigger("INITIATE_INTERACTION")

			--------------------------------

			GossipFrame.Clear()
			QuestFrame.Clear()

			--------------------------------

			LastNPC = NPC
			LastFrameType = FrameType
			LastQuestID = QuestID
			LastDialog = Dialog

			NS.Variables.Type = frameType

			--------------------------------

			NS.Variables.StartInteractionTime = GetTime()

			--------------------------------

			NS.Script:SetActiveState(true)

			--------------------------------

			CallbackRegistry:Trigger("START_INTERACTION", frameType)
		end
	end

	--------------------------------
	-- MANAGER
	--------------------------------

	do
		function NS.Script:Manager_Dialog_Start()
			local frameType = NS.Variables.Type

			--------------------------------

			addon.Interaction.Dialog.Variables.IsInInteraction = true
			addon.Interaction.Dialog.Variables.AllowAutoProgress = true
			addon.Interaction.Dialog.Variables.Finished = false

			addon.Interaction.Dialog.Variables.Temp_FrameType = frameType
			addon.Interaction.Dialog.Variables.Temp_CurrentIndex = 1
			addon.Interaction.Dialog.Variables.Temp_DialogStringList = {}
			addon.Interaction.Dialog.Variables.Temp_CurrentString = nil
			addon.Interaction.Dialog.Variables.Temp_IsScrollDialog = false
			addon.Interaction.Dialog.Variables.Temp_IsEmoteDialog = false
			addon.Interaction.Dialog.Variables.Temp_Temp_IsEmoteDialog = false
			addon.Interaction.Dialog.Variables.Temp_IsEmoteDialogIndexes = {}
			addon.Interaction.Dialog.Variables.Temp_NotEmoteDialogIndexes = {}
			addon.Interaction.Dialog.Variables.Temp_IsStylisedDialog = false

			--------------------------------

			addon.Interaction.Dialog.Script:GetString()

			--------------------------------

			do -- NAMEPLATE
				C_Timer.After(0, function()
					local Nameplate = C_NamePlate.GetNamePlateForUnit("npc")

					--------------------------------

					if not InCombatLockdown() then
						if Nameplate then
							Nameplate:Hide()
						end
					end
				end)
			end

			do -- START
				if #addon.Interaction.Dialog.Variables.Temp_DialogStringList[1] > 1 then
					addon.Interaction.Dialog.Script:UpdateString(true)

					--------------------------------

					InteractionDialogFrame.StartDialog()
				end
			end
		end

		function NS.Script:Manager_Dialog_Stop()
			addon.Interaction.Dialog.Variables.IsInInteraction = false
			addon.Interaction.Dialog.Variables.AllowAutoProgress = true
			addon.Interaction.Dialog.Variables.Finished = false

			addon.Interaction.Dialog.Variables.Temp_FrameType = nil
			addon.Interaction.Dialog.Variables.Temp_CurrentIndex = 1
			addon.Interaction.Dialog.Variables.Temp_DialogStringList = {}
			addon.Interaction.Dialog.Variables.Temp_CurrentString = nil
			addon.Interaction.Dialog.Variables.Temp_IsScrollDialog = false
			addon.Interaction.Dialog.Variables.Temp_IsEmoteDialog = false
			addon.Interaction.Dialog.Variables.Temp_Temp_IsEmoteDialog = false
			addon.Interaction.Dialog.Variables.Temp_IsEmoteDialogIndexes = {}
			addon.Interaction.Dialog.Variables.Temp_NotEmoteDialogIndexes = {}
			addon.Interaction.Dialog.Variables.Temp_IsStylisedDialog = false

			--------------------------------

			InteractionDialogFrame.StopDialog()
		end

		function NS.Script:Manager_Gossip_Visibility()
			local IsInteractingWithNPC = (UnitName("npc") or UnitName("questnpc"))
			local IsDialog = (InteractionDialogFrame:IsVisible())
			local IsQuest = (NS.Variables.Type == "quest-detail" or NS.Variables.Type == "quest-reward" or NS.Variables.Type == "quest-progress")
			local IsGossip = (NS.Variables.Type == "gossip" or NS.Variables.Type == "quest-greeting")

			local IsInitalized = (addon.Interaction.Variables.Active)
			local IsDialogFinished = (addon.Interaction.Dialog.Variables.Finished)

			--------------------------------

			if IsInitalized and IsInteractingWithNPC and IsGossip and (INTDB.profile.INT_ALWAYS_SHOW_GOSSIP or (not INTDB.profile.INT_ALWAYS_SHOW_GOSSIP and not IsDialog and IsDialogFinished)) then
				InteractionGossipFrame.ShowWithAnimation()

				--------------------------------

				InteractionGossipFrame.UpdateAll()
			else
				InteractionGossipFrame.HideWithAnimation()
			end
		end

		function NS.Script:Manager_Quest_Visibility()
			local IsFinishedDialog = (addon.Interaction.Dialog.Variables.Finished)
			local IsGossip = (NS.Variables.Type == "gossip" or NS.Variables.Type == "quest-greeting")
			local IsQuest = (NS.Variables.Type == "quest-detail" or NS.Variables.Type == "quest-reward" or NS.Variables.Type == "quest-progress")

			--------------------------------

			if INTDB.profile.INT_ALWAYS_SHOW_QUEST then
				if (IsQuest and not IsGossip) then
					InteractionQuestFrame.ShowWithAnimation()
				else
					InteractionQuestFrame.HideWithAnimation()
				end
			else
				if (IsQuest and not IsGossip) and (IsFinishedDialog) then
					InteractionQuestFrame.ShowWithAnimation()
				else
					InteractionQuestFrame.HideWithAnimation()
				end
			end
		end

		function NS.Script:Manager_Quest_Start()
			if InteractionQuestFrame:IsVisible() then
				InteractionQuestFrame:Hide()
				InteractionQuestFrame.hidden = true
			end
		end

		function NS.Script:Manager_Update()
			NS.Script:Manager_Gossip_Visibility()
			NS.Script:Manager_Quest_Visibility()
		end

		--------------------------------

		CallbackRegistry:Add("START_INTERACTION", NS.Script.Manager_Update, 5)
		CallbackRegistry:Add("STOP_INTERACTION", NS.Script.Manager_Update, 5)
		CallbackRegistry:Add("START_DIALOG", NS.Script.Manager_Update, 5)
		CallbackRegistry:Add("STOP_DIALOG", NS.Script.Manager_Update, 5)

		CallbackRegistry:Add("START_INTERACTION", NS.Script.Manager_Dialog_Start, 5)
		CallbackRegistry:Add("STOP_INTERACTION", NS.Script.Manager_Dialog_Stop, 5)
		CallbackRegistry:Add("START_INTERACTION", NS.Script.Manager_Quest_Start, 4)
	end

	--------------------------------
	-- EVENTS
	--------------------------------

	do
		CallbackRegistry:Add("GOSSIP_BUTTON_CLICKED", function(button)
			local atlas, texture = button.IconTexture:GetAtlas(), button.IconTexture:GetTexture()

			--------------------------------

			local IsTrainer = (atlas == 132058 or texture == 132058)

			--------------------------------

			if IsTrainer then
				if not InCombatLockdown() then
					UIParent:Show()
				end

				NS.Script:Stop()
			end
		end, 0)

		--------------------------------

		do -- PREVENT OVERLAPPING FRAMES
			hooksecurefunc(QuestFrame, "Show", function()
				if GossipFrame:IsVisible() then
					GossipFrame:Hide()
				end
			end)

			hooksecurefunc(GossipFrame, "Show", function()
				if QuestFrame:IsVisible() then
					QuestFrame:Hide()
				end
			end)
		end

		do -- START INTERACTION
			local _ = CreateFrame("Frame")
			_:RegisterEvent("QUEST_DETAIL")
			_:RegisterEvent("QUEST_COMPLETE")
			_:RegisterEvent("QUEST_GREETING")
			_:RegisterEvent("QUEST_PROGRESS")
			_:RegisterEvent("GOSSIP_SHOW")
			_:SetScript("OnEvent", function(self, event, ...)
				if (not addon.Initialize.Ready) then
					C_PlayerInteractionManager.ClearInteraction()
					return
				end

				--------------------------------

				local function StartInteraction(type)
					NS.Script:Start(type)
				end

				--------------------------------

				if event == "QUEST_DETAIL" then
					StartInteraction("quest-detail")
				elseif event == "QUEST_COMPLETE" then
					StartInteraction("quest-reward")
				elseif event == "QUEST_GREETING" then
					StartInteraction("quest-greeting")
				elseif event == "QUEST_PROGRESS" then
					StartInteraction("quest-progress")
				elseif event == "GOSSIP_SHOW" then
					StartInteraction("gossip")
				end
			end)
		end

		do -- STOP INTERACTION
			C_AddOns.LoadAddOn("Blizzard_FlightMap")
			C_AddOns.LoadAddOn("Blizzard_ProfessionsCustomerOrders")
			C_AddOns.LoadAddOn("Blizzard_OrderHallUI")
			C_AddOns.LoadAddOn("Blizzard_PlayerChoice")

			--------------------------------

			CallbackRegistry:Add("INITIATE_INTERACTION", function()
				WorldMapFrame:Hide()

				--------------------------------

				if not InCombatLockdown() then
					SettingsPanel:Hide()
				end
			end, 0)


			hooksecurefunc(QuestFrame, "Hide", function()
				NS.Script:Stop()
			end)

			hooksecurefunc(GossipFrame, "Hide", function()
				NS.Script:Stop()
			end)

			hooksecurefunc(GameMenuFrame, "Show", function()
				NS.Script:Stop(true)
			end)

			hooksecurefunc(WorldMapFrame, "Show", function()
				NS.Script:Stop(true)
			end)

			if not addon.Variables.IS_CLASSIC then
				hooksecurefunc(PlayerChoiceFrame, "Show", function()
					NS.Script:Stop()
				end)

				hooksecurefunc(QuestLogPopupDetailFrame, "Show", function()
					NS.Script:Stop()
				end)
			else
				hooksecurefunc(QuestLogFrame, "Show", function()
					NS.Script:Stop()
				end)
			end

			addon.Libraries.AceTimer:ScheduleTimer(function()
				local frames = {
					MerchantFrame,
					FlightMapFrame,
					ProfessionsCustomerOrdersFrame,
					OrderHallTalentFrame,
					MajorFactionRenownFrame,
					ClassTrainerFrame,
				}

				for f1 = 1, #frames do
					hooksecurefunc(frames[f1], "Show", function()
						NS.Script:Stop(true)
						frames[f1]:SetIgnoreParentAlpha(true)
					end)

					hooksecurefunc(frames[f1], "Hide", function()
						NS.Script:Stop()
					end)
				end
			end, addon.Variables.INIT_DELAY_LAST)
		end

		do -- ALERT
			do -- COMBAT
				local Combat_AlertShowForSession = false

				--------------------------------

				local _ = CreateFrame("Frame")
				_:RegisterEvent("PLAYER_REGEN_DISABLED")
				_:SetScript("OnEvent", function(self, event, arg1, arg2)
					if event == "PLAYER_REGEN_DISABLED" then
						if NS.Variables.Active and addon.Cinematic.Variables.Active and not Combat_AlertShowForSession then
							Combat_AlertShowForSession = true

							--------------------------------

							addon.Alert.Script:Show(addon.Variables.PATH .. "Art/Alert/swords.png", L["Alert - Under Attack"], 17.5, addon.SoundEffects.Alert_Combat_Show, addon.SoundEffects.Alert_Combat_Hide)
						end
					end
				end)

				--------------------------------

				CallbackRegistry:Add("START_INTERACTION", function()
					Combat_AlertShowForSession = false
				end, 0)
			end

			do -- TUTORIAL (SETTINGS)
				CallbackRegistry:Add("START_INTERACTION", function()
					if not INTDB.profile.TutorialSettingsShown then
						INTDB.profile.TutorialSettingsShown = true

						--------------------------------

						local Shortcut

						if addon.Input.Variables.IsController then
							Shortcut = AdaptiveAPI:InlineIcon(addon.Variables.PATH .. "Art/Blizzard/Settings/shortcut-controller.png", 25, 25, 0, 0) .. L["Alert - Open Settings"]
						else
							Shortcut = AdaptiveAPI:InlineIcon(addon.Variables.PATH .. "Art/Blizzard/Settings/shortcut-pc.png", 25, 75, 0, 0) .. L["Alert - Open Settings"]
						end

						--------------------------------

						addon.Alert.Script:Show(addon.Variables.PATH .. "Art/Alert/cog.png", Shortcut, 12.5, nil, nil, 5)
					end
				end, 0)
			end
		end
	end

	--------------------------------
	-- SETUP
	--------------------------------

	do
		GossipFrame.Clear()
		QuestFrame.Clear()
	end
end
