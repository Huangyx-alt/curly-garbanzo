local BingoPassBaseState = require "View/Bingopass/states/BingoPassBaseState"
local BingoPassEnterState = Clazz(BingoPassBaseState,"BingoPassEnterState")

function BingoPassEnterState:OnEnter(fsm)
    fsm:GetOwner():PlayBingoPassEnter()
end

function BingoPassEnterState:OnLeave(fsm)
end

function BingoPassEnterState:Complete(fsm)
    if fsm then
        self:ChangeState(fsm,"BingoPassOriginalState")
    end
end
return BingoPassEnterState