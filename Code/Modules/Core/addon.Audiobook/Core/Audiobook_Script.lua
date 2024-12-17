local addonName, addon = ...
local CallbackRegistry = addon.CallbackRegistry
local L = addon.Locales
local NS = addon.Audiobook

--------------------------------

NS.Script = {}

--------------------------------

function NS.Script:Load()
	--------------------------------
	-- REFERENCES
	--------------------------------

	local Callback = NS.Script
	local Frame = InteractionAudiobookFrame

	--------------------------------
	-- FUNCTIONS (FRAME)
	--------------------------------

	-- DATA
	do
		function Callback:SplitText(text)
			if text == nil then
				return
			end

			if AdaptiveAPI:FindString(text, "HTML") then
				text = Callback:RemoveHTML(text)
			end

			local separatorPattern = "[>|<|!|?|\n]%s+"

			text = text:gsub(" %s+", " "):gsub("|cffFFFFFF", ""):gsub("|r", "")

			local function splittext(text, pattern)
				local start, iterator = 1, text.gmatch(text, "()(" .. pattern .. ")")

				local function getNextSegment(segments, separators, separator, capture1, ...)
					start = separator and separators + #separator
					return text.sub(text, segments, separators or -1), capture1 or separator, ...
				end

				return function()
					if start then
						return getNextSegment(start, iterator())
					end
				end
			end

			local lines = {}
			local lineIndex = 1

			for segment in splittext(text, separatorPattern) do
				if segment ~= nil and segment ~= "" then
					local String = string.gsub(segment, "\"", "")
					local IsQuotation = AdaptiveAPI:FindString(segment, '"')

					local entry = {
						line = String,
						quotation = IsQuotation
					}

					lines[lineIndex] = entry
					lineIndex = lineIndex + 1
				end
			end

			return lines
		end

		function Callback:RemoveHTML(text)
			local cleanText = text:gsub("<[^>]+>", function(tag)
				if tag:match("^</?[%w%d][^>]*>$") then
					return ""
				else
					return tag
				end
			end)

			cleanText = cleanText:gsub("%s+", " "):gsub("^%s*(.-)%s*$", "%1")

			return cleanText
		end

		function Callback:ReadLine(line)
			local Voice = (INTDB.profile.INT_READABLE_AUDIOBOOK_VOICE or 1) - 1
			local Rate = (INTDB.profile.INT_READABLE_AUDIOBOOK_RATE or 1) * .125
			local Volume = (INTDB.profile.INT_READABLE_AUDIOBOOK_VOLUME or 100)

			addon.Libraries.AceTimer:ScheduleTimer(function()
				C_VoiceChat.SpeakText(Voice, line, Enum.VoiceTtsDestination.LocalPlayback, Rate, Volume)
			end, 0)
		end

		function Callback:SetData(ItemID, ItemLink, Type, Title, NumPages, Content)
			Callback.IsPlaying = false
			Callback.PlaybackLineIndex = 1

			NS.ItemUI.Variables.Title = Title
			NS.ItemUI.Variables.NumPages = NumPages
			NS.ItemUI.Variables.Content = Content

			--------------------------------

			Callback:SetLines()
		end

		function Callback:SetLines()
			local Lines = {}

			for page = 1, NS.ItemUI.Variables.NumPages do
				local PageLines = Callback:SplitText(NS.ItemUI.Variables.Content[page])
				for line = 1, #PageLines do
					table.insert(Lines, PageLines and PageLines[line])
				end
			end

			Callback.Lines = Lines
		end

		function Callback:NextLine()
			if Callback.PlaybackLineIndex < #Callback.Lines then
				Callback.PlaybackLineIndex = Callback.PlaybackLineIndex + 1
				Callback:StartPlayback()
			else
				Callback:StopPlayback()
			end
		end

		function Callback:PreviousLine()
			if Callback.PlaybackLineIndex > 1 then
				Callback.PlaybackLineIndex = Callback.PlaybackLineIndex - 1
				Callback:StartPlayback()
			else
				Callback.PlaybackLineIndex = 1
			end
		end
	end

	-- PLAYBACK
	do
		Callback.PlaybackTimer = nil

		local function EstimateDuration(line)
			local NumChars = #line
			local CharsPerSecond = 10
			local Padding = 5
			local Duration = (NumChars / CharsPerSecond) + Padding

			return Duration
		end

		local function HandlePlaybackTimeout(currentLineIndex, maxLines)
			local IsSameLine = (Callback.PlaybackLineIndex == currentLineIndex)
			local IsValidLine = (currentLineIndex < maxLines)

			--------------------------------

			if IsSameLine and IsValidLine then
				if Callback.IsPlaying then
					-- print("Playback Timeout")
					Callback:StopPlayback()
				end
			end
		end

		local function CancelPlaybackTimer()
			if Callback.PlaybackTimer and Callback.PlaybackTimer.Cancel then
				Callback.PlaybackTimer:Cancel()
				Callback.PlaybackTimer = nil
			end
		end

		local function StartPlaybackTimer(currentLine)
			CancelPlaybackTimer()

			--------------------------------

			local duration = EstimateDuration(currentLine)
			Callback.PlaybackTimer = addon.Libraries.AceTimer:ScheduleTimer(function()
				HandlePlaybackTimeout(Callback.PlaybackLineIndex, #Callback.Lines)
			end, duration)
		end

		function Callback:StartPlayback()
			if addon.Interaction.Variables.Active and INTDB.profile.INT_TTS then
				return
			end

			--------------------------------

			Callback.IsPlaying = true
			Frame.UpdateState()

			--------------------------------

			local CurrentLine = Callback.Lines[Callback.PlaybackLineIndex].line
			local IsQuotation = Callback.Lines[Callback.PlaybackLineIndex].quotation
			Callback:ReadLine(CurrentLine)

			--------------------------------

			-- print(quotation)

			StartPlaybackTimer(CurrentLine)
		end

		function Callback:StopPlayback()
			if Callback.IsPlaying then
				Callback.IsPlaying = false
				Frame.UpdateState()

				--------------------------------

				C_VoiceChat.StopSpeakingText()

				--------------------------------

				CancelPlaybackTimer()
			end
		end

		function Callback:TogglePlayback()
			if Callback.IsPlaying then
				Callback:StopPlayback()
			else
				if Callback.PlaybackLineIndex >= #Callback.Lines then
					Callback.PlaybackLineIndex = 1
				end

				--------------------------------

				Frame.UpdateState(false)
				Callback:StartPlayback()
			end
		end

		function Callback:Play(LibraryID)
			if addon.Interaction.Variables.Active and INTDB.profile.INT_TTS then
				return
			end

			local function Main()
				local Entry = INTLIB.profile.READABLE[LibraryID]

				local ItemID = Entry.ItemID
				local ItemLink = Entry.ItemLink
				local Type = Entry.Type
				local Title = Entry.Title
				local NumPages = Entry.NumPages
				local Content = Entry.Content

				Callback:SetData(ItemID, ItemLink, Type, Title, NumPages, Content)
				Frame.UpdateState(false)

				--------------------------------

				C_VoiceChat.StopSpeakingText()

				--------------------------------

				addon.Libraries.AceTimer:ScheduleTimer(function()
					Callback:StartPlayback()

					--------------------------------

					Frame.ShowWithAnimation()
				end, 1)
			end

			if Callback.IsPlaying then
				Callback:Stop()

				addon.Libraries.AceTimer:ScheduleTimer(function()
					Main()
				end, 1)
			else
				Main()
			end
		end

		function Callback:Stop()
			NS.Variables.IsPlaying = nil
			NS.Variables.PlaybackLineIndex = nil

			NS.Variables.Title = nil
			NS.Variables.NumPages = nil
			NS.Variables.Content = nil
			NS.Variables.Lines = nil

			--------------------------------

			C_VoiceChat.StopSpeakingText()

			--------------------------------

			Callback:StopPlayback()

			--------------------------------

			Frame.HideWithAnimation()
		end
	end

	-- FRAME
	do
		Frame.UpdateState = function(playAnimation)
			if not Callback.Lines then
				return
			end

			--------------------------------

			local MaxLines = #Callback.Lines
			local CurrentLine = Callback.PlaybackLineIndex

			local Value = ((MaxLines) * (CurrentLine / MaxLines))

			--------------------------------

			local ProgressBar = Frame.Content.MainFrame.Right.Footer.StatusBar
			local PlaybackButtonImageTexture = Frame.Content.ButtonFrame.PlaybackButton.ImageTexture

			ProgressBar:SetMinMaxValues(1, MaxLines)
			if playAnimation == false then
				ProgressBar:SetValue(Value)
			else
				if ProgressBar.TargetValue ~= Value then
					ProgressBar.TargetValue = Value

					AdaptiveAPI.Animation:SetProgressTo(ProgressBar, Value, 1, AdaptiveAPI.Animation.EaseExpo, function() return ProgressBar.TargetValue ~= Value end)
				end
			end

			if Callback.IsPlaying then
				PlaybackButtonImageTexture:SetTexture(NS.Variables.AUDIOBOOKUI_PATH .. "playback-pause.png")
			else
				PlaybackButtonImageTexture:SetTexture(NS.Variables.AUDIOBOOKUI_PATH .. "playback-play.png")
			end

			--------------------------------

			Frame.UpdateText()
		end

		Frame.UpdateText = function()
			if not Callback.Lines then
				return
			end

			--------------------------------

			local MaxLines = #Callback.Lines
			local CurrentLine = Callback.PlaybackLineIndex

			--------------------------------

			local Title = Frame.Content.MainFrame.Right.Header.Title
			local StatusText = Frame.Content.MainFrame.Left.StatusText

			Title:SetText(NS.ItemUI.Variables.Title)
			StatusText:SetText(Callback.PlaybackLineIndex .. "/" .. MaxLines)
		end

		Frame.SetSteps = function()
			local StatusBar = Frame.Content.MainFrame.Right.Footer.StatusBar

			--------------------------------

			local MaxLines = #Callback.Lines
			local Min, Max = StatusBar:GetMinMaxValues()

			StatusBar:SetValueStep(Max / MaxLines)
		end

		Frame.RemoveSteps = function()
			local StatusBar = Frame.Content.MainFrame.Right.Footer.StatusBar

			--------------------------------

			StatusBar:SetValueStep(0)
		end

		Frame.SetIndexOnValue = function()
			local StatusBar = Frame.Content.MainFrame.Right.Footer.StatusBar

			--------------------------------

			Callback.PlaybackLineIndex = math.floor(StatusBar:GetValue())

			--------------------------------

			Frame.UpdateState(false)
		end
	end

	--------------------------------
	-- FUNCTIONS (ANIMATION)
	--------------------------------

	Frame.ShowWithAnimation = function()
		Frame.hidden = false
		Frame:Show()

		--------------------------------

		AdaptiveAPI.Animation:FadeText(Frame.Content.MainFrame.Right.Header.Title, 1, 35, 1, nil, function() return Frame.moving or Frame.hidden end)
		AdaptiveAPI.Animation:FadeText(Frame.Content.MainFrame.Left.StatusText, 1, 35, 1, nil, function() return Frame.moving or Frame.hidden end)

		--------------------------------

		AdaptiveAPI.Animation:Fade(Frame, .25, 0, 1, nil, function() return Frame.hidden end)
		AdaptiveAPI.Animation:Scale(Frame.Content, .75, 1.25, 1, nil, AdaptiveAPI.Animation.EaseExpo, function() return Frame.hidden end)
		AdaptiveAPI.Animation:Scale(Frame.Background, .5, 1.125, 1, nil, AdaptiveAPI.Animation.EaseExpo, function() return Frame.hidden end)
	end

	Frame.HideWithAnimation = function()
		Frame.hidden = true
		addon.Libraries.AceTimer:ScheduleTimer(function()
			if Frame.hidden then
				Frame:Hide()
			end
		end, 1)

		--------------------------------

		AdaptiveAPI.Animation:Fade(Frame, .25, Frame:GetAlpha(), 0, nil, function() return not Frame.hidden end)
		AdaptiveAPI.Animation:Scale(Frame.Content, .375, Frame.Content:GetScale(), 1.175, nil, AdaptiveAPI.Animation.EaseExpo, function() return not Frame.hidden end)
		AdaptiveAPI.Animation:Scale(Frame.Background, .375, Frame.Background:GetScale(), 1.125, nil, AdaptiveAPI.Animation.EaseExpo, function() return not Frame.hidden end)
	end

	--------------------------------
	-- SETTINGS
	--------------------------------

	--------------------------------
	-- EVENTS
	--------------------------------

	CallbackRegistry:Add("START_INTERACTION", function()
		local InteractionActive = (addon.Interaction.Variables.Active)
		local IsTTS = (INTDB.profile.INT_TTS)

		--------------------------------

		if InteractionActive and IsTTS then
			Callback:StopPlayback()
		end
	end)

	CallbackRegistry:Add("START_READABLE", function()

	end)

	local Events = CreateFrame("Frame")
	Events:RegisterEvent("VOICE_CHAT_TTS_PLAYBACK_FINISHED")
	Events:SetScript("OnEvent", function(self, event, ...)
		if Callback.IsPlaying then
			addon.Libraries.AceTimer:ScheduleTimer(function()
				if Callback.IsPlaying then
					Callback:NextLine()
				end
			end, .5)
		end
	end)

	local ResponseFrame = CreateFrame("Frame")
	ResponseFrame:RegisterEvent("ADDONS_UNLOADING")
	ResponseFrame:SetScript("OnEvent", function(self, event, ...)
		if event == "ADDONS_UNLOADING" then
			C_VoiceChat.StopSpeakingText()
		end
	end)
end
