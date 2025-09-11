---@class addon
local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local PrefabRegistry = addon.PrefabRegistry
local L = addon.Locales

--------------------------------
-- VARIABLES
--------------------------------

addon.API.Util = {}

do -- MAIN
	addon.API.Util.NativeAPI = addon.API.Main
	addon.API.Util.NativeCallback = addon
	addon.API.Util.NativeTheme = addon.Theme
	addon.API.Util.IsDarkTheme = nil
end

do -- CONSTANTS
	addon.API.Util.RGB_RECOMMENDED = {}
	addon.API.Util.RGB_WHITE = { r = .99, g = .99, b = .99 }
	addon.API.Util.RGB_BLACK = { r = .2, g = .2, b = .2 }
	addon.API.Util.UI_SCALE = addon.API.Main.UIScale
end

--------------------------------
-- FUNCTIONS (VARIABLES)
--------------------------------

do
	local function ThemeUpdate()
		addon.API.Util.IsDarkTheme = addon.API.Util.NativeAPI:GetDarkTheme()

		--------------------------------

		if addon.API.Util.IsDarkTheme then
			addon.API.Util.RGB_RECOMMENDED = addon.API.Util.RGB_WHITE
		else
			addon.API.Util.RGB_RECOMMENDED = addon.API.Util.RGB_BLACK
		end
	end

	ThemeUpdate()

	addon.Libraries.AceTimer:ScheduleTimer(function()
		addon.API.Main:RegisterThemeUpdateWithNativeAPI(ThemeUpdate, -1)
	end, .1)
end

--------------------------------
-- STRING
--------------------------------

do
	do -- STRING
		do -- MEASUREMENT
			addon.API.MeasurementFrame = CreateFrame("Frame", "addon.API.MeasurementFrame", nil)
			addon.API.MeasurementFrame:SetScale(addon.API.Util.UI_SCALE)
			addon.API.MeasurementFrame:SetAllPoints(UIParent)

			addon.API.MeasurementText = addon.API.MeasurementFrame:CreateFontString("addon.API.MeasurementText", "OVERLAY")
			addon.API.MeasurementText:SetPoint("CENTER", addon.API.MeasurementFrame)
			addon.API.MeasurementText:Hide()

			-- Gets the width & height of the given string.
			---@param frame fontstring
			---@param maxWidth? number
			---@param maxHeight? number
			---@return width number
			---@return height number
			function addon.API.Util:GetStringSize(frame, maxWidth, maxHeight)
				local text = addon.API.Util:GetUnformattedText(frame:GetText())
				local font, size, flags = frame:GetFont()
				local justifyH, justifyV = frame:GetJustifyH(), frame:GetJustifyV()

				--------------------------------

				addon.API.MeasurementText:SetFont(font or GameFontNormal:GetFont(), size > 0 and size or 12.5, flags or "")
				addon.API.MeasurementText:SetText(text)

				if justifyH then
					addon.API.MeasurementText:SetJustifyH(justifyH)
				end

				if justifyV then
					addon.API.MeasurementText:SetJustifyV(justifyV)
				end

				addon.API.MeasurementText:SetWidth(maxWidth or frame:GetWidth())
				addon.API.MeasurementText:SetHeight(maxHeight or 1000)

				--------------------------------

				local width, height = addon.API.MeasurementText:GetWrappedWidth(), addon.API.MeasurementText:GetStringHeight()
				return width, height
			end

			--- Gets the actual height of the text in the given font string without any color codes.
			---@param text FontString
			---@return number
			function addon.API.Util:GetActualStringHeight(text)
				local cleanedText = addon.API.Util:StripColorCodes(text:GetText())

				--------------------------------

				local textFrame = CreateFrame("Frame"):CreateFontString(nil, "BACKGROUND", text:GetFont())
				textFrame:SetWidth(text:GetWidth())
				textFrame:SetText(cleanedText)

				--------------------------------

				local height = textFrame:GetHeight()
				return height
			end
		end

		do -- SEARCH
			-- Returns if the given string is found in the string.
			---@param string string
			---@param stringToSearch string
			---@return success boolean
			function addon.API.Util:FindString(string, stringToSearch)
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
			function addon.API.Util:GetCharacterStartIndex(str, index)
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
			function addon.API.Util:GetCharacterEndIndex(str, index)
				local start = addon.API.Util:GetCharacterStartIndex(str, index)
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

			--- Returns a substring of the given string from the starting index to the ending index.
			---@param str string
			---@param A number
			---@param B number
			---@return string
			function addon.API.Util:GetSubstring(str, A, B)
				local startIndex = addon.API.Util:GetCharacterStartIndex(str, A)
				local endIndex = addon.API.Util:GetCharacterEndIndex(str, B)

				--------------------------------

				if startIndex and endIndex then
					return str:sub(startIndex, endIndex)
				else
					return ""
				end
			end
		end

		do -- UTILITIES
			-- Removes atlas markup from the given string.
			---@param str string
			---@param removeSpace boolean
			---@return string
			function addon.API.Util:RemoveAtlasMarkup(str, removeSpace)
				str = str or ""
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
	end

	do -- FORMATTING
		-- Removes color codes from the given string.
		---@param text string
		---@return string
		function addon.API.Util:StripColorCodes(text)
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
		function addon.API.Util:GetHexColor(r, g, b)
			r = math.floor(r * 255)
			g = math.floor(g * 255)
			b = math.floor(b * 255)
			return string.format("%02x%02x%02x", r, g, b)
		end

		-- Changes the brightness of a given hex color string.
		---@param hexColor string
		---@param factor number
		---@return string
		function addon.API.Util:SetHexColorFromModifier(hexColor, factor)
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
		function addon.API.Util:SetHexColorFromModifierWithBase(hexColor, factor, baseColor)
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
		function addon.API.Util:GetRGBFromHexColor(hexColor)
			local r = tonumber(hexColor:sub(1, 2), 16) or 0
			local g = tonumber(hexColor:sub(3, 4), 16) or 0
			local b = tonumber(hexColor:sub(5, 6), 16) or 0

			return { r = r / 255, g = g / 255, b = b / 255 }
		end

		--- Sets the font of a FontString
		--- @param fontString FontString
		--- @param font string
		--- @param size number
		function addon.API.Util:SetFont(fontString, font, size)
			if not fontString then
				return
			end

			--------------------------------

			fontString:SetFont(font, size, "")
		end

		-- Sets the font size of a FontString
		---@param fontString FontString
		function addon.API.Util:SetFontSize(fontString, size)
			local FontName, FontHeight, FontFlags = fontString:GetFont()
			fontString:SetFont(FontName, size, FontFlags or "")
		end

		-- Removes inline formatting from the given text.
		---@param text string
		function addon.API.Util:GetUnformattedText(text)
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
		function addon.API.Util:GetImportantFormattedText(text)
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
		function addon.API.Util:SetUnformattedText(fontString)
			if fontString.IsObjectType and fontString:IsObjectType("FontString") then
				fontString:SetText(addon.API.Util:GetUnformattedText(fontString:GetText()))
			end
		end
	end

	do -- UTILITIES
		-- Extracts a number from a string.
		---@param str string
		---@return number number
		---@return sign string
		function addon.API.Util:ParseNumberFromString(str)
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
		function addon.API.Util:FormatNumber(x)
			return BreakUpLargeNumbers(x)
		end

		-- Returns x amount coverted to gold, silver and copper.
		---@param x number
		---@return gold number
		---@return silver number
		---@return copper number
		function addon.API.Util:FormatMoney(x)
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
		--- @param wrapText? boolean
		function addon.API.Util:AddTooltip(frame, text, location, locationX, locationY, bypassMouseResponder, wrapText)
			frame.showTooltip = true
			frame.tooltipText = text
			frame.tooltipActive = false

			--------------------------------

			if not frame.hookedFunc then
				frame.hookedFunc = true

				--------------------------------

				frame.API_ShowTooltip = function()
					frame.tooltipActive = true

					--------------------------------

					InteractionFrame.GameTooltip:SetOwner(frame, location, locationX, locationY)
					InteractionFrame.GameTooltip:SetText(frame.tooltipText, 1, 1, 1, 1, (wrapText == nil and true or wrapText))
					InteractionFrame.GameTooltip:Show()
				end

				frame.API_HideTooltip = function()
					frame.tooltipActive = false

					--------------------------------

					InteractionFrame.GameTooltip:Clear()
				end

				--------------------------------

				local function Enter()
					if frame.showTooltip then
						frame.API_ShowTooltip()
					else
						frame.API_HideTooltip()
					end
				end

				local function Leave()
					frame.API_HideTooltip()
				end

				if bypassMouseResponder then
					frame:HookScript("OnEnter", Enter)
					frame:HookScript("OnLeave", Leave)
				else
					addon.API.FrameTemplates:CreateMouseResponder(frame, { enterCallback = Enter, leaveCallback = Leave })
				end
			end
		end

		-- Disables the tooltip for the specified frame.
		---@param frame any
		function addon.API.Util:RemoveTooltip(frame)
			frame.showTooltip = false
			frame.tooltipText = ""
			if frame.tooltipActive then
				frame.tooltipActive = false

				--------------------------------

				frame.API_HideTooltip()
			end
		end
	end

	do -- SEARCH
		-- Returns if the an item name is found in the player's bag.
		---@param itemName string
		---@return itemID any
		---@return itemLink any
		function addon.API.Util:FindItemInInventory(itemName)
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

		-- Finds the position of a specified key in a table.
		--- @param table table
		--- @param indexValue any
		--- @return index any
		function addon.API.Util:FindKeyPositionInTable(table, indexValue)
			local currentIndex = 0

			--------------------------------

			for k, v in pairs(table) do
				currentIndex = currentIndex + 1

				--------------------------------

				if k == indexValue then
					return currentIndex
				end
			end

			--------------------------------

			return nil
		end

		-- Finds the position of a specified value in a table.
		--- @param table table
		--- @param indexValue any
		--- @return index any
		function addon.API.Util:FindValuePositionInTable(table, indexValue)
			local currentIndex = 0

			--------------------------------

			for k, v in pairs(table) do
				currentIndex = currentIndex + 1

				--------------------------------

				if v == indexValue then
					return currentIndex
				end
			end

			--------------------------------

			return nil
		end

		-- Finds the position of a variable value in a table.
		--- @param table table
		--- @param indexValue any
		--- @param searchVariable string
		function addon.API.Util:FindVariableValuePositionInTable(table, subVariableList, value)
			for i = 1, #table do
				local currentEntry = table[i]

				--------------------------------

				local subVariable = addon.API.Util:GetSubVariableFromList(currentEntry, subVariableList)
				if subVariable == value then
					return i
				end
			end

			--------------------------------

			return nil
		end

		-- Returns a sub variable from a list.
		---@param list table
		---@param subVariableList table
		---@return any
		function addon.API.Util:GetSubVariableFromList(list, subVariableList)
			local currentKey = list

			--------------------------------

			for i = 1, #subVariableList do
				currentKey = currentKey[subVariableList[i]]
			end

			--------------------------------

			return currentKey
		end

		-- Sorts a list by numbers.
		---@param list table
		---@param subVariableList table
		---@param ascending? boolean: use ascending order
		---@return table
		function addon.API.Util:SortListByNumber(list, subVariableList, ascending)
			table.sort(list, function(a, b)
				if ascending then
					local subVariableA = addon.API.Util:GetSubVariableFromList(a, subVariableList)
					local subVariableB = addon.API.Util:GetSubVariableFromList(b, subVariableList)

					return subVariableA > subVariableB
				else
					local subVariableA = addon.API.Util:GetSubVariableFromList(a, subVariableList)
					local subVariableB = addon.API.Util:GetSubVariableFromList(b, subVariableList)

					return subVariableA < subVariableB
				end
			end)

			--------------------------------

			return list
		end

		-- Sorts a list by alphabetical order.
		---@param list table
		---@param subVariableList table,
		---@param descending? boolean: use descending order (Z-A)
		---@return table
		function addon.API.Util:SortListByAlphabeticalOrder(list, subVariableList, descending)
			table.sort(list, function(a, b)
				if descending then
					local subVariableA = addon.API.Util:GetSubVariableFromList(a, subVariableList)
					local subVariableB = addon.API.Util:GetSubVariableFromList(b, subVariableList)

					return subVariableA:lower() > subVariableB:lower()
				else
					local subVariableA = addon.API.Util:GetSubVariableFromList(a, subVariableList)
					local subVariableB = addon.API.Util:GetSubVariableFromList(b, subVariableList)

					return subVariableA:lower() < subVariableB:lower()
				end
			end)

			--------------------------------

			return list
		end

		-- Filters a list by a variable.
		---@param list table
		---@param subVariableList table,
		---@param value any: value to filter
		---@param roughMatch? boolean: use rough matching
		---@param caseSensitive? boolean: use case-sensitive matching
		---@param customCheck? function
		---@return table
		function addon.API.Util:FilterListByVariable(list, subVariableList, value, roughMatch, caseSensitive, customCheck)
			local filteredList = {}

			--------------------------------

			for k, v in ipairs(list) do
				if customCheck then
					if customCheck(v) then
						table.insert(filteredList, v)
					end
				elseif roughMatch then
					if caseSensitive or caseSensitive == nil then
						local subVariableValue = addon.API.Util:GetSubVariableFromList(v, subVariableList)

						if addon.API.Util:FindString(tostring(subVariableValue), tostring(value)) then
							table.insert(filteredList, v)
						end
					else
						local subVariableValue = addon.API.Util:GetSubVariableFromList(v, subVariableList)

						if addon.API.Util:FindString(string.lower(tostring(subVariableValue)), string.lower(tostring(value))) then
							table.insert(filteredList, v)
						end
					end
				else
					if caseSensitive or caseSensitive == nil then
						local subVariableValue = addon.API.Util:GetSubVariableFromList(v, subVariableList)

						if subVariableValue == value then
							table.insert(filteredList, v)
						end
					else
						local subVariableValue = addon.API.Util:GetSubVariableFromList(v, subVariableList)

						if string.lower(tostring(subVariableValue)) == string.lower(tostring(value)) then
							table.insert(filteredList, v)
						end
					end
				end
			end

			--------------------------------

			return filteredList
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
		function addon.API.Util:WatchLocalVariable(variableTable, variableName, callback)
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
		function addon.API.Util:IsPlayerInShapeshiftForm()
			local auras = {
				"Cat Form", -- Druid Cat Form
				"Bear Form", -- Druid Bear Form
				"Travel Form", -- Druid Travel Form
				"Moonkin Form", -- Druid Moonkin Form
				"Aquatic Form", -- Druid Aquatic Form
				"Treant Form", -- Druid Treant Form
				"Mount Form", -- Druid Mount Form
			}

			--------------------------------

			for key, value in ipairs(auras) do
				if AuraUtil.FindAuraByName(value, "Player") then
					return true
				end
			end

			--------------------------------

			return false
		end

		-- Return WorldFrame width, unaffected by UI Scale.
		---@return width number
		function addon.API.Util:GetScreenWidth()
			return WorldFrame:GetWidth()
		end

		-- Return WorldFrame height, unaffected by UI Scale.
		---@return height number
		function addon.API.Util:GetScreenHeight()
			return WorldFrame:GetHeight()
		end
	end

	do -- METHOD
		-- Creates a method chain. Input a list of variables names to keep track and set. The variables can be called at anytime within the declaration method.
		--
		-- DECLARATION
		-- 		local chain = AddMethodChain({ "onFinish" })
		-- 		return { onFinish = chain.onFinish.set } -- in return statement
		--
		-- CALL
		--		chain.onFinish.variable()
		--
		-- USAGE
		-- 		func().onFinish(function()
		-- 			print("Hello, World!")
		-- 		end)
		---@param variableNames table
		---@return table
		function addon.API.Util:AddMethodChain(variableNames)
			local chain = {}

			--------------------------------

			for i = 1, #variableNames do
				local entry = {}
				entry = {
					["variable"] = nil,
					["set"] = function(...)
						entry.variable = ...
					end
				}

				chain[variableNames[i]] = entry
			end

			--------------------------------

			return chain
		end
	end

	do -- STANDARD FUNCTIONS
		-- Returns the length of a table.
		---@param table table
		---@return length number
		function addon.API.Util:tnum(table)
			local length = 0

			for _ in pairs(table) do
				length = length + 1
			end

			return length
		end

		-- Reverses a table.
		---@param table table
		---@return table table
		function addon.API.Util:rt(table)
			local reversed = {}
			local len = #table

			--------------------------------

			for i = len, 1, -1 do
				reversed[len - i + 1] = table[i]
			end

			--------------------------------

			return reversed
		end

		-- Generates a random hash
		---@return string hash
		function addon.API.Util:gen_hash()
			local hash = ""
			local chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"

			--------------------------------

			for i = 1, 16 do
				local rand = math.random(1, #chars)
				hash = hash .. chars:sub(rand, rand)
			end

			--------------------------------

			return hash
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
		function addon.API.Util:SetCVar(cvar, value)
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
		function addon.API.Util:InlineIcon(path, height, width, horizontalOffset, verticalOffset, type)
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
		function addon.API.Util:IconOffset(iconString, newXOffset, newYOffset)
			return iconString:gsub(":(%d+):(%d+)|a", ":" .. newXOffset .. ":" .. newYOffset .. "|a")
		end
	end

	do -- FRAME
		-- Clears the OnUpdate script of a frame.
		---@param frame any
		function addon.API.Util:ClearFrameUpdate(frame)
			if not frame then
				return
			end

			--------------------------------

			frame:SetScript("OnUpdate", nil)
		end

		-- Unregisters a frame from Blizzard UI Panel windows.
		---@param frame any
		function addon.API.Util:UnregisterFrame(frame)
			UIPanelWindows[frame:GetName()] = nil
		end

		-- Returns if a frame has the given script.
		---@param frame any
		---@param scriptName string
		---@return boolean
		function addon.API.Util:FrameHasScript(frame, scriptName)
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
		function addon.API.Main:RegisterThemeUpdateWithNativeAPI(func, priority)
			if addon.API.Util.NativeAPI.RegisterThemeUpdate then
				addon.API.Util.NativeAPI:RegisterThemeUpdate(func, priority)
			else
				func()
			end
		end
	end

	do -- PERFORMANCE

	end
end
