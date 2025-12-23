local BingoPassRewardsBaseState = require "View/Bingopass/states/BingoPassRewardsBaseState"
local BingoPassRewardsStiffState = Clazz(BingoPassRewardsBaseState, "BingoPassRewardsStiffState")

function BingoPassRewardsStiffState:OnEnter(fsm, previous, params)
    if 1 == params then
    else
        fsm:GetOwner():OnCollectReward()
    end
end

function BingoPassRewardsStiffState:OnLeave(fsm)
end

function BingoPassRewardsStiffState:Complete(fsm)
    if fsm then
        fsm:GetOwner():Finish()
    end
end

return BingoPassRewardsStiffState