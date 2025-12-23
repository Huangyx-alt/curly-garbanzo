
AdventureDrawCupState = Clazz(BaseAdventureState,"AdventureDrawCupState")

function AdventureDrawCupState:OnEnter(fsm,previous,...)
    fsm:GetOwner():PlayDrawCup(...)
end

function AdventureDrawCupState:OnLeave(fsm)
    
end

function AdventureDrawCupState:DoActionEnd(fsm)
    if fsm then
        self:ChangeState(fsm,"AdventureCollectState")
    end
end