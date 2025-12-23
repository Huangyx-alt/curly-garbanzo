
require "Logic/Fsm/BaseFsmState"

BaseHomeSceneEntity = Clazz(BaseFsmState,"BaseHomeSceneEntity")

local firstLogin = true

function BaseHomeSceneEntity:FirstLoginExpired()
    firstLogin = false
end

function BaseHomeSceneEntity:EnterHomeEntity(fsm)
    
end

function BaseHomeSceneEntity:Change2SelectCity(fsm)
end

function BaseHomeSceneEntity:Change2NormalLobby(fsm)
end

function BaseHomeSceneEntity:Change2AutoLobby(fsm)
end

function BaseHomeSceneEntity:Promotion(fsm)

end

function BaseHomeSceneEntity:ShowOrHideCityEntity(fsm,isActive)

end

function BaseHomeSceneEntity:CanDragCity()
    return false
end

function BaseHomeSceneEntity:IsSelectCity()
    return false
end

function BaseHomeSceneEntity:IsLobby()
    return false
end

function BaseHomeSceneEntity:IsNormalLobby()
    return false
end

function BaseHomeSceneEntity:IsAutoLobby()
    return false
end

function BaseHomeSceneEntity:IsFirstLogin()
    return firstLogin
end

function BaseHomeSceneEntity:GetSceneName()
    return "No Scene"
end

