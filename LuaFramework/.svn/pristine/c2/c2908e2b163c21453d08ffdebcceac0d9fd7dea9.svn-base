require "Sequence/BaseSequenceStep"

OpenBoxNextLayerStep = BaseSequenceStep:New("OpenBoxNextLayerStep")

local complete = nil

function OpenBoxNextLayerStep:OnSequenceStepFinish()
    complete = true
end

function OpenBoxNextLayerStep:OnEnter()
    MiniGame01View:CheckNextLayer()
    Event.AddListener(NotifyName.MiniGame01.MiniGameSequenceStepFinish,self.OnSequenceStepFinish,self)
end

function OpenBoxNextLayerStep:LeaveCondition()
    return complete
end

function OpenBoxNextLayerStep:OnLeave()
    complete = nil
    Event.RemoveListener(NotifyName.MiniGame01.MiniGameSequenceStepFinish,self.OnSequenceStepFinish,self)
end

function OpenBoxNextLayerStep:GetNextStep()
    return "OpenBoxShowTipsStep"
end

function OpenBoxNextLayerStep:IsSequeceFinish()
    return false
end