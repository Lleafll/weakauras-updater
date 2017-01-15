local ADDON_NAME, Addon = ...

local WeakAuras = WeakAuras


function Addon:GetDisplayData(displayName, parentName, createNew)
  local displayTemplate = self.Displays[parentName]["children"][displayName]
  local display = {}

  -- Copy template data to display
  self:DeepCopy(displayTemplate["required"], display)
  if createNew then
    self:DeepCopy(displayTemplate["optional"], display)

    for k, v in pairs(self.DisplayTemplate) do
      display[k] = display[k] or v
    end
  end

  display["parent"] = parentName
  display["id"] = displayName

  return display
end


function Addon:CreateDisplayParent(displayName, parentName)
  -- Check for parent and create if necessary
  if not WeakAuras.regions[parentName] then
    local parentTemplate = self.Displays[parentName]
    local parent = {}
    parent["id"] = parentName
    for k, v in pairs(parentTemplate["required"]) do
      parent[k] = v
    end
    for k, v in pairs(parentTemplate["optional"]) do
      parent[k] = v
    end
    for k, v in pairs(Addon.GroupTemplate) do
      parent[k] = parent[k] or v
    end
    WeakAuras.Add(parent)
  	local optionsFrame = WeakAuras.OptionsFrame and WeakAuras.OptionsFrame()
  	if optionsFrame then
      WeakAuras.NewDisplayButton(parent)  -- Create group button in WA options GUI
    end
  end
end


function Addon:AddDisplayToParent(displayName, parentName)
  -- Set display as child of parent
  local parentData = WeakAuras.GetData(parentName)
  if parentData.controlledChildren then
    local alreadyChild = false
    for index, childId in ipairs(parentData.controlledChildren) do
      if childId == displayName then
        alreadyChild = true
        break
      end
    end
    if not alreadyChild then
      parentData.controlledChildren[#parentData.controlledChildren + 1] = displayName
    end
  end
end
--------------------------------------------------------------------------------
-- Upvalues
--------------------------------------------------------------------------------
local ipairs = ipairs


--------------------------------------------------------------------------------
-- Display creation/deletion/modification
--------------------------------------------------------------------------------
function Addon:AddDisplay(displayName, parentName)
  -- Create display and parent if necessary
  self:CreateDisplayParent(displayName, parentName)
  local display = self:GetDisplayData(displayName, parentName, true)
  Addon:AddDisplayToParent(displayName, parentName)

  -- Add display to WeakAuras
  WeakAuras.Add(display)

  -- check if the options panel has loaded (from Details!)
	local optionsFrame = WeakAuras.OptionsFrame and WeakAuras.OptionsFrame()
	if optionsFrame then
		if not optionsFrame:IsShown() then
			WeakAuras.ToggleOptions()
		end
		WeakAuras.NewDisplayButton(display)
    -- Manually enable expand button since WA does not do this automatically after receving a child
    WeakAuras.displayButtons[parentName]:EnableExpand()
    WeakAuras.PickDisplay(displayName)
	end
end


function Addon:UpdateDisplay(displayName, parentName)
  local display = WeakAuras.GetData(displayName)
  self:DeepCopy(self.Displays[parentName]["children"][displayName]["required"], display)

  WeakAuras.Add(display)
  self:UpdateWeakAurasOptions(display)
end


function Addon:ResetDisplay(displayName, parentName)
  -- Create display and parent if necessary
  self:CreateDisplayParent(displayName, parentName)
  local display = self:GetDisplayData(displayName, parentName, true)
  self:AddDisplayToParent(displayName, parentName)

  WeakAuras.Add(display)
  self:UpdateWeakAurasOptions(display)
end


function Addon:DeleteDisplay(displayName, parentName)  -- TODO: Check if WA options are loaded instead of checking for every single function
  local weakAurasData = WeakAuras.GetData(displayName)
  if not weakAurasData then
    return
  end
  local parentData = weakAurasData.parent and WeakAuras.GetData(weakAurasData.parent)
  local parentButton = weakAurasData.parent and WeakAuras.GetDisplayButton and WeakAuras.GetDisplayButton(weakAurasData.parent)
  if WeakAuras.DeleteOption then
    WeakAuras.DeleteOption(weakAurasData)
  else  -- Options are not loaded
    WeakAuras.Delete(weakAurasData)
  end
  if parentData and WeakAuras.UpdateGroupOrders then
      WeakAuras.UpdateGroupOrders(parentData)
  end
  if parentButton then
      parentButton.callbacks.UpdateExpandButton()
  end
end


function Addon:DeleteGroup(parentName)
  for displayName, v in pairs(self.Displays[parentName]["children"]) do
    self:DeleteDisplay(displayName, parentName)
  end
  local weakAurasData = WeakAuras.GetData(parentName)
  if WeakAuras.DeleteOption then
    WeakAuras.DeleteOption(weakAurasData)
  else  -- Options are not loaded
    WeakAuras.Delete(weakAurasData)
  end

  WeakAuras.SortDisplayButtons()
end


--------------------------------------------------------------------------------
-- WeakAurasOptions handling
--------------------------------------------------------------------------------
function Addon:UpdateWeakAurasOptions(display)
  local optionsFrame = WeakAuras.OptionsFrame and WeakAuras.OptionsFrame()
    if optionsFrame then
      if not optionsFrame:IsShown() then
        WeakAuras.ToggleOptions()
      end
    -- Copied from WeakAuras.ConstructOptions in WeakAurasOptions.lua
    WeakAuras.ScanForLoads()
    WeakAuras.SetThumbnail(display)
    WeakAuras.SetIconNames(display)
    WeakAuras.UpdateDisplayButton(display)
    WeakAuras.SortDisplayButtons()

    WeakAuras.PickDisplay(display.id)
  end
end


function Addon:PickDisplay(displayName)
  local optionsFrame = WeakAuras.OptionsFrame and WeakAuras.OptionsFrame()
  if optionsFrame then
    if not optionsFrame:IsShown() then
      WeakAuras.ToggleOptions()
    end
    WeakAuras.PickDisplay(displayName)
  end
end


--------------------------------------------------------------------------------
-- Utilities
--------------------------------------------------------------------------------
function Addon:IsInstalled(displayName)
  return WeakAuras.GetData(displayName) and true or false
end


function Addon:IsOutdatedOrModified(displayName, parentName)
  local weakAurasData = WeakAuras.GetData(displayName)
  if not weakAurasData then
    return
  end
  local addonData = self.Displays[parentName]["children"][displayName]["required"]

  local function compareTable(addonData, weakAurasData)
    if type(addonData) == "table" then
      for k, v in pairs(addonData) do
        if compareTable(v, weakAurasData[k]) then
          return true
        end
      end
    else
      if addonData ~= weakAurasData then
        return true
      end
    end
    return false
  end

  return compareTable(addonData, weakAurasData)
end


function Addon:DeepCopy(template, target)
  for k, v in pairs(template) do
    if type(v) == "table" then
      target[k] = target[k] or {}
      self:DeepCopy(v, target[k])
    else
      target[k] = v
    end
  end
end
