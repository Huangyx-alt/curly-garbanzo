
CityTurnPageRight = Clazz(CityDragBaseState,"CityTurnPageRight")

function CityTurnPageRight:OnDragComplete(fsm)
    self:ChangeState(fsm,"CityDragOriginalState")
end

function CityTurnPageRight:OnEnter(fsm,previous,...)
    if fsm then
        local params = select(1,...)
        if params then
            fsm:GetOwner():OnTurnCityRightCrossState()
        else
            fsm:GetOwner():OnTurnCityRightState()
        end
    end
end

function CityTurnPageRight:OnLeave(fsm)
end