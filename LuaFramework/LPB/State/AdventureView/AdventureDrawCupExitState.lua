
AdventureDrawCupExitState = Clazz(BaseAdventureState,"AdventureDrawCupExitState")

function AdventureDrawCupExitState:OnEnter(fsm)
    fsm:GetOwner():PlayDrawCupExit()
end

function AdventureDrawCupExitState:OnLeave(fsm)
    
end

function AdventureDrawCupExitState:DoActionEnd(fsm)
    if fsm then
        fsm:GetOwner():ExitAdventure()
    end
end