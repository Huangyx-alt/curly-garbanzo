require "Sequence/BaseSequenceStep"

EnterGamekJackpotStep = BaseSequenceStep:New("EnterGamekJackpotStep")

local complete = nil
local isShowJackpot = nil

function EnterGamekJackpotStep:OnSequenceStepFinish()
    complete = true
end

function EnterGamekJackpotStep:OnEnter()
    if ModelList.MiniGameModel:IsTopLayerOpen() 
        and not ModelList.MiniGameModel:IsClaimJackpoReward() then
            isShowJackpot = true
            MiniGame01View:EnterGameShowJackpot()
            Event.AddListener(NotifyName.MiniGame01.MiniGameSequenceStepFinish,self.OnSequenceStepFinish,self)
    else
        complete = true
    end
end

function EnterGamekJackpotStep:LeaveCondition()
    return complete
end

function EnterGamekJackpotStep:OnLeave()
    complete = nil
    isShowJackpot = nil
    Event.RemoveListener(NotifyName.MiniGame01.MiniGameSequenceStepFinish,self.OnSequenceStepFinish,self)
end

function EnterGamekJackpotStep:GetNextStep()
    return "EnterGameTopRewardStep"
end

function EnterGamekJackpotStep:IsSequeceFinish()
    return false
end

function EnterGamekJackpotStep:GetParams()
    return isShowJackpot
end