
PiggySlotsGameExitState = Clazz(BasePiggySlotsGameState,"PiggySlotsGameExitState")

function PiggySlotsGameExitState:OnEnter(fsm)
    fsm:GetOwner():CloseSelfWithExitFunc()
end

function PiggySlotsGameExitState:OnLeave(fsm)
end


