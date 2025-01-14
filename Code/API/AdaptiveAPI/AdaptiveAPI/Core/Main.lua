local addonName, addon = ...

--------------------------------
-- VARIABLES
--------------------------------

AdaptiveAPI.NativeAPI = addon.API
AdaptiveAPI.NativeCallback = addon
AdaptiveAPI.NativeTheme = addon.Theme

do -- MAIN
	AdaptiveAPI.IsDarkTheme = nil
end

do -- CONSTANTS
	AdaptiveAPI.PATH = "Interface/AddOns/Interaction/Code/API/AdaptiveAPI/Art/"
	AdaptiveAPI.ADDON_PATH = "Interface/AddOns/Interaction/"
	AdaptiveAPI.RGB_RECOMMENDED = {}
	AdaptiveAPI.RGB_WHITE = { r = .99, g = .99, b = .99 }
	AdaptiveAPI.RGB_BLACK = { r = .2, g = .2, b = .2 }
end

--------------------------------
-- FUNCTIONS (VARIABLES)
--------------------------------

do
	local function ThemeUpdate()
		AdaptiveAPI.IsDarkTheme = AdaptiveAPI.NativeAPI:GetDarkTheme()

		--------------------------------

		if AdaptiveAPI.IsDarkTheme then
			AdaptiveAPI.RGB_RECOMMENDED = AdaptiveAPI.RGB_WHITE
		else
			AdaptiveAPI.RGB_RECOMMENDED = AdaptiveAPI.RGB_BLACK
		end
	end

	ThemeUpdate()

	addon.Libraries.AceTimer:ScheduleTimer(function()
		AdaptiveAPI:RegisterThemeUpdateWithNativeAPI(ThemeUpdate, -1)
	end, .1)
end

--------------------------------
-- STRING
--------------------------------

do
	do -- STRING
		-- Returns if the given string is found in the string.
		---@param string string
		---@param stringToSearch string
		---@return success boolean
		function AdaptiveAPI:FindString(string, stringToSearch)
			if string and stringToSearch then
				if string.match(string, stringToSearch) then
					return true
				else
					return false
				end
			else
				return false
			end
		end

		--- Returns the starting index of the character at the given index in the given UTF-8 encoded string.
		---@param str string
		---@param index number
		---@return number|nil
		function AdaptiveAPI:GetCharacterStartIndex(str, index)
			local i = 1
			local charCount = 0

			while i <= #str do
				local byte = str:byte(i)

				if byte >= 0 and byte <= 127 then
					charCount = charCount + 1
					if charCount == index then
						return i
					end
					i = i + 1
				elseif byte >= 192 and byte <= 223 then
					charCount = charCount + 1
					if charCount == index then
						return i
					end
					i = i + 2
				elseif byte >= 224 and byte <= 239 then
					charCount = charCount + 1
					if charCount == index then
						return i
					end
					i = i + 3
				elseif byte >= 240 and byte <= 247 then
					charCount = charCount + 1
					if charCount == index then
						return i
					end
					i = i + 4
				else
					i = i + 1
				end
			end

			return nil
		end

		--- Returns the index of the last byte of the character at the given index in the given UTF-8 encoded string.
		---@param str string
		---@param index number
		---@return number|nil
		function AdaptiveAPI:GetCharacterEndIndex(str, index)
			local start = AdaptiveAPI:GetCharacterStartIndex(str, index)
			if start then
				local byte = str:byte(start)
				if byte >= 0 and byte <= 127 then
					return start
				elseif byte >= 192 and byte <= 223 then
					return start + 1
				elseif byte >= 224 and byte <= 239 then
					return start + 2
				elseif byte >= 240 and byte <= 247 then
					return start + 3
				end
			end
			return nil
		end

		--- Gets the actual height of the text in the given font string without any color codes.
		---@param text FontString
		---@return number
		function AdaptiveAPI:GetActualStringHeight(text)
			local CleanedText = AdaptiveAPI:StripColorCodes(text:GetText())

			--------------------------------

			local Temp = CreateFrame("Frame"):CreateFontString(nil, "BACKGROUND", text:GetFont())
			Temp:SetWidth(text:GetWidth())
			Temp:SetText(CleanedText)

			--------------------------------

			local Height = Temp:GetHeight()
			return Height
		end

		--- Returns a substring of the given string from the starting index to the ending index.
		---@param str string
		---@param A number
		---@param B number
		---@return string
		function AdaptiveAPI:GetSubstring(str, A, B)
			local StartIndex = AdaptiveAPI:GetCharacterStartIndex(str, A)
			local EndIndex = AdaptiveAPI:GetCharacterEndIndex(str, B)

			--------------------------------

			if StartIndex and EndIndex then
				return str:sub(StartIndex, EndIndex)
			else
				return ""
			end
		end

		-- Removes atlas markup from the given string.
		---@param str string
		---@param removeSpace boolean
		---@return string
		function AdaptiveAPI:RemoveAtlasMarkup(str, removeSpace)
			if removeSpace then
				str = string.gsub(str, "(|A.-|a )", "")
				str = string.gsub(str, "(|H.-|h )", "")
			else
				str = string.gsub(str, "(|A.-|a)", "")
				str = string.gsub(str, "(|H.-|h)", "")
			end

			return str
		end
	end

	do -- FORMATTING
		-- Removes color codes from the given string.
		---@param text string
		---@return string
		function AdaptiveAPI:StripColorCodes(text)
			if text ~= nil then
				return text:gsub("|cff%x%x%x%x%x%x%x%x", ""):gsub("|r", "")
			else
				return ""
			end
		end

		-- Converts RGB values to a hex color string.
		---@param r number
		---@param g number
		---@param b number
		---@return string: The given color as a hex string (#RRGGBB).
		function AdaptiveAPI:GetHexColor(r, g, b)
			r = math.floor(r * 255)
			g = math.floor(g * 255)
			b = math.floor(b * 255)
			return string.format("%02x%02x%02x", r, g, b)
		end

		-- Changes the brightness of a given hex color string.
		---@param hexColor string
		---@param factor number
		---@return string
		function AdaptiveAPI:SetHexColorFromModifier(hexColor, factor)
			local color = hexColor:match("([0-9A-Fa-f]+)")

			if not color then
				return hexColor
			end

			local r = tonumber(color:sub(1, 2), 16)
			local g = tonumber(color:sub(3, 4), 16)
			local b = tonumber(color:sub(5, 6), 16)

			r = math.max(0, math.floor(r * (factor)))
			g = math.max(0, math.floor(g * (factor)))
			b = math.max(0, math.floor(b * (factor)))

			local newColor = string.format("%02x%02x%02x", r, g, b)

			return newColor
		end

		--- Modifies the brightness of a given hex color string, with a base color tint.
		---@param hexColor string
		---@param factor number
		---@param baseColor string
		---@return string
		function AdaptiveAPI:SetHexColorFromModifierWithBase(hexColor, factor, baseColor)
			local color = hexColor:match("([0-9A-Fa-f]+)")

			if not color then
				return hexColor
			end

			local r = tonumber(color:sub(1, 2), 16) or 0
			local g = tonumber(color:sub(3, 4), 16) or 0
			local b = tonumber(color:sub(5, 6), 16) or 0

			-- Parse the base color
			local baseR = tonumber(baseColor:sub(1, 2), 16) or 0
			local baseG = tonumber(baseColor:sub(3, 4), 16) or 0
			local baseB = tonumber(baseColor:sub(5, 6), 16) or 0

			-- Apply the brightness factor
			r = math.min(255, math.floor(r * factor + baseR * (1 - factor)))
			g = math.min(255, math.floor(g * factor + baseG * (1 - factor)))
			b = math.min(255, math.floor(b * factor + baseB * (1 - factor)))

			-- Ensure values are at least zero
			r = math.max(0, r)
			g = math.max(0, g)
			b = math.max(0, b)

			local newColor = string.format("%02x%02x%02x", r, g, b)

			return newColor
		end

		-- Converts a hex color to an RGB color from 0-1
		---@param hexColor string
		function AdaptiveAPI:GetRGBFromHexColor(hexColor)
			local r = tonumber(hexColor:sub(1, 2), 16) or 0
			local g = tonumber(hexColor:sub(3, 4), 16) or 0
			local b = tonumber(hexColor:sub(5, 6), 16) or 0

			return { r = r / 255, g = g / 255, b = b / 255 }
		end

		--- Sets the font of a FontString
		--- @param fontString FontString
		--- @param font string
		--- @param size number
		function AdaptiveAPI:SetFont(fontString, font, size)
			if not fontString then
				return
			end

			--------------------------------

			fontString:SetFont(font, size, "")
		end

		-- Sets the font for all FontStrings iterating from the given frame.
		---@param frame any
		---@param font string
		---@param size number
		function AdaptiveAPI:SetFontAll(frame, font, size)
			if not frame then
				return
			end

			--------------------------------

			if frame.IsVisible then
				function Enumerate(_frame, _font, _size, moveToChildren)
					if not moveToChildren then
						if _frame.GetNumRegions and _frame:GetNumRegions() > 0 then
							for i = 1, _frame:GetNumRegions() do
								local Region = select(i, _frame:GetRegions())

								--------------------------------

								if Region and Region.IsObjectType and Region:IsObjectType("FontString") then
									Region:SetFont(_font, _size, "")
								else
									Enumerate(_frame, _font, _size, true)
								end
							end
						else
							if _frame.SetFont then
								_frame:SetFont(_font, _size, "")
							end

							--------------------------------

							Enumerate(_frame, _font, _size, true)
						end
					end

					if moveToChildren then
						if _frame.GetNumChildren then
							for i = 1, _frame:GetNumChildren() do
								local Children = select(i, _frame:GetChildren())

								--------------------------------

								Enumerate(Children, _font, _size, false)
							end
						end
					end
				end

				--------------------------------

				Enumerate(frame, font, size, false)
			end
		end

		-- Sets the font size of a FontString
		---@param fontString FontString
		function AdaptiveAPI:SetFontSize(fontString, size)
			local FontName, FontHeight, FontFlags = fontString:GetFont()
			fontString:SetFont(FontName, size, FontFlags or "")
		end

		-- Removes inline formatting from the given text.
		---@param text string
		function AdaptiveAPI:GetUnformattedText(text)
			local Result = text

			--------------------------------

			if text ~= "" and text ~= nil then
				Result = Result:gsub("|c%x%x%x%x%x%x%x%x(.-)|r", "%1")
				Result = Result:gsub("\124cn.-:", "")
				Result = Result:gsub("|H(.-)|h(.-)|h", "%2")

				return Result
			else
				return ""
			end
		end

		-- Removes non-colored formmating from a given text.
		---@param text string
		function AdaptiveAPI:GetImportantFormattedText(text)
			local Result = text

			--------------------------------

			if text ~= "" and text ~= nil then
				Result = Result:gsub("|cff000000", "")
				Result = Result:gsub("|cffFFFFFF", "")

				return Result
			else
				return ""
			end
		end

		-- Remove inline formatting from the given FontString.
		---@param fontString FontString
		function AdaptiveAPI:SetUnformattedText(fontString)
			if fontString.IsObjectType and fontString:IsObjectType("FontString") then
				fontString:SetText(AdaptiveAPI:GetUnformattedText(fontString:GetText()))
			end
		end

		-- Remove inline formatting from all FontStrings iterating from the given frame.
		---@param frame any
		function AdaptiveAPI:SetUnformattedTextAll(frame)
			if frame.IsVisible then
				function Enumerate(_frame, moveToChildren)
					if not moveToChildren then
						if _frame.GetNumRegions and _frame:GetNumRegions() > 0 then
							for i = 1, _frame:GetNumRegions() do
								local Region = select(i, _frame:GetRegions())

								--------------------------------

								if Region and Region.IsObjectType and Region:IsObjectType("FontString") then
									AdaptiveAPI:SetUnformattedText(Region)
								else
									Enumerate(_frame, true)
								end
							end
						else
							if _frame.SetFont then
								AdaptiveAPI:SetUnformattedText(_frame)
							end

							--------------------------------

							Enumerate(_frame, true)
						end
					end

					if moveToChildren then
						if _frame.GetNumChildren then
							for i = 1, _frame:GetNumChildren() do
								local Children = select(i, _frame:GetChildren())

								--------------------------------

								Enumerate(Children, _font, _size, false)
							end
						end
					end
				end

				--------------------------------

				Enumerate(frame, font, size, false)
			end
		end
	end

	do -- UTILITIES
		-- Extracts a number from a string.
		---@param str string
		---@return number number
		---@return sign string
		function AdaptiveAPI:ParseNumberFromString(str)
			-- Remove color codes from the string
			str = str:gsub("|c%x%x%x%x%x%x%x%x(.-)|r", "%1")

			--------------------------------

			-- Extract the number from the unformatted string
			local NumberString = str:match("%-?%d[%d,]*")
			local NumberSign = "+"

			--------------------------------

			if NumberString then
				if str:find("%-") then
					NumberSign = "-"
				end

				--------------------------------

				NumberString = NumberString:gsub("[,+%-]", "")

				--------------------------------

				local Number = tonumber(NumberString)

				--------------------------------

				return Number, NumberSign
			else
				return nil, nil
			end
		end
	end
end

--------------------------------
-- UTILITIES
--------------------------------

do
	do -- FORMATTING
		-- Formats x to be comma seperated.
		---@param x number
		function AdaptiveAPI:FormatNumber(x)
			if x >= 1000 then
				local formattedNumber = string.format("%d", x)
				local reverseFormatted = formattedNumber:reverse()
				local result = reverseFormatted:gsub("(%d%d%d)", "%1,")
				return result:reverse()
			else
				return string.format("%.0f", x)
			end
		end

		-- Returns x amount coverted to gold, silver and copper.
		---@param x number
		---@return gold number
		---@return silver number
		---@return copper number
		function AdaptiveAPI:FormatMoney(x)
			local gold = math.floor(x / 10000)
			local silver = math.floor((x % 10000) / 100)
			local copperAmount = x % 100

			--------------------------------

			return gold, silver, copperAmount
		end
	end

	do -- TOOLTIP
		-- Adds a tooltip to the specified frame.
		--- @param frame any
		--- @param text string
		--- @param location string
		--- @param locationX? number
		--- @param locationY? number
		--- @param customTooltip? boolean
		function AdaptiveAPI:AddTooltip(frame, text, location, locationX, locationY, customTooltip, bypassMouseResponder)
			frame.showTooltip = true
			frame.tooltipText = text
			frame.tooltipActive = false

			if frame.hookedFunc == nil then
				frame.hookedFunc = true

				--------------------------------

				frame.AdaptiveAPI_ShowTooltip = function()
					frame.tooltipActive = true

					--------------------------------

					GameTooltip:SetOwner(frame, location, locationX, locationY)
					GameTooltip:SetText(frame.tooltipText, 1, 1, 1, 1, true)
					GameTooltip:Show()

					--------------------------------

					if customTooltip and addon.BlizzardGameTooltip then
						addon.BlizzardGameTooltip.Script:StartCustom()
					end
				end

				frame.AdaptiveAPI_HideTooltip = function()
					frame.tooltipActive = false

					--------------------------------

					GameTooltip:Hide()

					--------------------------------

					if customTooltip and addon.BlizzardGameTooltip then
						addon.BlizzardGameTooltip.Script:StopCustom()
					end
				end

				--------------------------------

				local function Enter()
					if frame.showTooltip then
						frame.AdaptiveAPI_ShowTooltip()
					else
						frame.AdaptiveAPI_HideTooltip()
					end
				end

				local function Leave()
					frame.AdaptiveAPI_HideTooltip()
				end

				if bypassMouseResponder then
					frame:HookScript("OnEnter", Enter)
					frame:HookScript("OnLeave", Leave)
				else
					AdaptiveAPI.FrameTemplates:CreateMouseResponder(frame, Enter, Leave)
				end
			end
		end

		-- Disables the tooltip for the specified frame.
		---@param frame any
		function AdaptiveAPI:RemoveTooltip(frame)
			frame.showTooltip = false
			frame.tooltipText = ""
			if frame.tooltipActive then
				frame.tooltipActive = false

				--------------------------------

				frame.AdaptiveAPI_HideTooltip()
			end
		end

		-- Extracts item stats from a tooltip.
		---@param tooltip frame
		---@param raw? boolean: Default = false - Whether to ignore the "If you replace this item" line
		---@return table with the following keys:
		---    - intNum: number of intellect
		---    - intSign: sign of intellect
		---    - strNum: number of strength
		---    - strSign: sign of strength
		---    - aglNum: number of agility
		---    - aglSign: sign of agility
		---    - masteryNum: number of mastery
		---    - masterySign: sign of mastery
		---    - hasteNum: number of haste
		---    - hasteSign: sign of haste
		---    - versNum: number of versatility
		---    - versSign: sign of versatility
		---    - critNum: number of critical strike
		---    - critSign: sign of critical strike
		function AdaptiveAPI:GetItemStatsFromTooltip(tooltip, raw)
			local Stats = {}

			--------------------------------

			local Valid = false

			for i = 1, tooltip:NumLines() do
				local Line = _G[tooltip:GetName() .. "TextLeft" .. i]:GetText()

				--------------------------------

				if string.match(Line, "If you replace this item") or raw then
					Valid = true
				end

				--------------------------------

				if Valid then
					local function MatchLine(line, stringToFind)
						if string.match(line, stringToFind) then
							return line
						else
							return nil
						end
					end

					-- Search for specific keywords to identify stats
					local Intellect = MatchLine(Line, "Intellect")
					local Strength = MatchLine(Line, "Strength")
					local Agility = MatchLine(Line, "Agility")
					local Mastery = MatchLine(Line, "Mastery")
					local Haste = MatchLine(Line, "Haste")
					local Versatility = MatchLine(Line, "Versatility")
					local Crit = MatchLine(Line, "Critical Strike")

					local IntNum, IntSign = AdaptiveAPI:ParseNumberFromString(tostring(Intellect))
					local StrNum, StrSign = AdaptiveAPI:ParseNumberFromString(tostring(Strength))
					local AglNum, AglSign = AdaptiveAPI:ParseNumberFromString(tostring(Agility))
					local MasteryNum, MasterySign = AdaptiveAPI:ParseNumberFromString(tostring(Mastery))
					local HasteNum, HasteSign = AdaptiveAPI:ParseNumberFromString(tostring(Haste))
					local VersatilityNum, VersatilitySign = AdaptiveAPI:ParseNumberFromString(tostring(Versatility))
					local CritNum, CritSign = AdaptiveAPI:ParseNumberFromString(tostring(Crit))

					-- If any stat is found, add it to the table
					if IntNum then
						Stats.intNum = IntNum
						Stats.intSign = IntSign
					elseif StrNum then
						Stats.strNum = StrNum
						Stats.strSign = StrSign
					elseif AglNum then
						Stats.aglNum = AglNum
						Stats.aglSign = AglSign
					elseif MasteryNum then
						Stats.masteryNum = MasteryNum
						Stats.masterySign = MasterySign
					elseif HasteNum then
						Stats.hasteNum = HasteNum
						Stats.hasteSign = HasteSign
					elseif VersatilityNum then
						Stats.versNum = VersatilityNum
						Stats.versSign = VersatilitySign
					elseif CritNum then
						Stats.critNum = CritNum
						Stats.critSign = CritSign
					end
				end
			end

			--------------------------------

			return Stats
		end

		-- Extracts the total item stats from a tooltip.
		---@param tooltip frame
		---@param raw? boolean: Default = false - Whether to ignore the "If you replace this item" line
		---@return table table with the following keys:
		---    - intNum: total number of intellect
		---    - strNum: total number of strength
		---    - aglNum: total number of agility
		---    - masteryNum: total number of mastery
		---    - hasteNum: total number of haste
		---    - versNum: total number of versatility
		---    - critNum: total number of critical strike
		function AdaptiveAPI:GetTotalItemStatsFromTooltip(tooltip, raw)
			local Stats = {
				intNum = 0,
				strNum = 0,
				aglNum = 0,
				masteryNum = 0,
				hasteNum = 0,
				versNum = 0,
				critNum = 0,
			}

			--------------------------------

			local Valid = false

			for i = 1, tooltip:NumLines() do
				local Line = _G[tooltip:GetName() .. "TextLeft" .. i]:GetText()

				--------------------------------

				if string.match(Line, "If you replace this item") or raw then
					Valid = true
				end

				--------------------------------

				if Valid then
					local FinishSearch = false

					--------------------------------

					local function MatchLine(line, stringToFind)
						local IsEquip = AdaptiveAPI:FindString(line, "Equip")
						local IsZoneOfFocus = AdaptiveAPI:FindString(line, "Zone of Focus")
						local IsSet = AdaptiveAPI:FindString(line, "Set")

						--------------------------------

						if (not IsEquip or IsZoneOfFocus) and not IsSet and string.match(line, stringToFind) and not FinishSearch then
							FinishSearch = true

							--------------------------------

							return line
						else
							return nil
						end
					end

					-- Search for specific keywords to identify stats
					local Intellect = MatchLine(Line, "Intellect")
					local Strength = MatchLine(Line, "Strength")
					local Agility = MatchLine(Line, "Agility")
					local Mastery = MatchLine(Line, "Mastery")
					local Haste = MatchLine(Line, "Haste")
					local Versatility = MatchLine(Line, "Versatility")
					local Crit = MatchLine(Line, "Critical Strike")

					-- Parse and accumulate values for each stat
					local function AccumulateStat(statName, statValue)
						if statValue then
							local function CalculateStat(string)
								local Num, Sign = AdaptiveAPI:ParseNumberFromString(string)
								local StatName

								--------------------------------

								if AdaptiveAPI:FindString(string, "Intellect") then StatName = "intNum" end
								if AdaptiveAPI:FindString(string, "Strength") then StatName = "strNum" end
								if AdaptiveAPI:FindString(string, "Agility") then StatName = "aglNum" end
								if AdaptiveAPI:FindString(string, "Mastery") then StatName = "masteryNum" end
								if AdaptiveAPI:FindString(string, "Haste") then StatName = "hasteNum" end
								if AdaptiveAPI:FindString(string, "Versatility") then StatName = "versNum" end
								if AdaptiveAPI:FindString(string, "Critical Strike") then StatName = "critNum" end

								--------------------------------

								if Num and StatName then
									Stats[StatName] = Stats[StatName] + Num
								end
							end

							if AdaptiveAPI:FindString(statValue, "and") then
								local string1, string2 = statValue:match("^(.-)%s+and%s+(.*)$")

								CalculateStat(string1)
								CalculateStat(string2)
							elseif AdaptiveAPI:FindString(statValue, "Zone of Focus") then
								local string1, string2 = statValue:match("^(.-)%%(.*)$")

								CalculateStat(string2)
							else
								CalculateStat(statValue)
							end
						end
					end

					AccumulateStat("intNum", Intellect)
					AccumulateStat("strNum", Strength)
					AccumulateStat("aglNum", Agility)
					AccumulateStat("masteryNum", Mastery)
					AccumulateStat("hasteNum", Haste)
					AccumulateStat("versNum", Versatility)
					AccumulateStat("critNum", Crit)
				end
			end

			--------------------------------

			return Stats
		end

		-- Returns the item level from a tooltip.
		---@param tooltip frame
		---@return ItemLevel number
		function AdaptiveAPI:GetItemLevelFromTooltip(tooltip)
			local ItemLevel

			--------------------------------

			for i = 1, tooltip:NumLines() do
				local Line = _G[tooltip:GetName() .. "TextLeft" .. i]:GetText()

				--------------------------------

				local function MatchLine(line, stringToFind)
					if string.match(line, stringToFind) then
						return line
					else
						return nil
					end
				end

				--------------------------------

				local ItemLevelLine = MatchLine(Line, "Item Level")

				--------------------------------

				if ItemLevelLine then
					ItemLevel = AdaptiveAPI:ParseNumberFromString(tostring(ItemLevelLine))
				end
			end

			--------------------------------

			return ItemLevel
		end
	end

	do -- SEARCH
		-- Returns if the an item name is found in the player's bag.
		---@param itemName string
		---@return itemID any
		---@return itemLink any
		function AdaptiveAPI:FindItemInInventory(itemName)
			if not itemName then
				return nil, nil
			end

			--------------------------------

			for bag = 0, 4 do
				for slot = 1, C_Container.GetContainerNumSlots(bag) do
					local itemID = C_Container.GetContainerItemID(bag, slot) or nil
					local itemLink = C_Container.GetContainerItemLink(bag, slot) or nil

					if itemLink then
						local itemNameInBag = C_Item.GetItemInfo(itemLink)
						if itemNameInBag and itemNameInBag:lower() == itemName:lower() then
							return itemID, itemLink
						end
					end
				end
			end

			--------------------------------

			return nil
		end

		-- Finds the index of a value in a table.
		--- @param table table
		--- @param indexValue any
		--- @return index any
		function AdaptiveAPI:FindIndexInTable(table, indexValue)
			local CurrentIndex = 0

			--------------------------------

			for k, v in pairs(table) do
				CurrentIndex = CurrentIndex + 1

				--------------------------------

				if k == indexValue then
					return CurrentIndex
				end
			end

			--------------------------------

			return nil
		end

		-- Finds the index of a value in a table by value.
		--- @param table table
		--- @param indexValue any
		--- @return index any
		function AdaptiveAPI:FindIndexInTableByValue(table, indexValue)
			local CurrentIndex = 0

			--------------------------------

			for k, v in pairs(table) do
				CurrentIndex = CurrentIndex + 1

				--------------------------------

				if v == indexValue then
					return CurrentIndex
				end
			end

			--------------------------------

			return nil
		end

		-- Finds the index of a value in a table by value.
		--- @param table table
		--- @param indexValue any
		--- @param searchVariable string
		function AdaptiveAPI:FindIndexInTableByVariableValue(table, indexValue, searchVariable)
			for i = 1, #table do
				local CurrentEntry = table[i]

				--------------------------------

				if CurrentEntry[searchVariable] == indexValue then
					return i
				end
			end

			--------------------------------

			return nil
		end

		-- Sorts a list by numbers.
		---@param list table
		---@param variable string: variable to sort
		---@param ascending? boolean: use ascending order
		---@return new table
		function AdaptiveAPI:SortListByNumber(list, variable, ascending)
			table.sort(list, function(a, b)
				if ascending then
					return a[variable] > b[variable]
				else
					return b[variable] < a[variable]
				end
			end)

			--------------------------------

			return list
		end

		-- Sorts a list by alphabetical order.
		---@param list table
		---@param variable string: variable to sort
		---@param ascending? boolean: use descending order (Z-A)
		---@return new table
		function AdaptiveAPI:SortListByAlphabeticalOrder(list, variable, descending)
			table.sort(list, function(a, b)
				if descending then
					return a[variable]:lower() > b[variable]:lower()
				else
					return a[variable]:lower() < b[variable]:lower()
				end
			end)

			--------------------------------

			return list
		end

		-- Filters a list by a variable.
		---@param list table
		---@param variable string: variable to filter
		---@param value any: value to filter
		---@param roughMatch? boolean: use rough matching
		---@param caseSensitive? boolean: use case-sensitive matching
		---@param customCheck? function
		---@return new table
		function AdaptiveAPI:FilterListByVariable(list, variable, value, roughMatch, caseSensitive, customCheck)
			local FilteredList = {}

			--------------------------------

			for k, v in ipairs(list) do
				if customCheck then
					if customCheck(v) then
						table.insert(FilteredList, v)
					end
				elseif roughMatch then
					if caseSensitive or caseSensitive == nil then
						if AdaptiveAPI:FindString(tostring(v[variable]), tostring(value)) then
							table.insert(FilteredList, v)
						end
					else
						if AdaptiveAPI:FindString(string.lower(tostring(v[variable])), string.lower(tostring(value))) then
							table.insert(FilteredList, v)
						end
					end
				else
					if caseSensitive or caseSensitive == nil then
						if v[variable] == value then
							table.insert(FilteredList, v)
						end
					else
						if string.lower(tostring(v[variable])) == string.lower(tostring(value)) then
							table.insert(FilteredList, v)
						end
					end
				end
			end

			--------------------------------

			return FilteredList
		end
	end

	do -- FRAME TEMPLATES

	end

	do -- FUNCTIONS
		ChangeUpdateCallbacks = {}

		-- Function to trigger the callbacks when a variable changes.
		---@param variableName string
		---@param newValue any
		local function TriggerCallbacks(variableName, newValue)
			for _, entry in ipairs(ChangeUpdateCallbacks) do
				if entry.variableName == variableName then
					entry.callback(newValue)
				end
			end
		end

		-- Function to watch a variable and trigger a callback on change.
		---@param variableTable any
		---@param variableName string
		---@param callback function
		function AdaptiveAPI:WatchLocalVariable(variableTable, variableName, callback)
			if not variableTable[variableName] then
				variableTable[variableName] = nil -- Initialize if not set
			end

			-- Metatable for variable watching
			local mt = {
				__newindex = function(t, key, value)
					rawset(t, key, value)  -- Set the value
					TriggerCallbacks(variableName, value) -- Trigger the callbacks
				end,
				__index = function(t, key)
					return rawget(t, key) -- Return the value
				end
			}

			-- Set the metatable for the variable in the table
			setmetatable(variableTable, mt)

			-- Register the callback
			ChangeUpdateCallbacks[#ChangeUpdateCallbacks + 1] = {
				variableName = variableName,
				callback = callback
			}
		end
	end

	do -- MISCELLANEOUS
		-- Gets if the player is in shapeshift form by spell name.
		---@return IsInShapeshiftForm boolean
		function AdaptiveAPI:IsPlayerInShapeshiftForm()
			local ShapeshiftForms = {
				"Cat Form", -- Druid Cat Form
				"Bear Form", -- Druid Bear Form
				"Travel Form", -- Druid Travel Form
				"Moonkin Form", -- Druid Moonkin Form
				"Aquatic Form", -- Druid Aquatic Form
				"Treant Form", -- Druid Treant Form
				"Mount Form", -- Druid Mount Form
			}

			--------------------------------

			for key, value in ipairs(ShapeshiftForms) do
				if AuraUtil.FindAuraByName(value, "Player") then
					return true
				end
			end

			--------------------------------

			return false
		end

		-- Return WorldFrame width, unaffected by UI Scale.
		---@return width number
		function AdaptiveAPI:GetScreenWidth()
			return WorldFrame:GetWidth()
		end

		-- Return WorldFrame height, unaffected by UI Scale.
		---@return height number
		function AdaptiveAPI:GetScreenHeight()
			return WorldFrame:GetHeight()
		end
	end
end

--------------------------------
-- FRAME
--------------------------------

do
	do -- FRAME
		-- Anchors a frame to the center of its parent.
		---@param frame any
		---@param avoidButton? boolean: Whether to avoid anchoring to a button.
		function AdaptiveAPI:AnchorToCenter(frame, avoidButton)
			if not frame or not frame:GetParent() then
				return
			end

			--------------------------------

			local Parent = frame:GetParent()

			--------------------------------

			local function IsButton(_frame)
				if AdaptiveAPI:FindString(_frame:GetDebugName(), "Button") == true then
					IsButton(_frame:GetParent())
				else
					return _frame
				end
			end

			--------------------------------

			if avoidButton then
				Parent = IsButton(Parent)
			end

			local NewAnchor = CreateFrame("Frame", nil, Parent)
			NewAnchor:SetPoint(frame:GetPoint())
			NewAnchor:SetSize(frame:GetSize())

			--------------------------------

			frame:ClearAllPoints()
			frame:SetPoint("CENTER", NewAnchor, "CENTER")
		end

		-- Sets the size of a frame with an offset that updates with the parent scale. Uses SetPoint.
		---@param frame any
		---@param parent any
		---@param offsetWidth number
		---@param offsetHeight number
		function AdaptiveAPI:SetSize(frame, parent, offsetWidth, offsetHeight)
			frame:SetPoint("TOPLEFT", parent, -offsetWidth / 2, -offsetHeight / 2)
			frame:SetPoint("TOPRIGHT", parent, offsetWidth / 2, -offsetHeight / 2)
			frame:SetPoint("BOTTOMLEFT", parent, -offsetWidth / 2, offsetHeight / 2)
			frame:SetPoint("BOTTOMRIGHT", parent, offsetWidth / 2, offsetHeight / 2)
		end

		-- Sets the visibility of a frame with a boolean value.
		---@param frame any
		---@param visibility boolean
		function AdaptiveAPI:SetVisibility(frame, visibility)
			if visibility then
				frame:Show()
			else
				frame:Hide()
			end
		end

		-- Returns the mouse delta from the origin point.
		---@param originX number
		---@param originY number
		---@return deltaX number
		---@return deltaY number
		function AdaptiveAPI:GetMouseDelta(originX, originY)
			if not originX or not originY then
				return nil, nil
			end

			--------------------------------

			local MouseX, MouseY = GetCursorPosition()
			local FrameX = originX
			local FrameY = originY

			--------------------------------

			local DeltaX = (MouseX - FrameX)
			local DeltaY = (FrameY - MouseY) -- Invert Y axis because WoW's coordinate system has Y increasing upwards.

			--------------------------------

			return DeltaX, DeltaY
		end

		-- Sets the value of a variable to all children of a frame.
		---@param frame any
		---@param variable string
		---@param value any
		function AdaptiveAPI:SetAllVariablesToChildren(frame, variable, value)
			for f1 = 1, frame:GetNumChildren() do
				local _frameIndex1 = select(f1, frame:GetChildren())

				--------------------------------

				if _frameIndex1.GetNumChildren and _frameIndex1:GetNumChildren() > 0 then
					AdaptiveAPI:SetAllVariablesToChildren(_frameIndex1, variable, value)
				end

				--------------------------------

				_frameIndex1[variable] = value
			end
		end

		-- Calls a function to all children of a frame.
		---@param frame any
		---@param func function
		function AdaptiveAPI:CallFunctionToAllChildren(frame, func)
			for f1 = 1, frame:GetNumChildren() do
				local _frameIndex1 = select(f1, frame:GetChildren())

				--------------------------------

				if _frameIndex1.GetNumChildren and _frameIndex1:GetNumChildren() > 0 then
					AdaptiveAPI:CallFunctionToAllChildren(_frameIndex1, func)
				end

				--------------------------------

				func(_frameIndex1)
			end
		end
	end

	do -- HOOKS
		-- Sets the text color of a frame to white.
		---@param frame any
		function AdaptiveAPI:HookSetTextColor(frame)
			if not frame.HookedTextColor then
				frame.HookedTextColor = true

				--------------------------------

				hooksecurefunc(frame, "SetTextColor", function()
					frame:SetText("|cffFFFFFF" .. AdaptiveAPI:GetUnformattedText(frame:GetText()) .. "|r")
				end)

				hooksecurefunc(frame, "SetFormattedText", function()
					frame:SetText("|cffFFFFFF" .. AdaptiveAPI:GetUnformattedText(frame:GetText()) .. "|r")
				end)
			end

			--------------------------------

			frame:SetText("|cffFFFFFF" .. AdaptiveAPI:GetUnformattedText(frame:GetText()) .. "|r")
		end

		-- Hides an element when it is shown.
		---@param frame any
		function AdaptiveAPI:HookHideElement(frame)
			if not frame.HookedHideElement then
				frame.HookedHideElement = true

				--------------------------------

				frame:HookScript("OnShow", function()
					frame:Hide()
				end)

				--------------------------------

				frame:Hide()
			end
		end
	end
end

--------------------------------
-- MISCELLANEOUS
--------------------------------

do
	do -- CVARS
		-- Sets a CVar to a value if not InCombatLockdown and value is different.
		---@param cvar string
		---@param value any
		function AdaptiveAPI:SetCVar(cvar, value)
			if not InCombatLockdown() and GetCVar(cvar) ~= value then
				SetCVar(cvar, value)
			end
		end
	end

	do -- INLINE ICONS
		-- Creates an inline icon.
		---@param path string
		---@param height number
		---@param width number
		---@param horizontalOffset number
		---@param verticalOffset number
		---@param type? string: "Atlas" or "Texture"
		---@return string string
		function AdaptiveAPI:InlineIcon(path, height, width, horizontalOffset, verticalOffset, type)
			if type == "Atlas" then
				return CreateAtlasMarkup(path, width, height, horizontalOffset, verticalOffset)
			else
				return "|T" .. path .. ":" .. height .. ":" .. width .. ":" .. horizontalOffset .. ":" .. verticalOffset .. "|t"
			end
		end

		-- Offsets an inline icon.
		---@param iconString string
		---@param newXOffset number
		---@param newYOffset number
		---@return new string
		function AdaptiveAPI:IconOffset(iconString, newXOffset, newYOffset)
			return iconString:gsub(":(%d+):(%d+)|a", ":" .. newXOffset .. ":" .. newYOffset .. "|a")
		end
	end

	do -- FRAME
		-- Clears the OnUpdate script of a frame.
		---@param frame any
		function AdaptiveAPI:ClearFrameUpdate(frame)
			if not frame then
				return
			end

			--------------------------------

			frame:SetScript("OnUpdate", nil)
		end

		-- Unregisters a frame from Blizzard UI Panel windows.
		---@param frame any
		function AdaptiveAPI:UnregisterFrame(frame)
			UIPanelWindows[frame:GetName()] = nil
		end

		-- Returns if a frame has the given script.
		---@param frame any
		---@param scriptName string
		---@return boolean
		function AdaptiveAPI:FrameHasScript(frame, scriptName)
			if frame.GetScript and pcall(function() frame:GetScript(scriptName) end) then
				return true
			else
				return false
			end
		end
	end

	do -- THEME
		-- Registers a function to be called when the theme changes.
		---@param func function
		---@param priority? number
		function AdaptiveAPI:RegisterThemeUpdateWithNativeAPI(func, priority)
			if AdaptiveAPI.NativeAPI.RegisterThemeUpdate then
				AdaptiveAPI.NativeAPI:RegisterThemeUpdate(func, priority)
			else
				func()
			end
		end
	end

	do -- PERFORMANCE

	end
end
