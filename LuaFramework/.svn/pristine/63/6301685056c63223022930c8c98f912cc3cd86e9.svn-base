require "Sequence/BaseSequenceStep"

EnterGameResetLayerStep = BaseSequenceStep:New("EnterGameResetLayerStep")

function EnterGameResetLayerStep:OnEnter()
    if EnterGameSequence:IsResetLayer() then
        MiniGame01View:ExitOrRestartMiniGame()
    end
end

function EnterGameResetLayerStep:LeaveCondition()
    return true
end

function EnterGameResetLayerStep:GetNextStep()
    return ""
end

function EnterGameResetLayerStep:IsSequeceFinish()
    return true
end