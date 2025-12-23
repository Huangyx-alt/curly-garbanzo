local BingoPassBaseState = require "View/Bingopass/states/BingoPassBaseState"
local BingoPassOriginalState = Clazz(BingoPassBaseState,"BingoPassOriginalState")

function BingoPassOriginalState:OnEnter(fsm)
end

function BingoPassOriginalState:OnLeave(fsm)
end

function BingoPassOriginalState:PlayEnter(fsm)
    if fsm then
        self:ChangeState(fsm,"BingoPassEnterState")
    end
end

function BingoPassOriginalState:PlayExit(fsm)
    if fsm then
        self:ChangeState(fsm,"BingoPassExitState")
    end
end

function BingoPassOriginalState:GemUnlockLevel(fsm,passItem)
    if fsm then
        self:ChangeState(fsm,"BingoPassStiffState",1,passItem)
    end
end

function BingoPassOriginalState:BingoPassWatchAd(fsm,passItem)
    if fsm then
        self:ChangeState(fsm,"BingoPassStiffState",2,passItem)
    end
end

function BingoPassOriginalState:Purchase(fsm)
    if fsm then
        fsm:GetOwner():OnShowPurchaseView()
    end
end

function BingoPassOriginalState:ClaimReward(fsm,passItem)
    if fsm then
        self:ChangeState(fsm,"BingoPassStiffState",3,passItem)
    end
end

function BingoPassOriginalState:ClaimAllReward(fsm)
    if fsm then
        self:ChangeState(fsm,"BingoPassStiffState",4)
    end
end

return BingoPassOriginalState