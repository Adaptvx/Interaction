---@class addon
local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local PrefabRegistry = addon.PrefabRegistry
local L = addon.Locales

--------------------------------
-- VARIABLES
--------------------------------

addon.Get = {}
local NS = addon.Get; addon.Get = NS

do -- MAIN

end

do -- CONSTANTS

end

--------------------------------
-- FUNCTIONS (MAIN)
--------------------------------

function NS:Load()
	--------------------------------
	-- FUNCTIONS (MAIN)
	--------------------------------

	do
		function NS.Blizzard_GossipButtons()
			local GossipFrameButtons = {}

			--------------------------------

			GossipFrame.GreetingPanel.ScrollBox:ForEachFrame(function(self)
				local elementData = self:GetElementData()

				--------------------------------

				if elementData.buttonType ~= GOSSIP_BUTTON_TYPE_DIVIDER and elementData.buttonType ~= GOSSIP_BUTTON_TYPE_TITLE then
					table.insert(GossipFrameButtons, self)

					--------------------------------

					addon.InteractionFrame.SetReferences(self)
				end
			end)

			--------------------------------

			return GossipFrameButtons
		end

		function NS.Blizzard_QuestButtons()
			local Result = {}

			--------------------------------
			-- RETAIL
			--------------------------------

			if not addon.Variables.IS_WOW_VERSION_CLASSIC_ALL then
				local NumButtons = 0
				local Frame = QuestFrameGreetingPanel

				--------------------------------

				for button in Frame.titleButtonPool:EnumerateActive() do
					NumButtons = NumButtons + 1

					--------------------------------

					table.insert(Result, button)

					--------------------------------

					addon.InteractionFrame.SetReferences(button)
				end
			end

			--------------------------------
			-- CLASSIC
			--------------------------------

			if addon.Variables.IS_WOW_VERSION_CLASSIC_ALL then
				local IsQuestTitleButtons = (QuestTitleButton1)
				local NumButtons = 0

				--------------------------------

				if IsQuestTitleButtons then
					local buttons = {}

					--------------------------------

					for i = 1, 40 do
						if _G["QuestTitleButton" .. i] and _G["QuestTitleButton" .. i]:IsVisible() then
							NumButtons = NumButtons + 1

							--------------------------------

							local CurrentFrame = _G["QuestTitleButton" .. i]

							--------------------------------

							table.insert(buttons, CurrentFrame)
						end
					end

					--------------------------------

					Result = buttons
				end
			end

			--------------------------------

			return Result
		end
	end

	--------------------------------
	-- EVENTS
	--------------------------------

	do

	end
end
