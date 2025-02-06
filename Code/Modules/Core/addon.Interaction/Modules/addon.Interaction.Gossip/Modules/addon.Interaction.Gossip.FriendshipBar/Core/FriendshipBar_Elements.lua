local addonName, addon = ...
local CallbackRegistry = addon.CallbackRegistry
local L = addon.Locales
local NS = addon.Interaction.Gossip.FriendshipBar

--------------------------------

NS.Elements = {}

--------------------------------

function NS.Elements:Load()
	--------------------------------
	-- CREATE ELEMENTS
    --------------------------------

	do -- CREATE ELEMENTS
        InteractionFriendshipBarParent = CreateFrame("Frame", "$parent.InteractionFriendshipBarParent", InteractionFrame)
        InteractionFriendshipBarParent:SetSize(350, 50)
        InteractionFriendshipBarParent:SetPoint("TOP", UIParent, 0, -(addon.API:GetScreenHeight() * .025))
        InteractionFriendshipBarParent:SetFrameStrata("FULLSCREEN")
        InteractionFriendshipBarParent:SetFrameLevel(99)
        InteractionFriendshipBarParent:Hide()

        InteractionFriendshipBarFrame = CreateFrame("Frame", "$parent.InteractionFriendshipBarFrame", InteractionFriendshipBarParent)
        InteractionFriendshipBarFrame:SetSize(InteractionFriendshipBarParent:GetWidth(), InteractionFriendshipBarParent:GetHeight())
        InteractionFriendshipBarFrame:SetScale(.75)
        InteractionFriendshipBarFrame:SetPoint("CENTER", InteractionFriendshipBarParent)
        InteractionFriendshipBarFrame:SetFrameStrata("FULLSCREEN")
        InteractionFriendshipBarFrame:SetFrameLevel(1)

        AdaptiveAPI.Animation:AddParallax(InteractionFriendshipBarFrame, InteractionFriendshipBarParent, function() return true end, function() return false end, addon.Input.Variables.IsController)

        --------------------------------

		local Parent = InteractionFriendshipBarParent
        local Frame = InteractionFriendshipBarFrame

        --------------------------------

		do -- TOOLTIP PARENT
			Frame.TooltipParent = CreateFrame("Frame", "$parent.TooltipParent", Frame)
			Frame.TooltipParent:SetSize(Frame:GetWidth(), Frame:GetHeight())
			Frame.TooltipParent:SetPoint("CENTER", Frame)
			Frame.TooltipParent:SetFrameStrata("FULLSCREEN")
			Frame.TooltipParent:SetFrameLevel(1)
			Frame.TooltipParent:SetIgnoreParentScale(true)
		end

		do -- IMAGE
            Frame.Image = CreateFrame("Frame", "$parent.Image", Frame)
            Frame.Image:SetSize(75, 75)
            Frame.Image:SetPoint("LEFT", Frame)
            Frame.Image:SetFrameStrata("FULLSCREEN")
            Frame.Image:SetFrameLevel(5)
			Frame.Image:SetClipsChildren(true)

            --------------------------------

			do -- BACKGROUND
                Frame.Image.Background, Frame.Image.BackgroundTexture = AdaptiveAPI.FrameTemplates:CreateTexture(Frame.Image, "FULLSCREEN", NS.Variables.PATH .. "image-background.png", "$parent.Background")
                Frame.Image.Background:SetSize(Frame.Image:GetWidth(), Frame.Image:GetHeight())
                Frame.Image.Background:SetPoint("CENTER", Frame.Image)
                Frame.Image.Background:SetFrameLevel(6)
            end

			do -- IMAGE
                Frame.Image.Image, Frame.Image.ImageTexture = AdaptiveAPI.FrameTemplates:CreateTexture(Frame.Image, "FULLSCREEN", nil, "$parent.Image")
                Frame.Image.Image:SetSize(Frame.Image:GetWidth(), Frame.Image:GetHeight())
                Frame.Image.Image:SetPoint("CENTER", Frame.Image)
                Frame.Image.Image:SetFrameLevel(7)
            end
        end

		do -- PROGRESS BAR
            Frame.Progress = CreateFrame("Frame", "$parent.Progress", Frame)
            Frame.Progress:SetSize(Frame:GetWidth() - Frame.Image:GetWidth() / 1.5, Frame:GetHeight())
            Frame.Progress:SetPoint("LEFT", Frame, Frame.Image:GetWidth() / 1.5, 0)
            Frame.Progress:SetFrameStrata("FULLSCREEN")
            Frame.Progress:SetFrameLevel(1)

            --------------------------------

			do -- BACKGROUND
                Frame.Progress.Background, Frame.Progress.BackgroundTexture = AdaptiveAPI.FrameTemplates:CreateTexture(Frame.Progress, "FULLSCREEN", NS.Variables.PATH .. "background.png", "$parent.Background")
                Frame.Progress.Background:SetSize(Frame.Progress:GetWidth(), Frame.Progress:GetHeight())
                Frame.Progress.Background:SetPoint("CENTER", Frame.Progress)
                Frame.Progress.Background:SetFrameStrata("FULLSCREEN")
                Frame.Progress.Background:SetFrameLevel(2)
            end

			do -- PROGRESS BAR
                Frame.Progress.Bar = AdaptiveAPI.FrameTemplates:CreateAdvancedProgressBar(Frame.Progress, "FULLSCREEN", NS.Variables.PATH .. "bar.png", NS.Variables.PATH .. "flare.png", 8, 0, "$parent.Bar")
                Frame.Progress.Bar:SetSize(Frame.Progress:GetWidth() - 25, Frame.Progress:GetHeight() - 25)
                Frame.Progress.Bar:SetPoint("CENTER", Frame.Progress.Background)
                Frame.Progress.Bar:SetFrameStrata("FULLSCREEN")
                Frame.Progress.Bar:SetFrameLevel(3)

                Frame.Progress.Bar.Flare:SetWidth(50)
                Frame.Progress.Bar.Flare:SetHeight(Frame.Progress:GetHeight())
                Frame.Progress.Bar.Flare:SetFrameStrata("FULLSCREEN_DIALOG")
                Frame.Progress.Bar.Flare:SetFrameLevel(4)
            end
        end
    end

	--------------------------------
	-- REFERENCES
	--------------------------------

	local Parent = InteractionFriendshipBarParent
	local Frame = InteractionFriendshipBarFrame
	local Callback = NS.Script

	--------------------------------
	-- SETUP
	--------------------------------

end
