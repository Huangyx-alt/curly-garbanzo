
AdventureShakeState = Clazz(BaseAdventureState,"AdventureShakeState")

function AdventureShakeState:OnEnter(fsm)
    fsm:GetOwner():PlayShake()
end

function AdventureShakeState:OnLeave(fsm)

end

function AdventureShakeState:DoActionEnd(fsm)
    if fsm then
        self:ChangeState(fsm,"AdventurePickState")
    end
end
