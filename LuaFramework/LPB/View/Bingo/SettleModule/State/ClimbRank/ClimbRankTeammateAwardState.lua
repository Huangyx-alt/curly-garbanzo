--结算队友带来的收益
local ClimbRankTeammateAwardState = Clazz(BaseFsmState, "ClimbRankTeammateAwardState")
local this = ClimbRankTeammateAwardState
local RewardType = {Jackpot = 1}

function ClimbRankTeammateAwardState:New()
    local o = {}
    setmetatable(o, {__index = ClimbRankTeammateAwardState})
    return o
end

function ClimbRankTeammateAwardState:InitState()
end

local baseSettleReward = nil
local addCound = 0
local cardCount = 0

function ClimbRankTeammateAwardState:OnEnter(fsm, previous)
    log.log("ClimbRankTeammateAwardState:OnEnter")
    local settleData = ModelList.BattleModel:GetCurrModel():GetSettleData().groupSettleReward
    baseSettleReward = settleData.jackpotSettleReward
    addCound = 0
    cardCount = #fsm:GetOwner():GetCards()
    this._fsm = fsm

    local matchReward = ModelList.SuperMatchModel:GetRewardInfo()
    --[[undo测试数据
    matchReward = {
        {bingoNum = 4, content = 4000000},
        {bingoNum = 3, content = 1000000},
        {bingoNum = 2, content = 200000},
        {bingoNum = 1, content = 50000},
    }
    --]]
    if matchReward then
        this:PlayTeammateAward(fsm, matchReward)
    else
        log.log("ClimbRankTeammateAwardState:OnEnter 不是super match")
        this:PalyEnd()
    end
end

local GetCoinItemCount = function(gift)
    local count = 0
    for i = 1, #gift do
        if gift[i] == 1005 or gift[1] == 1006 or gift[1] == 1007 then
            count = count +1
        end
    end
    return count
end

---@see 展示点击金币奖励
local GetRefundCoin = function(cardId)
    local data = ModelList.BattleModel:GetCurrModel():GetRoundData(cardId)
    local itemCount = 0
    if data.isJackpot then
        itemCount = 1
    end
    --itemCount = 1
    this._fsm:GetOwner():SetAddReward(cardId, 9,itemCount )
end

local GetRewardContent = function(cardId,rewardType)
    if rewardType == RewardType.Jackpot then
        GetRefundCoin(cardId)
    end
end

function ClimbRankTeammateAwardState:PlayTeammateAward(fsm, rewards)
    if fun.is_table_empty(rewards) then
        this:PalyEnd()
        return
    end

    local PlayNext = function()
        this:PalyEnd()
    end

    fsm:GetOwner():ShowSuperMatchRewards(rewards, PlayNext)
end

function ClimbRankTeammateAwardState:PalyEnd( )
    self:ChangeState(this._fsm, "ClimbRankEndState")
end

function ClimbRankTeammateAwardState:Finish()

end

function ClimbRankTeammateAwardState:OnLeave(fsm)
    log.log("ClimbRankTeammateAwardState:OnLeave")
    this._fsm = nil
    self._owner = nil
    self._posX = nil
end

function ClimbRankTeammateAwardState:Dispose()
    self:OnLeave(nil)
end

return this