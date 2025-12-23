
local BaseGamePassBaseState = Clazz(BaseFsmState,"BaseGamePassBaseState")

function BaseGamePassBaseState:PlayEnter(fsm)
end

function BaseGamePassBaseState:PlayExit(fsm)
end

function BaseGamePassBaseState:Complete(fsm)
end

function BaseGamePassBaseState:BaseGamePassBaseWatchAd(fsm,passItem)
end

function BaseGamePassBaseState:GemUnlockLevel(fsm,passItem)
end

function BaseGamePassBaseState:ClaimReward(fsm,passItem)
end

function BaseGamePassBaseState:Purchase(fsm)
end

function BaseGamePassBaseState:Expired(fsm)
    if fsm then
        self:ChangeState(fsm,"BaseGamePassBaseExpiredState")
    end
end

return BaseGamePassBaseState