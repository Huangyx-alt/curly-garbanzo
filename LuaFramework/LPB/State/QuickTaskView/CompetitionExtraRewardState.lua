local QuickTaskBaseState = require "State/QuickTaskView/QuickTaskBaseState"
local CompetitionExtraRewardState = Clazz(QuickTaskBaseState,"CompetitionExtraRewardState")
local previousName = nil
local checkType = nil
function CompetitionExtraRewardState:OnEnter(fsm,previous,check)
    --log.r("enter  CompetitionExtraRewardState")
    if fsm and self:CheckSkip() then
        return
    end
    checkType = check
    self.anima = fsm:GetOwner().anima
    self.fsm = fsm
    self.owner = fsm:GetOwner()
    previousName = previous
    if check and check == 1 then
        log.r("enter  CompetitionExtraRewardState")

        fsm:GetOwner():PlayRewardWithExtra2()
        self:start_x_update()
        --elseif check and check == 2 then

    else
        local reward_type,isExtraReward  =  fsm:GetOwner():CheckExtraReward2()
        if reward_type then
            if reward_type ~= isExtraReward then
                fsm:GetOwner().isExtraReward = reward_type
                if fsm:GetOwner().isExtraReward then
                    fsm:GetOwner():PlayRewardWithExtra2()
                else
                    fsm:GetOwner():PlayRewardWithExtra1()
                end
            end
        else
            fsm:GetOwner():PlayRewardNoExtra()
            self:start_x_update()
        end
    end
end

function CompetitionExtraRewardState:OnLeave(fsm)
    self:stop_x_update()
end

function CompetitionExtraRewardState:on_x_update()
    if not fun.is_null(self.anima)  then
        if  self.anima:GetCurrentAnimatorStateInfo(0) :IsName("idle1") then
            self:stop_x_update()
            self:PlayOver()
        end
    else
        self:stop_x_update()
        self:PlayOver()
    end
end

function CompetitionExtraRewardState:TweenSliderFinish(fsm)

end


function CompetitionExtraRewardState:PlayOver(fsm)
    if checkType == 2  then
        self.fsm:ChangeState(previousName)
    elseif  self.fsm:GetOwner():IsCompetitionNoChange() then
        self:ChangeState(self.fsm,"QuickTaskNoAchieveState",1)
    else
        --self.fsm:ChangeState("QuickTaskOriginalState",1)
        self.fsm:ChangeState("QuickTaskFlyCookyState")
    end
end


function CompetitionExtraRewardState:WaitOver()
    self:start_x_update()
end

return CompetitionExtraRewardState