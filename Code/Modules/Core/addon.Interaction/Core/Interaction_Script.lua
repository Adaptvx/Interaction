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

			NS.Variables.GossipLastNPC = nil
			NS.Variables.GossipFirstInteractMessage = nil
			NS.Variables.LastActiveTime = GetTime()

			NS.Variables.Type = nil
			NS.Variables.SavedNPC = nil

			--------------------------------

			local function CloseInteraction()
				if not NS.Variables.Active then
					return
				end

				--------------------------------
				-- DESELECT NPC
				--------------------------------

				if deselectTarget then
					C_PlayerInteractionManager.ClearInteraction()
				end

				--------------------------------
				-- BLIZZARD FRAME
				--------------------------------

				QuestFrame:Hide()
				GossipFrame:Hide()

				--------------------------------
				-- STATE
				--------------------------------

				NS.Script:SetActiveState(false)

				--------------------------------
				-- CALLBACKS
				--------------------------------

				CallbackRegistry:Trigger("STOP_INTERACTION")

				--------------------------------
				-- VARIABLES
				--------------------------------

				NS.Variables.SelectedOptionIcon = nil
				NS.Variables.SelectedOptionText = nil
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
			if not (GossipFrame:IsVisible() or QuestFrame:IsVisible()) then
				return
			end

			--------------------------------

			CallbackRegistry:Trigger("INITIATE_INTERACTION")

			--------------------------------

			GossipFrame.Clear()
			QuestFrame.Clear()

			--------------------------------

			if not (GossipFrame:IsVisible() or QuestFrame:IsVisible()) then
				return
			end

			--------------------------------

			NS.Variables.Type = frameType
			NS.Variables.SavedSelectedOptionText = NS.Variables.SelectedOptionText
			NS.Variables.SavedNPC = UnitName("npc") or UnitName("questnpc")

			--------------------------------

			NS.Variables.StartInteractionTime = GetTime()

			--------------------------------

			NS.Script:SetActiveState(true)

			--------------------------------

			CallbackRegistry:Trigger("START_INTERACTION", frameType)
		end
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

				local function NewGossipDialog()
					NS.Variables.SelectedOptionIcon = nil
					NS.Variables.SelectedOptionText = nil
				end

				local function StartInteraction(type)
					NS.Script:Start(type)
				end

				--------------------------------

				if event == "QUEST_DETAIL" then
					StartInteraction("quest-detail")
				elseif event == "QUEST_COMPLETE" then
					StartInteraction("quest-reward")
				elseif event == "QUEST_GREETING" then
					NewGossipDialog()
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
				SettingsPanel:Hide()
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
