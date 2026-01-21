local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local TemplateRegistry = addon.TemplateRegistry
local L = addon.Locales

addon.Readable = {}
addon.Readable.ItemUI = {}
addon.Readable.LibraryUI = {}

local NS = addon.Readable; addon.Readable = NS

function NS:Load()
	local function Modules()
		do -- Elements
			do -- Shared
				NS.Elements:Load()
			end

			do -- Item ui
				NS.ItemUI.Elements:Load()
			end

			do -- Library ui
				NS.LibraryUI.Elements:Load()
			end
		end

		do -- Script
			do -- Shared
				NS.Script:Load()
			end

			do -- Item ui
				NS.ItemUI.Script:Load()
			end

			do -- Library ui
				NS.LibraryUI.Script:Load()
			end
		end
	end

	local function Templates()
		NS.Templates:Load()
	end

	local function Misc()
        function ItemTextFrame.GetAllPages()
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

	Templates()
	Modules()
	Misc()
end
