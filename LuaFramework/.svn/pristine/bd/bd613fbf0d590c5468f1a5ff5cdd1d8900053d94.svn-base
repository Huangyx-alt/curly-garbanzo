require "Sequence/BaseSequenceStep"

EnterGameStolenStep = BaseSequenceStep:New("EnterGameStolenStep")

local isComplete = false
local finish = nil
local expel_Thief_State = nil

function EnterGameStolenStep:EnterCondition()
    return MiniGame01View:CheckEncounterThief()
end

function EnterGameStolenStep:OnEnter()
    EnterGameSequence:SetResetLayer(false)
    if ModelList.MiniGameModel:IsMeetThief() then
        Event.AddListener(NotifyName.MiniGame01.MiniGameSequenceStepFinish,self.OnMiniGameSequenceStepFinish,self)
        MiniGame01View:EnterGameShowStolenByThief()
        EnterGameSequence:SetResetLayer(true)
    else
        isComplete = true
    end
end

function EnterGameStolenStep:OnMiniGameSequenceStepFinish(expelThiefState)
    isComplete = true
    finish = true
    expel_Thief_State = expelThiefState
end

function EnterGameStolenStep:LeaveCondition()
    return isComplete
end

function EnterGameStolenStep:OnLeave()
    isComplete = nil
    finish = nil
    expel_Thief_State = nil
    Event.RemoveListener(NotifyName.MiniGame01.MiniGameSequenceStepFinish,self.OnMiniGameSequenceStepFinish,self)
end

function EnterGameStolenStep:GetNextStep()
    return "EnterGamekJackpotStep"
end

function EnterGameStolenStep:IsSequeceFinish()
    return finish
end

function EnterGameStolenStep:OnFinish()
    if 1 == expel_Thief_State then
        MiniGame01View:ExpelTheThief()
    elseif 2 == expel_Thief_State then
        MiniGame01View:ExitOrRestartMiniGame()
    end
end