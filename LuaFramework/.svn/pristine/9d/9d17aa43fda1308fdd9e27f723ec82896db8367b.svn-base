local BingoPassItemBaseState = require "View/Bingopass/states/BingoPassItemBaseState"
local BingoPassItemLockNopayState = Clazz(BingoPassItemBaseState,"BingoPassItemLockNopayState")

function BingoPassItemLockNopayState:OnEnter(fsm,previous,...)
    local isFree,param = select(1,...)
    if 3 == isFree then
        fsm:GetOwner():PlayBottomLockNopayAnima(param)
    end
end

function BingoPassItemLockNopayState:OnLeave(fsm,previous,...)
end

function BingoPassItemLockNopayState:Change2Mature(fsm,...)
    if fsm then
        self:ChangeState(fsm,"BingoPassItemMatureState",...)
    end
end
return BingoPassItemLockNopayState