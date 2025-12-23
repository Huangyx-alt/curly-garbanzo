
local PuzzleBaseState = Clazz(BaseFsmState,"PuzzleBaseState")

function PuzzleBaseState:Change2Enter(fsm)
    if fsm then
        self:ChangeState(fsm,"PuzzleEnterState")
    end
end

function PuzzleBaseState:Change2Exit(fsm)
    if fsm then
        self:ChangeState(fsm,"PuzzleExitState")
    end
end

function PuzzleBaseState:Change2Available(fsm,isEnter)
    if fsm then
        self:ChangeState(fsm,"PuzzleAvailableState",isEnter)
    end
end

function PuzzleBaseState:Change2Disable(fsm,isEnter)
    if fsm then
        self:ChangeState(fsm,"PuzzleDisabledState",isEnter)
    end
end

function PuzzleBaseState:Change2FlyReward(fsm,isEnter)
    if fsm then
        self:ChangeState(fsm,"PuzzleFlyRewardState",isEnter)
    end
end

function PuzzleBaseState:Change2FlyBigReward(fsm,isEnter)
    if fsm then
        self:ChangeState(fsm,"PuzzleFlyBigRewardState",isEnter)
    end
end

function PuzzleBaseState:Change2AddPieces(fsm)
    if fsm then
        self:ChangeState(fsm,"PuzzleAddPiecesState")
    end
end

function PuzzleBaseState:EnterFinish(fsm)
end

function PuzzleBaseState:AddPieces(fsm)
end

function PuzzleBaseState:AddPiecesResult(fsm)
    if fsm then
        fsm:GetOwner():CheckState()
    end
end

function PuzzleBaseState:ServerRespone()
end

function PuzzleBaseState:ClaimRewardResult(fsm)
end

function PuzzleBaseState:Goback()
end

function PuzzleBaseState:OpenShopView(fsm)
end
return PuzzleBaseState