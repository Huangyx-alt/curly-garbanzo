
AdventureCollectState = Clazz(BaseAdventureState,"AdventureCollectState")

function AdventureCollectState:OnEnter(fsm)

end

function AdventureCollectState:OnLeave(fsm)
    
end

function AdventureCollectState:DoBtnClick(fsm)
    if fsm then
        self:ChangeState(fsm,"AdventureDrawCupExitState")
    end
end