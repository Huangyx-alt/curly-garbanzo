local BaseGamePassBaseItemBaseState = require "GamePlayShortPass/Base/States/BaseGamePassBaseItemBaseState"
local BaseGamePassBaseItemLockState = Clazz(BaseGamePassBaseItemBaseState,"BaseGamePassBaseItemLockState")

function BaseGamePassBaseItemLockState:OnEnter(fsm,previous,...)
    local isFree,param = select(1,...)
    if 1 == isFree then
        fsm:GetOwner():PlayFreeLockAnima(param)
        fsm:GetOwner():PlayCircleAnima(param)
        fsm:GetOwner():PlayRestAnima(param)
    elseif 2 == isFree then
        -- body
        fsm:GetOwner():PlayFeeLockAnima(param)
        fsm:GetOwner():PlayCircleAnima(param)
        fsm:GetOwner():PlayRestAnima(param)
    end
end

function BaseGamePassBaseItemLockState:OnLeave(fsm)
    
end

function BaseGamePassBaseItemLockState:Change2Lock(fsm,...)
    local isFree,param = select(1,...)
    if fsm and 1 == isFree and fsm:GetOwner():IsShowGemBtn() then
        self:ChangeState(fsm,"BaseGamePassBaseItemLockMarkState",...)
    elseif fsm and 2 == isFree then
        fsm:GetOwner():PlayFeeLockAnima()
    end
end

function BaseGamePassBaseItemLockState:Change2Mature(fsm,...)
    if fsm then
        self:ChangeState(fsm,"BaseGamePassBaseItemMatureState",...)
    end
end

function BaseGamePassBaseItemLockState:Change2LockNopay(fsm,...)
    if fsm then
        self:ChangeState(fsm,"BaseGamePassBaseItemLockNopayState",...)
    end
end

function BaseGamePassBaseItemLockState:ClickPassItem(fsm)
    if fsm then
        fsm:GetOwner():ShowBingoPassTips()
    end
end

return BaseGamePassBaseItemLockState