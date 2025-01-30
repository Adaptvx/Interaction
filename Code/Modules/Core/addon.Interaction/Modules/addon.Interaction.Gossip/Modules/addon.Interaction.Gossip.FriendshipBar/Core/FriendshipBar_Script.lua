local addonName, addon = ...
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
			AdaptiveAPI.Animation:SetProgressTo(Frame.Progress.Bar, NewValue, 1)

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

			AdaptiveAPI.Animation:Fade(InteractionFriendshipBarFrame, .125, 0, 1, nil, StopEvent())
			AdaptiveAPI.Animation:Fade(Frame.Progress, .125, 0, 1, nil, StopEvent())
			AdaptiveAPI.Animation:Fade(Frame.Image, .125, 0, 1, nil, StopEvent())
		end

		Frame.HideWithAnimation = function()
			AdaptiveAPI.Animation:Fade(InteractionFriendshipBarFrame, .125, InteractionFriendshipBarFrame:GetAlpha(), 0)

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
				ReputationEntryMixin.ShowFriendshipReputationTooltip(InteractionFriendshipBarFrame.TooltipParent, BlizzardFriendshipBar.friendshipFactionID, "ANCHOR_BOTTOM", false)

				addon.BlizzardGameTooltip.Script:StartCustom()
			else
				ShowFriendshipReputationTooltip(BlizzardFriendshipBar.friendshipFactionID, InteractionFriendshipBarFrame.TooltipParent, "ANCHOR_BOTTOM")

				addon.BlizzardGameTooltip.Script:StartCustom()
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
