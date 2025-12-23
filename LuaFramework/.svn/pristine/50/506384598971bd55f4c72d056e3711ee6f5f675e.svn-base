local BaseGamePassBaseItemBaseState = require "GamePlayShortPass/Base/States/BaseGamePassBaseItemBaseState"
local BaseGamePassBaseItemMatureState = Clazz(BaseGamePassBaseItemBaseState,"BaseGamePassBaseItemMatureState")

function BaseGamePassBaseItemMatureState:OnEnter(fsm,previous,...)
    local isFree,param = select(1,...)
    if 1 == isFree then
        fsm:GetOwner():PlayFreeMatureAnima(param)
        fsm:GetOwner():PlayCircleAnima(param)
        fsm:GetOwner():PlayRestAnima(param)
    elseif 2 == isFree then
        -- body
        fsm:GetOwner():PlayFeeMatureAnima(param)
        fsm:GetOwner():PlayCircleAnima(param)
        fsm:GetOwner():PlayRestAnima(param)
    else
        fsm:GetOwner():PlayBottomMatureAnima(param)
    end  
end

function BaseGamePassBaseItemMatureState:OnLeave(fsm)
end

function BaseGamePassBaseItemMatureState:Change2Achieve(fsm,...)
    if fsm then
        self:ChangeState(fsm,"BaseGamePassBaseItemAchieveState",...)
    end
end

function BaseGamePassBaseItemMatureState:ClickPassItem(fsm)
    if fsm then
        fsm:GetOwner():on_btn_collect_click()
    end
end

return BaseGamePassBaseItemMatureState