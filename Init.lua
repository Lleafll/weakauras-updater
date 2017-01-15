local ADDON_NAME, Addon = ...


--------------------------------------------------------------------------------
-- Initialization
--------------------------------------------------------------------------------
LibStub("AceAddon-3.0"):NewAddon(Addon, ADDON_NAME, "AceConsole-3.0")
Addon.L = LibStub("AceLocale-3.0"):GetLocale(ADDON_NAME)
Addon.ACR = LibStub("AceConfigRegistry-3.0")
_G[ADDON_NAME] = Addon
