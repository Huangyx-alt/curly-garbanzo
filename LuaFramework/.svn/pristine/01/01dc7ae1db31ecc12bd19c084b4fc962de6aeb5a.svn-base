require "Sequence/BaseSequenceStep"

OpenBoxCheckJackpotStep = BaseSequenceStep:New("OpenBoxCheckJackpotStep")

local complete = nil

function OpenBoxCheckJackpotStep:OnSequenceStepFinish()
    MiniGame01View:ResetGrandPrizeAnima()
    complete = true
end

function OpenBoxCheckJackpotStep:OnEnter()
    if ModelList.MiniGameModel:IsTopLayerOpen() and 
    not ModelList.MiniGameModel:IsClaimJackpoReward() then
        Event.AddListener(NotifyName.MiniGame01.MiniGameSequenceStepFinish,self.OnSequenceStepFinish,self)
        MiniGame01View:OpenBoxShowJackpot()
    else
        complete = true
    end
end

function OpenBoxCheckJackpotStep:LeaveCondition()
    return complete
end

function OpenBoxCheckJackpotStep:OnLeave()
    complete = nil
    Event.RemoveListener(NotifyName.MiniGame01.MiniGameSequenceStepFinish,self.OnSequenceStepFinish,self)
end

function OpenBoxCheckJackpotStep:GetNextStep()
    return "OpenBoxCheckTopRewardStep"
end

function OpenBoxCheckJackpotStep:IsSequeceFinish()
    return false
end