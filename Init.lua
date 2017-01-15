local ADDON_NAME, Addon = ...

LibStub("AceAddon-3.0"):NewAddon(Addon, addonName, "AceConsole-3.0")
Addon.L = LibStub("AceLocale-3.0"):GetLocale(addonName)
Addon.ACR = LibStub("AceConfigRegistry-3.0")
_G[ADDON_NAME] = Addon
