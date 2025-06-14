---@class addon
local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local PrefabRegistry = addon.PrefabRegistry
local L = addon.Locales
local NS = addon.PromptText; addon.PromptText = NS

--------------------------------

NS.Script = {}

--------------------------------

function NS.Script:Load()
	--------------------------------
	-- REFERENCES
	--------------------------------

	local Frame = InteractionTextPromptFrame
	local Callback = NS.Script; NS.Script = Callback

	--------------------------------
	-- FUNCTIONS (BUTTONS)
	--------------------------------

	do
		Frame.ButtonArea.Button1:SetScript("OnClick", function(self)
			local success = self.Callback(self, Frame.InputArea.InputBox:GetText())

			--------------------------------

			if success then
				addon.PromptText:HideTextFrame()
			end
		end)
	end

	--------------------------------
	-- FUNCTIONS (FRAME)
	--------------------------------

	do
		function Callback:ShowTextFrame(title, multiline, hint, text, buttonText, buttonCallback, autoSelect)
			Frame.TitleArea.Title:SetText(title)
			Frame.InputArea.InputBox:SetText(text)
			Frame.InputArea.InputBox:SetMultiLine(multiline)
			Frame.InputArea.InputBox.Hint:SetText(hint)

			--------------------------------

			if autoSelect then
				Frame.InputArea.InputBox:HighlightText(0, #Frame.InputArea.InputBox:GetText())

				--------------------------------

				addon.Libraries.AceTimer:ScheduleTimer(function()
					Frame.InputArea.InputBox:SetFocus()
				end, .1)
			end

			--------------------------------


			addon.API.FrameUtil:SetVisibility(Frame.ButtonArea.Button1, (buttonText and buttonCallback))
			if buttonText and buttonCallback then
				Frame.ButtonArea.Button1:SetText(buttonText)
				Frame.ButtonArea.Button1.Callback = buttonCallback
			end

			--------------------------------

			Frame:ShowWithAnimation()
		end

		function Callback:HideTextFrame()
			Frame.TitleArea.Title:SetText("")
			Frame.InputArea.InputBox:SetText("")

			--------------------------------

			Frame.ButtonArea.Button1:Hide()
			Frame.ButtonArea.Button1:SetText("")
			Frame.ButtonArea.Button1.Callback = nil

			--------------------------------

			Frame:HideWithAnimation()
		end
	end

	--------------------------------
	-- FUNCTIONS (ANIMATION)
	--------------------------------

	do
		do -- SHOW
			function Frame:ShowWithAnimation_StopEvent()
				return Frame.hidden
			end

			function Frame:ShowWithAnimation()
				Frame:Show()
				Frame.hidden = false

				addon.API.Animation:Fade(Frame, .25, 0, 1, nil, Frame.ShowWithAnimation_StopEvent)
				if addon.Database.DB_GLOBAL.profile.INT_UIDIRECTION == 1 then
					addon.API.Animation:Move(Frame, .5, "CENTER", -25, 0, "y", addon.API.Animation.EaseExpo, Frame.ShowWithAnimation_StopEvent)
				else
					addon.API.Animation:Move(Frame, .5, "CENTER", -25, 0, "y", addon.API.Animation.EaseExpo, Frame.ShowWithAnimation_StopEvent)
				end
			end
		end

		do -- HIDE
			function Frame:HideWithAnimation_StopEvent()
				return not Frame.hidden
			end

			function Frame:HideWithAnimation()
				addon.Libraries.AceTimer:ScheduleTimer(function()
					Frame:Hide()
				end, .5)
				Frame.hidden = true

				addon.API.Animation:Fade(Frame, .25, Frame:GetAlpha(), 0, nil, Frame.HideWithAnimation_StopEvent)
				if addon.Database.DB_GLOBAL.profile.INT_UIDIRECTION == 1 then
					addon.API.Animation:Move(Frame, .5, "CENTER", 0, -25, "y", addon.API.Animation.EaseExpo, Frame.HideWithAnimation_StopEvent)
				else
					addon.API.Animation:Move(Frame, .5, "CENTER", 0, -25, "y", addon.API.Animation.EaseExpo, Frame.HideWithAnimation_StopEvent)
				end
			end
		end
	end

	--------------------------------
	-- SETTINGS
	--------------------------------

	do
		local function Settings_UIDirection()
			Frame:ClearAllPoints()
			if addon.Database.DB_GLOBAL.profile.INT_UIDIRECTION == 1 then
				Frame:SetPoint("CENTER", UIParent, 0, 0)
			else
				Frame:SetPoint("CENTER", UIParent, 0, 0)
			end
		end
		Settings_UIDirection()

		--------------------------------

		CallbackRegistry:Add("SETTINGS_UIDIRECTION_CHANGED", Settings_UIDirection)
	end

	--------------------------------
	-- EVENTS
	--------------------------------
end
