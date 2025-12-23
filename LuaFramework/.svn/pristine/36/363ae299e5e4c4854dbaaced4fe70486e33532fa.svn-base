local BaseGamePassBaseItemBaseState = require "GamePlayShortPass/Base/States/BaseGamePassBaseItemBaseState"
local BaseGamePassBaseItemAchieveState = Clazz(BaseGamePassBaseItemBaseState,"BaseGamePassBaseItemAchieveState")

function BaseGamePassBaseItemAchieveState:OnEnter(fsm,previous,...)
    local isFree,param = select(1,...)
    if 1 == isFree then
        fsm:GetOwner():PlayFreeAchieveAnima(param)
        fsm:GetOwner():PlayCircleAnima(true)
        fsm:GetOwner():PlayRestAnima(true)
    elseif 2 == isFree then
        -- body
        fsm:GetOwner():PlayFeeAchieveAnima(param)
        fsm:GetOwner():PlayCircleAnima(true)
        fsm:GetOwner():PlayRestAnima(true)
    else
        fsm:GetOwner():PlayBottomAchieveAnima(param)
    end    
end

function BaseGamePassBaseItemAchieveState:OnLeave(fsm)
end

function BaseGamePassBaseItemAchieveState:IsAchieve()
    return true
end

return BaseGamePassBaseItemAchieveState