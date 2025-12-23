
HallCityStiffState = Clazz(BaseHallCityState,"HallCityStiffState")

function HallCityStiffState:OnEnter(fsm,previous,...)
    local params1,params2 = select(1,...)
    if params1 then
        self._timer = Invoke(function()
            self:FinishStiff(fsm)
        end,params2 or 3)
    end
end

function HallCityStiffState:OnLeave(fsm)
    if self._timer then
        self._timer:Stop()
        self._timer = nil
    end
end

function HallCityStiffState:FinishStiff(fsm)
    if fsm then
        self:ChangeState(fsm,"HallCityOriginalState")
    end
end

function HallCityStiffState:Finish(fsm)
    if fsm then
        self:ChangeState(fsm,"HallCityOriginalState")
    end
end