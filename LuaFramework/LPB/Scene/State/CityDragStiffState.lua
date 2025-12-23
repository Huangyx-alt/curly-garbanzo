
CityDragStiffState = Clazz(CityDragBaseState,"CityDragStiffState")

CityDragStiffParams = {change2SelectCity = 1,change2NormalLobby = 2,selectCityPromotion = 3,clickEnterCity = 4}

function  CityDragStiffState:OnEnter(fsm,previous,...)
    local params1,params2,params3,params4 = select(1,...)
    if params1 == CityDragStiffParams.change2SelectCity then
        fsm:GetOwner():DoChange2SelectCity(params2,params3)
    elseif params1 == CityDragStiffParams.selectCityPromotion then
        fsm:GetOwner():DoSelectCityPromotion()
    elseif params1 == CityDragStiffParams.clickEnterCity then
        fsm:GetOwner():OnBtnBingoClick(params2,params3,params4) 
    end

    --[[ 进入honescene弹窗期间不应主动切状态
    self:StopTimer()
    self._timer = Invoke(function()
        self:Finish(fsm)
    end,5)
    --]]
end

function CityDragStiffState:OnLeave(fsm)
    self:StopTimer()
end

function CityDragStiffState:StopTimer()
    if self._timer then
        self._timer:Stop()
        self._timer = nil
    end
end

function CityDragStiffState:Finish(fsm)
    if fsm then
        self:ChangeState(fsm,"CityDragOriginalState")
    end
end


function CityDragStiffState:CanClickIcon()
    return false
end