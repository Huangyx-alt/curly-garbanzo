--[[
    luaide  模板位置位于 Template/FunTemplate/NewFileTemplate.lua 其中 Template 为配置路径 与luaide.luaTemplatesDir
    luaide.luaTemplatesDir 配置 https://www.showdoc.cc/web/#/luaide?page_id=713062580213505
    author:{author}
    time:2024-02-29 11:00:03
]]

----玩法活动passmodel管理 ，每个玩法都对应不同pass

local EnumClassName = {
    PassDataComponent = "PassDataComponent",
    PassHelperView = "PassHelperView",
    PassView = "PassView",
    SpinRewardView = "SpinRewardView",
    TaskDataComponent = "TaskDataComponent",
    PassTaskView = "PassTaskView" ,
    PassIconView ="PassIconView",
    PassReceivedView = "PassReceivedView",
    PassRewardView = "PassRewardView",
    PassShowTipView = "PassShowTipView",
    PassPurchaseView = "PassPurchaseView",
}

local GameActivityPassModel = BaseModel:New("GameActivityPassModel")
local playid = -1
local this = GameActivityPassModel
local refreshTime = -1
local _allPassData = {}   -- 字典  key ：gameid   value :PB_ShortSeasonPassInfo
local _showPlayId = -1
local packageLoad = require "GamePlayShortPass.Base.GamePlayShortPassPackage"

local forceRefreshCallBack = nil
--local rouletePart = require("Model/ModelPart/PassRouleteModel")

--------------------------消息返回-----------------------------------
---
---
local debug = false
 
local mapping = {}
mapping[20] = "LeeToleManPass"   --TODO 配置
mapping[21] = "EasterPass"   --TODO 配置
mapping[22] = "VolcanoPass"   --TODO 配置
mapping[12] = "GemQueenPass"   --TODO 配置
mapping[26] = "MoleMinerPass"   --TODO 配置
mapping[23] = "PirateShip"   --海盗船配置
--- flag:短令牌 每次增加新的短令牌都要修改
mapping[27] = "Bison"   --野牛配置
mapping[28] = "HorseRacing"   --野牛配置
mapping[29] = "ScratchWinner"   --刮刮卡配置
mapping[30] = "GoldenTrain"   --金币火车配置
mapping[31] = "ChristmasSynthesis"   --配置
mapping[32] = "GotYou"   --配置
mapping[33] = "LetemRoll"   --配置
mapping[35] = "Solitaire"   --配置

function GameActivityPassModel.S2C_UpdatePassData(code,data)
    if(code == RET.RET_SUCCESS)then 

       
        if(data.pass)then 
          
            for k,v in pairs(data.pass) do


                log.r("lxq MSG_SHORT_SEASON_PASS_FETCH",v.playId)
                this.UpdateDataById(v.playId,v)
            end
        end 

        refreshTime = data.refreshTime

        if forceRefreshCallBack then
            forceRefreshCallBack()
            forceRefreshCallBack = nil
        end

        --if data.rouletteConfId then
        --    rouletePart.S2C_ResphoneRouletteInfo(RET.RET_SUCCESS, {rouletteConfId = data.rouletteConfId,
        --                                                           nextTime = data.endTime,message = "",code = 0 } )
        --end
    end
end







function GameActivityPassModel.S2C_OnUpdataBingopassInfo(code,data)
    if(code == RET.RET_SUCCESS)then 
        if(data.playId)then 
            local passData =  _allPassData[data.playId]
            if(passData==nil)then 
                log.e("查不到玩法"..data.playId)
                return 
            end
            local passDataCompont = passData[EnumClassName.PassDataComponent]
            if(not passDataCompont)then 
                log.e("compoment is nil ")
                return 
            end
            forceRefreshCallBack  = nil
            passDataCompont:S2C_OnUpdataBingopassInfo(RET.RET_SUCCESS,data)

            RedDotManager:Check(RedDotEvent.game_pass_reddot_event)
        end 
    end
end

---
function GameActivityPassModel.C2S_ForceRequestBingopassDetail(force,callBack)

    local passData =  _allPassData[this.GetCurrentId()]
    if(passData==nil)then
        log.e("查不到玩法"..data.playId)
        return
    end
    local passDataCompont = passData[EnumClassName.PassDataComponent]
    if(not passDataCompont)then
        log.e("compoment is nil ")
        return
    end
    forceRefreshCallBack = callBack
    passDataCompont:C2S_RequestBingopassDetail(force)
end

function GameActivityPassModel.S2C_OnRespondClaimReward(code,data)
    if(code == RET.RET_SUCCESS)then 
        if(data.playId)then  
            local passData =  _allPassData[data.playId]
            if(passData==nil)then 
                log.e("查不到玩法"..data.playId)
                return 
            
            end
            local passDataCompont = passData[EnumClassName.PassDataComponent]
            if(not passDataCompont)then 
                log.e("compoment is nil ")
                return 
            end
            passDataCompont:S2C_OnRespondClaimReward(RET.RET_SUCCESS,data)

            RedDotManager:Check(RedDotEvent.game_pass_reddot_event)
        end 
    end
end
function GameActivityPassModel.S2C_OnDiamondUplevel(code,data)
    if(code == RET.RET_SUCCESS)then 
        if(data.playId)then 
 
            local passData =  _allPassData[data.playId]
            if(passData==nil)then 
                log.e("查不到玩法"..data.playId)
                return 
            end
            local passDataCompont = passData[EnumClassName.PassDataComponent]
            if(not passDataCompont)then 
                log.e("compoment is nil ")
                return 
            end
            passDataCompont:S2C_OnDiamondUplevel(RET.RET_SUCCESS,data) 
            RedDotManager:Check(RedDotEvent.game_pass_reddot_event)
        end 
    end
end


--------------------------消息请求------------------------------------
---
---

function GameActivityPassModel:Login_C2S_UpdatePassData()
    return this:SendDataToBase64(MSG_ID.MSG_SHORT_SEASON_PASS_FETCH, {})  --debug
end



---------------------------对外接口------------------------------------
local iconPosStack = {}


function GameActivityPassModel.GetLoadModule()

    return EnumClassName
end


function GameActivityPassModel.GetCurrentPassExpProgress()
    local currentId = this.GetCurrentId()
    local passData = _allPassData[currentId]
    if passData == nil then
        log.e("passData is nil"..tostring(id))
        return
    end
    local passDataCompont = passData[EnumClassName.PassDataComponent]
    if(not passDataCompont)then 
        log.e("compoment is nil ")
        return 
    end
    return passDataCompont:get_exp_progress()
end


function GameActivityPassModel.GetCurrentPassRewardById(id)
    local currentId = this.GetCurrentId()
    local passData = _allPassData[currentId]
    if passData == nil then
        log.e("passData is nil"..tostring(id))
        return
    end
    local passDataCompont = passData[EnumClassName.PassDataComponent]
    if(not passDataCompont)then 
        log.e("compoment is nil ")
        return 
    end
    local ret = passDataCompont:GetRewardDataById(id)
    if(ret==nil and fun.IsEditor())then 
        log.e(tostring(id).." not found reward data ")
    end
    return ret
end




function GameActivityPassModel.SetIconPos(pos,isHallPos)
      if(pos~=nil)then 
        table.insert(iconPosStack,pos) 
      else
        local cout = GetTableLength(iconPosStack)
        iconPosStack[cout] = nil
      end
end

function GameActivityPassModel.GetIconPos()
    local cout = GetTableLength(iconPosStack)
     return   iconPosStack[cout]
end


function GameActivityPassModel.GetRemainTime()
    local id = this.GetCurrentId() 
    local passData =  _allPassData[id]
    if(passData)then 
        return passData[EnumClassName.PassDataComponent]:GetRemainTime()
    end
    return 0
end


function GameActivityPassModel.CurrentPlayIdHasReward()
    local id = this.GetCurrentId()
    return this.HasRewardById(id)
end

function GameActivityPassModel.HasRewardById(id)
    local passData =  _allPassData[id]
    if(passData)then 
        local isReward =  passData[EnumClassName.PassDataComponent]:HasReward() or passData[EnumClassName.TaskDataComponent]:HasReward() 
          return isReward
    end
    return false
end


function GameActivityPassModel.CheckRefreshTime()
    if(refreshTime~=nil and os.time()>=refreshTime)then 
        refreshTime = os.time()+99999---防止重复请求
        this.SendMessage(MSG_ID.MSG_SHORT_SEASON_PASS_FETCH,{})
    end
end

function GameActivityPassModel.IsExpiredById(id)
    this.CheckRefreshTime()
    local passData =  _allPassData[id]
    if(passData)then 
          return passData[EnumClassName.PassDataComponent]:IsExpired()
    end
    return true
end



function GameActivityPassModel.GetProgress(id)
    
    return 1/2
end

--- 短令牌Function 进度
function GameActivityPassModel.GetIconProgressOld()
    local curr = this.GetCurrExp()
    local currPlayId = this.GetCurrentId()
    local tCurrPassId =this.GetCurrPassId(currPlayId)
    tCurrPassId = tCurrPassId + 1
    local targetExp = Csv.GetData("task_pass",tCurrPassId,"exp")
    if not targetExp then
        tCurrPassId = tCurrPassId - 1
        targetExp = Csv.GetData("task_pass",tCurrPassId,"exp")
    end
    return curr,targetExp
end

--- 短令牌Function 进度
function GameActivityPassModel.GetIconProgress()
    local curr = this.GetCurrExp()
    local currPlayId = this.GetCurrentId()
    local tCurrPassId = this.GetCurrPassId(currPlayId)
    tCurrPassId = tCurrPassId + 1
    local targetExp
    if fun.is_not_null(Csv.task_pass) then
        for i, v in ipairs(Csv.task_pass) do
            if v.play_id == currPlayId and v.level == tCurrPassId then
                targetExp = v.exp
                break
            end
        end

        if not targetExp then
            tCurrPassId = tCurrPassId - 1
            for i, v in ipairs(Csv.task_pass) do
                if v.play_id == currPlayId and v.level == tCurrPassId then
                    targetExp = v.exp
                    break
                end
            end
        end
    end

    return curr, targetExp
end


function GameActivityPassModel.HasDataByCityData(id)
    local passData =  _allPassData[id]
    if(passData)then 
         return passData[EnumClassName.PassDataComponent]
    end
 end
 
 function GameActivityPassModel.GetCurPassDataComponent()
    local passData =  _allPassData[this.GetCurrentId()]
    if(passData)then 
         return passData[EnumClassName.PassDataComponent]
    end
 end
 

function GameActivityPassModel.GetPassDataComponentById(id)
   local passData =  _allPassData[id]
   if(passData)then 
        return passData[EnumClassName.PassDataComponent]
   end
end


function GameActivityPassModel.GetTaskDataComponentById(id)
    local passData =  _allPassData[id]
    if(passData)then 
         return passData[EnumClassName.TaskDataComponent]
    end
 end

function GameActivityPassModel.SetCurrentId(id)
    _showPlayId = id
end

function GameActivityPassModel.GetCurrentId()
 
    return _showPlayId
end

function GameActivityPassModel.CleanCurrentId()
    _showPlayId = -1
end

function GameActivityPassModel.GetPassDataById(id)
    local passData = _allPassData[id]
    if(passData)then 
        return passData.data.seasonInfo
    end
    return nil 
end

function GameActivityPassModel.GetTaskData()
    local id = this.GetCurrentId()
    local passData = _allPassData[id]
    if(passData)then
        return passData[EnumClassName.TaskDataComponent].data,passData.data.endTime
    end
    return nil 
end

function GameActivityPassModel.IsOpenPassById(id)
    local passData = _allPassData[id]
    if(passData)then 
        local isOpen = ( passData.endTime - os.time() )>0 
        return isOpen
    end
    return false 
end

function GameActivityPassModel.GetCurrPassId(id)
    local currentId = this.GetCurrentId()
    local passData = _allPassData[currentId]
    if passData == nil then
        log.e("passData is nil"..tostring(id))
        return
    end
    local passDataCompont = passData[EnumClassName.PassDataComponent]
    if(not passDataCompont)then
        log.e("compoment is nil ")
        return
    end
    return passDataCompont:GetLevel()
 end


 function GameActivityPassModel.GetCurrPassCout()
    local currentId = this.GetCurrentId()
    local passData = _allPassData[currentId]
    if passData == nil then
        return
    end
    local passDataCompont = passData[EnumClassName.PassDataComponent]
    if(not passDataCompont)then
        log.e("compoment is nil ")
        return
    end
    return passDataCompont:GetShowRewardDataCout()
 end


function GameActivityPassModel.GetCurrExp()
    local currentId = this.GetCurrentId()
    local passData = _allPassData[currentId]
    if passData == nil then
        log.e("passData is nil"..tostring(id))
        return
    end
    local passDataCompont = passData[EnumClassName.PassDataComponent]
    if(not passDataCompont)then
        log.e("compoment is nil ")
        return
    end
    return passDataCompont:GetExp()
end


---------------------------数据处理------------------------------------
 
function GameActivityPassModel:InitData()
    _allPassData = {}  

    Facade.RemoveCommand(NotifyName.GamePlayShortPassView.ShowGamePlayShortPassView)
    Facade.RegisterCommand(NotifyName.GamePlayShortPassView.ShowGamePlayShortPassView,CmdCommonList.CmdShowGamePlayShortPassView,self)
        
end


function GameActivityPassModel.GetMappingData()
  

    return mapping
end




function GameActivityPassModel.GetViewById(id,viewName)
    local mapping  = this.GetMappingData() 
    local ret
    
    if(_allPassData[id])then 
        local passData = _allPassData[id]
        local view = passData[viewName]
        return view
    end
    return nil 
    
end
 
function GameActivityPassModel.UpdateDataById(id,data)
    local mapping = this.GetMappingData() 

    if(not mapping[id])then 
        log.e("没有开发pass模块"..id)
        return 
    end 

    if(_allPassData[id])then 
        _allPassData[id].data = data  
    else
        local passClass = packageLoad:LoadPlayPackage(mapping[id],id)
        passClass.data = data   
        passClass.id = id
        _allPassData[id] = passClass
    end

    this.UpdatePassDataById(id,EnumClassName.PassDataComponent,data)
    this.UpdatePassDataById(id,EnumClassName.TaskDataComponent,data.tasks)
end


function GameActivityPassModel.UpdatePassDataById(id,EnumClassNameType,data)
    local passData = _allPassData[id]
    if passData == nil then
        log.e("passData is nil"..tostring(id))
        return
    end
    local passDataCompont = passData[EnumClassNameType]
    if(not passDataCompont)then 
        log.e("compoment is nil ")
        return 
    end
    passDataCompont:UpdateData(data)
end


----------------------------region 转盘-----------------------------------------------------

function GameActivityPassModel:GetRouletteInfo()
    return rouletePart:GetRouletteInfo()
end

function GameActivityPassModel:GetEnterRouletteInfo()
    return rouletePart:GetEnterRouletteInfo()
end


function GameActivityPassModel:IsFeeAvailable(isEnable)
    return rouletePart:IsFeeAvailable(isEnable)
end


function GameActivityPassModel:ResetRouletteInfo()
    return rouletePart:ResetRouletteInfo()
end

function GameActivityPassModel.S2C_ResphoneSpinRoulette(code,data)
    return rouletePart.S2C_ResphoneSpinRoulette(code,data)
end

function GameActivityPassModel.S2C_ResphoneClaimRouletteReward(code,data)
    return rouletePart.S2C_ResphoneClaimRouletteReward(code,data)
end

function GameActivityPassModel.S2C_PushRouletteRewardInfo(code,data)
    return rouletePart.S2C_PushRouletteRewardInfo(code,data)
end

----------------------------ednregion 转盘-----------------------------------------------------


 

----------------------------重载接口-----------------------------------------------------

this.MsgIdList = {
    {msgid = MSG_ID.MSG_SHORT_SEASON_PASS_FETCH, func = this.S2C_UpdatePassData}, 
    {msgid = MSG_ID.MSG_SHORT_SEASON_PASS_UP_LEVEL, func = this.S2C_OnUpdataBingopassInfo}, 
    {msgid = MSG_ID.MSG_SHORT_SEASON_PASS_RECEIVE, func = this.S2C_OnRespondClaimReward}, 
    {msgid = MSG_ID.MSG_SHORT_SEASON_PASS_DIAMOND_UP, func = this.S2C_OnDiamondUplevel},

    --- pass的事件监听，等待后端提供
    {msgid = MSG_ID.MSG_TASK_ROULETTE_START,func = this.S2C_ResphoneSpinRoulette},
    {msgid = MSG_ID.MSG_TASK_ROULETTE_RECEIVE,func = this.S2C_ResphoneClaimRouletteReward},
    {msgid = MSG_ID.MSG_TASK_ROULETTE_REWARD,func = this.S2C_PushRouletteRewardInfo},
}

return this 
