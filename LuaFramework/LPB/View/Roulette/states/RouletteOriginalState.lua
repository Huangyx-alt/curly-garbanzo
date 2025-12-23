local RouletteBaseState  = require("View/Roulette/states/RouletteBaseState")
local RouletteOriginalState = Clazz(RouletteBaseState,"RouletteOriginalState")

function RouletteOriginalState:OnEnter(fsm)
end

function RouletteOriginalState:OnLeave(fsm)
end

function RouletteOriginalState:PlayEnter(fsm,params)
    if fsm then
        self:ChangeState(fsm,"RouletteEnterState",params)
    end
end

function RouletteOriginalState:Spin(fsm)
    if fsm then
        self:ChangeState(fsm,"RouletteSpinState")
    end
end

function RouletteOriginalState:Close(fsm)
    if fsm then
        self:ChangeState(fsm,"RouletteExitState")
    end
end

return RouletteOriginalState
