---@class addon
local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local PrefabRegistry = addon.PrefabRegistry
local L = addon.Locales
local NS = addon.Audiobook; addon.Audiobook = NS

--------------------------------

NS.Script = {}

--------------------------------

function NS.Script:Load()
	--------------------------------
	-- REFERENCES
	--------------------------------

	local Callback = NS.Script; NS.Script = Callback
	local Frame = InteractionAudiobookFrame

	--------------------------------
	-- FUNCTIONS (BUTTONS)
	--------------------------------

	do
		Frame.MouseResponder:HookScript("OnMouseUp", function(_, button)
			if button == "RightButton" then
				Callback:Stop()
			end
		end)

		Frame.Content.PlaybackButton:HookScript("OnMouseUp", function()
			Callback:TogglePlayback()
		end)

		Frame.Content.Slider:HookScript("OnMouseDown", function()
			Callback:StopPlayback()
		end)

		Frame.Content.Slider:HookScript("OnMouseUp", function()
			Frame:UpdateState()

			--------------------------------

			local isSameLine, isLastLine = Callback:IsSameLine()
			if isSameLine then
				Callback:StartPlayback()
			end
		end)

		Frame.Content.Slider:HookScript("OnValueChanged", function(self, value, userInput)
			if userInput then
				Frame:SetIndexOnValue()
			end
		end)

		addon.API.Util:AddTooltip(Frame.MouseResponder, L["Audiobook - Action Tooltip"], "ANCHOR_BOTTOM", 0, -20, true)
	end

	--------------------------------
	-- FUNCTIONS (FRAME)
	--------------------------------

	do
		do -- DATA
			local function SplitText(text, pattern)
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

			function Callback:SplitText(text)
				if not text then
					return
				end

				--------------------------------

				if addon.API.Util:FindString(text, "HTML") then
					text = Callback:RemoveHTML(text)
				end

				local separatorPattern = "[<|>|!|?|\n]%s+"
				text = text:gsub(" %s+", " "):gsub("|cffFFFFFF", ""):gsub("|r", "")

				--------------------------------

				local lines = {}
				local lineIndex = 1

				for segment in SplitText(text, separatorPattern) do
					if segment ~= nil and segment ~= "" then
						local quotationStrings = { { string = "<", seperator = "<" }, { string = ">", seperator = ">" } }
						local string = segment

						local line = string
						local quotation = false
						for i = 1, #quotationStrings do
							if addon.API.Util:FindString(segment, quotationStrings[i].string) then
								quotation = true
								break
							end
						end

						--------------------------------

						local entry = {
							line = line,
							quotation = quotation
						}

						lines[lineIndex] = entry
						lineIndex = lineIndex + 1
					end
				end

				--------------------------------

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

				--------------------------------

				return cleanText
			end

			function Callback:ReadLine(line, quotation)
				local voice
				local rate = (addon.Database.DB_GLOBAL.profile.INT_READABLE_AUDIOBOOK_RATE or 1) * .125
				local volume = (addon.Database.DB_GLOBAL.profile.INT_READABLE_AUDIOBOOK_VOLUME or 100)

				if quotation then
					voice = (addon.Database.DB_GLOBAL.profile.INT_READABLE_AUDIOBOOK_VOICE_SPECIAL or 1) - 1
				else
					voice = (addon.Database.DB_GLOBAL.profile.INT_READABLE_AUDIOBOOK_VOICE or 1) - 1
				end

				--------------------------------

				addon.Libraries.AceTimer:ScheduleTimer(function()
					addon.TextToSpeech.Script:SpeakText(voice, line, Enum.VoiceTtsDestination and Enum.VoiceTtsDestination.LocalPlayback or 1, rate, volume)
				end, 0)
			end

			function Callback:SetTextPreview(line, quotation)
				if quotation then
					Frame.TextPreviewFrame.Content.Text:SetTextColor(addon.Theme.RGB_CHAT_MSG_EMOTE.r, addon.Theme.RGB_CHAT_MSG_EMOTE.g, addon.Theme.RGB_CHAT_MSG_EMOTE.b, addon.Theme.RGB_CHAT_MSG_EMOTE.a)
				else
					Frame.TextPreviewFrame.Content.Text:SetTextColor(addon.Theme.RGB_CHAT_MSG_SAY.r, addon.Theme.RGB_CHAT_MSG_SAY.g, addon.Theme.RGB_CHAT_MSG_SAY.b, addon.Theme.RGB_CHAT_MSG_SAY.a)
				end

				--------------------------------

				Frame.TextPreviewFrame.Content.Text:SetText(line)
			end

			function Callback:SetData(itemID, itemLink, type, title, numPages, content)
				NS.Variables.IsPlaying = false
				NS.Variables.PlaybackLineIndex = 1

				NS.Variables.Title = title
				NS.Variables.NumPages = numPages
				NS.Variables.Content = content

				--------------------------------

				Callback:SetLines()
			end

			function Callback:SetLines()
				local lines = {}

				for page = 1, NS.Variables.NumPages do
					local PageLines = Callback:SplitText(NS.Variables.Content[page])
					for line = 1, #PageLines do
						table.insert(lines, PageLines and PageLines[line])
					end
				end

				NS.Variables.Lines = lines
			end

			function Callback:NextLine()
				if NS.Variables.PlaybackLineIndex < #NS.Variables.Lines then
					NS.Variables.PlaybackLineIndex = NS.Variables.PlaybackLineIndex + 1
					Callback:StartPlayback()
				else
					Callback:StopPlayback()
				end
			end

			function Callback:PreviousLine()
				if NS.Variables.PlaybackLineIndex > 1 then
					NS.Variables.PlaybackLineIndex = NS.Variables.PlaybackLineIndex - 1
					Callback:StartPlayback()
				else
					NS.Variables.PlaybackLineIndex = 1
				end
			end

			function Callback:IsSameLine()
				if not NS.Variables.Lines then
					return
				end

				--------------------------------

				local currentLineIndex = NS.Variables.PlaybackLineIndex
				local maxLines = #NS.Variables.Lines
				local isSameLine = (NS.Variables.PlaybackLineIndex == currentLineIndex)
				local isLastLine = (currentLineIndex == maxLines)

				return isSameLine, isLastLine
			end
		end

		do -- PLAYBACK
			local function EstimateDuration(line)
				local numChars = strlenutf8(line)
				local rate = (addon.Database.DB_GLOBAL.profile.INT_READABLE_AUDIOBOOK_RATE + 10) * 10
				local rateModifier = .025
				local charsPerSecond = L["AudiobookData - EstimatedCharPerSecond"] + (rate * rateModifier - (100 * rateModifier))
				local padding = 1
				local duration = (numChars / charsPerSecond) + padding

				return duration
			end

			local function HandlePlaybackTimeout()
				if NS.Variables.IsPlaying then
					local isSameLine, isLastLine = Callback:IsSameLine()

					--------------------------------

					if isSameLine and not isLastLine then
						Callback:StopPlayback()

						--------------------------------

						addon.Libraries.AceTimer:ScheduleTimer(Callback.NextLine, .5)
					elseif isLastLine then
						Callback:StopPlayback()
					end
				end
			end

			local function CancelPlaybackTimer()
				if NS.Variables.PlaybackTimer and NS.Variables.PlaybackTimer.Cancel then
					NS.Variables.PlaybackTimer:Cancel()
					NS.Variables.PlaybackTimer = nil
				end
			end

			local function StartPlaybackTimer(currentLine)
				CancelPlaybackTimer()

				--------------------------------

				local duration = EstimateDuration(currentLine)
				NS.Variables.PlaybackTimer = C_Timer.NewTimer(duration, function()
					if NS.Variables.Lines then
						HandlePlaybackTimeout()
					end
				end)
			end

			function Callback:StartPlayback()
				if addon.Interaction.Variables.Active and addon.Database.DB_GLOBAL.profile.INT_TTS then
					return
				end

				--------------------------------

				NS.Variables.IsPlaying = true
				NS.Variables.LastPlayTime = GetTime()
				Frame:UpdateState()

				--------------------------------

				local line = NS.Variables.Lines[NS.Variables.PlaybackLineIndex].line
				local quotation = NS.Variables.Lines[NS.Variables.PlaybackLineIndex].quotation
				Callback:ReadLine(line, quotation)
				Callback:SetTextPreview(line, quotation)

				--------------------------------

				StartPlaybackTimer(line)
			end

			function Callback:StopPlayback()
				if NS.Variables.IsPlaying then
					NS.Variables.IsPlaying = false
					Frame:UpdateState()

					--------------------------------

					addon.TextToSpeech.Script:StopSpeakingText()

					--------------------------------

					CancelPlaybackTimer()
				end
			end

			function Callback:TogglePlayback()
				if NS.Variables.IsPlaying then
					Callback:StopPlayback()
				else
					if NS.Variables.PlaybackLineIndex >= #NS.Variables.Lines then
						NS.Variables.PlaybackLineIndex = 1
					end

					--------------------------------

					Frame:UpdateState()
					Callback:StartPlayback()
				end
			end

			function Callback:Play(LibraryID)
				if addon.Interaction.Variables.Active and addon.Database.DB_GLOBAL.profile.INT_TTS then
					return
				end

				local function Main()
					local entry = addon.Readable.LibraryUI.Variables.LibraryDB[LibraryID]

					local itemID = entry.ItemID
					local itemLink = entry.ItemLink
					local type = entry.Type
					local title = entry.Title
					local numPages = entry.NumPages
					local content = entry.Content

					Callback:SetData(itemID, itemLink, type, title, numPages, content)
					Frame:UpdateState()

					--------------------------------

					addon.TextToSpeech.Script:StopSpeakingText()

					--------------------------------

					addon.Libraries.AceTimer:ScheduleTimer(function()
						Callback:StartPlayback()

						--------------------------------

						Frame:ShowWithAnimation()
					end, 1)
				end

				if NS.Variables.IsPlaying then
					Callback:Stop()

					addon.Libraries.AceTimer:ScheduleTimer(function()
						Main()
					end, .25)
				else
					Main()
				end
			end

			function Callback:Stop()
				NS.Variables.IsPlaying = nil
				NS.Variables.LastPlayTime = nil
				NS.Variables.PlaybackLineIndex = nil

				NS.Variables.Title = nil
				NS.Variables.NumPages = nil
				NS.Variables.Content = nil
				NS.Variables.Lines = nil

				--------------------------------

				addon.TextToSpeech.Script:StopSpeakingText()

				--------------------------------

				Callback:StopPlayback()

				--------------------------------

				Frame:HideWithAnimation()
			end
		end

		do -- FRAME
			function Frame:UpdateState()
				if not NS.Variables.Lines then
					return
				end

				--------------------------------

				local maxLines = #NS.Variables.Lines
				local currentLine = NS.Variables.PlaybackLineIndex

				local value = ((maxLines) * (currentLine / maxLines))

				--------------------------------

				Frame.Content.Slider:SetMinMaxValues(1, maxLines)
				Frame.Content.Slider:SetValue(value)

				if NS.Variables.IsPlaying then
					Frame.Content.PlaybackButton.ImageTexture:SetTexture(NS.Variables.AUDIOBOOKUI_PATH .. "button-playback-pause.png")

					--------------------------------

					if Frame.TextPreviewFrame.hidden then
						Frame.TextPreviewFrame:ShowWithAnimation()
					end
				else
					Frame.Content.PlaybackButton.ImageTexture:SetTexture(NS.Variables.AUDIOBOOKUI_PATH .. "button-playback-play.png")

					--------------------------------

					if not Frame.TextPreviewFrame.hidden then
						Frame.TextPreviewFrame:HideWithAnimation()
					end
				end

				--------------------------------

				Frame:UpdateText()
			end

			function Frame:UpdateText()
				if not NS.Variables.Lines then
					return
				end

				--------------------------------

				local minPage, maxPage = Frame.Content.Slider:GetMinMaxValues()
				local currentPage = Frame.Content.Slider:GetValue()

				Frame.Content.Text.Title:SetText(NS.Variables.Title or "")
				Frame.Content.Text.Index.Text:SetText(currentPage .. "/" .. maxPage)
			end

			function Frame:SetIndexOnValue()
				NS.Variables.PlaybackLineIndex = math.floor(Frame.Content.Slider:GetValue())

				--------------------------------

				Frame:UpdateState()
			end
		end
	end

	--------------------------------
	-- FUNCTIONS (ANIMATION)
	--------------------------------

	do
		do -- SHOW
			function Frame:ShowWithAnimation_StopEvent()

			end

			function Frame:ShowWithAnimation()
				Frame.hidden = false
				Frame:Show()

				Frame.MouseResponder:Show()

				--------------------------------

				addon.API.Animation:Fade(Frame, .125, 0, 1, nil, Frame.ShowWithAnimation_StopEvent)
				addon.API.Animation:Scale(Frame.Background, .25, .875, 1, nil, addon.API.Animation.EaseSine, Frame.ShowWithAnimation_StopEvent)
				addon.API.Animation:Fade(Frame.Content, .25, 0, 1, nil, Frame.ShowWithAnimation_StopEvent)
				addon.API.Animation:Scale(Frame.Content, .25, 1.05, 1, nil, addon.API.Animation.EaseSine, Frame.ShowWithAnimation_StopEvent)
			end
		end

		do -- HIDE
			function Frame:HideWithAnimation_StopEvent()

			end

			function Frame:HideWithAnimation()
				Frame.hidden = true
				addon.Libraries.AceTimer:ScheduleTimer(function()
					if Frame.hidden then
						Frame:Hide()
					end
				end, 1)

				Frame.MouseResponder:Hide()

				--------------------------------

				addon.API.Animation:Fade(Frame, .125, Frame:GetAlpha(), 0, nil, Frame.HideWithAnimation_StopEvent)
				addon.API.Animation:Scale(Frame.Background, .25, Frame.Background:GetScale(), 1.05, nil, addon.API.Animation.EaseSine, Frame.HideWithAnimation_StopEvent)
				addon.API.Animation:Fade(Frame.Content, .125, Frame.Content:GetAlpha(), 0, nil, Frame.HideWithAnimation_StopEvent)
				addon.API.Animation:Scale(Frame.Content, .25, Frame.Content:GetScale(), 1.125, nil, addon.API.Animation.EaseSine)
			end
		end

		do -- TEXT PREVIEW
			do -- SHOW
				function Frame.TextPreviewFrame:ShowWithAnimation_StopEvent()
					return Frame.TextPreviewFrame.hidden
				end

				function Frame.TextPreviewFrame:ShowWithAnimation()
					if not Frame.TextPreviewFrame.hidden then
						return
					end
					Frame.TextPreviewFrame.hidden = false
					Frame.TextPreviewFrame:Show()

					--------------------------------

					addon.API.Animation:Fade(Frame.TextPreviewFrame, .125, 0, 1, nil, Frame.TextPreviewFrame.ShowWithAnimation_StopEvent)
				end
			end

			do -- HIDE
				function Frame.TextPreviewFrame:HideWithAnimation_StopEvent()
					return not Frame.TextPreviewFrame.hidden
				end

				function Frame.TextPreviewFrame:HideWithAnimation()
					if Frame.TextPreviewFrame.hidden then
						return
					end
					Frame.TextPreviewFrame.hidden = true
					addon.Libraries.AceTimer:ScheduleTimer(function()
						if Frame.TextPreviewFrame.hidden then
							Frame.TextPreviewFrame:Hide()
						end
					end, .25)

					--------------------------------

					addon.API.Animation:Fade(Frame.TextPreviewFrame, .125, Frame.TextPreviewFrame:GetAlpha(), 0, nil, Frame.TextPreviewFrame.HideWithAnimation_StopEvent)
				end
			end

			do -- FRAME
				function Frame.TextPreviewFrame:NewTextAnimation()
					addon.API.Animation:Fade(Frame.TextPreviewFrame.Content.Text, .5, 0, 1)
					addon.API.Animation:Move(Frame.TextPreviewFrame.Content.Text, .375, "CENTER", 25, 0, "y")
				end
			end
		end
	end

	--------------------------------
	-- EVENTS
	--------------------------------

	do
		CallbackRegistry:Add("START_INTERACTION", function()
			local interactionActive = (addon.Interaction.Variables.Active)
			local isTTS = (addon.Database.DB_GLOBAL.profile.INT_TTS)

			--------------------------------

			if interactionActive and isTTS then
				Callback:StopPlayback()
			end
		end)

		CallbackRegistry:Add("START_READABLE", function()

		end)

		local Events = CreateFrame("Frame")
		Events:RegisterEvent("VOICE_CHAT_TTS_PLAYBACK_FINISHED")
		Events:SetScript("OnEvent", function(self, event, ...)
			if NS.Variables.IsPlaying then
				local isSameLine, isLastLine = Callback:IsSameLine()
				local isActualPlayback = (GetTime() - NS.Variables.LastPlayTime > 1)

				--------------------------------

				if isActualPlayback then
					if isSameLine and not isLastLine then
						Callback:NextLine()
					elseif isLastLine then
						Callback:StopPlayback()
					end
				end
			end
		end)

		local ResponseFrame = CreateFrame("Frame")
		ResponseFrame:RegisterEvent("ADDONS_UNLOADING")
		ResponseFrame:SetScript("OnEvent", function(self, event, ...)
			if event == "ADDONS_UNLOADING" then
				addon.TextToSpeech.Script:StopSpeakingText()
			end
		end)
	end
end
