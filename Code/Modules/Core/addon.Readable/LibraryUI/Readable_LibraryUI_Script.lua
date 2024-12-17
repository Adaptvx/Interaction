local addonName, addon = ...
local CallbackRegistry = addon.CallbackRegistry
local L = addon.Locales
local NS = addon.Readable

--------------------------------

NS.LibraryUI.Script = {}

--------------------------------

function NS.LibraryUI.Script:Load()
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
		LibraryUI.Content.ContentFrame.Index.Content.Button_PreviousPage:SetScript("OnClick", function()
			LibraryCallback:PreviousPage()
		end)

		LibraryUI.Content.ContentFrame.Index.Content.Button_NextPage:SetScript("OnClick", function()
			LibraryCallback:NextPage()
		end)
	end

	--------------------------------
	-- FUNCTIONS (FRAME)
	--------------------------------

	do
		LibraryUI.Content.Sidebar.UpdateLayout = function()
			local CurrentOffset = 0
			local Padding = NS.Variables:RATIO(9)

			local Elements = LibraryUI.Content.Sidebar.Elements

			--------------------------------

			for _ = 1, #Elements do
				local CurrentElement = Elements[_]

				--------------------------------

				CurrentElement:ClearAllPoints()
				CurrentElement:SetPoint("TOP", LibraryUI.Content.Sidebar, 0, -CurrentOffset)

				--------------------------------

				CurrentOffset = CurrentOffset + CurrentElement:GetHeight() + Padding
			end
		end

		LibraryUI.Content.ContentFrame.ScrollFrame.RefreshLayout = function()
			local CurrentOffset = 0
			local Padding = NS.Variables:RATIO(9)

			local Elements = LibraryUI.Buttons

			for i = 1, #Elements do
				local CurrentElement = Elements[i]

				if CurrentElement:IsVisible() then
					CurrentElement:ClearAllPoints()
					CurrentElement:SetPoint("TOP", LibraryUI.Content.ContentFrame.ScrollChildFrame, 0, -CurrentOffset)

					CurrentOffset = CurrentOffset + CurrentElement:GetHeight() + Padding
				end
			end

			LibraryUI.Content.ContentFrame.ScrollChildFrame:SetHeight(CurrentOffset)
		end

		LibraryUI.Content.ContentFrame.ScrollFrame.RefreshButtonGradient = function()
			local Elements = LibraryUI.Buttons

			for i = 1, #Elements do
				Elements[i].UpdateGradientAlpha()
			end
		end

		LibraryUI.Content.ContentFrame.ScrollFrame.UpdateScrollIndicator = function()
			local Current = LibraryUI.Content.ContentFrame.ScrollFrame:GetVerticalScroll()
			local Min = 5
			local Max = LibraryUI.Content.ContentFrame.ScrollFrame:GetVerticalScrollRange() - 5

			--------------------------------

			local function Top()
				if Current > Min then
					if not LibraryUI.Content.ContentFrame.ScrollFrame.ScrollIndicator_Top.hidden then
						return
					end
					LibraryUI.Content.ContentFrame.ScrollFrame.ScrollIndicator_Top.hidden = false
					LibraryUI.Content.ContentFrame.ScrollFrame.ScrollIndicator_Top:Show()

					--------------------------------

					AdaptiveAPI.Animation:Fade(LibraryUI.Content.ContentFrame.ScrollFrame.ScrollIndicator_Top, .25, 0, 1, AdaptiveAPI.Animation.EaseQuad, function() return LibraryUI.Content.ContentFrame.ScrollFrame.ScrollIndicator_Top.hidden end)
				else
					if LibraryUI.Content.ContentFrame.ScrollFrame.ScrollIndicator_Top.hidden then
						return
					end
					LibraryUI.Content.ContentFrame.ScrollFrame.ScrollIndicator_Top.hidden = true
					addon.Libraries.AdaptiveTimer.Script:Schedule(function()
						if LibraryUI.Content.ContentFrame.ScrollFrame.ScrollIndicator_Top.hidden then
							LibraryUI.Content.ContentFrame.ScrollFrame.ScrollIndicator_Top:Hide()
						end
					end, .25)

					--------------------------------

					AdaptiveAPI.Animation:Fade(LibraryUI.Content.ContentFrame.ScrollFrame.ScrollIndicator_Top, .25, LibraryUI.Content.ContentFrame.ScrollFrame.ScrollIndicator_Top:GetAlpha(), 0, AdaptiveAPI.Animation.EaseQuad, function() return not LibraryUI.Content.ContentFrame.ScrollFrame.ScrollIndicator_Top.hidden end)
				end
			end

			local function Bottom()
				if Current < Max then
					if not LibraryUI.Content.ContentFrame.ScrollFrame.ScrollIndicator_Bottom.hidden then
						return
					end
					LibraryUI.Content.ContentFrame.ScrollFrame.ScrollIndicator_Bottom.hidden = false
					LibraryUI.Content.ContentFrame.ScrollFrame.ScrollIndicator_Bottom:Show()

					--------------------------------

					AdaptiveAPI.Animation:Fade(LibraryUI.Content.ContentFrame.ScrollFrame.ScrollIndicator_Bottom, .25, 0, 1, AdaptiveAPI.Animation.EaseQuad, function() return LibraryUI.Content.ContentFrame.ScrollFrame.ScrollIndicator_Bottom.hidden end)
				else
					if LibraryUI.Content.ContentFrame.ScrollFrame.ScrollIndicator_Bottom.hidden then
						return
					end
					LibraryUI.Content.ContentFrame.ScrollFrame.ScrollIndicator_Bottom.hidden = true
					addon.Libraries.AdaptiveTimer.Script:Schedule(function()
						if LibraryUI.Content.ContentFrame.ScrollFrame.ScrollIndicator_Bottom.hidden then
							LibraryUI.Content.ContentFrame.ScrollFrame.ScrollIndicator_Bottom:Hide()
						end
					end, .25)

					--------------------------------

					AdaptiveAPI.Animation:Fade(LibraryUI.Content.ContentFrame.ScrollFrame.ScrollIndicator_Bottom, .25, LibraryUI.Content.ContentFrame.ScrollFrame.ScrollIndicator_Bottom:GetAlpha(), 0, AdaptiveAPI.Animation.EaseQuad, function() return not LibraryUI.Content.ContentFrame.ScrollFrame.ScrollIndicator_Bottom.hidden end)
				end
			end

			--------------------------------

			Top()
			Bottom()
		end
	end

	--------------------------------
	-- FUNCTIONS (ANIMATION)
	--------------------------------

	do
		LibraryUI.ShowWithAnimation = function()
			LibraryUI:Show()

			--------------------------------

			AdaptiveAPI.Animation:Fade(LibraryUI, .5, 0, 1, nil, function() return not Frame:IsVisible() or not Frame:GetAlpha() == 1 end)
		end

		LibraryUI.HideWithAnimation = function()
			addon.Libraries.AdaptiveTimer.Script:Schedule(function()
				LibraryUI:Hide()
			end, .5)

			--------------------------------

			AdaptiveAPI.Animation:Fade(LibraryUI, .5, LibraryUI:GetAlpha(), 0, nil, function() return not Frame:IsVisible() or not Frame:GetAlpha() == 1 end)
		end
	end

	--------------------------------
	-- FUNCTIONS (MAIN)
	--------------------------------

	do
		do -- ENTRIES
			function LibraryCallback:GetButtons()
				if not Frame.LibraryUIFrame.Buttons then
					return
				end

				--------------------------------

				return Frame.LibraryUIFrame.Buttons
			end

			function LibraryCallback:GetAllEntries()
				local Results = {}

				--------------------------------

				for title in pairs(INTLIB.profile.READABLE) do
					local CurrentEntry = INTLIB.profile.READABLE[title]

					--------------------------------

					table.insert(Results, CurrentEntry)
				end

				--------------------------------

				return Results
			end

			function LibraryCallback:GetAllTypeEntries(type)
				local Results = {}
				local AllEntries = LibraryCallback:GetAllEntries()

				--------------------------------

				for i = 1, #AllEntries do
					local CurrentEntry = AllEntries[i]

					--------------------------------

					if type == "Letter" then
						if (CurrentEntry.Type == "Parchment" or CurrentEntry.Type == "ParchmentLarge" or not CurrentEntry.Type) and CurrentEntry.NumPages <= 1 then
							table.insert(Results, CurrentEntry)
						end
					elseif type == "Book" then
						if (CurrentEntry.Type == "Parchment" or CurrentEntry.Type == "ParchmentLarge" or not CurrentEntry.Type) and CurrentEntry.NumPages > 1 then
							table.insert(Results, CurrentEntry)
						end
					elseif type == "Stone" then
						if CurrentEntry.Type == "Stone" or CurrentEntry.Type == "Bronze" then
							table.insert(Results, CurrentEntry)
						end
					elseif type == "InWorld" then
						if not CurrentEntry.IsItemInInventory then
							table.insert(Results, CurrentEntry)
						end
					end
				end

				--------------------------------

				return Results
			end

			function LibraryCallback:GetAllFilteredEntries()
				local AllEntries = LibraryCallback:GetAllEntries()
				local Entries = AdaptiveAPI:SortListByAlphabeticalOrder(AllEntries, "Title", true)

				--------------------------------

				local SearchText = Frame.LibraryUIFrame.Content.Sidebar.Search:GetText()

				if SearchText ~= "" then
					Frame.LibraryUIFrame.Content.ContentFrame.ScrollFrame:SetVerticalScroll(0)

					-- TITLE
					Entries = AdaptiveAPI:FilterListByVariable(LibraryCallback:GetAllEntries(), "Title", SearchText, true, false)

					-- ZONE
					if #Entries == 0 then
						Entries = AdaptiveAPI:FilterListByVariable(LibraryCallback:GetAllEntries(), "Zone", SearchText, true, false)
					end

					-- NUM PAGES
					if #Entries == 0 then
						Entries = AdaptiveAPI:FilterListByVariable(LibraryCallback:GetAllEntries(), "NumPages", SearchText, true, false)
					end

					-- IS ADDED FROM BAGS
					if #Entries == 0 then
						local Text = SearchText

						if AdaptiveAPI:FindString("added from bags", string.lower(Text)) then
							Entries = AdaptiveAPI:FilterListByVariable(LibraryCallback:GetAllEntries(), "IsItemInInventory", SearchText, true, false)
						end
					end

					-- CONTENT
					if #Entries == 0 then
						Entries = AdaptiveAPI:FilterListByVariable(LibraryCallback:GetAllEntries(), nil, nil, nil, nil, function(item)
							if AdaptiveAPI:FindString(string.lower(item.Content[1]), string.lower(SearchText)) then
								return true
							end

							return false
						end)
					end

					Entries = AdaptiveAPI:SortListByAlphabeticalOrder(Entries, "Title")
				end

				--------------------------------

				local Type_Letter = Frame.LibraryUIFrame.Content.Sidebar.Type_Letter.Checked
				local Type_Book = Frame.LibraryUIFrame.Content.Sidebar.Type_Book.Checked
				local Type_Slate = Frame.LibraryUIFrame.Content.Sidebar.Type_Slate.Checked
				local Type_InWorld = Frame.LibraryUIFrame.Content.Sidebar.Type_InWorld.Checked

				local TypeList = AdaptiveAPI:FilterListByVariable(Entries, nil, nil, nil, nil, function(item)
					local Result

					local Type = item.Type
					local NumPages = item.NumPages
					local IsItemInInventory = item.IsItemInInventory

					local IsLetter = ((Type == "Parchment" or Type == "ParchmentLarge" or not Type) and NumPages == 1)
					local IsBook = ((Type == "Parchment" or Type == "ParchmentLarge" or not Type) and NumPages > 1)
					local IsSlate = (Type == "Stone" or Type == "Bronze")
					local IsWorld = (not IsItemInInventory)

					if Type_InWorld then
						if ((Type_Letter and IsLetter) or (Type_Book and IsBook) or (Type_Slate and IsSlate)) and IsWorld then
							Result = true
						else
							Result = false
						end
					else
						if (Type_Letter and IsLetter) or (Type_Book and IsBook) or (Type_Slate and IsSlate) then
							Result = true
						else
							Result = false
						end
					end

					return Result
				end)

				--------------------------------

				Entries = TypeList

				--------------------------------

				return Entries
			end
		end

		do -- PAGES
			function LibraryCallback:GetAllEntriesForCurrentPage()
				local Results = {}
				local CurrentPage = NS.LibraryUI.Variables.CurrentPage

				--------------------------------

				local StartIndex = (CurrentPage - 1) * NS.LibraryUI.Variables.MAX_ENTRIES_PER_PAGE
				local EndIndex = StartIndex + NS.LibraryUI.Variables.MAX_ENTRIES_PER_PAGE
				local CurrentIndex = 0

				for title in pairs(INTLIB.profile.READABLE) do
					CurrentIndex = CurrentIndex + 1

					--------------------------------

					if CurrentIndex >= StartIndex and CurrentIndex <= EndIndex then
						local CurrentEntry = INTLIB.profile.READABLE[title]

						--------------------------------

						table.insert(Results, CurrentEntry)
					end
				end

				--------------------------------

				return Results
			end

			function LibraryCallback:GetAllFilteredEntriesForCurrentPage()
				local Results = {}
				local CurrentPage = NS.LibraryUI.Variables.CurrentPage
				local Entries = LibraryCallback:GetAllFilteredEntries()

				--------------------------------

				local StartIndex = (CurrentPage - 1) * NS.LibraryUI.Variables.MAX_ENTRIES_PER_PAGE
				local EndIndex = StartIndex + NS.LibraryUI.Variables.MAX_ENTRIES_PER_PAGE
				local CurrentIndex = 0

				for title in pairs(Entries) do
					CurrentIndex = CurrentIndex + 1

					--------------------------------

					if CurrentIndex >= StartIndex and CurrentIndex <= EndIndex then
						local CurrentEntry = Entries[title]

						--------------------------------

						table.insert(Results, CurrentEntry)
					end
				end

				--------------------------------

				return Results
			end

			function LibraryCallback:GetMinMaxPages()
				local CurrentPage = NS.LibraryUI.Variables.CurrentPage
				local Min = 1
				local Max = math.ceil(#LibraryCallback:GetAllFilteredEntries() / NS.LibraryUI.Variables.MAX_ENTRIES_PER_PAGE)

				--------------------------------

				return CurrentPage, Min, Max
			end

			function LibraryCallback:GetCurrentPage()
				return NS.LibraryUI.Variables.CurrentPage
			end

			function LibraryCallback:NextPage()
				local CurrentPage, Min, Max = LibraryCallback:GetMinMaxPages()

				--------------------------------

				if CurrentPage < Max then
					NS.LibraryUI.Variables.CurrentPage = NS.LibraryUI.Variables.CurrentPage + 1
				end

				--------------------------------

				LibraryCallback:UpdatePageCounter()
				LibraryCallback:SetPageButtons(true)
			end

			function LibraryCallback:PreviousPage()
				local CurrentPage, Min, Max = LibraryCallback:GetMinMaxPages()

				--------------------------------

				if CurrentPage > Min then
					NS.LibraryUI.Variables.CurrentPage = NS.LibraryUI.Variables.CurrentPage - 1
				end

				--------------------------------

				LibraryCallback:UpdatePageCounter()
				LibraryCallback:SetPageButtons(true)
			end

			function LibraryCallback:UpdatePageCounter()
				local CurrentPage, Min, Max = LibraryCallback:GetMinMaxPages()

				--------------------------------

				if CurrentPage > Max then
					CurrentPage = Max
					NS.LibraryUI.Variables.CurrentPage = Max
					LibraryCallback:SetPageButtons(true)
				end

				if CurrentPage < 1 and Max >= 1 then
					CurrentPage = 1
					NS.LibraryUI.Variables.CurrentPage = 1
					LibraryCallback:SetPageButtons(true)
				end

				--------------------------------

				if Max > 1 then
					LibraryUI.Content.ContentFrame.Index:Show()

					--------------------------------

					LibraryUI.Content.ContentFrame.Index.Content.Text:SetText(CurrentPage .. "/" .. Max)

					--------------------------------

					LibraryUI.Content.ContentFrame.Index.Content.Button_PreviousPage:SetEnabled(CurrentPage > Min)
					LibraryUI.Content.ContentFrame.Index.Content.Button_NextPage:SetEnabled(CurrentPage < Max)
				else
					LibraryUI.Content.ContentFrame.Index:Hide()
				end

				LibraryUI.Content.ContentFrame.ScrollFrame.UpdateSize()
			end

			function LibraryCallback:SetPageButtons(playAnimation)
				NS.LibraryUI.Variables.SelectedIndex = nil
				CallbackRegistry:Trigger("LIBRARY_MENU_DATA_LOADED")

				--------------------------------

				local AllEntries = LibraryCallback:GetAllEntries()
				local Entries = LibraryCallback:GetAllFilteredEntriesForCurrentPage()
				local Buttons = LibraryCallback:GetButtons()

				local SearchText = Frame.LibraryUIFrame.Content.Sidebar.Search:GetText()

				--------------------------------

				Frame.LibraryUIFrame.Content.Title.Main.Subtext:SetText(L["Readable - Showing Status Text - Subtext 1"] .. #Entries .. "/" .. #AllEntries .. L["Readable - Showing Status Text - Subtext 2"])

				--------------------------------

				for i = 1, #Buttons do
					Buttons[i]:Hide()
				end

				for i = 1, #Entries do
					if i > #Buttons then
						break
					end

					--------------------------------

					local CurrentEntry = Entries[i]

					--------------------------------

					Buttons[i]:Show()
					Buttons[i].ID = CurrentEntry.Content[1]

					--------------------------------

					if playAnimation or playAnimation == nil then
						AdaptiveAPI.Animation:Fade(Buttons[i], .25, 0, 1, nil, function() return not Buttons[i]:IsVisible() end)
					else
						Buttons[i]:SetAlpha(1)
					end

					--------------------------------

					local Type = CurrentEntry.Type
					local NumPages = CurrentEntry.NumPages
					local Title = CurrentEntry.Title
					local Content = CurrentEntry.Content

					local IsItemInInventory = CurrentEntry.IsItemInInventory

					local Zone = CurrentEntry.Zone
					local MapID = CurrentEntry.MapID
					local Position = CurrentEntry.Position
					local Time = CurrentEntry.Time

					--------------------------------

					local ImageTexture

					local ItemParchmentTexture; if addon.Theme.IsDarkTheme then
						ItemParchmentTexture = NS.Variables.READABLE_UI_PATH .. "Parchment/parchment-dark-mode.png"
					else
						ItemParchmentTexture = NS.Variables.READABLE_UI_PATH .. "Parchment/parchment-light-mode.png"
					end
					local ItemStoneTexture = NS.Variables.READABLE_UI_PATH .. "Slate/Slate.png"
					local ItemBookTexture = NS.Variables.READABLE_UI_PATH .. "Book/book-cover.png"
					local ItemBookLargeTexture = NS.Variables.READABLE_UI_PATH .. "Book/book-cover-large.png"

					if Type == "Parchment" or Type == "ParchmentLarge" or not Type then
						if NumPages > 1 then
							if Type == "ParchmentLarge" then
								ImageTexture = ItemBookLargeTexture
							else
								ImageTexture = ItemBookTexture
							end
						else
							ImageTexture = ItemParchmentTexture
						end
					end

					if Type == "Stone" or Type == "Bronze" then
						ImageTexture = ItemStoneTexture
					end

					--------------------------------

					local TitleText = Title
					local DetailText = Zone
					local TooltipText = Content[1]
					if #TooltipText > 100 then
						TooltipText = string.sub(TooltipText, 1, 100) .. "..."
					end
					if AdaptiveAPI:FindString(TooltipText, "<HTML>") then
						TooltipText = nil
					end

					if not IsItemInInventory then
						if Position then
							DetailText = DetailText .. " " .. AdaptiveAPI:InlineIcon(NS.Variables.READABLE_UI_PATH .. "Library/divider-content-text.png", 2, 25, 0, -7.5) .. " " .. "X: " .. string.format("%.0f", (Position.x * 100)) .. " " .. "Y: " .. string.format("%.0f", (Position.y * 100))
						end
					else
						DetailText = DetailText .. " " .. AdaptiveAPI:InlineIcon(NS.Variables.READABLE_UI_PATH .. "Library/divider-content-text.png", 2, 25, 0, -7.5) .. " " .. "Added from Bags"
					end

					--------------------------------

					Buttons[i].Title:SetText(TitleText)
					Buttons[i].Detail:SetText(DetailText)

					Buttons[i].ImageTexture:SetTexture(ImageTexture)

					--------------------------------

					if TooltipText then
						AdaptiveAPI:AddTooltip(Buttons[i], TooltipText, "ANCHOR_TOP", 0, 17.5, true)
					else
						AdaptiveAPI:RemoveTooltip(Buttons[i])
					end
				end

				--------------------------------

				local IsEmpty = (#Entries == 0)
				local IsSearch = (SearchText ~= "")

				if IsEmpty then
					Frame.LibraryUIFrame.Content.ContentFrame.ScrollFrame.Label:Show()

					--------------------------------

					if IsSearch then
						Frame.LibraryUIFrame.Content.ContentFrame.ScrollFrame.Label:SetText(L["Readable - No Results Text - Subtext 1"] .. "\"" .. SearchText .. "\"" .. L["Readable - No Results Text - Subtext 2"])
					else
						Frame.LibraryUIFrame.Content.ContentFrame.ScrollFrame.Label:SetText(L["Readable - Empty Library Text"])
					end
				else
					Frame.LibraryUIFrame.Content.ContentFrame.ScrollFrame.Label:Hide()
				end

				--------------------------------

				local Filters = {
					{
						frame = Frame.LibraryUIFrame.Content.Sidebar.Type_Letter,
						detail = function() return #LibraryCallback:GetAllTypeEntries("Letter") end
					},
					{
						frame = Frame.LibraryUIFrame.Content.Sidebar.Type_Book,
						detail = function() return #LibraryCallback:GetAllTypeEntries("Book") end
					},
					{
						frame = Frame.LibraryUIFrame.Content.Sidebar.Type_Slate,
						detail = function() return #LibraryCallback:GetAllTypeEntries("Stone") end
					},
					{
						frame = Frame.LibraryUIFrame.Content.Sidebar.Type_InWorld,
						detail = function() return #LibraryCallback:GetAllTypeEntries("InWorld") end
					},
				}

				for i = 1, #Filters do
					local Frame = Filters[i].frame

					--------------------------------

					Frame.Detail:SetText(tostring(Filters[i].detail()))
				end

				--------------------------------

				LibraryCallback:UpdatePageCounter()

				--------------------------------

				Frame.LibraryUIFrame.Content.ContentFrame.ScrollFrame:SetVerticalScroll(0)
			end
		end

		do -- DATA
			function LibraryCallback:SaveToLibrary()
				local ID = NS.ItemUI.Variables.Content[1]

				local Type = NS.ItemUI.Variables.Type
				local NumPages = NS.ItemUI.Variables.NumPages
				local Title = NS.ItemUI.Variables.Title
				local Content = NS.ItemUI.Variables.Content

				local IsItemInInventory = NS.ItemUI.Variables.IsItemInInventory
				local ItemID = NS.ItemUI.Variables.ItemID
				local ItemLink = NS.ItemUI.Variables.ItemLink

				local Zone = GetZoneText()
				local MapID = C_Map.GetBestMapForUnit("player")
				local Position = C_Map.GetPlayerMapPosition(MapID, "player")
				local Time = time()

				local Entry = {
					Type = Type,
					NumPages = NumPages,
					Title = Title,
					Content = Content,
					IsItemInInventory = IsItemInInventory,
					ItemID = ItemID,
					ItemLink = ItemLink,
					Zone = Zone,
					MapID = MapID,
					Position = Position,
					Time = Time
				}

				if not INTLIB.profile.READABLE[ID] then
					addon.Libraries.AdaptiveTimer.Script:Schedule(function()
						InteractionAlertNotificationFrame.ShowWithText(L["Readable - Notification - Saved To Library"])
					end, .1)
				end

				INTLIB.profile.READABLE[ID] = Entry
			end

			function LibraryCallback:DeleteFromLibrary(ID)
				local Entry = AdaptiveAPI:FindIndexInTable(INTLIB.profile.READABLE, ID)

				if Entry then
					InteractionPromptFrame.Set(L["Readable - Prompt - Delete"], L["Readable - Prompt - Delete Button 1"], L["Readable - Prompt - Delete Button 2"],
						function()
							INTLIB.profile.READABLE[ID] = nil
							LibraryCallback:SetPageButtons(true)

							InteractionPromptFrame.Clear()
						end, function()
							InteractionPromptFrame.Clear()
						end
						, true, false)
				end
			end

			function LibraryCallback:OpenFromLibrary(ID)
				local Index = INTLIB.profile.READABLE[ID]

				local Type = Index.Type
				local NumPages = Index.NumPages
				local Title = Index.Title
				local Content = Index.Content

				NS.ItemUI.Variables.Type = Type
				NS.ItemUI.Variables.NumPages = NumPages
				NS.ItemUI.Variables.Title = Title
				NS.ItemUI.Variables.Content = Content
				NS.ItemUI.Variables.CurrentPage = 1

				--------------------------------

				Frame.TransitionToType("ReadableUI")

				--------------------------------

				addon.Libraries.AdaptiveTimer.Script:Schedule(function()
					NS.ItemUI.Script:Update()

					--------------------------------

					addon.Libraries.AdaptiveTimer.Script:Schedule(function()
						NS.ItemUI.Script:Update()
					end, .1)
				end, .525)
			end

			function LibraryCallback:Export()
				local library = INTLIB.profile.READABLE

				local serialized = addon.Libraries.LibSerialize:SerializeEx(
					{ errorOnUnserializableType = false },
					library, { a = 1, b = library })
				local compressed = addon.Libraries.LibDeflate:CompressDeflate(serialized)
				local encoded = addon.Libraries.LibDeflate:EncodeForPrint(compressed)

				addon.PromptTextShowTextFrame(L["Readable - TextPrompt - Export"] .. AdaptiveAPI:InlineIcon(addon.Variables.PATH .. "Art/Platform/Platform-PC-Copy.png", 25, 100, 0, 0), true, L["Readable - TextPrompt - Export Input Placeholder"], encoded, "Done", function() return true end, true)
			end

			function LibraryCallback:Import(string)
				local decoded = addon.Libraries.LibDeflate:DecodeForPrint(string)
				local decompressed = addon.Libraries.LibDeflate:DecompressDeflate(decoded)
				local success, values = addon.Libraries.LibSerialize:Deserialize(decompressed)

				return success, values
			end

			function LibraryCallback:ImportPrompt()
				addon.PromptTextShowTextFrame(L["Readable - TextPrompt - Import"], true, L["Readable - TextPrompt - Import Input Placeholder"], "", L["Readable - TextPrompt - Import Button 1"], function(_, val)
					local success, values = LibraryCallback:Import(val)

					if val ~= "" and success then
						InteractionPromptFrame.Set(L["Readable - Prompt - Import"], L["Readable - Prompt - Import Button 1"], L["Readable - Prompt - Import Button 2"], function()
								INTLIB.profile.READABLE = values

								ReloadUI()
							end,
							function()
								InteractionPromptFrame.Clear()
							end
							, true, false)

						return true
					else
						return false
					end
				end, true)
			end
		end

		do -- BUTTONS
			function LibraryCallback:UpdateButtons()
				local Entries = LibraryCallback:GetAllEntries()
				local Buttons = LibraryCallback:GetButtons()

				for i = 1, #Buttons do
					if Buttons then
						if i > #Buttons then
							break
						end

						--------------------------------

						Buttons[i].Update()
					end
				end
			end
		end
	end

	--------------------------------
	-- EVENTS
	--------------------------------

	do
		CallbackRegistry:Add("START_LIBRARY", function()
			LibraryCallback:SetPageButtons()
		end, 0)

		-- SetButtons on ThemeUpdate
		addon.Libraries.AdaptiveTimer.Script:Schedule(function()
			addon.API:RegisterThemeUpdate(function()
				if Frame.LibraryUIFrame:IsVisible() then
					LibraryCallback:SetPageButtons()
				end
			end, 10)
		end, 1)
	end

	--------------------------------
	-- SETUP
	--------------------------------

	do
		LibraryUI.Content.Sidebar.UpdateLayout()
	end
end
