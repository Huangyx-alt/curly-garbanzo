local BingoPassItemBaseState = require "View/Bingopass/states/BingoPassItemBaseState"
local BingoPassItemAchieveState = Clazz(BingoPassItemBaseState,"BingoPassItemAchieveState")

function BingoPassItemAchieveState:OnEnter(fsm,previous,...)
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

function BingoPassItemAchieveState:OnLeave(fsm)
end

function BingoPassItemAchieveState:IsAchieve()
    return true
end

return BingoPassItemAchieveState