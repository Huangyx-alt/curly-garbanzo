local BaseGamePassBaseState = require "GamePlayShortPass/Base/States/BaseGamePassBaseState"
local BaseGamePassBaseEnterState = Clazz(BaseGamePassBaseState,"BaseGamePassBaseEnterState")

function BaseGamePassBaseEnterState:OnEnter(fsm)
    fsm:GetOwner():PlayBingoPassEnter()
end

function BaseGamePassBaseEnterState:OnLeave(fsm)
end

function BaseGamePassBaseEnterState:Complete(fsm)
    if fsm then
        self:ChangeState(fsm,"BaseGamePassBaseOriginalState")
    end
end
return BaseGamePassBaseEnterState