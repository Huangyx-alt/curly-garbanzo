require "Sequence/BaseSequenceStep"

OpenBoxCheckTopRewardStep = BaseSequenceStep:New("OpenBoxCheckTopRewardStep")

local complete = nil
local isFinish = nil

function OpenBoxCheckTopRewardStep:OnSequenceStepFinish()
    complete = true
end

function OpenBoxCheckTopRewardStep:OnEnter()
    if ModelList.MiniGameModel:IsTopLayerOpen() 
    and ModelList.MiniGameModel:IsClaimJackpoReward() then
        isFinish = true
        Event.AddListener(NotifyName.MiniGame01.MiniGameSequenceStepFinish,self.OnSequenceStepFinish,self)
        MiniGame01View:OpenBoxShowClaimTopReward()
    else
        complete = true
    end
end

function OpenBoxCheckTopRewardStep:LeaveCondition()
    return complete
end

function OpenBoxCheckTopRewardStep:OnLeave()
    complete = nil
    isFinish = nil
    Event.RemoveListener(NotifyName.MiniGame01.MiniGameSequenceStepFinish,self.OnSequenceStepFinish,self)
end

function OpenBoxCheckTopRewardStep:GetNextStep()
    return "OpenBoxNextLayerStep"
end

function OpenBoxCheckTopRewardStep:IsSequeceFinish()
    return isFinish
end

function OpenBoxCheckTopRewardStep:OnFinish()
    MiniGame01View:ExitOrRestartMiniGame()
end