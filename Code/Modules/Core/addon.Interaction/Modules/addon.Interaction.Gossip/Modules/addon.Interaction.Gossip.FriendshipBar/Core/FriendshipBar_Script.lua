local addonName, addon = ...
local PrefabRegistry = addon.PrefabRegistry
local CallbackRegistry = addon.CallbackRegistry
local L = addon.Locales
local NS = addon.Interaction.Gossip.FriendshipBar

--------------------------------

NS.Script = {}

--------------------------------

function NS.Script:Load()
	--------------------------------
	-- REFERENCES
	--------------------------------

	local Parent = InteractionFriendshipBarParent
	local Frame = InteractionFriendshipBarFrame
	local Callback = NS.Script

	local BlizzardFriendshipBar; if not addon.Variables.IS_CLASSIC then BlizzardFriendshipBar = GossipFrame.FriendshipStatusBar else BlizzardFriendshipBar = NPCFriendshipStatusBar end

	--------------------------------
	-- FUNCTIONS (TOOLTIP)
	--------------------------------

	local ReputationTooltip_Retail = {}
	local ReputationTooltip_Classic = {}

	do -- RETAIL
		-- Blizzard_UIPanels_Game -> Mainline -> ReputationFrame.lua

		local function TryAppendAccountReputationLineToTooltip(tooltip, factionID)
			if not tooltip or not factionID or not C_Reputation.IsAccountWideReputation(factionID) then
				return;
			end

			local wrapText = false;
			GameTooltip_AddColoredLine(tooltip, REPUTATION_TOOLTIP_ACCOUNT_WIDE_LABEL, ACCOUNT_WIDE_FONT_COLOR, wrapText);
		end

		function ReputationTooltip_Retail:ShowFriendshipReputationTooltip(factionID, anchor, canClickForOptions)
			local friendshipData = C_GossipInfo.GetFriendshipReputation(factionID);
			if not friendshipData or friendshipData.friendshipFactionID < 0 then
				return;
			end

			InteractionFrame.GameTooltip:SetOwner(self, anchor);
			local rankInfo = C_GossipInfo.GetFriendshipReputationRanks(friendshipData.friendshipFactionID);
			if rankInfo.maxLevel > 0 then
				GameTooltip_SetTitle(InteractionFrame.GameTooltip, friendshipData.name.." ("..rankInfo.currentLevel.." / "..rankInfo.maxLevel..")", HIGHLIGHT_FONT_COLOR);
			else
				GameTooltip_SetTitle(InteractionFrame.GameTooltip, friendshipData.name, HIGHLIGHT_FONT_COLOR);
			end

			TryAppendAccountReputationLineToTooltip(InteractionFrame.GameTooltip, factionID);

			GameTooltip_AddBlankLineToTooltip(InteractionFrame.GameTooltip)
			InteractionFrame.GameTooltip:AddLine(friendshipData.text, nil, nil, nil, true);
			if friendshipData.nextThreshold then
				local current = friendshipData.standing - friendshipData.reactionThreshold;
				local max = friendshipData.nextThreshold - friendshipData.reactionThreshold;
				local wrapText = true;
				GameTooltip_AddHighlightLine(InteractionFrame.GameTooltip, friendshipData.reaction.." ("..current.." / "..max..")", wrapText);
			else
				local wrapText = true;
				GameTooltip_AddHighlightLine(InteractionFrame.GameTooltip, friendshipData.reaction, wrapText);
			end

			-- This tooltip code is shared between Gossips (no click functionality) and the Reputation UI (can click button for options)
			if canClickForOptions then
				GameTooltip_AddBlankLineToTooltip(InteractionFrame.GameTooltip);
				GameTooltip_AddInstructionLine(InteractionFrame.GameTooltip, REPUTATION_BUTTON_TOOLTIP_CLICK_INSTRUCTION);
			end

			InteractionFrame.GameTooltip:Show();
		end
	end

	do -- CLASSIC
		-- Blizzard_UIPanels_Game -> Mainline -> ReputationFrame.lua

		-- local function TryAppendAccountReputationLineToTooltip(tooltip, factionID)
		-- 	if not tooltip or not factionID or not C_Reputation.IsAccountWideReputation(factionID) then
		-- 		return;
		-- 	end

		-- 	local wrapText = false;
		-- 	GameTooltip_AddColoredLine(tooltip, REPUTATION_TOOLTIP_ACCOUNT_WIDE_LABEL, ACCOUNT_WIDE_FONT_COLOR, wrapText);
		-- end

		function ReputationTooltip_Classic:ShowFriendshipReputationTooltip(factionID, anchor, canClickForOptions)
			local friendshipData = C_GossipInfo.GetFriendshipReputation(factionID);
			if not friendshipData or friendshipData.friendshipFactionID < 0 then
				return;
			end

			InteractionFrame.GameTooltip:SetOwner(self, anchor);
			local rankInfo = C_GossipInfo.GetFriendshipReputationRanks(friendshipData.friendshipFactionID);
			if rankInfo.maxLevel > 0 then
				GameTooltip_SetTitle(InteractionFrame.GameTooltip, friendshipData.name.." ("..rankInfo.currentLevel.." / "..rankInfo.maxLevel..")", HIGHLIGHT_FONT_COLOR);
			else
				GameTooltip_SetTitle(InteractionFrame.GameTooltip, friendshipData.name, HIGHLIGHT_FONT_COLOR);
			end

			-- TryAppendAccountReputationLineToTooltip(InteractionFrame.GameTooltip, factionID);

			GameTooltip_AddBlankLineToTooltip(InteractionFrame.GameTooltip)
			InteractionFrame.GameTooltip:AddLine(friendshipData.text, nil, nil, nil, true);
			if friendshipData.nextThreshold then
				local current = friendshipData.standing - friendshipData.reactionThreshold;
				local max = friendshipData.nextThreshold - friendshipData.reactionThreshold;
				local wrapText = true;
				GameTooltip_AddHighlightLine(InteractionFrame.GameTooltip, friendshipData.reaction.." ("..current.." / "..max..")", wrapText);
			else
				local wrapText = true;
				GameTooltip_AddHighlightLine(InteractionFrame.GameTooltip, friendshipData.reaction, wrapText);
			end

			-- This tooltip code is shared between Gossips (no click functionality) and the Reputation UI (can click button for options)
			if canClickForOptions then
				GameTooltip_AddBlankLineToTooltip(InteractionFrame.GameTooltip);
				GameTooltip_AddInstructionLine(InteractionFrame.GameTooltip, REPUTATION_BUTTON_TOOLTIP_CLICK_INSTRUCTION);
			end

			InteractionFrame.GameTooltip:Show();
		end
	end

	--------------------------------
	-- FUNCTIONS (FRAME)
	--------------------------------

	do
		Frame.ShowProgress = function()
			Frame.ShowWithAnimation()

			--------------------------------

			local NewValue = (BlizzardFriendshipBar:GetValue())
			local Min = (select(1, BlizzardFriendshipBar:GetMinMaxValues()))
			local Max = (select(2, BlizzardFriendshipBar:GetMinMaxValues()))

			Frame.Progress.Bar:SetValue(0)
			Frame.Progress.Bar:SetMinMaxValues(Min, Max)
			addon.API.Animation:SetProgressTo(Frame.Progress.Bar, NewValue, 1)

			--------------------------------

			local ImageTexture = (BlizzardFriendshipBar.icon:GetTexture())
			Frame.Image.ImageTexture:SetTexture(ImageTexture)
		end
	end

	--------------------------------
	-- FUNCTIONS (ANIMATION)
	--------------------------------

	do
		Frame.ShowWithAnimation = function()
			Parent:Show()

			--------------------------------

			InteractionFriendshipBarFrame:SetAlpha(0)
			Frame.Image:SetAlpha(0)
			Frame.Progress:SetAlpha(0)
			Frame.Image:SetScale(.75)

			--------------------------------

			local StopEvent = function() return not InteractionFriendshipBarFrame:IsVisible() end

			--------------------------------

			addon.API.Animation:Fade(InteractionFriendshipBarFrame, .125, 0, 1, nil, StopEvent())
			addon.API.Animation:Fade(Frame.Progress, .125, 0, 1, nil, StopEvent())
			addon.API.Animation:Fade(Frame.Image, .125, 0, 1, nil, StopEvent())
		end

		Frame.HideWithAnimation = function()
			addon.API.Animation:Fade(InteractionFriendshipBarFrame, .125, InteractionFriendshipBarFrame:GetAlpha(), 0)

			--------------------------------

			addon.Libraries.AceTimer:ScheduleTimer(function()
				Parent:Hide()
			end, .25)
		end
	end

	--------------------------------
	-- EVENTS
	--------------------------------

	do
		Parent:SetScript("OnEnter", function()
			if not addon.Variables.IS_CLASSIC then
				ReputationTooltip_Retail.ShowFriendshipReputationTooltip(InteractionFriendshipBarFrame.TooltipParent, BlizzardFriendshipBar.friendshipFactionID, "ANCHOR_BOTTOM", false)
			else
				ReputationTooltip_Classic(BlizzardFriendshipBar.friendshipFactionID, InteractionFriendshipBarFrame.TooltipParent, "ANCHOR_BOTTOM")
			end
		end)

		Parent:SetScript("OnLeave", function()
			GameTooltip:Hide()

			addon.BlizzardGameTooltip.Script:StartCustom()
		end)

		local Events = CreateFrame("Frame")
		Events:RegisterEvent("GOSSIP_SHOW")
		Events:SetScript("OnEvent", function(self, event, ...)
			if not addon.Initialize.Ready then
				return
			end

			--------------------------------

			if event == "GOSSIP_SHOW" then
				if BlizzardFriendshipBar:IsVisible() then
					Frame.ShowProgress()
				else
					Frame.HideWithAnimation()
				end
			end
		end)

		CallbackRegistry:Add("STOP_INTERACTION", Frame.HideWithAnimation)
	end

	--------------------------------
	-- SETUP
	--------------------------------
end
