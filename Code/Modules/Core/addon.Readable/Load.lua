local addonName, addon = ...
local CallbackRegistry = addon.CallbackRegistry
local L = addon.Locales

--------------------------------

addon.Readable = {}
addon.Readable.ItemUI = {}
addon.Readable.LibraryUI = {}

local NS = addon.Readable

--------------------------------

function NS:Load()
	local function Modules()
		local function Elements()
			local function Shared()
				NS.Elements:Load()
			end

			local function ReadableUI()
				NS.ItemUI.Elements:Load()
			end

			local function LibraryUI()
				NS.LibraryUI.Elements:Load()
			end

			--------------------------------

			Shared()
			ReadableUI()
			LibraryUI()
		end

		local function Script()
			local function Shared()
				NS.Script:Load()
			end

			local function ReadableUI()
				NS.ItemUI.Script:Load()
			end

			local function LibraryUI()
				NS.LibraryUI.Script:Load()
			end

			--------------------------------

			Shared()
			ReadableUI()
			LibraryUI()
		end

		--------------------------------

		Elements()
		Script()
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

	Modules()
	Misc()
end
