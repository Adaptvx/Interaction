-- [!] [addon.ControlGuide] is used to display relevant keybinds for the current context.
-- [ControlGuide_Elements.lua] creates the front-end (UI)
-- for the addon.ControlGuide module.

---@class addon
local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local PrefabRegistry = addon.PrefabRegistry
local L = addon.Locales
local NS = addon.ControlGuide; addon.ControlGuide = NS

--------------------------------

NS.Elements = {}

--------------------------------

function NS.Elements:Load()
	--------------------------------
	-- CREATE ELEMENTS
	--------------------------------

	do
		do -- ELEMENTS
			InteractionFrame.ControlGuideFrame = CreateFrame("Frame", "$parent.ControlGuideFrame", InteractionFrame)
			InteractionFrame.ControlGuideFrame:SetSize(500, 35)
			InteractionFrame.ControlGuideFrame:SetPoint("BOTTOM", UIParent, 0, NS.Variables:RATIO(1.5))
			InteractionFrame.ControlGuideFrame:SetFrameStrata(NS.Variables.FRAME_STRATA)
			InteractionFrame.ControlGuideFrame:SetFrameLevel(NS.Variables.FRAME_LEVEL)

			local Frame = InteractionFrame.ControlGuideFrame

			--------------------------------

			do -- CONTENT
				Frame.Content = CreateFrame("Frame", "$parent.Content", Frame)
				Frame.Content:SetPoint("CENTER", Frame)
				Frame.Content:SetFrameStrata(NS.Variables.FRAME_STRATA)
				Frame.Content:SetFrameLevel(NS.Variables.FRAME_LEVEL + 1)
				addon.API.FrameUtil:SetDynamicSize(Frame.Content, Frame, nil, 0)
				Frame.Content:SetAlpha(.5)

				local Content = Frame.Content

				--------------------------------

				do -- LAYOUT GROUP
					Content.LayoutGroup, Content.LayoutGroup_Sort = addon.API.FrameTemplates:CreateLayoutGroup(Content, { point = "LEFT", direction = "horizontal", resize = true, padding = 0, distribute = false, distributeResizeElements = false, excludeHidden = true, autoSort = true, customOffset = nil, customLayoutSort = nil }, "$parent.LayoutGroup")
					Content.LayoutGroup:SetPoint("CENTER", Content, 0, 0)
					Content.LayoutGroup:SetFrameStrata(NS.Variables.FRAME_STRATA)
					Content.LayoutGroup:SetFrameLevel(NS.Variables.FRAME_LEVEL + 2)
					addon.API.FrameUtil:SetDynamicSize(Content.LayoutGroup, Content, nil, 0)
					addon.API.FrameUtil:SetDynamicSize(Content, Content.LayoutGroup, 0, nil)
					CallbackRegistry:Add("LayoutGroupSort ControlGuide.Content", Content.LayoutGroup_Sort)

					local LayoutGroup = Content.LayoutGroup

					--------------------------------

					do -- ELEMENTS
						local function CreateElement(name)
							local Element = PrefabRegistry:Create("ControlGuide.Element", Frame.Content, NS.Variables.FRAME_STRATA, NS.Variables.FRAME_LEVEL + 3, name)
							return Element
						end

						--------------------------------

						for i = 1, 10 do
							LayoutGroup["Element" .. i] = CreateElement(Frame.Content)
							LayoutGroup:AddElement(LayoutGroup["Element" .. i])
							table.insert(NS.Variables.Elements, LayoutGroup["Element" .. i])
						end
					end
				end
			end
		end

		do -- REFERENCES
			local Frame = InteractionFrame.ControlGuideFrame

			--------------------------------

			-- CORE
			Frame.REF_CONTENT = Frame.Content

			-- CONTENT
			Frame.REF_CONTENT_LAYOUTGROUP = Frame.Content.LayoutGroup
		end
	end

	--------------------------------
	-- REFERENCES
	--------------------------------

	local Frame = InteractionFrame.ControlGuideFrame
	local Callback = NS.Script; NS.Script = Callback

	--------------------------------
	-- SETUP
	--------------------------------

	do
		Frame:Hide()
		Frame.hidden = true
	end
end
