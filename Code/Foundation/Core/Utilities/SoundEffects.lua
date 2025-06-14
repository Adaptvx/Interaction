---@class addon
local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local PrefabRegistry = addon.PrefabRegistry
local L = addon.Locales

--------------------------------
-- VARIABLES
--------------------------------

addon.SoundEffects = {}
local NS = addon.SoundEffects; addon.SoundEffects = NS

do -- CONSTANTS
	NS.PATH = addon.Variables.PATH_ART .. "Audio/"

	-- READABLE UI
	do
		NS.Readable_Open = NS.PATH .. "Readable/ReadableUI_Open.mp3"
		NS.Readable_Close = NS.PATH .. "Readable/ReadableUI_Close.mp3"
		NS.Readable_Transition = NS.PATH .. "Readable/ReadableUI_Transition.mp3"

		NS.Readable_ItemUI_Slate_ChangePage = NS.PATH .. "Readable/ReadableUI_ItemUI_Slate_ChangePage.mp3"
		NS.Readable_ItemUI_Book_Flip = NS.PATH .. "Readable/ReadableUI_ItemUI_Book_Flip.mp3"
		NS.Readable_ItemUI_Book_ReverseFlip = NS.PATH .. "Readable/ReadableUI_ItemUI_Book_ReverseFlip.mp3"
		NS.Readable_ItemUI_Book_Open = NS.PATH .. "Readable/ReadableUI_ItemUI_Book_Open.mp3"
		NS.Readable_ItemUI_Book_Close = NS.PATH .. "Readable/ReadableUI_ItemUI_Book_Close.mp3"

		NS.Readable_LibraryUI_Button_Menu_Enter = NS.PATH .. "Readable/ReadableUI_LibraryUI_Button_Menu_Enter.mp3"
		NS.Readable_LibraryUI_Button_Menu_Leave = NS.PATH .. "Readable/ReadableUI_LibraryUI_Button_Menu_Leave.mp3"
		NS.Readable_LibraryUI_Button_Menu_MouseDown = NS.PATH .. "Readable/ReadableUI_LibraryUI_Button_Menu_MouseDown.mp3"
		NS.Readable_LibraryUI_Button_Menu_MouseUp = NS.PATH .. "Readable/ReadableUI_LibraryUI_Button_Menu_MouseUp.mp3"

		NS.Readable_LibraryUI_Checkbox_Enter = NS.PATH .. "Readable/ReadableUI_LibraryUI_Checkbox_Enter.mp3"
		NS.Readable_LibraryUI_Checkbox_Leave = NS.PATH .. "Readable/ReadableUI_LibraryUI_Checkbox_Leave.mp3"
		NS.Readable_LibraryUI_Checkbox_MouseDown = NS.PATH .. "Readable/ReadableUI_LibraryUI_Checkbox_MouseDown.mp3"
		NS.Readable_LibraryUI_Checkbox_MouseUp = NS.PATH .. "Readable/ReadableUI_LibraryUI_Checkbox_MouseUp.mp3"

		NS.Readable_LibraryUI_Input_Enter = NS.PATH .. "Readable/ReadableUI_LibraryUI_Input_Enter.mp3"
		NS.Readable_LibraryUI_Input_Leave = NS.PATH .. "Readable/ReadableUI_LibraryUI_Input_Leave.mp3"
		NS.Readable_LibraryUI_Input_MouseDown = NS.PATH .. "Readable/ReadableUI_LibraryUI_Input_MouseDown.mp3"
		NS.Readable_LibraryUI_Input_MouseUp = NS.PATH .. "Readable/ReadableUI_LibraryUI_Input_MouseUp.mp3"
		NS.Readable_LibraryUI_Input_ValueChanged = NS.PATH .. "Readable/ReadableUI_LibraryUI_Input_ValueChanged.mp3"

		NS.Readable_LibraryUI_NextPageButton_Enter = NS.PATH .. "Readable/ReadableUI_LibraryUI_NextPageButton_Enter.mp3"
		NS.Readable_LibraryUI_NextPageButton_Leave = NS.PATH .. "Readable/ReadableUI_LibraryUI_NextPageButton_Leave.mp3"
		NS.Readable_LibraryUI_NextPageButton_MouseDown = NS.PATH .. "Readable/ReadableUI_LibraryUI_NextPageButton_MouseDown.mp3"
		NS.Readable_LibraryUI_NextPageButton_MouseUp = NS.PATH .. "Readable/ReadableUI_LibraryUI_NextPageButton_MouseUp.mp3"

		NS.Readable_LibraryUI_PreviousPageButton_Enter = NS.PATH .. "Readable/ReadableUI_LibraryUI_PreviousPageButton_Enter.mp3"
		NS.Readable_LibraryUI_PreviousPageButton_Leave = NS.PATH .. "Readable/ReadableUI_LibraryUI_PreviousPageButton_Leave.mp3"
		NS.Readable_LibraryUI_PreviousPageButton_MouseDown = NS.PATH .. "Readable/ReadableUI_LibraryUI_PreviousPageButton_MouseDown.mp3"
		NS.Readable_LibraryUI_PreviousPageButton_MouseUp = NS.PATH .. "Readable/ReadableUI_LibraryUI_PreviousPageButton_MouseUp.mp3"

		NS.Readable_Button_Enter = NS.PATH .. "Readable/ReadableUI_Button_Enter.mp3"
		NS.Readable_Button_Leave = NS.PATH .. "Readable/ReadableUI_Button_Leave.mp3"
		NS.Readable_Button_MouseDown = NS.PATH .. "Readable/ReadableUI_Button_MouseDown.mp3"
		NS.Readable_Button_MouseUp = NS.PATH .. "Readable/ReadableUI_Button_MouseUp.mp3"
	end

	-- SETTINGS
	do
		NS.Settings_Open = NS.PATH .. "Settings/Settings_Open.mp3"
		NS.Settings_Close = NS.PATH .. "Settings/Settings_Close.mp3"

		NS.Settings_Button_Enter = NS.PATH .. "Settings/Settings_Button_Enter.mp3"
		NS.Settings_Button_Leave = NS.PATH .. "Settings/Settings_Button_Leave.mp3"
		NS.Settings_Button_MouseDown = NS.PATH .. "Settings/Settings_Button_MouseDown.mp3"
		NS.Settings_Button_MouseUp = NS.PATH .. "Settings/Settings_Button_MouseUp.mp3"

		NS.Settings_Checkbox_Enter = NS.PATH .. "Settings/Settings_Checkbox_Enter.mp3"
		NS.Settings_Checkbox_Leave = NS.PATH .. "Settings/Settings_Checkbox_Leave.mp3"
		NS.Settings_Checkbox_MouseDown = NS.PATH .. "Settings/Settings_Checkbox_MouseDown.mp3"
		NS.Settings_Checkbox_MouseUp = NS.PATH .. "Settings/Settings_Checkbox_MouseUp.mp3"

		NS.Settings_Slider_Enter = NS.PATH .. "Settings/Settings_Slider_Enter.mp3"
		NS.Settings_Slider_Leave = NS.PATH .. "Settings/Settings_Slider_Leave.mp3"
		NS.Settings_Slider_MouseDown = NS.PATH .. "Settings/Settings_Slider_MouseDown.mp3"
		NS.Settings_Slider_MouseUp = NS.PATH .. "Settings/Settings_Slider_MouseUp.mp3"
		NS.Settings_Slider_ValueChanged = NS.PATH .. "Settings/Settings_Slider_ValueChanged.mp3"

		NS.Settings_Input_Enter = NS.PATH .. "Settings/Settings_Input_Enter.mp3"
		NS.Settings_Input_Leave = NS.PATH .. "Settings/Settings_Input_Leave.mp3"
		NS.Settings_Input_MouseDown = NS.PATH .. "Settings/Settings_Input_MouseDown.mp3"
		NS.Settings_Input_MouseUp = NS.PATH .. "Settings/Settings_Input_MouseUp.mp3"
		NS.Settings_Input_ValueChanged = NS.PATH .. "Settings/Settings_Input_ValueChanged.mp3"

		NS.Settings_Dropdown_Enter = NS.PATH .. "Settings/Settings_Dropdown_Enter.mp3"
		NS.Settings_Dropdown_Leave = NS.PATH .. "Settings/Settings_Dropdown_Leave.mp3"
		NS.Settings_Dropdown_MouseDown = NS.PATH .. "Settings/Settings_Dropdown_MouseDown.mp3"
		NS.Settings_Dropdown_MouseUp = NS.PATH .. "Settings/Settings_Dropdown_MouseUp.mp3"
		NS.Settings_Dropdown_ListElementEnter = NS.PATH .. "Settings/Settings_Dropdown_ListElement_Enter.mp3"
		NS.Settings_Dropdown_ListElementLeave = NS.PATH .. "Settings/Settings_Dropdown_ListElement_Leave.mp3"
		NS.Settings_Dropdown_ListElementMouseDown = NS.PATH .. "Settings/Settings_Dropdown_ListElement_MouseDown.mp3"
		NS.Settings_Dropdown_ListElementMouseUp = NS.PATH .. "Settings/Settings_Dropdown_ListElement_MouseUp.mp3"
		NS.Settings_Dropdown_ValueChanged = NS.PATH .. "Settings/Settings_Dropdown_ValueChanged.mp3"

		NS.Settings_Keybind_Enter = NS.PATH .. "Settings/Settings_Keybind_Enter.mp3"
		NS.Settings_Keybind_Leave = NS.PATH .. "Settings/Settings_Keybind_Leave.mp3"
		NS.Settings_Keybind_MouseDown = NS.PATH .. "Settings/Settings_Keybind_MouseDown.mp3"
		NS.Settings_Keybind_MouseUp = NS.PATH .. "Settings/Settings_Keybind_MouseUp.mp3"
		NS.Settings_Keybind_ValueChanged = NS.PATH .. "Settings/Settings_Keybind_ValueChanged.mp3"

		NS.Settings_TabButton_Enter = NS.PATH .. "Settings/Settings_TabButton_Enter.mp3"
		NS.Settings_TabButton_Leave = NS.PATH .. "Settings/Settings_TabButton_Leave.mp3"
		NS.Settings_TabButton_MouseDown = NS.PATH .. "Settings/Settings_TabButton_MouseDown.mp3"
		NS.Settings_TabButton_MouseUp = NS.PATH .. "Settings/Settings_TabButton_MouseUp.mp3"
	end

	-- PROMPT
	do
		NS.Prompt_Show = NS.PATH .. "Prompt/Prompt_Show.mp3"
		NS.Prompt_Hide = NS.PATH .. "Prompt/Prompt_Hide.mp3"

		NS.Prompt_Button_Enter = NS.PATH .. "Prompt/Prompt_Button_Enter.mp3"
		NS.Prompt_Button_Leave = NS.PATH .. "Prompt/Prompt_Button_Leave.mp3"
		NS.Prompt_Button_MouseDown = NS.PATH .. "Prompt/Prompt_Button_MouseDown.mp3"
		NS.Prompt_Button_MouseUp = NS.PATH .. "Prompt/Prompt_Button_MouseUp.mp3"
	end

	-- DIALOG
	do
		NS.Dialog_Skip = NS.PATH .. "Dialog/Dialog_Skip.mp3"
		NS.Dialog_Next = NS.PATH .. "Dialog/Dialog_Next.mp3"
		NS.Dialog_Previous = NS.PATH .. "Dialog/Dialog_Previous.mp3"
		addon.SoundEffects_Dialog_Invalid = NS.PATH .. "Dialog/Dialog_Invalid.mp3"
	end

	-- GOSSIP
	do
		NS.Gossip_Button_Enter = NS.PATH .. "Gossip/Gossip_Button_Enter.mp3"
		NS.Gossip_Button_Leave = NS.PATH .. "Gossip/Gossip_Button_Leave.mp3"
		NS.Gossip_Button_MouseDown = NS.PATH .. "Gossip/Gossip_Button_MouseDown.mp3"
		NS.Gossip_Button_MouseUp = NS.PATH .. "Gossip/Gossip_Button_MouseUp.mp3"
	end

	-- QUEST
	do
		NS.Quest_Show = NS.PATH .. "Quest/Quest_Show.mp3"
		NS.Quest_Hide = NS.PATH .. "Quest/Quest_Hide.mp3"

		NS.Quest_Reward_Selected = NS.PATH .. "Quest/Quest_Reward_Selected.mp3"

		NS.Quest_Button_Enter = NS.PATH .. "Quest/Quest_Button_Enter.mp3"
		NS.Quest_Button_Leave = NS.PATH .. "Quest/Quest_Button_Leave.mp3"
		NS.Quest_Button_MouseDown = NS.PATH .. "Quest/Quest_Button_MouseDown.mp3"
		NS.Quest_Button_MouseUp = NS.PATH .. "Quest/Quest_Button_MouseUp.mp3"
	end

	-- ALERT
	do
		NS.Alert_Combat_Show = NS.PATH .. "Alert/Alert_Combat_Show.mp3"
		NS.Alert_Combat_Hide = NS.PATH .. "Alert/Alert_Combat_Hide.mp3"
		NS.Alert_InvalidQuestReward_Show = NS.PATH .. "Alert/Alert_InvalidQuestReward_Show.mp3"
		NS.Alert_InvalidQuestReward_Hide = NS.PATH .. "Alert/Alert_InvalidQuestReward_Hide.mp3"
	end

	-- ALERT NOTIFICATION
	do
		NS.AlertNotification_Show = NS.PATH .. "AlertNotification/AlertNotification_Show.mp3"
		NS.AlertNotification_Hide = NS.PATH .. "AlertNotification/AlertNotification_Hide.mp3"
	end
end

--------------------------------
-- FUNCTIONS (MAIN)
--------------------------------

function NS:Load()
	--------------------------------
	-- FUNCTIONS (MAIN)
	--------------------------------

	do
		function NS:PlaySoundFile(filePath)
			if addon.Database.DB_GLOBAL.profile.INT_AUDIO then
				if filePath then
					PlaySoundFile(filePath)
				end
			end
		end

		function NS:PlaySound(soundID)
			if addon.Database.DB_GLOBAL.profile.INT_AUDIO then
				if soundID then
					PlaySound(soundID)
				end
			end
		end
	end

	--------------------------------
	-- FUNCTIONS (FRAME)
	--------------------------------

	do
		function NS:SetButton(frame, enter, leave, mouseDown, mouseUp)
			local function Enter()
				NS:PlaySoundFile(enter)
			end

			local function Leave()
				NS:PlaySoundFile(leave)
			end

			local function MouseDown()
				NS:PlaySoundFile(mouseDown)
			end

			local function MouseUp()
				NS:PlaySoundFile(mouseUp)
			end

			--------------------------------

			if frame.enterCallbacks then
				table.insert(frame.enterCallbacks, Enter)
			else
				frame:HookScript("OnEnter", function()
					NS:PlaySoundFile(enter)
				end)
			end

			if frame.leaveCallbacks then
				table.insert(frame.leaveCallbacks, Leave)
			else
				frame:HookScript("OnLeave", function()
					NS:PlaySoundFile(leave)
				end)
			end

			if frame.mouseDownCallbacks then
				table.insert(frame.mouseDownCallbacks, MouseDown)
			else
				frame:HookScript("OnMouseDown", function()
					NS:PlaySoundFile(mouseDown)
				end)
			end

			if frame.mouseUpCallbacks then
				table.insert(frame.mouseUpCallbacks, MouseUp)
			else
				frame:HookScript("OnMouseUp", function()
					NS:PlaySoundFile(mouseUp)
				end)
			end
		end

		function NS:SetCheckbox(frame, enter, leave, mouseDown, mouseUp)
			local function Enter()
				NS:PlaySoundFile(enter)
			end

			local function Leave()
				NS:PlaySoundFile(leave)
			end

			local function MouseDown()
				NS:PlaySoundFile(mouseDown)
			end

			local function MouseUp()
				NS:PlaySoundFile(mouseUp)
			end

			--------------------------------

			if frame.enterCallbacks then
				table.insert(frame.enterCallbacks, Enter)
			else
				frame:HookScript("OnEnter", function()
					NS:PlaySoundFile(enter)
				end)
			end

			if frame.leaveCallbacks then
				table.insert(frame.leaveCallbacks, Leave)
			else
				frame:HookScript("OnLeave", function()
					NS:PlaySoundFile(leave)
				end)
			end

			if frame.mouseDownCallbacks then
				table.insert(frame.mouseDownCallbacks, MouseDown)
			else
				frame:HookScript("OnMouseDown", function()
					NS:PlaySoundFile(mouseDown)
				end)
			end

			if frame.mouseUpCallbacks then
				table.insert(frame.mouseUpCallbacks, MouseUp)
			else
				frame:HookScript("OnMouseUp", function()
					NS:PlaySoundFile(mouseUp)
				end)
			end
		end

		function NS:SetSlider(frame, enter, leave, mouseDown, mouseUp, valueChanged)
			local function Enter()
				NS:PlaySoundFile(enter)
			end

			local function Leave()
				NS:PlaySoundFile(leave)
			end

			local function MouseDown()
				NS:PlaySoundFile(mouseDown)
			end

			local function MouseUp()
				NS:PlaySoundFile(mouseUp)
			end

			local function ValueChanged()
				NS:PlaySoundFile(valueChanged)
			end

			--------------------------------

			if frame.enterCallbacks then
				table.insert(frame.enterCallbacks, Enter)
			else
				frame:HookScript("OnEnter", function()
					NS:PlaySoundFile(enter)
				end)
			end

			if frame.leaveCallbacks then
				table.insert(frame.leaveCallbacks, Leave)
			else
				frame:HookScript("OnLeave", function()
					NS:PlaySoundFile(leave)
				end)
			end

			if frame.mouseDownCallbacks then
				table.insert(frame.mouseDownCallbacks, MouseDown)
			else
				frame:HookScript("OnMouseDown", function()
					NS:PlaySoundFile(mouseDown)
				end)
			end

			if frame.mouseUpCallbacks then
				table.insert(frame.mouseUpCallbacks, MouseUp)
			else
				frame:HookScript("OnMouseUp", function()
					NS:PlaySoundFile(mouseUp)
				end)
			end

			if frame.valueChangedCallbacks then
				table.insert(frame.valueChangedCallbacks, ValueChanged)
			else
				frame:HookScript("OnValueChanged", function(self, new, userInput)
					if userInput then
						NS:PlaySoundFile(valueChanged)
					end
				end)
			end
		end

		function NS:SetInputBox(frame, enter, leave, mouseDown, mouseUp, valueChanged)
			local function Enter()
				NS:PlaySoundFile(enter)
			end

			local function Leave()
				NS:PlaySoundFile(leave)
			end

			local function MouseDown()
				NS:PlaySoundFile(mouseDown)
			end

			local function MouseUp()
				NS:PlaySoundFile(mouseUp)
			end

			local function ValueChanged()
				NS:PlaySoundFile(valueChanged)
			end

			--------------------------------

			if frame.enterCallbacks then
				table.insert(frame.enterCallbacks, Enter)
			else
				frame:HookScript("OnEnter", function()
					NS:PlaySoundFile(enter)
				end)
			end

			if frame.leaveCallbacks then
				table.insert(frame.leaveCallbacks, Leave)
			else
				frame:HookScript("OnLeave", function()
					NS:PlaySoundFile(leave)
				end)
			end

			if frame.mouseDownCallbacks then
				table.insert(frame.mouseDownCallbacks, MouseDown)
			else
				frame:HookScript("OnMouseDown", function()
					NS:PlaySoundFile(mouseDown)
				end)
			end

			if frame.mouseUpCallbacks then
				table.insert(frame.mouseUpCallbacks, MouseUp)
			else
				frame:HookScript("OnMouseUp", function()
					NS:PlaySoundFile(mouseUp)
				end)
			end

			if frame.valueChangedCallbacks then
				table.insert(frame.valueChangedCallbacks, ValueChanged)
			else
				frame:HookScript("OnTextChanged", function(self, userInput)
					if userInput then
						NS:PlaySoundFile(valueChanged)
					end
				end)
			end
		end

		function NS:SetDropdown(frame, enter, leave, mouseDown, mouseUp, listElementEnter, listElementLeave, listElementMouseDown, listElementMouseUp, valueChanged)
			local function Enter()
				NS:PlaySoundFile(enter)
			end

			local function Leave()
				NS:PlaySoundFile(leave)
			end

			local function MouseDown()
				NS:PlaySoundFile(mouseDown)
			end

			local function MouseUp()
				NS:PlaySoundFile(mouseUp)
			end

			local function ListElementEnter()
				NS:PlaySoundFile(listElementEnter)
			end

			local function ListElementLeave()
				NS:PlaySoundFile(listElementLeave)
			end

			local function ListElementMouseDown()
				NS:PlaySoundFile(listElementMouseDown)
			end

			local function ListElementMouseUp()
				NS:PlaySoundFile(listElementMouseUp)
			end

			local function ValueChanged()
				NS:PlaySoundFile(valueChanged)
			end

			--------------------------------

			if frame.enterCallbacks then
				table.insert(frame.enterCallbacks, Enter)
			else
				frame:HookScript("OnEnter", function()
					NS:PlaySoundFile(enter)
				end)
			end

			if frame.leaveCallbacks then
				table.insert(frame.leaveCallbacks, Leave)
			else
				frame:HookScript("OnLeave", function()
					NS:PlaySoundFile(leave)
				end)
			end

			if frame.mouseDownCallbacks then
				table.insert(frame.mouseDownCallbacks, MouseDown)
			else
				frame:HookScript("OnMouseDown", function()
					NS:PlaySoundFile(mouseDown)
				end)
			end

			if frame.mouseUpCallbacks then
				table.insert(frame.mouseUpCallbacks, MouseUp)
			else
				frame:HookScript("OnMouseUp", function()
					NS:PlaySoundFile(mouseUp)
				end)
			end

			if frame.enterCallbacks_listElement then
				table.insert(frame.enterCallbacks_listElement, ListElementEnter)
			end

			if frame.leaveCallbacks_listElement then
				table.insert(frame.leaveCallbacks_listElement, ListElementLeave)
			end

			if frame.mouseDownCallbacks_listElement then
				table.insert(frame.mouseDownCallbacks_listElement, ListElementMouseDown)
			end

			if frame.mouseUpCallbacks_listElement then
				table.insert(frame.mouseUpCallbacks_listElement, ListElementMouseUp)
			end

			if frame.valueChangedCallbacks then
				table.insert(frame.valueChangedCallbacks, ValueChanged)
			end
		end

		function NS:SetKeybind(frame, enter, leave, mouseDown, mouseUp, valueChanged)
			local function Enter()
				NS:PlaySoundFile(enter)
			end

			local function Leave()
				NS:PlaySoundFile(leave)
			end

			local function MouseDown()
				NS:PlaySoundFile(mouseDown)
			end

			local function MouseUp()
				NS:PlaySoundFile(mouseUp)
			end

			local function ValueChanged()
				NS:PlaySoundFile(valueChanged)
			end

			--------------------------------

			if frame.enterCallbacks then
				table.insert(frame.enterCallbacks, Enter)
			else
				frame:HookScript("OnEnter", function()
					NS:PlaySoundFile(enter)
				end)
			end

			if frame.leaveCallbacks then
				table.insert(frame.leaveCallbacks, Leave)
			else
				frame:HookScript("OnLeave", function()
					NS:PlaySoundFile(leave)
				end)
			end

			if frame.mouseDownCallbacks then
				table.insert(frame.mouseDownCallbacks, MouseDown)
			else
				frame:HookScript("OnMouseDown", function()
					NS:PlaySoundFile(mouseDown)
				end)
			end

			if frame.mouseUpCallbacks then
				table.insert(frame.mouseUpCallbacks, MouseUp)
			else
				frame:HookScript("OnMouseUp", function()
					NS:PlaySoundFile(mouseUp)
				end)
			end

			if frame.valueChangedCallbacks then
				table.insert(frame.valueChangedCallbacks, ValueChanged)
			end
		end
	end
end
