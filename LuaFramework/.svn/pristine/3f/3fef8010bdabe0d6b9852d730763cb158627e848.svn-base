local BingoPassItemBaseState = require "View/Bingopass/states/BingoPassItemBaseState"
local BingoPassItemOriginalState = Clazz(BingoPassItemBaseState,"BingoPassItemOriginalState")

function BingoPassItemOriginalState:OnEnter(fsm)
end

function BingoPassItemOriginalState:OnLeave(fsm)
end

function BingoPassItemOriginalState:ResetState(fsm)
    --do nothing
end

function BingoPassItemOriginalState:Change2Lock(fsm,...)
    if fsm then
        self:ChangeState(fsm,"BingoPassItemLockState",...)
    end
end

function BingoPassItemOriginalState:Change2Mature(fsm,...)
    if fsm then
        self:ChangeState(fsm,"BingoPassItemMatureState",...)
    end
end

function BingoPassItemOriginalState:Change2Achieve(fsm,...)
    if fsm then
        self:ChangeState(fsm,"BingoPassItemAchieveState",...)
    end
end

function BingoPassItemOriginalState:Change2LockNopay(fsm,...)
    if fsm then
        self:ChangeState(fsm,"BingoPassItemLockNopayState",...)
    end
end

return BingoPassItemOriginalState