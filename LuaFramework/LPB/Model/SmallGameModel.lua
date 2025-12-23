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
    PassTaskView = "PassTaskView",
    PassIconView = "PassIconView",
    PassReceivedView = "PassReceivedView",
    PassRewardView = "PassRewardView",
    PassShowTipView = "PassShowTipView",
    PassPurchaseView = "PassPurchaseView",
}

local SmallGameModel = BaseModel:New("SmallGameModel")
local this = SmallGameModel
local refreshTime = -1
local _allPassData = {} -- 字典  key ：gameid   value :PB_ShortSeasonPassInfo
local forceRefreshCallBack = nil

--------------------------消息返回-----------------------------------

function SmallGameModel:SetLoginData(data)
    if data.smallGame then

    end
end

---playid改变的时候,刷新小游戏的默认数据
function SmallGameModel:UpdateCityPlayId(playId)
    if not playId then
        playId = ModelList.CityModel.GetPlayIdByCity()
    end
    if playId then
        if this:CanOpenGameForCurrPlay() then
            for k, v in pairs(Csv.minigame_bet) do
                if v.city_play_id == playId and v.minigame_id == this.MainMiniGameTime.miniGameId then
                    this.unlock_bet = v.unlock_bet
                end
            end
        end
    else
        this.unlock_bet = 1000
    end
end

function SmallGameModel.S2C_UpdateSmallGameData(code, data)
    if (code == RET.RET_SUCCESS) then
        if (data.pass) then
            for k, v in pairs(data.pass) do
                log.r("lxq MSG_SHORT_SEASON_PASS_FETCH", v.playId)
                this.UpdateDataById(v.playId, v)
            end
        end
        refreshTime = data.refreshTime
        if forceRefreshCallBack then
            forceRefreshCallBack()
            forceRefreshCallBack = nil
        end
    end
end

---------------------------对外接口------------------------------------


function SmallGameModel.GetLoadModule()
    return EnumClassName
end

---返回当前小游戏ID
function SmallGameModel.GetCurrentGameId()
    return this.MainMiniGameTime and this.MainMiniGameTime.miniGameId or 1
end

---返回当前小游戏预设信息
function SmallGameModel.GetCurrentGamePrefabName()
    if this:CanOpenGameForCurrPlay() then
        local data = Csv.GetData("minigame_time", this.MainMiniGameTime.miniGameId)
        return data.minigame_lock_name, data.minigame_unlock_name
    end
end

---返回当前小游戏的helper界面信息
function SmallGameModel.GetCurrentGameHelperInfo()
    if this.MainMiniGameTime and this.MainMiniGameTime.miniGameId then
        return Csv.GetData("minigame_time", this.MainMiniGameTime.miniGameId, "helper_name")
    end
    return "SuperMatchBangHelperView"
end

---返回当前小游戏的helper界面信息
function SmallGameModel.GetCurrentGameIconInfo()
    if this.MainMiniGameTime and this.MainMiniGameTime.miniGameId then
        return Csv.GetData("minigame_time", this.MainMiniGameTime.miniGameId, "icon_res_name")
    end
    return "SuperMatchPuIcon"
end

---返回当前小游戏的helper界面信息
function SmallGameModel.GetCurrentGameJackpotIconInfo()
    if this.MainMiniGameTime and this.MainMiniGameTime.miniGameId then
        return Csv.GetData("minigame_time", this.MainMiniGameTime.miniGameId, "jackpot_enable_res_name")
    end
    return "SuperMatchPPTitle"
end

---检查当前玩法是否可以进入小游戏
function SmallGameModel:CanOpenGameForCurrPlay()
    if not this.MainMiniGameTime then
        return false
    end
    local currTime = ModelList.PlayerInfoModel.get_cur_server_time()
    if this.MainMiniGameTime.openTime > currTime then
        return false
    end
    if this.MainMiniGameTime.closeTime < currTime then
        return false
    end
    if not self:IsLevelEnough() then return false end
    local playId = ModelList.CityModel.GetPlayIdByCity()
    if fun.is_include(playId, this.MainMiniGameTime.enPlayIds) then
        return true
    end
    return false
end

---检查当前玩法是否可以进入小游戏
function SmallGameModel:IsPlayIdInAllowList()
    if not this.MainMiniGameTime then
        log.log("SmallGameModel:IsPlayIdInAllowList 数据异常1")
        return false
    end

    if not this.MainMiniGameTime.enPlayIds then
        log.log("SmallGameModel:IsPlayIdInAllowList 数据异常2")
        return false
    end

    local playId = ModelList.CityModel.GetPlayIdByCity()
    if fun.is_include(playId, this.MainMiniGameTime.enPlayIds) then
        return true
    end

    return false
end

---是否在开放时间
function SmallGameModel:IsOpenTime()
    if not this.MainMiniGameTime then
        return false
    end
    local currTime = ModelList.PlayerInfoModel.get_cur_server_time()
    if this.MainMiniGameTime.openTime > currTime then
        return false
    end
    if this.MainMiniGameTime.closeTime < currTime then
        return false
    end
    return true
end

function SmallGameModel:GetLeftTime()
    if not this.MainMiniGameTime then
        return 0
    end
    local currTime = ModelList.PlayerInfoModel.get_cur_server_time()
    return this.MainMiniGameTime.closeTime - currTime
end

---检查当前bet是否可以开启小游戏
function SmallGameModel:CanOpenGameForBet()
    if this:CanOpenGameForCurrPlay() then
        local isUltraBetOpen = ModelList.UltraBetModel:IsActivityValidForCurPlay()
        if isUltraBetOpen then
            return true
        end

        if not this.unlock_bet then
            self:UpdateCityPlayId()
            if not this.unlock_bet then
                log.log("SmallGameModel:CanOpenGameForBet() error 配置问题")
                return false
            end
        end

        local currBet = ModelList.CityModel:GetBetRate()
        if currBet >= this.unlock_bet then
            return true
        end
    end
    return false
end

function SmallGameModel:IsLevelEnough()
    local selfLevel = ModelList.PlayerInfoModel:GetLv()
    local needLevel = 0 -- Csv.GetLevelOpenByType(19,0)
    local myLabel = ModelList.PlayerInfoModel:GetUserType()
    if myLabel and myLabel > 0 then
        needLevel = Csv.GetData("level_open", 34, "pay_openlevel")
    else
        needLevel = Csv.GetData("level_open", 34, "openlevel")
    end

    if not needLevel then
        log.log("SmallGameModel:IsLevelEnough() level_open配表有问题，无34")
        return false
    end

    return selfLevel >= needLevel
end

---在大厅是否能触发
function SmallGameModel:IsSmallGameTriggerInLobby()
    local currBet = ModelList.CityModel:GetBetRate()
    if currBet >= this.unlock_bet then
        return true
    end
    return false
end

---检查当前bet是否满足解锁bet
function SmallGameModel:IsBetEnough()
    local currBet = ModelList.CityModel:GetBetRate()
    if currBet >= this.unlock_bet then
        return true
    end
    return false
end

function SmallGameModel.GetActivityRemainTime()
    local currTime = ModelList.PlayerInfoModel.get_cur_server_time()
    if this.MainMiniGameTime then
        if this.MainMiniGameTime.openTime > currTime then
            return 0
        end
        if this.MainMiniGameTime.closeTime < currTime then
            return 0
        end
        return this.MainMiniGameTime.closeTime - currTime
    end
    return 0
end

---结算界面之后是否触发小游戏
function SmallGameModel:IsSettleSmallGame()
    local currGameId = ModelList.BattleModel:GetCurrModel():GetBattleExtraInfo("mainMiniGameId")
    if currGameId == 1 then
        local rewards = ModelList.BattleModel:GetCurrModel():GetSettleExtraInfo("SuperMatchSmash")
        if rewards and rewards.rewardList and rewards.hitLevel and rewards.hitLevel > 0 then
            return true
        end
        return false
    elseif ModelList.PiggySloltsGameModel.CheckPiggySlotsGameExist() then
        return true
    else
        local data = ModelList.BattleModel:GetCurrModel():GetSmallGameData2()
        return data ~= nil and true or false
    end
end

---返回当前小游戏的helper界面信息
function SmallGameModel.GetCurrentSGMainViewName()
    if this.MainMiniGameTime and this.MainMiniGameTime.miniGameId then
        return Csv.GetData("minigame_time", this.MainMiniGameTime.miniGameId, "minigame_mainview")
    end
    return nil
end

---------------------------数据处理------------------------------------

function SmallGameModel:InitData()

end

----------------------------region 协议-----------------------------------------------------
function SmallGameModel.S2C_MainMiniGameTime(code, data)
    if code == RET.RET_SUCCESS then
        this.MainMiniGameTime = data
    else

    end
end

function SmallGameModel.GmModifyMiniGameTime(miniId)
    if this.MainMiniGameTime then
        this.CheckGameChange(miniId)
        this.MainMiniGameTime.miniGameId = miniId
    end
end

function SmallGameModel.CheckGameChange(miniId)
    if this.MainMiniGameTime then
        if this.MainMiniGameTime.miniGameId ~= miniId then
            local curHallView = GetCurHallView()
            if curHallView and curHallView._hallFunction then
                curHallView._hallFunction:ChangeSmallGameType()
            end
        end
    end
end

function SmallGameModel.Login_C2S_Fetch(code, data)
    this.SendMessage(MSG_ID.MSG_MAIN_MINI_GAME_TIME, {})
end

----------------------------ednregion 协议-----------------------------------------------------




----------------------------重载接口-----------------------------------------------------

this.MsgIdList = {
    { msgid = MSG_ID.MSG_MAIN_MINI_GAME_TIME, func = this.S2C_MainMiniGameTime },

}

return this
