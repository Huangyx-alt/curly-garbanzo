require "Sequence/BaseSequenceStep"

OpenBoxFlyRewardStep = BaseSequenceStep:New("OpenBoxFlyRewardStep")

local complete = nil

function OpenBoxFlyRewardStep:OnSequenceStepFinish()
    complete = true
end

function OpenBoxFlyRewardStep:OnEnter()
    MiniGame01View:FlyLayerReward()
    Event.AddListener(NotifyName.MiniGame01.MiniGameSequenceStepFinish,self.OnSequenceStepFinish,self)
end

function OpenBoxFlyRewardStep:LeaveCondition()
    return complete
end

function OpenBoxFlyRewardStep:OnLeave()
    complete = nil
    Event.RemoveListener(NotifyName.MiniGame01.MiniGameSequenceStepFinish,self.OnSequenceStepFinish,self)
end

function OpenBoxFlyRewardStep:GetNextStep()
    return "OpenBoxCheckJackpotStep"
end

function OpenBoxFlyRewardStep:IsSequeceFinish()
    return false
end