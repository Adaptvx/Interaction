local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local TemplateRegistry = addon.TemplateRegistry
local L = addon.Locales
local NS = addon.Interaction.Gossip.AutoSelect; addon.Interaction.Gossip.AutoSelect = NS

NS.Variables = {}

-- Variables
----------------------------------------------------------------------------------------------------

do -- Main

end

do -- Constants
	NS.Variables.ALWAYS = "Always"
	NS.Variables.ONLY_OPTION = "Only Option"

	NS.Variables.DB = {
		[120910] = NS.Variables.ONLY_OPTION, -- (Dornogal) Dornagal Flight Point
		[121665] = NS.Variables.ALWAYS, -- (Dornogal) Trading Post
		[121672] = NS.Variables.ALWAYS, -- (Dornogal) Trading Post
		[107824] = NS.Variables.ALWAYS, -- Trading post
		[107827] = NS.Variables.ALWAYS, -- Trading post
		[107825] = NS.Variables.ALWAYS, -- Trading post
		[107826] = NS.Variables.ALWAYS, -- Trading post
		[48598] = NS.Variables.ALWAYS, -- Katy stampwhistle
		[120733] = NS.Variables.ALWAYS, -- Theater troupe
	}
end

-- Events
----------------------------------------------------------------------------------------------------
