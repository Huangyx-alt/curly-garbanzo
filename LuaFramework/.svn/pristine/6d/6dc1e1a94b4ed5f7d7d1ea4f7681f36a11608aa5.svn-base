
HomeSceneAutoLobbyView = Clazz(BaseHomeSceneEntity,"HomeSceneAutoLobbyView")

function HomeSceneAutoLobbyView:OnEnter(fsm)
    fsm:GetOwner():OnChange2AutoLobby()
end

function HomeSceneAutoLobbyView:OnLeave(fsm)
    fsm:GetOwner():AutoLobbyExit()
end

function HomeSceneAutoLobbyView:GetSceneName()
    return "AutoHallScene"
end

function HomeSceneAutoLobbyView:IsAutoLobby()
    return true
end

function HomeSceneAutoLobbyView:IsLobby()
    return true
end

function HomeSceneAutoLobbyView:EnterHomeEntity(fsm)
    self:OnEnter(fsm)
end

function HomeSceneAutoLobbyView:Change2SelectCity(fsm)
    if fsm then
        self:ChangeState(fsm,"HomeSceneSelectCityView",true)
    end
end

function HomeSceneAutoLobbyView:Promotion(fsm)
    if fsm then
        fsm:GetOwner():OnAutoLobbyPromotion()
    end
end