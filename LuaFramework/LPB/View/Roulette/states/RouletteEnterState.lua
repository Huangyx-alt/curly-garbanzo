local RouletteBaseState  = require("View/Roulette/states/RouletteBaseState")
local RouletteEnterState = Clazz(RouletteBaseState,"RouletteEnterState")

function RouletteEnterState:OnEnter(fsm,previous,params)
    fsm:GetOwner():PlayRouletteEnter()
end


function RouletteEnterState:OnLeave(fsm)
end

function RouletteEnterState:Complete(fsm)
    if fsm then
        self:ChangeState(fsm,"RouletteOriginalState")
    end
end
return RouletteEnterState