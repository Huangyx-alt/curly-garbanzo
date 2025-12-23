local BingoPassRewardsBaseState = require "View/Bingopass/states/BingoPassRewardsBaseState"
local BingoPassRewardsOriginalState = Clazz(BingoPassRewardsBaseState, "BingoPassRewardsOriginalState")

function BingoPassRewardsOriginalState:OnEnter(fsm)
end

function BingoPassRewardsOriginalState:OnLeave(fsm)
end

function BingoPassRewardsOriginalState:PlayEnter(fsm,callback)
    self:ChangeState(fsm, "BingoPassRewardsStiffState", 1)
    if callback then
        callback()
    end
end

function BingoPassRewardsOriginalState:CollectReward(fsm)
    self:ChangeState(fsm, "BingoPassRewardsStiffState")
end

function BingoPassRewardsOriginalState:ExtraSpin(fsm)
    self:ChangeState(fsm, "BingoPassRewardsExtraState")
end

return BingoPassRewardsOriginalState