local addon = select(2, ...)

-- Variables
----------------------------------------------------------------------------------------------------

addon.Libraries = {}

-- Libraries
----------------------------------------------------------------------------------------------------

do
	addon.Libraries.LibSerialize = LibStub("LibSerialize")
	addon.Libraries.LibDeflate = LibStub("LibDeflate")
end
