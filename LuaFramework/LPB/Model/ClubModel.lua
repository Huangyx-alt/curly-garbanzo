local base64 = require "Common/base64"
local ClubModel = BaseModel:New("ClubModel")

local this = ClubModel
--[[
   --公会id
      -- 消息id
      -- 消息类型 MessageType 1 = 系统消息 2 = 请求资源 3 = 卡包
      -- 发送人id
   -- 公会聊天记录 ClubMessageList 
      -- 昵称 
      -- 头像
      -- 头衔
   -- 公会人员 
     
      --领取人列表
      --红包id
      --领取总人数
      --红包类型
   -- 公会红包 --需要置顶

   -- 公会详细信息
      --总人数

]]--

local selfClubInfo = {} --个人公会信息
local clubList = nil 
local ClubMessageList = {} --公会得聊天记录--增量更新
local MessageisAll = true;
local MemberList = {} --成员列表
local RedDot = false  -- 可领取奖励

---------------------------消息返回----------------------------------

--查询公会信息
function ClubModel.S2C_ClubInfo(code,data)
   if code == RET.RET_SUCCESS then 
         -- data.clubs
         local SelfClubid = selfClubInfo.clubid
         if data and data.clubInfo  and SelfClubid == data.clubInfo.clubId then
            selfClubInfo={}
            selfClubInfo.resourceAskCdTime = data.resourceAskCdTime
            selfClubInfo.clubid = SelfClubid
            selfClubInfo.seasonCardAskCdTime = data.seasonCardAskCdTime
            selfClubInfo.clubPackets =  data.clubPackets --公会可发送礼盒列表
            selfClubInfo.ToppacketMsg =  data.packetMsg 
            selfClubInfo.MemberList = data.clubInfo.members
            selfClubInfo.clubInfo = data.clubInfo
            selfClubInfo.weeklyLeader = data.weeklyLeader

            for _,v in pairs(data.msgPackage.chatMsg) do 
               ClubMessageList[v.msgId] = v --根据msgId 排序增序
            end 

            for _,v in pairs(data.clubInfo.members) do 
               MemberList[v.uid] = v
            end 

            Facade.SendNotification(NotifyName.Club.GetSelfClubInfo)
         else 
            --发送查询别人的

         end

       RedDotManager:Check(RedDotEvent.club_reddot_event)
   end 
end

--加入公会
function ClubModel.S2C_Clubjoin(code, data)
    --需要用code展示弹窗
    Facade.SendNotification(NotifyName.Club.JoinClub, code)
end

--查询用户所在公会 
function ClubModel.S2C_ClubFetchList(code, data)
   local isExitData = (data ~= nil) and next(data)
   if code == RET.RET_SUCCESS and isExitData then
       local oldClubId, oldClubName = this.GetSelfClubID(), this.GetSelfClubName()
       
       selfClubInfo.MemberList = data.clubInfo.members
       for _,v in pairs(data.clubInfo.members) do
           MemberList[v.uid] = v
       end
       selfClubInfo.clubInfo = data.clubInfo
       selfClubInfo.clubid = data.clubInfo.clubId

       local curClubId = this.GetSelfClubID()
       --被踢出工会
       if oldClubId > 0 and curClubId == 0 then
           if  fun.get_active_scene().name =="SceneHome" then
               UIUtil.show_common_popup(30075, true, nil, nil, oldClubName)
               Facade.SendNotification(NotifyName.Club.BeKickedClub)
           else
               this.saveOldClubId = oldClubName
           end
       end

       Facade.SendNotification(NotifyName.Club.FetchClub)
    end
end

--获取公会列表
function ClubModel.S2C_ClubQueryList(code,data)
    if code == RET.RET_SUCCESS then
        clubList = data.clubs
        
        --回调
        if this.queryListCb then
            this.queryListCb()
        end
        
        --发送事件
        Facade.SendNotification(NotifyName.Club.QueryClub)
    end 
end 

--离开公会
function ClubModel.S2C_ClubQuit(code,data)
   if code == RET.RET_SUCCESS then
       -- data.clubs
       --清空数据 
       selfClubInfo = {}
       
       --可能没数据，本地缓存
       local cd = Csv.GetData("control", 163, "content")[1][1]
       this.nextJoinClubUnix_ = os.time() + cd
   
       ClubMessageList = {}
       MemberList = {}
       --发送事件
       Facade.SendNotification(NotifyName.Club.LeaveClub)
       RedDotManager:Check(RedDotEvent.club_reddot_event)
    end 
end 

--查询消息
function ClubModel.S2C_ClubRoomFetchMessage(code,data)
   if code == RET.RET_SUCCESS then 
      if not data then 
         log.r("S2C_ClubRoomFetchMessage eeeeroor")
         return 
      end 

      if data.msgPackage.hasMore ==false then 
         MessageisAll = data.msgPackage.hasMore --是否有更多的消息
      end 
      

      if data.msgPackage.msgNum  <= 0 then 
         return 
      end 

       local needFetchClubInfo = false
      for _,v in pairs(data.msgPackage.chatMsg) do 
         ClubMessageList[v.msgId] = v --根据msgId 排序增序
          
          --收到系统消息时更新公会数据
          if v.type == CLUB_CHAT_MESSAGE_TYPE.CHAT_TYPE_SYSTEM then
              needFetchClubInfo = true
          end

          --消息是自增的情况下，增加置顶礼盒
          if v.type == CLUB_CHAT_MESSAGE_TYPE.CHAT_TYPE_PACKET then 
               table.insert( selfClubInfo.ToppacketMsg,v)
          end 
      end
       if needFetchClubInfo then
           this.C2S_ClubFetchList()
       end

      --发送消息刷新事件
      Facade.SendNotification(NotifyName.Club.FetchMessageClub)
       RedDotManager:Check(RedDotEvent.club_reddot_event)
   end 
end 

--更新消息
function ClubModel.S2C_ClubRoomUpdateMessage(code,data)
   if code == RET.RET_SUCCESS then 
      -- data.clubs
      for _,v in pairs(data.msgPackage.chatMsg) do  
         ClubMessageList[v.msgId] = v --根据msgId 排序增序
      end 
      
      --发送消息修改的事件
      Facade.SendNotification(NotifyName.Club.UpdateMessageClub)
       RedDotManager:Check(RedDotEvent.club_reddot_event)
   end 
end 

--请求资源
function ClubModel.S2C_ClubRoomAskResource(code,data)
   if code == RET.RET_SUCCESS then 
      -- data.cdTime
      -- data.chatMsg
      if data ~= nil then 
         selfClubInfo.resourceAskCdTime = data.cdTime
         ClubMessageList[data.chatMsg.msgId] = data.chatMsg
          
         Facade.SendNotification(NotifyName.Club.AskResourceClub)
          RedDotManager:Check(RedDotEvent.club_reddot_event)
      end 
   end 
end

--资源帮助
function ClubModel.S2C_ClubRoomAskResHelp(code,data)
   if code == RET.RET_SUCCESS then 
      -- data.chatMsg
       
     -- ClubMessageList[data.chatMsg.msgId] = data.chatMsg
      if not data.reward then 
         return
      end 
      --奖励信息
      Facade.SendNotification(NotifyName.Club.AskResHelpClub,data.reward)
       RedDotManager:Check(RedDotEvent.club_reddot_event)
   end 
end 

--资源打开
function ClubModel.S2C_ClubRoomAskResOpen(code,data)
   if code == RET.RET_SUCCESS then 
      -- data.chatMsg --里面有资源相关信息
         ClubMessageList[data.chatMsg.msgId] = data.chatMsg

          --需要资源
         --奖励信息
         Facade.SendNotification(NotifyName.Club.AskResOpenClub)
       RedDotManager:Check(RedDotEvent.club_reddot_event)
   end 
end 

--卡牌请求
function ClubModel.S2C_ClubSeasonCardAsk(code,data)
   if code == RET.RET_SUCCESS then 
      -- data.cdTime
      if data ~= nil then 
         selfClubInfo.seasonCardAskCdTime = data.cdTime
      end 
      
      ClubMessageList[data.chatMsg.msgId] = data.chatMsg

      Facade.SendNotification(NotifyName.Club.SeasonCardAskClub)
      -- data.chatMsg
       RedDotManager:Check(RedDotEvent.club_reddot_event)
   end 
end   

--卡牌帮助
function ClubModel.S2C_ClubSeasonCardAskHelp(code,data)
   if code == RET.RET_SUCCESS then 
      ClubMessageList[data.chatMsg.msgId] = data.chatMsg

      Facade.SendNotification(NotifyName.Club.SeasonCardAskHelpClub,data.chatMsg.msgId)
       -- data.chatMsg
       RedDotManager:Check(RedDotEvent.club_reddot_event)
   end 
end   

--发送礼包
function ClubModel.S2C_ClubGiftPackageSend(code,data)
   if code == RET.RET_SUCCESS then 
      -- data.chatMsg

      if data ~= nil then 
         ClubMessageList[data.chatMsg.msgId] = data.chatMsg

         selfClubInfo.clubPackets =  data.clubPackets --公会可发送礼盒列表
      end 
      
      Facade.SendNotification(NotifyName.Club.GiftPackageSendClub)
       RedDotManager:Check(RedDotEvent.club_reddot_event)
   end 
end  

--打开礼包
function ClubModel.S2C_ClubGiftPackageOpen(code,data)
   if code == RET.RET_SUCCESS then 
      -- data.chatMsg
      ClubMessageList[data.chatMsg.msgId] = data.chatMsg
      Facade.SendNotification(NotifyName.Club.GiftPackageOpenClub,data.chatMsg.msgId)
       RedDotManager:Check(RedDotEvent.club_reddot_event)
   end 
end  

--感谢礼包
function ClubModel.S2C_ClubGiftPackageThank(code,data)
   if code == RET.RET_SUCCESS then 
      -- data.chatMsg

    --  ClubMessageList[data.chatMsg.msgId] = data.chatMsg
   end 
end 

function ClubModel.S2C_ClubinfoUpdata(code,data)
   if code == RET.RET_SUCCESS then 
      local SelfClubid = selfClubInfo.clubid
      if SelfClubid == data.clubId then 
         selfClubInfo.ToppacketMsg =  data.packetMsg 
         selfClubInfo.weeklyLeader = data.weeklyLeader
         Facade.SendNotification(NotifyName.Club.UpdateMessageClub)
          RedDotManager:Check(RedDotEvent.club_reddot_event)
      end 
     
   end 
end 

-----------------------------消息请求----------------------------------------------------

--公会查询
function ClubModel.C2S_ClubFetchList()
   this.SendMessage(MSG_ID.MSG_CLUB_FETCH,{q = ""}) --模糊查询
end 

--登录时-公会查询
function ClubModel.Login_C2S_ClubFetchList()
   this.SendMessage(MSG_ID.MSG_CLUB_FETCH,{q = ""}) --模糊查询
   return MSG_ID.MSG_CLUB_FETCH,Base64.encode(Proto.encode(MSG_ID.MSG_CLUB_FETCH,{q = ""}))
end 

--公会查询自己房间得信息
function ClubModel.C2S_ClubFetRoomInfo()
   if not selfClubInfo.clubid  or selfClubInfo.clubid  == 0 then 
      return;
   end 

   local clubid = selfClubInfo.clubid 
   this.SendMessage(MSG_ID.MSG_CLUB_FETCH_ROOM_INFO,{clubId = clubid}) 
end 

--公会查询自己房间得信息
function ClubModel.Login_C2S_ClubFetRoomInfo()
   if not selfClubInfo.clubid  or selfClubInfo.clubid  == 0 then 
      return nil,nil;
   end 

   local clubid = selfClubInfo.clubid 
   
   return MSG_ID.MSG_CLUB_FETCH_ROOM_INFO,Base64.encode(Proto.encode(MSG_ID.MSG_CLUB_FETCH_ROOM_INFO,{clubId = clubid}))
end 

--公会列表
function ClubModel.C2S_ClubQueryList(cb)
    this.queryListCb = cb
    this.SendMessage(MSG_ID.MSG_CLUB_QUERY,{q = ""}) --模糊查询
end

--公会离开
function ClubModel.C2S_ClubQuit()
   local clubID = this.GetSelfClubID()
   this.SendMessage(MSG_ID.MSG_CLUB_QUIT,{clubId = clubID})
end 

--公会加入
function ClubModel.C2S_Clubjoin(clubid)
    this.SendMessage(MSG_ID.MSG_CLUB_JOIN,{clubId = clubid})
end

--发送查询俱乐部消息
function ClubModel.C2S_ClubRoomFetchMessage()
   this.SendMessage(MSG_ID.MSG_CLUB_ROOM_FETCH_MSG,{})
end 

--消息更新 一般不发送
function ClubModel.C2S_ClubRoomUpdateMessage(msgId,historyFlag)
   local clubid = selfClubInfo.clubid 
   local ishostory = historyFlag or false 
   this.SendMessage(MSG_ID.MSG_CLUB_ROOM_UPDATE_MSG,{clubId =clubid,msgId = msgId,history = ishostory})
end

--发送请求资源
function ClubModel.C2S_ClubRoomAskResource(itemId)
   local clubid = selfClubInfo.clubid 

   this.SendMessage(MSG_ID.MSG_CLUB_ROOM_MSG_RS_ASK,{clubId = clubid,askId =itemId})
end

--发送资源帮助
function ClubModel.C2S_ClubRoomAskResHelp(msgId)
   local clubid = selfClubInfo.clubid 

   this.SendMessage(MSG_ID.MSG_CLUB_ROOM_MSG_RS_HELP,{clubId = clubid,msgId =msgId})
end 

--资源打开
function ClubModel.C2S_ClubRoomAskResOpen(msgId)
   local clubid =  selfClubInfo.clubid 

   this.SendMessage(MSG_ID.MSG_CLUB_ROOM_MSG_RS_OPEN,{clubId = clubid,msgId =msgId})
end 

--卡牌请求
function ClubModel.C2S_ClubSeasonCardAsk(cardId)
   local clubid =  selfClubInfo.clubid 
   this.SendMessage(MSG_ID.MSG_CLUB_ROOM_MSG_SEASON_CARD_ASK,{clubId = clubid,cardId =cardId,seasonId = ModelList.SeasonCardModel:GetCurSeasonId()})
end

--卡牌帮助
function ClubModel.C2S_ClubSeasonCardAskHelp(msgId)
   local clubid =  selfClubInfo.clubid 
   this.SendMessage(MSG_ID.MSG_CLUB_ROOM_MSG_SEASON_CARD_HELP,{clubId = clubid,msgId =msgId})
end 

--发送礼包
function ClubModel.C2S_ClubGiftPackageSend(packetId)
   local clubid =  selfClubInfo.clubid 
   this.SendMessage(MSG_ID.MSG_CLUB_ROOM_MSG_PACKET_SEND,{clubId = clubid,packetId =packetId})
end  

--打开礼包
function ClubModel.C2S_ClubGiftPackageOpen(msgId)
   local clubid =  selfClubInfo.clubid 
   this.SendMessage(MSG_ID.MSG_CLUB_ROOM_MSG_PACKET_OPEN,{clubId = clubid,msgId =msgId})
end  

--感谢礼包
function ClubModel.C2S_ClubGiftPackageThank(msgId)
   local clubid =  selfClubInfo.clubid 
   this.SendMessage(MSG_ID.MSG_CLUB_ROOM_MSG_PACKET_THANK,{clubId = clubid,msgId =msgId})
end

--------------------------------对外接口------------------------------------------

function ClubModel.HaveReaDot()
    local check
    local isClubOpen = ModelList.ClubModel.IsClubOpen()
    
    if isClubOpen == false then 
      return false;
    end 
   
    --存在可以帮助的资源请求
    table.each(ClubMessageList, function(message)
        if not check then
           --未过期的消息
            if message.type == CLUB_CHAT_MESSAGE_TYPE.CHAT_TYPE_RESOURCE_ASK and message.status == 0 then 
               local decoded = base64.decode(message.msgBase64)
                local chatInfo = Proto.decode(MSG_ID.MSG_CLUB_CHAT_RESOURCE_ASK, decoded)
               local cdTime = chatInfo.rewardUnix - os.time()
               
               if message.info.uid == ModelList.PlayerInfoModel:GetUid() then 
                  if cdTime > 0 and #chatInfo.players >0 and #chatInfo.players >= chatInfo.target then
                     check = true
                  end
               else 
                  local haveHelp = false
                  for _,v in pairs(chatInfo.players) do
                     if v.uid == ModelList.PlayerInfoModel:GetUid() then 
                        haveHelp = true 
                        break;
                     end 
                  end
                  if cdTime > 0 and haveHelp ==false and #chatInfo.players < chatInfo.target then
                        check = true
                  end
               end 
            elseif  message.type == CLUB_CHAT_MESSAGE_TYPE.CHAT_TYPE_PACKET and message.status == 0 then 
               local decoded = base64.decode(message.msgBase64)
                local ChatInfo = Proto.decode(MSG_ID.MSG_CLUB_CHAT_PACKET,decoded)
               local haveOpen = false 
               for _,v in pairs(ChatInfo.packetInfo) do 
                  if v.player.uid == ModelList.PlayerInfoModel:GetUid() then 
                     haveOpen = true 
                     break;
                  end
               end 
               if haveOpen == false then 
                  check = true
               end 
         end
        end
    end)

    if check then
        return check
    end
    
    --有可以打开的公会礼盒
    if selfClubInfo ~= nil and selfClubInfo.clubPackets ~= nil then
        for _,v in pairs(selfClubInfo.clubPackets) do
            if v.unix > os.time() then
                local count = fun.table_len(v)
                if count > 0 then
                    check = true
                    break
                end
            end
        end
    end
    
    return check
end

function ClubModel.GetMemeberInfo(uid)

   --公会成员id 获得具体信息

   return MemberList[uid]
end

function ClubModel.GetClubList()
    return clubList
end

function ClubModel.GetMemberList()
    if selfClubInfo then
        if selfClubInfo.clubInfo then
            return selfClubInfo.clubInfo.members
        end
    end
    
    return {}
end

function ClubModel.GetSelfClubInfo()
   return selfClubInfo
end

function ClubModel.GetSelfClubID()
    if selfClubInfo then
        if selfClubInfo.clubInfo then
            return selfClubInfo.clubInfo.clubId
        end
    end
    
    return 0
end

function ClubModel.GetSelfClubName()
    if selfClubInfo then
        if selfClubInfo.clubInfo then
            return selfClubInfo.clubInfo.name
        end
    end
end

function ClubModel.GetJoinClubRemainTime()
    local nextJoinClubUnix = this.GetNextJoinClubUnix() or 0
    local now = os.time()
    return nextJoinClubUnix - now
end

function ClubModel.GetNextJoinClubUnix()
    if selfClubInfo then
        if selfClubInfo.clubInfo and selfClubInfo.clubInfo.clubId == 0 then
            return selfClubInfo.clubInfo.nextJoinClubUnix
        end
    end

    return this.nextJoinClubUnix_ or 0
end

function ClubModel.GetMessageList()
   return ClubMessageList
end

function ClubModel.getMessageForid(msgid)
   return ClubMessageList[msgid]
end 

function ClubModel.CheckCanReqRes()
   local resourceAskCdTime = selfClubInfo.resourceAskCdTime or 0
   return (os.time() - resourceAskCdTime) >= 0
end

function ClubModel.CheckCanReqCard()
   local seasonCardAskCdTime = selfClubInfo.seasonCardAskCdTime or 0
   return (os.time() - seasonCardAskCdTime) >= 0
end

function ClubModel.GetReqResCd()
   local resourceAskCdTime = selfClubInfo.resourceAskCdTime or 0
   return resourceAskCdTime
end
function ClubModel.GetReqCardCd()
   local resourceAskCdTime = selfClubInfo.seasonCardAskCdTime or 0
   return resourceAskCdTime
end

--玩家是否加入了公会
function ClubModel.CheckPlayerHasJoinClub()
    local clubID = this.GetSelfClubID()
    return clubID and clubID > 0
end

--公会具体信息 人数，规则 限制等
function ClubModel.getClubinfo()
   return selfClubInfo.clubInfo 
end

--是否有置顶礼包
function ClubModel.getTopPackage()
   return selfClubInfo.ToppacketMsg 
end

--获得某个等级得礼包
function ClubModel.getClubGiftPack(level)
   local packData = {}
   
   if selfClubInfo ~= nil and selfClubInfo.clubPackets ~= nil then
      for _,v in pairs(selfClubInfo.clubPackets) do 
            if  Csv.GetRewardisLevel(v.itemId,level) and v.unix > os.time() then 
               table.insert(packData,v)
            end 
      end 
   end 
   
   return packData
end

--获得拥有的礼包的最高等级
function ClubModel.GetClubGiftHighestLevel()
    local level = 0
   
    table.each(selfClubInfo and selfClubInfo.clubPackets, function(data)
        local itemResult = Csv.GetData("item", data.itemId,"result")
        if itemResult and itemResult[2]  then
            if itemResult[2] > level then
                level = itemResult[2]
            end
        end
    end)
   
    return level
end

--是否达成开启Club的条件
function ClubModel.IsClubOpen()
    local playLevel = ModelList.PlayerInfoModel:GetLevel()
    local openLevel = Csv.GetData("level_open",27,"openlevel")
    if playLevel and openLevel then
        return playLevel >= openLevel
    end
    
    return false
end

--获取weeklyLeader数据
function ClubModel.getWeeklyLeader()
   return selfClubInfo.weeklyLeader
end

-------------------------------内部数据初始化---------------------------------------------------
function ClubModel:SetLoginData(data)
   selfClubInfo.clubid = data.roleInfo.clubId
end
 
--item 物品更新
function ClubModel:SetDataUpdate(data)
   if #data.clubPacket> 0 then -- 为空时就不再更新
      selfClubInfo.clubPackets = data.clubPacket
      
      Facade.SendNotification(NotifyName.Club.UpdatePackageCount)
   end 
end
----------------------------------逻辑处理----------------------------------------------------

 

 this.MsgIdList = 
 {
   { msgid = MSG_ID.MSG_CLUB_JOIN, func = this.S2C_Clubjoin},   
   { msgid = MSG_ID.MSG_CLUB_QUIT, func = this.S2C_ClubQuit},
   { msgid = MSG_ID.MSG_CLUB_FETCH, func = this.S2C_ClubFetchList},
   { msgid = MSG_ID.MSG_CLUB_QUERY, func = this.S2C_ClubQueryList},
   { msgid = MSG_ID.MSG_CLUB_FETCH_ROOM_INFO, func = this.S2C_ClubInfo},
   { msgid = MSG_ID.MSG_CLUB_ROOM_FETCH_MSG, func = this.S2C_ClubRoomFetchMessage},
   { msgid = MSG_ID.MSG_CLUB_ROOM_UPDATE_MSG, func = this.S2C_ClubRoomUpdateMessage },
   { msgid = MSG_ID.MSG_CLUB_ROOM_MSG_RS_ASK, func = this.S2C_ClubRoomAskResource },
   { msgid = MSG_ID.MSG_CLUB_ROOM_MSG_RS_HELP, func = this.S2C_ClubRoomAskResHelp },
   { msgid = MSG_ID.MSG_CLUB_ROOM_MSG_RS_OPEN, func = this.S2C_ClubRoomAskResOpen },
   { msgid = MSG_ID.MSG_CLUB_ROOM_MSG_SEASON_CARD_ASK, func = this.S2C_ClubSeasonCardAsk },
   { msgid = MSG_ID.MSG_CLUB_ROOM_MSG_SEASON_CARD_HELP, func = this.S2C_ClubSeasonCardAskHelp },
   { msgid = MSG_ID.MSG_CLUB_ROOM_MSG_PACKET_SEND, func = this.S2C_ClubGiftPackageSend },
   { msgid = MSG_ID.MSG_CLUB_ROOM_MSG_PACKET_OPEN, func = this.S2C_ClubGiftPackageOpen },
   { msgid = MSG_ID.MSG_CLUB_ROOM_MSG_PACKET_THANK, func = this.S2C_ClubGiftPackageThank },
   { msgid = MSG_ID.MSG_CLUB_ROOM_UPDATE_INFO, func = this.S2C_ClubinfoUpdata },
   
   --更新俱乐部房间消息
 }

return this