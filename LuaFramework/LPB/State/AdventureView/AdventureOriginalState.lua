
AdventureOriginalState = Clazz(BaseAdventureState,"AdventureOriginalState")

function AdventureOriginalState:OnEnter(fsm)

end

function AdventureOriginalState:OnLeave(fsm)

end

function AdventureOriginalState:DoEnter(fsm)
    if fsm then
        self:ChangeState(fsm,"AdventureEnterState")
    end
end

function AdventureOriginalState:DoBtnClick(fsm)
    if fsm then
        self:ChangeState(fsm,"AdventureShakeState")
    end
end