local ExtraBonusModel = BaseModel:New("MailModel")


local this = ExtraBonusModel
local ExtraInfoList = {}
local newGeterInfo = nil 
local currCoinAmount = 0
---------------------------------------消息交互-----------------------------------------------
--获取额外奖励得信息， 进房间得时候传
function ExtraBonusModel.S2C_GetExtraInfo(code,data) 

    if(code == RET.RET_SUCCESS) then
        currCoinAmount =  data.coinAmount
        for _,v in pairs(data.itemList) do
            --key = uid + 时间戳
            ExtraInfoList[v.uid+"_"+v.getTime] = v
        end

        if #data.itemList ==1 then 
            local info = this.TransInfo(data.itemList[1])
            Facade.SendNotification(NotifyName.ExtraBonus.ShowOthGetReward,info)
        end 

        Facade.SendNotification(NotifyName.ExtraBonus.ShowOthGetReward,currCoinAmount)
        --推送金额
    end 
end 

function ExtraBonusModel.C2S_GetExtraInfo(playId)
    playId = playId or 1  --传玩法id

    this.SendMessage(MSG_ID.MSG_EXTRA_INFO,{page=playId})
end

function ExtraBonusModel.C2S_ExtraReward()
    this.SendMessage(MSG_ID.MSG_EXTRA_REWARD,{})
end

function ExtraBonusModel.S2C_ExtraReward(code,data)
    if(code == RET.RET_SUCCESS) then
        --展示个人获奖界面
        newGeterInfo = data.reward
    end 
end

-------------------------------逻辑代码---------------------------------------------------------------

function ExtraBonusModel.TransInfo(data)
   local info ={}
   local timeCount =  ModelList.PlayerInfoModel.get_cur_server_time()
   info.uid = data.uid
   info.BetCount = data.bet
   info.cardNum = data.cardNum
   info.CoinCount = data.coinSpend
   info.ReawardCount = data.coinReward

   --初始化头像和名字
   if data.robot == 1 then 
        info.avatar =Csv.GetData("robot_name", info.id, "icon")
        info.nickName =Csv.GetData("robot_name", info.id, "name")
   else
        info.avatar = data.avatar
        info.nickName = data.nickName
   end 

   --初始化时间
   info.DayCount = math.floor((timeCount-data.getTime) /86400) 

   return info 
end 

--------------------------------外部接口---------------------------------------------------------------------------
--获得前六个
function ExtraBonusModel.GetSixExtraList()
    local len = #ExtraInfoList
    local maxCount = len >6 and 6 or len
    local index = 1
    local data = {}
    table.sort(ExtraInfoList,function (a,b)
        return a.getTime < b.getTime
    end)

    for _,v in pairs(ExtraInfoList) do
        if index >= maxCount then 
            local tmp = this.TransInfo(v)
            data[index] = tmp
            index = index +1
        else 
            break;
        end
    end 

    return data
end

this.MsgIdList = 
{
    { msgid = MSG_ID.MSG_EXTRA_INFO, func = this.S2C_GetExtraInfo },
    { msgid = MSG_ID.MSG_EXTRA_REWARD, func = this.S2C_ExtraReward },
    
}

return this 