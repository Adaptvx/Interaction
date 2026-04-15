local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local TemplateRegistry = addon.TemplateRegistry
local L = addon.Locales
local NS = addon.Interaction; addon.Interaction = NS

NS.Variables = {}
NS.Variables.Active = false
NS.Variables.LastActive = nil
NS.Variables.CurrentSession = {
    ["type"]       = nil,
    ["questID"]    = nil,
    ["dialogText"] = nil,
    ["npc"]        = nil
}

NS.Variables.LastQuestNPC = nil
NS.Variables.CurrentSession.type = nil
