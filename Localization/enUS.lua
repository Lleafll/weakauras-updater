local addonName, addonTable = ...

local L = LibStub("AceLocale-3.0"):NewLocale(addonName, "enUS", true)
if not L then return end

L["Add"] = true
L["Delete"] = true
L["Reset"] = true
L["Show"] = true
L["Update"] = true
