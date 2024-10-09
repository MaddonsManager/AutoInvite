-- Author      : Martag of Greymane
-- Create Date : 9/13/2008 7:04:28 PM

function AutoInvite_OnLoad()

 AutoInviteWindow:RegisterEvent("PLAYER_ENTERING_WORLD");
 AutoInviteWindow:RegisterEvent("CHAT_MSG_WHISPER");
 AutoInviteWindow:RegisterEvent("CHAT_MSG_GUILD");
 AutoInviteWindow:RegisterEvent("CHAT_MSG_SAY");
 AutoInviteWindow:RegisterEvent("CHAT_MSG_YELL");
 AutoInviteWindow:RegisterEvent("CHAT_MSG_CHANNEL");
 AutoInviteWindow:RegisterEvent("PARTY_MEMBERS_CHANGED");
 AutoInviteWindow:RegisterEvent("ADDON_LOADED");
 AutoInviteWindow:RegisterEvent("VARIABLES_LOADED");
 
 -- Set Scale, Hide Main Window
 AutoInviteWindow:SetScale(UIParent:GetEffectiveScale());
 AutoInviteWindow:Hide();
 
 -- No focused boxes, set cursor positions
 triggerEdit:SetAutoFocus(false);
 spamEdit:SetAutoFocus(false);
 maxRaiders:SetAutoFocus(false);
 snCustomChan:SetAutoFocus(false);
 

  
 tinsert(UISpecialFrames,AutoInviteWindow:GetName());
 -- Disable addon on first load
 inviteEnabled:SetChecked(nil);
 
 -- Slash Command Setup
 SlashCmdList["AUTOINVITE"] = AutoInviteSlashCmd;
 SLASH_AUTOINVITE1 = "/autoinvite";
 SLASH_AUTOINVITE2 = "/ai";
 DEFAULT_CHAT_FRAME:AddMessage("AutoInvite 2.3.5 :: Martag of Greymane.");
end

--[[ INITALIZE UNCTION ]]--

function AutoInvite_InitializeSetup()
 -- Do some beautification
 maxRaiders:SetNumeric(1);
 maxRaiders:SetTextInsets(5,0,0,0);
 triggerEdit:SetTextInsets(5,0,0,0);
 spamEdit:SetTextInsets(5,0,0,0);
 snCustomChan:SetTextInsets(5,0,0,0);
 
 -- Check Variables for Pre-existing values
 if not (AutoInvite_Config) then AutoInvite_Config = {}; end
 if not (AIQtimer_vars) then AIQtimer_vars = {}; end
 if not (queListDB) then queListDB = {}; end
 if not (AutoInvite_Config["BlackListed"]) then AutoInvite_Config["BlackListed"] =  { }; end

 if(AutoInvite_Config["whisperListen"] == nil) then AutoInvite_Config["whisperListen"] = "yes"; end
 if(AutoInvite_Config["spammsg"] == nil) then
  AutoInvite_Config["spammsg"] = 'Whisper me with \"<key>\" to receive an invite! ';
 end
 if(AutoInvite_Config["guildOnly"] == "yes") then guildOnly:SetChecked(1); end
 if(AutoInvite_Config["autoRaid"] == "yes") then autoRaid:SetChecked(1); end
 if(AutoInvite_Config["triggers"] == nil) then AutoInvite_Config["triggers"] = "invite101"; end
 if(AutoInvite_Config["guildListen"] == "yes") then guildListen:SetChecked(1); end
 if(AutoInvite_Config["queChkBox"] == "yes") then queChkBox:SetChecked(1); end
 
 -- Spam Check Boxes Initialize 
 if(AutoInvite_Config["snSay"] == "yes") then snSay:SetChecked(1); end
 if(AutoInvite_Config["snTrade"] == "yes") then snTrade:SetChecked(1); end
 if(AutoInvite_Config["snGuild"] == "yes") then snGuild:SetChecked(1); end
 if(AutoInvite_Config["snLFG"] == "yes") then snLFG:SetChecked(1); end
 if(AutoInvite_Config["snCustom"] == "yes") then
  snCustom:SetChecked(1);
  snCustomChan:SetText(AutoInvite_Config["snCustomChan"]);
 end
 if(AutoInvite_Config["snGeneral"] == "yes") then snGeneral:SetChecked(1); end
 
 -- maxRaiders box setup
 if(AutoInvite_Config["maxMembersBox"] == "yes") then maxMembersBox:SetChecked(1); end
 if(AutoInvite_Config["maxRaiders"] == nil) then AutoInvite_Config["maxRaiders"] = "25"; end
 
 -- Listening Channels Setup
 if(AutoInvite_Config["guildListen"] == "yes") then guildListen:SetChecked(1); end
 if(AutoInvite_Config["sayListen"] == "yes") then sayListen:SetChecked(1); end
 if(AutoInvite_Config["yellListen"] == "yes") then yellListen:SetChecked(1); end
 if(AutoInvite_Config["generalListen"] == "yes") then generalListen:SetChecked(1); end
 if(AutoInvite_Config["tradeListen"] == "yes") then tradeListen:SetChecked(1); end
 if(AutoInvite_Config["defenseListen"] == "yes") then defenseListen:SetChecked(1); end
 if(AutoInvite_Config["lfgListen"] == "yes") then defenseListen:SetChecked(1); end
 if(AutoInvite_Config["whisperListen"] == "yes") then whisperListen:SetChecked(1); end
 
 -- Fill in Edit Boxes
 maxRaiders:SetNumber(AutoInvite_Config["maxRaiders"]);
 triggerEdit:SetText(AutoInvite_Config["triggers"]);
 spamEdit:SetText(AutoInvite_Config["spammsg"]);
 
 -- PromoteWin Init
  AIPromote_Init = false;
end

--[[ AUTO INVITE EVENT HANDLER ]]--
function AutoInvite_OnComms(self, event, ...)

 local text = select(1, ...);
 local author = select(2, ...);
 
 if(event == "PLAYER_ENTERING_WORLD") then
  AutoInvite_InitializeSetup();
 end
 if(event == "PARTY_MEMBERS_CHANGED") then
  AutoInvite_ConvertToRaidCheck();
 end
 if(event == "CHAT_MSG_SAY") then
  if(sayListen:GetChecked()) then AutoInvite_InvUnitCheck(author, text); end
 end
 if(event == "CHAT_MSG_GUILD") and (guildListen:GetChecked()) then
  AutoInvite_InvUnitCheck(author, text);
 end
 if(event == "CHAT_MSG_WHISPER") then
  -- Insert Code for checking !promote <keys>
  local w1, txt = strsplit(" ", text);
  if(w1 == "!promote") and (AIPromoteEnabled:GetChecked()) then
   if(AIPromoteAutoAssistRadio:GetChecked()) then
    if AIPromote_IsKey(txt) and not AIBlackList_CheckCred(author) then 
     AIPromote_Assist(author)
    end
   elseif (AIPromoteAutoNotify:GetChecked()) then 
    DEFAULT_CHAT_FRAME:AddMessage("AutoInvite: "..author.." is requesting raid assist.");
   end
  else
   if (whisperListen:GetChecked()) then AutoInvite_InvUnitCheck(author, text); end
  end
 end
 if(event == "CHAT_MSG_YELL") and (yellListen:GetChecked()) then
  AutoInvite_InvUnitCheck(author, text);
 end
 if(event == "CHAT_MSG_CHANNEL") then
  -- Run Through All the Channels
  if(arg7 == 22) and (defenseListen:GetChecked()) then
   AutoInvite_InvUnitCheck(author, text);
  end
  if(arg7 == 2) and (tradeListen:GetChecked()) then 
   AutoInvite_InvUnitCheck(author, text);
  end
  if(arg7 == 1) and (generalListen:GetChecked()) then
   AutoInvite_InvUnitCheck(author, text);
  end
  if(arg7 == 26) and (lfgListen:GetChecked()) then
   AutoInvite_InvUnitCheck(author, text);
  end
 end
end

--[[ SPAM FUNCTION ]]--
function AutoInvite_Spam()
 if (inviteEnabled:GetChecked()) then 
  local spamtemp = AutoInvite_Config["spammsg"];  
  local spamtemp = strsub(string.gsub(spamtemp, "<key>", AutoInvite_Config["triggers"]),1,-2);
  local spamtemp = string.gsub(spamtemp, ";", " /");
  if (snGeneral:GetChecked()) then SendChatMessage(spamtemp, "CHANNEL", nil, 1); end  
  if (snSay:GetChecked()) then SendChatMessage(spamtemp, "SAY", nil); end  
  if (snTrade:GetChecked()) then SendChatMessage(spamtemp, "CHANNEl", nil, 2); end
  if (snLFG:GetChecked()) then SendChatMessage(spamtemp, "CHANNEL", nil, 4); end
  if (snGuild:GetChecked()) then SendChatMessage(spamtemp, "GUILD", nil); end
  if (snCustom:GetChecked()) then
   local index = GetChannelName(snCustomChan:GetText());
   SendChatMessage(spamtemp, "CHANNEL", nil, index);
  end
 else
  DEFAULT_CHAT_FRAME:AddMessage("[AutoInvite] Enable the Addon");
 end
end

--[[ SLASH COMMAND FUNCTION ]]--
function AutoInviteSlashCmd(aicmdtxt)
 local t = aicmdtxt;
 if(t == "") then AutoInvite_toggle(); end
 if(t == "enable") then inviteEnabled:SetChecked(1); end
 if(t == "disable") then inviteEnabled:SetChecked(nil); end
 if(t == "toggle") then AutoInvite_toggle(); end
 if(t == "r") then ReloadUI(); end
 if(t == "list") then AIQueList_Setup(); end
 if(t == "bl") then AIBlackList_Toggle(); end
 if(t == "promote") then AIPromoteWin_Toggle(); end
end

-- Clear Editbox Focus
function AutoInvite_ClearFoci()
 triggerEdit:ClearFocus();
 spamEdit:ClearFocus();
 maxRaiders:ClearFocus();
end

--[[ TOGGLE MAIN WINDOW FUNCTION ]]--
function AutoInvite_toggle()
 if not (AI_CloseButton) then
  local b = CreateFrame("Button", "AI_CloseButton", AutoInviteWindow, "UIPanelCloseButton");
  b:SetPoint("TOPRIGHT", -3, -3);
  b:Show();
 end
 spamEdit:SetCursorPosition(1);
 triggerEdit:SetCursorPosition(1);
 AutoInviteWindow:SetScale(UIParent:GetEffectiveScale());
 if(IsInGuild()) then GuildRoster(); end
 if(AutoInviteWindow:IsVisible()) then AutoInviteWindow:Hide(); else AutoInviteWindow:Show(); end
end

--[[ EDITBOX STICKY SETTINGS ]]--
function AutoInvite_editUpdate()
 AutoInvite_Config["triggers"] = triggerEdit:GetText();
 AutoInvite_Config["spammsg"] = spamEdit:GetText();
 AutoInvite_Config["snCustomChan"] = snCustomChan:GetText();
 AutoInvite_Config["maxRaiders"] = maxRaiders:GetNumber();
end

--[[ CHECKBOX STICKY SETTINGS ]]--

function AutoInvite_CheckBoxes()
 
 if(queChkBox:GetChecked()) then AutoInvite_Config["queChkBox"] = "yes"; else AutoInvite_Config["queChkBox"] = "no"; end
 if(guildOnly:GetChecked()) then AutoInvite_Config["guildOnly"] = "yes"; else AutoInvite_Config["guildOnly"] = "no"; end
 if(autoRaid:GetChecked()) then AutoInvite_Config["autoRaid"] = "yes"; else AutoInvite_Config["autoRaid"] = "no"; end
 if(maxMembersBox:GetChecked()) then AutoInvite_Config["maxMembersBox"] = "yes"; else AutoInvite_Config["maxMembersBox"] = "no"; end
 
 -- Where to Spam Check Boxes
 if(snGeneral:GetChecked()) then AutoInvite_Config["snGeneral"] = "yes"; else AutoInvite_Config["snGeneral"] = "no"; end
 if(snSay:GetChecked()) then AutoInvite_Config["snSay"] = "yes"; else AutoInvite_Config["snSay"] = "no"; end
 if(snTrade:GetChecked()) then AutoInvite_Config["snTrade"] = "yes"; else AutoInvite_Config["snTrade"] = "no"; end
 if(snGuild:GetChecked()) then AutoInvite_Config["snGuild"] = "yes"; else AutoInvite_Config["snGuild"] = "no"; end
 if(snLFG:GetChecked()) then AutoInvite_Config["snLFG"] = "yes"; else AutoInvite_Config["snLFG"] = "no"; end
 if(snCustom:GetChecked()) then
  AutoInvite_Config["snCustom"] = "yes";
  if(snCustomChan:GetText()) then
   AutoInvite_Config["snCustomChan"] = snCustomChan:GetText();
  end
 else
  AutoInvite_Config["snCustom"] = "no";
  if(snCustomChan:GetText()) then
   AutoInvite_Config["snCustomChan"] = snCustomChan:GetText();
  end
 end
 if(whisperListen:GetChecked()) then AutoInvite_Config["whisperListen"] = "yes"; else AutoInvite_Config["whisperListen"] = "no"; end
 if(guildListen:GetChecked()) then AutoInvite_Config["guildListen"] = "yes"; else AutoInvite_Config["guildListen"] = "no"; end
 if(sayListen:GetChecked()) then AutoInvite_Config["sayListen"] = "yes"; else AutoInvite_Config["sayListen"] = "no"; end
 if(yellListen:GetChecked()) then AutoInvite_Config["yellListen"] = "yes"; else AutoInvite_Config["yellListen"] = "no"; end
 if(generalListen:GetChecked()) then AutoInvite_Config["generalListen"] = "yes"; else AutoInvite_Config["generalListen"] = "no"; end
 if(tradeListen:GetChecked()) then AutoInvite_Config["tradeListen"] = "yes"; else AutoInvite_Config["tradeListen"] = "no"; end
 if(defenseListen:GetChecked()) then AutoInvite_Config["defenseListen"] = "yes"; else AutoInvite_Config["defenseListen"] = "no"; end
 if(lfgListen:GetChecked()) then AutoInvite_Config["lfgListen"] = "yes"; else AutoInvite_Config["lfgListen"] = "no"; end
end

--[[ CONVERT TO RAID FUNCTION ]]--
function AutoInvite_ConvertToRaidCheck()
 if not UnitInRaid("player") then
  if(IsPartyLeader()) and (GetNumPartyMembers() > 2) then
   if (autoRaid:GetChecked()) then
    DEFAULT_CHAT_FRAME:AddMessage("[AutoInvite] Converting to a Raid ");
    ConvertToRaid();
   end
  end
 end
end

--[[ INVITING MEMBERS FUNCTIONS ]]--

function AutoInvite_TriggerCheck(incmsg)
 msg = string.lower(incmsg);

 local triggers = { strsplit(";", strreplace(strtrim(string.lower(AutoInvite_Config["triggers"])), " ", "")) };
 for k, v in ipairs(triggers) do
  if string.find(msg, triggers[k]) then
   result = true
   return true --found a trigger, filter
  end
 end
 result = nil
--[[
 local triggs = AutoInvite_Config["triggers"];
 local t = { strsplit(" ", incmsg) };
 found = "false";
 for k,v in ipairs(t) do
  if(strfind(triggs, t[k])) then 
   found = "true";
   break
  end
 end
 if(found == "true") then return true
 else return false end
 
 ]]--
end

function AutoInvite_InvUnitCheck(unit, msg)
 if(inviteEnabled:GetChecked()) then
  if unit ~= UnitName("player") then
   if not (AIBlackList_CheckCred(unit)) then
    if (AutoInvite_TriggerCheck(msg)) then
     AutoInvite_ConvertToRaidCheck();
     if (IsPartyLeader()) or (IsRaidLeader()) or (GetNumPartyMembers() == 0) or (IsRaidOfficer()) then
      -- Run the Guild Only check
      if(guildOnly:GetChecked()) then
       if(UnitIsInMyGuild(unit)) then
        if(queChkBox:GetChecked()) then
         AIQueList_AddTo(unit, msg);
        else
         AutoInvite_InvUnit(unit);
        end
       else
        DEFAULT_CHAT_FRAME:AddMessage("[AutoInvite] "..unit.." denied for invite: Guild Only");
       end
      else
       if(queChkBox:GetChecked()) then
        AIQueList_AddTo(unit, msg);
       else
        AutoInvite_InvUnit(unit);
       end
      end  
     end
    end
   end
  end
 end
end
function AutoInvite_InvUnit(author)
 local person = author;
 if(maxMembersBox:GetChecked()) then
  if (UnitInRaid("player")) then
   local p = GetRealNumRaidMembers() + 1;
   if (p >= maxRaiders:GetNumber()) then
    SendChatMessage("[AutoInvite] There are no spots left.", "WHISPER", nil, person);
   else
    InviteUnit(person);
    SendChatMessage("[AutoInvite] Sending Invite", "WHISPER", nil, person);
   end
  else
   local p = GetNumPartyMembers() + 1;
   if(p <= maxRaiders:GetNumber()) then
    InviteUnit(person);
    SendChatMessage("[AutoInvite] Sending Invite", "WHISPER", nil, person);
   else
    SendChatMessage("[AutoInvite] There are no spots left.", "WHISPER", nil, person);
   end
  end  
 end
 if not(maxMembersBox:GetChecked()) then
  InviteUnit(person);
  SendChatMessage("[AutoInvite] Sending Invite", "WHISPER", nil, person);
 end
end

function aiqmsg(text)
 DEFAULT_CHAT_FRAME:AddMessage(text);
end

--[[ INVITE GUILD FUNCTION ]]--

function AutoInvite_inviteGuild()
 inviteEnabled:SetChecked(1);
 guildListen:SetChecked(1);
 if(IsInGuild()) then
  GuildRoster();
  SetGuildRosterShowOffline(false);
  SortGuildRoster("level");
  
  local x, t = GetNumGuildMembers();
  
  -- Clear Database
  if not queChkBox:GetChecked() then queChkBox:SetChecked(1); end
  if(queChkBox:GetChecked()) then queListDB = { }; end
  for x = 1, t do
   local name, rank, rankIndex, level, class, zone, note, officernote, online, status = GetGuildRosterInfo(x);
   -- InviteUnit(name);
   if(queChkBox:GetChecked()) then
    AIQueList_Setup();
    if name ~= UnitName("player") then
     if not (UnitInRaid(name) or UnitInParty(name)) then
      table.insert(queListDB, 1, name);
      AIQueList_Update();
     end
    end
   else
    if name ~= UnitName("player") then
     if not UnitInRaid(name) or UnitInParty(name) then
      InviteUnit(name);
     end
    end
   end
  end
 end
end

function AutoInviteList_OnLoad()
 AutoInviteList:SetScale(UIParent:GetEffectiveScale());
 tinsert(UISpecialFrames,AutoInviteList:GetName());
 AutoInviteList:Hide();
end


--[[ PLAYER QUEUE LIST FUNCTION/WINDOW ]]--
function AIQueList_Setup()

 if not (AI_QueueCloseButton) then
  local b = CreateFrame("Button", "AI_QueueCloseButton", AutoInviteList, "UIPanelCloseButton");
  b:SetPoint("TOPRIGHT", -3, -3);
  b:Show();
 end
 -- SLIDER
 
 local AIQueList = AutoInviteList;
 
 --[[ AIQueList.text = AIQueList:CreateFontString(AIQueList_PlayerVsMax, "OVERLAY", "GameFontNormal");
 AIQueList.text:SetPoint("TOPLEFT",15,-12);
 AIQueList.text:SetText("Group Numbers: X/Y"); ]]--

 AIQueList:SetScale(UIParent:GetEffectiveScale());
 AIQueList:Show();
 
 if not AISlider then
    local AISlider = CreateFrame('Slider','AISlider',AIQueList,'OptionsSliderTemplate');
 end
 AISlider:SetOrientation('VERTICAL');
 AISlider:ClearAllPoints();
 AISlider:SetHeight(295);
 AISlider:SetWidth(15);
 AISlider:SetPoint("TOPLEFT", 433, -45);
 AISlider:SetMinMaxValues(1, 100);
 AISlider:SetValue(1);
 getglobal(AISlider:GetName() .. 'Low'):SetText();
 getglobal(AISlider:GetName() .. 'High'):SetText();
 getglobal(AISlider:GetName() .. 'Text'):SetText();
 AISlider:SetValueStep(1);
 AISlider:SetScript("OnValueChanged", function() AIQueList_Update() end);
 AISlider:Show();
 AISlider:EnableMouseWheel(true);
 AISlider:SetScript("OnMouseWheel",  function(self, delta)
  local Curr = AISlider:GetValue();
  if(delta == 1) then AISlider:SetValue(Curr - 1); end
  if(delta == -1) then AISlider:SetValue(Curr + 1); end
 end);  
 --SLIDER END
 
 AIQueList_Update(); 
end

-- Create Button Function
function AIList_CreateButton(frame, text, name, x, y, w, h)
 local tempButton = CreateFrame("Button", name, _G[frame], "UIPanelButtonTemplate");
 tempButton:SetPoint("TOPLEFT",x,y);
 if not w then tempButton:SetWidth(28); else tempButton:SetWidth(w); end
 if not h then tempButton:SetHeight(20); else tempButton:SetHeight(h); end
 tempButton:SetText(text);
 tempButton:Show();
end
function AIQueList_Update()
  -- Show List, Slider Logic

 if(maxMembersBox:GetChecked()) then
   if (UnitInRaid("player")) then
    p = GetRealNumRaidMembers();
   else
    p = GetNumPartyMembers() + 1;
   end
   
   if (p < maxRaiders:GetNumber()) then
    _G["AIQueListPvM"]:Clear();
    _G["AIQueListPvM"]:AddMessage("Current Players: "..p.."/"..maxRaiders:GetNumber().."");
   end
   if(p >= maxRaiders:GetNumber()) then
    _G["AIQueListPvM"]:Clear();
    _G["AIQueListPvM"]:AddMessage("Current Players: Filled");
   end
 end
 if not (maxMembersBox:GetChecked()) then
  _G["AIQueListPvM"]:Clear();
  _G["AIQueListPvM"]:Hide();
 end
 
 local V = AISlider:GetValue();

 -- Setup mix/max from queListDB
 if(V <= 6) then Xmin = 1 ; Xmax = 10; end
 if(V > 6 and V < 96) then Xmin = V - 5; Xmax = V + 4; end
 if(V >= 96) then Xmin = 91; Xmax = 100; end
 
 -- Throw Xmin -> Xmax into temporary table
 tempList = { };
 for p = Xmin, Xmax do
  if(queListDB[p]) then
   table.insert(tempList, 1, queListDB[p]);
  else
   table.insert(tempList, 1, "");
  end
 end
 
 -- Throw tempList into the Window
 local t = tempList;
 for i,v in ipairs(t) do
  local a, b, c = strsplit("�",v);
  _G["AIQuePlayer"..i]:Clear();
  _G["AIQueComment"..i]:Clear();
  if(a) then _G["AIQuePlayer"..i]:AddMessage(a); else _G["AIQuePlayer"..i]:AddMessage(""); end
  if(c) then _G["AIQueComment"..i]:AddMessage(string.sub(c,1,21)); else _G["AIQueComment"..i]:AddMessage(""); end
 end
end

--[[ CLEAR QUEUE MANAGER ]]--
function AIQueClearAll()
 queListDB = { };
 AIQueList_Update();
end
--[[ ADD TO QEUUE MANAGER ]]--
function AIQueList_AddTo(username,comment)
 AIQueList_Setup();
 if not queListDB[1] then tinsert(queListDB, 1, ""..username.."�"..comment.."");
 else
  local s = # queListDB
  local string = strjoin("�", username, comment);
  table.insert(queListDB, s, string);
 end
 AIQueList_Update();
end

--[[ INVITE BUTTON FUNCTION ]]--
function AIQueList_InviteBtn(id)
 local player = tempList[id];
 local a, b, c = strsplit("�",player);
 AutoInvite_InvUnit(a);
 AIQueList_RemoveBtn(id);
end

--[[ REMOVE BUTTON FUNCTION ]]--
function AIQueList_RemoveBtn(id)
 if tempList[id] ~= "" then
 player, split, comment = strsplit("�",tempList[id]);
  for i,v in ipairs(queListDB) do
   local p, s, c = strsplit("�",queListDB[i]);
   if (player == p) then table.remove(queListDB,i); end
  end
 end
 AIQueList_Update();
end

--[[ INVITE ALL FUNCTIONS (TIMER/INVITEALL) ]]--
local total = 0;
function AIQueList_onUpdate(self, elapsed)
 if inviteListStatus == "enabled" then
  total = total + tonumber(elapsed);
  if inviteListCurr <= inviteListMax then
   if total >= .25 then
    local h = inviteListCurr;
     AutoInvite_InvUnit(inviteListUsers[h]);
    inviteListCurr = h + 1;
    total = 0;
   end
  end
  if inviteListCurr > inviteListMax then
   inviteListStatus = "disabled";
   queListDB = { };
   AIQueList_Update();
  end
 end 
end

function AIQueList_InviteAll()
 inviteList = { };
 inviteListUsers = { };
 for i,v in ipairs(queListDB) do
  local p, s, c = strsplit("�",queListDB[i]);
  table.insert(inviteListUsers, 1, p);
 end
 inviteListStatus = "enabled";
 inviteListCurr = 1;
 inviteListMax = table.getn(inviteListUsers);
end

--[[ INVITE ONLINE FRIENDS ]]--

function AutoInvite_InvOnlineFriends()
 queListDB = { };
 for i = 1, GetNumFriends() do
  name, level, class, area, connected, status, note, RAF = GetFriendInfo(i);
  if(connected) then
   if not queChkBox:GetChecked() then queChkBox:SetChecked(1); end
   AIQueList_Setup();
   if not (UnitInRaid(name) or UnitInParty(name)) then
    if(status) then name = name.."�"..status end
    table.insert(queListDB, 1, name);
    AIQueList_Update();
   end
  else 
   break
  end
 end
end