local BingoPassRewardsBaseState = require "View/Bingopass/states/BingoPassRewardsBaseState"
local BingoPassRewardsExtraState = Clazz(BingoPassRewardsBaseState, "BingoPassRewardsExtraState")

function BingoPassRewardsExtraState:OnEnter(fsm)
    fsm:GetOwner():OnExtraSpin()
end

function BingoPassRewardsExtraState:OnLeave(fsm)
end

function BingoPassRewardsExtraState:Complete(fsm)
    if fsm then
        fsm:GetOwner():FinishNeedExtraSpin()
    end
end

return BingoPassRewardsExtraState