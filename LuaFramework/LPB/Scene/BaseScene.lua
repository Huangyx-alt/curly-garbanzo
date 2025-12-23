
BaseScene = BaseView:New()
local this = BaseScene
this.__index = this

local curSceneView = nil

function GetCurrentSceneView()
    return curSceneView
end

function BaseScene:New(sceneName,viewName, atlasName)
    local o = {sceneName = sceneName,viewName = viewName, atlasName = atlasName}
    self.__index = self
    setmetatable(o,self)
    return o
end

function BaseScene:OnEnable_late()
    curSceneView = self
end

function BaseScene:IsSelectCity()
end

function BaseScene:IsNormalLobby()
end

function BaseScene:IsAutoLobby()
end

function BaseScene:IsCityOrLobby()
end

function BaseScene:IsFirstLogin()
end

function BaseScene:GetSceneName()
    return ""
end