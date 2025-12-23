
PiggySlotsGameEnterState = Clazz(BasePiggySlotsGameState,"PiggySlotsGameEnterState")

function PiggySlotsGameEnterState:OnLeave(fsm)
end


function PiggySlotsGameEnterState:DoEnter(fsm)
    if fsm then
        self:ChangeState(fsm,"PiggySlotsGameWaitDoFreeSpinState")
    end
end

