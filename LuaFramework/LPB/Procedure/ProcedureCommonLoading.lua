

ProcedureCommonLoading = Clazz(BaseProcedure,"ProcedureCommonLoading")

function ProcedureCommonLoading:New()
    local o = {}
    setmetatable(o,{__index = ProcedureCommonLoading})
    return o
end

local RestartCommonLoading = function()

end

function ProcedureCommonLoading:OnEnter(fsm,lastName)
    
    SceneViewManager.SetCurrentSceneName("SceneLoading")
    local needReActive = false

    log.r(" Procedure SceneLoading!!!")
    --SDK.open_game()
    local game_ui = fun.find_gameObject_with_tag("NormalUiRoot")
    log.r(" Procedure find_gameObject_with_tag!!!")
    local ref = fun.get_component(game_ui,fun.REFER)
    log.r(" Procedure get_component!!!")
    local go = ref:Get("EnterGameLoadingView");
    log.r(" Procedure ref:Get(\"EnterGameLoadingView\")!!!")

    Facade.SendNotification(NotifyName.SkipLoadShowUI,ViewList.EnterGameLoadingView,go)
    if AppConst.IsInit then
        --ViewList.EnterGameLoadingView:Close()
        --ViewList.EnterGameLoadingView:ResetWorkFlowFinish()
        needReActive = true
    else
        AppConst.IsInit = true
    end
    if( not SceneViewManager.CheckViewIsCache(ViewList.WaitLoadingView.viewName))then 
        Facade.SendNotification(NotifyName.LoadUIToCache,ViewList.WaitLoadingView,function()
            Facade.SendNotification(NotifyName.ShowUI, ViewList.WaitLoadingView)
        end)
    end
    --if needReActive and go then
    --    fun.set_active(go,false)
    --    fun.set_active(go,true)
    --end
    --TODO 干嘛???????????
    -- AssetManager.load_sceneloading_common_res(function()
        
    -- end)
end

function ProcedureCommonLoading:OnLeave(fsm)
    
end

function ProcedureCommonLoading:ProcedureName()
    return "ProcedureCommonLoading"
end

function ProcedureCommonLoading:GetCurrentSceneName()
    return "CommonLoadingScene"
end