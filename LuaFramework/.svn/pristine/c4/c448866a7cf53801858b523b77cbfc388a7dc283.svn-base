
PiggySlotsGameTableInitState = Clazz(BasePiggySlotsGameState,"PiggySlotsGameTableInitState")

function PiggySlotsGameTableInitState:OnEnter(fsm,previouse,isReset)
    if isReset then
        fsm:GetOwner():ShowReelInit()
    end
end

function PiggySlotsGameTableInitState:OnLeave(fsm)
end

function PiggySlotsGameTableInitState:DoEnter(fsm)
    fsm:GetOwner():ShowReelInit()
end

function PiggySlotsGameTableInitState:DoFinishGameInit(fsm)
    if fsm then
        fsm:GetOwner():FinishInitSpinUpdateUI()
        self:ChangeState(fsm,"PiggySlotsGameWaitDoFreeSpinState")
    end
end