require "Sequence/BaseSequenceStep"

OpenBoxShowTipsStep = BaseSequenceStep:New("OpenBoxShowTipsStep")

local complete = nil

function OpenBoxShowTipsStep:OnSequenceStepFinish()
    complete = true
end

function OpenBoxShowTipsStep:OnEnter()
    if MiniGame01View:ShowLayerTips() then
        Event.AddListener(NotifyName.MiniGame01.MiniGameSequenceStepFinish,self.OnSequenceStepFinish,self)
    else
        complete = true
    end
end

function OpenBoxShowTipsStep:LeaveCondition()
    return complete
end

function OpenBoxShowTipsStep:OnLeave()
    complete = nil
    Event.RemoveListener(NotifyName.MiniGame01.MiniGameSequenceStepFinish,self.OnSequenceStepFinish,self)
end

function OpenBoxShowTipsStep:GetNextStep()
    return "OpenBoxResetLayerStep"
end

function OpenBoxShowTipsStep:IsSequeceFinish()
    return false
end