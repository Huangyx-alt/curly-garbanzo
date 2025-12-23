--[[
    luaide  模板位置位于 Template/FunTemplate/NewFileTemplate.lua 其中 Template 为配置路径 与luaide.luaTemplatesDir
    luaide.luaTemplatesDir 配置 https://www.showdoc.cc/web/#/luaide?page_id=713062580213505
    author:{author}
    time:2024-02-29 14:46:44
]]


local BasePassDataComponent = class("BasePassDataComponent",BaseModel)--Clazz(ClazzBase, "BasePassDataComponent")
local this = BasePassDataComponent

local csv_data_name = "task_pass"




BingoPassPayType = {Pay499 = 1,Pay999 = 2,Pay500 = 3}


function BasePassDataComponent:ctor(id)
    self.id = id 
    self._level = 0
    self.bingopass_info = nil 
    self.requestDetail = nil
    self.freeReceivedCache = nil
    self.payReceivedCache = nil
    self.receiveRewardData = nil
    self._exp = nil 
    self.priceItem = nil
    self._expCount = nil 
    self._hasReward = false 
    self._showRewardDatas = {}  --展示的奖励数据，原读表，现在修改成直接由服务器下发，原因是分组及玩法增多，导致表结构变大，影响后期性能 
 end

function BasePassDataComponent:SetHasReward(reward)

    if(self._hasReward~=reward)then 
        RedDotManager:Check(RedDotEvent.game_pass_reddot_event)
    end

    self._hasReward = reward
end



function BasePassDataComponent:SetShowRewardDatas(datas)
    -- self._showRewardDatas = datas
    self._showRewardDatas = {}
    for k,v in pairs(datas) do
        local rewardData = {}
        rewardData.id = v.level
        rewardData.level = v.level
        rewardData.exp = v.exp
        rewardData.sum_exp = v.sumExp
        rewardData.unlock_diamond = v.diamond
        rewardData.free_reward =   fun.stringToTable(v.freeReward)  --string.split(v.freeReward,",") --v.freeReward
        rewardData.free_reward_icon = v.freeRewardIcon
        rewardData.pay_reward = fun.stringToArrays(v.payReward)--v.payReward
        rewardData.pay_reward_icon = v.payRewardIcon
        self._showRewardDatas[v.level] = rewardData
    end
end


function BasePassDataComponent:GetRewardDataById(id) 
    return self._showRewardDatas[id]
end


function BasePassDataComponent:GetShowRewardDataCout() 
    return GetTableLength(self._showRewardDatas)
end

 
 function BasePassDataComponent:UpdateData(data)
     self.data = data 
     self:S2C_OnReceiveBingopassDetail(RET.RET_SUCCESS,self.data) 
     self:SetLevel(self.data.curPassId)
     self:SetHasReward(self.data.hasReward)
     self:SetShowRewardDatas(self.data.rewards)
 end


function BasePassDataComponent:InitData()
    self.bingopass_detail = {}
end

function BasePassDataComponent:SetLoginData(data)
end

function BasePassDataComponent:get_price()
    if self.bingopass_detail and self.bingopass_detail.seasonInfo then
        return self.bingopass_detail.seasonInfo.price
    end
    return "0"
end

function BasePassDataComponent:get_productId()
    if self.bingopass_detail and self.bingopass_detail.seasonInfo then
        return self.bingopass_detail.seasonInfo.productId
    end
    return 0
end

--获取折扣
function BasePassDataComponent:get_booster()
    if self.bingopass_detail and self.bingopass_detail.booster then
        return self.bingopass_detail.booster
    end 
    return 100
end 

function BasePassDataComponent:get_priceItem()
    if self.bingopass_detail 
    and self.bingopass_detail.seasonInfo 
    and self.priceItem == nil then
        self.priceItem = Split(self.bingopass_detail.seasonInfo.priceItem,",")
    end
    return self.priceItem or "0"
end

 
function BasePassDataComponent:get_progress()
    local csv_data_name = "task_pass"
    local totalItemCount =   self:GetShowRewardDataCout() --#Csv[csv_data_name] - 1 --最终奖励不放一起，独立开来了
    local progress = self:GetRewardLevel()

    return progress,totalItemCount
end

function BasePassDataComponent:get_exp_progress()
     

    return self:GetExp(),self:GetExpCount()
end

function BasePassDataComponent:GetRewardLevel()
    if self:IsAnyPayment() then
        return self:GetLevel()
    else
        local curLevel = self:GetLevel()
        local temLevel = curLevel
        while true do
            local passData =  self:GetRewardDataById(math.max(1,temLevel)) -- Csv.GetData(csv_data_name,math.max(1,temLevel),"free_reward")
            if not passData then
                break
            end
            if passData[1] and passData[1] > 0 then
                break
            end
            temLevel = math.max(1,temLevel - 1)
        end
        return (self:IsFreeReceived(temLevel) 
        and {curLevel} 
        or {temLevel})[1]
    end
end
 

function BasePassDataComponent:get_payDifference()
    if self.bingopass_detail and self.bingopass_detail.seasonInfo then
        return self.bingopass_detail.seasonInfo.payDifference
    end
    return "0"
end

function BasePassDataComponent:get_productDifference()
    if self.bingopass_detail and self.bingopass_detail.seasonInfo then
        return self.bingopass_detail.seasonInfo.productDifference
    end
    return 0
end


function BasePassDataComponent:get_description()
    if self.bingopass_detail and self.bingopass_detail.seasonInfo then
        return self.bingopass_detail.seasonInfo.description
    end
    return 0
end

 

function BasePassDataComponent:IsBingoPassActivate()
    return self.bingopass_info ~= nil
end

function BasePassDataComponent:CheckRedDot()
    if self.bingopass_detail then
        local level = self:GetLevel()
        local isFreeRedDot = level > 0
        while true do
            if 0 == level then
                break
            end
            local received = self:IsFreeReceived(level)
            if received ~= nil then
                isFreeRedDot = not received
                break
            else
                local data = self:GetRewardDataById(level)  --Csv.GetData(csv_data_name,level,"free_reward")
                if data and data[1] and data[1] > 0 then
                    isFreeRedDot = true
                    break
                end
            end
            level = math.max(0,level - 1)
        end
        if self:GetLevel() == 0 then --如果是零级的情况，是没有免费与支付的
            return false 
        else
            return isFreeRedDot or self:IsPayNoClaim(self:GetLevel())
        end 
    else
        return self.bingopass_info and self.bingopass_info.hasReward
    end
end

 

function BasePassDataComponent:GetRemainTime()
    if self.bingopass_detail then
        return math.max(0,self.bingopass_detail.endTime - ModelList.PlayerInfoModel.get_cur_server_time())
    end
    return 0
end

--是否在促销时间
function BasePassDataComponent:IsSaleTime()
    if self.bingopass_detail and self.bingopass_detail.seasonInfo then
       
        if self.bingopass_detail.seasonInfo.offTime == 0 then 
            return false
        else 
            return  (ModelList.PlayerInfoModel.get_cur_server_time() ) > self.bingopass_detail.endTime-(self.bingopass_detail.seasonInfo.offTime * 3600)
        end 
        return self.bingopass_detail.seasonInfo.offTime  - ModelList.PlayerInfoModel.get_cur_server_time() <0 
    end
    return false
end

function BasePassDataComponent:IsPayAccomplish()
    if self.bingopass_detail then
        local exp =  self:GetRewardDataById(self:GetLevel() + 1)  -- Csv.GetData(csv_data_name,self:GetLevel() + 1,"exp")
        for key, value in pairs(self.bingopass_detail.payInfo) do
            if (value.itemId == BingoPassPayType.Pay499 and 0 == exp) or (value.itemId == BingoPassPayType.Pay999 or 
            value.itemId == BingoPassPayType.Pay500) then
                if value.isPay == 1 then
                    return true
                end
            end
        end
    end
    return false
end

function BasePassDataComponent:IsCompletePay(payType)
    if self.bingopass_detail then
        for key, value in pairs(self.bingopass_detail.payInfo) do
            if value.itemId == payType then
                return value.isPay == 1
            end
        end
    end
    return false
end


function BasePassDataComponent:GetPayItemId()
    if self.bingopass_detail then
        for key, value in pairs(self.bingopass_detail.payInfo) do
            if value.isPay == 0 then
                return value.itemId
            end
        end
    end
    return nil
end


function BasePassDataComponent:IsAnyPayment()
    return self:IsActivateGoldenPass()
end

function BasePassDataComponent:GetSeasonId()
    if self.bingopass_detail then
        return self.bingopass_detail.seasonId
    end
end

function BasePassDataComponent:GetRewardList()
    if self.receiveRewardData then
        return self.receiveRewardData.reward
    end
end

function BasePassDataComponent:IsActivateGoldenPass()
    if self.bingopass_detail then
        return self.bingopass_detail.isPay == 1
    end
    return false
end

function BasePassDataComponent:GetLevel() 
    return self._level or 0
end

function BasePassDataComponent:SetLevel(level)
    self._level = level 
end


function BasePassDataComponent:GetPreviousLevel()
    if self.bingopass_info then
        return self.bingopass_info.lastLevel
    end
end

function BasePassDataComponent:GetExp()
    if self.bingopass_info then
        return self.bingopass_info.exp 
    end

    return self._exp or 0
end

function BasePassDataComponent:GetPreviousExp()
    if self.bingopass_info then
        return self.bingopass_info.lastExp
    end
end

function BasePassDataComponent:GetExpCount()
    if self.bingopass_info then
        return self.bingopass_info.expCount
    end
    return self._expCount or 0
end

function BasePassDataComponent:IsFreeNoClaim(id)
    if self:GetLevel() >= (id or 0) then
        return not self:IsFreeReceived(id)
    end
end

function BasePassDataComponent:IsFreeReceived(id)
    if self.freeReceivedCache then
        return self.freeReceivedCache[id or 0]
    end
end

--是否获得免费奖励
function BasePassDataComponent:IsGetAllFreeReceived(id)
    if self.freeReceivedCache and self.freeReceivedCache[id] ~= nil and  self.freeReceivedCache[id] == true then 
        return true
    end 

    return false 
end

--是否获得付费奖励
function BasePassDataComponent:IsGetAllPayReceived(id)
    if self.payReceivedCache and self.payReceivedCache[id] ~= nil and  self.payReceivedCache[id] == true then 
        return true
    end  
    return false 
end

function BasePassDataComponent:IsPayNoClaim(id)
    

    if self:GetLevel() >= (id or 0) and 
    self:IsActivateGoldenPass() then
        return not self:IsPayReceived(id)
    end
end

function BasePassDataComponent:IsPayReceived(id)
    if self.payReceivedCache then
        return self.payReceivedCache[id or 0]
    end
end

function BasePassDataComponent:SetPayInfo()
    --4.99档没有等级变化是没消息返回的，只能强制刷新
    if self.payId and self.bingopass_detail then
        self.bingopass_detail.isPay = 1
        if self.bingopass_detail.payInfo == nil then
            self.bingopass_detail.payInfo = {}
            table.insert(self.bingopass_detail.payInfo,{itemId = payId,isPay = 1})
        else
            for key, value in pairs(self.bingopass_detail.payInfo) do
                if value.itemId == payId then
                    value.isPay = 1
                end
            end    
        end
        self.payId = nil
    end
end

function BasePassDataComponent:GetEndTime()
    return self.bingopass_detail and self.bingopass_detail.endTime or 0
end


function BasePassDataComponent:IsExpired()
    if(self.bingopass_detail and self.bingopass_detail.endTime)  then 
        return self.bingopass_detail.endTime < os.time()
    end
    return true 
end

function BasePassDataComponent:HasReward()
 
    return self._hasReward
end

--此赛季是否还有效
function BasePassDataComponent:IsSeasonValid()
    --没有赛季的任何数据，认为是过期了
    if not self:IsBingoPassActivate() then
        return false
    end

    if not self:IsSeasonOpen() then
        return false
    end

    local level = self:GetLevel()
    local level_max =self:GetRewardDataById(level) -- Csv.GetData(csv_data_name, level, "level_max")

    --在有效间内，已经领取了所有的奖励
    if level_max == 1 and self:IsGetAllPayReceived(level) then
        return false
    end

    return true
end

function BasePassDataComponent:IsSeasonOpen()
    if not self.bingopass_detail then
        return false
    end

    return self.bingopass_detail.isSeasonOpen
end

function BasePassDataComponent:IsPlayerLevelEnough()
    local nowLevel = ModelList.PlayerInfoModel:GetLevel()
    local needLevel = Csv.GetLevelOpenByType(10, 0)
    return nowLevel >= needLevel
end

function BasePassDataComponent:GetPayGoldPassLevel()
    local level = self:GetLevel()
    local exp = self:GetExp()
    local seasonId = self:GetSeasonId()
    local rewardData = self:get_priceItem2()
    local rewardExp = tonumber(rewardData[2][2] or 0)
    while true do
        local needExp =self:GetRewardDataById(level + 1) -- Csv.GetData(csv_data_name, level + 1, "exp")
        if needExp then
            needExp = needExp - exp
            rewardExp = math.max(0,rewardExp - needExp)
            exp = 0
            level = level + 1
        else
            break
        end
        if rewardExp == 0 then
            break
        end
    end

    return level
end

function BasePassDataComponent:GetAllReward(productType)
    local levelNormal = self:GetLevel()
    local levelGolden = levelNormal
    local rewardNow = {}
    local rewardSoon = {}
    if productType == BingoPassPayType.Pay999 then
        levelGolden = self:GetPayGoldPassLevel()
    end

    local cout = self:GetShowRewardDataCout()
    for i = 1, cout do
        local cache_list = nil
        local passData = self:GetRewardDataById(i) --Csv.GetData(csv_data_name,i)
        if i <= levelNormal or i <= levelGolden then
            if not self:IsPayReceived(i) then
                cache_list = rewardNow
            end
        else
            if passData.exp == 0 and levelNormal == i - 1 then
                cache_list = rewardNow 
            else
                cache_list = rewardSoon
            end
        end
        if cache_list then
            for key2, value2 in pairs(passData.pay_reward) do
                local key = value2[1]
                local value = value2[2]
                if key and value then
                    cache_list[key] = (cache_list[key] or 0) + value
                end
            end
        else
            --break --这里不可以break
        end
    end

    return rewardNow, rewardSoon
end

function BasePassDataComponent:C2S_ReqquestBingopassInfo()
    this.SendMessage(MSG_ID.MSG_SHORT_SEASON_PASS_UP_LEVEL,{})
end

function BasePassDataComponent:S2C_OnUpdataBingopassInfo(code,data)
    if code == RET.RET_SUCCESS and data then
        self.bingopass_info = deep_copy(data)

        if(self.bingopass_info.hasReward)then 
            self:SetHasReward(self.bingopass_info.hasReward)
        end
        if(self.bingopass_info.curPassId)then 
            self:SetLevel(self.bingopass_info.curPassId)
        end
        if self.payId then
            self:C2S_RequestBingopassDetail()
        else
            Facade.SendNotification(NotifyName.GamePlayShortPassView.UpdataBingoPassInfo)
        end
        -- Event.Brocast(EventName.Event_BingoPass_UpdateLevel) --
        Facade.SendNotification(NotifyName.GamePlayShortPassView.UpdateExpInfo)
    end
end


function BasePassDataComponent:S2C_OnReceiveBingopassDetail(code,data)
    log.log("lxq BasePassDataComponent:S2C_OnReceiveBingopassDetail receive detail data is ", code, data)
    if code == RET.RET_SUCCESS and data then
        if data.isNTF then --单独处理推送过来的消息
            self:S2C_OnNtfBingopassDetail(data)
            return
        end

        self.bingopass_detail = deep_copy(data)
        self.freeReceivedCache = {}

        if(not self.bingopass_detail.freeReceived)then 
            log.e("lxq debug ")
            return 
        end
        self._exp = data.exp
        self._expCount = data.expCount
        for key, value in pairs(self.bingopass_detail.freeReceived) do
            self.freeReceivedCache[value] = true
        end
        self.payReceivedCache = {}
        for key, value in pairs(self.bingopass_detail.payReceived) do
            self.payReceivedCache[value] = true
        end
        self.bingopass_detail.free = nil
        self.bingopass_detail.freeReceived = nil
        self.bingopass_detail.pay = nil
        self.bingopass_detail.payReceived = nil 

        Facade.SendNotification(NotifyName.GamePlayShortPassView.UpdataBingoPassInfo)
 
    end
end

--单独处理推送过来的消息
function BasePassDataComponent:S2C_OnNtfBingopassDetail(data)
    log.log("dghdgh0007 ntf detail data is ", data)  
    --只处理之前没有开启，通知开启的情况
    if (not self.bingopass_detail or (self.bingopass_detail and not self.bingopass_detail.isSeasonOpen)) and data.isSeasonOpen then
        self.bingopass_detail = deep_copy(data)
        self.freeReceivedCache = {}
        for key, value in pairs(self.bingopass_detail.freeReceived) do
            self.freeReceivedCache[value] = true
        end
        self.payReceivedCache = {}
        for key, value in pairs(self.bingopass_detail.payReceived) do
            self.payReceivedCache[value] = true
        end
        self.bingopass_detail.free = nil
        self.bingopass_detail.freeReceived = nil
        self.bingopass_detail.pay = nil
        self.bingopass_detail.payReceived = nil
        
  
        local bundle = {}
        bundle.componentName = "FunctionIconBingopassView"
        Event.Brocast(EventName.Event_Add_Function_Icon, bundle)
    end
end

function BasePassDataComponent:C2S_RequestDiamondUplevel(level)
    this.SendMessage(MSG_ID.MSG_SHORT_SEASON_PASS_DIAMOND_UP,{playId = self.id})
end

function BasePassDataComponent:S2C_OnDiamondUplevel(code,data)
    if code == RET.RET_SUCCESS and data then
        if data.code ~= 0 then
            Facade.SendNotification(NotifyName.GamePlayShortPassView.Expired)
        end
    end
end


function BasePassDataComponent:S2C_OnRespondClaimReward(code,data)
    if code == RET.RET_SUCCESS and data then
        self.receiveRewardData = deep_copy(data)
 
        self.freeReceivedCache = {}
        local level = self:GetLevel()
        for i = 1, level do
            self.freeReceivedCache[i] = true
        end
        if self:IsActivateGoldenPass() then
            self.payReceivedCache = self.freeReceivedCache
        end
        self:SetHasReward(false)  --奖励领取是一次性，所以刷新红点标识
        Facade.SendNotification(NotifyName.GamePlayShortPassView.ReceiveReward)
        --因为领奖，是不发升级消息，所以前端维护此奖励
        if self.bingopass_info and self.bingopass_info.hasReward then 
            self.bingopass_info.hasReward = false 
        end  
    end
end

function BasePassDataComponent:RequestActivateGoldenPass() 
    self.payId = self.id
    ModelList.MainShopModel.C2S_RequestActivityPay(self.id,"taskPass")
end
 


function BasePassDataComponent:C2S_RequestClaimReward()
    this.SendMessage(MSG_ID.MSG_SHORT_SEASON_PASS_RECEIVE,{playId = self.id})
end

function BasePassDataComponent:C2S_RequestBingopassDetail(isforce)
    if not self.requestDetail then
        self.requestDetail = true
        this.SendMessage(MSG_ID.MSG_SHORT_SEASON_PASS_FETCH, {})
    elseif isforce then
        this.SendMessage(MSG_ID.MSG_SHORT_SEASON_PASS_FETCH, {},false,true)

    end
end





return BasePassDataComponent