require "Sequence/BaseSequenceStep"

OpenBoxResetLayerStep = BaseSequenceStep:New("OpenBoxResetLayerStep")

local complete = nil

function OpenBoxResetLayerStep:OnSequenceStepFinish()
    complete = true
end

function OpenBoxResetLayerStep:OnEnter()
    MiniGame01View:ExitOrRestartMiniGame()
    Event.AddListener(NotifyName.MiniGame01.MiniGameSequenceStepFinish,self.OnSequenceStepFinish,self)
end

function OpenBoxResetLayerStep:LeaveCondition()
    return complete
end

function OpenBoxResetLayerStep:OnLeave()
    complete = nil
    Event.RemoveListener(NotifyName.MiniGame01.MiniGameSequenceStepFinish,self.OnSequenceStepFinish,self)
end

function OpenBoxResetLayerStep:GetNextStep()
    return ""
end

function OpenBoxResetLayerStep:IsSequeceFinish()
    return true
end