local QuickTaskBaseState = require "State/QuickTaskView/QuickTaskBaseState"
local QuickTaskNoAchieveState = Clazz(QuickTaskBaseState,"QuickTaskNoAchieveState")

function QuickTaskNoAchieveState:OnEnter(fsm,previous,check)
    if fsm and self:CheckSkip() then
        return
    end
    log.r("enter  QuickTaskNoAchieveState")
    if check == 1 then
        fsm:GetOwner():QuickTaskFinish()
    else
        self:QuickTaskNoAchieve(fsm)
    end
end

function QuickTaskNoAchieveState:OnLeave(fsm)
    
end

--function QuickTaskOriginalState:CheckQuickTask(fsm)
--    if fsm then
--        log.r("QuickTaskNoAchieveState  but run QuickTaskOriginalState method CheckQuickTask")
--        fsm:GetOwner():OnCheckQuickTask()
--    end
--end
--
--function QuickTaskOriginalState:QuickTaskAchieve(fsm)
--    if fsm then
--        log.r("QuickTaskNoAchieveState  but run QuickTaskOriginalState method QuickTaskAchieve")
--        self:ChangeState(fsm,"QuickTaskAchieveState")
--    end
--end

function QuickTaskNoAchieveState:QuickTaskNoAchieve(fsm)
    if fsm then
        fsm:GetOwner():OnQuickTaskNoAchieve()
    end
end

---[[
function QuickTaskNoAchieveState:TweenSliderFinish(fsm)
    if fsm then
        fsm:GetOwner():QuickTaskFinish()
    end
end
--]]

function QuickTaskNoAchieveState:Finish(fsm)
    if fsm then
        fsm:GetOwner():TimeOutHide()
    end
end

function QuickTaskNoAchieveState:ShowDetail(fsm)
    if fsm then
        fsm:GetOwner():OnShowDetail()
    end
end

function QuickTaskNoAchieveState:ShowExtraRewardTip(fsm)
    if fsm then
        fsm:GetOwner():OnShowExtraRewardTip()
    end
end

function QuickTaskNoAchieveState:FlyCooky(fsm,params)
    if fsm then
        self:ChangeState(fsm,"QuickTaskFlyCookyState",1,params)
    end
end

function QuickTaskNoAchieveState:CheckTimeOut(fsm)
    if fsm then
        fsm:GetOwner():TimeOutHide()
    end
end

return  QuickTaskNoAchieveState