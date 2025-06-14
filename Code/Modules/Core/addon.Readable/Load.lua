---@class addon
local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local PrefabRegistry = addon.PrefabRegistry
local L = addon.Locales

--------------------------------

addon.Readable = {}
addon.Readable.ItemUI = {}
addon.Readable.LibraryUI = {}

local NS = addon.Readable; addon.Readable = NS

--------------------------------

function NS:Load()
	local function Modules()
		do -- ELEMENTS
			do -- SHARED
				NS.Elements:Load()
			end

			do -- ITEM UI
				NS.ItemUI.Elements:Load()
			end

			do -- LIBRARY UI
				NS.LibraryUI.Elements:Load()
			end
		end

		do -- SCRIPT
			do -- SHARED
				NS.Script:Load()
			end

			do -- ITEM UI
				NS.ItemUI.Script:Load()
			end

			do -- LIBRARY UI
				NS.LibraryUI.Script:Load()
			end
		end
	end

	local function Prefabs()
		NS.Prefabs:Load()
	end

	local function Misc()
        ItemTextFrame.GetAllPages = function()
            local NumPage = 0
            local Content = {}

            local function ScanPage()
                local Text = ItemTextGetText()
                NumPage = NumPage + 1

                table.insert(Content, Text)

                if ItemTextHasNextPage() then
                    ItemTextNextPage()
                    ScanPage()
                end
            end

            ScanPage()

            return NumPage, Content
        end
	end

	--------------------------------

	Prefabs()
	Modules()
	Misc()
end
