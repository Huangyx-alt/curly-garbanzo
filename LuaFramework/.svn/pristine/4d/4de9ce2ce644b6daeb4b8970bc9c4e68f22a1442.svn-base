
CityTurnPageLeft = Clazz(CityDragBaseState,"CityTurnPageLeft")

function CityTurnPageLeft:OnDragComplete(fsm)
    self:ChangeState(fsm,"CityDragOriginalState")
end

function CityTurnPageLeft:OnEnter(fsm,previous,...)
    if fsm then
        local params = select(1,...)
        if params then
            fsm:GetOwner():OnTurnCityLeftCrossState()
        else
            fsm:GetOwner():OnTurnCityLeftState()
        end
    end
end

function CityTurnPageLeft:OnLeave(fsm)
end