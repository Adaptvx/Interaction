local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local TemplateRegistry = addon.TemplateRegistry
local L = addon.Locales
local NS = addon.Interaction.Quest; addon.Interaction.Quest = NS

NS.Templates = {}

function NS.Templates:Load()
    do -- Button container
        do -- Button
            TemplateRegistry:Add("Quest.ButtonContainer.Button", function(parent, color, highlightColor, color_darkTheme, highlightColor_darkTheme, frameStrata, frameLevel, name)
                local Frame = CreateFrame("Button", name, parent, "UIPanelButtonTemplate")
                Frame.Text = _G[Frame:GetDebugName() .. "Text"]

                addon.API.FrameTemplates.Styles:Button(Frame, {
                    defaultTexture       = addon.API.Presets.NINESLICE_INSCRIBED_FILLED_HIGHLIGHT,
                    highlightTexture     = addon.API.Presets.NINESLICE_INSCRIBED_FILLED_HIGHLIGHT,
                    edgeSize             = 25,
                    scale                = .5,
                    playAnimation        = false,
                    customColor          = color,
                    customHighlightColor = highlightColor,
                    customTextColor      = addon.Theme.RGB_WHITE
                })

                addon.API.Main:RegisterThemeUpdate(function()
                                                       local FilledColor
                                                       local FilledHighlightColor

                                                       if addon.Theme.IsDarkTheme then
                                                           FilledColor = color_darkTheme
                                                           FilledHighlightColor = highlightColor_darkTheme
                                                       else
                                                           FilledColor = color
                                                           FilledHighlightColor = highlightColor
                                                       end

                                                       addon.API.FrameTemplates.Styles:UpdateButton(Frame, {
                                                           customColor          = FilledColor,
                                                           customHighlightColor = FilledHighlightColor
                                                       })
                                                   end, 3)

                return Frame
            end)
        end
    end

    do -- Storyline
        local PADDING = NS.Variables:RATIO(9)
        local BACKGROUND_ALPHA_DEFAULT = .125
        local BACKGROUND_ALPHA_HIGHLIGHT = .25
        local BACKGROUND_ALPHA_CLICK = .175

        TemplateRegistry:Add("Quest.Storyline", function(parent, frameStrata, frameLevel, name)
            local Frame = CreateFrame("Frame", name, parent)
            Frame:SetFrameStrata(frameStrata)
            Frame:SetFrameLevel(frameLevel + 1)

            do -- Elements
                do -- Content
                    Frame.Content = CreateFrame("Frame", "$parent.Content", Frame)
                    Frame.Content:SetPoint("CENTER", Frame)
                    Frame.Content:SetFrameStrata(frameStrata)
                    Frame.Content:SetFrameLevel(frameLevel + 2)
                    addon.API.FrameUtil:SetDynamicSize(Frame.Content, Frame, 0, 0)

                    local Content = Frame.Content

                    do -- Background
                        Content.Background, Content.BackgroundTexture = addon.API.FrameTemplates:CreateNineSlice(Content, frameStrata, NS.Variables.THEME.INSCRIBED_BACKGROUND, 25, .5, "$parent.Background")
                        Content.Background:SetAllPoints(Content, true)
                        Content.Background:SetFrameStrata(frameStrata)
                        Content.Background:SetFrameLevel(frameLevel + 3)
                        Content.Background:SetAlpha(BACKGROUND_ALPHA_DEFAULT)
                    end

                    do -- Content
                        Content.Content = CreateFrame("Frame", "$parent.Content", Content)
                        Content.Content:SetPoint("CENTER", Content)
                        Content.Content:SetFrameStrata(frameStrata)
                        Content.Content:SetFrameLevel(frameLevel + 5)
                        Content.Content:SetAlpha(.5)
                        addon.API.FrameUtil:SetDynamicSize(Content.Content, Content, (PADDING * 2), (PADDING * 2))

                        local Subcontent = Content.Content

                        do -- Layout group
                            Subcontent.LayoutGroup = addon.API.FrameTemplates:CreateLayoutGroup(Subcontent, { point = "LEFT", direction = "horizontal", resize = false, padding = (PADDING / 2), distribute = false, distributeResizeElements = false, excludeHidden = true, autoSort = true, customOffset = nil, customLayoutSort = nil }, "$parent.LayoutGroup")
                            Subcontent.LayoutGroup:SetPoint("CENTER", Subcontent)
                            Subcontent.LayoutGroup:SetFrameStrata(frameStrata)
                            Subcontent.LayoutGroup:SetFrameLevel(frameLevel + 6)
                            addon.API.FrameUtil:SetDynamicSize(Subcontent.LayoutGroup, Subcontent, 0, 0)

                            local LayoutGroup = Subcontent.LayoutGroup

                            do -- Image frame
                                LayoutGroup.ImageFrame = CreateFrame("Frame", "$parent.ImageFrame", LayoutGroup)
                                LayoutGroup.ImageFrame:SetFrameStrata(frameStrata)
                                LayoutGroup.ImageFrame:SetFrameLevel(frameLevel + 7)
                                addon.API.FrameUtil:SetDynamicSize(LayoutGroup.ImageFrame, LayoutGroup, function(relativeWidth, relativeHeight) return relativeHeight - 2.5 end, function(relativeWidth, relativeHeight) return relativeHeight - 2.5 end)
                                LayoutGroup:AddElement(LayoutGroup.ImageFrame)

                                local ImageFrame = LayoutGroup.ImageFrame

                                do -- Background
                                    ImageFrame.Background, ImageFrame.BackgroundTexture = addon.API.FrameTemplates:CreateTexture(ImageFrame, frameStrata, nil, "$parent.Background")
                                    ImageFrame.Background:SetAllPoints(ImageFrame, true)
                                    ImageFrame.Background:SetFrameStrata(frameStrata)
                                    ImageFrame.Background:SetFrameLevel(frameLevel + 8)
                                end
                            end

                            do -- Text frame
                                LayoutGroup.TextFrame = CreateFrame("Frame", "$parent.TextFrame", LayoutGroup)
                                LayoutGroup.TextFrame:SetFrameStrata(frameStrata)
                                LayoutGroup.TextFrame:SetFrameLevel(frameLevel + 7)
                                addon.API.FrameUtil:SetDynamicSize(LayoutGroup.TextFrame, LayoutGroup, function(relativeWidth, relativeHeight) return relativeWidth end, function(relativeWidth, relativeHeight) return relativeHeight - 2.5 end)
                                LayoutGroup:AddElement(LayoutGroup.TextFrame)

                                local TextFrame = LayoutGroup.TextFrame

                                do -- Text
                                    TextFrame.Text = addon.API.FrameTemplates:CreateText(TextFrame, addon.Theme.RGB_WHITE, 15, "LEFT", "MIDDLE", GameFontNormal:GetFont())
                                    TextFrame.Text:SetAllPoints(TextFrame, true)
                                end
                            end
                        end
                    end
                end
            end

            do -- Animations
                do -- On enter

                    function Frame:Animation_OnEnter_StopEvent()
                        return not Frame.isMouseOver
                    end

                    function Frame:Animation_OnEnter(skipAnimation)
                        if skipAnimation then
                            Frame.Content.Background:SetAlpha(BACKGROUND_ALPHA_HIGHLIGHT)
                        else
                            addon.API.Animation:Fade(Frame.Content.Background, .125, Frame.Content.Background:GetAlpha(), BACKGROUND_ALPHA_HIGHLIGHT, nil, Frame.Animation_OnEnter_StopEvent)
                        end
                    end
                end

                do -- On leave

                    function Frame:Animation_OnLeave_StopEvent()
                        return Frame.isMouseOver
                    end

                    function Frame:Animation_OnLeave(skipAnimation)
                        if skipAnimation then
                            Frame.Content.Background:SetAlpha(BACKGROUND_ALPHA_DEFAULT)
                        else
                            addon.API.Animation:Fade(Frame.Content.Background, .125, Frame.Content.Background:GetAlpha(), BACKGROUND_ALPHA_DEFAULT, nil, Frame.Animation_OnLeave_StopEvent)
                        end
                    end
                end

                do -- On mouse down

                    function Frame:Animation_OnMouseDown_StopEvent()
                        return not Frame.isMouseDown
                    end

                    function Frame:Animation_OnMouseDown(skipAnimation)
                        if skipAnimation then
                            Frame.Content.Background:SetAlpha(BACKGROUND_ALPHA_CLICK)
                        else
                            addon.API.Animation:Fade(Frame.Content.Background, .125, Frame.Content.Background:GetAlpha(), BACKGROUND_ALPHA_CLICK, nil, Frame.Animation_OnEnter_StopEvent)
                        end
                    end
                end

                do -- On mouse up

                    function Frame:Animation_OnMouseUp_StopEvent()
                        return Frame.isMouseDown
                    end

                    function Frame:Animation_OnMouseUp(skipAnimation)
                        if skipAnimation then
                            if Frame.isMouseOver then
                                Frame.Content.Background:SetAlpha(BACKGROUND_ALPHA_HIGHLIGHT)
                            else
                                Frame.Content.Background:SetAlpha(BACKGROUND_ALPHA_DEFAULT)
                            end
                        else
                            if Frame.isMouseOver then
                                addon.API.Animation:Fade(Frame.Content.Background, .125, Frame.Content.Background:GetAlpha(), BACKGROUND_ALPHA_HIGHLIGHT, nil, Frame.Animation_OnEnter_StopEvent)
                            else
                                addon.API.Animation:Fade(Frame.Content.Background, .125, Frame.Content.Background:GetAlpha(), BACKGROUND_ALPHA_DEFAULT, nil, Frame.Animation_OnEnter_StopEvent)
                            end
                        end
                    end
                end
            end

            do -- Logic
                Frame.enabled = false
                Frame.isMouseOver = false
                Frame.isMouseDown = false

                Frame.onEnabledCallbacks = {}
                Frame.enterCallbacks = {}
                Frame.leaveCallbacks = {}
                Frame.mouseDownCallbacks = {}
                Frame.mouseUpCallbacks = {}
                Frame.clickCallbacks = {}

                do -- Functions
                    do -- Set

                        function Frame:SetEnabled(enabled)
                            Frame.enabled = enabled

                            if enabled then
                                Frame:Leave(true, true)
                            else
                                Frame:Leave(true, true)
                            end
                        end

                        function Frame:SetClick(callback)
                            Frame.clickCallbacks = {}
                            table.insert(Frame.clickCallbacks, callback)
                        end

                        function Frame:SetInfo(text, image, enabled, tooltipText, callback)
                            do -- Set
                                if image then
                                    Frame.Content.Content.LayoutGroup.ImageFrame:Show(); Frame.Content.Content.LayoutGroup.ImageFrame.BackgroundTexture:SetTexture(image)
                                else
                                    Frame.Content.Content.LayoutGroup.ImageFrame:Hide()
                                end
                                if text then Frame.Content.Content.LayoutGroup.TextFrame.Text:SetText(text) end

                                local IMAGE_WIDTH = Frame.Content.Content.LayoutGroup.ImageFrame:GetWidth()
                                local TEXT_WIDTH = Frame.Content.Content.LayoutGroup.TextFrame.Text:GetStringWidth()

                                Frame:SetSize(PADDING + (image and (IMAGE_WIDTH + PADDING / 2) or 0) + (TEXT_WIDTH or 0) + PADDING, 27.5)
                                Frame.Content.Content.LayoutGroup:Sort()
                            end

                            do -- Enabled
                                Frame:SetEnabled(enabled)

                                if enabled then
                                    Frame:SetClick(callback)

                                    addon.API.Util:AddTooltip(Frame, tooltipText, "ANCHOR_BOTTOM", 0, -12.5, false, false)
                                else
                                    addon.API.Util:RemoveTooltip(Frame)
                                end
                            end
                        end
                    end

                    do -- Logic

                    end
                end

                do -- Events

                    function Frame:Enter(bypass, skipAnimation)
                        if bypass or Frame.enabled then
                            Frame.isMouseOver = true

                            Frame:Animation_OnEnter(skipAnimation)

                            do -- On enter
                                if #Frame.enterCallbacks >= 1 then
                                    local enterCallbacks = Frame.enterCallbacks

                                    for callback = 1, #enterCallbacks do
                                        enterCallbacks[callback](Frame)
                                    end
                                end
                            end
                        end
                    end

                    function Frame:Leave(bypass, skipAnimation)
                        if bypass or Frame.enabled then
                            Frame.isMouseOver = false

                            Frame:Animation_OnLeave(skipAnimation)

                            do -- On leave
                                if #Frame.leaveCallbacks >= 1 then
                                    local leaveCallbacks = Frame.leaveCallbacks

                                    for callback = 1, #leaveCallbacks do
                                        leaveCallbacks[callback](Frame)
                                    end
                                end
                            end
                        end
                    end

                    function Frame:MouseDown(bypass, skipAnimation)
                        if bypass or Frame.enabled then
                            Frame.isMouseDown = true

                            Frame:Animation_OnMouseDown(skipAnimation)

                            do -- On mouse down
                                if #Frame.mouseDownCallbacks >= 1 then
                                    local mouseDownCallbacks = Frame.mouseDownCallbacks

                                    for callback = 1, #mouseDownCallbacks do
                                        mouseDownCallbacks[callback](Frame)
                                    end
                                end
                            end
                        end
                    end

                    function Frame:MouseUp(bypass, skipAnimation)
                        if bypass or Frame.enabled then
                            Frame.isMouseDown = false

                            Frame:Animation_OnMouseUp(skipAnimation)

                            do -- On mouse up
                                if #Frame.mouseUpCallbacks >= 1 then
                                    local mouseUpCallbacks = Frame.mouseUpCallbacks

                                    for callback = 1, #mouseUpCallbacks do
                                        mouseUpCallbacks[callback](Frame)
                                    end
                                end
                            end

                            do -- On click
                                Frame:Click()
                            end
                        end
                    end

                    function Frame:Click()
                        do -- On click
                            if #Frame.clickCallbacks >= 1 then
                                local clickCallbacks = Frame.clickCallbacks

                                for callback = 1, #clickCallbacks do
                                    clickCallbacks[callback](Frame)
                                end
                            end
                        end
                    end

                    addon.API.FrameTemplates:CreateMouseResponder(Frame, { enterCallback = Frame.Enter, leaveCallback = Frame.Leave, mouseDownCallback = Frame.MouseDown, mouseUpCallback = Frame.MouseUp })
                end
            end

            do -- Setup
                Frame:Leave(true, true)
                Frame:SetEnabled(false)
            end

            return Frame
        end)
    end

    do -- Content
        local PADDING = NS.Variables:RATIO(6.5)
        local TITLE_TEXT_SIZE = 25
        local CONTENT_TEXT_SIZE = 15
        local TOOLTIP_TEXT_SIZE = 12.5

        do -- Header
            TemplateRegistry:Add("Quest.Content.Header", function(parent, scrollFrame, frameStrata, frameLevel, name)
                local Frame = CreateFrame("Frame", name, parent)
                Frame:SetHeight(NS.Variables:RATIO(5.25))
                Frame:SetFrameStrata(frameStrata)
                Frame:SetFrameLevel(frameLevel + 1)
                addon.API.FrameUtil:SetDynamicSize(Frame, scrollFrame, 0, nil)

                do -- Elements
                    do -- Background
                        Frame.Background, Frame.BackgroundTexture = addon.API.FrameTemplates:CreateNineSlice(Frame, "HIGH", NS.Variables.THEME.INSCRIBED_HEADER, 86, .125, "$parent.Header", Enum.UITextureSliceMode.Stretched)
                        Frame.Background:SetPoint("TOPLEFT", Frame, -3.75, 2.5)
                        Frame.Background:SetPoint("BOTTOMRIGHT", Frame, 3.75, -2.5)
                        Frame.Background:SetFrameStrata(frameStrata)
                        Frame.Background:SetFrameLevel(frameLevel)
                    end

                    do -- Text
                        Frame.Text = addon.API.FrameTemplates:CreateText(Frame, { r = 1, g = 1, b = 1 }, 15, "LEFT", "MIDDLE", GameFontNormal:GetFont())
                        Frame.Text:SetPoint("TOPLEFT", Frame, (PADDING / 2), -(PADDING / 2))
                        Frame.Text:SetPoint("BOTTOMRIGHT", Frame, -(PADDING / 2), (PADDING / 2))
                        Frame.Text:SetAlpha(.75)
                    end
                end

                do -- Animations

                end

                do -- Logic
                    do -- Functions
                        do -- Set

                            function Frame:SetText(text)
                                Frame.Text:SetText(text)
                            end
                        end
                    end

                    do -- Events

                    end
                end

                do -- Setup

                end

                return Frame
            end)
        end

        do -- Header (REWARD)
            local HEADER_REWARD_PADDING = NS.Variables:RATIO(7.5)

            TemplateRegistry:Add("Quest.Content.Header.Reward", function(parent, scrollFrame, frameStrata, frameLevel, name)
                local Frame = CreateFrame("Frame", name, parent)
                Frame:SetHeight(NS.Variables:RATIO(6.5))
                Frame:SetFrameStrata(frameStrata)
                Frame:SetFrameLevel(frameLevel + 1)
                addon.API.FrameUtil:SetDynamicSize(Frame, scrollFrame, 0, nil)

                do -- Elements
                    do -- Background
                        Frame.Background, Frame.BackgroundTexture = addon.API.FrameTemplates:CreateNineSlice(Frame, frameStrata, nil, 50, 3.25, "$parent.Background")
                        addon.API.FrameUtil:SetDynamicSize(Frame.Background, Frame, 0, 0)

                        addon.API.Main:RegisterThemeUpdate(function()
                                                               local COLOR_Background

                                                               if addon.Theme.IsDarkTheme then
                                                                   COLOR_Background = addon.Theme.Quest.Highlight_Tertiary_DarkTheme
                                                               else
                                                                   COLOR_Background = addon.Theme.Quest.Highlight_Tertiary_LightTheme
                                                               end

                                                               Frame.BackgroundTexture:SetVertexColor(COLOR_Background.r, COLOR_Background.g, COLOR_Background.b, COLOR_Background.a)
                                                           end, 5)
                    end

                    do -- Text
                        Frame.Text = addon.API.FrameTemplates:CreateText(Frame, { r = 1, g = 1, b = 1 }, CONTENT_TEXT_SIZE, "LEFT", "MIDDLE", GameFontNormal:GetFont(), "$parent.Label")
                        Frame.Text:SetPoint("CENTER", Frame)
                        Frame.Text:SetAlpha(.75)
                        addon.API.FrameUtil:SetDynamicSize(Frame.Text, Frame, 0, HEADER_REWARD_PADDING)
                    end
                end

                do -- Animations

                end

                do -- Logic
                    do -- Functions

                    end

                    do -- Events

                    end
                end

                do -- Setup

                end

                return Frame
            end)
        end

        do -- Reward
            local REWARD_PADDING = NS.Variables:RATIO(9.5)
            local TEXT_PADDING = NS.Variables:RATIO(7.5)

            TemplateRegistry:Add("Quest.Content.Reward", function(parent, selectable, frameStrata, frameLevel, name)
                local Frame = CreateFrame("Frame", name, parent)
                Frame:SetHeight(NS.Variables:RATIO(5.5))
                Frame:SetPoint("CENTER", parent)
                Frame:SetFrameStrata(frameStrata)
                Frame:SetFrameLevel(frameLevel + 1)
                addon.API.FrameUtil:SetDynamicSize(Frame, parent, 0, nil)

                do -- Elements
                    do -- Background
                        Frame.Background, Frame.BackgroundTexture = addon.API.FrameTemplates:CreateNineSlice(Frame, frameStrata, NS.Variables.THEME.INSCRIBED_BACKGROUND, 50, 3.25, "$parent.Background")
                        Frame.Background:SetPoint("TOPLEFT", Frame, -1.25, 1.25)
                        Frame.Background:SetPoint("BOTTOMRIGHT", Frame, 1.25, -1.25)
                        Frame.Background:SetFrameStrata(frameStrata)
                        Frame.Background:SetFrameLevel(frameLevel)
                    end

                    do -- Image
                        Frame.Image = CreateFrame("Frame", "$parent.Image", Frame)
                        Frame.Image:SetPoint("LEFT", Frame)
                        Frame.Image:SetFrameStrata(frameStrata)
                        Frame.Image:SetFrameLevel(frameLevel + 2)
                        addon.API.FrameUtil:SetDynamicSize(Frame.Image, Frame, function(relativeWidth, relativeHeight) return relativeHeight - 2.5 end, function(relativeWidth, relativeHeight) return relativeHeight - 2.5 end)

                        do -- Background
                            Frame.Image.Background, Frame.Image.BackgroundTexture = addon.API.FrameTemplates:CreateTexture(Frame.Image, frameStrata, addon.API.Presets.BASIC_SQUARE, "$parent.Background")
                            Frame.Image.Background:SetAllPoints(Frame.Image, true)
                            Frame.Image.Background:SetFrameStrata(frameStrata)
                            Frame.Image.Background:SetFrameLevel(frameLevel + 2)
                        end

                        do -- Icon
                            Frame.Image.Icon, Frame.Image.IconTexture = addon.API.FrameTemplates:CreateTexture(Frame.Image, frameStrata, nil, "$parent.Texture")
                            Frame.Image.Icon:SetPoint("TOPLEFT", Frame.Image, (REWARD_PADDING / 2), -(REWARD_PADDING / 2))
                            Frame.Image.Icon:SetPoint("BOTTOMRIGHT", Frame.Image, -(REWARD_PADDING / 2), (REWARD_PADDING / 2))
                            Frame.Image.Icon:SetFrameStrata(frameStrata)
                            Frame.Image.Icon:SetFrameLevel(frameLevel + 3)
                            Frame.Image.IconTexture:SetTexCoord(.15, .85, .15, .85)
                        end

                        do -- Corner
                            Frame.Image.Corner, Frame.Image.CornerTexture = addon.API.FrameTemplates:CreateTexture(Frame.Image.Icon, frameStrata, addon.Variables.PATH_ART .. "Icons\\gold.png", "$parent.Corner", 2)
                            Frame.Image.Corner:SetPoint("TOPRIGHT", Frame.Image.Icon, (REWARD_PADDING / 1.5), (REWARD_PADDING / 1.5))
                            Frame.Image.Corner:SetPoint("BOTTOMLEFT", Frame.Image.Icon, (REWARD_PADDING * 3.5), (REWARD_PADDING * 3.5))
                            Frame.Image.Corner:SetFrameStrata(frameStrata)
                            Frame.Image.Corner:SetFrameLevel(frameLevel + 4)
                            Frame.Image.Corner:Hide()
                            Frame.Image.CornerTexture:SetTexCoord(.05, .95, .05, .95)
                        end

                        do -- Text
                            Frame.Image.Text = CreateFrame("Frame", "$parent.Text", Frame.Image)
                            Frame.Image.Text:SetPoint("BOTTOM", Frame.Image, 0, REWARD_PADDING / 2)
                            Frame.Image.Text:SetFrameStrata(frameStrata)
                            Frame.Image.Text:SetFrameLevel(frameLevel + 4)
                            addon.API.FrameUtil:SetDynamicSize(Frame.Image.Text, Frame.Image, function(relativeWidth, relativeHeight) return relativeWidth - REWARD_PADDING end, function(relativeWidth, relativeHeight) return relativeHeight / (addon.Variables.GOLDEN_RATIO ^ 2) end)

                            do -- Background
                                Frame.Image.Text.Background, Frame.Image.Text.BackgroundTexture = addon.API.FrameTemplates:CreateTexture(Frame.Image.Text, "HIGH", addon.API.Presets.BASIC_SQUARE, "$parent.Background")
                                Frame.Image.Text.Background:SetAllPoints(Frame.Image.Text, true)
                                Frame.Image.Text.Background:SetFrameStrata(frameStrata)
                                Frame.Image.Text.Background:SetFrameLevel(frameLevel + 5)
                                Frame.Image.Text.BackgroundTexture:SetVertexColor(.1, .1, .1, .825)
                            end

                            do -- Label
                                Frame.Image.Text.Label = addon.API.FrameTemplates:CreateText(Frame.Image.Text, { r = 1, g = 1, b = 1 }, TOOLTIP_TEXT_SIZE, "CENTER", "MIDDLE", GameFontNormal:GetFont(), "$parent.Label")
                                Frame.Image.Text.Label:SetAllPoints(Frame.Image.Text, true)
                            end
                        end
                    end

                    do -- Label
                        Frame.Label = addon.API.FrameTemplates:CreateText(Frame, { r = 1, g = 1, b = 1 }, 15, "LEFT", "MIDDLE", GameFontNormal:GetFont())
                        Frame.Label:SetPoint("LEFT", Frame, Frame.Image:GetWidth() + TEXT_PADDING, 0)
                        Frame.Label:SetAlpha(.75)
                        addon.API.FrameUtil:SetDynamicSize(Frame.Label, Frame, function(relativeWidth, relativeHeight) return relativeWidth - TEXT_PADDING - Frame.Image:GetWidth() - TEXT_PADDING end, 0)
                    end

                    do -- Highlight
                        Frame.Highlight = CreateFrame("Frame", "$parent.Highlight", Frame)
                        Frame.Highlight:SetAllPoints(Frame, true)
                        Frame.Highlight:SetFrameStrata(frameStrata)
                        Frame.Highlight:SetFrameLevel(frameLevel + 2)

                        do -- Background
                            Frame.Highlight.Background, Frame.Highlight.BackgroundTexture = addon.API.FrameTemplates:CreateTexture(Frame.Highlight, "HIGH", NS.Variables.QUEST_PATH .. "reward-highlight-add.png", "$parent.Texture")
                            Frame.Highlight.Background:SetAllPoints(Frame.Highlight, true)
                            Frame.Highlight.Background:SetFrameStrata(frameStrata)
                            Frame.Highlight.Background:SetFrameLevel(frameLevel + 99)

                            Frame.Highlight.BackgroundTexture:SetBlendMode("ADD")
                        end
                    end
                end

                do -- Animations
                    do -- On enter

                        function Frame:Animation_OnEnter_StopEvent()
                            return not Frame.isMouseOver
                        end

                        function Frame.Animation_OnEnter(skipAnimation)
                            if skipAnimation then
                                Frame.Highlight:SetAlpha(1)
                            else
                                addon.API.Animation:Fade(Frame.Highlight, .075, Frame.Highlight:GetAlpha(), 1, addon.API.Animation.EaseExpo, Frame.Animation_OnEnter_StopEvent)
                            end
                        end
                    end

                    do -- On leave

                        function Frame:Animation_OnLeave_StopEvent()
                            return Frame.isMouseOver
                        end

                        function Frame.Animation_OnLeave(skipAnimation)
                            if skipAnimation then
                                Frame.Highlight:SetAlpha(0)
                            else
                                addon.API.Animation:Fade(Frame.Highlight, .075, Frame.Highlight:GetAlpha(), 0, addon.API.Animation.EaseSine, Frame.Animation_OnLeave_StopEvent)
                            end
                        end
                    end

                    do -- On mouse down

                        function Frame:Animation_OnMouseDown_StopEvent()
                            return not Frame.isMouseDown
                        end

                        function Frame.Animation_OnMouseDown(skipAnimation)

                        end
                    end

                    do -- On mouse up

                        function Frame:Animation_OnMouseUp_StopEvent()
                            return Frame.isMouseDown
                        end

                        function Frame.Animation_OnMouseUp(skipAnimation)

                        end
                    end
                end

                do -- Logic
                    Frame.index = nil
                    Frame.type = nil
                    Frame.callback = nil
                    Frame.quality = nil
                    Frame.state = "DEFAULT"
                    Frame.selectionState = "DEFAULT"

                    Frame.isMouseOver = false
                    Frame.isMouseDown = false

                    Frame.enterCallbacks = {}
                    Frame.leaveCallbacks = {}
                    Frame.mouseDownCallbacks = {}
                    Frame.mouseUpCallbacks = {}
                    Frame.clickCallbacks = {}

                    do -- Functions
                        do -- Set

                        end

                        do -- Get

                        end

                        do -- Logic

                            function Frame:SetState(state, SelectionState)
                                Frame.state = state
                                Frame.selectionState = SelectionState

                                Frame:UpdateState()
                            end

                            function Frame:SetStateAuto()
                                if not Frame.type or not Frame.index then
                                    return
                                end

                                local type = Frame.type
                                local index = Frame.index

                                local state
                                local selectionState
                                local selectedReward = QuestInfoFrame.itemChoice

                                do -- State
                                    if type ~= "spell" then
                                        local name, texture, count, quality, isUsable, itemID = GetQuestItemInfo(type, index)

                                        if addon.Variables.IS_WOW_VERSION_CLASSIC_ALL and not isUsable then
                                            state = "INVALID"
                                        else
                                            state = "DEFAULT"
                                        end
                                    else
                                        state = "DEFAULT"
                                    end
                                end

                                do -- State (SELECTION)
                                    if selectedReward == index then
                                        selectionState = "SELECTED"
                                    else
                                        selectionState = "DEFAULT"
                                    end
                                end

                                Frame:SetState(state, selectionState)
                                Frame:UpdateState()
                            end

                            function Frame:UpdateState()
                                local state = Frame.state
                                local selectionState = Frame.selectionState

                                do -- State
                                    if state == "DEFAULT" then
                                        local quality = Frame.Quality
                                        local bestPrice = Frame.BestPrice
                                        local qualityColors = {
                                            [0] = { addon.Theme.Quest.Gradient_Quality_Poor_Start, addon.Theme.Quest.Gradient_Quality_Poor_End, addon.Theme.Quest.Text_Quality_Poor },
                                            [1] = { addon.Theme.Quest.Gradient_Quality_Common_Start, addon.Theme.Quest.Gradient_Quality_Common_End, addon.Theme.Quest.Text_Quality_Common },
                                            [2] = { addon.Theme.Quest.Gradient_Quality_Uncommon_Start, addon.Theme.Quest.Gradient_Quality_Uncommon_End, addon.Theme.Quest.Text_Quality_Uncommon },
                                            [3] = { addon.Theme.Quest.Gradient_Quality_Rare_Start, addon.Theme.Quest.Gradient_Quality_Rare_End, addon.Theme.Quest.Text_Quality_Rare },
                                            [4] = { addon.Theme.Quest.Gradient_Quality_Epic_Start, addon.Theme.Quest.Gradient_Quality_Epic_End, addon.Theme.Quest.Text_Quality_Epic },
                                            [5] = { addon.Theme.Quest.Gradient_Quality_Legendary_Start, addon.Theme.Quest.Gradient_Quality_Legendary_End, addon.Theme.Quest.Text_Quality_Legendary },
                                            [6] = { addon.Theme.Quest.Gradient_Quality_Artifact_Start, addon.Theme.Quest.Gradient_Quality_Artifact_End, addon.Theme.Quest.Text_Quality_Artifact },
                                            [7] = { addon.Theme.Quest.Gradient_Quality_Heirloom_Start, addon.Theme.Quest.Gradient_Quality_Heirloom_End, addon.Theme.Quest.Text_Quality_Heirloom },
                                            [8] = { addon.Theme.Quest.Gradient_Quality_WoWToken_Start, addon.Theme.Quest.Gradient_Quality_WoWToken_End, addon.Theme.Quest.Text_Quality_WoWToken }
                                        }

                                        local colors = qualityColors[quality] or (addon.Theme.IsDarkTheme and { addon.Theme.Quest.Highlight_Primary_DarkTheme, addon.Theme.Quest.Highlight_Secondary_DarkTheme, addon.Theme.RGB_WHITE } or { addon.Theme.Quest.Highlight_Primary_LightTheme, addon.Theme.Quest.Highlight_Secondary_LightTheme, addon.Theme.RGB_WHITE })
                                        local GRADIENT_Start, GRADIENT_End, COLOR_Text = unpack(colors)

                                        local COLOR_Background = addon.Theme.IsDarkTheme and addon.Theme.Quest.Highlight_Tertiary_DarkTheme or addon.Theme.Quest.Highlight_Tertiary_LightTheme
                                        local COLOR_Image = { r = 1, g = 1, b = 1, a = 1 }

                                        Frame.Label:SetTextColor(COLOR_Text.r, COLOR_Text.g, COLOR_Text.b, 1)
                                        Frame.BackgroundTexture:SetVertexColor(COLOR_Background.r, COLOR_Background.g, COLOR_Background.b, COLOR_Background.a)
                                        Frame.Image.IconTexture:SetVertexColor(COLOR_Image.r, COLOR_Image.g, COLOR_Image.b, COLOR_Image.a)
                                        if Frame.Image.CornerTexture then
                                            Frame.Image.CornerTexture:SetVertexColor(COLOR_Image.r, COLOR_Image.g, COLOR_Image.b, COLOR_Image.a)
                                            if bestPrice then
                                                Frame.Image.Corner:Show()
                                            else
                                                Frame.Image.Corner:Hide()
                                            end
                                        end
                                        Frame.Image.BackgroundTexture:SetGradient("VERTICAL", GRADIENT_Start, GRADIENT_End)
                                    end

                                    if state == "INVALID" then
                                        local COLOR_Background
                                        local COLOR_Image
                                        local GRADIENT_START_Image_Background
                                        local GRADIENT_END_Image_Background

                                        if addon.Theme.IsDarkTheme then
                                            COLOR_Background = addon.Theme.Quest.Invalid_Tertiary_DarkTheme
                                            COLOR_Image = addon.Theme.Quest.Invalid_Tint_DarkTheme

                                            local colorStart = addon.Theme.Quest.Invalid_Primary_DarkTheme
                                            local colorEnd = addon.Theme.Quest.Invalid_Secondary_DarkTheme
                                            GRADIENT_START_Image_Background = CreateColor(colorStart.r, colorStart.g, colorStart.b, colorStart.a)
                                            GRADIENT_END_Image_Background = CreateColor(colorEnd.r, colorEnd.g, colorEnd.b, colorEnd.a)
                                        else
                                            COLOR_Background = addon.Theme.Quest.Invalid_Tertiary_LightTheme
                                            COLOR_Image = addon.Theme.Quest.Invalid_Tint_DarkTheme

                                            local colorStart = addon.Theme.Quest.Invalid_Primary_LightTheme
                                            local colorEnd = addon.Theme.Quest.Invalid_Secondary_LightTheme
                                            GRADIENT_START_Image_Background = CreateColor(colorStart.r, colorStart.g, colorStart.b, colorStart.a)
                                            GRADIENT_END_Image_Background = CreateColor(colorEnd.r, colorEnd.g, colorEnd.b, colorEnd.a)
                                        end

                                        Frame.BackgroundTexture:SetVertexColor(COLOR_Background.r, COLOR_Background.g, COLOR_Background.b, COLOR_Background.a)
                                        Frame.Image.IconTexture:SetVertexColor(COLOR_Image.r, COLOR_Image.g, COLOR_Image.b, COLOR_Image.a)
                                        Frame.Image.BackgroundTexture:SetGradient("VERTICAL", GRADIENT_START_Image_Background, GRADIENT_END_Image_Background)
                                    end
                                end

                                do -- State (SELECTION)
                                    local isSelectable = selectable
                                    local numChoices = NS.Variables.Num_Choice
                                    local selectedReward = QuestInfoFrame.itemChoice

                                    local currentAlpha = Frame:GetAlpha()
                                    local targetAlpha = 1

                                    if selectionState == "SELECTED" or selectedReward == 0 then
                                        targetAlpha = 1
                                    elseif isSelectable and numChoices > 1 then
                                        targetAlpha = .25
                                    end

                                    if currentAlpha ~= targetAlpha then
                                        addon.API.Animation:Fade(Frame, .25, currentAlpha, targetAlpha, addon.API.Animation.EaseExpo)
                                    else
                                        Frame:SetAlpha(targetAlpha)
                                    end
                                end
                            end
                        end
                    end

                    do -- Events
                        local function GetRewardTooltip()
                            local useBlizzardTooltip = addon.Database.DB_GLOBAL and addon.Database.DB_GLOBAL.profile.INT_BLIZZARD_TOOLTIP
                            return useBlizzardTooltip and GameTooltip or InteractionFrame.GameTooltip
                        end

                        local function Logic_OnEnter()
                            local tooltip = GetRewardTooltip()
                            tooltip.RewardButton = Frame
                            InteractionFrame.GameTooltip.RewardButton = Frame

                            if Frame.callback then
                                local rewardType = NS.Script:GetQuestRewardType(Frame.type, Frame.index)
                                local useBlizzardTooltip = addon.Database.DB_GLOBAL and addon.Database.DB_GLOBAL.profile.INT_BLIZZARD_TOOLTIP

                                if useBlizzardTooltip then
                                    tooltip:SetOwner(Frame, "ANCHOR_RIGHT", 0, 0)
                                else
                                    tooltip:SetOwner(Frame, "ANCHOR_TOPRIGHT", 0, 0)
                                end

                                if (Frame.type == "spell") then
                                    if (Frame.callback.factionID) then
                                        local wrapText = false
                                        GameTooltip_SetTitle(tooltip, QUEST_REPUTATION_REWARD_TITLE:format(Frame.callback.factionName), HIGHLIGHT_FONT_COLOR, wrapText)
                                        if C_Reputation.IsAccountWideReputation(Frame.callback.factionID) then
                                            GameTooltip_AddColoredLine(tooltip, REPUTATION_TOOLTIP_ACCOUNT_WIDE_LABEL, ACCOUNT_WIDE_FONT_COLOR)
                                        end
                                        GameTooltip_AddNormalLine(tooltip, QUEST_REPUTATION_REWARD_TOOLTIP:format(Frame.callback.rewardAmount, Frame.callback.factionName))
                                    elseif (Frame.garrFollowerID or Frame.callback.garrFollowerID or Frame.callback.followerID) then
                                        local followerID = Frame.garrFollowerID or Frame.callback.garrFollowerID or Frame.callback.followerID
                                        local followerInfo = C_Garrison.GetFollowerInfo(followerID)
                                        if followerInfo then
                                            GameTooltip_SetTitle(tooltip, followerInfo.name, HIGHLIGHT_FONT_COLOR)
                                            if followerInfo.className then
                                                GameTooltip_AddNormalLine(tooltip, followerInfo.className)
                                            end
                                            if REWARD_FOLLOWER then
                                                GameTooltip_AddBlankLineToTooltip(tooltip)
                                                GameTooltip_AddColoredLine(tooltip, REWARD_FOLLOWER, QUEST_REWARD_CONTEXT_FONT_COLOR)
                                            end
                                        end
                                    elseif (Frame.rewardSpellID or Frame.callback.rewardSpellID) then
                                        local spellID = Frame.rewardSpellID or Frame.callback.rewardSpellID
                                        tooltip:SetSpellByID(spellID)
                                    end
                                elseif (rewardType == "item") then
                                    tooltip:SetQuestItem(Frame.callback.type, Frame.callback:GetID())
                                    if tooltip.ShowComparison then
                                        tooltip:ShowComparison(tooltip)
                                    end
                                elseif (rewardType == "currency") then
                                    local callbackType = Frame.callback and Frame.callback.type
                                    if callbackType == "reward" then
                                        pcall(tooltip.SetQuestCurrency, tooltip, callbackType, Frame.callback:GetID())
                                    end
                                end

                                if (Frame.callback.rewardContextLine) then
                                    GameTooltip_AddBlankLineToTooltip(tooltip)
                                    GameTooltip_AddColoredLine(tooltip, Frame.callback.rewardContextLine, QUEST_REWARD_CONTEXT_FONT_COLOR)
                                end

                                tooltip:Show()
                                CursorUpdate(Frame.callback)

                                if InteractionFrame.QuestFrame.UpdateGameTooltip then InteractionFrame.QuestFrame:UpdateGameTooltip() end
                            end

                            CallbackRegistry:Trigger("QUEST_REWARD_HIGHLIGHTED", Frame)
                        end

                        local function Logic_OnLeave()
                            local tooltip = GetRewardTooltip()
                            tooltip.RewardButton = nil
                            InteractionFrame.GameTooltip.RewardButton = nil

                            tooltip:Hide()
                            InteractionFrame.GameTooltip:Hide()
                            if InteractionFrame.QuestFrame.UpdateGameTooltip then InteractionFrame.QuestFrame:UpdateGameTooltip() end
                        end

                        local function Logic_OnMouseDown()

                        end

                        local function Logic_OnMouseUp()
                            Frame.callback:Click()

                            if Frame.type == "choice" then
                                InteractionFrame.QuestFrame:SetChoiceSelected(Frame)
                            end

                            CallbackRegistry:Trigger("QUEST_REWARD_SELECTED", Frame)

                            addon.SoundEffects:PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
                        end

                        function Frame:OnEnter(skipAnimation)
                            Frame.isMouseOver = true

                            Frame.Animation_OnEnter(skipAnimation)
                            Logic_OnEnter()

                            do -- On enter
                                if #Frame.enterCallbacks >= 1 then
                                    local enterCallbacks = Frame.enterCallbacks

                                    for callback = 1, #enterCallbacks do
                                        enterCallbacks[callback](skipAnimation)
                                    end
                                end
                            end
                        end

                        function Frame:OnLeave(skipAnimation)
                            Frame.isMouseOver = false

                            Frame.Animation_OnLeave(skipAnimation)
                            Logic_OnLeave()

                            do -- On leave
                                if #Frame.leaveCallbacks >= 1 then
                                    local leaveCallbacks = Frame.leaveCallbacks

                                    for callback = 1, #leaveCallbacks do
                                        leaveCallbacks[callback](skipAnimation)
                                    end
                                end
                            end
                        end

                        function Frame:OnMouseDown(button, skipAnimation)
                            Frame.isMouseDown = true

                            Frame.Animation_OnMouseDown(skipAnimation)
                            Logic_OnMouseDown()

                            do -- On mouse down
                                if #Frame.mouseDownCallbacks >= 1 then
                                    local mouseDownCallbacks = Frame.mouseDownCallbacks

                                    for callback = 1, #mouseDownCallbacks do
                                        mouseDownCallbacks[callback](skipAnimation)
                                    end
                                end
                            end
                        end

                        function Frame:OnMouseUp(button, skipAnimation)
                            Frame.isMouseDown = false

                            Frame.Animation_OnMouseUp(skipAnimation)
                            Logic_OnMouseUp()

                            do -- On mouse up
                                if #Frame.mouseUpCallbacks >= 1 then
                                    local mouseUpCallbacks = Frame.mouseUpCallbacks

                                    for callback = 1, #mouseUpCallbacks do
                                        mouseUpCallbacks[callback](skipAnimation)
                                    end
                                end
                            end

                            do -- On click
                                if #Frame.clickCallbacks >= 1 then
                                    local clickCallbacks = Frame.clickCallbacks

                                    for callback = 1, #clickCallbacks do
                                        clickCallbacks[callback](skipAnimation)
                                    end
                                end
                            end
                        end

                        addon.API.FrameTemplates:CreateMouseResponder(Frame, { enterCallback = Frame.OnEnter, leaveCallback = Frame.OnLeave, mouseDownCallback = Frame.OnMouseDown, mouseUpCallback = Frame.OnMouseUp })
                        CallbackRegistry:Add("START_QUEST", function() Frame:SetStateAuto() end, 0)
                        CallbackRegistry:Add("QUEST_REWARD_SELECTED", function() Frame:SetStateAuto() end, 0)
                        addon.API.Main:RegisterThemeUpdate(Frame.UpdateState, 10)
                    end
                end

                do -- Setup
                    Frame.OnLeave(true)
                end

                return Frame
            end)
        end
    end
end
