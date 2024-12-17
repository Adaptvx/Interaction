local addonName, addon = ...
local CallbackRegistry = addon.CallbackRegistry
local L = addon.Locales
local NS = addon.Input

--------------------------------

NS.Variables = {}

--------------------------------
-- VARIABLES
--------------------------------

do -- MAIN
	do -- INPUT DEVICE
		NS.Variables.SimulateController = false -- DEBUG
		NS.Variables.IsController = nil
		NS.Variables.IsPC = nil

		--------------------------------

		NS.Variables.IsControllerEnabled = false
	end

	do -- NAVIGATION
		NS.Variables.IsNavigating = false
		NS.Variables.PreviousFrame = nil
		NS.Variables.CurrentFrame = nil
	end
end

do -- CONSTANTS
	NS.Variables.PATH = addon.Variables.PATH .. "Art/Controller/"
end

--------------------------------
-- EVENTS
--------------------------------
