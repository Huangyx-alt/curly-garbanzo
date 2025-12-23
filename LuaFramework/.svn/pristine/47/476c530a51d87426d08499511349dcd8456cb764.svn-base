require "Sequence/BaseSequenceStep"

EnterGameShowTipsStep = BaseSequenceStep:New("EnterGameShowTipsStep")

local complete = nil

function EnterGameShowTipsStep:OnSequenceStepFinish()
    complete = true
end

function EnterGameShowTipsStep:OnEnter()
    if MiniGame01View:EnterShowLayerTips() then
        Event.AddListener(NotifyName.MiniGame01.MiniGameSequenceStepFinish,self.OnSequenceStepFinish,self)
    else
        complete = true
    end
end

function EnterGameShowTipsStep:LeaveCondition()
    return complete
end

function EnterGameShowTipsStep:OnLeave()
    complete = nil
    Event.RemoveListener(NotifyName.MiniGame01.MiniGameSequenceStepFinish,self.OnSequenceStepFinish,self)
end

function EnterGameShowTipsStep:GetNextStep()
    return "EnterGameResetLayerStep"
end

function EnterGameShowTipsStep:IsSequeceFinish()
    return false
end