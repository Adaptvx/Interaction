local addonName, addon = ...
local CallbackRegistry = addon.CallbackRegistry
local L = addon.Locales
local NS = addon.Readable

--------------------------------

NS.ItemUI.Script = {}

--------------------------------

function NS.ItemUI.Script:Load()
	--------------------------------
	-- REFERENCES
	--------------------------------

	local Callback = NS.Script
	local LibraryCallback = NS.LibraryUI.Script

	local Frame = NS.Variables.Frame
	local ReadableUI = NS.Variables.ReadableUIFrame
	local ReadableUI_ItemUI = ReadableUI.ItemFrame
	local ReadableUI_BookUI = ReadableUI.BookFrame
	local LibraryUI = NS.Variables.LibraryUIFrame

	--------------------------------
	-- FUNCTIONS (BUTTONS)
	--------------------------------

	do
		Frame.ButtonCooldown = function()
			Frame.button_cooldown = true

			addon.Libraries.AceTimer:ScheduleTimer(function()
				Frame.button_cooldown = false
			end, .5)
		end

		Frame.Back = function()
			if NS.ItemUI.Variables.CurrentPage <= 1 then
				Frame.TransitionToType("Library")
			else
				NS.ItemUI.Script:PreviousPage()
			end
		end

		Frame.Next = function()
			NS.ItemUI.Script:NextPage()
		end

		Frame.ReadableUIFrame.BookFrame.FrontPageParent:SetScript("OnMouseUp", function(self, button)
			if ReadableUI_BookUI.FrontPage:IsVisible() then
				NS.ItemUI.Script:NextPage()
			end
		end)

		Frame.ReadableUIFrame.BookFrame.Content.Left:SetScript("OnMouseUp", function(self, button)
			if ReadableUI_BookUI.Content:IsVisible() then
				NS.ItemUI.Script:PreviousPage()
			end
		end)

		Frame.ReadableUIFrame.BookFrame.Content.Right:SetScript("OnMouseUp", function(self, button)
			if ReadableUI_BookUI.Content:IsVisible() then
				NS.ItemUI.Script:NextPage()
			end
		end)

		Frame.ReadableUIFrame.ItemFrame:SetScript("OnMouseUp", function(self, button)
			if ReadableUI_ItemUI:IsVisible() then
				if button == "LeftButton" then
					NS.ItemUI.Script:NextPage()
				end

				if button == "RightButton" then
					NS.ItemUI.Script:PreviousPage()
				end
			end
		end)

		Frame.ReadableUIFrame:SetScript("OnMouseWheel", function(self, delta)
			if delta > 0 then
				if NS.ItemUI.Variables.CurrentPage > 1 then
					NS.ItemUI.Script:PreviousPage()
				end
			else
				if NS.ItemUI.Variables.CurrentPage < NS.ItemUI.Variables.NumPages then
					NS.ItemUI.Script:NextPage()
				end
			end
		end)

		--------------------------------

		CallbackRegistry:Add("READABLE_ITEMUI_UPDATE", function()
			if NS.ItemUI.Variables.Content then
				Frame.ReadableUIFrame.NavigationFrame.PreviousPage:Show()

				--------------------------------

				if NS.ItemUI.Variables.CurrentPage < #NS.ItemUI.Variables.Content then
					Frame.ReadableUIFrame.NavigationFrame.NextPage:Show()
				else
					Frame.ReadableUIFrame.NavigationFrame.NextPage:Hide()
				end
			end
		end)
	end

	--------------------------------
	-- FUNCTIONS (MAIN)
	--------------------------------

	do
		function NS.ItemUI.Script:SetData(itemID, itemLink, type, title, numPages, content, currentPage, isItemInInventory, playerName)
			NS.ItemUI.Variables.ItemID = itemID
			NS.ItemUI.Variables.ItemLink = itemLink
			NS.ItemUI.Variables.Type = type
			NS.ItemUI.Variables.Title = title
			NS.ItemUI.Variables.NumPages = numPages
			NS.ItemUI.Variables.Content = content
			NS.ItemUI.Variables.CurrentPage = currentPage
			NS.ItemUI.Variables.IsItemInInventory = isItemInInventory
			NS.ItemUI.Variables.PlayerName = playerName
		end

		function NS.ItemUI.Script:ClearData()
			NS.ItemUI.Variables.ItemID = nil
			NS.ItemUI.Variables.ItemLink = nil
			NS.ItemUI.Variables.Type = nil
			NS.ItemUI.Variables.Title = nil
			NS.ItemUI.Variables.NumPages = 0
			NS.ItemUI.Variables.Content = {}
			NS.ItemUI.Variables.CurrentPage = 0
			NS.ItemUI.Variables.IsItemInInventory = false
			NS.ItemUI.Variables.PlayerName = {}
		end

		function NS.ItemUI.Script:Update()
			local Type = NS.ItemUI.Variables.Type

			--------------------------------

			local ItemParchmentTexture; if addon.Theme.IsDarkTheme then
				ItemParchmentTexture = NS.Variables.READABLE_UI_PATH .. "Parchment/parchment-dark-mode.png"
			else
				ItemParchmentTexture = NS.Variables.READABLE_UI_PATH .. "Parchment/parchment-light-mode.png"
			end
			local ItemParchmentLargeTexture = ItemParchmentTexture
			local ItemStoneTexture = NS.Variables.READABLE_UI_PATH .. "Slate/Slate.png"

			local BookCoverTexture
			local BookContentTexture
			if Type == "Parchment" or Type == nil then
				BookCoverTexture = NS.Variables.READABLE_UI_PATH .. "Book/book-cover.png"
				BookContentTexture = NS.Variables.READABLE_UI_PATH .. "Book/book.png"
			else
				BookCoverTexture = NS.Variables.READABLE_UI_PATH .. "Book/book-cover-large.png"
				BookContentTexture = NS.Variables.READABLE_UI_PATH .. "Book/book-large.png"
			end

			--------------------------------

			local function State()
				if Type == "Parchment" or Type == "ParchmentLarge" or not Type then
					if NS.ItemUI.Variables.NumPages > 1 then
						ReadableUI_ItemUI:Hide()
						ReadableUI_BookUI:Show()

						ReadableUI_BookUI.FrontPage.BackgroundTexture:SetTexture(BookCoverTexture)
						ReadableUI_BookUI.Content.BackgroundTexture:SetTexture(BookContentTexture)

						if Type == "ParchmentLarge" then
							ReadableUI_BookUI.Content.Background.Spritesheet.Texture.texture:SetVertexColor(1, .91, .75)
						else
							ReadableUI_BookUI.Content.Background.Spritesheet.Texture.texture:SetVertexColor(1, 1, 1)
						end
					else
						ReadableUI_ItemUI:Show()
						ReadableUI_BookUI:Hide()

						ReadableUI_ItemUI.BackgroundTexture:SetTexture(ItemParchmentTexture)
					end
				end

				if Type == "Stone" or Type == "Bronze" then
					ReadableUI_ItemUI:Show()
					ReadableUI_BookUI:Hide()

					ReadableUI_ItemUI.BackgroundTexture:SetTexture(ItemStoneTexture)
				end
			end

			function Text()
				local CurrentPage = NS.ItemUI.Variables.CurrentPage
				local Title = NS.ItemUI.Variables.Title

				--------------------------------

				local function Text_Title()
					Frame.ReadableUIFrame.Title.Text:SetText(Title)
				end

				local function Text_View()
					if ReadableUI_ItemUI:IsVisible() then
						ReadableUI_ItemUI.Text:SetText(NS.ItemUI.Variables.Content[NS.ItemUI.Variables.CurrentPage])
					end

					if ReadableUI_BookUI:IsVisible() then
						local scale
						if NS.ItemUI.Variables.Type == "Parchment" or NS.ItemUI.Variables.Type == nil then
							scale = 1.125
						elseif NS.ItemUI.Variables.Type == "ParchmentLarge" then
							scale = 1.25
						end
						ReadableUI_BookUI:SetScale(scale)

						if CurrentPage <= 1 then
							ReadableUI_BookUI.FrontPage:Show()
							ReadableUI_BookUI.Content:Hide()

							ReadableUI_BookUI.FrontPage.Text:SetText(Title)
						else
							ReadableUI_BookUI.FrontPage:Hide()
							ReadableUI_BookUI.Content:Show()

							ReadableUI_BookUI.Content.Left.Text:SetText(NS.ItemUI.Variables.Content[tonumber(NS.ItemUI.Variables.CurrentPage) - 1] or "")
							ReadableUI_BookUI.Content.Right.Text:SetText(NS.ItemUI.Variables.Content[tonumber(NS.ItemUI.Variables.CurrentPage)] or "")

							if NS.ItemUI.Variables.Content[NS.ItemUI.Variables.CurrentPage - 1] ~= nil then
								ReadableUI_BookUI.Content.Left.Footer:SetText(NS.ItemUI.Variables.CurrentPage - 1)
							else
								ReadableUI_BookUI.Content.Left.Footer:SetText("")
							end

							if NS.ItemUI.Variables.Content[NS.ItemUI.Variables.CurrentPage] ~= nil then
								ReadableUI_BookUI.Content.Right.Footer:SetText(NS.ItemUI.Variables.CurrentPage)
							else
								ReadableUI_BookUI.Content.Right.Footer:SetText("")
							end
						end
					end
				end

				local function Text_CurrentPage()
					if ReadableUI_BookUI:IsVisible() then
						if ReadableUI_BookUI.Content:IsVisible() then
							Frame.ReadableUIFrame.Title.CurrentPageText:SetText(string.format("%.0f", math.floor(CurrentPage / 2 + .5)) .. "/" .. string.format("%.0f", math.floor(#NS.ItemUI.Variables.Content / 2 + .5)))
						else
							Frame.ReadableUIFrame.Title.CurrentPageText:SetText("0" .. "/" .. string.format("%.0f", math.floor(#NS.ItemUI.Variables.Content / 2 + .5)))
						end
					else
						Frame.ReadableUIFrame.Title.CurrentPageText:SetText(CurrentPage .. "/" .. #NS.ItemUI.Variables.Content)
					end
				end

				--------------------------------

				Text_Title()
				Text_View()
				Text_CurrentPage()
			end

			local function Text_Color()
				local TextColor

				if Type == "Parchment" or Type == "ParchmentLarge" or not Type then
					if addon.Theme.IsDarkTheme then
						TextColor = { r = 1, g = 1, b = 1, a = 1 }
					else
						TextColor = { r = .1, g = .1, b = .1, a = 1 }
					end
				end

				if Type == "Stone" or Type == "Bronze" then
					TextColor = { r = .75, g = .75, b = .75, a = 1 }
				end

				ReadableUI_ItemUI.Text:SetTextColor(TextColor.r, TextColor.g, TextColor.b, TextColor.a)
			end

			--------------------------------

			State()
			Text()
			Text_Color()

			--------------------------------

			CallbackRegistry:Trigger("READABLE_ITEMUI_UPDATE")
		end

		function NS.ItemUI.Script:NextPage()
			if NS.ItemUI.Variables.CurrentPage >= #NS.ItemUI.Variables.Content then
				return
			end

			-- Fix for issue causing NextPage to be called while the animation is still playing and not triggering the UpdatePage animation.
			if (ReadableUI_BookUI.Content:IsVisible() and ReadableUI_BookUI.Content.Left:GetAlpha() < .99 and ReadableUI_BookUI.Content.Right:GetAlpha() < .99) then
				return
			end

			if Frame.button_cooldown then
				return
			end
			Frame.ButtonCooldown()

			if ReadableUI_BookUI:IsVisible() then
				if ReadableUI_BookUI.FrontPage:IsVisible() then
					NS.ItemUI.Variables.CurrentPage = NS.ItemUI.Variables.CurrentPage + 1
				else
					NS.ItemUI.Variables.CurrentPage = NS.ItemUI.Variables.CurrentPage + 2
				end
			else
				NS.ItemUI.Variables.CurrentPage = NS.ItemUI.Variables.CurrentPage + 1
			end

			Frame.ReadableUIFrame.UpdatePageWithAnimation(NS.ItemUI.Variables.CurrentPage)
		end

		function NS.ItemUI.Script:PreviousPage()
			if NS.ItemUI.Variables.CurrentPage <= 1 then
				return
			end

			if Frame.button_cooldown then
				return
			end
			Frame.ButtonCooldown()

			if ReadableUI_BookUI:IsVisible() then
				NS.ItemUI.Variables.CurrentPage = math.max(1, NS.ItemUI.Variables.CurrentPage - 2)
			else
				NS.ItemUI.Variables.CurrentPage = math.max(1, NS.ItemUI.Variables.CurrentPage - 1)
			end

			Frame.ReadableUIFrame.UpdatePageWithAnimation(NS.ItemUI.Variables.CurrentPage, true)
		end
	end

	--------------------------------
	-- FUNCTIONS (TTS)
	--------------------------------

	do
		function NS.ItemUI.Script:StartTTS()
			addon.Audiobook.Script:Play(NS.ItemUI.Variables.Content[1])
		end
	end

	--------------------------------
	-- FUNCTIONS (ANIMATION)
	--------------------------------

	do
		ReadableUI.ShowWithAnimation = function()
			ReadableUI:Show()

			--------------------------------

			AdaptiveAPI.Animation:Fade(ReadableUI, .5, 0, 1, nil, function() return not Frame:IsVisible() or not Frame:GetAlpha() == 1 end)
			AdaptiveAPI.Animation:Move(ReadableUI_ItemUI, 1, "CENTER", -100, 0, "y", AdaptiveAPI.Animation.EaseExpo, function() return not Frame:IsVisible() or not Frame:GetAlpha() == 1 end)
			AdaptiveAPI.Animation:Move(ReadableUI_BookUI, 1, "CENTER", -100, 0, "y", AdaptiveAPI.Animation.EaseExpo, function() return not Frame:IsVisible() or not Frame:GetAlpha() == 1 end)

			AdaptiveAPI.Animation:Fade(ReadableUI.Title.Text, .5, 0, 1, nil, function() return not Frame:IsVisible() or not Frame:GetAlpha() == 1 end)
		end

		ReadableUI.HideWithAnimation = function()
			addon.Libraries.AceTimer:ScheduleTimer(function()
				ReadableUI:Hide()
			end, .5)

			--------------------------------

			AdaptiveAPI.Animation:Fade(ReadableUI, .5, ReadableUI:GetAlpha(), 0, nil, function() return not Frame:IsVisible() or not Frame:GetAlpha() == 1 end)
		end

		Frame.ReadableUIFrame.UpdatePageWithAnimation = function(CurrentPage, IsReverse)
			if Frame.hidden then
				return
			end
			Frame.pageUpdateTransition = true
			addon.Libraries.AceTimer:ScheduleTimer(function()
				if Frame.pageUpdateTransition then
					Frame.pageUpdateTransition = false
				end
			end, 2)

			--------------------------------

			if ReadableUI_ItemUI:IsVisible() then
				if NS.ItemUI.Variables.Type == "Stone" then
					addon.SoundEffects:PlaySoundFile(addon.SoundEffects.Readable_ItemUI_Slate_ChangePage)
				end

				--------------------------------

				AdaptiveAPI.Animation:Fade(ReadableUI_ItemUI, .25, ReadableUI_ItemUI:GetAlpha(), 0)

				--------------------------------

				if IsReverse then
					AdaptiveAPI.Animation:Move(ReadableUI_ItemUI, 1, "CENTER", 0, 100, "x", AdaptiveAPI.Animation.EaseExpo)
				else
					AdaptiveAPI.Animation:Move(ReadableUI_ItemUI, 1, "CENTER", 0, -100, "x", AdaptiveAPI.Animation.EaseExpo)
				end

				--------------------------------

				addon.Libraries.AceTimer:ScheduleTimer(function()
					NS.ItemUI.Script:Update()

					--------------------------------

					AdaptiveAPI.Animation:Fade(ReadableUI_ItemUI, .5, ReadableUI_ItemUI:GetAlpha(), 1)

					--------------------------------

					if IsReverse then
						AdaptiveAPI.Animation:Move(ReadableUI_ItemUI, 1, "CENTER", -100, 0, "x", AdaptiveAPI.Animation.EaseExpo)
					else
						AdaptiveAPI.Animation:Move(ReadableUI_ItemUI, 1, "CENTER", 100, 0, "x", AdaptiveAPI.Animation.EaseExpo)
					end
				end, .25)
			end

			--------------------------------

			if ReadableUI_BookUI:IsVisible() then
				if (ReadableUI_BookUI.FrontPage:IsVisible()) or ((NS.ItemUI.Variables.CurrentPage - 1) == 0) then
					if ReadableUI_BookUI.FrontPage:IsVisible() then
						addon.SoundEffects:PlaySoundFile(addon.SoundEffects.Readable_ItemUI_Book_Open)
					else
						addon.SoundEffects:PlaySoundFile(addon.SoundEffects.Readable_ItemUI_Book_Close)
					end

					--------------------------------

					local baseScale
					if NS.ItemUI.Variables.Type == "Parchment" or NS.ItemUI.Variables.Type == nil then
						baseScale = 1.125
					elseif NS.ItemUI.Variables.Type == "ParchmentLarge" then
						baseScale = 1.25
					end

					local targetPage
					local comparison
					if ReadableUI_BookUI.FrontPage:IsVisible() then
						targetPage = 2
						comparison = "<"
					elseif NS.ItemUI.Variables.CurrentPage - 1 == 0 then
						targetPage = 1
						comparison = ">"
					end

					--------------------------------

					AdaptiveAPI.Animation:Fade(ReadableUI_BookUI.FrontPage.Text, .125, ReadableUI_BookUI.FrontPage.Text:GetAlpha(), 0, nil, function() if comparison == ">" then return NS.ItemUI.Variables.CurrentPage > targetPage elseif comparison == "<" then return NS.ItemUI.Variables.CurrentPage < targetPage end end)
					AdaptiveAPI.Animation:Fade(ReadableUI_BookUI.Content.Left, .125, ReadableUI_BookUI.Content.Left:GetAlpha(), 0, nil, function() if comparison == ">" then return NS.ItemUI.Variables.CurrentPage > targetPage elseif comparison == "<" then return NS.ItemUI.Variables.CurrentPage < targetPage end end)
					AdaptiveAPI.Animation:Fade(ReadableUI_BookUI.Content.Right, .125, ReadableUI_BookUI.Content.Right:GetAlpha(), 0, nil, function() if comparison == ">" then return NS.ItemUI.Variables.CurrentPage > targetPage elseif comparison == "<" then return NS.ItemUI.Variables.CurrentPage < targetPage end end)
					AdaptiveAPI.Animation:Fade(ReadableUI_BookUI, .25, ReadableUI_BookUI:GetAlpha(), 0, nil, function() if comparison == ">" then return NS.ItemUI.Variables.CurrentPage > targetPage elseif comparison == "<" then return NS.ItemUI.Variables.CurrentPage < targetPage end end)

					addon.Libraries.AceTimer:ScheduleTimer(function()
						AdaptiveAPI.Animation:Scale(ReadableUI_BookUI, 1, ReadableUI_BookUI:GetScale(), baseScale + .15, nil, AdaptiveAPI.Animation.EaseExpo, function() if comparison == ">" then return NS.ItemUI.Variables.CurrentPage > targetPage elseif comparison == "<" then return NS.ItemUI.Variables.CurrentPage < targetPage end end)
					end, .125)

					--------------------------------

					addon.Libraries.AceTimer:ScheduleTimer(function()
						NS.ItemUI.Script:Update()

						--------------------------------

						addon.Libraries.AceTimer:ScheduleTimer(function()
							AdaptiveAPI.Animation:Fade(ReadableUI_BookUI.FrontPage.Text, .5, 0, 1, nil, function() if comparison == ">" then return NS.ItemUI.Variables.CurrentPage > targetPage elseif comparison == "<" then return NS.ItemUI.Variables.CurrentPage < targetPage end end)
							AdaptiveAPI.Animation:Fade(ReadableUI_BookUI.Content.Left, .5, 0, 1, nil, function() if comparison == ">" then return NS.ItemUI.Variables.CurrentPage > targetPage elseif comparison == "<" then return NS.ItemUI.Variables.CurrentPage < targetPage end end)
							AdaptiveAPI.Animation:Fade(ReadableUI_BookUI.Content.Right, .5, 0, 1, nil, function() if comparison == ">" then return NS.ItemUI.Variables.CurrentPage > targetPage elseif comparison == "<" then return NS.ItemUI.Variables.CurrentPage < targetPage end end)
						end, .5)

						--------------------------------

						AdaptiveAPI.Animation:Fade(ReadableUI_BookUI, .5, ReadableUI_BookUI:GetAlpha(), 1, nil, function() if comparison == ">" then return NS.ItemUI.Variables.CurrentPage > targetPage elseif comparison == "<" then return NS.ItemUI.Variables.CurrentPage < targetPage end end)
						AdaptiveAPI.Animation:Scale(ReadableUI_BookUI, 1, baseScale - .15, baseScale, nil, AdaptiveAPI.Animation.EaseExpo, function() if comparison == ">" then return NS.ItemUI.Variables.CurrentPage > targetPage elseif comparison == "<" then return NS.ItemUI.Variables.CurrentPage < targetPage end end)

						--------------------------------

						addon.Libraries.AceTimer:ScheduleTimer(function()
							NS.ItemUI.Script:Update()
						end, .5)
					end, .25)
				elseif (ReadableUI_BookUI.Content:IsVisible() and ReadableUI_BookUI.Content.Left:GetAlpha() > .99 and ReadableUI_BookUI.Content.Right:GetAlpha() > .99) then
					local function Text()
						if IsReverse then
							ReadableUI_BookUI.Content.Left:SetAlpha(0)
							ReadableUI_BookUI.Content.Right:SetAlpha(0)
						else
							ReadableUI_BookUI.Content.Left:SetAlpha(0)
							ReadableUI_BookUI.Content.Right:SetAlpha(0)
						end

						--------------------------------

						addon.Libraries.AceTimer:ScheduleTimer(function()
							ReadableUI_BookUI.Content.Left:SetAlpha(.01)
							ReadableUI_BookUI.Content.Right:SetAlpha(.01)

							--------------------------------

							AdaptiveAPI.Animation:Fade(ReadableUI_BookUI.Content.Left, .25, ReadableUI_BookUI.Content.Left:GetAlpha(), 1, nil, function() return ReadableUI_BookUI.Content.Left:GetAlpha() < .01 end)
							AdaptiveAPI.Animation:Fade(ReadableUI_BookUI.Content.Right, .25, ReadableUI_BookUI.Content.Right:GetAlpha(), 1, nil, function() return ReadableUI_BookUI.Content.Right:GetAlpha() < .01 end)
						end, .25)
					end

					local function Flip()
						AdaptiveAPI.Animation:Fade(ReadableUI_BookUI.Content.Background.Spritesheet, .125, 0, 1)

						--------------------------------

						if IsReverse then
							ReadableUI_BookUI.Content.Background.Spritesheet.Texture.Play(true)
							addon.SoundEffects:PlaySoundFile(addon.SoundEffects.Readable_ItemUI_Book_ReverseFlip)
						else
							ReadableUI_BookUI.Content.Background.Spritesheet.Texture.Play()
							addon.SoundEffects:PlaySoundFile(addon.SoundEffects.Readable_ItemUI_Book_Flip)
						end

						--------------------------------

						addon.Libraries.AceTimer:ScheduleTimer(function()
							AdaptiveAPI.Animation:Fade(ReadableUI_BookUI.Content.Background.Spritesheet, .125, ReadableUI_BookUI.Content.Background.Spritesheet:GetAlpha(), 0)
						end, .125)
					end

					--------------------------------

					Text()
					Flip()

					--------------------------------

					NS.ItemUI.Script:Update()
				end
			end
		end
	end

	--------------------------------
	-- SETTINGS
	--------------------------------

	do
		local function Settings_ContentSize()
			local ItemTextSize = INTDB.profile.INT_CONTENT_SIZE * 1
			local BookTextSize = INTDB.profile.INT_CONTENT_SIZE * .75

			AdaptiveAPI:SetFontSize(Frame.ReadableUIFrame.ItemFrame.Text, ItemTextSize)
			AdaptiveAPI:SetFontSize(Frame.ReadableUIFrame.BookFrame.Content.Left.MeasurementText, BookTextSize)
			AdaptiveAPI:SetFontSize(Frame.ReadableUIFrame.BookFrame.Content.Left.Text, BookTextSize)
			AdaptiveAPI:SetFontSize(Frame.ReadableUIFrame.BookFrame.Content.Right.MeasurementText, BookTextSize)
			AdaptiveAPI:SetFontSize(Frame.ReadableUIFrame.BookFrame.Content.Right.Text, BookTextSize)

			if ReadableUI_BookUI:IsVisible() then
				NS.ItemUI.Script:Update()
			end
		end
		addon.Libraries.AceTimer:ScheduleTimer(Settings_ContentSize, 1.25)

		--------------------------------

		CallbackRegistry:Add("SETTINGS_CONTENT_SIZE_CHANGED", Settings_ContentSize, 0)
	end

	--------------------------------
	-- EVENTS
	--------------------------------

	do
		-- UpdateFrame on ThemeUpdate
		addon.Libraries.AceTimer:ScheduleTimer(function()
			addon.API:RegisterThemeUpdate(function()
				if Frame:IsVisible() and NS.ItemUI.Variables.Title then
					NS.ItemUI.Script:Update()
				end
			end, 10)
		end, 1)
	end

	--------------------------------
	-- SETUP
	--------------------------------
end
