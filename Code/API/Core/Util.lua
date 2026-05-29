local addon = select(2, ...)

addon.API.Util = {}

addon.API.Util.RGB_RECOMMENDED = addon.API.Util.RGB_RECOMMENDED or {}
addon.API.Util.RGB_WHITE = { r = .99, g = .99, b = .99 }
addon.API.Util.RGB_BLACK = { r = .2, g = .2, b = .2 }
addon.API.Util.UI_SCALE = addon.API.Main.UIScale
addon.API.Util.IsDarkTheme = nil

do -- Theme tracking
    local function ThemeUpdate()
        addon.API.Util.IsDarkTheme = addon.API.Main:GetDarkTheme()
        addon.API.Util.RGB_RECOMMENDED = addon.API.Util.IsDarkTheme and addon.API.Util.RGB_WHITE or addon.API.Util.RGB_BLACK
    end

    ThemeUpdate()
    C_Timer.After(.1, function() addon.API.Main:RegisterThemeUpdateWithNativeAPI(ThemeUpdate, -1) end)
end

do -- String measurement & parsing
    addon.API.MeasurementFrame = CreateFrame("Frame")
    addon.API.MeasurementFrame:SetScale(addon.API.Util.UI_SCALE)
    addon.API.MeasurementFrame:SetAllPoints(UIParent)

    addon.API.MeasurementText = addon.API.MeasurementFrame:CreateFontString(nil, "OVERLAY")
    addon.API.MeasurementText:SetPoint("CENTER", addon.API.MeasurementFrame)
    addon.API.MeasurementText:Hide()

    function addon.API.Util:GetStringSize(frame, maxWidth, maxHeight)
        local rawText = frame:GetText()
        if addon.API.Util:IsSecretValue(rawText) then
            return maxWidth or 0, maxHeight or 0
        end

        local text = addon.API.Util:GetUnformattedText(rawText)
        local font, size, flags = frame:GetFont()
        local justifyH, justifyV = frame:GetJustifyH(), frame:GetJustifyV()

        addon.API.MeasurementText:SetFont(font or GameFontNormal:GetFont(), size > 0 and size or 12.5, flags or "")
        addon.API.MeasurementText:SetText(text)
        if justifyH then addon.API.MeasurementText:SetJustifyH(justifyH) end
        if justifyV then addon.API.MeasurementText:SetJustifyV(justifyV) end
        addon.API.MeasurementText:SetWidth(maxWidth or frame:GetWidth())
        addon.API.MeasurementText:SetHeight(maxHeight or 1000)

        return addon.API.MeasurementText:GetWrappedWidth(), addon.API.MeasurementText:GetStringHeight()
    end

    function addon.API.Util:GetActualStringHeight(text)
        local cleanedText = addon.API.Util:StripColorCodes(text:GetText())
        local textFrame = CreateFrame("Frame"):CreateFontString(nil, "BACKGROUND", text:GetFont())
        textFrame:SetWidth(text:GetWidth())
        textFrame:SetText(cleanedText)
        return textFrame:GetHeight()
    end

    function addon.API.Util:FindString(text, stringToSearch)
        if addon.API.Util:IsSecretValue(text) or addon.API.Util:IsSecretValue(stringToSearch) then return false end
        local found = text and stringToSearch and string.match(text, stringToSearch)
        return found and true or false
    end

    function addon.API.Util:HasVisibleText(text)
        if addon.API.Util:IsSecretValue(text) then return true end
        local match = type(text) == "string" and string.match(text, "%S")
        return match and true or false
    end

    function addon.API.Util:AreValuesEqual(valueA, valueB)
        if type(valueA) == "nil" or type(valueB) == "nil" then
            return type(valueA) == type(valueB)
        end

        local isCompared, isEqual = pcall(function()
            return valueA == valueB
        end)

        return isCompared and isEqual or false
    end

    function addon.API.Util:GetInteractionUnitToken()
        if UnitExists("npc") then return "npc" end
        if UnitExists("questnpc") then return "questnpc" end
        if addon.API.Main:IsNPCGossip() then return "npc" end
        if addon.API.Main:IsNPCQuest() then return "questnpc" end
        return nil
    end

    function addon.API.Util:IsStaticInteractionTarget()
        return addon.API.Main:IsNPCQuestOrGossip() and not UnitExists("npc") and not UnitExists("questnpc")
    end

    function addon.API.Util:GetCharacterStartIndex(str, index)
        if addon.API.Util:IsSecretValue(str) then return nil end
        local i, charCount = 1, 0
        while i <= #str do
            local byte = string.byte(str, i)
            if byte >= 0 and byte <= 127 then
                charCount = charCount + 1
                if charCount == index then return i end
                i = i + 1
            elseif byte >= 192 and byte <= 223 then
                charCount = charCount + 1
                if charCount == index then return i end
                i = i + 2
            elseif byte >= 224 and byte <= 239 then
                charCount = charCount + 1
                if charCount == index then return i end
                i = i + 3
            elseif byte >= 240 and byte <= 247 then
                charCount = charCount + 1
                if charCount == index then return i end
                i = i + 4
            else
                i = i + 1
            end
        end
        return nil
    end

    function addon.API.Util:GetCharacterEndIndex(str, index)
        local start = addon.API.Util:GetCharacterStartIndex(str, index)
        if not start then return nil end
        local byte = string.byte(str, start)
        if byte <= 127 then return start end
        if byte <= 223 then return start + 1 end
        if byte <= 239 then return start + 2 end
        if byte <= 247 then return start + 3 end
    end

    function addon.API.Util:GetSubstring(str, A, B)
        if addon.API.Util:IsSecretValue(str) then return "" end
        local startIndex = addon.API.Util:GetCharacterStartIndex(str, A)
        local endIndex = addon.API.Util:GetCharacterEndIndex(str, B)
        return startIndex and endIndex and string.sub(str, startIndex, endIndex) or ""
    end

    function addon.API.Util:RemoveAtlasMarkup(str, removeSpace)
        if addon.API.Util:IsSecretValue(str) then return "" end
        str = str or ""
        if removeSpace then
            str = string.gsub(str, "(|A.-|a )", "")
            return string.gsub(str, "(|H.-|h )", "")
        end

        str = string.gsub(str, "(|A.-|a)", "")
        return string.gsub(str, "(|H.-|h)", "")
    end
end

do -- Text formatting
    function addon.API.Util:IsSecretValue(value)
        if type(issecretvalue) ~= "function" then return false end

        local checked, isSecret = pcall(issecretvalue, value)
        if not checked or not isSecret then return false end

        if type(canaccessvalue) ~= "function" then return true end

        local accessChecked, canAccess = pcall(canaccessvalue, value)
        return not accessChecked or not canAccess
    end

    function addon.API.Util:GetValueOrFallback(value, fallback)
        if addon.API.Util:IsSecretValue(value) then return value end
        if value == nil then return fallback end
        return value
    end

    function addon.API.Util:GetDisplayValueOrFallback(value, fallback)
        if addon.API.Util:IsSecretValue(value) then return fallback end
        if value == nil then return fallback end
        return value
    end

    function addon.API.Util:GetFirstValue(valueA, valueB)
        if addon.API.Util:IsSecretValue(valueA) then return valueA end
        if valueA ~= nil then return valueA end
        return valueB
    end

    function addon.API.Util:StripColorCodes(text)
        if addon.API.Util:IsSecretValue(text) then return "" end
        if type(text) ~= "string" then return "" end
        text = string.gsub(text, "|cff%x%x%x%x%x%x%x%x", "")
        return string.gsub(text, "|r", "")
    end

    function addon.API.Util:GetHexColor(r, g, b)
        r, g, b = math.floor(r * 255), math.floor(g * 255), math.floor(b * 255)
        return string.format("%02x%02x%02x", r, g, b)
    end

    function addon.API.Util:SetHexColorFromModifier(hexColor, factor)
        local color = string.match(hexColor, "([0-9A-Fa-f]+)")
        if not color then return hexColor end
        local r = tonumber(string.sub(color, 1, 2), 16)
        local g = tonumber(string.sub(color, 3, 4), 16)
        local b = tonumber(string.sub(color, 5, 6), 16)
        r, g, b = math.max(0, math.floor(r * factor)), math.max(0, math.floor(g * factor)), math.max(0, math.floor(b * factor))
        return string.format("%02x%02x%02x", r, g, b)
    end

    function addon.API.Util:SetHexColorFromModifierWithBase(hexColor, factor, baseColor)
        local color = string.match(hexColor, "([0-9A-Fa-f]+)")
        if not color then return hexColor end
        local r = tonumber(string.sub(color, 1, 2), 16) or 0
        local g = tonumber(string.sub(color, 3, 4), 16) or 0
        local b = tonumber(string.sub(color, 5, 6), 16) or 0
        local baseR = tonumber(string.sub(baseColor, 1, 2), 16) or 0
        local baseG = tonumber(string.sub(baseColor, 3, 4), 16) or 0
        local baseB = tonumber(string.sub(baseColor, 5, 6), 16) or 0
        r = math.min(255, math.floor(r * factor + baseR * (1 - factor)))
        g = math.min(255, math.floor(g * factor + baseG * (1 - factor)))
        b = math.min(255, math.floor(b * factor + baseB * (1 - factor)))
        return string.format("%02x%02x%02x", math.max(0, r), math.max(0, g), math.max(0, b))
    end

    function addon.API.Util:GetRGBFromHexColor(hexColor)
        local r = tonumber(string.sub(hexColor, 1, 2), 16) or 0
        local g = tonumber(string.sub(hexColor, 3, 4), 16) or 0
        local b = tonumber(string.sub(hexColor, 5, 6), 16) or 0
        return { r = r / 255, g = g / 255, b = b / 255 }
    end

    function addon.API.Util:SetFont(fontString, font, size)
        if not fontString then return end
        fontString:SetFont(font, size, "")
    end

    function addon.API.Util:SetFontSize(fontString, size)
        local fontName, _, fontFlags = fontString:GetFont()
        fontString:SetFont(fontName, size, fontFlags or "")
    end

    function addon.API.Util:GetUnformattedText(text)
        if addon.API.Util:IsSecretValue(text) then return "" end
        if type(text) ~= "string" then return "" end
        text = string.gsub(text, "|c%x%x%x%x%x%x%x%x(.-)|r", "%1")
        text = string.gsub(text, "\124cn.-:", "")
        return string.gsub(text, "|H(.-)|h(.-)|h", "%2")
    end

    function addon.API.Util:GetImportantFormattedText(text)
        if addon.API.Util:IsSecretValue(text) then return "" end
        if type(text) ~= "string" then return "" end
        text = string.gsub(text, "|cff000000", "")
        return string.gsub(text, "|cffFFFFFF", "")
    end

    function addon.API.Util:SetUnformattedText(fontString)
        if fontString.IsObjectType and fontString:IsObjectType("FontString") then fontString:SetText(addon.API.Util:GetUnformattedText(fontString:GetText())) end
    end

    function addon.API.Util:ParseNumberFromString(str)
        if addon.API.Util:IsSecretValue(str) then return nil, nil end
        str = string.gsub(str, "|c%x%x%x%x%x%x%x%x(.-)|r", "%1")
        local numberString = string.match(str, "%-?%d[%d,]*")
        if not numberString then return nil, nil end
        local sign = string.find(str, "%-") and "-" or "+"
        numberString = string.gsub(numberString, "[,+%-]", "")
        return tonumber(numberString), sign
    end
end

do -- Formatting helpers
    function addon.API.Util:FormatNumber(x) return BreakUpLargeNumbers(x) end

    function addon.API.Util:FormatMoney(x)
        local gold = math.floor(x / 10000)
        local silver = math.floor((x % 10000) / 100)
        return gold, silver, x % 100
    end
end

do -- Tooltip helpers
    function addon.API.Util:AddTooltip(frame, text, location, locationX, locationY, bypassMouseResponder, wrapText)
        frame.showTooltip, frame.tooltipText, frame.tooltipActive = true, text, false
        if frame.hookedFunc then return end
        frame.hookedFunc = true

        function frame.API_ShowTooltip()
            frame.tooltipActive = true
            InteractionFrame.GameTooltip:SetOwner(frame, location, locationX, locationY)
            InteractionFrame.GameTooltip:SetText(frame.tooltipText, 1, 1, 1, 1, wrapText == nil and true or wrapText)
            InteractionFrame.GameTooltip:Show()
        end

        function frame.API_HideTooltip()
            frame.tooltipActive = false
            InteractionFrame.GameTooltip:Clear()
        end

        local function Enter() if frame.showTooltip then frame.API_ShowTooltip() else frame.API_HideTooltip() end end
        local function Leave() frame.API_HideTooltip() end
        if bypassMouseResponder then
            frame:HookScript("OnEnter", Enter)
            frame:HookScript("OnLeave", Leave)
        else
            addon.API.FrameTemplates:CreateMouseResponder(frame, { enterCallback = Enter, leaveCallback = Leave })
        end
    end

    function addon.API.Util:RemoveTooltip(frame)
        frame.showTooltip = false
        frame.tooltipText = ""
        if frame.tooltipActive then
            frame.tooltipActive = false
            frame.API_HideTooltip()
        end
    end
end

do -- Table & list helpers
    function addon.API.Util:FindItemInInventory(itemName)
        if not itemName then return nil, nil end

        local isItemNameLowered, loweredItemName = pcall(function()
            return string.lower(itemName)
        end)

        if not isItemNameLowered then
            return nil, nil
        end

        for bag = 0, 4 do
            for slot = 1, C_Container.GetContainerNumSlots(bag) do
                local itemLink = C_Container.GetContainerItemLink(bag, slot)
                if itemLink then
                    local itemNameInBag = C_Item.GetItemInfo(itemLink)
                    if itemNameInBag then
                        local isBagItemNameLowered, loweredBagItemName = pcall(function()
                            return string.lower(itemNameInBag)
                        end)

                        if isBagItemNameLowered then
                            local isMatchCompared, isMatch = pcall(function()
                                return loweredBagItemName == loweredItemName
                            end)

                            if isMatchCompared and isMatch then
                                return C_Container.GetContainerItemID(bag, slot) or nil, itemLink
                            end
                        end
                    end
                end
            end
        end
        return nil
    end

    function addon.API.Util:FindKeyPositionInTable(tbl, indexValue)
        local currentIndex = 0
        for k in pairs(tbl) do
            currentIndex = currentIndex + 1
            if k == indexValue then return currentIndex end
        end
    end

    function addon.API.Util:FindValuePositionInTable(tbl, indexValue)
        local currentIndex = 0
        for _, v in pairs(tbl) do
            currentIndex = currentIndex + 1
            if v == indexValue then return currentIndex end
        end
    end

    function addon.API.Util:FindVariableValuePositionInTable(tbl, subVariableList, value)
        for i = 1, #tbl do if addon.API.Util:GetSubVariableFromList(tbl[i], subVariableList) == value then return i end end
    end

    function addon.API.Util:GetSubVariableFromList(list, subVariableList)
        if not subVariableList or type(subVariableList) ~= "table" then return nil end
        if #subVariableList == 0 then return list end
        local currentKey = list
        for i = 1, #subVariableList do
            if currentKey == nil then break end
            currentKey = currentKey[subVariableList[i]]
        end
        return currentKey
    end

    function addon.API.Util:SortListByNumber(list, subVariableList, ascending)
        table.sort(list, function(a, b)
            local subA = addon.API.Util:GetSubVariableFromList(a, subVariableList)
            local subB = addon.API.Util:GetSubVariableFromList(b, subVariableList)
            return ascending and subA > subB or subA < subB
        end)
        return list
    end

    function addon.API.Util:SortListByAlphabeticalOrder(list, subVariableList, descending)
        table.sort(list, function(a, b)
            local subA = string.lower(addon.API.Util:GetSubVariableFromList(a, subVariableList))
            local subB = string.lower(addon.API.Util:GetSubVariableFromList(b, subVariableList))
            return descending and subA > subB or subA < subB
        end)
        return list
    end

    function addon.API.Util:FilterListByVariable(list, subVariableList, value, roughMatch, caseSensitive, customCheck)
        local filteredList = {}
        for _, entry in ipairs(list) do
            if customCheck and customCheck(entry) then
                table.insert(filteredList, entry)
            elseif roughMatch then
                local subValue = addon.API.Util:GetSubVariableFromList(entry, subVariableList)
                local lhs = caseSensitive ~= false and tostring(subValue) or string.lower(tostring(subValue))
                local rhs = caseSensitive ~= false and tostring(value) or string.lower(tostring(value))
                if addon.API.Util:FindString(lhs, rhs) then table.insert(filteredList, entry) end
            else
                local subValue = addon.API.Util:GetSubVariableFromList(entry, subVariableList)
                local lhs = caseSensitive ~= false and tostring(subValue) or string.lower(tostring(subValue))
                local rhs = caseSensitive ~= false and tostring(value) or string.lower(tostring(value))
                if lhs == rhs then table.insert(filteredList, entry) end
            end
        end
        return filteredList
    end
end

do -- Watchers
    local changeUpdateCallbacks = {}

    local function TriggerCallbacks(variableName, newValue)
        for _, entry in ipairs(changeUpdateCallbacks) do if entry.variableName == variableName then entry.callback(newValue) end end
    end

    function addon.API.Util:WatchLocalVariable(variableTable, variableName, callback)
        local mt = {
            __newindex = function(t, key, value)
                rawset(t, key, value)
                TriggerCallbacks(variableName, value)
            end,
            __index    = function(t, key) return rawget(t, key) end
        }
        setmetatable(variableTable, mt)
        changeUpdateCallbacks[#changeUpdateCallbacks + 1] = { variableName = variableName, callback = callback }
    end
end

do -- Miscellaneous
    function addon.API.Util:IsPlayerInShapeshiftForm()
        local auras = { "Cat Form", "Bear Form", "Travel Form", "Moonkin Form", "Aquatic Form", "Treant Form", "Mount Form" }
        for _, auraName in ipairs(auras) do if AuraUtil.FindAuraByName(auraName, "Player") then return true end end
        return false
    end

    function addon.API.Util:GetScreenWidth() return WorldFrame:GetWidth() end
    function addon.API.Util:GetScreenHeight() return WorldFrame:GetHeight() end
end

do -- Method chains
    function addon.API.Util:AddMethodChain(variableNames)
        local chain = {}
        for i = 1, #variableNames do
            local entry = { variable = nil }
            function entry.set(...) entry.variable = ... end
            chain[variableNames[i]] = entry
        end
        return chain
    end
end

do -- General helpers
    function addon.API.Util:tnum(tbl)
        local length = 0
        for _ in pairs(tbl) do length = length + 1 end
        return length
    end
    function addon.API.Util:rt(tbl)
        local reversed, len = {}, #tbl
        for i = len, 1, -1 do reversed[len - i + 1] = tbl[i] end
        return reversed
    end
    function addon.API.Util:gen_hash()
        local hash, chars = "", "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        for i = 1, 16 do
            local rand = math.random(1, #chars)
            hash = hash .. string.sub(chars, rand, rand)
        end
        return hash
    end
end

do -- Cvars
    function addon.API.Util:SetCVar(cvar, value) if not InCombatLockdown() and GetCVar(cvar) ~= value then SetCVar(cvar, value) end end
end

do -- Inline icons
    function addon.API.Util:InlineIcon(path, height, width, horizontalOffset, verticalOffset, type) return type == "Atlas" and CreateAtlasMarkup(path, width, height, horizontalOffset, verticalOffset) or "|T" .. path .. ":" .. height .. ":" .. width .. ":" .. horizontalOffset .. ":" .. verticalOffset .. "|t" end
    function addon.API.Util:IconOffset(iconString, newXOffset, newYOffset) return string.gsub(iconString, ":(%d+):(%d+)|a", ":" .. newXOffset .. ":" .. newYOffset .. "|a") end
end

do -- Frame helpers
    function addon.API.Util:ClearFrameUpdate(frame) if frame then frame:SetScript("OnUpdate", nil) end end
    function addon.API.Util:UnregisterFrame(frame) UIPanelWindows[frame:GetName()] = nil end
    function addon.API.Util:RegisterFrame(frame) UIPanelWindows[frame:GetName()] = frame end
    function addon.API.Util:FrameHasScript(frame, scriptName) return frame.GetScript and pcall(function() frame:GetScript(scriptName) end) or false end
end

do -- Theme registration
    function addon.API.Main:RegisterThemeUpdateWithNativeAPI(func, priority)
        if self.RegisterThemeUpdate then self:RegisterThemeUpdate(func, priority) else func() end
    end
end
