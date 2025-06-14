-- [!] [addon.Cinematic.Effects] is used to display screen gradients/effects.
-- [Effects_Script.lua] is the back-end (logic & behavior)
-- for [Effects_Elements.lua].

---@class addon
local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local PrefabRegistry = addon.PrefabRegistry
local L = addon.Locales
local NS = addon.Cinematic.Effects; addon.Cinematic.Effects = NS

--------------------------------

NS.Script = {}

--------------------------------

function NS.Script:Load()
	--------------------------------
	-- REFERENCES
	--------------------------------

	local Frame = InteractionFrame.EffectsFrame
	local Callback = NS.Script; NS.Script = Callback

	--------------------------------
	-- FUNCTIONS (MAIN)
	--------------------------------

	do
		do -- MAIN
			function Callback:UpdateVisibility()
				local isCinematicMode = (addon.Database.DB_GLOBAL.profile.INT_CINEMATIC)
				local isGradient = (addon.Database.VAR_CINEMATIC_VIGNETTE and addon.Database.VAR_CINEMATIC_VIGNETTE_GRADIENT)

				if not isCinematicMode then
					return
				end

				--------------------------------

				if isGradient then
					local isInteraction = (addon.Interaction.Variables.Active)
					local isDialog = (not InteractionFrame.DialogFrame.hidden)
					local isGossip = (not InteractionFrame.GossipFrame.hidden)
					local isQuest = (not InteractionFrame.QuestFrame.hidden)

					--------------------------------

					if isInteraction and (isGossip or isQuest) then
						Frame.REF_GRADIENT:ShowWithAnimation()
					else
						Frame.REF_GRADIENT:HideWithAnimation()
					end
				else
					Frame.REF_GRADIENT:HideWithAnimation()
				end
			end
		end
	end

	--------------------------------
	-- FUNCTIONS (ANIMATION)
	--------------------------------

	do
		do -- GRADIENT
			do -- SHOW
				function Frame.REF_GRADIENT:ShowWithAnimation_StopEvent()
					return Frame.REF_GRADIENT.hidden
				end

				function Frame.REF_GRADIENT:ShowWithAnimation()
					if not Frame.REF_GRADIENT.hidden then
						return
					end
					Frame.REF_GRADIENT.hidden = false
					Frame.REF_GRADIENT:Show()

					--------------------------------

					addon.API.Animation:Fade(Frame.REF_GRADIENT, .25, Frame.REF_GRADIENT:GetAlpha(), 1, nil, function() return Frame.REF_GRADIENT.hidden end)
				end
			end

			do -- HIDE
				function Frame.REF_GRADIENT:HideWithAnimation_StopEvent()
					return not Frame.REF_GRADIENT.hidden
				end

				function Frame.REF_GRADIENT:HideWithAnimation()
					if Frame.REF_GRADIENT.hidden then
						return
					end
					Frame.REF_GRADIENT.hidden = true

					addon.Libraries.AceTimer:ScheduleTimer(function()
						if Frame.REF_GRADIENT.hidden then
							Frame.REF_GRADIENT:Hide()
						end
					end, .25)

					--------------------------------

					addon.API.Animation:Fade(Frame.REF_GRADIENT, .25, Frame.REF_GRADIENT:GetAlpha(), 0, nil, function() return not Frame.REF_GRADIENT.hidden end)
				end
			end
		end
	end

	--------------------------------
	-- FUNCTIONS (FOCUS)
	--------------------------------

	do
		-- do -- GRADIENT
		-- 	function Frame.REF_GRADIENT:OnEnter()
		-- 		Frame.REF_GRADIENT.mouseOver = true

		-- 		--------------------------------

		-- 		Frame.REF_GRADIENT:UpdateFocus()
		-- 	end

		-- 	function Frame.REF_GRADIENT:OnLeave()
		-- 		Frame.REF_GRADIENT.mouseOver = false

		-- 		--------------------------------

		-- 		Frame.REF_GRADIENT:UpdateFocus()
		-- 	end

		-- 	function Frame.REF_GRADIENT:UpdateFocus()
		-- 		if not addon.Input.Variables.IsController then
		-- 			local IsMouseOver = (Frame.REF_GRADIENT.mouseOver)
		-- 			local IsInDialog = (not InteractionFrame.DialogFrame.hidden)

		-- 			if IsInDialog and not IsMouseOver then
		-- 				Frame.REF_GRADIENT.focused = false
		-- 			else
		-- 				Frame.REF_GRADIENT.focused = true
		-- 			end
		-- 		else
		-- 			Frame.REF_GRADIENT.focused = true
		-- 		end

		-- 		--------------------------------

		-- 		if Frame.REF_GRADIENT.focused then
		-- 			addon.API.Animation:Fade(Frame.REF_GRADIENT.Background, .25, Frame.REF_GRADIENT.Background:GetAlpha(), 1, nil, function() return not Frame.REF_GRADIENT.focused end)
		-- 		else
		-- 			addon.API.Animation:Fade(Frame.REF_GRADIENT.Background, .25, Frame.REF_GRADIENT.Background:GetAlpha(), .5, nil, function() return Frame.REF_GRADIENT.focused end)
		-- 		end
		-- 	end

		-- 	addon.API.FrameTemplates:CreateMouseResponder(Frame.REF_MOUSE_RESPONDERS_LEFT, { enterCallback = function() if addon.Database.DB_GLOBAL.profile.INT_UIDIRECTION == 1 then Frame.REF_GRADIENT.Enter() end end, leaveCallback = function() if addon.Database.DB_GLOBAL.profile.INT_UIDIRECTION == 1 then Frame.REF_GRADIENT.Leave() end end })
		-- 	addon.API.FrameTemplates:CreateMouseResponder(Frame.REF_MOUSE_RESPONDERS_RIGHT, { enterCallback = function() if addon.Database.DB_GLOBAL.profile.INT_UIDIRECTION == 2 then Frame.REF_GRADIENT.Enter() end end, leaveCallback = function() if addon.Database.DB_GLOBAL.profile.INT_UIDIRECTION == 2 then Frame.REF_GRADIENT.Leave() end end })
		-- end
	end

	--------------------------------
	-- SETTINGS
	--------------------------------

	do
		do -- GRADIENT
			local function Settings_UIDirection()
				if addon.Database.DB_GLOBAL.profile.INT_UIDIRECTION == 1 then
					Frame.REF_GRADIENT.BackgroundTexture:SetTexture(addon.Variables.PATH_ART .. "Gradient/gradient-left-fullscreen.png")
				elseif addon.Database.DB_GLOBAL.profile.INT_UIDIRECTION == 2 then
					Frame.REF_GRADIENT.BackgroundTexture:SetTexture(addon.Variables.PATH_ART .. "Gradient/gradient-right-fullscreen.png")
				end
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
