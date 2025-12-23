local QuickTaskBaseState = require "State/QuickTaskView/QuickTaskBaseState"
local QuickTaskFlyCookyState = Clazz(QuickTaskBaseState,"QuickTaskFlyCookyState")

function QuickTaskFlyCookyState:OnEnter(fsm,previous,...)
    if fsm and self:CheckSkip() then
        return
    end
    --log.r("enter  QuickTaskFlyCookyState")
    self.changeTarget = ({ ... })[1]
    local cookeyRoot = ({ ... })[2]
    self.anima = fsm:GetOwner().anima
    self.fsm = fsm
    self.owner = fsm:GetOwner()
    self.owner:RefreshRemainTime()

    if ModelList.CompetitionModel:HasCookie() then
        fsm:GetOwner():OnFlyCooky(cookeyRoot)
        fsm:GetOwner():SaveQuickTaskId()
        UISound.play("kick_reward")
    else
        self:TweenSliderFinish(fsm)
    end
    --self:start_x_update()
end

function QuickTaskFlyCookyState:OnLeave(fsm)
    UISound.stop_loop("task_item_out")
end

function QuickTaskFlyCookyState:TweenSliderFinish(fsm)
    --if fsm then
    --    if self.changeTarget == 1 then
    --        self:ChangeState(fsm,"QuickTaskNoAchieveState",self.changeTarget)
    --    elseif self.changeTarget == 2 then
    --        self:ChangeState(fsm,"QuickTaskAchieveState",self.changeTarget)
    --    end
    --end
    self:ChangeState(fsm,"QuickTaskOriginalState",1)
    --fsm:GetOwner():OnCheckQuickTask2()
    --if fsm then
    --    if fsm:GetOwner():IsCompetitionGetReward() then
    --        self:ChangeState(fsm,"QuickTaskAchieveState",2)
    --    else
    --        self:ChangeState(fsm,"QuickTaskNoAchieveState",1)
    --    end
    --    fsm:GetOwner():SetNextLoop(true)
    --end

    --if fsm then
    --    if fsm:GetOwner():IsCompetitionGetReward() then
    --        self:ChangeState(fsm,"QuickTaskAchieveState",2)
    --    else
    --        self:ChangeState(fsm,"QuickTaskNoAchieveState",1)
    --    end
    --    fsm:GetOwner():SetNextLoop(true)
    --end
end

--
--
--function QuickTaskFlyCookyState:on_x_update()
--    if self.anima then
--        if  self.anima:GetCurrentAnimatorStateInfo(0) :IsName("idle1") then
--            self:stop_x_update()
--            self:PlayOver()
--        end
--    end
--end

return  QuickTaskFlyCookyState