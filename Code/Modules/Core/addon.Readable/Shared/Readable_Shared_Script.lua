---@class addon
local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local PrefabRegistry = addon.PrefabRegistry
local L = addon.Locales
local NS = addon.Readable; addon.Readable = NS

--------------------------------

NS.Script = {}

--------------------------------

function NS.Script:Load()
	--------------------------------
	-- REFERENCES
	--------------------------------

	local Callback = NS.Script; NS.Script = Callback
	local LibraryCallback = NS.LibraryUI.Script

	local Frame = NS.Variables.Frame
	local ReadableUI = NS.Variables.ReadableUIFrame
	local ReadableUI_ItemUI = ReadableUI.ItemFrame
	local ReadableUI_BookUI = ReadableUI.BookFrame
	local LibraryUI = NS.Variables.LibraryUIFrame

	--------------------------------
	-- FUNCTIONS (ANIMATION)
	--------------------------------

	do
		function Frame:StartCooldown()
			Frame.cooldown = true

			addon.Libraries.AceTimer:ScheduleTimer(function()
				Frame.cooldown = false
			end, 1)
		end

		function Frame:ShowWithAnimation(uiType)
			if not Frame.hidden or Frame.cooldown then
				return
			end
			Frame.hidden = false
			Frame:StartCooldown()

			Frame:Show()

			--------------------------------

			Frame:SetAlpha(0)
			Frame.Disc:SetAlpha(0)
			Frame.DiscTexture:SetRotation(0)

			if uiType == "READABLE" then
				ReadableUI:Show()
				LibraryUI:Hide()

				ReadableUI:SetAlpha(1)
				ReadableUI:ShowWithAnimation()
			end

			if uiType == "LIBRARY" then
				ReadableUI:Hide()
				LibraryUI:Show()

				LibraryUI:SetAlpha(1)
				LibraryUI:ShowWithAnimation()
			end

			--------------------------------

			addon.API.Animation:Fade(Frame, .5, 0, 1, nil)

			addon.Libraries.AceTimer:ScheduleTimer(function()
				local RING_SCALE = (uiType == "LIBRARY" and 1.25) or (uiType == "READABLE" and 1.125)

				----------------------------------

				addon.API.Animation:Fade(Frame.Disc, .25, 0, .5, nil)
				addon.API.Animation:Scale(Frame.Disc, 1, RING_SCALE + .125, RING_SCALE, nil, nil, nil)
				addon.API.Animation:Rotate(Frame.DiscTexture, 5, 0, 1, addon.API.Animation.EaseExpo, nil)
			end, .25)

			addon.Libraries.AceTimer:ScheduleTimer(function()
				addon.API.Animation:StartRotate(Frame.DiscTexture, .125)
			end, 2.5)

			--------------------------------

			if not IsInInstance() then
				addon.HideUI.Script:HideUI(true)

				if addon.Database.DB_GLOBAL.profile.INT_READABLE_CINEMATIC then
					addon.Cinematic.Script:StartCinematicMode(true, true)
				end
			end

			--------------------------------

			if not IsPlayerMoving() and not InCombatLockdown() then
				DoEmote("READ")
			end

			--------------------------------

			CallbackRegistry:Trigger("START_READABLE_UI")

			--------------------------------

			addon.SoundEffects:PlaySoundFile(addon.SoundEffects.Readable_Open)
		end

		function Frame:TransitionToType(uiType)
			if Frame.cooldown or Frame.transition then
				return
			end
			Frame.transition = true
			addon.Libraries.AceTimer:ScheduleTimer(function()
				Frame.transition = false
			end, 1)

			--------------------------------

			local StopEvent = function() return not Frame:IsVisible() or not Frame:GetAlpha() == 1 end

			--------------------------------

			if uiType == "READABLE" then
				LibraryUI:HideWithAnimation()
			end

			if uiType == "LIBRARY" then
				ReadableUI:HideWithAnimation()
			end

			addon.Libraries.AceTimer:ScheduleTimer(function()
				local RING_SCALE = (uiType == "LIBRARY" and 1.25) or (uiType == "READABLE" and 1.125)

				--------------------------------

				addon.API.Animation:StopRotate(Frame.DiscTexture)

				--------------------------------

				addon.API.Animation:Scale(Frame.Disc, 5, Frame.Disc:GetScale(), RING_SCALE, nil, addon.API.Animation.EaseExpo, StopEvent)
				addon.API.Animation:Rotate(Frame.DiscTexture, 5, 0, 1, addon.API.Animation.EaseExpo, StopEvent)
			end, 0)

			addon.Libraries.AceTimer:ScheduleTimer(function()
				if uiType == "LIBRARY" then
					LibraryUI:ShowWithAnimation()
				end

				if uiType == "READABLE" then
					ReadableUI:ShowWithAnimation()
				end
			end, .5)

			addon.Libraries.AceTimer:ScheduleTimer(function()
				addon.API.Animation:StartRotate(Frame.DiscTexture, .125)
			end, 1.5)

			--------------------------------

			addon.SoundEffects:PlaySoundFile(addon.SoundEffects.Readable_Transition)
		end

		function Frame:HideWithAnimation(bypass, preventCloseItem)
			if not bypass and (Frame.hidden or Frame.cooldown) then
				return
			end
			Frame.hidden = true
			Frame.cooldown = false

			addon.Libraries.AceTimer:ScheduleTimer(function()
				if Frame.hidden then
					Frame:Hide()
				end
			end, .125)

			--------------------------------

			addon.API.Animation:Fade(Frame, .125, Frame:GetAlpha(), 0)
			addon.API.Animation:StopRotate(Frame.DiscTexture)
			addon.API.Animation:Rotate(Frame.DiscTexture, 1, 0, 1, addon.API.Animation.EaseExpo, nil)

			--------------------------------

			if not IsInInstance() then
				addon.HideUI.Script:ShowUI(true)

				if addon.Database.DB_GLOBAL.profile.INT_READABLE_CINEMATIC then
					addon.Cinematic.Script:CancelCinematicMode(true)
				end
			end

			--------------------------------

			CancelEmote()

			--------------------------------

			CallbackRegistry:Trigger("STOP_READABLE_UI")

			--------------------------------

			if not preventCloseItem then
				CloseItemText()
			end

			--------------------------------

			addon.SoundEffects:PlaySoundFile(addon.SoundEffects.Readable_Close)
		end

		function Frame:ShowLibrary()
			if not addon.Initialize.Ready then
				return
			end

			--------------------------------

			if addon.Interaction.Variables.Active then
				addon.Interaction.Script:Stop(true)
			end

			--------------------------------

			Frame:ShowWithAnimation("LIBRARY")
		end
	end

	--------------------------------
	-- SETTINGS
	--------------------------------

	do
		local function Settings_UIDirection()
			Frame:ClearAllPoints()
			if addon.Database.DB_GLOBAL.profile.INT_UIDIRECTION == 1 then
				Frame:SetPoint("LEFT", nil)
			else
				Frame:SetPoint("RIGHT", nil, 0, 0)
			end

			if addon.Database.DB_GLOBAL.profile.INT_UIDIRECTION == 1 then
				Frame.BackgroundTexture:SetTexCoord(1, 0, 0, 1)
			else
				Frame.BackgroundTexture:SetTexCoord(0, 1, 0, 1)
			end

			Frame.CloseButton:ClearAllPoints()
			if addon.Database.DB_GLOBAL.profile.INT_UIDIRECTION == 1 then
				Frame.CloseButton:SetPoint("TOPLEFT", Frame, 25, -25)
			else
				Frame.CloseButton:SetPoint("TOPRIGHT", Frame, -25, -25)
			end

			InteractionReadableUIFrame.TTSButton:ClearAllPoints()
			if addon.Database.DB_GLOBAL.profile.INT_UIDIRECTION == 1 then
			    InteractionReadableUIFrame.TTSButton:SetPoint("TOPLEFT", InteractionReadableUIFrame, 50, -25)
			else
			    InteractionReadableUIFrame.TTSButton:SetPoint("TOPRIGHT", InteractionReadableUIFrame, -50, -25)
			end
		end
		Settings_UIDirection()

		--------------------------------

		CallbackRegistry:Add("SETTINGS_UIDIRECTION_CHANGED", Settings_UIDirection, 2)
	end

	--------------------------------
	-- EVENTS
	--------------------------------

	do
		if addon.Database.DB_GLOBAL.profile.INT_READABLE then
			CallbackRegistry:Add("READABLE_DATA_READY", function()
				Frame:ShowWithAnimation("READABLE")

				--------------------------------

				NS.ItemUI.Script:Update()
				NS.LibraryUI.Script:SaveToLibrary()
			end, 0)

			CallbackRegistry:Add("LIBRARY_MENU_DATA_LOADED", function()
				NS.LibraryUI.Script:UpdateButtons()
			end, 0)

			CallbackRegistry:Add("LIBRARY_MENU_SELECTION", function()
				NS.LibraryUI.Script:UpdateButtons()
			end, 0)

			CallbackRegistry:Add("START_INTERACTION", function()
				Frame:HideWithAnimation()
			end, 0)

			CallbackRegistry:Add("LIBRARY_INDEX_CHANGED", function()
				local Entries = NS.LibraryUI.Script:GetAllEntries()
				local Buttons = NS.LibraryUI.Script:GetButtons()

				--------------------------------

				for i = 1, #Buttons do
					if Buttons then
						if i > #Buttons then
							break
						end

						--------------------------------

						Buttons[i]:Update()
					end
				end
			end, 0)

			CallbackRegistry:Add("STOP_READABLE_UI", function()
				NS.ItemUI.Script:ClearData()
			end, 0)

			--------------------------------

			addon.API.Util:WatchLocalVariable(NS.LibraryUI.Variables, "SelectedIndex", function()
				CallbackRegistry:Trigger("LIBRARY_INDEX_CHANGED", NS.LibraryUI.Variables.SelectedIndex)
			end)

			--------------------------------

			local Events = CreateFrame("Frame")
			Events:RegisterEvent("ITEM_TEXT_READY")
			Events:RegisterEvent("ITEM_TEXT_CLOSED")
			Events:SetScript("OnEvent", function(self, event, ...)
				local arg1, arg2 = ...

				if event == "ITEM_TEXT_READY" then
					addon.Libraries.AceTimer:ScheduleTimer(function()
						if ItemTextGetItem() == NS.ItemUI.Variables.Title then
							return
						end

						local CurrentPage = 1
						local Type = ItemTextGetMaterial()
						local Title = ItemTextGetItem()
						local NumPages, Content = ItemTextFrame.GetAllPages()
						local IsItemInInventory = (addon.API.Util:FindItemInInventory(Title) ~= nil)
						local ItemID, ItemLink = addon.API.Util:FindItemInInventory(Title)
						local PlayerName = { ["name"] = UnitName("player"), ["server"] = GetRealmName() }

						NS.ItemUI.Script:SetData(ItemID, ItemLink, Type, Title, NumPages, Content, CurrentPage, IsItemInInventory, PlayerName)
						CallbackRegistry:Trigger("READABLE_DATA_READY")
					end, .1)
				end

				if event == "ITEM_TEXT_CLOSED" then
					if not addon.Database.DB_GLOBAL.profile.INT_READABLE_ALWAYS_SHOW then
						if Frame.ReadableUIFrame:IsVisible() then
							Frame:HideWithAnimation(true, true)
						end
					end
				end
			end)

			--------------------------------

			ItemTextFrame:UnregisterAllEvents()
			ItemTextFrame:SetAlpha(0)
			ItemTextFrame:EnableMouse(false)

			--------------------------------

			hooksecurefunc(ReadableUI, "Show", function()
				CallbackRegistry:Trigger("START_READABLE")
			end)

			hooksecurefunc(ReadableUI, "Hide", function()
				CallbackRegistry:Trigger("STOP_READABLE")
			end)

			hooksecurefunc(LibraryUI, "Show", function()
				CallbackRegistry:Trigger("START_LIBRARY")
			end)

			hooksecurefunc(LibraryUI, "Hide", function()
				CallbackRegistry:Trigger("STOP_LIBRARY")
			end)

			hooksecurefunc(Frame, "Hide", function()
				CallbackRegistry:Trigger("STOP_READABLE")
				CallbackRegistry:Trigger("STOP_LIBRARY")
			end)
		end
	end

	--------------------------------
	-- SETUP
	--------------------------------

	do
		Frame.cooldown = false
		Frame.transition = false
		Frame.pageUpdateTransition = false
	end
end
