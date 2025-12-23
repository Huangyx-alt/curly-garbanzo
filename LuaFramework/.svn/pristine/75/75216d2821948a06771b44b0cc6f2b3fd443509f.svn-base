local BingoPassItemBaseState = require "View/Bingopass/states/BingoPassItemBaseState"
local BingoPassItemLockMarkState = Clazz(BingoPassItemBaseState,"BingoPassItemLockMarkState")

function BingoPassItemLockMarkState:OnEnter(fsm,previous,...)
    fsm:GetOwner():PlayFreeLockAnima(false)
    fsm:GetOwner():PlayRestAnima(false)
end

function BingoPassItemLockMarkState:OnLeave(fsm,previous,...)
end

function BingoPassItemLockMarkState:Change2Mature(fsm,...)
    if fsm then
        self:ChangeState(fsm,"BingoPassItemMatureState",...)
    end
end
return BingoPassItemLockMarkState