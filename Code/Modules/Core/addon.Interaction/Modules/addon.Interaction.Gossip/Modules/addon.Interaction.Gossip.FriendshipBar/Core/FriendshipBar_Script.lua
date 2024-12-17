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

	local Parent = NS.Variables.Parent
	local Frame = NS.Variables.Frame
	local Callback = NS.Script

	--------------------------------
	-- FUNCTIONS (FRAME)
	--------------------------------

	do
		Frame.ShowProgress = function()
			Frame.ShowWithAnimation()

			--------------------------------

			local Frame = GossipFrame.FriendshipStatusBar
			local NewValue = (Frame:GetValue())
			local Min = (select(1, Frame:GetMinMaxValues()))
			local Max = (select(2, Frame:GetMinMaxValues()))

			Frame.Progress.Bar:SetValue(0)
			Frame.Progress.Bar:SetMinMaxValues(Min, Max)
			AdaptiveAPI.Animation:SetProgressTo(Frame.Progress.Bar, NewValue, 1)

			--------------------------------

			local ImageTexture = (Frame.icon:GetTexture())
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

			AdaptiveAPI.Animation:Fade(InteractionFriendshipBarFrame, .25, 0, 1, nil, StopEvent())
			AdaptiveAPI.Animation:Fade(Frame.Progress, .25, 0, 1, nil, StopEvent())
			AdaptiveAPI.Animation:Fade(Frame.Image, .25, 0, 1, nil, StopEvent())
		end

		Frame.HideWithAnimation = function()
			AdaptiveAPI.Animation:Fade(InteractionFriendshipBarFrame, .25, InteractionFriendshipBarFrame:GetAlpha(), 0)

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
				ReputationEntryMixin.ShowFriendshipReputationTooltip(InteractionFriendshipBarFrame, NS.Variables.BLIZZARD_BAR_FRIENDSHIP.friendshipFactionID, "ANCHOR_BOTTOM", false)

				addon.BlizzardGameTooltip.Script:StartCustom()
			else
				ShowFriendshipReputationTooltip(NS.Variables.BLIZZARD_BAR_FRIENDSHIP.friendshipFactionID, InteractionFriendshipBarFrame, "ANCHOR_BOTTOM")

				addon.BlizzardGameTooltip.Script:StartCustom()
			end
		end)

		Parent:SetScript("OnLeave", function()
			GameTooltip:Hide()

			addon.BlizzardGameTooltip.Script:StartCustom()
		end)

		hooksecurefunc(GossipFrame, "Hide", function()
			Frame.HideWithAnimation()
		end)

		local Events = CreateFrame("Frame")
		Events:RegisterEvent("GOSSIP_SHOW")
		Events:SetScript("OnEvent", function(self, event, ...)
			if event == "GOSSIP_SHOW" then
				if NS.Variables.BLIZZARD_BAR_FRIENDSHIP:IsVisible() then
					Frame.ShowProgress()
				else
					Frame.HideWithAnimation()
				end
			end
		end)
	end

	--------------------------------
	-- SETUP
	--------------------------------
end
