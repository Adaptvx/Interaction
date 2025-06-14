-- [!] [addon.BlizzardFrames] is used to modify Blizzard's default frames to support the custom functionality.

---@class addon
local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local PrefabRegistry = addon.PrefabRegistry
local L = addon.Locales
local NS = addon.BlizzardFrames; addon.BlizzardFrames = NS

--------------------------------

NS.Script = {}

--------------------------------

function NS.Script:Load()
	--------------------------------
	-- REFERENCES
	--------------------------------

	local Callback = NS.Script; NS.Script = Callback

	--------------------------------
	-- FUNCTIONS (MAIN)
	--------------------------------

	do
		do -- BLIZZARD
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

			function Callback:Clear_QuestFrame()
				QuestFrame:ClearAllPoints()

				--------------------------------

				if not addon._DEV.ENABLED then
					ScanHideElement(QuestFrame)

					QuestFrame:SetPoint("CENTER", UIParent, 0, 10000)
					QuestFrame:SetAlpha(0)
				else
					QuestFrame:SetPoint("LEFT", UIParent)
					QuestFrame:SetAlpha(1)
				end
			end

			function Callback:Clear_GossipFrame()
				GossipFrame:ClearAllPoints()

				--------------------------------

				if not addon._DEV.ENABLED then
					ScanHideElement(GossipFrame)

					GossipFrame:SetPoint("CENTER", UIParent, 0, 10000)
					GossipFrame:SetAlpha(0)
				else
					GossipFrame:SetPoint("LEFT", UIParent)
					GossipFrame:SetAlpha(1)
				end
			end

			function Callback:Clear()
				Callback:Clear_QuestFrame()
				Callback:Clear_GossipFrame()
			end
		end

		do -- ELEMENTS
			function Callback:SetElements()
				NS.Variables.SetElementsActive = true

				--------------------------------

				Callback:SetElements_InteractionPriorityFrame(UIErrorsFrame)
			end

			function Callback:SetElements_UIParent(frame, strata)
				frame:SetParent(UIParent)

				--------------------------------

				frame:SetFrameStrata(strata or frame.SavedFrameStrata or "FULLSCREEN_DIALOG")
			end

			function Callback:SetElements_InteractionPriorityFrame(frame, strata)
				frame:SetParent(InteractionPriorityFrame)

				--------------------------------

				if strata then
					frame.SavedFrameStrata = frame:GetFrameStrata()
					frame:SetFrameStrata(strata)
				end
			end

			function Callback:RemoveElements()
				NS.Variables.SetElementsActive = false

				--------------------------------

				Callback:SetElements_UIParent(UIErrorsFrame)
			end
		end
	end

	--------------------------------
	-- CALLBACKS
	--------------------------------

	do
		if not addon.Variables.IS_WOW_VERSION_CLASSIC_ALL then
			local function Callback(queueType)
				CallbackRegistry:Trigger("QUEUE_POP", queueType)
			end

			hooksecurefunc(LFGDungeonReadyPopup, "Show", function() Callback("Dungeon") end)
			hooksecurefunc(PVPReadyDialog, "Show", function() Callback("PVP") end)
			hooksecurefunc(PVPReadyPopup, "Show", function() Callback("PVP") end)
			if PlunderstormFramePopup then hooksecurefunc(PlunderstormFramePopup, "Show", function() Callback("Plunderstorm") end) end
		end
	end

	--------------------------------
	-- EVENTS
	--------------------------------

	do
		CallbackRegistry:Add("START_INTERACTION", function()
			Callback:Clear()
		end, 0)
	end

	--------------------------------
	-- SETUP
	--------------------------------

	do
		addon.API.Util:UnregisterFrame(GossipFrame)
		addon.API.Util:UnregisterFrame(QuestFrame)
		GossipFrame:SetParent(InteractionFrame)
		QuestFrame:SetParent(InteractionFrame)

		--------------------------------

		StaticPopup1:SetIgnoreParentAlpha(true)
		if not addon.Variables.IS_WOW_VERSION_CLASSIC_ERA then LFGDungeonReadyPopup:SetIgnoreParentAlpha(true) end
		if not addon.Variables.IS_WOW_VERSION_CLASSIC_ALL then PVPReadyDialog:SetIgnoreParentAlpha(true) end
		if not addon.Variables.IS_WOW_VERSION_CLASSIC_ALL then PVPReadyPopup:SetIgnoreParentAlpha(true) end
		if not addon.Variables.IS_WOW_VERSION_CLASSIC_ALL and PlunderstormFramePopup then PlunderstormFramePopup:SetIgnoreParentAlpha(true) end

		--------------------------------

		local function Update()
			if addon.Database.DB_GLOBAL.profile.INT_HIDEUI and not UIParent:IsVisible() and addon.API.Main:CanShowUIAndHideElements() then
				if not NS.Variables.SetElementsActive then
					Callback:SetElements()
				end
			else
				if NS.Variables.SetElementsActive then
					Callback:RemoveElements()
				end
			end
		end

		CallbackRegistry:Add("START_HIDEUI", Update, 0)
		CallbackRegistry:Add("STOP_HIDEUI", Update, 0)
		CallbackRegistry:Add("START_INTERACTION", Update, 0)
		CallbackRegistry:Add("STOP_INTERACTION", Update, 0)

		local Events = CreateFrame("Frame")
		Events:RegisterEvent("CINEMATIC_START")
		Events:RegisterEvent("PLAY_MOVIE")
		Events:RegisterEvent("STOP_MOVIE")
		Events:RegisterEvent("CINEMATIC_STOP")
		Events:SetScript("OnEvent", Update)
	end
end
