local addon = select(2, ...)

addon.Libraries = {}

do
	addon.Libraries.LibSerialize = LibStub("LibSerialize")
	addon.Libraries.LibDeflate = LibStub("LibDeflate")
end
