
HomeSceneNormalLobbyView = Clazz(BaseHomeSceneEntity,"HomeSceneNormalLobbyView")

function HomeSceneNormalLobbyView:OnEnter(fsm,previous,...)
    fsm:GetOwner():OnChange2NormalLobby(true,previous,...)
end

function HomeSceneNormalLobbyView:OnLeave(fsm)
    fsm:GetOwner():NormalLobbyExit()
end

function HomeSceneNormalLobbyView:GetSceneName()
    return "NormalHallScene"
end

function HomeSceneNormalLobbyView:IsNormalLobby()
    return true
end

function HomeSceneNormalLobbyView:IsLobby()
    return true
end

function HomeSceneNormalLobbyView:EnterHomeEntity(fsm)
    fsm:GetOwner():OnChange2NormalLobby(false)
end

function HomeSceneNormalLobbyView:Change2SelectCity(fsm)
    if fsm then
        self:ChangeState(fsm,"HomeSceneSelectCityView")
    end
end

function HomeSceneNormalLobbyView:Promotion(fsm)
    if fsm then
        fsm:GetOwner():OnNormalLobbyPromotion()
    end
end