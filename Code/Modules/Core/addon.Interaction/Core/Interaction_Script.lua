-- [!] [addon.Interaction] is used to manage NPC interaction custom logic such as displaying Quest/Gossip frame etc.

---@class addon
local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local PrefabRegistry = addon.PrefabRegistry
local L = addon.Locales
local NS = addon.Interaction; addon.Interaction = NS

--------------------------------

NS.Script = {}

--------------------------------

function NS.Script:Load()
	--------------------------------
	-- FUNCTIONS
	--------------------------------

	do
		function NS.Script:SetActiveState(value)
			NS.Variables.LastActive = NS.Variables.Active
			NS.Variables.Active = value
		end

		local function CloseInteraction(deselectTarget)
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
				HideUIPanel(QuestFrame)
				HideUIPanel(GossipFrame)
			end

			do -- STATE
				NS.Script:SetActiveState(false)
			end

			do -- CALLBACK
				CallbackRegistry:Trigger("STOP_INTERACTION")
			end
		end

		function NS.Script:Stop(skip, deselectTarget)
			if InteractionFrame.DialogFrame and InteractionFrame.DialogFrame:IsVisible() then
				InteractionFrame.DialogFrame:Hide()
			end

			--------------------------------

			NS.Variables.CurrentSession.type = nil
			NS.Variables.CurrentSession.questID = nil
			NS.Variables.CurrentSession.dialogText = nil
			NS.Variables.CurrentSession.npc = nil

			--------------------------------

			if skip then
				CloseInteraction(deselectTarget)
			else
				addon.Libraries.AceTimer:ScheduleTimer(function()
					if not GossipFrame:IsVisible() and not QuestFrame:IsVisible() then
						CloseInteraction(deselectTarget)
					end
				end, .575)
			end
		end

		function NS.Script:Start(frameType)
			local NPC = UnitName("npc") or UnitName("questnpc")
			local QuestID = GetQuestID() or 0

			local TEXT_REWARD = GetRewardText()
			local TEXT_PROGRESS = GetProgressText()
			local TEXT_GREETING = GetGreetingText()
			local TEXT_DETAIL = GetQuestText()
			local TEXT_GOSSIP = C_GossipInfo.GetText()
			local TEXT =
				frameType == "quest-reward" and TEXT_REWARD or
				frameType == "quest-progress" and TEXT_PROGRESS or
				frameType == "gossip" and TEXT_GOSSIP or
				frameType == "quest-greeting" and TEXT_GREETING or
				frameType == "quest-detail" and TEXT_DETAIL

			--------------------------------

			if (NS.Variables.CurrentSession.npc == NPC) and (NS.Variables.CurrentSession.type == frameType) and (NS.Variables.CurrentSession.questID == QuestID) and (NS.Variables.CurrentSession.dialogText == TEXT) then
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

			addon.BlizzardFrames.Script:Clear_GossipFrame()
			addon.BlizzardFrames.Script:Clear_QuestFrame()

			--------------------------------

			NS.Variables.CurrentSession.type = frameType
			NS.Variables.CurrentSession.questID = QuestID
			NS.Variables.CurrentSession.dialogText = TEXT
			NS.Variables.CurrentSession.npc = NPC

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
			local frameType = NS.Variables.CurrentSession.type

			--------------------------------

			do -- NAMEPLATE
				addon.Libraries.AceTimer:ScheduleTimer(function()
					local nameplate = C_NamePlate.GetNamePlateForUnit("npc")

					--------------------------------

					if not InCombatLockdown() then
						if nameplate then
							nameplate:Hide()
						end
					end
				end, 0)
			end

			do -- START
				addon.Interaction.Dialog.Script:Init(frameType)
			end
		end

		function NS.Script:Manager_Dialog_Stop()
			addon.Interaction.Dialog.Script:Stop()
		end

		function NS.Script:Manager_Gossip_Visibility()
			local isNewNPC = (NS.Variables.CurrentSession.npc ~= addon.Interaction.Gossip.Variables.CurrentSession.npc)
			local isFinishedDialog = (addon.Interaction.Dialog.Variables.Playback_Finished)
			local isValidDialog = (addon.Interaction.Dialog.Variables.Playback_Valid)
			local isGossip = (NS.Variables.CurrentSession.type == "gossip" or NS.Variables.CurrentSession.type == "quest-greeting")
			local isQuest = (NS.Variables.CurrentSession.type == "quest-detail" or NS.Variables.CurrentSession.type == "quest-reward" or NS.Variables.CurrentSession.type == "quest-progress")

			--------------------------------

			if addon.Database.DB_GLOBAL.profile.INT_ALWAYS_SHOW_GOSSIP then
				if (isGossip) then
					InteractionFrame.GossipFrame:ShowWithAnimation(isNewNPC)
				else
					InteractionFrame.GossipFrame:HideWithAnimation()
				end
			else
				if (isGossip) and (not isValidDialog or (isValidDialog and isFinishedDialog)) then
					InteractionFrame.GossipFrame:ShowWithAnimation(isNewNPC)
				else
					InteractionFrame.GossipFrame:HideWithAnimation()
				end
			end
		end

		function NS.Script:Manager_Quest_Visibility()
			local isFinishedDialog = (addon.Interaction.Dialog.Variables.Playback_Finished)
			local isValidDialog = (addon.Interaction.Dialog.Variables.Playback_Valid)
			local isGossip = (NS.Variables.CurrentSession.type == "gossip" or NS.Variables.CurrentSession.type == "quest-greeting")
			local isQuest = (NS.Variables.CurrentSession.type == "quest-detail" or NS.Variables.CurrentSession.type == "quest-reward" or NS.Variables.CurrentSession.type == "quest-progress")

			--------------------------------

			if addon.Database.DB_GLOBAL.profile.INT_ALWAYS_SHOW_QUEST then
				if (isQuest and not isGossip) then
					InteractionFrame.QuestFrame:ShowWithAnimation()
				else
					InteractionFrame.QuestFrame:HideWithAnimation()
				end
			else
				if (isQuest and not isGossip) and (not isValidDialog or (isValidDialog and isFinishedDialog)) then
					InteractionFrame.QuestFrame:ShowWithAnimation()
				else
					InteractionFrame.QuestFrame:HideWithAnimation()
				end
			end
		end

		function NS.Script:Manager_Quest_Start()
			if InteractionFrame.QuestFrame:IsVisible() then
				InteractionFrame.QuestFrame:Hide()
				InteractionFrame.QuestFrame.hidden = true
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
			local atlas, texture = button:GetImageObject().BackgroundTexture:GetAtlas(), button:GetImageObject().BackgroundTexture:GetTexture()

			--------------------------------

			local isTrainer = (atlas == 132058 or texture == 132058)

			--------------------------------

			if isTrainer then
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
					HideUIPanel(GossipFrame)
				end
			end)

			hooksecurefunc(GossipFrame, "Show", function()
				if QuestFrame:IsVisible() then
					HideUIPanel(QuestFrame)
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

			CallbackRegistry:Add("START_INTERACTION", function()
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

			if not addon.Variables.IS_WOW_VERSION_CLASSIC_ALL then
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
						if addon.HideUI.Variables.Active and not Combat_AlertShowForSession then
							Combat_AlertShowForSession = true

							--------------------------------

							addon.Alert.Script:Show(addon.Variables.PATH_ART .. "Alert/swords.png", L["Alert - Under Attack"], 17.5, addon.SoundEffects.Alert_Combat_Show, addon.SoundEffects.Alert_Combat_Hide)
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
					if not addon.Database.DB_GLOBAL.profile.TutorialSettingsShown then
						addon.Database.DB_GLOBAL.profile.TutorialSettingsShown = true

						--------------------------------

						local Shortcut

						if addon.Input.Variables.IsController then
							Shortcut = addon.API.Util:InlineIcon(addon.Variables.PATH_ART .. "Blizzard/Settings/shortcut-controller.png", 25, 25, 0, 0) .. L["Alert - Open Settings"]
						else
							Shortcut = addon.API.Util:InlineIcon(addon.Variables.PATH_ART .. "Blizzard/Settings/shortcut-pc.png", 25, 75, 0, 0) .. L["Alert - Open Settings"]
						end

						--------------------------------

						addon.Alert.Script:Show(addon.Variables.PATH_ART .. "Alert/cog.png", Shortcut, 12.5, nil, nil, 5)
					end
				end, 0)
			end
		end
	end

	--------------------------------
	-- SETUP
	--------------------------------

	do
		addon.BlizzardFrames.Script:Clear_GossipFrame()
		addon.BlizzardFrames.Script:Clear_QuestFrame()
	end
end
