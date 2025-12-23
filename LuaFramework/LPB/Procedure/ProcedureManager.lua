require "Procedure/BaseProcedure"
require "Procedure/ProcedureInitialize"
require "Procedure/ProcedureCommonLoading"
require "Procedure/ProcedureLogin"
require "Procedure/ProcedureCityHome"
require "Procedure/ProcedureGameLoading"
require "Procedure/ProcedureSceneLoadingHome"
require "Procedure/ProcedureNormalGame"
require "Procedure/ProcedureHawaiiGame"
require "Procedure/ProcedureHangUp"
require "Procedure/ProcedureTest"
require "Procedure/ProcedureChristmasGame"
--require "Procedure/ProcedureFoodPartyGame"


ProcedureManager = {}

local this = ProcedureManager

local _currentState = nil
local _previousState = nil

function ProcedureManager:Start()
    this.SetProcedure(ProcedureCommonLoading:New())
    this:on_sence_enter()
  --[[   require("Logic/SDK") --暂时屏蔽SDK by LwangZg
    SDK.event_first_open() ]]
    print(" ====== ++++++++++++ ProcedureManager:Start() ")
end

function ProcedureManager:on_sence_enter(sceneName)
    if _currentState == nil then
        log.r("当前Procedure为nil")
        return
    end
    if _currentState:FsmState() == FsmState.Init then
        --log.r("==========================>>on_sence_enter " .. _currentState:ProcedureName())
        local preName = ""
        if _previousState ~= nil then
            _previousState:LeaveState(self)
            preName = _previousState.name
        end
        _currentState:EnterState(self,preName)
    elseif _currentState:FsmState() == FsmState.Enter_start 
    or _currentState:FsmState() == FsmState.Enter_end then
        log.r("错误，已进入当前Procedure！") 
    else
        log.r("错误，当前Procedure已离线！")
    end
end

function ProcedureManager.SetProcedure(procedure)
    if not procedure then
        return
    end
    
    if _currentState and _currentState:FsmState() ~= FsmState.Enter_end then
        log.r("错误，当前Procedure还没有启用，请不要频繁切换Procedure") 
    end
    if procedure.CheckProcedure and procedure:CheckProcedure() then
        --log.r("==========================>>SetProcedure " .. procedure:ProcedureName())
        _previousState = _currentState
        _currentState = procedure
        _currentState:InitState()
    elseif type(procedure) == "string" then
        local temProcedure = require(procedure)
        _previousState = _currentState
        _currentState = temProcedure:New()
        _currentState:InitState()
    end
end

function ProcedureManager.GetCurProcedure()
    return _currentState
end

function ProcedureManager.GetCamera()
    if _currentState then
        return _currentState:GetCamera()
    end
    return nil
end

function ProcedureManager.IsSceneHome()
    if _currentState then
        return _currentState:IsSceneHome()
    end
    return false
end

function ProcedureManager.IsSceneHall()
    if _currentState then
        return _currentState:IsSceneNormalHall()
    end
    return false
end

function ProcedureManager.IsSceneAutoHall()
    if _currentState then
        return _currentState:IsSceneAutoHall()
    end
    return false
end

function ProcedureManager.IsFirstLoginEnter()
    if _currentState then
        return _currentState:IsFirstLoginEnter()
    end
    return false
end

function ProcedureManager.GetCurrentSceneName()
    if _currentState then
        return _currentState:GetCurrentSceneName()
    end
    return "NoScene"
end

function ProcedureManager.ShowReadyView(cb)
    if _currentState and _currentState.ShowReadyView then
        _currentState:ShowReadyView(cb)
    else
        fun.SafeCall(cb, false)
    end
end

return this