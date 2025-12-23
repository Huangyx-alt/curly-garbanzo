
BaseHallCityState = Clazz(BaseFsmState,"BaseHallCityState")

function BaseHallCityState:EnterHallCity(fsm)
end

function BaseHallCityState:Finish(fsm)
end

function BaseHallCityState:Change2Stiff(fsm)
    
end

function BaseHallCityState:FinishStiff(fsm)
end

function BaseHallCityState:OnTurnCityLeft(fsm)

end

function BaseHallCityState:OnTurnCityRight(fsm)
    
end

function BaseHallCityState:OnCityClick(fsm,isMax,cityid)
end

function BaseHallCityState:OnFunctionIconClick(fsm,view,params,...)
    
end

function BaseHallCityState:OpenShopView(fsm)
end

function BaseHallCityState:OnAutoBingoClick(fsm)
    
end

function BaseHallCityState:CheckPopUpView(fsm)

end

function BaseHallCityState:TournamentStiff(fsm)
    return false
end

function BaseHallCityState:OnFunctionIconClickSpecial(fsm)
end