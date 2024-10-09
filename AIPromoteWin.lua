function AIPromoteWin_Toggle()
 if not (AI_PromoteCloseButton) then
  local b = CreateFrame("Button", "AI_PromoteCloseButton", AIPromoteWin, "UIPanelCloseButton");
  b:SetPoint("TOPRIGHT", -3, -3);
  b:Show();
 end
 tinsert(UISpecialFrames,AIPromoteWin:GetName());
 AIPromoteWin:SetScale(UIParent:GetEffectiveScale());
 AIPromoteKey:SetAutoFocus(false);
 
 if (AIPromoteWin:IsShown()) then AIPromoteWin:Hide() else AIPromoteWin:Show(); end
 -- Initalize

 local radio1 = AIPromoteAutoAssistRadio;
 if not radio1 then 
  local newradio = CreateFrame("CheckButton", "AIPromoteAutoAssistRadio", AIPromoteWin, "UIRadioButtonTemplate");
  newradio:SetPoint("TOPLEFT", AIPromoteWin, "BOTTOMLEFT", 275, 80);
  newradio:SetHeight(25);
  newradio:SetWidth(25);
  newradio:SetScript("OnClick",function()
   AIPromoteAutoNotify:SetChecked(nil)
   AutoInvite_Config["AIPromote_RadioSet"] = "1";
  end);
  newradio:Show();
 end
 local radio2 = AIPromoteAutoNotify;
 if not radio2 then 
  local newradio = CreateFrame("CheckButton", "AIPromoteAutoNotify", AIPromoteWin, "UIRadioButtonTemplate");
  newradio:SetPoint("TOPLEFT", AIPromoteWin, "BOTTOMLEFT", 275, 48 );
  newradio:SetHeight(25);
  newradio:SetWidth(25);
  newradio:SetScript("OnClick", function()
   AIPromoteAutoAssistRadio:SetChecked(nil)
   AutoInvite_Config["AIPromote_RadioSet"] = "2";
  end);
  newradio:Show();
 end
 if not AIPromote_Init then
  local RadioSet = AutoInvite_Config["AIPromote_RadioSet"];
  if (RadioSet == "2") then AIPromoteAutoNotify:SetChecked(1); else AIPromoteAutoAssistRadio:SetChecked(1); end
  
  local status = AutoInvite_Config["AIPromote_Enabled"];
  if (status == "enabled") then AIPromoteEnabled:SetChecked(1); else AIPromoteEnabled:SetChecked(nil); end
  
  local key = AutoInvite_Config["AIPromote_Key"];
  if (key) then 
   AIPromoteKey:SetText(key); 
  else 
   AutoInvite_Config["AIPromote_Key"] = "s3cure";
   local t = AutoInvite_Config["AIPromote_Key"];
   AIPromoteKey:SetText(t);
  end
  
  AIPromoteKey:SetTextInsets(5,0,0,0);
  
  AIPromote_Init = true;
 end
 AIPromote_CheckStatus();
end
function AIPromote_CheckStatus()
 if(AIPromoteEnabled:GetChecked()) then AutoInvite_Config["AIPromote_Enabled"] = "enabled"; else AutoInvite_Config["AIPromote_Enabled"] = "disabled"; end
end
function AIPromote_KeySet()
 local t = AIPromoteKey:GetText();
 AutoInvite_Config["AIPromote_Key"] = t;
end
function AIPromote_IsKey(...)
 local tkey = strtrim(...)
 local key = strtrim(AutoInvite_Config["AIPromote_Key"])
 if(tkey == key) then
  return true
 else
  return false
 end
end
function AIPromote_Assist(...)
 local user = ...
 if(IsRaidLeader()) then PromoteToAssistant(user) end  
end