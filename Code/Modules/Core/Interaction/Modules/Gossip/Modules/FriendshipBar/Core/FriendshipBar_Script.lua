local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local TemplateRegistry = addon.TemplateRegistry
local L = addon.Locales
local NS = addon.Interaction.Gossip.FriendshipBar; addon.Interaction.Gossip.FriendshipBar = NS

NS.Script = {}

function NS.Script:Load()

	-- References
	----------------------------------------------------------------------------------------------------

	local Parent = InteractionFriendshipBarParent
	local Frame = InteractionFriendshipBarFrame
	local Callback = NS.Script

	local BlizzardFriendshipBar = GossipFrame.FriendshipStatusBar or NPCFriendshipStatusBar

	-- Tooltip
	----------------------------------------------------------------------------------------------------

	local ReputationTooltip_Retail = {}
	local ReputationTooltip_Classic = {}

	do -- Retail
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
				GameTooltip_SetTitle(InteractionFrame.GameTooltip, friendshipData.name .. " (" .. rankInfo.currentLevel .. " / " .. rankInfo.maxLevel .. ")", HIGHLIGHT_FONT_COLOR);
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
				GameTooltip_AddHighlightLine(InteractionFrame.GameTooltip, friendshipData.reaction .. " (" .. current .. " / " .. max .. ")", wrapText);
			else
				local wrapText = true;
				GameTooltip_AddHighlightLine(InteractionFrame.GameTooltip, friendshipData.reaction, wrapText);
			end

			if canClickForOptions then
				GameTooltip_AddBlankLineToTooltip(InteractionFrame.GameTooltip);
				GameTooltip_AddInstructionLine(InteractionFrame.GameTooltip, REPUTATION_BUTTON_TOOLTIP_CLICK_INSTRUCTION);
			end

			InteractionFrame.GameTooltip:Show();
		end
	end

	do -- Classic

		function ReputationTooltip_Classic:ShowFriendshipReputationTooltip(factionID, parent, anchor)
			local friendshipData = C_GossipInfo.GetFriendshipReputation(factionID);
			if not friendshipData or friendshipData.friendshipFactionID < 0 then
				return;
			end

			InteractionFrame.GameTooltip:SetOwner(parent, anchor);
			local rankInfo = C_GossipInfo.GetFriendshipReputationRanks(friendshipData.friendshipFactionID);
			if rankInfo.maxLevel > 0 then
				GameTooltip_SetTitle(InteractionFrame.GameTooltip, friendshipData.name .. " (" .. rankInfo.currentLevel .. " / " .. rankInfo.maxLevel .. ")", HIGHLIGHT_FONT_COLOR);
			else
				GameTooltip_SetTitle(InteractionFrame.GameTooltip, friendshipData.name, HIGHLIGHT_FONT_COLOR);
			end

			GameTooltip_AddBlankLineToTooltip(InteractionFrame.GameTooltip)
			InteractionFrame.GameTooltip:AddLine(friendshipData.text, nil, nil, nil, true);
			if friendshipData.nextThreshold then
				local current = friendshipData.standing - friendshipData.reactionThreshold;
				local max = friendshipData.nextThreshold - friendshipData.reactionThreshold;
				local wrapText = true;
				GameTooltip_AddHighlightLine(InteractionFrame.GameTooltip, friendshipData.reaction .. " (" .. current .. " / " .. max .. ")", wrapText);
			else
				local wrapText = true;
				GameTooltip_AddHighlightLine(InteractionFrame.GameTooltip, friendshipData.reaction, wrapText);
			end

			if canClickForOptions then
				GameTooltip_AddBlankLineToTooltip(InteractionFrame.GameTooltip);
				GameTooltip_AddInstructionLine(InteractionFrame.GameTooltip, REPUTATION_BUTTON_TOOLTIP_CLICK_INSTRUCTION);
			end

			InteractionFrame.GameTooltip:Show();
		end
	end

	-- Frame
	----------------------------------------------------------------------------------------------------

	do

		function Frame:ShowProgress()
			Frame:ShowWithAnimation()

			local value = BlizzardFriendshipBar:GetValue()
			local min, max = BlizzardFriendshipBar:GetMinMaxValues()

			Frame.Progress.Bar:SetValue(0)
			Frame.Progress.Bar:SetMinMaxValues(min, max)
			addon.API.Animation:SetProgressTo(Frame.Progress.Bar, value, 1)

			local texture = (BlizzardFriendshipBar.icon:GetTexture())
			Frame.Image.ImageTexture:SetTexture(texture)
		end
	end

	-- Animation
	----------------------------------------------------------------------------------------------------

	do
		do -- Show

			function Frame:ShowWithAnimation_StopEvent()
				return not Frame:IsVisible()
			end

			function Frame:ShowWithAnimation()
				Parent:Show()

				Frame:SetAlpha(0)
				Frame.Image:SetAlpha(0)
				Frame.Progress:SetAlpha(0)
				Frame.Image:SetScale(.75)

				addon.API.Animation:Fade(InteractionFriendshipBarFrame, .125, 0, 1, nil, Frame.ShowWithAnimation_StopEvent)
				addon.API.Animation:Fade(Frame.Progress, .125, 0, 1, nil, Frame.ShowWithAnimation_StopEvent)
				addon.API.Animation:Fade(Frame.Image, .125, 0, 1, nil, Frame.ShowWithAnimation_StopEvent)
			end
		end

		do -- Hide

			function Frame:HideWithAnimation_StopEvent()

			end

			function Frame:HideWithAnimation()
				addon.API.Animation:Fade(InteractionFriendshipBarFrame, .125, InteractionFriendshipBarFrame:GetAlpha(), 0)

				C_Timer.After(.25, function()
					Parent:Hide()
				end)
			end
		end
	end

	-- Events
	----------------------------------------------------------------------------------------------------

	do
		Parent:SetScript("OnEnter", function()
			if not addon.Variables.IS_WOW_VERSION_CLASSIC_ALL then
				ReputationTooltip_Retail.ShowFriendshipReputationTooltip(InteractionFriendshipBarFrame.TooltipParent, BlizzardFriendshipBar.friendshipFactionID, "ANCHOR_BOTTOM", false)
			else
				ReputationTooltip_Classic:ShowFriendshipReputationTooltip(BlizzardFriendshipBar.friendshipFactionID, InteractionFriendshipBarFrame.TooltipParent, "ANCHOR_BOTTOM")
			end
		end)

		Parent:SetScript("OnLeave", function()
			InteractionFrame.GameTooltip:Clear()
		end)

		local f = CreateFrame("Frame")
		f:RegisterEvent("GOSSIP_SHOW")
		f:SetScript("OnEvent", function(self, event, ...)
			if not addon.Initialize.Ready then
				return
			end

			if event == "GOSSIP_SHOW" then
				if BlizzardFriendshipBar:IsVisible() then
					Frame:ShowProgress()
				else
					Frame:HideWithAnimation()
				end
			end
		end)

		CallbackRegistry:Add("STOP_INTERACTION", Frame.HideWithAnimation)
	end

	-- Setup
	----------------------------------------------------------------------------------------------------
end
