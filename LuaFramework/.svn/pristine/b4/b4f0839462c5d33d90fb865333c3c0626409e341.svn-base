
HomeSceneSelectCityView = Clazz(BaseHomeSceneEntity,"HomeSceneSelectCityView")

function HomeSceneSelectCityView:OnEnter(fsm,previous,...)
    fsm:GetOwner():OnChange2SelectCity(previous,...)
end

function HomeSceneSelectCityView:OnLeave(fsm)
    self:FirstLoginExpired()
    fsm:GetOwner():SelectCityExit()
end

function HomeSceneSelectCityView:GetSceneName()
    return "DragCityScene"
end

function HomeSceneSelectCityView:CanDragCity()
    return true
end

function HomeSceneSelectCityView:IsSelectCity()
    return true
end

function HomeSceneSelectCityView:EnterHomeEntity(fsm)
    self:OnEnter(fsm)
end

function HomeSceneSelectCityView:Change2NormalLobby(fsm)
    if fsm then
        self:ChangeState(fsm,"HomeSceneNormalLobbyView")
    end

end

function HomeSceneSelectCityView:Change2AutoLobby(fsm)
    if fsm then
        self:ChangeState(fsm,"HomeSceneAutoLobbyView")
    end
end

function HomeSceneSelectCityView:Promotion(fsm)
    if fsm then
        fsm:GetOwner():OnSelectCityPromotion()
    end
end

function HomeSceneSelectCityView:ShowOrHideCityEntity(fsm,isActive)
    if fsm then
        fsm:GetOwner():OnShowOrHideCityEntity(isActive)
    end
end