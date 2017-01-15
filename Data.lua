local ADDON_NAME, Addon = ...


--------------------------------------------------------------------------------
-- Templates for essential data
--------------------------------------------------------------------------------
Addon.GroupTemplate = {
  ["expanded"] = true;
  ["load"] = {},
  ["regionType"] = "group",
  ["trigger"] = {},
}

Addon.DisplayTemplate = {
  ["load"] = {},
  ["trigger"] = {},
}


--------------------------------------------------------------------------------
-- Displays
--------------------------------------------------------------------------------
Addon.Displays = {}

Addon.Displays["aaa"] = {
  ["required"] = {
  },
  ["optional"] = {
    ["regionType"] = "group",
  },
  ["children"] = {
  },
}

Addon.Displays["aaa"]["children"]["Minimap toggle 2"] = {
  ["standalone"] = true,
  ["required"] = {
    ["activeTriggerMode"] = 0,
    ["additional_triggers"] = {
      {
        ["trigger"] = {
          ["type"] = "custom",
          ["custom_type"] = "event",
          ["events"] = "PLAYER_ENTERING_WORLD",
          ["custom"] = "function(event, ...)\n    return true\nend",
          ["custom_hide"] = "timed",
          ["duration"] = "5",
        },
      },
    },
    ["trigger"] = {
      ["type"] = "custom",
      ["custom_type"] = "event",
      ["events"] = "ZONE_CHANGED_NEW_AREA,QUEST_ACCEPTED,QUEST_TURNED_IN,QUEST_WATCH_UPDATE",
      ["custom"] = "function(event, ...)\n    return true\nend",
      ["custom_hide"] = "timed",
      ["duration"] = "0",
    },
    ["untrigger"] = {
      ["custom"] = "function()\n    return true\nend",
    },
  },
  ["optional"] = {
    ["yOffset"] = 0,
    ["xOffset"] = 52,
    ["regionType"] = "text",
  }
}


Addon.Displays["aaa"]["children"]["Despoiled Ground"] = {
  ["standalone"] = true,
  ["required"] = {
    ["trigger"] = {
      ["spellId"] = "180604",
      ["duration"] = "1.1",
      ["unit"] = "player",
      ["destUnit"] = "player",
      ["debuffType"] = "HARMFUL",
      ["type"] = "aura",
      ["unevent"] = "timed",
      ["custom_hide"] = "timed",
      ["event"] = "Combat Log",
      ["spellName"] = "Despoiled Ground",
      ["subeventPrefix"] = "SPELL_PERIODIC",
      ["use_spellId"] = true,
      ["spellIds"] = {
      },
      ["use_spellName"] = false,
      ["name"] = "Despoiled Ground",
      ["use_destUnit"] = true,
      ["subeventSuffix"] = "_DAMAGE",
      ["names"] = {
        "Despoiled Ground", -- [1]
      },
    },
  },
  ["optional"] = {
		["xOffset"] = -126.000366210938,
		["untrigger"] = {
		},
		["anchorPoint"] = "CENTER",
		["activeTriggerMode"] = 0,
		["customTextUpdate"] = "update",
		["actions"] = {
			["start"] = {
				["sound_channel"] = "Master",
				["sound"] = "Interface\\Addons\\WeakAuras\\PowerAurasMedia\\Sounds\\sonar.ogg",
				["do_sound"] = true,
			},
			["finish"] = {
			},
			["init"] = {
			},
		},
		["fontFlags"] = "OUTLINE",
		["selfPoint"] = "CENTER",
		["trigger"] = {
			["spellId"] = "180604",
			["duration"] = "1.1",
			["unit"] = "player",
			["destUnit"] = "player",
			["debuffType"] = "HARMFUL",
			["type"] = "aura",
			["unevent"] = "timed",
			["custom_hide"] = "timed",
			["event"] = "Combat Log",
			["spellName"] = "Despoiled Ground",
			["subeventPrefix"] = "SPELL_PERIODIC",
			["use_spellId"] = true,
			["spellIds"] = {
			},
			["use_spellName"] = false,
			["name"] = "Despoiled Ground",
			["use_destUnit"] = true,
			["subeventSuffix"] = "_DAMAGE",
			["names"] = {
				"Despoiled Ground", -- [1]
			},
		},
		["stickyDuration"] = false,
		["font"] = "Friz Quadrata TT",
		["height"] = 64,
		["load"] = {
			["talent"] = {
				["multi"] = {
				},
			},
			["class"] = {
				["multi"] = {
				},
			},
			["use_encounterid"] = true,
			["difficulty"] = {
				["multi"] = {
				},
			},
			["role"] = {
				["multi"] = {
				},
			},
			["pvptalent"] = {
				["multi"] = {
				},
			},
			["faction"] = {
				["multi"] = {
				},
			},
			["encounterid"] = "1784",
			["race"] = {
				["multi"] = {
				},
			},
			["spec"] = {
				["multi"] = {
				},
			},
			["size"] = {
				["multi"] = {
				},
			},
		},
		["fontSize"] = 12,
		["displayStacks"] = "%s",
		["regionType"] = "icon",
		["icon"] = true,
		["stacksContainment"] = "INSIDE",
		["zoom"] = 0,
		["auto"] = true,
		["color"] = {
			1, -- [1]
			1, -- [2]
			1, -- [3]
			1, -- [4]
		},
		["frameStrata"] = 1,
		["width"] = 64,
		["animation"] = {
			["start"] = {
				["duration_type"] = "seconds",
				["type"] = "none",
			},
			["main"] = {
				["duration_type"] = "seconds",
				["type"] = "none",
			},
			["finish"] = {
				["duration_type"] = "seconds",
				["type"] = "none",
			},
		},
		["yOffset"] = 111.999938964844,
		["numTriggers"] = 1,
		["inverse"] = false,
		["desaturate"] = false,
		["displayIcon"] = "Interface\\Icons\\spell_fire_twilighthellfire",
		["stacksPoint"] = "BOTTOMRIGHT",
		["textColor"] = {
			1, -- [1]
			1, -- [2]
			1, -- [3]
			1, -- [4]
		},
	},
}


Addon.Displays["test2"] = {}


--------------------------------------------------------------------------------
-- Compile list of displays for easy search
--------------------------------------------------------------------------------
Addon.DisplayParents = {}
for groupName, v in pairs(Addon.Displays) do
  if v and v["children"] then
    for displayName in pairs(v["children"]) do
      Addon.DisplayParents[displayName] = groupName
    end
  end
end
