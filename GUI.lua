local addonName, Addon = ...

local L = Addon.L
local GUI = Addon:NewModule("GUI")
Addon.GUI = GUI
AUI = LibStub("AceGUI-3.0")

local WeakAuras = WeakAuras

function GUI:Open()
  local container = AUI:Create("Frame")
  container:SetCallback("OnClose", function(self)
    AUI:Release(self)
  end)
  container:SetTitle(addonName)
  container:SetLayout("Fill")
  self.container = container

  local groupTree = {}
  for k, v in pairs(Addon.Displays) do
    groupTree[#groupTree + 1] = {
      value = k,
      text = k
    }
  end
  local groupList = AUI:Create("TreeGroup")
  groupList:SetWidth(200)
  groupList:SetHeight(600)
  groupList:SetLayout("Flow")
  groupList:SetTree(groupTree)
  function groupList:BuildDisplayList(groupName)
    if not groupName then
      return
    end

    self:ReleaseChildren()
    if not Addon.Displays[groupName]["children"] then
      return
    end
    local isInstalled = Addon:IsInstalled(groupName)

    -- Show Group
    local showGroupButton = AUI:Create("Button")
    showGroupButton:SetText(L["Show"])
    showGroupButton:SetWidth(80)
    showGroupButton:SetCallback("OnClick", function()
      Addon:PickDisplay(groupName)
    end)
    showGroupButton:SetDisabled(not isInstalled)
    self:AddChild(showGroupButton)

    -- Delete Group
    local deleteGroupButton = AUI:Create("Button")
    deleteGroupButton:SetText(L["Delete"])
    deleteGroupButton:SetWidth(80)
    deleteGroupButton:SetCallback("OnClick", function()
      Addon:DeleteGroup(groupName)
    end)
    deleteGroupButton:SetDisabled(not isInstalled)
    self:AddChild(deleteGroupButton)

    for displayName, v in pairs(Addon.Displays[groupName]["children"]) do
      local isInstalled = Addon:IsInstalled(displayName)
      local isOutdatedOrModified = Addon:IsOutdatedOrModified(displayName, groupName)

      local displayGroup = AUI:Create("InlineGroup")
      displayGroup:SetTitle(displayName)
      displayGroup:SetWidth(500)
      displayGroup:SetLayout("Flow")
      self:AddChild(displayGroup)

      -- Show
      local showButton = AUI:Create("Button")
      showButton:SetText(L["Show"])
      showButton:SetWidth(80)
      showButton:SetCallback("OnClick", function()
        Addon:PickDisplay(displayName)
      end)
      showButton:SetDisabled(not isInstalled)
      displayGroup:AddChild(showButton)

      -- Install
      local installButton = AUI:Create("Button")
      installButton:SetText(L["Install"])
      installButton:SetWidth(80)
      installButton:SetCallback("OnClick", function()
        Addon:AddDisplay(displayName, groupName, true)
      end)
      installButton:SetDisabled(isInstalled)
      displayGroup:AddChild(installButton)

      -- Update
      local updateButton = AUI:Create("Button")
      updateButton:SetText(L["Update"])
      updateButton:SetWidth(80)
      updateButton:SetCallback("OnClick", function()
        Addon:UpdateDisplay(displayName, groupName)
      end)
      updateButton:SetDisabled(not isInstalled or not isOutdatedOrModified)
      displayGroup:AddChild(updateButton)

      -- Reset
      local resetButton = AUI:Create("Button")
      resetButton:SetText(L["Reset"])
      resetButton:SetWidth(80)
      resetButton:SetCallback("OnClick", function()
        Addon:ResetDisplay(displayName, groupName)
      end)
      resetButton:SetDisabled(not isInstalled)
      displayGroup:AddChild(resetButton)

      -- Delete
      local deleteButton = AUI:Create("Button")
      deleteButton:SetText(L["Delete"])
      deleteButton:SetWidth(80)
      deleteButton:SetCallback("OnClick", function()
        Addon:DeleteDisplay(displayName, groupName)
      end)
      deleteButton:SetDisabled(not isInstalled)
      displayGroup:AddChild(deleteButton)
    end
  end
  groupList:SetCallback("OnGroupSelected", function(self, event, value)
    GUI.groupName = value
    groupList:BuildDisplayList(value)
  end)
  container:AddChild(groupList)
  Addon.GUI.groupList = groupList
end

-- WeakAuras hook to register display manipulation
function GUI:ReloadDisplay(data)
  if self.groupList and (data.id == self.groupName or data.parent == self.groupName) then
    self.groupList:BuildDisplayList(self.groupName)
  end
end

hooksecurefunc(WeakAuras, "pAdd", function(data)
  GUI:ReloadDisplay(data)
end)

hooksecurefunc(WeakAuras, "Delete", function(data)
  GUI:ReloadDisplay(data)
end)

-- Debug
GUI:Open()
