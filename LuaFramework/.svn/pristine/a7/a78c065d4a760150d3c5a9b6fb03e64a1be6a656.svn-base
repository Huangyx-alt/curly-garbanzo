local BaseGamePassBaseState = require "GamePlayShortPass/Base/States/BaseGamePassBaseState"
local BaseGamePassBaseOriginalState = Clazz(BaseGamePassBaseState,"BaseGamePassBaseOriginalState")

function BaseGamePassBaseOriginalState:OnEnter(fsm)
end

function BaseGamePassBaseOriginalState:OnLeave(fsm)
end

function BaseGamePassBaseOriginalState:PlayEnter(fsm)
    if fsm then
        self:ChangeState(fsm,"BaseGamePassBaseEnterState")
    end
end

function BaseGamePassBaseOriginalState:PlayExit(fsm)
    if fsm then
        self:ChangeState(fsm,"BaseGamePassBaseExitState")
    end
end

function BaseGamePassBaseOriginalState:GemUnlockLevel(fsm,passItem)
    if fsm then
        self:ChangeState(fsm,"BaseGamePassBaseStiffState",1,passItem)
    end
end

function BaseGamePassBaseOriginalState:BaseGamePassBaseWatchAd(fsm,passItem)
    if fsm then
        self:ChangeState(fsm,"BaseGamePassBaseStiffState",2,passItem)
    end
end

function BaseGamePassBaseOriginalState:Purchase(fsm)
    if fsm then
        fsm:GetOwner():OnShowPurchaseView()
    end
end

function BaseGamePassBaseOriginalState:ClaimReward(fsm,passItem)
    if fsm then
        self:ChangeState(fsm,"BaseGamePassBaseStiffState",3,passItem)
    end
end
return BaseGamePassBaseOriginalState