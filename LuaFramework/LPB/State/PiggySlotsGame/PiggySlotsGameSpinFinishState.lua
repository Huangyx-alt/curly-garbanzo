
PiggySlotsGameSpinFinishState = Clazz(BasePiggySlotsGameState,"PiggySlotsGameSpinFinishState")

function PiggySlotsGameSpinFinishState:OnEnter(fsm)
    fsm:GetOwner():onElementMerge()
end

function PiggySlotsGameSpinFinishState:OnLeave(fsm)
    
end

