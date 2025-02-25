local addonName, addon = ...
local PrefabRegistry = addon.PrefabRegistry
local CallbackRegistry = addon.CallbackRegistry
local L = addon.Locales
local NS = addon.GameTooltip

--------------------------------

NS.Script = {}

--------------------------------

function NS.Script:Load()
	--------------------------------
	-- REFERENCES
	--------------------------------

	local InteractionFrame_GameTooltip = InteractionFrame.GameTooltip
	local InteractionFrame_ShoppingTooltip1 = InteractionFrame.ShoppingTooltip1
	local InteractionFrame_ShoppingTooltip2 = InteractionFrame.ShoppingTooltip2
	local Callback = NS.Script

	--------------------------------
	-- FUNCTIONS (MAIN)
	--------------------------------

	do
		-- Blizzard_SharedXMLGame -> Tooltip -> TooltipComparisonManager.lua

		local TooltipComparisonManager = {}

		function TooltipComparisonManager:CreateComparisonItem(tooltipData)
			local comparisonItem
			if tooltipData and tooltipData.type == Enum.TooltipDataType.Item then
				if tooltipData.guid then
					comparisonItem = { guid = tooltipData.guid, overrideItemLevel = tooltipData.overrideItemLevel }
				elseif tooltipData.hyperlink and tooltipData.hyperlink ~= "" then
					comparisonItem = { hyperlink = tooltipData.hyperlink, overrideItemLevel = tooltipData.overrideItemLevel }
				end
			end
			return comparisonItem
		end

		function TooltipComparisonManager:Initialize(tooltip, anchorFrame)
			self.tooltip = tooltip
			self.anchorFrame = anchorFrame or self.tooltip
			for i, shoppingTooltip in ipairs(self.tooltip.shoppingTooltips) do
				shoppingTooltip:SetOwner(self.tooltip, "ANCHOR_NONE", 0, 0)
				shoppingTooltip:ClearAllPoints()
			end
		end

		function TooltipComparisonManager:Clear(tooltip)
			-- if no tooltip specific, clear any
			if self.tooltip and (self.tooltip == tooltip or not tooltip) then
				self.comparisonItem = nil
				self.comparisonIndex = nil
				self.compareInfo = nil
				self.anchorFrame = nil

				for i, shoppingTooltip in ipairs(self.tooltip.shoppingTooltips) do
					shoppingTooltip:Hide()
				end

				self.tooltip = nil
			end
		end

		function TooltipComparisonManager:AnchorShoppingTooltips(primaryShown, secondaryShown)
			local tooltip = self.tooltip
			local primaryTooltip = tooltip.shoppingTooltips[1]
			local secondaryTooltip = tooltip.shoppingTooltips[2]

			addon.API.FrameUtil:SetVisibility(primaryTooltip, primaryShown)
			addon.API.FrameUtil:SetVisibility(secondaryTooltip, secondaryShown)
			primaryTooltip:SetAlpha(0)
			secondaryTooltip:SetAlpha(0)

			local sideAnchorFrame = self.anchorFrame
			if self.anchorFrame.IsEmbedded then
				sideAnchorFrame = self.anchorFrame:GetParent():GetParent()
			end

			local leftPos = sideAnchorFrame:GetLeft()
			local rightPos = sideAnchorFrame:GetRight()

			local selfLeftPos = tooltip:GetLeft()
			local selfRightPos = tooltip:GetRight()

			-- if we get the Left, we have the Right
			if leftPos and selfLeftPos then
				leftPos = math.min(selfLeftPos, leftPos) -- get the left most bound
				rightPos = math.max(selfRightPos, rightPos) -- get the right most bound
			else
				leftPos = leftPos or selfLeftPos or 0
				rightPos = rightPos or selfRightPos or 0
			end

			-- sometimes the sideAnchorFrame is an actual tooltip, and sometimes it's a script region, so make sure we're getting the actual anchor type
			local anchorType = sideAnchorFrame.GetAnchorType and sideAnchorFrame:GetAnchorType() or tooltip:GetAnchorType()

			local totalWidth = 0
			if primaryShown then
				totalWidth = totalWidth + primaryTooltip:GetWidth()
			end
			if secondaryShown then
				totalWidth = totalWidth + secondaryTooltip:GetWidth()
			end

			local rightDist = 0
			local screenWidth = GetScreenWidth()
			rightDist = screenWidth - rightPos

			-- find correct side
			local side
			if anchorType and (totalWidth < leftPos) and (anchorType == "ANCHOR_LEFT" or anchorType == "ANCHOR_TOPLEFT" or anchorType == "ANCHOR_BOTTOMLEFT") then
				side = "left"
			elseif anchorType and (totalWidth < rightDist) and (anchorType == "ANCHOR_RIGHT" or anchorType == "ANCHOR_TOPRIGHT" or anchorType == "ANCHOR_BOTTOMRIGHT") then
				side = "right"
			elseif rightDist < leftPos then
				side = "left"
			else
				side = "right"
			end

			-- see if we should slide the tooltip
			if totalWidth > 0 and (anchorType and anchorType ~= "ANCHOR_PRESERVE") then --we never slide a tooltip with a preserved anchor
				local slideAmount = 0
				if ((side == "left") and (totalWidth > leftPos)) then
					slideAmount = totalWidth - leftPos
				elseif ((side == "right") and (rightPos + totalWidth) > screenWidth) then
					slideAmount = screenWidth - (rightPos + totalWidth)
				end

				if slideAmount ~= 0 then -- if we calculated a slideAmount, we need to slide
					if sideAnchorFrame.SetAnchorType then
						sideAnchorFrame:SetAnchorType(anchorType, slideAmount, 0)
					else
						tooltip:SetAnchorType(anchorType, slideAmount, 0)
					end
				end
			end

			if secondaryShown then
				primaryTooltip:SetPoint("TOP", self.anchorFrame, 0, 0)
				secondaryTooltip:SetPoint("TOP", self.anchorFrame, 0, 0)
				if side and side == "left" then
					primaryTooltip:SetPoint("RIGHT", sideAnchorFrame, "LEFT", -15, 0)
				else
					secondaryTooltip:SetPoint("LEFT", sideAnchorFrame, "RIGHT", 15, 0)
				end

				if side and side == "left" then
					secondaryTooltip:SetPoint("TOPRIGHT", primaryTooltip, "TOPLEFT", -15, 0)
				else
					primaryTooltip:SetPoint("TOPLEFT", secondaryTooltip, "TOPRIGHT", 15, 0)
				end
			else
				primaryTooltip:SetPoint("TOP", self.anchorFrame, 0, 0)
				if side and side == "left" then
					primaryTooltip:SetPoint("RIGHT", sideAnchorFrame, "LEFT", -15, 0)
				else
					primaryTooltip:SetPoint("LEFT", sideAnchorFrame, "RIGHT", 15, 0)
				end
			end
		end

		-- ITEM
		function TooltipComparisonManager:CompareItem(comparisonItem, tooltip, anchorFrame)
			if not comparisonItem then
				self:Clear()
				return
			end

			self:Initialize(tooltip, anchorFrame)

			if self:IsComparisonItemDifferent(comparisonItem) then
				self.comparisonItem = comparisonItem
				self.compareInfo = C_TooltipComparison.GetItemComparisonInfo(comparisonItem)
				self.comparisonIndex = 1
			end

			self:RefreshItems()
		end

		function TooltipComparisonManager:RefreshItems()
			if not self.compareInfo then
				return
			end

			local isPrimaryTooltip = true
			local primaryShown = self:SetItemTooltip(isPrimaryTooltip)
			local secondaryShown = self:SetItemTooltip(not isPrimaryTooltip)
			self:AnchorShoppingTooltips(primaryShown, secondaryShown)
		end

		function TooltipComparisonManager:IsComparisonItemDifferent(comparisonItem)
			if not self.comparisonItem or not comparisonItem then
				return true
			end

			if self.comparisonItem.guid and comparisonItem.guid then
				return self.comparisonItem.guid ~= comparisonItem.guid
			end

			if self.comparisonItem.hyperlink and comparisonItem.hyperlink then
				return self.comparisonItem.hyperlink ~= comparisonItem.hyperlink
			end

			return true
		end

		function TooltipComparisonManager:GetSecondaryItem()
			local item = self.compareInfo.additionalItems[self.comparisonIndex]
			if not item and self.comparisonIndex > 1 then
				self.comparisonIndex = 1
				item = self.compareInfo.additionalItems[self.comparisonIndex]
			end
			return item
		end

		function TooltipComparisonManager:GetComparisonItemData(displayedItem)
			if displayedItem then
				if displayedItem.guid then
					return C_TooltipInfo.GetItemByGUID(displayedItem.guid)
				elseif displayedItem.hyperlink then
					return C_TooltipInfo.GetHyperlink(displayedItem.hyperlink)
				end
			end
			return nil
		end

		function TooltipComparisonManager:SetItemTooltip(isPrimaryTooltip)
			local tooltip, displayedItem
			if isPrimaryTooltip then
				displayedItem = self.compareInfo.item
				tooltip = self.tooltip.shoppingTooltips[1]
			else
				displayedItem = self:GetSecondaryItem()
				tooltip = self.tooltip.shoppingTooltips[2]
			end

			local comparisonMethod = self.compareInfo.method

			local tooltipData = self:GetComparisonItemData(displayedItem)
			if not tooltipData then
				return
			end

			tooltip:ClearLines()

			local isPairedItem = comparisonMethod == Enum.TooltipComparisonMethod.WithBagMainHandItem or comparisonMethod == Enum.TooltipComparisonMethod.WithBagOffHandItem

			-- header
			local header = CURRENTLY_EQUIPPED
			if not isPrimaryTooltip and isPairedItem then
				header = IF_EQUIPPED_TOGETHER
			end
			local noWrapText = false
			GameTooltip_AddDisabledLine(tooltip, header, noWrapText)

			-- the item
			local tooltipInfo = {
				tooltipData = tooltipData,
				append = true,
			}
			tooltip:ProcessInfo(tooltipInfo)

			-- delta stats
			-- always for primary tooltip, secondary only if it's not a combined comparison
			if isPrimaryTooltip or comparisonMethod == Enum.TooltipComparisonMethod.Single then
				local additionalItem = comparisonMethod ~= Enum.TooltipComparisonMethod.Single and self:GetSecondaryItem() or nil
				local delta = C_TooltipComparison.GetItemComparisonDelta(self.comparisonItem, displayedItem, additionalItem, isPairedItem)
				if delta and #delta > 0 then
					-- summary header
					local summaryHeader = ITEM_DELTA_DESCRIPTION
					if isPrimaryTooltip and comparisonMethod == Enum.TooltipComparisonMethod.WithBothHands then
						summaryHeader = ITEM_DELTA_MULTIPLE_COMPARISON_DESCRIPTION
					end
					GameTooltip_AddBlankLineToTooltip(tooltip)
					GameTooltip_AddNormalLine(tooltip, summaryHeader)
					-- additional item?
					if isPairedItem and additionalItem then
						local formatString = ITEM_DELTA_DUAL_WIELD_COMPARISON_MAINHAND_DESCRIPTION
						if comparisonMethod == Enum.TooltipComparisonMethod.WithBagOffHandItem then
							formatString = ITEM_DELTA_DUAL_WIELD_COMPARISON_OFFHAND_DESCRIPTION
						end
						local itemName = C_Item.GetItemNameByID(additionalItem.guid or additionalItem.hyperlink)
						local itemQuality = C_Item.GetItemQualityByID(additionalItem.guid or additionalItem.hyperlink)
						if itemName then
							local itemQualityColor = ITEM_QUALITY_COLORS[itemQuality]
							local hexColor = itemQualityColor.color:GenerateHexColor()
							GameTooltip_AddBlankLineToTooltip(tooltip)
							GameTooltip_AddNormalLine(tooltip, formatString:format(hexColor, itemName))
						end
					end
					-- the stats
					for i, deltaLine in ipairs(delta) do
						GameTooltip_AddHighlightLine(tooltip, deltaLine)
					end

					-- cyclable items?
					if #self.compareInfo.additionalItems > 1 and GetCVarBool("allowCompareWithToggle") then
						GameTooltip_AddBlankLineToTooltip(tooltip)
						local bindKey = GetBindingKeyForAction("ITEMCOMPARISONCYCLING")
						if bindKey and bindKey ~= "" then
							local formatString = ITEM_COMPARISON_SWAP_ITEM_MAINHAND_DESCRIPTION
							if comparisonMethod == Enum.TooltipComparisonMethod.WithBagOffHandItem then
								formatString = ITEM_COMPARISON_SWAP_ITEM_OFFHAND_DESCRIPTION
							end
							GameTooltip_AddDisabledLine(tooltip, formatString:format(bindKey))
						else
							local text = ITEM_COMPARISON_CYCLING_DISABLED_MSG_MAINHAND
							if comparisonMethod == Enum.TooltipComparisonMethod.WithBagOffHandItem then
								text = ITEM_COMPARISON_CYCLING_DISABLED_MSG_OFFHAND
							end
							GameTooltip_AddDisabledLine(tooltip, text)
						end
					end
				end
			end

			return true
		end

		function InteractionFrame_GameTooltip:ShowComparison(self, anchorFrame)
			local tooltip = self or InteractionFrame_GameTooltip
			local tooltipData = tooltip:GetPrimaryTooltipData()
			local comparisonItem = TooltipComparisonManager:CreateComparisonItem(tooltipData)
			TooltipComparisonManager:CompareItem(comparisonItem, tooltip, anchorFrame)
		end

		function InteractionFrame_GameTooltip:HideComparison()
			TooltipComparisonManager:Clear()
		end

		function InteractionFrame_GameTooltip:Clear()
			InteractionFrame_GameTooltip:Hide()
			TooltipComparisonManager:Clear()
		end
	end

	--------------------------------
	-- FUNCTIONS (ANIMATION)
	--------------------------------

	do
		do -- GAME TOOLTIP
			InteractionFrame_GameTooltip.hidden = true

			function InteractionFrame_GameTooltip:ShowWithAnimation_StopEvent()
				return InteractionFrame_GameTooltip.hidden
			end

			function InteractionFrame_GameTooltip:HideWithAnimation_StopEvent()
				return not InteractionFrame_GameTooltip.hidden
			end

			function InteractionFrame_GameTooltip:ShowWithAnimation()
				if not InteractionFrame_GameTooltip.hidden then
					return
				end
				InteractionFrame_GameTooltip.hidden = false

				--------------------------------

				addon.API.Animation:Fade(InteractionFrame_GameTooltip, .125, 0, 1, nil, InteractionFrame_GameTooltip.ShowWithAnimation_StopEvent)
			end

			function InteractionFrame_GameTooltip:HideWithAnimation()
				if InteractionFrame_GameTooltip.hidden then
					return
				end
				InteractionFrame_GameTooltip.hidden = true

				--------------------------------

				GameTooltip:SetAlpha(0)
			end

			hooksecurefunc(InteractionFrame_GameTooltip, "Show", InteractionFrame_GameTooltip.ShowWithAnimation)
			hooksecurefunc(InteractionFrame_GameTooltip, "Hide", InteractionFrame_GameTooltip.HideWithAnimation)
		end

		do -- SHOPPING TOOLTIP 1
			InteractionFrame_ShoppingTooltip1.hidden = true

			function InteractionFrame_ShoppingTooltip1:ShowWithAnimation_StopEvent()
				return InteractionFrame_ShoppingTooltip1.hidden
			end

			function InteractionFrame_ShoppingTooltip1:HideWithAnimation_StopEvent()
				return not InteractionFrame_ShoppingTooltip1.hidden
			end

			function InteractionFrame_ShoppingTooltip1:ShowWithAnimation()
				if not InteractionFrame_ShoppingTooltip1.hidden then
					return
				end
				InteractionFrame_ShoppingTooltip1.hidden = false

				--------------------------------

				addon.API.Animation:Fade(InteractionFrame_ShoppingTooltip1, .125, 0, 1, nil, InteractionFrame_ShoppingTooltip1.ShowWithAnimation_StopEvent)
			end

			function InteractionFrame_ShoppingTooltip1:HideWithAnimation()
				if InteractionFrame_ShoppingTooltip1.hidden then
					return
				end
				InteractionFrame_ShoppingTooltip1.hidden = true

				--------------------------------

				InteractionFrame_ShoppingTooltip1:SetAlpha(0)
			end

			hooksecurefunc(InteractionFrame_ShoppingTooltip1, "Show", InteractionFrame_ShoppingTooltip1.ShowWithAnimation)
			hooksecurefunc(InteractionFrame_ShoppingTooltip1, "Hide", InteractionFrame_ShoppingTooltip1.HideWithAnimation)
		end

		do -- SHOPPING TOOLTIP 2
			InteractionFrame_ShoppingTooltip2.hidden = true

			function InteractionFrame_ShoppingTooltip2:ShowWithAnimation_StopEvent()
				return InteractionFrame_ShoppingTooltip2.hidden
			end

			function InteractionFrame_ShoppingTooltip2:HideWithAnimation_StopEvent()
				return not InteractionFrame_ShoppingTooltip2.hidden
			end

			function InteractionFrame_ShoppingTooltip2:ShowWithAnimation()
				if not InteractionFrame_ShoppingTooltip2.hidden then
					return
				end
				InteractionFrame_ShoppingTooltip2.hidden = false

				--------------------------------

				addon.API.Animation:Fade(InteractionFrame_ShoppingTooltip2, .25, 0, 1, nil, InteractionFrame_ShoppingTooltip2.ShowWithAnimation_StopEvent)
			end

			function InteractionFrame_ShoppingTooltip2:HideWithAnimation()
				if InteractionFrame_ShoppingTooltip2.hidden then
					return
				end
				InteractionFrame_ShoppingTooltip2.hidden = true

				--------------------------------

				InteractionFrame_ShoppingTooltip2:SetAlpha(0)
			end

			hooksecurefunc(InteractionFrame_ShoppingTooltip2, "Show", InteractionFrame_ShoppingTooltip2.ShowWithAnimation)
			hooksecurefunc(InteractionFrame_ShoppingTooltip2, "Hide", InteractionFrame_ShoppingTooltip2.HideWithAnimation)
		end
	end

	--------------------------------
	-- EVENTS
	--------------------------------

	do
		hooksecurefunc(InteractionFrame_GameTooltip, "Hide", InteractionFrame_GameTooltip.HideComparison)
	end

	--------------------------------
	-- SETUP
	--------------------------------
end
