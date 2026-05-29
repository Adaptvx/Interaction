local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local TemplateRegistry = addon.TemplateRegistry
local L = addon.Locales
local NS = addon.BlizzardSound; addon.BlizzardSound = NS

NS.Variables = {}

NS.Variables.IsDucked = false
NS.Variables.DuckTicker = nil
NS.Variables.Saved_Sound_MusicVolume = nil
NS.Variables.Saved_Sound_SFXVolume = nil
NS.Variables.Saved_Sound_AmbienceVolume = nil
NS.Variables.DUCK_FADE_DURATION = .5
NS.Variables.DUCK_FADE_STEPS = 10
NS.Variables.TargetLostSFX = 567520
NS.Variables.QuestOpenSFX = 567504
NS.Variables.QuestCloseSFX = 567508
