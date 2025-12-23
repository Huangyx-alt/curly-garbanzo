local QuickTaskBaseState = require "State/QuickTaskView/QuickTaskBaseState"
local QuickTaskAchieveState = Clazz(QuickTaskBaseState,"QuickTaskAchieveState")

function QuickTaskAchieveState:OnEnter(fsm,previous,check)
    if fsm and self:CheckSkip() then
        return
    end
    --log.r("enter  QuickTaskAchieveState "..check)
    if check == 1 then
        fsm:GetOwner():FlyRewardItem2Head()
    elseif check == 2 then
        fsm:GetOwner():QuickTaskGetReward()    
    else
        fsm:GetOwner():OnQuickTaskAchieve()
    end
    self.fsm = fsm
    self.owner = fsm:GetOwner()
end

function QuickTaskAchieveState:OnLeave(fsm)
end

function QuickTaskAchieveState:CheckQuickTask(fsm)
    if fsm then
        fsm:GetOwner():OnCheckQuickTask()
    end
end

function QuickTaskAchieveState:QuickTaskAchieve(fsm)
    if fsm then
        self:start_x_update()
    end
end


function QuickTaskAchieveState:on_x_update()
    if self.owner.anima then
        if  self.owner.anima:GetCurrentAnimatorStateInfo(0) :IsName("idle1") or
                self.owner.anima:GetCurrentAnimatorStateInfo(0) :IsName("2end") then
            self:stop_x_update()
            self.fsm:GetOwner():TweenSlider()
        end
    end
end

function QuickTaskAchieveState:TweenSliderFinish(fsm)
    if fsm then
        fsm:GetOwner():OnQuickTaskAchieve2()
    end
end

function QuickTaskAchieveState:QuickTaskNoAchieve(fsm)
    if fsm then
        self:ChangeState(fsm,"QuickTaskNoAchieveState")
    end
end

function QuickTaskAchieveState:ClaimAwards(fsm)
    if fsm then
        self:ChangeState(fsm,"QuickTaskClaimAwardsState")
    end
end

function QuickTaskAchieveState:FlyCooky(fsm,params)
    if fsm then
        self:ChangeState(fsm,"QuickTaskFlyCookyState",2, params)
    end
end

return  QuickTaskAchieveState