local PuzzleBaseState = require("State.PuzzleView.PuzzleBaseState")
local PuzzleFlyBigRewardState = Clazz(PuzzleBaseState,"PuzzleFlyBigRewardState")

function PuzzleFlyBigRewardState:OnEnter(fsm,previous,...)
    fsm:GetOwner():SetFlyStageReward(...)
end

function PuzzleFlyBigRewardState:RepeatedEnter(fsm,...)
    self:OnEnter(fsm)
end

function PuzzleFlyBigRewardState:OnLeave(fsm)

end

function PuzzleFlyBigRewardState:ClaimRewardResult(fsm)
    if fsm then
        fsm:GetOwner():OnClaimRewardResult(true)
    end
end

return PuzzleFlyBigRewardState