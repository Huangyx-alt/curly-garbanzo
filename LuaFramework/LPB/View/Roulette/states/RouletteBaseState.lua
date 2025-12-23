
local RouletteBaseState = Clazz(BaseFsmState,"RouletteBaseState")

function RouletteBaseState:PlayEnter(fsm)
end

function RouletteBaseState:Complete(fsm)
end

function RouletteBaseState:Spin(fsm)
end

function RouletteBaseState:Close(fsm)
end

function RouletteBaseState:ForceClose(fsm)
end

function RouletteBaseState:GoBack(fsm)
end

function RouletteBaseState:ServerReshone()
end

return RouletteBaseState