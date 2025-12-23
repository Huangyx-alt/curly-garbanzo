local RouletteBaseState  = require("View/Roulette/states/RouletteBaseState")
local RouletteSpinState = Clazz(RouletteBaseState,"RouletteSpinState")

function RouletteSpinState:OnEnter(fsm)
    fsm:GetOwner():PlayButtonSpin()
    fsm:GetOwner():RequestSpinRoulette()
    self._timer = Invoke(function()
        if self then
            self:Complete(fsm)
        end
    end,10)
end

function RouletteSpinState:OnLeave(fsm)
    self:ServerReshone()
end

function RouletteSpinState:ServerReshone()
    if self._timer then
        self._timer:Stop()
        self._timer = nil
    end
end

function RouletteSpinState:Complete(fsm)
    if fsm then
        if fsm:GetOwner() then
            fsm:GetOwner():PlayButtonIdle()
        end
        self:ChangeState(fsm,"RouletteOriginalState")
    end
end

function RouletteSpinState:Close(fsm)
    --[[
    if fsm then
        fsm:GetOwner():CloseWarning()
    end
    --]]
end

function RouletteSpinState:ForceClose(fsm)
    --[[
    if fsm then
        self:ChangeState(fsm,"RouletteExitState")
    end
    --]]
end

return RouletteSpinState