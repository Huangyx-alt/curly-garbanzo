
local BingoPassItemBaseState = Clazz(BaseFsmState,"BingoPassItemBaseState")

function BingoPassItemBaseState:ResetState(fsm)
    if fsm then
        self:ChangeState(fsm,"BingoPassItemOriginalState")
    end
end

function BingoPassItemBaseState:Change2Lock(fsm,...)
end

function BingoPassItemBaseState:Change2Mature(fsm,...)
end

function BingoPassItemBaseState:Change2Achieve(fsm,...)
end

function BingoPassItemBaseState:ClickPassItem(fsm)
end

function BingoPassItemBaseState:Change2LockNopay(fsm,...)
end

function BingoPassItemBaseState:IsAchieve()
    return false
end

return BingoPassItemBaseState