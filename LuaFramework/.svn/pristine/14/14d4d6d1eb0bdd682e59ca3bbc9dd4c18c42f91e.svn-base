HallCityOriginalState = Clazz(BaseHallCityState,"HallCityOriginalState")

function HallCityOriginalState:OnEnter(fsm)

end

function HallCityOriginalState:OnLeave(fsm)

end

function HallCityOriginalState:EnterHallCity(fsm)
    if fsm then
        self:ChangeState(fsm,"HallCityEnterState")
    end
end

function HallCityOriginalState:Change2Stiff(fsm)
    if fsm then
        self:ChangeState(fsm,"HallCityStiffState")
    end
end

function HallCityOriginalState:OnTurnCityRight(fsm)
    if fsm then
        if fsm:GetOwner():IsDragLeftMax() then

        else
            self:ChangeState(fsm,"HallCityStiffState")
            fsm:GetOwner():OnTurnCityRight()
        end
    end
end

function HallCityOriginalState:OnTurnCityLeft(fsm)
    if fsm then
        if fsm:GetOwner():IsDragRightMax() then

        else
            self:ChangeState(fsm,"HallCityStiffState")
            fsm:GetOwner():OnTurnCityLeft()
        end
    end
end    

function HallCityOriginalState:OnCityClick(fsm,isMax,cityid)
    if fsm then
        fsm:GetOwner():OnCityClick(isMax,cityid)
    end
end

function HallCityOriginalState:OnAutoBingoClick(fsm)
    if fsm then
        fsm:GetOwner():OnAutoBingoClick()
    end
end

function HallCityOriginalState:OnFunctionIconClick(fsm,view,params,...)
    if fsm then
        fsm:GetOwner():OnFunctionIconShowView(view,params,...)
    end
end

function HallCityOriginalState:OnFunctionIconClickSpecial(fsm,view,params)
    if fsm then
        fsm:GetOwner():OnFunctionIconShowViewSpecial(view,params)
    end
end

function HallCityOriginalState:OpenShopView(fsm)
    if fsm then
        fsm:GetOwner():OnOpenShopView()
    end
end

function HallCityOriginalState:CheckPopUpView(fsm)
    if fsm then
        self:ChangeState(fsm,"HallCityStiffState")
    end
end

function HallCityOriginalState:TournamentStiff(fsm)
    if fsm then
        self:ChangeState(fsm,"HallCityStiffState",true,3)
        return true
    end
    return false
end