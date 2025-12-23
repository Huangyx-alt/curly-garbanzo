require "Sequence/BaseSequenceStep"

OpenBoxStolenStep = BaseSequenceStep:New("OpenBoxStolenStep")

local complete = nil
local finish = nil
local expel_Thief_State = nil

function OpenBoxStolenStep:OnEnter()
    log.r("===============>>3410OpenBoxStolenStep  " .. tostring(ModelList.MiniGameModel:IsMeetThief()))
    if ModelList.MiniGameModel:IsMeetThief() then
        Event.AddListener(NotifyName.MiniGame01.MiniGameSequenceStepFinish,self.OnMiniGameSequenceStepFinish,self)
        MiniGame01View:OpenBoxShowStolenByThief()
        log.r("===============>>3410OpenBoxStolenStep222222")
    else
        complete = true
    end
end

function OpenBoxStolenStep:OnMiniGameSequenceStepFinish(expelThiefState)
    finish = true
    complete = true
    expel_Thief_State = expelThiefState
end

function OpenBoxStolenStep:LeaveCondition()
    return complete
end

function OpenBoxStolenStep:OnLeave()
    complete = nil
    finish = nil
    Event.RemoveListener(NotifyName.MiniGame01.MiniGameSequenceStepFinish,self.OnMiniGameSequenceStepFinish,self)
end

function OpenBoxStolenStep:GetNextStep()
    return "OpenBoxFlyRewardStep"
end

function OpenBoxStolenStep:IsSequeceFinish()
    return finish
end

function OpenBoxStolenStep:OnFinish()
    if 1 == expel_Thief_State then
        MiniGame01View:ExpelTheThief()
    elseif 2 == expel_Thief_State then
        MiniGame01View:ExitOrRestartMiniGame()
    end
end