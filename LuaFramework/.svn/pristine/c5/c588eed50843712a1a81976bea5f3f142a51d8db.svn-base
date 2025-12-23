local BingoPassItemBaseState = require "View/Bingopass/states/BingoPassItemBaseState"
local BingoPassItemLockState = Clazz(BingoPassItemBaseState,"BingoPassItemLockState")

function BingoPassItemLockState:OnEnter(fsm,previous,...)
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

function BingoPassItemLockState:OnLeave(fsm)
    
end

function BingoPassItemLockState:Change2Lock(fsm,...)
    local isFree,param = select(1,...)
    if fsm and 1 == isFree and fsm:GetOwner():IsShowGemBtn() then
        self:ChangeState(fsm,"BingoPassItemLockMarkState",...)
    elseif fsm and 2 == isFree then
        fsm:GetOwner():PlayFeeLockAnima()
    end
end

function BingoPassItemLockState:Change2Mature(fsm,...)
    if fsm then
        self:ChangeState(fsm,"BingoPassItemMatureState",...)
    end
end

function BingoPassItemLockState:Change2LockNopay(fsm,...)
    if fsm then
        self:ChangeState(fsm,"BingoPassItemLockNopayState",...)
    end
end

function BingoPassItemLockState:ClickPassItem(fsm)
    if fsm then
        fsm:GetOwner():ShowBingoPassTips()
    end
end

return BingoPassItemLockState