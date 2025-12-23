
local BingoPassBaseState = Clazz(BaseFsmState,"BingoPassBaseState")

function BingoPassBaseState:PlayEnter(fsm)
end

function BingoPassBaseState:PlayExit(fsm)
end

function BingoPassBaseState:Complete(fsm)
end

function BingoPassBaseState:BingoPassWatchAd(fsm,passItem)
end

function BingoPassBaseState:GemUnlockLevel(fsm,passItem)
end

function BingoPassBaseState:ClaimReward(fsm,passItem)
end

function BingoPassBaseState:Purchase(fsm)
end

function BingoPassBaseState:Expired(fsm)
    if fsm then
        self:ChangeState(fsm,"BingoPassExpiredState")
    end
end

function BingoPassBaseState:ClaimAllReward(fsm)
end

return BingoPassBaseState