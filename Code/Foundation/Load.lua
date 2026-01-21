local addon = select(2, ...)

-- Variables
----------------------------------------------------------------------------------------------------

addon.Foundation = {}
local NS = addon.Foundation; addon.Foundation = NS

do -- Main
	NS.Initalized = false
end


function NS:Load()

	-- Main
	----------------------------------------------------------------------------------------------------

	local function Priority()
		addon.CallbackRegistry:Load()
		addon.TemplateRegistry:Load()
		addon.EventListener:Load()
	end

	local function Modules()
		addon.Theme:Load()
		addon.SoundEffects:Load()
		addon.Get:Load()
		addon.LoadedAddons:Load()

		addon.Initialize:Load()
	end

	-- Events
	----------------------------------------------------------------------------------------------------

	do
		local f = CreateFrame("Frame")
		f:RegisterEvent("PLAYER_ENTERING_WORLD")
		f:SetScript("OnEvent", function(self, event, ...)
			if event == "PLAYER_ENTERING_WORLD" then
				if not NS.Initalized then
					C_Timer.After(addon.Variables.INIT_DELAY_2, function()
						Modules()
					end)
				end
			end
		end)
	end

	-- Setup
	----------------------------------------------------------------------------------------------------

	do
		Priority()
	end
end

NS:Load()
