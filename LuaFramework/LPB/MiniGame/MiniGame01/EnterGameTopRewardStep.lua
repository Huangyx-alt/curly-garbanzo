
require "Sequence/BaseSequenceStep"

EnterGameTopRewardStep = BaseSequenceStep:New("EnterGameTopRewardStep")

local complete = nil

function EnterGameTopRewardStep:OnSequenceStepFinish()
    complete = true
end

function EnterGameTopRewardStep:OnEnter(params)
    if ModelList.MiniGameModel:IsTopLayerOpen() 
        and ModelList.MiniGameModel:IsClaimJackpoReward() then
            EnterGameSequence:SetResetLayer(true)
            MiniGame01View:EnterGameShowClaimTopReward(params)
            Event.AddListener(NotifyName.MiniGame01.MiniGameSequenceStepFinish,self.OnSequenceStepFinish,self)
    else
        complete = true
    end
end

function EnterGameTopRewardStep:LeaveCondition()
    return complete
end

function EnterGameTopRewardStep:OnLeave()
    complete = nil
    Event.RemoveListener(NotifyName.MiniGame01.MiniGameSequenceStepFinish,self.OnSequenceStepFinish,self)
end

function EnterGameTopRewardStep:ClaimBigRewardFinish()
    complete = true
end

function EnterGameTopRewardStep:ConditionExecute()
    
end

function EnterGameTopRewardStep:IsCompleted()
    return complete
end

function EnterGameTopRewardStep:GetNextStep()
    return "EnterGameShowTipsStep"
end

function EnterGameTopRewardStep:IsSequeceFinish()
    return false
end