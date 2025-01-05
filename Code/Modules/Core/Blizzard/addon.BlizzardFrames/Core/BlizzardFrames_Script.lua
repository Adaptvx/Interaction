local addonName, addon = ...
local CallbackRegistry = addon.CallbackRegistry
local L = addon.Locales
local NS = addon.BlizzardFrames

--------------------------------

NS.Script = {}

--------------------------------

function NS.Script:Load()
	--------------------------------
	-- REFERENCES
	--------------------------------

	local Callback = NS.Script

	--------------------------------
	-- FUNCTIONS (MAIN)
	--------------------------------

	-- Hide Blizzard Frames
	do
		local function ScanHideElement(frame)
			for f1 = 1, frame:GetNumChildren() do
				local _frameIndex1 = select(f1, frame:GetChildren())

				--------------------------------

				if _frameIndex1.GetNumChildren and _frameIndex1:GetNumChildren() > 0 then
					ScanHideElement(_frameIndex1)
				end

				_frameIndex1:EnableMouse(false)
				_frameIndex1:SetAlpha(0)
			end

			frame:EnableMouse(false)
			frame:SetAlpha(0)
		end

		QuestFrame.Clear = function()
			if not addon._DEV.ENABLED then
				ScanHideElement(QuestFrame)
			end

			QuestFrame:ClearAllPoints()

			if not addon._DEV.ENABLED then
				QuestFrame:SetPoint("CENTER", UIParent, 0, 10000)
				QuestFrame:SetAlpha(0)
			else
				QuestFrame:SetPoint("LEFT", UIParent)
				QuestFrame:SetAlpha(1)
			end
		end

		GossipFrame.Clear = function()
			if not addon._DEV.ENABLED then
				ScanHideElement(GossipFrame)
			end

			GossipFrame:ClearAllPoints()

			if not addon._DEV.ENABLED then
				GossipFrame:SetPoint("CENTER", UIParent, 0, 10000)
				GossipFrame:SetAlpha(0)
			else
				GossipFrame:SetPoint("LEFT", UIParent)
				GossipFrame:SetAlpha(1)
			end
		end
	end

	-- Priority Frame
	do
		function Callback:SetupFrameVisibility()
			GossipFrame:SetParent(InteractionFrame)
			QuestFrame:SetParent(InteractionFrame)

			StaticPopup1:SetIgnoreParentAlpha(true)
			if not addon.Variables.IS_CLASSIC_ERA then LFDRoleCheckPopup:SetIgnoreParentAlpha(true) end

			--------------------------------

			local function Update()
				if INTDB.profile.INT_HIDEUI and not UIParent:IsVisible() and addon.API:CanShowUIAndHideElements() then
					if not NS.Variables.SetElementsActive then
						Callback:SetElements()
					end
				else
					if NS.Variables.SetElementsActive then
						Callback:RemoveElements()
					end
				end
			end

			--------------------------------

			CallbackRegistry:Add("START_HIDEUI", Update, 0)
			CallbackRegistry:Add("STOP_HIDEUI", Update, 0)
			CallbackRegistry:Add("START_INTERACTION", Update, 0)
			CallbackRegistry:Add("STOP_INTERACTION", Update, 0)

			local _ = CreateFrame("Frame")
			_:RegisterEvent("CINEMATIC_START")
			_:RegisterEvent("PLAY_MOVIE")
			_:RegisterEvent("STOP_MOVIE")
			_:RegisterEvent("CINEMATIC_STOP")
			_:SetScript("OnEvent", function(_, event)
				Update()
			end)

			-- local _ = CreateFrame("Frame", "UpdateFrame/BlizzardFrames.lua -- SetupFrameVisibility", nil)
			-- _:SetScript("OnUpdate", function()
			-- 	if INTDB.profile.INT_HIDEUI and not UIParent:IsVisible() and addon.API:CanShowUIAndHideElements() then
			-- 		if not NS.Variables.SetElementsActive then
			-- 			addon.BlizzardFrames.Script:SetElements()
			-- 		end
			-- 	else
			-- 		if NS.Variables.SetElementsActive then
			-- 			addon.BlizzardFrames.Script:RemoveElements()
			-- 		end
			-- 	end
			-- end)
		end

		function Callback:SetElementToInteractionPriorityFrame(frame, strata)
			frame:SetParent(InteractionPriorityFrame)

			--------------------------------

			if strata then
				frame.SavedFrameStrata = frame:GetFrameStrata()
				frame:SetFrameStrata(strata)
			end
		end

		function Callback:SetElementToUIParent(frame, strata)
			frame:SetParent(UIParent)

			--------------------------------

			frame:SetFrameStrata(strata or frame.SavedFrameStrata or "FULLSCREEN_DIALOG")
		end

		function Callback:SetElements()
			NS.Variables.SetElementsActive = true

			--------------------------------

			Callback:SetElementToInteractionPriorityFrame(UIErrorsFrame)
		end

		function Callback:RemoveElements()
			NS.Variables.SetElementsActive = false

			--------------------------------

			Callback:SetElementToUIParent(UIErrorsFrame)
		end
	end

	--------------------------------
	-- EVENTS
	--------------------------------

	do
		CallbackRegistry:Add("START_INTERACTION", function()
			QuestFrame.Clear()
			GossipFrame.Clear()
		end, 0)
	end

	--------------------------------
	-- SETUP
	--------------------------------

	Callback:SetupFrameVisibility()

	AdaptiveAPI:UnregisterFrame(GossipFrame)
	AdaptiveAPI:UnregisterFrame(QuestFrame)
end
