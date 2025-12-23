
PiggySlotsGameSpinState = Clazz(BasePiggySlotsGameState,"PiggySlotsGameSpinState")

function PiggySlotsGameSpinState:OnEnter(fsm,previouse,spinStateName)
    self.spinStateName = spinStateName
    log.log("PiggySlotsGameSpinState 进入spin前的状态" , self.spinStateName)
    fsm:GetOwner():UpdateSpinTip()
    fsm:GetOwner():onStartRoll()
end

function PiggySlotsGameSpinState:OnLeave(fsm)
end

function PiggySlotsGameSpinState:DoStopRoll(fsm)
    if fsm then
        self:ChangeState(fsm,"PiggySlotsGameElementMergeState" , self.spinStateName)
    end
end

