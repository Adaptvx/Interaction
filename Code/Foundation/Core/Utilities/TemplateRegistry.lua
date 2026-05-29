local addon = select(2, ...)

addon.TemplateRegistry = {}
local NS = addon.TemplateRegistry; addon.TemplateRegistry = NS

local Templates = {}
local TemplateVariables = {}

function NS:Load()

	function NS:Add(id, TemplateFunc)
		if Templates[id] == nil then
			Templates[id] = TemplateFunc
		end
	end

	function NS:Create(id, ...)
		if Templates[id] then
			return Templates[id](...)
		end
	end

	function NS:AddVariableTable(id, varTable)
		if TemplateVariables[id] == nil then
			TemplateVariables[id] = varTable
		end
	end

	function NS:GetVariableTable(id)
		return TemplateVariables[id]
	end
end
