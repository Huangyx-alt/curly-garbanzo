local PuzzleBaseState = require("State.PuzzleView.PuzzleBaseState")
local PuzzleFlyRewardState = Clazz(PuzzleBaseState,"PuzzleFlyRewardState")

function PuzzleFlyRewardState:OnEnter(fsm,previous,...)
    --这个状态得时候隐藏掉宝箱

    fsm:GetOwner():SetFlyReward(...)
    fsm:GetOwner():ShowOrHide(false)
    --log.r("==============================>>PuzzleFlyRewardState")
end

function PuzzleFlyRewardState:RepeatedEnter(fsm,...)
    self:OnEnter(fsm)
end

function PuzzleFlyRewardState:OnLeave(fsm)
    
end

function PuzzleFlyRewardState:ClaimRewardResult(fsm)
    if fsm then
        fsm:GetOwner():OnClaimRewardResult(false)
        --fsm:GetOwner():ShowOrHide(true)
    end
end
return PuzzleFlyRewardState