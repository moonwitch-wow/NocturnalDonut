------------------------------------------------------------------------
-- Setting up the local scope
------------------------------------------------------------------------
local addon, ns = ...
local eventHandler = CreateFrame("frame")

------------------------------------------------------------------------
--  CONFIG
------------------------------------------------------------------------
local font = STANDARD_TEXT_FONT
local fontSize = 12
local fontFlag = 'OUTLINE'
local buttonSize = 32
local horizontal_spacing = -10

------------------------------------------------------------------------
-- Functions
------------------------------------------------------------------------
-- using hooksecurefunc to avoid breakage...
hooksecurefunc("BuffFrame_OnLoad", function()
  BUFF_FLASH_TIME_ON = 0.8
  BUFF_FLASH_TIME_OFF = 0.8
  BUFF_MIN_ALPHA = 0.70
  BUFFS_PER_ROW = 12
  DAY_ONELETTER_ABBR = "%dd"
  HOUR_ONELETTER_ABBR = "%dh"
  MINUTE_ONELETTER_ABBR = "%dm"
  SECOND_ONELETTER_ABBR = "%ds"
end)

-- Positioning of the masses
TemporaryEnchantFrame:ClearAllPoints()
TemporaryEnchantFrame:SetPoint("TOPRIGHT", Minimap, "TOPLEFT", -10, 0)
TemporaryEnchantFrame.SetPoint = function() end
BuffFrame:ClearAllPoints()
BuffFrame:SetPoint("TOPRIGHT", Minimap, "TOPLEFT", -10, 0)
BuffFrame.SetPoint = function() end
ConsolidatedBuffs:ClearAllPoints()
ConsolidatedBuffs:SetPoint("TOPRIGHT", Minimap, "TOPLEFT", -10, 0)
ConsolidatedBuffs.SetPoint = function() end

-- Time is of the essence
local SecondsToTimeAbbrev = function(time)
  local hr, m, s, text
  if time <= 0 then text = ""
  elseif(time < 3600 and time > 60) then
    hr = floor(time / 3600)
    m = floor(mod(time, 3600) / 60 + 1)
    text = format("%dm", m)
  elseif time < 60 then
    m = floor(time / 60)
    s = mod(time, 60)
    text = (m == 0 and format("%ds", s))
  else
    hr = floor(time / 3600 + 1)
    text = format("%dh", hr)
  end
  return text
end

------------------------------------------------------------------------
-- Skinning Functions
------------------------------------------------------------------------
local skinner = function( name, id )
  local base = _G[("%s%d"):format(name, id)]
  local icon = _G[("%s%dIcon"):format(name, id)]
  local duration = _G[("%s%dDuration"):format(name, id)]
  local count = _G[("%s%dCount"):format(name, id)]
  local border = _G[("%s%dBorder"):format(name, id)]
  local skin = _G[("%s%dSkin"):format(name, id)]

  if (icon) then
    -- set size
    base:SetSize(buttonSize, buttonSize)

    count:SetFont(font, fontSize+3, fontFlag)
    count:SetShadowColor(0, 0, 0, .9)
    count:SetShadowOffset(1, -1)
    count:ClearAllPoints()
    count:SetPoint("TOPRIGHT", base)
    count:SetDrawLayer"OVERLAY"

    duration:SetFont(font, fontSize, fontFlag)
    duration:SetShadowColor(0, 0, 0, .9)
    duration:SetShadowOffset(1, -1)
    duration:ClearAllPoints()
    duration:SetPoint("TOP", base, "BOTTOM", 0, 4)
    duration:SetDrawLayer"OVERLAY"

    icon:SetTexCoord(0.1,0.9,0.1,0.9)
    icon:SetDrawLayer("BACKGROUND")

    --border
    if (border) then
      border:SetDrawLayer"BORDER"
      border:SetParent(base)
      border:SetTexture("Interface\\AddOns\\NocturnalDonut\\media\\gloss_grey")
      border:SetPoint("TOPRIGHT", base, 3, 3)
      border:SetPoint("BOTTOMLEFT", base, -3, -3)
      border:SetTexCoord(0, 1, 0, 1)
    end

    if (base and not skin and not border) then
      local overlay = CreateFrame("Frame", base:GetName().."Skin")
      overlay:SetAllPoints(base)
      overlay:SetParent(base)

      local texture = overlay:CreateTexture(nil, "BORDER")
      texture:SetParent(base)
      texture:SetTexture("Interface\\AddOns\\NocturnalDonut\\media\\gloss")
      texture:SetPoint("TOPRIGHT", overlay, 3, 3)
      texture:SetPoint("BOTTOMLEFT", overlay, -3, -3)
      texture:SetVertexColor(0.4, 0.4, 0.4)
    end
  return true
  end
end

--update debuff anchors
local function updateDebuffs()
  BUFF_HORIZ_SPACING = horizontal_spacing
  DEBUFF_ACTUAL_DISPLAY = 0
  for i=1, DEBUFF_MAX_DISPLAY do
    if ( skinner("DebuffButton", i) ) then
      DEBUFF_ACTUAL_DISPLAY = DEBUFF_ACTUAL_DISPLAY + 1;
    end
  end
end

--update buff anchors
local function updateAllBuffs()
  BUFF_HORIZ_SPACING = horizontal_spacing
  BUFF_ACTUAL_DISPLAY = 0
  for i=1, BUFF_MAX_DISPLAY do
    if ( skinner("BuffButton", i) ) then
      BUFF_ACTUAL_DISPLAY = BUFF_ACTUAL_DISPLAY + 1;
    end
  end
end

------------------------------------------------------------------------
-- Hooking into Blizzy funcs
------------------------------------------------------------------------
hooksecurefunc("BuffFrame_UpdateAllBuffAnchors", updateAllBuffs)
hooksecurefunc("DebuffButton_UpdateAnchors", updateDebuffs)
-- temp enchants are wonky
local r, g, b = .7 , .6 , 1
for i = 1, 3 do
  skinner("TempEnchant", i)

  local fn = _G["TempEnchant" .. i .. "Border"]
  fn:SetTexture("Interface\\AddOns\\NocturnalDonut\\media\\gloss_grey")
  fn:SetVertexColor(r, g, b)
  _G["TempEnchant" .. i .. "Duration"]:SetDrawLayer"OVERLAY"
end

eventHandler:RegisterEvent("PLAYER_ENTERING_WORLD")
eventHandler:SetScript("OnEvent", function()
  updateAllBuffs()
  updateDebuffs()
end)