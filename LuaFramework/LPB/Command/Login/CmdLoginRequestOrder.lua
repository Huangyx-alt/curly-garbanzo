
local Command = {}
local this = Command

-- this.login_req_list =
-- {
--     ["PowerupCards"] =
--     {
--         req = function()
--             --重连时候，战斗中的不发这条，后端会立即结算
--             if not ModelList.BattleModel:IsGameing() and not ModelList.GuideModel:IsJumpPower() then
--                 ModelList.CityModel.C2S_FetchPowerUp()
--             end
--         end,
--         req_index = 2,
--     },
--     ["TaskInfo"] = 
--     {
--         req = function()
--             ModelList.TaskModel:C2S_FetchTask()
--         end,
--         req_index = 3,
--     },
--     ["ShopInfo"] = 
--     {
--         req = function()
--             --ModelList.MainShopModel.C2S_FetchShopInfo(SHOP_TYPE.SHOP_TYPE_ITEMS)
--         end,
--         req_index = 4,
--     },
--     ["TournamentInfo"] = 
--     {
--         req = function()
--             ModelList.TournamentModel.C2S_RequestMyTournamentInfo()
--         end,
--         req_index = 5,
--     },
--     ["RoulettleInfo"] = 
--     {
--         req = function()
--             ModelList.RouletteModel.C2S_RequestRouletteInfo()
--         end,
--         req_index = 6,
--     },
--     ["MailListInfo"]=
--     {
--         req = function()
--             ModelList.MailModel.C2S_RequestMailList()
--         end,
--         req_index = 7,
--     },
--     ["BingoPassInfo"]=
--     {
--         req = function()
--             ModelList.BingopassModel:C2S_RequestBingopassDetail2()
--         end,
--         req_index = 8,
--     },
--     -- ["MiniGameBoxInfo"] = {
--         -- req = function()
--             -- ModelList.MiniGameModel:RequestMiniGameLayerInfo()
--         -- end,
--         -- req_index = 9,
--     -- },
  
--     ["TournamentInfoJoin"] = 
--     {
--         req = function()
--             ModelList.TournamentModel.C2S_RequestMyTournamentJoinInfo()
--         end,
--         req_index = 9,
--     },
--     ["avatarData"] = 
--     {
--         req = function()
--             ModelList.PlayerInfoSysModel.C2S_RequestAvatarList()
--         end,
--         req_index = 10,
--     },
--     ["frameData"] = 
--     {
--         req = function()
--             ModelList.PlayerInfoSysModel.C2S_RequestAvatarFrameList()
--             ModelList.PlayerInfoModel:CheckDeeplinkInfo() -- 检查deeplink消息
--         end,
--         req_index = 11,
--     },

--     ---[[
--     ["UltraBetData"] = 
--     {
--         req = function()
--             ModelList.UltraBetModel.C2S_RequestUltraBetInfo()
--         end,
--         req_index = 12,
--     },
--     --]]

--     ---[[
--     ["SeasonCardActivityData"] = 
--     {
--         req = function()
--             --ModelList.SeasonCardModel:C2S_SeasonInfo()
--             ModelList.SeasonCardModel:C2S_CardGroupList(0)
--         end,
--         req_index = 13,
--     },
--     --]]

--     --]]    ---[[
--     ["PlayerClubInfo"] =
--     {
--         req = function()
--             ModelList.ClubModel.C2S_ClubFetchList()
--             ModelList.ClubModel.C2S_ClubFetRoomInfo()
--         end,
--         req_index = 14,
--     },
--     ["PlayerAdInfo"] =
--     {
--         req = function()
--             ModelList.AdModel.Check_WathchAdResult()
--         end,
--         req_index = 15,
--     },
--     --]]
    
    
--     ---[[
--     ["CompetitionData"] =
--     {
--         req = function()
--             ModelList.CompetitionModel.ReqCompetitionOptions()
--         end,
--         req_index = 16,
--     },
--     --]]
























































--     ----------------------------提示信息，请勿删除-------------------------------------
--     --添加登录请求队列，请记得修改最后请求的消息返回后再发送登录成功跳转场景（LoginRequestComplete）
--     ----------------------------提示信息，请勿删除-------------------------------------
--     ["RegularlyAwardInfo"] =
--     {
--         req = function()
--             ModelList.regularlyAwardModel.C2S_FetchRegularlyAwardInfo(this.LoginRequestComplete)
--         end,
--         req_index = 100000,
--     },
-- }

function Command.LoginRequestComplete()
    log.g("Command.LoginRequestComplete =>>>>>>>>>>>")

    if fun.get_active_scene().name == "SceneLogin" or fun.get_active_scene().name == "SceneLoading" then
        Facade.SendNotification(NotifyName.Login.LoginSuccess)
    end
end

-- function Command:SortReqList()
--     local sort_req_list = {}
--     for k,v in pairs(this.login_req_list) do
--         local info = {}
--         info.name = k
--         info.func = v.req
--         info.index = v.req_index or 1
--         sort_req_list[#sort_req_list + 1] = info
--     end
--     table.sort( sort_req_list, function(a,b)
--         return a.index < b.index
--     end)

--     return sort_req_list
-- end
local count = 0
function Command.Execute(notifyName, ...)
    --- 等待网络连接上再发请求
    if this.loopWaitConnect then
        LuaTimer:Remove(this.loopWaitConnect)
    end
    if Network.isConnect and ModelList.loginModel:IsGetEnterRes() then
        Command.ExecuteReq()
    else
       this.loopWaitConnect =  LuaTimer:SetDelayLoopFunction(0.1,0.5,100,function()
            if Network.isConnect and ModelList.loginModel:IsGetEnterRes() then
                Command.ExecuteReq()
                LuaTimer:Remove(this.loopWaitConnect)
            end
        end,function()
           if not Network.isConnect then
               --this.Execute(notifyName,...)
               log.r("Error: network is not connected!!!!")
           end
       end,nil,LuaTimer.TimerType.UI)
    end
end


function Command.ExecuteReq(notifyName, ...)
    local req_list ={} -- this:SortReqList()
   
    --此处添加需要 登录发送的消息
    if not ModelList.BattleModel:IsGameing() and not ModelList.GuideModel:IsJumpPower() then
        table.insert( req_list, {ModelList.CityModel.Login_C2S_FetchPowerUp()})
    end
    table.insert( req_list, {ModelList.TaskModel.Login_C2S_FetchTask()}) 
    -- table.insert( req_list, {ModelList.MainShopModel.Login_C2S_FetchShopInfo(SHOP_TYPE.SHOP_TYPE_ITEMS)}) 
    -- table.insert( req_list, {ModelList.MainShopModel.Login_C2S_FetchShopInfo(SHOP_TYPE.SHOP_TYPE_CHIPS)}) 
    -- table.insert( req_list, {ModelList.MainShopModel.Login_C2S_FetchShopInfo(SHOP_TYPE.SHOP_TYPE_DIAMONDS)}) 
    -- table.insert( req_list, {ModelList.MainShopModel.Login_C2S_FetchShopInfo(SHOP_TYPE.SHOP_TYPE_OFFERS)}) 
    --table.insert( req_list, {ModelList.TournamentModel.Login_C2S_RequestMyTournamentInfo()}) 
    table.insert( req_list, {ModelList.RouletteModel.Login_C2S_RequestRouletteInfo()}) 
    table.insert( req_list, {ModelList.MailModel.Login_C2S_RequestMailList()}) 
    table.insert( req_list, {ModelList.BingopassModel.Login_C2S_RequestBingopassDetail()}) 
    --table.insert( req_list, {ModelList.TournamentModel.Login_C2S_RequestMyTournamentJoinInfo()})
    table.insert( req_list, {ModelList.PlayerInfoSysModel.Login_C2S_RequestAvatarList()})  
    table.insert( req_list, {ModelList.PlayerInfoSysModel.Login_C2S_RequestAvatarFrameList()})
    table.insert( req_list, {ModelList.PlayerInfoModel.Login_C2S_CheckDeeplinkInfo()})
    table.insert( req_list, {ModelList.UltraBetModel.LoginC2S_RequestUltraBetInfo()})
    table.insert( req_list, {ModelList.SeasonCardModel:Login_C2S_CardGroupList(0)})
    table.insert( req_list, {ModelList.ClubModel.Login_C2S_ClubFetchList()})
    table.insert( req_list, {ModelList.ClubModel.Login_C2S_ClubFetRoomInfo()})
    table.insert( req_list, {ModelList.AdModel.Login_Check_WathchAdResult()})  --中间有不需要返回数据的处理
    table.insert( req_list, {ModelList.CompetitionModel.Login_ReqCompetitionOptions()})
    table.insert( req_list, {ModelList.RegularlyAwardModel.Login_C2S_FetchRegularlyAwardInfo()})
    table.insert( req_list, {ModelList.WinZoneModel:Login_C2S_VictoryBeatsInfo()})
    table.insert( req_list, {ModelList.GameActivityPassModel:Login_C2S_UpdatePassData()})   
    table.insert( req_list, {ModelList.VolcanoMissionModel:Login_C2S_UpdateMissionData()})   
    table.insert( req_list, {ModelList.HallofFameModel:C2S_RequestEntrance()})   

    
    table.insert( req_list, {ModelList.CompetitionModel.Login_C2S_CompetitionRankInfo()}) --2024/3/27 19:18:45 赛车活动和饼干共存
    table.insert( req_list, {ModelList.CarQuestModel.Login_C2S_RacingFetch()}) --2024/3/27 19:18:45 赛车活动和饼干共存
    table.insert( req_list, {ModelList.SmallGameModel.Login_C2S_Fetch()}) --[2025-02-07]增加mini小游戏请求
    table.insert( req_list, {ModelList.NewPuzzleModel.Login_C2S_Fetch()}) --[2025-02-07]增加mini小游戏请求
    table.insert( req_list, {ModelList.MainShopModel.C2S_FetchPU()}) --[2025-08-26]拥有PU请求
    table.insert( req_list, {ModelList.MiniGameModel.RaqMiniGameFetch()}) --[2025-08-26]请求小游戏
    log.g(req_list)
    Message.AddMessage(MSG_ID.MSG_GENERIC_MERGE_MESSAGE,  Command.MessageHandle)
    
    local reqMsg ={}
    for _,v in ipairs(req_list) do
        if v[1] ~= nil then 
            table.insert( reqMsg, {msgId = v[1],msgBase64=v[2]})
        end 
    end 
    Network.SendMessage(MSG_ID.MSG_GENERIC_MERGE_MESSAGE,{isLogin = true,reqMsg =reqMsg},false,true)


end

function Command.MessageHandle(code,data)
    Message.RemoveMessage(MSG_ID.MSG_GENERIC_MERGE_MESSAGE)
    if code == RET.RET_SUCCESS then 
        if data and data.nextMessages then 
            table.each(data.nextMessages,function(v)
                local body = Base64.decode(v.msgBase64)
                local ret = Proto.decode(v.msgId, body)

                log.w(" MSG_GENERIC_MERGE_MESSAGE DispatchMessage"..tostring(v.msgId).." bodystr "..tostring(v.msgBase64))
                Message.DispatchMessage(v.msgId, v.code, ret)
                
            end)

            this.LoginRequestComplete()

        else 
            log.r("MSG_ID.MSG_GENERIC_MERGE_MESSAGE =>!!!!!!>>>>>>>>>>>>> data error error error ")
        end
        Network.ResendNeedResendMsg()
    else 
        log.r("MSG_ID.MSG_GENERIC_MERGE_MESSAGE =>!!!!!!>>>>>>>>>>>>>not SUCCESS "..tostring(code))
    end 
end 

return Command
