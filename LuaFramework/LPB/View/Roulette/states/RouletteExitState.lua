local RouletteBaseState  = require("View/Roulette/states/RouletteBaseState")
local RouletteExitState = Clazz(RouletteBaseState,"RouletteExitState")

function RouletteExitState:OnEnter(fsm,previous,params)
    fsm:GetOwner():OnClose()
end

function RouletteExitState:OnLeave(fsm)
end

function RouletteExitState:GoBack(fsm)
    if fsm then
        self:ChangeState(fsm,"RouletteOriginalState")
    end
end
return RouletteExitState