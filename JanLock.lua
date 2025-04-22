DotMessageFrame = CreateFrame("Frame")
DotMessageFrame:SetFrameStrata("BACKGROUND")
DotMessageFrame:SetWidth(100)
DotMessageFrame:SetHeight(50)
DotMessageFrame:SetPoint("CENTER",0,-100)

DotMessageFrame.text = DotMessageFrame:CreateFontString(nil, "ARTWORK")
DotMessageFrame.text:SetFont("Fonts\\ARIALN.ttf", 13, "OUTLINE")
DotMessageFrame.text:SetPoint("CENTER",0,0)

actionBlockEndTime = nil;  -- if im spell clicking abilty, ignore clicks after spell was casted

lastCorruptionCastTime = nil;
lastAgonyCastTime = nil;

local corruptionText = "0"; 
local agonyText = "0";

DotMessageFrame:SetScript("OnUpdate", function()
  -- only check for updates every .2 seconds
  if ( this.tick or 1) > GetTime() then return else this.tick = GetTime() + .2 end

  if lastCorruptionCastTime ~= nil then 
    local diff = GetTime()- lastCorruptionCastTime
    local duration = 17
    if diff > duration then 
      corruptionText = "0"
      lastCorruptionCastTime = nil
    else 
      corruptionText = string.format("%.1f",duration - diff) 
    end
  end;

  if lastAgonyCastTime ~= nil then 
    local diff = GetTime()- lastAgonyCastTime
    local duration = 23
    if diff > duration then
      agonyText = "0" 
      lastAgonyCastTime = nil
    else
      agonyText = string.format("%.1f", duration - diff)
    end
  end;

  DotMessageFrame.text:SetText("Corru: "..corruptionText.." Agony "..agonyText) 
end);

CorruptionCast = function() 
  if not actionBlockEndTime or GetTime() > actionBlockEndTime then
    lastCorruptionCastTime = GetTime()
  end
end;

AgonyCast = function() 
  if not actionBlockEndTime or GetTime() > actionBlockEndTime then
    lastAgonyCastTime = GetTime()
  end    
end;

DotMessageFrame:Hide();
DotMessageFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
DotMessageFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
-- DotMessageFrame:RegisterEvent("ACTIONBAR_UPDATE_COOLDOWN")
DotMessageFrame:SetScript("OnEvent", function() 
	if event == "PLAYER_REGEN_DISABLED" then
		DotMessageFrame:Show()
		-- UIErrorsFrame:AddMessage("DotMessageFrame |cffffffaa INFIGHT")
  elseif event == "PLAYER_REGEN_ENABLED" or event == "PLAYER_ENTERING_WORLD" then
		DotMessageFrame:Hide()
		-- UIErrorsFrame:AddMessage("DotMessageFrame |cffffffaa OUTFIGHT")
  end
end);




BuffMessageFrame = CreateFrame("Frame")
BuffMessageFrame:SetFrameStrata("BACKGROUND")
BuffMessageFrame:SetWidth(100)
BuffMessageFrame:SetHeight(50)
BuffMessageFrame:SetPoint("CENTER",0,-120)

BuffMessageFrame.text = BuffMessageFrame:CreateFontString(nil, "ARTWORK")
BuffMessageFrame.text:SetFont("Fonts\\ARIALN.ttf", 13, "OUTLINE")
BuffMessageFrame.text:SetPoint("CENTER",0,0)

BuffMessageFrame:RegisterEvent("PLAYER_AURAS_CHANGED")
BuffMessageFrame:SetScript("OnEvent", function() 
  if event == "PLAYER_AURAS_CHANGED" then
    CheckBuffs()
  end
end);

CheckBuffs = function () 
  local i = 1
  local foundDemonArmor = false
  while UnitBuff("player",i) do 
    if UnitBuff("player",i)=="Interface\\Icons\\Spell_Shadow_RagingScream" then
      foundDemonArmor = true
    end 
    i=i+1 
  end 

  if not foundDemonArmor then BuffMessageFrame.text:SetText("missing demon armor") 
  else BuffMessageFrame.text:SetText("")
  end 
end
CheckBuffs()







message("JanLock loaded")