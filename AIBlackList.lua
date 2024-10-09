function AIBlackList_OnLoad()
 --[[ Important variables:
 AutoInvite_Config["BlackListed"]
 ]]--
 
 -- Build BlackList Window by LUA
 local BL = CreateFrame("Frame", "AIBlackList2", UIParent, "BasicFrameTemplateWithInset");
 BL:SetPoint("CENTER", 0,0);
 BL:SetWidth(200);
 BL:SetHeight(300);
 BL:Hide();
 
 BL:SetMovable(true);
 BL:RegisterForDrag("LeftButton");
 BL:EnableMouse(true);
 BL:SetScript("OnDragStart", function(self, button)
    BL:StartMoving();
 end);
 BL:SetScript("OnDragStop", function(self)
    BL:StopMovingOrSizing();
 end);
 AIBlackList2TitleText:SetText("AutoInvite - BlackList");
 AIBlackList2InsetBg:SetPoint("TOPLEFT", 5, -50);
 AIBlackList2InsetBg:SetPoint("BOTTOMRIGHT", -25, 30);
 
 -- Build character name slider (copy'd from AutoInvite.lua)
 
 --"OptionsSliderTemplate"
 
 if not AIBL_InputUser then
  local edit = CreateFrame("Editbox", "AIBL_InputUser", AIBlackList2, "InputBoxTemplate");
  edit:SetPoint("BOTTOMLEFT", AIBlackList2, "BOTTOMLEFT", 70, 5);
  edit:SetAutoFocus(false);
  edit:SetWidth(100);
  edit:SetHeight(20);
 end
 
 if not AIBL_AddUserButton then
  local b = CreateFrame("Button", "AIBL_AddUserButton", AIBlackList2, "UIPanelButtonTemplate");
  b:SetPoint("BOTTOMLEFT", AIBlackList2, "BOTTOMLEFT", 1, 2);
  b:SetWidth(55);
  b:SetHeight(25);
  b:SetText("Add");
  b:SetScript("OnClick",function(self)
   AIBL_AddUser();
  end);
 end
 
 if not AIBL_RemUserButton then
  local b = CreateFrame("Button", "AIBL_RemUserButton", AIBlackList2, "UIPanelCloseButton");
  b:SetScript("OnClick",function(self) StaticPopup_Show("AIBL_REMUSERCONFIRM") end); 
  b:SetPoint("TOPLEFT", 2, -20);
 end
 
 if not AIBL_UserDisplay then
  local fs = AIBlackList2:CreateFontString("AIBL_UserDisplay", "ARTWORK", "GameFontNormalLargeLeft");
  fs:SetPoint("TOPLEFT", AIBlackList2, "TOPLEFT", 30, -27);
  fs:Show();
 end
 
 if not AIBL_UserButton1 then
  for i=1, 10 do
   local b = CreateFrame("Button", "AIBL_UserButton"..i, AIBlackList2, "UIPanelButtonTemplate");
   if ( i == 1 ) then
    b:SetPoint("TOPLEFT", AIBlackList2InsetBg, "TOPLEFT", 2, -1);
   else
    local bMinus = i - 1;
    local yOffset = bMinus * 10 * -1
    b:SetPoint("TOPLEFT", "AIBL_UserButton"..bMinus, "BOTTOMLEFT", 0, -1);
   end
   b:SetWidth(150);
   b:SetHeight(20);
   b:SetHighlightTexture("Interface\\PaperDollInfoFrame\\UI-Character-Tab-Highlight");
   b:SetNormalTexture("");
   b:SetPushedTexture("");
   b:SetScript("OnClick",function(self)
    AIBL_UserClick("AIBL_UserButton"..i)
   end);
   b:SetText("");
  end
  
  if not AIBLSlider then
 
   local AIBLSL = CreateFrame("Slider","AIBLSlider",AIBlackList2,"UIPanelScrollBarTemplate");
 
   AIBLSL:SetPoint("TOPLEFT", AIBlackList2, "TOPRIGHT", -23, -68);
   AIBLSL:SetPoint("BOTTOMLEFT", AIBlackList2, "BOTTOMRIGHT", -23, 45);
   AIBLSL:SetMinMaxValues(0, 100);
   AIBLSL:SetValueStep(1);
   AIBLSL:SetScript("OnValueChanged",function(self)
    local value = self:GetValue();
    local min, max = self:GetMinMaxValues();
    if (value == min) then
     _G[self:GetName().."ScrollUpButton"]:Disable();
    else
     _G[self:GetName().."ScrollUpButton"]:Enable();
    end
    if ( value == max ) then
     _G[self:GetName().."ScrollDownButton"]:Disable();
    else
     _G[self:GetName().."ScrollDownButton"]:Enable();
    end
    AIBL_UpdateDisplay();
   end);
   AIBLSL:SetValue(0);
   AIBLSL:Show();
   AIBLSL:EnableMouseWheel(true);
   AIBLSL:SetScript("OnMouseWheel",  function(self, delta)
    local Curr = AIBLSlider:GetValue();
    if(delta == 1) then AIBLSlider:SetValue(Curr - 1); end
    if(delta == -1) then AIBLSlider:SetValue(Curr + 1); end
   end);  
   AIBLSL:Show();
  end
  
  if (AutoInvite_Config["BlackListed"]) then
   -- Remove empty BlackListed lines
   AIBL_CleanTable();
   
   AIBL_BlackListed = AutoInvite_Config["BlackListed"];
   AIBL_tempUserList = { };
   local V = AIBLSlider:GetValue();
   if(V <= 6) then minOffset = 1 ; maxOffset = 10; end
   if(V > 6 and V < 96) then minOffset = V - 5; maxOffset = V + 4; end
   if(V >= 96) then minOffset = 91; maxOffset = 100; end
   for h=minOffset, maxOffset do
    local bName = AIBL_BlackListed[h];
    if not bName then bName = ""; end
     tinsert(AIBL_tempUserList, 1, bNme);
    end
   for k,v in ipairs(AIBL_tempUserList) do
    print(k, v);
    if (_G["AIBL_UserButton"..k]) then  _G["AIBL_UserButton"..k]:SetText(v); end
   end
  end
 end

 AIBlackList2:RegisterEvent("PLAYER_ENTERING_WORLD");
 tinsert(UISpecialFrames,AIBlackList2:GetName());
 
end

StaticPopupDialogs["AIBL_REMUSERCONFIRM"] = {
 text = "Are you suer you want to remove this user?",
 button1 = "yes",
 button2 = "Cancel",
 OnAccept = function(self, ...)
   AIBL_RemSelectedUser();
 end,
 timeout = 0,
 whileDead = true,
 hideOnEscape = true,
}
function AIBL_CleanTable()
 t = AutoInvite_Config["BlackListed"];
 for k,v in ipairs(t) do
  if(v == "") then tremove(t, k); end 
 end
 AutoInvite_Config["BlackListed"] = t
end
function AIBL_UserClick(button)
 
 if AIBL_LockButton then
  _G[AIBL_LockButton]:UnlockHighlight();
 end
 
 AIBL_LockButton = button;
 if _G[button]:GetText() then _G[button]:LockHighlight(); end
 
 local name = _G[button]:GetText();
 if not name then name = ""; end
 AIBL_UserDisplay:SetText(name);
 
end
function AIBL_UpdateDisplay()
 
 if not AutoInvite_Config["BlackListed"][1] then
  for i=1, 10 do
   _G["AIBL_UserButton"..i]:SetText("");
  end
  AIBL_UserDisplay:SetText("");
 end
 if (AutoInvite_Config["BlackListed"][1]) then
  AIBL_CleanTable();
  AIBL_BlackListed = AutoInvite_Config["BlackListed"];

  -- once again stolen mostly from AI Queue Manager

  AIBL_tempUserList = { };
  local V = AIBLSlider:GetValue();
  if(V <= 6) then minOffset = 1 ; maxOffset = 10; end
  if(V > 6 and V < 96) then minOffset = V - 5; maxOffset = V + 4; end
  if(V >= 96) then minOffset = 91; maxOffset = 100; end
 
  for h=minOffset, maxOffset do
   local bName = AIBL_BlackListed[h];
   if not bName then bName = ""; end
   local pos = # AIBL_tempUserList
   local pos = pos + 1;
   tinsert(AIBL_tempUserList, pos, bName);
  end
  local k = # AIBL_tempUserList
  local p = 1
 
  while k >= p do
   local dName = AIBL_tempUserList[k];
   if not dName then dName = ""; end
   if (_G["AIBL_UserButton"..k]) then _G["AIBL_UserButton"..k]:SetText(dName); end
   k = k - 1;
  end
  if AIBL_LockButton then
   _G[AIBL_LockButton]:UnlockHighlight();
  end
 
 end
end
function AIBL_AddUser()
 AIBL_BlackListed = AutoInvite_Config["BlackListed"];
 local name = strtrim(AIBL_InputUser:GetText());
 if strlen(name) > 0 then
  for k,v in ipairs(AIBL_BlackListed) do
   if v == name then 
    print("AI BlackList: User already existin the list.");
    return 
   end
  end 
   
  print("AI BlackList: Added user "..name.." to blacklist.");
  AIBL_InputUser:ClearFocus();
  tinsert(AIBL_BlackListed, 1, name);
  AIBL_UpdateDisplay();
 end 
 AIBL_InputUser:SetText("");
end
function BL2()
 if not AIBlackList2 then
  AIBlackList_OnLoad()
 end
 AIBL_CleanTable();
 AIBlackList2:Show();
end
function AIBL_RemSelectedUser()
 local name = AIBL_UserDisplay:GetText();
 if not name then name = ""; end

 if name ~= "" then
  local t = AutoInvite_Config["BlackListed"];
  local newT = {};
  if (t) then 
   for i,v in ipairs(t) do
    if t[i] ~= name then tinsert(newT, t[i]); end
   end
  end
  AutoInvite_Config["BlackListed"] = newT;
  print("AI: Removed "..name.." from the BlackList");
  AIBL_UserDisplay:SetText("");
  AIBL_UpdateDisplay();
 end 
end
function AIBlackList_OnComms(self, event, ...)
 local text = select(1, ...);
 local author = select(2, ...);
 if(event == "PLAYER_ENTERING_WORLD") then
  AIBlackList_InitializeSetup();
 end
end
function AIBlackList_InitializeSetup()
 AIBL_BlackListed = AutoInvite_Config["BlackListed"];
 AIBlackList:SetScale(UIParent:GetEffectiveScale());
 AIBLScrollBar:Show();
 AIBLScrollBar:EnableMouseWheel();
 if not AIBLcurrSelected then
  local nfs = AIBlackList:CreateFontString("AIBLcurrSelected", "OVERLAY", "GameFontNormal");
  nfs:SetPoint("TOPLEFT", 30, -210);
  nfs:SetText("Currently Selected:");
 end
 if not SelectedPlayerName then
  local nfs = AIBlackList:CreateFontString("SelectedPlayerName", "OVERLAY", "GameFontNormalLarge");
  nfs:SetPoint("TOPLEFT", 45, -235);
  nfs:SetText("");
 end
end

function AIBlackList_CheckCred(player)
 local t = AutoInvite_Config["AIBlackList"];
 if (t) then do 
  for i,v in ipairs(t) do
   if (t[i] == player) then
    result = true;
    return true end
   end
  end
 end
end
function AIBlackList_Toggle()
  if not AIBlackList2 then AIBlackList_OnLoad(); end
  if(AIBlackList2:IsVisible()) then AIBlackList2:Hide(); else AIBlackList2:Show(); end
 --AIBL = {};
 --for i=1,50 do AIBL[i] = "Test "..math.random(100); end
 --AIBlackList_ScrollFrame();
 --AIBlackList_CreateButtons();
 --for i=1,50 do MyModData[i] = "Test "..math.random(100); end
end
function AIBlackListAddPlayer()
 tinsert(AutoInvite_Config["AIBlackList"], 1, AIBLaddEditbox:GetText());
 DEFAULT_CHAT_FRAME:AddMessage("AIBlackList: Added Player ("..AIBLaddEditbox:GetText()..") to invite blacklist.");
 AIBLaddEditbox:SetText("");
 AIBLScrollBar_Update();
end
function AIBlackListRemoveConfirm()
 StaticPopupDialogs["AIBLREMOVE_CONFIRM"] = {
  text = "Un-BlackList: "..SelectedPlayerName:GetText().."?",
  button1 = "Yes",
  button2 = "No",
  OnAccept = function()
      AIBlackListRemovePlayer();
  end,
  timeout = 0,
  whileDead = true,
  hideOnEscape = true,
 }
 if SelectedPlayerName:GetText() then
  StaticPopup_Show("AIBLREMOVE_CONFIRM");
 end
end
function AIBlackListRemovePlayer()
  --Rebuild AIBlackList table
  local temp = AutoInvite_Config["AIBlackList"];
  local t = { };
  local player = _G["SelectedPlayerName"]:GetText();
  if player then
   for i,v in ipairs(temp) do
    if not (v == player) then tinsert(t, 1, temp[i]); end
   end
  end
  AutoInvite_Config["AIBlackList"] = t;
  AIBLScrollBar_Update();
end
function AIBLScrollBar_Update()
  local t = AutoInvite_Config["AIBlackList"];
  local line; -- 1 through 5 of our window to scroll
  local lineplusoffset; -- an index into our data calculated from the scroll offset
  FauxScrollFrame_Update(AIBLScrollBar,55,10,16);
  for line=1,10 do
    lineplusoffset = line + FauxScrollFrame_GetOffset(AIBLScrollBar);
    if lineplusoffset <= 50 then
      getglobal("AIBLEntry"..line):SetText(t[lineplusoffset]);
      getglobal("AIBLEntry"..line):Show();
    else
      getglobal("AIBLEntry"..line):Hide();
    end
  end
end
function AIBLScrollBar_MouseWheel(self, delta)
 if (delta == -1) then
  local p = AIBLScrollBar:GetVerticalScroll() + 16;
  if(p <= AIBLScrollBar:GetVerticalScrollRange()) then
   AIBLScrollBar:SetVerticalScroll(p);
  else
   AIBLScrollBar:SetVerticalScroll(AIBLScrollBar:GetVerticalScrollRange());
  end
 end
 if (delta == 1) then
  local p = AIBLScrollBar:GetVerticalScroll() - 16;
  if(p >= 0) then
   AIBLScrollBar:SetVerticalScroll(p);
  else
   AIBLScrollBar:SetVerticalScroll(0);
  end
 end
end
function AIBlackList_ButtonClick(id)
 local player = getglobal("AIBLEntry"..id):GetText();
 if not SelectedPlayerName then
  local nfs = AIBlackList:CreateFontString("SelectedPlayerName", "OVERLAY", "GameFontNormalLarge");
  nfs:SetPoint("TOPLEFT", 30, -235);
  if player then nfs:SetText(player); end
 else
  if player then SelectedPlayerName:SetText(player); end
 end 
end
