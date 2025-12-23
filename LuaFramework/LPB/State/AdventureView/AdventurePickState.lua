
AdventurePickState = Clazz(BaseAdventureState,"AdventurePickState")

function AdventurePickState:OnEnter(fsm)

end

function AdventurePickState:OnLeave(fsm)

end

function AdventurePickState:DoPick(fsm,params)
    if fsm then
        self:ChangeState(fsm,"AdventurePickWaitState",params)
    end
end