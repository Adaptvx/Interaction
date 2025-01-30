local addonName, addon = ...
local CallbackRegistry = addon.CallbackRegistry
local L = addon.Locales
local NS = addon.Cinematic.Effects

--------------------------------

NS.Script = {}

--------------------------------

function NS.Script:Load()
	--------------------------------
	-- REFERENCES
	--------------------------------

	local Frame = InteractionCinematicEffectsFrame
	local Callback = NS.Script

	--------------------------------
	-- FUNCTIONS (MAIN)
	--------------------------------

	do
		do -- MAIN
			function Callback:UpdateVisibility()
				local isCinematicMode = (DB_GLOBAL.profile.INT_CINEMATIC)
				if not isCinematicMode then
					return
				end

				--------------------------------

				local isGradient = (addon.Database.VAR_CINEMATIC_VIGNETTE and addon.Database.VAR_CINEMATIC_VIGNETTE_GRADIENT)

				--------------------------------

				if isGradient then
					local isInteraction = (addon.Interaction.Variables.Active)
					local isDialog = (not InteractionDialogFrame.hidden)
					local isGossip = (not InteractionGossipFrame.hidden)
					local isQuest = (not InteractionQuestFrame.hidden)

					--------------------------------

					if isInteraction and (isGossip or isQuest) then
						Frame.Gradient.ShowWithAnimation()
					else
						Frame.Gradient.HideWithAnimation()
					end
				else
					Frame.Gradient.HideWithAnimation()
				end
			end
		end

		do -- GRADIENT
			Frame.Gradient.UpdateSize = function()
				Frame.MouseResponders.Left:SetSize(750, UIParent:GetHeight())
				Frame.MouseResponders.Left:SetPoint("LEFT", Frame.MouseResponders)

				Frame.MouseResponders.Right:SetSize(750, UIParent:GetHeight())
				Frame.MouseResponders.Right:SetPoint("RIGHT", Frame.MouseResponders)
			end
		end
	end

	--------------------------------
	-- FUNCTIONS (ANIMATION)
	--------------------------------

	do
		do -- GRADIENT
			Frame.Gradient.ShowWithAnimation = function()
				if not Frame.Gradient.hidden then
					return
				end
				Frame.Gradient.hidden = false
				Frame.Gradient:Show()

				--------------------------------

				AdaptiveAPI.Animation:Fade(Frame.Gradient, .25, Frame.Gradient:GetAlpha(), 1, nil, function() return Frame.Gradient.hidden end)
			end

			Frame.Gradient.HideWithAnimation = function()
				if Frame.Gradient.hidden then
					return
				end
				Frame.Gradient.hidden = true

				addon.Libraries.AceTimer:ScheduleTimer(function()
					if Frame.Gradient.hidden then
						Frame.Gradient:Hide()
					end
				end, .25)

				--------------------------------

				AdaptiveAPI.Animation:Fade(Frame.Gradient, .25, Frame.Gradient:GetAlpha(), 0, nil, function() return not Frame.Gradient.hidden end)
			end
		end
	end

	--------------------------------
	-- FUNCTIONS (FOCUS)
	--------------------------------

	do
		-- do -- GRADIENT
		-- 	Frame.Gradient.Enter = function()
		-- 		Frame.Gradient.mouseOver = true

		-- 		--------------------------------

		-- 		Frame.Gradient.UpdateFocus()
		-- 	end

		-- 	Frame.Gradient.Leave = function()
		-- 		Frame.Gradient.mouseOver = false

		-- 		--------------------------------

		-- 		Frame.Gradient.UpdateFocus()
		-- 	end

		-- 	Frame.Gradient.UpdateFocus = function()
		-- 		if not addon.Input.Variables.IsController then
		-- 			local IsMouseOver = (Frame.Gradient.mouseOver)
		-- 			local IsInDialog = (not InteractionDialogFrame.hidden)

		-- 			if IsInDialog and not IsMouseOver then
		-- 				Frame.Gradient.focused = false
		-- 			else
		-- 				Frame.Gradient.focused = true
		-- 			end
		-- 		else
		-- 			Frame.Gradient.focused = true
		-- 		end

		-- 		--------------------------------

		-- 		if Frame.Gradient.focused then
		-- 			AdaptiveAPI.Animation:Fade(Frame.Gradient.Background, .25, Frame.Gradient.Background:GetAlpha(), 1, nil, function() return not Frame.Gradient.focused end)
		-- 		else
		-- 			AdaptiveAPI.Animation:Fade(Frame.Gradient.Background, .25, Frame.Gradient.Background:GetAlpha(), .5, nil, function() return Frame.Gradient.focused end)
		-- 		end
		-- 	end

		-- 	AdaptiveAPI.FrameTemplates:CreateMouseResponder(Frame.MouseResponders.Left, function() if DB_GLOBAL.profile.INT_UIDIRECTION == 1 then Frame.Gradient.Enter() end end, function() if DB_GLOBAL.profile.INT_UIDIRECTION == 1 then Frame.Gradient.Leave() end end)
		-- 	AdaptiveAPI.FrameTemplates:CreateMouseResponder(Frame.MouseResponders.Right, function() if DB_GLOBAL.profile.INT_UIDIRECTION == 2 then Frame.Gradient.Enter() end end, function() if DB_GLOBAL.profile.INT_UIDIRECTION == 2 then Frame.Gradient.Leave() end end)
		-- end
	end

	--------------------------------
	-- SETTINGS
	--------------------------------

	do
		do -- GRADIENT
			local function Settings_UIDirection()
				if DB_GLOBAL.profile.INT_UIDIRECTION == 1 then
					Frame.Gradient.BackgroundTexture:SetTexture(addon.Variables.PATH .. "Art/Gradient/gradient-left-fullscreen.png")
				elseif DB_GLOBAL.profile.INT_UIDIRECTION == 2 then
					Frame.Gradient.BackgroundTexture:SetTexture(addon.Variables.PATH .. "Art/Gradient/gradient-right-fullscreen.png")
				end

				--------------------------------

				Frame.Gradient.UpdateSize()
			end
			Settings_UIDirection()

			--------------------------------

			CallbackRegistry:Add("SETTINGS_UIDIRECTION_CHANGED", Settings_UIDirection, 0)
		end
	end

	--------------------------------
	-- EVENTS
	--------------------------------

	do
		do -- GRADIENT
			CallbackRegistry:Add("START_INTERACTION", Callback.UpdateVisibility, 5)
			CallbackRegistry:Add("STOP_INTERACTION", Callback.UpdateVisibility, 5)
			CallbackRegistry:Add("START_DIALOG", Callback.UpdateVisibility, 5)
			CallbackRegistry:Add("STOP_DIALOG", Callback.UpdateVisibility, 5)
			CallbackRegistry:Add("START_GOSSIP", Callback.UpdateVisibility, 5)
			CallbackRegistry:Add("STOP_GOSSIP", Callback.UpdateVisibility, 5)
			CallbackRegistry:Add("START_QUEST", Callback.UpdateVisibility, 5)
			CallbackRegistry:Add("STOP_QUEST", Callback.UpdateVisibility, 5)
		end
	end
end
