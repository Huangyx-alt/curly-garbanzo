local SuperMatchModel = BaseModel:New("SuperMatchModel")
local this = SuperMatchModel

function SuperMatchModel:IsLevelEnough()
    local selfLevel = ModelList.PlayerInfoModel:GetLv()
    local needLevel = 0 -- Csv.GetLevelOpenByType(19,0)
    local myLabel = ModelList.PlayerInfoModel:GetUserType()
    if myLabel and myLabel > 0 then
        needLevel = Csv.GetData("level_open", 34, "pay_openlevel")
    else
        needLevel = Csv.GetData("level_open", 34, "openlevel")
    end

    if not needLevel then
        log.log("SuperMatchModel:IsLevelEnough() level_open配表有问题，无34")
        return false
    end

    return selfLevel >= needLevel
end

function SuperMatchModel:SetSuperMatchData(data)
    self.superMatchData = data
end

function SuperMatchModel:GetSuperMatchGuideData()
    return self.superMatchData.guideReward
end

--活动是否有效
function SuperMatchModel:IsActivityAvailable()
    if not self:IsLevelEnough() then
        log.log("SuperMatchModel:IsActivityAvailable F 等级不够")
        return false
    end
    local remainTime = self:GetActivityRemainTime()
    return remainTime > 0
end

--自己是否能进supermatch
function SuperMatchModel:CanEnterSuperMatch()
    if not self:IsActivityAvailable() then
        return false
    end

    if self:GetTicketNum() == 0 then
        return false
    end

    local playid = ModelList.CityModel.GetPlayIdByCity()
    local minBet = Csv.GetData("city_play", playid, "supermatch_bet")
    if minBet == 0 then return false end
    local curRate = ModelList.CityModel:GetBetRate()
    if not minBet or not curRate then
        log.log("SuperMatchModel:CanEnterSuperMatch 判断条件未达成", maxRate, curRate)
        return false
    end

    if not ModelList.UltraBetModel:IsActivityValid() then
        if curRate < minBet then
            return false
        end
    end

    if ModelList.CityModel:GetEnterGameMode() ~= 1 then
        return false
    end

    -- if not CityHomeScene or not CityHomeScene:IsNormalLobby() then
    --     return false
    -- end

    return true
end

--不看下注档位自己是否能进supermatch
function SuperMatchModel:CanEnterSuperMatchIgnoreBet()
    if not self:IsActivityAvailable() then
        return false
    end

    if self:GetTicketNum() == 0 then
        return false
    end

    if ModelList.CityModel:GetEnterGameMode() ~= 1 then
        return false
    end

    -- if not CityHomeScene or not CityHomeScene:IsNormalLobby() then
    --     return false
    -- end

    return true
end

function SuperMatchModel:GetActivityRemainTime()
    if self.superMatchData then
        return self.superMatchData.expireTime - os.time()
    end
    return 0
end

function SuperMatchModel:GetTicketNum()
    --[[
    local num = self.superMatchData and self.superMatchData.matchTimes
    --]]
    local num = ModelList.ItemModel.getResourceNumByType(Resource.supermatch_ticket)
    return num or 0
end

--undo
function SuperMatchModel:HasPopPosterRecord()
    return false
end

--undo
function SuperMatchModel:RecordPosterPop()

end

--undo
function SuperMatchModel:ClearPosterPopRecord()

end

--undo
function SuperMatchModel:GetRewardInfo()
    local rewards = ModelList.BattleModel:GetCurrModel():GetSettleExtraInfo("superMatchReward")
    if not rewards then
        return
    end

    local accReward = ModelList.BattleModel:GetCurrModel():GetSettleExtraInfo("AccReward") or 0
    table.insert(rewards, { accReward = 1, content = accReward })
    --[[
    if fun.is_table_empty(rewards) then
        return
    end
    --]]

    return rewards
end

function SuperMatchModel:GetMateIdForSettle()
    local mateId = ModelList.BattleModel:GetCurrModel():GetSettleExtraInfo("matchId")
    if not mateId then
        log.log("SuperMatchModel:GetMateIdForSettle() 未找到队友ID")
        return
    end


    return mateId
end

---------------------------region 锤力器------------------------

---结算是否触发锤力器
function SuperMatchModel:IsSettleTriggerSmash()
    local rewards = ModelList.BattleModel:GetCurrModel():GetSettleExtraInfo("SuperMatchSmash")
    if rewards and rewards.rewardList and rewards.hitLevel and rewards.hitLevel > 0 then
        return true
    end
    return false
end

---锤力器在大厅是否能触发
function SuperMatchModel:IsSmashTriggerInLobby()
    local curRate = ModelList.CityModel:GetBetRate()
    local playid = ModelList.CityModel.GetPlayIdByCity()
    local minBet = Csv.GetData("city_play", playid, "supermatch_bet")
    if minBet == 0 then return false end
    return curRate >= minBet and true or false
end

--- 检查结算奖励道具中是否有锤力器道具
function SuperMatchModel:IsSmashRewardInSettleReward()
    local settleData = ModelList.BattleModel:GetCurrModel():GetSettleData()
    if settleData then
        this.smashId = nil
        for j = 1, #settleData.reward do
            if settleData.reward[j].id == 37032 or settleData.reward[j].id == 37033 or settleData.reward[j].id == 37034 then
                this.smashId = settleData.reward[j].id
                break
            end
        end
        if this.smashId then
            local index = tostring(this.smashId):sub(-1)
            return tonumber(index)
            --this.smashIcon.sprite = AtlasManager:GetSpriteByName("GameItemAtlas", "ClqJs0" .. index)
            --fun.set_active(this.superMatchSmash, true)
        end
    end
    return 0
end

---------------------------endregion---------------------------




-----------------------------------------------------C2S-----------------------------------------------------begin
function SuperMatchModel.Login_C2S_XXX()
    this.SendMessage(MSG_ID.MSG_COMPETITION_RACING_FETCH, {})
end

---锤力器奖励领取
function SuperMatchModel.ReqSmashReward()
    local gameId = ModelList.BattleModel:GetCurrModel():LoadGameData().gameId
    if gameId then
        this.SendMessage(MSG_ID.MSG_SUPER_MATCH_SMASH_REWARD, {gameId = gameId },false,true)
    else
        if ViewList.SGSuperMatchMainView then
            Facade.SendNotification(NotifyName.CloseUI, ViewList.SGSuperMatchMainView)
            ViewList.SGSuperMatchMainView = nil
        end
    end
end

-----------------------------------------------------C2S-----------------------------------------------------end

-----------------------------------------------------S2C-----------------------------------------------------begin
---活动数据
function SuperMatchModel.ResXXXX(code, data)
    if code == RET.RET_SUCCESS then

    else

    end
end

function SuperMatchModel.ResSmashReward(code, data)
    if code == RET.RET_SUCCESS then
        if ViewList.SGSuperMatchMainView then
            ViewList.SGSuperMatchMainView:PlayBangStart()
        end
    else
        if ViewList.SGSuperMatchMainView then
            ViewList.SGSuperMatchMainView:ForceExit()
        end
    end
end

-----------------------------------------------------S2C-----------------------------------------------------end

this.MsgIdList = {
    --{msgid = MSG_ID.MSG_COMPETITION_RACING_FETCH, func = this.ResXXXX},
    {msgid = MSG_ID.MSG_SUPER_MATCH_SMASH_REWARD, func = this.ResSmashReward},
}

return this
