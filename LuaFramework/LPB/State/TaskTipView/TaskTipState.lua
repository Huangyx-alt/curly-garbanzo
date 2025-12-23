
HallCityEnterState = Clazz(BaseHallCityState,"HallCityEnterState")

function HallCityEnterState:OnEnter(fsm)
    fsm:GetOwner():OnEnterHallCity()
end

function HallCityEnterState:OnLeave(fsm)

end

function HallCityEnterState:Finish(fsm)
    if fsm then
        self:ChangeState(fsm,"HallCityOriginalState")
    end
end