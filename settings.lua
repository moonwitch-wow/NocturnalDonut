------------------------------------------------------------------------
-- Namespaceing
------------------------------------------------------------------------
local addonName, ns = ...

------------------------------------------------------------------------
-- Main Catefgory Frame
-- Register in the Interface Addon Options GUI
-- Set the name for the Category for the Options Panel
------------------------------------------------------------------------
local Panel = CreateFrame('Frame', nil, InterfaceOptionsFramePanelContainer)
Panel.name = addonName
Panel:Hide()

------------------------------------------------------------------------
-- Child Frame
------------------------------------------------------------------------
Panel.childpanel = CreateFrame( "Frame", nil, Panel)
Panel.childpanel.name = ChildPanelName
Panel.childpanel:Hide()

-- Specify childness of this panel
Panel.childpanel.parent = Panel.name

-----------------------------
-- Populating the panel itself (main panel)
Panel:SetScript('OnShow', function(self)
  local Title = self:CreateFontString(nil, nil, 'GameFontNormalLarge')
  Title:SetPoint('TOPLEFT', 16, -16)
  Title:SetText(addonName)

  local Author = self:CreateFontString(nil, nil, 'GameFontNormal')
  Author:SetPoint('TOPLEFT', Title, 'BOTTOMLEFT', 0, -8)
  Author:SetPoint('RIGHT', -32, 0)
  Author:SetJustifyH('LEFT')
  Author:SetText(GetAddOnMetadata(addonName, "Author"))
  -- self.Author = Author

  self:SetScript('OnShow', nil)
end)

-----------------------------
-- Add the panel to the Interface Options
InterfaceOptions_AddCategory(Panel)

-----------------------------
-- Add the child to the Interface Options
InterfaceOptions_AddCategory(Panel.childpanel)

-----------------------------
-- Adding a SlashCommand to open the correct Panel
SLASH_NDONUT1 = '/Ndonut'
SlashCmdList[NDONUT] = function()
   InterfaceOptionsFrame_OpenToCategory(addonName)
end
