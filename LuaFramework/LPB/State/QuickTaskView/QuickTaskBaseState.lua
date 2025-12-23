
require "Logic/Fsm/BaseFsmState"

local QuickTaskBaseState = Clazz(BaseFsmState,"QuickTaskBaseState")

function QuickTaskBaseState:CheckQuickTask(fsm)
end

function QuickTaskBaseState:QuickTaskAchieve(fsm)
end

function QuickTaskBaseState:QuickTaskNoAchieve(fsm)
end

function QuickTaskBaseState:TweenSliderFinish(fsm)
end

function QuickTaskBaseState:ClaimAwards(fsm)
end

function QuickTaskBaseState:ClaimRewardResult(fsm)
end

function QuickTaskBaseState:CheckTimeOut(fsm)
    if fsm then
        fsm:GetOwner():TimeOutHide()
    end
end

function QuickTaskBaseState:Finish(fsm)
end

function QuickTaskBaseState:ShowDetail(fsm)
end

function QuickTaskBaseState:ShowExtraRewardTip(fsm)
end

function QuickTaskBaseState:FlyCooky(fsm,params)
end

function QuickTaskBaseState:WaitOver()
end

function QuickTaskBaseState:CheckSkip(fsm)
    if fsm and fsm:GetOwner() and fsm:GetOwner():IsSkip() then
        fsm:GetOwner():SetSkip()
        return true
    end
    return false
end

return  QuickTaskBaseState