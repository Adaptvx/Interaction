---@class addon
local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local PrefabRegistry = addon.PrefabRegistry
local L = addon.Locales
local NS = addon.Interaction.Gossip.FriendshipBar; addon.Interaction.Gossip.FriendshipBar = NS

--------------------------------

NS.Elements = {}

--------------------------------

function NS.Elements:Load()
	--------------------------------
	-- CREATE ELEMENTS
    --------------------------------

	do -- ELEMENTS
        InteractionFriendshipBarParent = CreateFrame("Frame", "$parent.InteractionFriendshipBarParent", InteractionFrame)
        InteractionFriendshipBarParent:SetSize(350, 50)
        InteractionFriendshipBarParent:SetPoint("TOP", UIParent, 0, -(addon.API.Main:GetScreenHeight() * .025))
        InteractionFriendshipBarParent:SetFrameStrata("FULLSCREEN")
        InteractionFriendshipBarParent:SetFrameLevel(99)
        InteractionFriendshipBarParent:Hide()

        InteractionFriendshipBarFrame = CreateFrame("Frame", "$parent.InteractionFriendshipBarFrame", InteractionFriendshipBarParent)
        InteractionFriendshipBarFrame:SetSize(InteractionFriendshipBarParent:GetWidth(), InteractionFriendshipBarParent:GetHeight())
        InteractionFriendshipBarFrame:SetScale(.75)
        InteractionFriendshipBarFrame:SetPoint("CENTER", InteractionFriendshipBarParent)
        InteractionFriendshipBarFrame:SetFrameStrata("FULLSCREEN")
        InteractionFriendshipBarFrame:SetFrameLevel(1)

        addon.API.Animation:AddParallax(InteractionFriendshipBarFrame, InteractionFriendshipBarParent, function() return true end, function() return false end, addon.Input.Variables.IsController)

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

			local Image = Frame.Image

            --------------------------------

			do -- BACKGROUND
                Image.Background, Image.BackgroundTexture = addon.API.FrameTemplates:CreateTexture(Image, "FULLSCREEN", NS.Variables.PATH .. "image-background.png", "$parent.Background")
                Image.Background:SetSize(Image:GetWidth(), Image:GetHeight())
                Image.Background:SetPoint("CENTER", Image)
                Image.Background:SetFrameLevel(6)
            end

			do -- IMAGE
                Image.Image, Image.ImageTexture = addon.API.FrameTemplates:CreateTexture(Image, "FULLSCREEN", nil, "$parent.Image")
                Image.Image:SetSize(Image:GetWidth(), Image:GetHeight())
                Image.Image:SetPoint("CENTER", Image)
                Image.Image:SetFrameLevel(7)

				--------------------------------

				do -- MASK TEXTURE
					Image.ImageTexture.Mask = Image.Image:CreateMaskTexture()
					Image.ImageTexture.Mask:SetTexture(NS.Variables.PATH .. "image-mask.png")
					Image.ImageTexture.Mask:SetPoint("CENTER", Image.Image)
					addon.API.FrameUtil:SetDynamicSize(Image.ImageTexture.Mask, Image.Image, 10, 10)

					Image.ImageTexture:AddMaskTexture(Image.ImageTexture.Mask)
				end
            end
        end

		do -- PROGRESS BAR
            Frame.Progress = CreateFrame("Frame", "$parent.Progress", Frame)
            Frame.Progress:SetSize(Frame:GetWidth() - Frame.Image:GetWidth() / 1.5, Frame:GetHeight())
            Frame.Progress:SetPoint("LEFT", Frame, Frame.Image:GetWidth() / 1.5, 0)
            Frame.Progress:SetFrameStrata("FULLSCREEN")
            Frame.Progress:SetFrameLevel(1)

			local Progress = Frame.Progress

            --------------------------------

			do -- BACKGROUND
                Progress.Background, Progress.BackgroundTexture = addon.API.FrameTemplates:CreateTexture(Progress, "FULLSCREEN", NS.Variables.PATH .. "background.png", "$parent.Background")
                Progress.Background:SetSize(Progress:GetWidth(), Progress:GetHeight())
                Progress.Background:SetPoint("CENTER", Progress)
                Progress.Background:SetFrameStrata("FULLSCREEN")
                Progress.Background:SetFrameLevel(2)
            end

			do -- PROGRESS BAR
                Progress.Bar = addon.API.FrameTemplates:CreateAdvancedProgressBar(Progress, "FULLSCREEN", NS.Variables.PATH .. "bar.png", NS.Variables.PATH .. "flare.png", 8, 0, "$parent.Bar")
                Progress.Bar:SetSize(Progress:GetWidth() - 25, Progress:GetHeight() - 25)
                Progress.Bar:SetPoint("CENTER", Progress.Background)
                Progress.Bar:SetFrameStrata("FULLSCREEN")
                Progress.Bar:SetFrameLevel(3)

                Progress.Bar.Flare:SetWidth(50)
                Progress.Bar.Flare:SetHeight(Progress:GetHeight())
                Progress.Bar.Flare:SetFrameStrata("FULLSCREEN_DIALOG")
                Progress.Bar.Flare:SetFrameLevel(4)
            end
        end
    end

	--------------------------------
	-- REFERENCES
	--------------------------------

	local Parent = InteractionFriendshipBarParent
	local Frame = InteractionFriendshipBarFrame
	local Callback = NS.Script; NS.Script = Callback

	--------------------------------
	-- SETUP
	--------------------------------

end
