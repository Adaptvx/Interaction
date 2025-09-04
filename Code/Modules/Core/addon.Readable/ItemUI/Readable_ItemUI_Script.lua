---@class addon
local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local PrefabRegistry = addon.PrefabRegistry
local L = addon.Locales
local NS = addon.Readable; addon.Readable = NS

--------------------------------

NS.ItemUI.Script = {}

--------------------------------

function NS.ItemUI.Script:Load()
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
	-- FUNCTIONS (BUTTONS)
	--------------------------------

	do
		function Frame:ButtonCooldown()
			Frame.button_cooldown = true

			addon.Libraries.AceTimer:ScheduleTimer(function()
				Frame.button_cooldown = false
			end, .5)
		end

		function Frame:Back()
			if NS.ItemUI.Variables.CurrentPage <= 1 then
				Frame:TransitionToType("LIBRARY")
			else
				NS.ItemUI.Script:PreviousPage()
			end
		end

		function Frame:Next()
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
			local type = NS.ItemUI.Variables.Type

			--------------------------------

			local item_parchmentTexture = addon.Theme.IsDarkTheme and NS.Variables.READABLE_UI_PATH .. "Parchment/parchment-dark.png" or NS.Variables.READABLE_UI_PATH .. "Parchment/parchment-light.png"
			local item_parchmentLargeTexture = item_parchmentTexture
			local item_parchmentGradientTexture = addon.Theme.IsDarkTheme and NS.Variables.READABLE_UI_PATH .. "Parchment/parchment-content-gradient-dark.png" or NS.Variables.READABLE_UI_PATH .. "Parchment/parchment-content-gradient-light.png"

			local item_stoneTexture = NS.Variables.READABLE_UI_PATH .. "Slate/Slate.png"
			local item_stoneGradientTexture = NS.Variables.READABLE_UI_PATH .. "Slate/slate-content-gradient.png"

			local book_coverTexture
			local book_contentTexture
			if type == "Parchment" or type == nil then
				book_coverTexture = NS.Variables.READABLE_UI_PATH .. "Book/book-cover.png"
				book_contentTexture = NS.Variables.READABLE_UI_PATH .. "Book/book.png"
			else
				book_coverTexture = NS.Variables.READABLE_UI_PATH .. "Book/book-cover-large.png"
				book_contentTexture = NS.Variables.READABLE_UI_PATH .. "Book/book-large.png"
			end

			--------------------------------

			do -- STATE
				if type == "Parchment" or type == "ParchmentLarge" or type == "Valentine" or not type then
					if NS.ItemUI.Variables.NumPages > 1 then
						ReadableUI_ItemUI:Hide()
						ReadableUI_BookUI:Show()

						ReadableUI_BookUI.FrontPage.BackgroundTexture:SetTexture(book_coverTexture)
						ReadableUI_BookUI.Content.BackgroundTexture:SetTexture(book_contentTexture)

						if type == "ParchmentLarge" then
							ReadableUI_BookUI.Content.Background.Spritesheet.Texture.texture:SetVertexColor(1, .91, .75)
						else
							ReadableUI_BookUI.Content.Background.Spritesheet.Texture.texture:SetVertexColor(1, 1, 1)
						end
					else
						ReadableUI_ItemUI:Show()
						ReadableUI_BookUI:Hide()

						ReadableUI_ItemUI.BackgroundTexture:SetTexture(item_parchmentTexture)
						ReadableUI_ItemUI.ScrollFrame.GradientTexture:SetTexture(item_parchmentGradientTexture)
					end
				end

				if type == "Stone" or type == "Bronze" or type == "Silver" or type == "Marble" or type == "Progenitor" then
					ReadableUI_ItemUI:Show()
					ReadableUI_BookUI:Hide()

					ReadableUI_ItemUI.BackgroundTexture:SetTexture(item_stoneTexture)
					ReadableUI_ItemUI.ScrollFrame.GradientTexture:SetTexture(item_stoneGradientTexture)
				end
			end

			do -- TEXT
				local currentPage = NS.ItemUI.Variables.CurrentPage
				local title = NS.ItemUI.Variables.Title

				--------------------------------

				do -- TITLE
					Frame.ReadableUIFrame.Title.Text:SetText(title)
				end

				do -- TITLE (CURRENT PAGE)
					if ReadableUI_BookUI:IsVisible() then
						if ReadableUI_BookUI.Content:IsVisible() then
							Frame.ReadableUIFrame.Title.CurrentPageText:SetText(string.format("%.0f", math.floor(currentPage / 2 + .5)) .. "/" .. string.format("%.0f", math.floor(#NS.ItemUI.Variables.Content / 2 + .5)))
						else
							Frame.ReadableUIFrame.Title.CurrentPageText:SetText("0" .. "/" .. string.format("%.0f", math.floor(#NS.ItemUI.Variables.Content / 2 + .5)))
						end
					else
						Frame.ReadableUIFrame.Title.CurrentPageText:SetText(currentPage .. "/" .. #NS.ItemUI.Variables.Content)
					end
				end

				do -- CONTENT
					if ReadableUI_ItemUI:IsVisible() then
						ReadableUI_ItemUI.ScrollFrame.Text:SetText(NS.ItemUI.Variables.Content[NS.ItemUI.Variables.CurrentPage])
					end

					if ReadableUI_BookUI:IsVisible() then
						local scale
						if NS.ItemUI.Variables.Type == "Parchment" or NS.ItemUI.Variables.Type == nil then
							scale = 1.125
						elseif NS.ItemUI.Variables.Type == "ParchmentLarge" then
							scale = 1.25
						end
						ReadableUI_BookUI:SetScale(scale)

						if currentPage <= 1 then
							ReadableUI_BookUI.FrontPage:Show()
							ReadableUI_BookUI.Content:Hide()

							ReadableUI_BookUI.FrontPage.Text.Title:SetText(title)
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
			end

			do -- TEXT COLOR
				local textColor

				if type == "Parchment" or type == "ParchmentLarge" or type == "Valentine" or not type then
					if addon.Theme.IsDarkTheme then
						textColor = { r = 1, g = 1, b = 1, a = 1 }
					else
						textColor = { r = .1, g = .1, b = .1, a = 1 }
					end
				end

				if type == "Stone" or type == "Bronze" or type == "Silver" or type == "Marble" or type == "Progenitor" then
					textColor = { r = .75, g = .75, b = .75, a = 1 }
				end

				ReadableUI_ItemUI.ScrollFrame.Text:SetTextColor(textColor.r, textColor.g, textColor.b, textColor.a)
			end

			do -- TOOLTIP
				local tooltipText = L["Readable - Tooltip - Change Page"]

				if NS.ItemUI.Variables.NumPages > 1 then
					addon.API.Util:AddTooltip(Frame.ReadableUIFrame.TooltipFrame, tooltipText, "ANCHOR_BOTTOM", 0, 50, true)
				else
					addon.API.Util:RemoveTooltip(Frame.ReadableUIFrame.TooltipFrame)
				end
			end

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
			Frame:ButtonCooldown()

			if ReadableUI_BookUI:IsVisible() then
				if ReadableUI_BookUI.FrontPage:IsVisible() then
					NS.ItemUI.Variables.CurrentPage = NS.ItemUI.Variables.CurrentPage + 1
				else
					NS.ItemUI.Variables.CurrentPage = NS.ItemUI.Variables.CurrentPage + 2
				end
			else
				NS.ItemUI.Variables.CurrentPage = NS.ItemUI.Variables.CurrentPage + 1
			end

			Frame.ReadableUIFrame:UpdatePageWithAnimation()
		end

		function NS.ItemUI.Script:PreviousPage()
			if NS.ItemUI.Variables.CurrentPage <= 1 then
				return
			end

			if Frame.button_cooldown then
				return
			end
			Frame:ButtonCooldown()

			if ReadableUI_BookUI:IsVisible() then
				NS.ItemUI.Variables.CurrentPage = math.max(1, NS.ItemUI.Variables.CurrentPage - 2)
			else
				NS.ItemUI.Variables.CurrentPage = math.max(1, NS.ItemUI.Variables.CurrentPage - 1)
			end

			Frame.ReadableUIFrame:UpdatePageWithAnimation(true)
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
		do -- SHOW
			function ReadableUI:ShowWithAnimation_StopEvent()
				return not Frame:IsVisible()
			end

			function ReadableUI:ShowWithAnimation()
				ReadableUI:Show()

				--------------------------------

				ReadableUI_ItemUI:SetAlpha(1)
				ReadableUI_ItemUI.ScrollFrame:SetAlpha(0)
				ReadableUI_BookUI:SetAlpha(1)
				ReadableUI_BookUI.FrontPage.Text:SetAlpha(1)
				ReadableUI_BookUI.Content.Left:SetAlpha(1)
				ReadableUI_BookUI.Content.Right:SetAlpha(1)

				addon.API.Animation:Fade(ReadableUI, .5, 0, 1, nil, ReadableUI.ShowWithAnimation_StopEvent)
				addon.API.Animation:Fade(ReadableUI.Title.Text, .5, 0, 1, nil, ReadableUI.ShowWithAnimation_StopEvent)

				addon.API.Animation:Move(ReadableUI_ItemUI, 1, "CENTER", -100, 0, "y", addon.API.Animation.EaseExpo, ReadableUI.ShowWithAnimation_StopEvent)
				addon.API.Animation:Move(ReadableUI_BookUI, 1, "CENTER", -100, 0, "y", addon.API.Animation.EaseExpo, ReadableUI.ShowWithAnimation_StopEvent)

				addon.Libraries.AceTimer:ScheduleTimer(function()
					addon.API.Animation:Fade(ReadableUI_ItemUI.ScrollFrame, .5, 0, 1, nil, ReadableUI.ShowWithAnimation_StopEvent)
				end, .25)
			end
		end

		do -- HIDE
			function ReadableUI:HideWithAnimation_StopEvent()
				return not Frame:IsVisible() or not Frame:GetAlpha() == 1
			end

			function ReadableUI:HideWithAnimation()
				addon.Libraries.AceTimer:ScheduleTimer(function()
					ReadableUI:Hide()
				end, .5)

				--------------------------------

				addon.API.Util:RemoveTooltip(Frame.ReadableUIFrame.TooltipFrame)

				--------------------------------

				addon.API.Animation:Fade(ReadableUI, .5, ReadableUI:GetAlpha(), 0, nil, ReadableUI.HideWithAnimation_StopEvent)
				addon.API.Animation:Fade(ReadableUI_ItemUI.ScrollFrame, .125, ReadableUI_ItemUI.ScrollFrame:GetAlpha(), 0, nil, ReadableUI.HideWithAnimation_StopEvent)
			end
		end

		do -- PAGE
			function ReadableUI:UpdatePageWithAnimation(isReverse)
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

				do -- ITEM
					if ReadableUI_ItemUI:IsVisible() then
						if NS.ItemUI.Variables.Type == "Stone" then
							addon.SoundEffects:PlaySoundFile(addon.SoundEffects.Readable_ItemUI_Slate_ChangePage)
						end

						--------------------------------

						ReadableUI_ItemUI:EnableMouse(false)

						--------------------------------

						addon.API.Animation:Fade(ReadableUI_ItemUI, .25, ReadableUI_ItemUI:GetAlpha(), 0)

						--------------------------------

						if isReverse then
							addon.API.Animation:Move(ReadableUI_ItemUI, 1, "CENTER", 0, 100, "x", addon.API.Animation.EaseExpo)
						else
							addon.API.Animation:Move(ReadableUI_ItemUI, 1, "CENTER", 0, -100, "x", addon.API.Animation.EaseExpo)
						end

						--------------------------------

						addon.Libraries.AceTimer:ScheduleTimer(function()
							NS.ItemUI.Script:Update()

							--------------------------------

							addon.API.Animation:Fade(ReadableUI_ItemUI, .5, ReadableUI_ItemUI:GetAlpha(), 1)

							--------------------------------

							if isReverse then
								addon.API.Animation:Move(ReadableUI_ItemUI, 1, "CENTER", -100, 0, "x", addon.API.Animation.EaseExpo)
							else
								addon.API.Animation:Move(ReadableUI_ItemUI, 1, "CENTER", 100, 0, "x", addon.API.Animation.EaseExpo)
							end
						end, .25)

						addon.Libraries.AceTimer:ScheduleTimer(function()
							ReadableUI_ItemUI:EnableMouse(true)
						end, 1.25)
					end
				end

				do -- BOOK
					if ReadableUI_BookUI:IsVisible() then
						if (ReadableUI_BookUI.FrontPage:IsVisible()) or ((NS.ItemUI.Variables.CurrentPage - 1) == 0) then
							if ReadableUI_BookUI.FrontPage:IsVisible() then
								addon.SoundEffects:PlaySoundFile(addon.SoundEffects.Readable_ItemUI_Book_Open)
							else
								addon.SoundEffects:PlaySoundFile(addon.SoundEffects.Readable_ItemUI_Book_Close)
							end

							--------------------------------

							local baseScale
							if NS.ItemUI.Variables.Type == "Parchment" or NS.ItemUI.Variables.Type == "Valentine" or NS.ItemUI.Variables.Type == nil then
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

							local function StopEvent()
								if comparison == ">" then
									return NS.ItemUI.Variables.CurrentPage > targetPage
								elseif comparison == "<" then
									return NS.ItemUI.Variables.CurrentPage < targetPage
								end
							end

							--------------------------------

							addon.API.Animation:Fade(ReadableUI_BookUI.FrontPage.Text, .125, ReadableUI_BookUI.FrontPage.Text:GetAlpha(), 0, nil, StopEvent)
							addon.API.Animation:Fade(ReadableUI_BookUI.Content.Left, .125, ReadableUI_BookUI.Content.Left:GetAlpha(), 0, nil, StopEvent)
							addon.API.Animation:Fade(ReadableUI_BookUI.Content.Right, .125, ReadableUI_BookUI.Content.Right:GetAlpha(), 0, nil, StopEvent)
							addon.API.Animation:Fade(ReadableUI_BookUI, .25, ReadableUI_BookUI:GetAlpha(), 0, nil, StopEvent)

							addon.Libraries.AceTimer:ScheduleTimer(function()
								addon.API.Animation:Scale(ReadableUI_BookUI, 1, ReadableUI_BookUI:GetScale(), baseScale + .15, nil, addon.API.Animation.EaseExpo, StopEvent)
							end, .125)

							--------------------------------

							addon.Libraries.AceTimer:ScheduleTimer(function()
								NS.ItemUI.Script:Update()

								--------------------------------

								addon.Libraries.AceTimer:ScheduleTimer(function()
									addon.API.Animation:Fade(ReadableUI_BookUI.FrontPage.Text, .5, 0, 1, nil, StopEvent)
									addon.API.Animation:Fade(ReadableUI_BookUI.Content.Left, .5, 0, 1, nil, StopEvent)
									addon.API.Animation:Fade(ReadableUI_BookUI.Content.Right, .5, 0, 1, nil, StopEvent)
								end, .5)

								--------------------------------

								addon.API.Animation:Fade(ReadableUI_BookUI, .5, ReadableUI_BookUI:GetAlpha(), 1, nil, StopEvent)
								addon.API.Animation:Scale(ReadableUI_BookUI, 1, baseScale - .15, baseScale, nil, addon.API.Animation.EaseExpo, StopEvent)

								--------------------------------

								addon.Libraries.AceTimer:ScheduleTimer(function()
									NS.ItemUI.Script:Update()
								end, .5)
							end, .25)
						elseif (ReadableUI_BookUI.Content:IsVisible() and ReadableUI_BookUI.Content.Left:GetAlpha() > .99 and ReadableUI_BookUI.Content.Right:GetAlpha() > .99) then
							do -- TEXT
								if isReverse then
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

									addon.API.Animation:Fade(ReadableUI_BookUI.Content.Left, .25, ReadableUI_BookUI.Content.Left:GetAlpha(), 1, nil, function() return ReadableUI_BookUI.Content.Left:GetAlpha() < .01 end)
									addon.API.Animation:Fade(ReadableUI_BookUI.Content.Right, .25, ReadableUI_BookUI.Content.Right:GetAlpha(), 1, nil, function() return ReadableUI_BookUI.Content.Right:GetAlpha() < .01 end)
								end, .25)
							end

							do -- FLIP
								addon.API.Animation:Fade(ReadableUI_BookUI.Content.Background.Spritesheet, .125, 0, 1)

								--------------------------------

								if isReverse then
									ReadableUI_BookUI.Content.Background.Spritesheet.Texture.Play(true)
									addon.SoundEffects:PlaySoundFile(addon.SoundEffects.Readable_ItemUI_Book_ReverseFlip)
								else
									ReadableUI_BookUI.Content.Background.Spritesheet.Texture.Play()
									addon.SoundEffects:PlaySoundFile(addon.SoundEffects.Readable_ItemUI_Book_Flip)
								end

								--------------------------------

								addon.Libraries.AceTimer:ScheduleTimer(function()
									addon.API.Animation:Fade(ReadableUI_BookUI.Content.Background.Spritesheet, .125, ReadableUI_BookUI.Content.Background.Spritesheet:GetAlpha(), 0)
								end, .125)
							end

							--------------------------------

							NS.ItemUI.Script:Update()
						end
					end
				end
			end
		end
	end

	--------------------------------
	-- SETTINGS
	--------------------------------

	do
		local function Settings_ContentSize()
			local item_textSize = addon.Database.DB_GLOBAL.profile.INT_CONTENT_SIZE * 1
			local book_textSize = addon.Database.DB_GLOBAL.profile.INT_CONTENT_SIZE * .75

			--------------------------------

			addon.API.Util:SetFontSize(Frame.ReadableUIFrame.ItemFrame.ScrollFrame.MeasurementText, item_textSize)
			addon.API.Util:SetFontSize(Frame.ReadableUIFrame.ItemFrame.ScrollFrame.Text, item_textSize)
			addon.API.Util:SetFontSize(Frame.ReadableUIFrame.BookFrame.Content.Left.MeasurementText, book_textSize)
			addon.API.Util:SetFontSize(Frame.ReadableUIFrame.BookFrame.Content.Left.Text, book_textSize)
			addon.API.Util:SetFontSize(Frame.ReadableUIFrame.BookFrame.Content.Right.MeasurementText, book_textSize)
			addon.API.Util:SetFontSize(Frame.ReadableUIFrame.BookFrame.Content.Right.Text, book_textSize)

			--------------------------------

			if ReadableUI_ItemUI:IsVisible() or ReadableUI_BookUI:IsVisible() then
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
			addon.API.Main:RegisterThemeUpdate(function()
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
