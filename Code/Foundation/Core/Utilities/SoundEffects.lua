local addon = select(2, ...)

addon.SoundEffects = {}
local NS = addon.SoundEffects; addon.SoundEffects = NS

function NS:Load()

	-- Main
	----------------------------------------------------------------------------------------------------

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

	-- Frame
	----------------------------------------------------------------------------------------------------

	function NS:SetButton(frame)
		local function MouseUp()
			NS:PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
		end

		if frame.mouseUpCallbacks then
			table.insert(frame.mouseUpCallbacks, MouseUp)
		else
			frame:HookScript("OnMouseUp", MouseUp)
		end
	end

	function NS:SetCheckbox(frame)
		local function MouseUp()
			NS:PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
		end

		if frame.mouseUpCallbacks then
			table.insert(frame.mouseUpCallbacks, MouseUp)
		else
			frame:HookScript("OnMouseUp", MouseUp)
		end
	end

	function NS:SetSlider(frame)
		local function MouseDown()
			NS:PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
		end

		if frame.mouseDownCallbacks then
			table.insert(frame.mouseDownCallbacks, MouseDown)
		else
			frame:HookScript("OnMouseDown", MouseDown)
		end
	end

	function NS:SetDropdown(frame)
		local function ValueChanged()
			NS:PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
		end

		if frame.valueChangedCallbacks then
			table.insert(frame.valueChangedCallbacks, ValueChanged)
		end
	end

	function NS:SetKeybind(frame)
		local function MouseUp()
			NS:PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
		end

		local function ValueChanged()
			NS:PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
		end

		if frame.mouseUpCallbacks then
			table.insert(frame.mouseUpCallbacks, MouseUp)
		else
			frame:HookScript("OnMouseUp", MouseUp)
		end

		if frame.valueChangedCallbacks then
			table.insert(frame.valueChangedCallbacks, ValueChanged)
		end
	end
end
