local QuickTaskBaseState = require "State/QuickTaskView/QuickTaskBaseState"
local QuickTaskOriginalState = Clazz(QuickTaskBaseState,"QuickTaskOriginalState")

function QuickTaskOriginalState:OnEnter(fsm,previous,check)
    --log.r("enter  QuickTaskOriginalState")
    if check and check == 1 then
        self:CheckQuickTask(fsm)
    else
        --fun.set_active(fsm:GetOwner().content,false)
        if not ModelList.CompetitionModel:IsActivityAvailable() then
            fun.set_active(fsm:GetOwner().content,false)
        end
        fun.set_active(fsm:GetOwner().RankAnima,false)
    end
    --self:CheckQuickTask(fsm)
end

function QuickTaskOriginalState:OnLeave(fsm)
end

function QuickTaskOriginalState:CheckQuickTask(fsm)
    if fsm then
        fsm:GetOwner():OnCheckQuickTask()
    end
end

function QuickTaskOriginalState:QuickTaskAchieve(fsm)
    if fsm then
        self:ChangeState(fsm,"QuickTaskAchieveState")
    end
end

function QuickTaskOriginalState:QuickTaskNoAchieve(fsm)
    if fsm then
        self:ChangeState(fsm,"QuickTaskNoAchieveState")
    end
end

function QuickTaskOriginalState:TweenSliderFinish(fsm)
    if fsm then
        fsm:GetOwner():QuickTaskFinish()
    end
end

function QuickTaskOriginalState:CheckTimeOut(fsm)
    if fsm then
        fsm:GetOwner():TimeOutHide()
    end
end

function QuickTaskOriginalState:FlyCooky(fsm,params)
    if fsm then
        self:ChangeState(fsm,"QuickTaskFlyCookyState",3, params)
    end
end


function QuickTaskOriginalState:ShowDetail(fsm)
    if fsm then
        fsm:GetOwner():OnShowDetail()
    end
end

return  QuickTaskOriginalState