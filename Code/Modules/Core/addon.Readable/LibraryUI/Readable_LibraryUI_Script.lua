---@class addon
local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local PrefabRegistry = addon.PrefabRegistry
local L = addon.Locales
local NS = addon.Readable; addon.Readable = NS

--------------------------------

NS.LibraryUI.Script = {}

--------------------------------

function NS.LibraryUI.Script:Load()
	--------------------------------
	-- REFERENCES
	--------------------------------

	NS.Variables.LIBRARY_LOCAL = addon.Database.DB_LOCAL_PERSISTENT.profile.READABLE
	NS.Variables.LIBRARY_GLOBAL = addon.Database.DB_GLOBAL_PERSISTENT.profile.READABLE

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
		function LibraryUI.Content.Sidebar:UpdateLayout()
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

		function LibraryUI.Content.Sidebar:ResetToDefaults()
			Frame.LibraryUIFrame.Content.Sidebar.Search:SetText("")
			Frame.LibraryUIFrame.Content.Sidebar.Search:SetFocus(false)

			Frame.LibraryUIFrame.Content.Sidebar.Type_Letter.Checkbox:SetChecked(true)
			Frame.LibraryUIFrame.Content.Sidebar.Type_Book.Checkbox:SetChecked(true)
			Frame.LibraryUIFrame.Content.Sidebar.Type_Slate.Checkbox:SetChecked(true)
			Frame.LibraryUIFrame.Content.Sidebar.Type_InWorld.Checkbox:SetChecked(false)
		end

		function LibraryUI.Content.ContentFrame.ScrollFrame:RefreshLayout()
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

		function LibraryUI.Content.ContentFrame.ScrollFrame:RefreshButtonGradient()
			local Elements = LibraryUI.Buttons

			for i = 1, #Elements do
				Elements[i]:UpdateGradientAlpha()
			end
		end

		function LibraryUI.Content.ContentFrame.ScrollFrame:UpdateScrollIndicator()
			local Current = LibraryUI.Content.ContentFrame.ScrollFrame:GetVerticalScroll()
			local Min = 5
			local Max = LibraryUI.Content.ContentFrame.ScrollFrame:GetVerticalScrollRange() - 5

			--------------------------------

			do -- TOP
				if Current > Min then
					if LibraryUI.Content.ContentFrame.ScrollFrame.ScrollIndicator_Top.hidden then
						LibraryUI.Content.ContentFrame.ScrollFrame.ScrollIndicator_Top.hidden = false
						LibraryUI.Content.ContentFrame.ScrollFrame.ScrollIndicator_Top:Show()

						--------------------------------

						addon.API.Animation:Fade(LibraryUI.Content.ContentFrame.ScrollFrame.ScrollIndicator_Top, .25, 0, 1, addon.API.Animation.EaseQuad, function() return LibraryUI.Content.ContentFrame.ScrollFrame.ScrollIndicator_Top.hidden end)
					end
				else
					if not LibraryUI.Content.ContentFrame.ScrollFrame.ScrollIndicator_Top.hidden then
						LibraryUI.Content.ContentFrame.ScrollFrame.ScrollIndicator_Top.hidden = true
						addon.Libraries.AceTimer:ScheduleTimer(function()
							if LibraryUI.Content.ContentFrame.ScrollFrame.ScrollIndicator_Top.hidden then
								LibraryUI.Content.ContentFrame.ScrollFrame.ScrollIndicator_Top:Hide()
							end
						end, .25)

						--------------------------------

						addon.API.Animation:Fade(LibraryUI.Content.ContentFrame.ScrollFrame.ScrollIndicator_Top, .25, LibraryUI.Content.ContentFrame.ScrollFrame.ScrollIndicator_Top:GetAlpha(), 0, addon.API.Animation.EaseQuad, function() return not LibraryUI.Content.ContentFrame.ScrollFrame.ScrollIndicator_Top.hidden end)
					end
				end
			end

			do -- BOTTOM
				if Current < Max then
					if LibraryUI.Content.ContentFrame.ScrollFrame.ScrollIndicator_Bottom.hidden then
						LibraryUI.Content.ContentFrame.ScrollFrame.ScrollIndicator_Bottom.hidden = false
						LibraryUI.Content.ContentFrame.ScrollFrame.ScrollIndicator_Bottom:Show()

						--------------------------------

						addon.API.Animation:Fade(LibraryUI.Content.ContentFrame.ScrollFrame.ScrollIndicator_Bottom, .25, 0, 1, addon.API.Animation.EaseQuad, function() return LibraryUI.Content.ContentFrame.ScrollFrame.ScrollIndicator_Bottom.hidden end)
					end
				else
					if not LibraryUI.Content.ContentFrame.ScrollFrame.ScrollIndicator_Bottom.hidden then
						LibraryUI.Content.ContentFrame.ScrollFrame.ScrollIndicator_Bottom.hidden = true
						addon.Libraries.AceTimer:ScheduleTimer(function()
							if LibraryUI.Content.ContentFrame.ScrollFrame.ScrollIndicator_Bottom.hidden then
								LibraryUI.Content.ContentFrame.ScrollFrame.ScrollIndicator_Bottom:Hide()
							end
						end, .25)

						--------------------------------

						addon.API.Animation:Fade(LibraryUI.Content.ContentFrame.ScrollFrame.ScrollIndicator_Bottom, .25, LibraryUI.Content.ContentFrame.ScrollFrame.ScrollIndicator_Bottom:GetAlpha(), 0, addon.API.Animation.EaseQuad, function() return not LibraryUI.Content.ContentFrame.ScrollFrame.ScrollIndicator_Bottom.hidden end)
					end
				end
			end
		end
	end

	--------------------------------
	-- FUNCTIONS (ANIMATION)
	--------------------------------

	do
		do -- SHOW
			function LibraryUI:ShowWithAnimation_StopEvent()
				return not Frame:IsVisible() or not Frame:GetAlpha() == 1
			end

			function LibraryUI:ShowWithAnimation()
				LibraryUI:Show()

				--------------------------------

				addon.API.Animation:Fade(LibraryUI, .5, 0, 1, nil, LibraryUI.ShowWithAnimation_StopEvent)
			end
		end

		do -- HIDE
			function LibraryUI:HideWithAnimation_StopEvent()
				return not Frame:IsVisible() or not Frame:GetAlpha() == 1
			end

			function LibraryUI:HideWithAnimation()
				addon.Libraries.AceTimer:ScheduleTimer(function()
					LibraryUI:Hide()
				end, .5)

				--------------------------------

				addon.API.Animation:Fade(LibraryUI, .5, LibraryUI:GetAlpha(), 0, nil, LibraryUI.HideWithAnimation_StopEvent)
			end
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

				for title in pairs(NS.LibraryUI.Variables.LibraryDB) do
					local CurrentEntry = NS.LibraryUI.Variables.LibraryDB[title]

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
						if (CurrentEntry.Type == "Parchment" or CurrentEntry.Type == "ParchmentLarge" or CurrentEntry.Type == "Valentine" or not CurrentEntry.Type) and CurrentEntry.NumPages <= 1 then
							table.insert(Results, CurrentEntry)
						end
					elseif type == "Book" then
						if (CurrentEntry.Type == "Parchment" or CurrentEntry.Type == "ParchmentLarge" or CurrentEntry.Type == "Valentine" or not CurrentEntry.Type) and CurrentEntry.NumPages > 1 then
							table.insert(Results, CurrentEntry)
						end
					elseif type == "Stone" then
						if CurrentEntry.Type == "Stone" or CurrentEntry.Type == "Bronze" or CurrentEntry.Type == "Silver" or CurrentEntry.Type == "Marble" or CurrentEntry.Type == "Progenitor" then
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
				local Group_Letters = LibraryCallback:GetAllTypeEntries("Letter")
				local Alphabetical_Letters = addon.API.Util:SortListByAlphabeticalOrder(Group_Letters, { "Title" })
				local Group_Books = LibraryCallback:GetAllTypeEntries("Book")
				local Alphabetical_Books = addon.API.Util:SortListByAlphabeticalOrder(Group_Books, { "Title" })
				local Group_Slates = LibraryCallback:GetAllTypeEntries("Stone")
				local Alphabetical_Slates = addon.API.Util:SortListByAlphabeticalOrder(Group_Slates, { "Title" })

				local Group_Combined = {}

				local CurrentIndex = 0
				for i = 1, #Alphabetical_Letters do
					CurrentIndex = CurrentIndex + 1
					Group_Combined[CurrentIndex] = Alphabetical_Letters[i]
				end
				for i = 1, #Alphabetical_Books do
					CurrentIndex = CurrentIndex + 1
					Group_Combined[CurrentIndex] = Alphabetical_Books[i]
				end
				for i = 1, #Alphabetical_Slates do
					CurrentIndex = CurrentIndex + 1
					Group_Combined[CurrentIndex] = Alphabetical_Slates[i]
				end

				local Entries = Group_Combined

				--------------------------------

				local SearchText = Frame.LibraryUIFrame.Content.Sidebar.Search:GetText()

				if SearchText ~= "" then
					Frame.LibraryUIFrame.Content.ContentFrame.ScrollFrame:SetVerticalScroll(0)

					-- TITLE
					Entries = addon.API.Util:FilterListByVariable(LibraryCallback:GetAllEntries(), { "Title" }, SearchText, true, false)

					-- ZONE
					if #Entries == 0 then
						Entries = addon.API.Util:FilterListByVariable(LibraryCallback:GetAllEntries(), { "Zone" }, SearchText, true, false)
					end

					-- NUM PAGES
					if #Entries == 0 then
						Entries = addon.API.Util:FilterListByVariable(LibraryCallback:GetAllEntries(), { "NumPages" }, SearchText, true, false)
					end

					-- IS ADDED FROM BAGS
					if #Entries == 0 then
						local Text = SearchText

						if addon.API.Util:FindString("added from bags", string.lower(Text)) then
							Entries = addon.API.Util:FilterListByVariable(LibraryCallback:GetAllEntries(), { "IsItemInInventory" }, SearchText, true, false)
						end
					end

					-- CONTENT
					if #Entries == 0 then
						Entries = addon.API.Util:FilterListByVariable(LibraryCallback:GetAllEntries(), nil, nil, nil, nil, function(item)
							if addon.API.Util:FindString(string.lower(item.Content[1]), string.lower(SearchText)) then
								return true
							end

							return false
						end)
					end

					Entries = addon.API.Util:SortListByAlphabeticalOrder(Entries, { "Title" })
				end

				--------------------------------

				local Type_Letter = Frame.LibraryUIFrame.Content.Sidebar.Type_Letter.Checkbox.checked
				local Type_Book = Frame.LibraryUIFrame.Content.Sidebar.Type_Book.Checkbox.checked
				local Type_Slate = Frame.LibraryUIFrame.Content.Sidebar.Type_Slate.Checkbox.checked
				local Type_InWorld = Frame.LibraryUIFrame.Content.Sidebar.Type_InWorld.Checkbox.checked

				local TypeList = addon.API.Util:FilterListByVariable(Entries, nil, nil, nil, nil, function(item)
					local Result

					local Type = item.Type
					local NumPages = item.NumPages
					local IsItemInInventory = item.IsItemInInventory

					local IsLetter = ((Type == "Parchment" or Type == "ParchmentLarge" or Type == "Valentine" or not Type) and NumPages == 1)
					local IsBook = ((Type == "Parchment" or Type == "ParchmentLarge" or Type == "Valentine" or not Type) and NumPages > 1)
					local IsSlate = (Type == "Stone" or Type == "Bronze"  or Type == "Silver" or Type == "Marble" or Type == "Progenitor")
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

				for title in pairs(NS.LibraryUI.Variables.LibraryDB) do
					CurrentIndex = CurrentIndex + 1

					--------------------------------

					if CurrentIndex >= StartIndex and CurrentIndex <= EndIndex then
						local CurrentEntry = NS.LibraryUI.Variables.LibraryDB[title]

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

					if CurrentIndex > StartIndex and CurrentIndex <= EndIndex then
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

			function LibraryCallback:SetCurrentPage(page)
				NS.LibraryUI.Variables.CurrentPage = page

				--------------------------------

				LibraryCallback:UpdatePageCounter()
				LibraryCallback:SetPageButtons(true)
			end

			function LibraryCallback:NextPage()
				local CurrentPage, Min, Max = LibraryCallback:GetMinMaxPages()

				--------------------------------

				if CurrentPage < Max then
					LibraryCallback:SetCurrentPage(CurrentPage + 1)
				end
			end

			function LibraryCallback:PreviousPage()
				local CurrentPage, Min, Max = LibraryCallback:GetMinMaxPages()

				--------------------------------

				if CurrentPage > Min then
					LibraryCallback:SetCurrentPage(CurrentPage - 1)
				end
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

				LibraryUI.Content.ContentFrame.ScrollFrame:UpdateSize()
			end

			function LibraryCallback:SetPageButtons(playAnimation, userInput)
				NS.LibraryUI.Variables.SelectedIndex = nil
				CallbackRegistry:Trigger("LIBRARY_MENU_DATA_LOADED")

				--------------------------------

				local AllEntries = LibraryCallback:GetAllEntries()
				local Entries = LibraryCallback:GetAllFilteredEntriesForCurrentPage()
				local Buttons = LibraryCallback:GetButtons()

				local searchText = Frame.LibraryUIFrame.Content.Sidebar.Search:GetText()

				--------------------------------

				do -- TITLE
					do -- TITLE TEXT
						local isLocal = (NS.LibraryUI.Variables.LibraryDB == NS.Variables.LIBRARY_LOCAL)
						local playerName = UnitName("player")

						if isLocal then
							Frame.LibraryUIFrame.Content.Title.Main.Text:SetText(L["Readable - Library - Name Text - Local - Subtext 1"] .. playerName .. L["Readable - Library - Name Text - Local - Subtext 2"])
						else
							Frame.LibraryUIFrame.Content.Title.Main.Text:SetText(L["Readable - Library - Name Text - Global"])
						end
					end

					do -- SHOWING STATUS TEXT
						Frame.LibraryUIFrame.Content.Title.Main.Subtext:SetText(L["Readable - Library - Showing Status Text - Subtext 1"] .. #Entries .. "/" .. #AllEntries .. L["Readable - Library - Showing Status Text - Subtext 2"])
					end
				end

				do -- BUTTONS
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
						Buttons[i].id = CurrentEntry.Content[1]

						--------------------------------

						if playAnimation or playAnimation == nil then
							addon.API.Animation:Fade(Buttons[i], .125 + (.075 * i), 0, .75, nil, function() return not Buttons[i]:IsVisible() end)
						else
							Buttons[i]:SetAlpha(.75)
						end

						--------------------------------

						local Type = CurrentEntry.Type
						local NumPages = CurrentEntry.NumPages
						local Title = CurrentEntry.Title
						local Content = CurrentEntry.Content

						local IsItemInInventory = CurrentEntry.IsItemInInventory
						local ItemID = CurrentEntry.ItemID
						local ItemLink = CurrentEntry.ItemLink

						local Zone = CurrentEntry.Zone
						local MapID = CurrentEntry.MapID
						local Position = CurrentEntry.Position
						local Time = CurrentEntry.Time

						--------------------------------

						local ImageTexture
						local ImageTexCoords = { 0, 1, 0, 1 }

						local ItemParchmentTexture; if addon.Theme.IsDarkTheme then
							ItemParchmentTexture = NS.Variables.READABLE_UI_PATH .. "Library/element-button-image-parchment-dark.png"
						else
							ItemParchmentTexture = NS.Variables.READABLE_UI_PATH .. "Library/element-button-image-parchment-light.png"
						end
						local ItemStoneTexture = NS.Variables.READABLE_UI_PATH .. "Library/element-button-image-slate.png"
						local ItemBookTexture = NS.Variables.READABLE_UI_PATH .. "Library/element-button-image-book.png"
						local ItemBookLargeTexture = NS.Variables.READABLE_UI_PATH .. "Library/element-button-image-book-large.png"

						if Type == "Parchment" or Type == "ParchmentLarge" or Type == "Valentine" or not Type then
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

						if Type == "Stone" or Type == "Bronze" or Type == "Silver" or Type == "Marble" or Type == "Progenitor" then
							ImageTexture = ItemStoneTexture
						end

						if ItemLink then
							local ItemIcon = C_Item.GetItemIconByID(ItemLink)

							--------------------------------

							if ItemIcon then
								ImageTexture = ItemIcon
								ImageTexCoords = { 0, 1, 0, 1 }
							end
						end

						--------------------------------

						local TitleText = Title
						local DetailText = Zone
						local TooltipText = Content[1]
						if #TooltipText > 100 then
							TooltipText = string.sub(TooltipText, 1, 100) .. "..."
						end
						if addon.API.Util:FindString(TooltipText, "<HTML>") then
							TooltipText = nil
						end

						if not IsItemInInventory then
							if Position then
								DetailText = DetailText .. " " .. "(" .. "X: " .. string.format("%.0f", (Position.x * 100)) .. " " .. "Y: " .. string.format("%.0f", (Position.y * 100)) .. ")"
							end
						else
							DetailText = DetailText .. " " .. "(" .. "Added from Bags" .. ")"
						end

						--------------------------------

						Buttons[i].Content.Text.Title:SetText(TitleText)
						Buttons[i].Content.Text.Detail:SetText(DetailText)

						Buttons[i].Content.ImageTexture:SetTexture(ImageTexture)
						Buttons[i].Content.ImageTexture:SetTexCoord(unpack(ImageTexCoords))

						--------------------------------

						if TooltipText then
							addon.API.Util:AddTooltip(Buttons[i], TooltipText, "ANCHOR_TOP", 0, 17.5)
						else
							addon.API.Util:RemoveTooltip(Buttons[i])
						end
					end
				end

				do -- ERROR
					local isEmpty = (#Entries == 0)
					local isSearch = (searchText ~= "")

					if isEmpty then
						Frame.LibraryUIFrame.Content.ContentFrame.ScrollFrame.Label:Show()

						--------------------------------

						if isSearch then
							Frame.LibraryUIFrame.Content.ContentFrame.ScrollFrame.Label:SetText(L["Readable - Library - No Results Text - Subtext 1"] .. "\"" .. searchText .. "\"" .. L["Readable - Library - No Results Text - Subtext 2"])
						else
							Frame.LibraryUIFrame.Content.ContentFrame.ScrollFrame.Label:SetText(L["Readable - Library - Empty Library Text"])
						end
					else
						Frame.LibraryUIFrame.Content.ContentFrame.ScrollFrame.Label:Hide()
					end
				end

				do -- SIDEBAR
					do -- CHECKBOX FILTER DETAIL
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
					end
				end

				--------------------------------

				if userInput then
					LibraryCallback:SetCurrentPage(1)
				else
					LibraryCallback:UpdatePageCounter()
				end

				--------------------------------

				Frame.LibraryUIFrame.Content.ContentFrame.ScrollFrame:SetVerticalScroll(0)
			end
		end

		do -- DATA
			function LibraryCallback:SetLibraryDestination(destination)
				NS.LibraryUI.Variables.LibraryDB = destination

				--------------------------------

				if LibraryUI:IsVisible() then
					LibraryCallback:SetPageButtons(true, true)
				end
			end

			function LibraryCallback:SaveToLibrary()
				local id = NS.ItemUI.Variables.Content[1]

				--------------------------------

				local type = NS.ItemUI.Variables.Type
				local numPages = NS.ItemUI.Variables.NumPages
				local title = NS.ItemUI.Variables.Title
				local content = NS.ItemUI.Variables.Content

				local isItemInInventory = NS.ItemUI.Variables.IsItemInInventory
				local itemID = NS.ItemUI.Variables.ItemID
				local itemLink = NS.ItemUI.Variables.ItemLink

				local zone = GetZoneText()
				local mapID = C_Map.GetBestMapForUnit("player")
				local position = C_Map.GetPlayerMapPosition(mapID, "player")
				local time = time()

				--------------------------------

				local entry = {
					Type = type,
					NumPages = numPages,
					Title = title,
					Content = content,
					IsItemInInventory = isItemInInventory,
					ItemID = itemID,
					ItemLink = itemLink,
					Zone = zone,
					MapID = mapID,
					Position = position,
					Time = time
				}

				if not NS.LibraryUI.Variables.LibraryDB[id] then
					addon.Libraries.AceTimer:ScheduleTimer(function()
						LibraryCallback:AddCharacterToGlobal()

						--------------------------------

						addon.AlertNotification.Script:ShowWithText(L["Readable - Notification - Saved To Library"])
					end, .1)
				end

				NS.LibraryUI.Variables.LibraryDB[id] = entry
			end

			function LibraryCallback:DeleteFromLibrary(ID)
				local selectedEntry = addon.API.Util:FindKeyPositionInTable(NS.LibraryUI.Variables.LibraryDB, ID)

				--------------------------------

				local isLocal = (NS.LibraryUI.Variables.LibraryDB == NS.Variables.LIBRARY_LOCAL)

				--------------------------------

				if selectedEntry then
					addon.Prompt.Script:Set(isLocal and L["Readable - Library - Prompt - Delete - Local"] or L["Readable - Library - Prompt - Delete - Global"], L["Readable - Library - Prompt - Delete Button 1"], L["Readable - Library - Prompt - Delete Button 2"],
						function()
							NS.LibraryUI.Variables.LibraryDB[ID] = nil
							LibraryCallback:SetPageButtons(true)

							addon.Prompt.Script:Clear()
						end, function()
							addon.Prompt.Script:Clear()
						end
						, true, false)
				end
			end

			function LibraryCallback:OpenFromLibrary(ID)
				local Index = NS.LibraryUI.Variables.LibraryDB[ID]

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

				Frame:TransitionToType("READABLE")

				--------------------------------

				addon.Libraries.AceTimer:ScheduleTimer(function()
					NS.ItemUI.Script:Update()

					--------------------------------

					addon.Libraries.AceTimer:ScheduleTimer(function()
						NS.ItemUI.Script:Update()
					end, .1)
				end, .525)
			end

			function LibraryCallback:Export()
				local library = NS.LibraryUI.Variables.LibraryDB

				--------------------------------

				local isLocal = (NS.LibraryUI.Variables.LibraryDB == NS.Variables.LIBRARY_LOCAL)
				local isMacClient = IsMacClient()
				local copyIcon = isMacClient and addon.Variables.PATH_ART .. "Platform/Platform-PC-Copy-Mac.png" or addon.Variables.PATH_ART .. "Platform/Platform-PC-Copy-Windows.png"

				local serialized = addon.Libraries.LibSerialize:SerializeEx({ errorOnUnserializableType = false }, library, { a = 1, b = library })
				local compressed = addon.Libraries.LibDeflate:CompressDeflate(serialized)
				local encoded = addon.Libraries.LibDeflate:EncodeForPrint(compressed)

				--------------------------------

				if isLocal then
					addon.PromptText.Script:ShowTextFrame(L["Readable - Library - TextPrompt - Export - Local"] .. " " .. addon.API.Util:InlineIcon(copyIcon, 17.5, 17.5 * (239 / 64), 0, 0), true, L["Readable - Library - TextPrompt - Export Input Placeholder"], encoded, "Done", function() return true end, true)
				else
					addon.PromptText.Script:ShowTextFrame(L["Readable - Library - TextPrompt - Export - Global"] .. " " .. addon.API.Util:InlineIcon(copyIcon, 17.5, 17.5 * (239 / 64), 0, 0), true, L["Readable - Library - TextPrompt - Export Input Placeholder"], encoded, "Done", function() return true end, true)
				end
			end

			function LibraryCallback:Import(string)
				local decoded = addon.Libraries.LibDeflate:DecodeForPrint(string)
				local decompressed = addon.Libraries.LibDeflate:DecompressDeflate(decoded)
				local success, values = addon.Libraries.LibSerialize:Deserialize(decompressed)

				return success, values
			end

			function LibraryCallback:ImportPrompt()
				local isLocal = (NS.LibraryUI.Variables.LibraryDB == NS.Variables.LIBRARY_LOCAL)

				--------------------------------

				addon.PromptText.Script:ShowTextFrame(isLocal and L["Readable - Library - TextPrompt - Import - Local"] or L["Readable - Library - TextPrompt - Import - Global"], true, L["Readable - Library - TextPrompt - Import Input Placeholder"], "", L["Readable - Library - TextPrompt - Import Button 1"], function(_, val)
					local success, values = LibraryCallback:Import(val)

					if val ~= "" and success then
						addon.Prompt.Script:Set(isLocal and L["Readable - Library - Prompt - Import - Local"] or L["Readable - Library - Prompt - Import - Global"], L["Readable - Library - Prompt - Import Button 1"], L["Readable - Library - Prompt - Import Button 2"], function()
								if isLocal then
									addon.Database.DB_LOCAL_PERSISTENT.profile.READABLE = values
								else
									addon.Database.DB_GLOBAL_PERSISTENT.profile.READABLE = values
								end

								ReloadUI()
							end,
							function()
								addon.Prompt.Script:Clear()
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
				local Buttons = LibraryCallback:GetButtons()

				for i = 1, #Buttons do
					if Buttons then
						if i > #Buttons then
							break
						end

						--------------------------------

						Buttons[i]:Update()
					end
				end
			end
		end

		do -- GLOBAL LIBRARY
			function LibraryCallback:SetToLocal()
				LibraryCallback:SetLibraryDestination(NS.Variables.LIBRARY_LOCAL)
			end

			function LibraryCallback:SetToGlobal()
				LibraryCallback:SetLibraryDestination(NS.Variables.LIBRARY_GLOBAL)
			end

			function LibraryCallback:AddCharacterToGlobal()
				local LocalDB = NS.Variables.LIBRARY_LOCAL
				local GlobalDB = NS.Variables.LIBRARY_GLOBAL

				local missingEntries = {}

				--------------------------------

				do -- GET
					for name, data in pairs(LocalDB) do
						if not GlobalDB[name] then
							missingEntries[name] = data
						end
					end
				end

				do -- SET
					for name, data in pairs(missingEntries) do
						GlobalDB[name] = data
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
			LibraryUI.Content.Sidebar:ResetToDefaults()

			--------------------------------

			LibraryCallback:SetPageButtons()
		end, 0)

		-- SetButtons on ThemeUpdate
		addon.Libraries.AceTimer:ScheduleTimer(function()
			addon.API.Main:RegisterThemeUpdate(function()
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
		LibraryCallback:SetToLocal()
		LibraryCallback:AddCharacterToGlobal()

		--------------------------------

		LibraryUI.Content.Sidebar:UpdateLayout()
	end
end
